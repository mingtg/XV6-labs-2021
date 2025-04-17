// Physical memory allocator, for user processes,
// kernel stacks, page-table pages,
// and pipe buffers. Allocates whole 4096-byte pages.

#include "types.h"
#include "param.h"
#include "memlayout.h"
#include "spinlock.h"
#include "riscv.h"
#include "defs.h"

void freerange(void *pa_start, void *pa_end);

extern char end[]; // first address after kernel.
                   // defined by kernel.ld.

struct run {
  struct run *next;
};

struct {
  struct spinlock lock;
  struct run *freelist;
} kmem;

#define NPAGE 32723

char reference[NPAGE];

int
getrefindex(void *pa){
  int index = ((char*)pa - (char*)PGROUNDUP((uint64)end)) / PGSIZE;
  return index;
}

int
getref(void *pa){
  return reference[getrefindex(pa)];
}


void
addref(char *tip, void *pa){
  reference[getrefindex(pa)]++;
}

void
subref(char *tip,void *pa){
  int index = getrefindex(pa);
  if(reference[index] == 0)
    return;
  reference[index]--;
}


void
kinit()
{
  initlock(&kmem.lock, "kmem");
  freerange(end, (void*)PHYSTOP);
}

void
freerange(void *pa_start, void *pa_end)
{
  char *p;
  p = (char*)PGROUNDUP((uint64)pa_start);
  printf("start ~ end:%p ~ %p\n", p, pa_end);
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE){
    /** 初始化ref_count  */
    reference[getrefindex(p)] = 0;
    kfree(p);
  }
}


// Free the page of physical memory pointed at by v,
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);

  r = (struct run*)pa;

  subref("kfree()", (void *) pa);
  int ref_count = getref(pa);
  if(ref_count == 0){
    //printf("!\n");
    memset(pa, 1, PGSIZE);
    // printf("r->ref_count after: %d\n",((struct run *)pa)->ref_count);
    // printf("----------------\n");
    r = (struct run*)pa;
    //r->ref_count = ref_count;
    acquire(&kmem.lock);
    r->next = kmem.freelist;
    kmem.freelist = r;
    release(&kmem.lock);

  }
                        
/*原文链接：https://blog.csdn.net/weixin_44465434/article/details/111566139*/
}

// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
  struct run *r;

  acquire(&kmem.lock);
  r = kmem.freelist;
  if(r)
    kmem.freelist = r->next;
  release(&kmem.lock);

  if(r){
    memset((char*)r, 5, PGSIZE); // fill with junk
    int index = getrefindex((void *)r);
    reference[index] = 1;
  }
  return (void*)r;
}

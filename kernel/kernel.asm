
kernel/kernel：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00009117          	auipc	sp,0x9
    80000004:	9e013103          	ld	sp,-1568(sp) # 800089e0 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	6ec050ef          	jal	ra,80005702 <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    8000001c:	1101                	addi	sp,sp,-32
    8000001e:	ec06                	sd	ra,24(sp)
    80000020:	e822                	sd	s0,16(sp)
    80000022:	e426                	sd	s1,8(sp)
    80000024:	e04a                	sd	s2,0(sp)
    80000026:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000028:	03451793          	slli	a5,a0,0x34
    8000002c:	ebb9                	bnez	a5,80000082 <kfree+0x66>
    8000002e:	84aa                	mv	s1,a0
    80000030:	00026797          	auipc	a5,0x26
    80000034:	21078793          	addi	a5,a5,528 # 80026240 <end>
    80000038:	04f56563          	bltu	a0,a5,80000082 <kfree+0x66>
    8000003c:	47c5                	li	a5,17
    8000003e:	07ee                	slli	a5,a5,0x1b
    80000040:	04f57163          	bgeu	a0,a5,80000082 <kfree+0x66>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000044:	6605                	lui	a2,0x1
    80000046:	4585                	li	a1,1
    80000048:	00000097          	auipc	ra,0x0
    8000004c:	132080e7          	jalr	306(ra) # 8000017a <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000050:	00009917          	auipc	s2,0x9
    80000054:	fe090913          	addi	s2,s2,-32 # 80009030 <kmem>
    80000058:	854a                	mv	a0,s2
    8000005a:	00006097          	auipc	ra,0x6
    8000005e:	08e080e7          	jalr	142(ra) # 800060e8 <acquire>
  r->next = kmem.freelist;
    80000062:	01893783          	ld	a5,24(s2)
    80000066:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000068:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006c:	854a                	mv	a0,s2
    8000006e:	00006097          	auipc	ra,0x6
    80000072:	12e080e7          	jalr	302(ra) # 8000619c <release>
}
    80000076:	60e2                	ld	ra,24(sp)
    80000078:	6442                	ld	s0,16(sp)
    8000007a:	64a2                	ld	s1,8(sp)
    8000007c:	6902                	ld	s2,0(sp)
    8000007e:	6105                	addi	sp,sp,32
    80000080:	8082                	ret
    panic("kfree");
    80000082:	00008517          	auipc	a0,0x8
    80000086:	f8e50513          	addi	a0,a0,-114 # 80008010 <etext+0x10>
    8000008a:	00006097          	auipc	ra,0x6
    8000008e:	b26080e7          	jalr	-1242(ra) # 80005bb0 <panic>

0000000080000092 <freerange>:
{
    80000092:	7179                	addi	sp,sp,-48
    80000094:	f406                	sd	ra,40(sp)
    80000096:	f022                	sd	s0,32(sp)
    80000098:	ec26                	sd	s1,24(sp)
    8000009a:	e84a                	sd	s2,16(sp)
    8000009c:	e44e                	sd	s3,8(sp)
    8000009e:	e052                	sd	s4,0(sp)
    800000a0:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    800000a2:	6785                	lui	a5,0x1
    800000a4:	fff78713          	addi	a4,a5,-1 # fff <_entry-0x7ffff001>
    800000a8:	00e504b3          	add	s1,a0,a4
    800000ac:	777d                	lui	a4,0xfffff
    800000ae:	8cf9                	and	s1,s1,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000b0:	94be                	add	s1,s1,a5
    800000b2:	0095ee63          	bltu	a1,s1,800000ce <freerange+0x3c>
    800000b6:	892e                	mv	s2,a1
    kfree(p);
    800000b8:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000ba:	6985                	lui	s3,0x1
    kfree(p);
    800000bc:	01448533          	add	a0,s1,s4
    800000c0:	00000097          	auipc	ra,0x0
    800000c4:	f5c080e7          	jalr	-164(ra) # 8000001c <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000c8:	94ce                	add	s1,s1,s3
    800000ca:	fe9979e3          	bgeu	s2,s1,800000bc <freerange+0x2a>
}
    800000ce:	70a2                	ld	ra,40(sp)
    800000d0:	7402                	ld	s0,32(sp)
    800000d2:	64e2                	ld	s1,24(sp)
    800000d4:	6942                	ld	s2,16(sp)
    800000d6:	69a2                	ld	s3,8(sp)
    800000d8:	6a02                	ld	s4,0(sp)
    800000da:	6145                	addi	sp,sp,48
    800000dc:	8082                	ret

00000000800000de <kinit>:
{
    800000de:	1141                	addi	sp,sp,-16
    800000e0:	e406                	sd	ra,8(sp)
    800000e2:	e022                	sd	s0,0(sp)
    800000e4:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    800000e6:	00008597          	auipc	a1,0x8
    800000ea:	f3258593          	addi	a1,a1,-206 # 80008018 <etext+0x18>
    800000ee:	00009517          	auipc	a0,0x9
    800000f2:	f4250513          	addi	a0,a0,-190 # 80009030 <kmem>
    800000f6:	00006097          	auipc	ra,0x6
    800000fa:	f62080e7          	jalr	-158(ra) # 80006058 <initlock>
  freerange(end, (void*)PHYSTOP);
    800000fe:	45c5                	li	a1,17
    80000100:	05ee                	slli	a1,a1,0x1b
    80000102:	00026517          	auipc	a0,0x26
    80000106:	13e50513          	addi	a0,a0,318 # 80026240 <end>
    8000010a:	00000097          	auipc	ra,0x0
    8000010e:	f88080e7          	jalr	-120(ra) # 80000092 <freerange>
}
    80000112:	60a2                	ld	ra,8(sp)
    80000114:	6402                	ld	s0,0(sp)
    80000116:	0141                	addi	sp,sp,16
    80000118:	8082                	ret

000000008000011a <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    8000011a:	1101                	addi	sp,sp,-32
    8000011c:	ec06                	sd	ra,24(sp)
    8000011e:	e822                	sd	s0,16(sp)
    80000120:	e426                	sd	s1,8(sp)
    80000122:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000124:	00009497          	auipc	s1,0x9
    80000128:	f0c48493          	addi	s1,s1,-244 # 80009030 <kmem>
    8000012c:	8526                	mv	a0,s1
    8000012e:	00006097          	auipc	ra,0x6
    80000132:	fba080e7          	jalr	-70(ra) # 800060e8 <acquire>
  r = kmem.freelist;
    80000136:	6c84                	ld	s1,24(s1)
  if(r)
    80000138:	c885                	beqz	s1,80000168 <kalloc+0x4e>
    kmem.freelist = r->next;
    8000013a:	609c                	ld	a5,0(s1)
    8000013c:	00009517          	auipc	a0,0x9
    80000140:	ef450513          	addi	a0,a0,-268 # 80009030 <kmem>
    80000144:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000146:	00006097          	auipc	ra,0x6
    8000014a:	056080e7          	jalr	86(ra) # 8000619c <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    8000014e:	6605                	lui	a2,0x1
    80000150:	4595                	li	a1,5
    80000152:	8526                	mv	a0,s1
    80000154:	00000097          	auipc	ra,0x0
    80000158:	026080e7          	jalr	38(ra) # 8000017a <memset>
  return (void*)r;
}
    8000015c:	8526                	mv	a0,s1
    8000015e:	60e2                	ld	ra,24(sp)
    80000160:	6442                	ld	s0,16(sp)
    80000162:	64a2                	ld	s1,8(sp)
    80000164:	6105                	addi	sp,sp,32
    80000166:	8082                	ret
  release(&kmem.lock);
    80000168:	00009517          	auipc	a0,0x9
    8000016c:	ec850513          	addi	a0,a0,-312 # 80009030 <kmem>
    80000170:	00006097          	auipc	ra,0x6
    80000174:	02c080e7          	jalr	44(ra) # 8000619c <release>
  if(r)
    80000178:	b7d5                	j	8000015c <kalloc+0x42>

000000008000017a <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    8000017a:	1141                	addi	sp,sp,-16
    8000017c:	e422                	sd	s0,8(sp)
    8000017e:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000180:	ca19                	beqz	a2,80000196 <memset+0x1c>
    80000182:	87aa                	mv	a5,a0
    80000184:	1602                	slli	a2,a2,0x20
    80000186:	9201                	srli	a2,a2,0x20
    80000188:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    8000018c:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000190:	0785                	addi	a5,a5,1
    80000192:	fee79de3          	bne	a5,a4,8000018c <memset+0x12>
  }
  return dst;
}
    80000196:	6422                	ld	s0,8(sp)
    80000198:	0141                	addi	sp,sp,16
    8000019a:	8082                	ret

000000008000019c <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    8000019c:	1141                	addi	sp,sp,-16
    8000019e:	e422                	sd	s0,8(sp)
    800001a0:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    800001a2:	ca05                	beqz	a2,800001d2 <memcmp+0x36>
    800001a4:	fff6069b          	addiw	a3,a2,-1 # fff <_entry-0x7ffff001>
    800001a8:	1682                	slli	a3,a3,0x20
    800001aa:	9281                	srli	a3,a3,0x20
    800001ac:	0685                	addi	a3,a3,1
    800001ae:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    800001b0:	00054783          	lbu	a5,0(a0)
    800001b4:	0005c703          	lbu	a4,0(a1)
    800001b8:	00e79863          	bne	a5,a4,800001c8 <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    800001bc:	0505                	addi	a0,a0,1
    800001be:	0585                	addi	a1,a1,1
  while(n-- > 0){
    800001c0:	fed518e3          	bne	a0,a3,800001b0 <memcmp+0x14>
  }

  return 0;
    800001c4:	4501                	li	a0,0
    800001c6:	a019                	j	800001cc <memcmp+0x30>
      return *s1 - *s2;
    800001c8:	40e7853b          	subw	a0,a5,a4
}
    800001cc:	6422                	ld	s0,8(sp)
    800001ce:	0141                	addi	sp,sp,16
    800001d0:	8082                	ret
  return 0;
    800001d2:	4501                	li	a0,0
    800001d4:	bfe5                	j	800001cc <memcmp+0x30>

00000000800001d6 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    800001d6:	1141                	addi	sp,sp,-16
    800001d8:	e422                	sd	s0,8(sp)
    800001da:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    800001dc:	c205                	beqz	a2,800001fc <memmove+0x26>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    800001de:	02a5e263          	bltu	a1,a0,80000202 <memmove+0x2c>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    800001e2:	1602                	slli	a2,a2,0x20
    800001e4:	9201                	srli	a2,a2,0x20
    800001e6:	00c587b3          	add	a5,a1,a2
{
    800001ea:	872a                	mv	a4,a0
      *d++ = *s++;
    800001ec:	0585                	addi	a1,a1,1
    800001ee:	0705                	addi	a4,a4,1 # fffffffffffff001 <end+0xffffffff7ffd8dc1>
    800001f0:	fff5c683          	lbu	a3,-1(a1)
    800001f4:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    800001f8:	fef59ae3          	bne	a1,a5,800001ec <memmove+0x16>

  return dst;
}
    800001fc:	6422                	ld	s0,8(sp)
    800001fe:	0141                	addi	sp,sp,16
    80000200:	8082                	ret
  if(s < d && s + n > d){
    80000202:	02061693          	slli	a3,a2,0x20
    80000206:	9281                	srli	a3,a3,0x20
    80000208:	00d58733          	add	a4,a1,a3
    8000020c:	fce57be3          	bgeu	a0,a4,800001e2 <memmove+0xc>
    d += n;
    80000210:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000212:	fff6079b          	addiw	a5,a2,-1
    80000216:	1782                	slli	a5,a5,0x20
    80000218:	9381                	srli	a5,a5,0x20
    8000021a:	fff7c793          	not	a5,a5
    8000021e:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000220:	177d                	addi	a4,a4,-1
    80000222:	16fd                	addi	a3,a3,-1
    80000224:	00074603          	lbu	a2,0(a4)
    80000228:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    8000022c:	fee79ae3          	bne	a5,a4,80000220 <memmove+0x4a>
    80000230:	b7f1                	j	800001fc <memmove+0x26>

0000000080000232 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000232:	1141                	addi	sp,sp,-16
    80000234:	e406                	sd	ra,8(sp)
    80000236:	e022                	sd	s0,0(sp)
    80000238:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    8000023a:	00000097          	auipc	ra,0x0
    8000023e:	f9c080e7          	jalr	-100(ra) # 800001d6 <memmove>
}
    80000242:	60a2                	ld	ra,8(sp)
    80000244:	6402                	ld	s0,0(sp)
    80000246:	0141                	addi	sp,sp,16
    80000248:	8082                	ret

000000008000024a <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    8000024a:	1141                	addi	sp,sp,-16
    8000024c:	e422                	sd	s0,8(sp)
    8000024e:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000250:	ce11                	beqz	a2,8000026c <strncmp+0x22>
    80000252:	00054783          	lbu	a5,0(a0)
    80000256:	cf89                	beqz	a5,80000270 <strncmp+0x26>
    80000258:	0005c703          	lbu	a4,0(a1)
    8000025c:	00f71a63          	bne	a4,a5,80000270 <strncmp+0x26>
    n--, p++, q++;
    80000260:	367d                	addiw	a2,a2,-1
    80000262:	0505                	addi	a0,a0,1
    80000264:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000266:	f675                	bnez	a2,80000252 <strncmp+0x8>
  if(n == 0)
    return 0;
    80000268:	4501                	li	a0,0
    8000026a:	a809                	j	8000027c <strncmp+0x32>
    8000026c:	4501                	li	a0,0
    8000026e:	a039                	j	8000027c <strncmp+0x32>
  if(n == 0)
    80000270:	ca09                	beqz	a2,80000282 <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    80000272:	00054503          	lbu	a0,0(a0)
    80000276:	0005c783          	lbu	a5,0(a1)
    8000027a:	9d1d                	subw	a0,a0,a5
}
    8000027c:	6422                	ld	s0,8(sp)
    8000027e:	0141                	addi	sp,sp,16
    80000280:	8082                	ret
    return 0;
    80000282:	4501                	li	a0,0
    80000284:	bfe5                	j	8000027c <strncmp+0x32>

0000000080000286 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000286:	1141                	addi	sp,sp,-16
    80000288:	e422                	sd	s0,8(sp)
    8000028a:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    8000028c:	872a                	mv	a4,a0
    8000028e:	8832                	mv	a6,a2
    80000290:	367d                	addiw	a2,a2,-1
    80000292:	01005963          	blez	a6,800002a4 <strncpy+0x1e>
    80000296:	0705                	addi	a4,a4,1
    80000298:	0005c783          	lbu	a5,0(a1)
    8000029c:	fef70fa3          	sb	a5,-1(a4)
    800002a0:	0585                	addi	a1,a1,1
    800002a2:	f7f5                	bnez	a5,8000028e <strncpy+0x8>
    ;
  while(n-- > 0)
    800002a4:	86ba                	mv	a3,a4
    800002a6:	00c05c63          	blez	a2,800002be <strncpy+0x38>
    *s++ = 0;
    800002aa:	0685                	addi	a3,a3,1
    800002ac:	fe068fa3          	sb	zero,-1(a3)
  while(n-- > 0)
    800002b0:	40d707bb          	subw	a5,a4,a3
    800002b4:	37fd                	addiw	a5,a5,-1
    800002b6:	010787bb          	addw	a5,a5,a6
    800002ba:	fef048e3          	bgtz	a5,800002aa <strncpy+0x24>
  return os;
}
    800002be:	6422                	ld	s0,8(sp)
    800002c0:	0141                	addi	sp,sp,16
    800002c2:	8082                	ret

00000000800002c4 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    800002c4:	1141                	addi	sp,sp,-16
    800002c6:	e422                	sd	s0,8(sp)
    800002c8:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    800002ca:	02c05363          	blez	a2,800002f0 <safestrcpy+0x2c>
    800002ce:	fff6069b          	addiw	a3,a2,-1
    800002d2:	1682                	slli	a3,a3,0x20
    800002d4:	9281                	srli	a3,a3,0x20
    800002d6:	96ae                	add	a3,a3,a1
    800002d8:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    800002da:	00d58963          	beq	a1,a3,800002ec <safestrcpy+0x28>
    800002de:	0585                	addi	a1,a1,1
    800002e0:	0785                	addi	a5,a5,1
    800002e2:	fff5c703          	lbu	a4,-1(a1)
    800002e6:	fee78fa3          	sb	a4,-1(a5)
    800002ea:	fb65                	bnez	a4,800002da <safestrcpy+0x16>
    ;
  *s = 0;
    800002ec:	00078023          	sb	zero,0(a5)
  return os;
}
    800002f0:	6422                	ld	s0,8(sp)
    800002f2:	0141                	addi	sp,sp,16
    800002f4:	8082                	ret

00000000800002f6 <strlen>:

int
strlen(const char *s)
{
    800002f6:	1141                	addi	sp,sp,-16
    800002f8:	e422                	sd	s0,8(sp)
    800002fa:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    800002fc:	00054783          	lbu	a5,0(a0)
    80000300:	cf91                	beqz	a5,8000031c <strlen+0x26>
    80000302:	0505                	addi	a0,a0,1
    80000304:	87aa                	mv	a5,a0
    80000306:	4685                	li	a3,1
    80000308:	9e89                	subw	a3,a3,a0
    8000030a:	00f6853b          	addw	a0,a3,a5
    8000030e:	0785                	addi	a5,a5,1
    80000310:	fff7c703          	lbu	a4,-1(a5)
    80000314:	fb7d                	bnez	a4,8000030a <strlen+0x14>
    ;
  return n;
}
    80000316:	6422                	ld	s0,8(sp)
    80000318:	0141                	addi	sp,sp,16
    8000031a:	8082                	ret
  for(n = 0; s[n]; n++)
    8000031c:	4501                	li	a0,0
    8000031e:	bfe5                	j	80000316 <strlen+0x20>

0000000080000320 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000320:	1141                	addi	sp,sp,-16
    80000322:	e406                	sd	ra,8(sp)
    80000324:	e022                	sd	s0,0(sp)
    80000326:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80000328:	00001097          	auipc	ra,0x1
    8000032c:	af0080e7          	jalr	-1296(ra) # 80000e18 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000330:	00009717          	auipc	a4,0x9
    80000334:	cd070713          	addi	a4,a4,-816 # 80009000 <started>
  if(cpuid() == 0){
    80000338:	c139                	beqz	a0,8000037e <main+0x5e>
    while(started == 0)
    8000033a:	431c                	lw	a5,0(a4)
    8000033c:	2781                	sext.w	a5,a5
    8000033e:	dff5                	beqz	a5,8000033a <main+0x1a>
      ;
    __sync_synchronize();
    80000340:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    80000344:	00001097          	auipc	ra,0x1
    80000348:	ad4080e7          	jalr	-1324(ra) # 80000e18 <cpuid>
    8000034c:	85aa                	mv	a1,a0
    8000034e:	00008517          	auipc	a0,0x8
    80000352:	cea50513          	addi	a0,a0,-790 # 80008038 <etext+0x38>
    80000356:	00006097          	auipc	ra,0x6
    8000035a:	8a4080e7          	jalr	-1884(ra) # 80005bfa <printf>
    kvminithart();    // turn on paging
    8000035e:	00000097          	auipc	ra,0x0
    80000362:	0d8080e7          	jalr	216(ra) # 80000436 <kvminithart>
    trapinithart();   // install kernel trap vector
    80000366:	00001097          	auipc	ra,0x1
    8000036a:	746080e7          	jalr	1862(ra) # 80001aac <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    8000036e:	00005097          	auipc	ra,0x5
    80000372:	d72080e7          	jalr	-654(ra) # 800050e0 <plicinithart>
  }

  scheduler();        
    80000376:	00001097          	auipc	ra,0x1
    8000037a:	ff2080e7          	jalr	-14(ra) # 80001368 <scheduler>
    consoleinit();
    8000037e:	00005097          	auipc	ra,0x5
    80000382:	742080e7          	jalr	1858(ra) # 80005ac0 <consoleinit>
    printfinit();
    80000386:	00006097          	auipc	ra,0x6
    8000038a:	a54080e7          	jalr	-1452(ra) # 80005dda <printfinit>
    printf("\n");
    8000038e:	00008517          	auipc	a0,0x8
    80000392:	cba50513          	addi	a0,a0,-838 # 80008048 <etext+0x48>
    80000396:	00006097          	auipc	ra,0x6
    8000039a:	864080e7          	jalr	-1948(ra) # 80005bfa <printf>
    printf("xv6 kernel is booting\n");
    8000039e:	00008517          	auipc	a0,0x8
    800003a2:	c8250513          	addi	a0,a0,-894 # 80008020 <etext+0x20>
    800003a6:	00006097          	auipc	ra,0x6
    800003aa:	854080e7          	jalr	-1964(ra) # 80005bfa <printf>
    printf("\n");
    800003ae:	00008517          	auipc	a0,0x8
    800003b2:	c9a50513          	addi	a0,a0,-870 # 80008048 <etext+0x48>
    800003b6:	00006097          	auipc	ra,0x6
    800003ba:	844080e7          	jalr	-1980(ra) # 80005bfa <printf>
    kinit();         // physical page allocator
    800003be:	00000097          	auipc	ra,0x0
    800003c2:	d20080e7          	jalr	-736(ra) # 800000de <kinit>
    kvminit();       // create kernel page table
    800003c6:	00000097          	auipc	ra,0x0
    800003ca:	322080e7          	jalr	802(ra) # 800006e8 <kvminit>
    kvminithart();   // turn on paging
    800003ce:	00000097          	auipc	ra,0x0
    800003d2:	068080e7          	jalr	104(ra) # 80000436 <kvminithart>
    procinit();      // process table
    800003d6:	00001097          	auipc	ra,0x1
    800003da:	992080e7          	jalr	-1646(ra) # 80000d68 <procinit>
    trapinit();      // trap vectors
    800003de:	00001097          	auipc	ra,0x1
    800003e2:	6a6080e7          	jalr	1702(ra) # 80001a84 <trapinit>
    trapinithart();  // install kernel trap vector
    800003e6:	00001097          	auipc	ra,0x1
    800003ea:	6c6080e7          	jalr	1734(ra) # 80001aac <trapinithart>
    plicinit();      // set up interrupt controller
    800003ee:	00005097          	auipc	ra,0x5
    800003f2:	cdc080e7          	jalr	-804(ra) # 800050ca <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    800003f6:	00005097          	auipc	ra,0x5
    800003fa:	cea080e7          	jalr	-790(ra) # 800050e0 <plicinithart>
    binit();         // buffer cache
    800003fe:	00002097          	auipc	ra,0x2
    80000402:	eaa080e7          	jalr	-342(ra) # 800022a8 <binit>
    iinit();         // inode table
    80000406:	00002097          	auipc	ra,0x2
    8000040a:	538080e7          	jalr	1336(ra) # 8000293e <iinit>
    fileinit();      // file table
    8000040e:	00003097          	auipc	ra,0x3
    80000412:	4ea080e7          	jalr	1258(ra) # 800038f8 <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000416:	00005097          	auipc	ra,0x5
    8000041a:	dea080e7          	jalr	-534(ra) # 80005200 <virtio_disk_init>
    userinit();      // first user process
    8000041e:	00001097          	auipc	ra,0x1
    80000422:	cfe080e7          	jalr	-770(ra) # 8000111c <userinit>
    __sync_synchronize();
    80000426:	0ff0000f          	fence
    started = 1;
    8000042a:	4785                	li	a5,1
    8000042c:	00009717          	auipc	a4,0x9
    80000430:	bcf72a23          	sw	a5,-1068(a4) # 80009000 <started>
    80000434:	b789                	j	80000376 <main+0x56>

0000000080000436 <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    80000436:	1141                	addi	sp,sp,-16
    80000438:	e422                	sd	s0,8(sp)
    8000043a:	0800                	addi	s0,sp,16
  w_satp(MAKE_SATP(kernel_pagetable));
    8000043c:	00009797          	auipc	a5,0x9
    80000440:	bcc7b783          	ld	a5,-1076(a5) # 80009008 <kernel_pagetable>
    80000444:	83b1                	srli	a5,a5,0xc
    80000446:	577d                	li	a4,-1
    80000448:	177e                	slli	a4,a4,0x3f
    8000044a:	8fd9                	or	a5,a5,a4
// supervisor address translation and protection;
// holds the address of the page table.
static inline void 
w_satp(uint64 x)
{
  asm volatile("csrw satp, %0" : : "r" (x));
    8000044c:	18079073          	csrw	satp,a5
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000450:	12000073          	sfence.vma
  sfence_vma();
}
    80000454:	6422                	ld	s0,8(sp)
    80000456:	0141                	addi	sp,sp,16
    80000458:	8082                	ret

000000008000045a <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    8000045a:	7139                	addi	sp,sp,-64
    8000045c:	fc06                	sd	ra,56(sp)
    8000045e:	f822                	sd	s0,48(sp)
    80000460:	f426                	sd	s1,40(sp)
    80000462:	f04a                	sd	s2,32(sp)
    80000464:	ec4e                	sd	s3,24(sp)
    80000466:	e852                	sd	s4,16(sp)
    80000468:	e456                	sd	s5,8(sp)
    8000046a:	e05a                	sd	s6,0(sp)
    8000046c:	0080                	addi	s0,sp,64
    8000046e:	84aa                	mv	s1,a0
    80000470:	89ae                	mv	s3,a1
    80000472:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    80000474:	57fd                	li	a5,-1
    80000476:	83e9                	srli	a5,a5,0x1a
    80000478:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    8000047a:	4b31                	li	s6,12
  if(va >= MAXVA)
    8000047c:	04b7f263          	bgeu	a5,a1,800004c0 <walk+0x66>
    panic("walk");
    80000480:	00008517          	auipc	a0,0x8
    80000484:	bd050513          	addi	a0,a0,-1072 # 80008050 <etext+0x50>
    80000488:	00005097          	auipc	ra,0x5
    8000048c:	728080e7          	jalr	1832(ra) # 80005bb0 <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    80000490:	060a8663          	beqz	s5,800004fc <walk+0xa2>
    80000494:	00000097          	auipc	ra,0x0
    80000498:	c86080e7          	jalr	-890(ra) # 8000011a <kalloc>
    8000049c:	84aa                	mv	s1,a0
    8000049e:	c529                	beqz	a0,800004e8 <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    800004a0:	6605                	lui	a2,0x1
    800004a2:	4581                	li	a1,0
    800004a4:	00000097          	auipc	ra,0x0
    800004a8:	cd6080e7          	jalr	-810(ra) # 8000017a <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    800004ac:	00c4d793          	srli	a5,s1,0xc
    800004b0:	07aa                	slli	a5,a5,0xa
    800004b2:	0017e793          	ori	a5,a5,1
    800004b6:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    800004ba:	3a5d                	addiw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ffd8db7>
    800004bc:	036a0063          	beq	s4,s6,800004dc <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    800004c0:	0149d933          	srl	s2,s3,s4
    800004c4:	1ff97913          	andi	s2,s2,511
    800004c8:	090e                	slli	s2,s2,0x3
    800004ca:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    800004cc:	00093483          	ld	s1,0(s2)
    800004d0:	0014f793          	andi	a5,s1,1
    800004d4:	dfd5                	beqz	a5,80000490 <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    800004d6:	80a9                	srli	s1,s1,0xa
    800004d8:	04b2                	slli	s1,s1,0xc
    800004da:	b7c5                	j	800004ba <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    800004dc:	00c9d513          	srli	a0,s3,0xc
    800004e0:	1ff57513          	andi	a0,a0,511
    800004e4:	050e                	slli	a0,a0,0x3
    800004e6:	9526                	add	a0,a0,s1
}
    800004e8:	70e2                	ld	ra,56(sp)
    800004ea:	7442                	ld	s0,48(sp)
    800004ec:	74a2                	ld	s1,40(sp)
    800004ee:	7902                	ld	s2,32(sp)
    800004f0:	69e2                	ld	s3,24(sp)
    800004f2:	6a42                	ld	s4,16(sp)
    800004f4:	6aa2                	ld	s5,8(sp)
    800004f6:	6b02                	ld	s6,0(sp)
    800004f8:	6121                	addi	sp,sp,64
    800004fa:	8082                	ret
        return 0;
    800004fc:	4501                	li	a0,0
    800004fe:	b7ed                	j	800004e8 <walk+0x8e>

0000000080000500 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    80000500:	57fd                	li	a5,-1
    80000502:	83e9                	srli	a5,a5,0x1a
    80000504:	00b7f463          	bgeu	a5,a1,8000050c <walkaddr+0xc>
    return 0;
    80000508:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    8000050a:	8082                	ret
{
    8000050c:	1141                	addi	sp,sp,-16
    8000050e:	e406                	sd	ra,8(sp)
    80000510:	e022                	sd	s0,0(sp)
    80000512:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80000514:	4601                	li	a2,0
    80000516:	00000097          	auipc	ra,0x0
    8000051a:	f44080e7          	jalr	-188(ra) # 8000045a <walk>
  if(pte == 0)
    8000051e:	c105                	beqz	a0,8000053e <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    80000520:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    80000522:	0117f693          	andi	a3,a5,17
    80000526:	4745                	li	a4,17
    return 0;
    80000528:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    8000052a:	00e68663          	beq	a3,a4,80000536 <walkaddr+0x36>
}
    8000052e:	60a2                	ld	ra,8(sp)
    80000530:	6402                	ld	s0,0(sp)
    80000532:	0141                	addi	sp,sp,16
    80000534:	8082                	ret
  pa = PTE2PA(*pte);
    80000536:	83a9                	srli	a5,a5,0xa
    80000538:	00c79513          	slli	a0,a5,0xc
  return pa;
    8000053c:	bfcd                	j	8000052e <walkaddr+0x2e>
    return 0;
    8000053e:	4501                	li	a0,0
    80000540:	b7fd                	j	8000052e <walkaddr+0x2e>

0000000080000542 <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    80000542:	715d                	addi	sp,sp,-80
    80000544:	e486                	sd	ra,72(sp)
    80000546:	e0a2                	sd	s0,64(sp)
    80000548:	fc26                	sd	s1,56(sp)
    8000054a:	f84a                	sd	s2,48(sp)
    8000054c:	f44e                	sd	s3,40(sp)
    8000054e:	f052                	sd	s4,32(sp)
    80000550:	ec56                	sd	s5,24(sp)
    80000552:	e85a                	sd	s6,16(sp)
    80000554:	e45e                	sd	s7,8(sp)
    80000556:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if(size == 0)
    80000558:	c639                	beqz	a2,800005a6 <mappages+0x64>
    8000055a:	8aaa                	mv	s5,a0
    8000055c:	8b3a                	mv	s6,a4
    panic("mappages: size");
  
  a = PGROUNDDOWN(va);
    8000055e:	777d                	lui	a4,0xfffff
    80000560:	00e5f7b3          	and	a5,a1,a4
  last = PGROUNDDOWN(va + size - 1);
    80000564:	fff58993          	addi	s3,a1,-1
    80000568:	99b2                	add	s3,s3,a2
    8000056a:	00e9f9b3          	and	s3,s3,a4
  a = PGROUNDDOWN(va);
    8000056e:	893e                	mv	s2,a5
    80000570:	40f68a33          	sub	s4,a3,a5
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    80000574:	6b85                	lui	s7,0x1
    80000576:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    8000057a:	4605                	li	a2,1
    8000057c:	85ca                	mv	a1,s2
    8000057e:	8556                	mv	a0,s5
    80000580:	00000097          	auipc	ra,0x0
    80000584:	eda080e7          	jalr	-294(ra) # 8000045a <walk>
    80000588:	cd1d                	beqz	a0,800005c6 <mappages+0x84>
    if(*pte & PTE_V)
    8000058a:	611c                	ld	a5,0(a0)
    8000058c:	8b85                	andi	a5,a5,1
    8000058e:	e785                	bnez	a5,800005b6 <mappages+0x74>
    *pte = PA2PTE(pa) | perm | PTE_V;
    80000590:	80b1                	srli	s1,s1,0xc
    80000592:	04aa                	slli	s1,s1,0xa
    80000594:	0164e4b3          	or	s1,s1,s6
    80000598:	0014e493          	ori	s1,s1,1
    8000059c:	e104                	sd	s1,0(a0)
    if(a == last)
    8000059e:	05390063          	beq	s2,s3,800005de <mappages+0x9c>
    a += PGSIZE;
    800005a2:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    800005a4:	bfc9                	j	80000576 <mappages+0x34>
    panic("mappages: size");
    800005a6:	00008517          	auipc	a0,0x8
    800005aa:	ab250513          	addi	a0,a0,-1358 # 80008058 <etext+0x58>
    800005ae:	00005097          	auipc	ra,0x5
    800005b2:	602080e7          	jalr	1538(ra) # 80005bb0 <panic>
      panic("mappages: remap");
    800005b6:	00008517          	auipc	a0,0x8
    800005ba:	ab250513          	addi	a0,a0,-1358 # 80008068 <etext+0x68>
    800005be:	00005097          	auipc	ra,0x5
    800005c2:	5f2080e7          	jalr	1522(ra) # 80005bb0 <panic>
      return -1;
    800005c6:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    800005c8:	60a6                	ld	ra,72(sp)
    800005ca:	6406                	ld	s0,64(sp)
    800005cc:	74e2                	ld	s1,56(sp)
    800005ce:	7942                	ld	s2,48(sp)
    800005d0:	79a2                	ld	s3,40(sp)
    800005d2:	7a02                	ld	s4,32(sp)
    800005d4:	6ae2                	ld	s5,24(sp)
    800005d6:	6b42                	ld	s6,16(sp)
    800005d8:	6ba2                	ld	s7,8(sp)
    800005da:	6161                	addi	sp,sp,80
    800005dc:	8082                	ret
  return 0;
    800005de:	4501                	li	a0,0
    800005e0:	b7e5                	j	800005c8 <mappages+0x86>

00000000800005e2 <kvmmap>:
{
    800005e2:	1141                	addi	sp,sp,-16
    800005e4:	e406                	sd	ra,8(sp)
    800005e6:	e022                	sd	s0,0(sp)
    800005e8:	0800                	addi	s0,sp,16
    800005ea:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    800005ec:	86b2                	mv	a3,a2
    800005ee:	863e                	mv	a2,a5
    800005f0:	00000097          	auipc	ra,0x0
    800005f4:	f52080e7          	jalr	-174(ra) # 80000542 <mappages>
    800005f8:	e509                	bnez	a0,80000602 <kvmmap+0x20>
}
    800005fa:	60a2                	ld	ra,8(sp)
    800005fc:	6402                	ld	s0,0(sp)
    800005fe:	0141                	addi	sp,sp,16
    80000600:	8082                	ret
    panic("kvmmap");
    80000602:	00008517          	auipc	a0,0x8
    80000606:	a7650513          	addi	a0,a0,-1418 # 80008078 <etext+0x78>
    8000060a:	00005097          	auipc	ra,0x5
    8000060e:	5a6080e7          	jalr	1446(ra) # 80005bb0 <panic>

0000000080000612 <kvmmake>:
{
    80000612:	1101                	addi	sp,sp,-32
    80000614:	ec06                	sd	ra,24(sp)
    80000616:	e822                	sd	s0,16(sp)
    80000618:	e426                	sd	s1,8(sp)
    8000061a:	e04a                	sd	s2,0(sp)
    8000061c:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    8000061e:	00000097          	auipc	ra,0x0
    80000622:	afc080e7          	jalr	-1284(ra) # 8000011a <kalloc>
    80000626:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    80000628:	6605                	lui	a2,0x1
    8000062a:	4581                	li	a1,0
    8000062c:	00000097          	auipc	ra,0x0
    80000630:	b4e080e7          	jalr	-1202(ra) # 8000017a <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    80000634:	4719                	li	a4,6
    80000636:	6685                	lui	a3,0x1
    80000638:	10000637          	lui	a2,0x10000
    8000063c:	100005b7          	lui	a1,0x10000
    80000640:	8526                	mv	a0,s1
    80000642:	00000097          	auipc	ra,0x0
    80000646:	fa0080e7          	jalr	-96(ra) # 800005e2 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    8000064a:	4719                	li	a4,6
    8000064c:	6685                	lui	a3,0x1
    8000064e:	10001637          	lui	a2,0x10001
    80000652:	100015b7          	lui	a1,0x10001
    80000656:	8526                	mv	a0,s1
    80000658:	00000097          	auipc	ra,0x0
    8000065c:	f8a080e7          	jalr	-118(ra) # 800005e2 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    80000660:	4719                	li	a4,6
    80000662:	004006b7          	lui	a3,0x400
    80000666:	0c000637          	lui	a2,0xc000
    8000066a:	0c0005b7          	lui	a1,0xc000
    8000066e:	8526                	mv	a0,s1
    80000670:	00000097          	auipc	ra,0x0
    80000674:	f72080e7          	jalr	-142(ra) # 800005e2 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    80000678:	00008917          	auipc	s2,0x8
    8000067c:	98890913          	addi	s2,s2,-1656 # 80008000 <etext>
    80000680:	4729                	li	a4,10
    80000682:	80008697          	auipc	a3,0x80008
    80000686:	97e68693          	addi	a3,a3,-1666 # 8000 <_entry-0x7fff8000>
    8000068a:	4605                	li	a2,1
    8000068c:	067e                	slli	a2,a2,0x1f
    8000068e:	85b2                	mv	a1,a2
    80000690:	8526                	mv	a0,s1
    80000692:	00000097          	auipc	ra,0x0
    80000696:	f50080e7          	jalr	-176(ra) # 800005e2 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    8000069a:	4719                	li	a4,6
    8000069c:	46c5                	li	a3,17
    8000069e:	06ee                	slli	a3,a3,0x1b
    800006a0:	412686b3          	sub	a3,a3,s2
    800006a4:	864a                	mv	a2,s2
    800006a6:	85ca                	mv	a1,s2
    800006a8:	8526                	mv	a0,s1
    800006aa:	00000097          	auipc	ra,0x0
    800006ae:	f38080e7          	jalr	-200(ra) # 800005e2 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800006b2:	4729                	li	a4,10
    800006b4:	6685                	lui	a3,0x1
    800006b6:	00007617          	auipc	a2,0x7
    800006ba:	94a60613          	addi	a2,a2,-1718 # 80007000 <_trampoline>
    800006be:	040005b7          	lui	a1,0x4000
    800006c2:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800006c4:	05b2                	slli	a1,a1,0xc
    800006c6:	8526                	mv	a0,s1
    800006c8:	00000097          	auipc	ra,0x0
    800006cc:	f1a080e7          	jalr	-230(ra) # 800005e2 <kvmmap>
  proc_mapstacks(kpgtbl);
    800006d0:	8526                	mv	a0,s1
    800006d2:	00000097          	auipc	ra,0x0
    800006d6:	600080e7          	jalr	1536(ra) # 80000cd2 <proc_mapstacks>
}
    800006da:	8526                	mv	a0,s1
    800006dc:	60e2                	ld	ra,24(sp)
    800006de:	6442                	ld	s0,16(sp)
    800006e0:	64a2                	ld	s1,8(sp)
    800006e2:	6902                	ld	s2,0(sp)
    800006e4:	6105                	addi	sp,sp,32
    800006e6:	8082                	ret

00000000800006e8 <kvminit>:
{
    800006e8:	1141                	addi	sp,sp,-16
    800006ea:	e406                	sd	ra,8(sp)
    800006ec:	e022                	sd	s0,0(sp)
    800006ee:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    800006f0:	00000097          	auipc	ra,0x0
    800006f4:	f22080e7          	jalr	-222(ra) # 80000612 <kvmmake>
    800006f8:	00009797          	auipc	a5,0x9
    800006fc:	90a7b823          	sd	a0,-1776(a5) # 80009008 <kernel_pagetable>
}
    80000700:	60a2                	ld	ra,8(sp)
    80000702:	6402                	ld	s0,0(sp)
    80000704:	0141                	addi	sp,sp,16
    80000706:	8082                	ret

0000000080000708 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    80000708:	715d                	addi	sp,sp,-80
    8000070a:	e486                	sd	ra,72(sp)
    8000070c:	e0a2                	sd	s0,64(sp)
    8000070e:	fc26                	sd	s1,56(sp)
    80000710:	f84a                	sd	s2,48(sp)
    80000712:	f44e                	sd	s3,40(sp)
    80000714:	f052                	sd	s4,32(sp)
    80000716:	ec56                	sd	s5,24(sp)
    80000718:	e85a                	sd	s6,16(sp)
    8000071a:	e45e                	sd	s7,8(sp)
    8000071c:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    8000071e:	03459793          	slli	a5,a1,0x34
    80000722:	e795                	bnez	a5,8000074e <uvmunmap+0x46>
    80000724:	8a2a                	mv	s4,a0
    80000726:	892e                	mv	s2,a1
    80000728:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    8000072a:	0632                	slli	a2,a2,0xc
    8000072c:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    80000730:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000732:	6b05                	lui	s6,0x1
    80000734:	0735e263          	bltu	a1,s3,80000798 <uvmunmap+0x90>
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
  }
}
    80000738:	60a6                	ld	ra,72(sp)
    8000073a:	6406                	ld	s0,64(sp)
    8000073c:	74e2                	ld	s1,56(sp)
    8000073e:	7942                	ld	s2,48(sp)
    80000740:	79a2                	ld	s3,40(sp)
    80000742:	7a02                	ld	s4,32(sp)
    80000744:	6ae2                	ld	s5,24(sp)
    80000746:	6b42                	ld	s6,16(sp)
    80000748:	6ba2                	ld	s7,8(sp)
    8000074a:	6161                	addi	sp,sp,80
    8000074c:	8082                	ret
    panic("uvmunmap: not aligned");
    8000074e:	00008517          	auipc	a0,0x8
    80000752:	93250513          	addi	a0,a0,-1742 # 80008080 <etext+0x80>
    80000756:	00005097          	auipc	ra,0x5
    8000075a:	45a080e7          	jalr	1114(ra) # 80005bb0 <panic>
      panic("uvmunmap: walk");
    8000075e:	00008517          	auipc	a0,0x8
    80000762:	93a50513          	addi	a0,a0,-1734 # 80008098 <etext+0x98>
    80000766:	00005097          	auipc	ra,0x5
    8000076a:	44a080e7          	jalr	1098(ra) # 80005bb0 <panic>
      panic("uvmunmap: not mapped");
    8000076e:	00008517          	auipc	a0,0x8
    80000772:	93a50513          	addi	a0,a0,-1734 # 800080a8 <etext+0xa8>
    80000776:	00005097          	auipc	ra,0x5
    8000077a:	43a080e7          	jalr	1082(ra) # 80005bb0 <panic>
      panic("uvmunmap: not a leaf");
    8000077e:	00008517          	auipc	a0,0x8
    80000782:	94250513          	addi	a0,a0,-1726 # 800080c0 <etext+0xc0>
    80000786:	00005097          	auipc	ra,0x5
    8000078a:	42a080e7          	jalr	1066(ra) # 80005bb0 <panic>
    *pte = 0;
    8000078e:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000792:	995a                	add	s2,s2,s6
    80000794:	fb3972e3          	bgeu	s2,s3,80000738 <uvmunmap+0x30>
    if((pte = walk(pagetable, a, 0)) == 0)
    80000798:	4601                	li	a2,0
    8000079a:	85ca                	mv	a1,s2
    8000079c:	8552                	mv	a0,s4
    8000079e:	00000097          	auipc	ra,0x0
    800007a2:	cbc080e7          	jalr	-836(ra) # 8000045a <walk>
    800007a6:	84aa                	mv	s1,a0
    800007a8:	d95d                	beqz	a0,8000075e <uvmunmap+0x56>
    if((*pte & PTE_V) == 0)
    800007aa:	6108                	ld	a0,0(a0)
    800007ac:	00157793          	andi	a5,a0,1
    800007b0:	dfdd                	beqz	a5,8000076e <uvmunmap+0x66>
    if(PTE_FLAGS(*pte) == PTE_V)
    800007b2:	3ff57793          	andi	a5,a0,1023
    800007b6:	fd7784e3          	beq	a5,s7,8000077e <uvmunmap+0x76>
    if(do_free){
    800007ba:	fc0a8ae3          	beqz	s5,8000078e <uvmunmap+0x86>
      uint64 pa = PTE2PA(*pte);
    800007be:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    800007c0:	0532                	slli	a0,a0,0xc
    800007c2:	00000097          	auipc	ra,0x0
    800007c6:	85a080e7          	jalr	-1958(ra) # 8000001c <kfree>
    800007ca:	b7d1                	j	8000078e <uvmunmap+0x86>

00000000800007cc <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    800007cc:	1101                	addi	sp,sp,-32
    800007ce:	ec06                	sd	ra,24(sp)
    800007d0:	e822                	sd	s0,16(sp)
    800007d2:	e426                	sd	s1,8(sp)
    800007d4:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    800007d6:	00000097          	auipc	ra,0x0
    800007da:	944080e7          	jalr	-1724(ra) # 8000011a <kalloc>
    800007de:	84aa                	mv	s1,a0
  if(pagetable == 0)
    800007e0:	c519                	beqz	a0,800007ee <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    800007e2:	6605                	lui	a2,0x1
    800007e4:	4581                	li	a1,0
    800007e6:	00000097          	auipc	ra,0x0
    800007ea:	994080e7          	jalr	-1644(ra) # 8000017a <memset>
  return pagetable;
}
    800007ee:	8526                	mv	a0,s1
    800007f0:	60e2                	ld	ra,24(sp)
    800007f2:	6442                	ld	s0,16(sp)
    800007f4:	64a2                	ld	s1,8(sp)
    800007f6:	6105                	addi	sp,sp,32
    800007f8:	8082                	ret

00000000800007fa <uvminit>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvminit(pagetable_t pagetable, uchar *src, uint sz)
{
    800007fa:	7179                	addi	sp,sp,-48
    800007fc:	f406                	sd	ra,40(sp)
    800007fe:	f022                	sd	s0,32(sp)
    80000800:	ec26                	sd	s1,24(sp)
    80000802:	e84a                	sd	s2,16(sp)
    80000804:	e44e                	sd	s3,8(sp)
    80000806:	e052                	sd	s4,0(sp)
    80000808:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    8000080a:	6785                	lui	a5,0x1
    8000080c:	04f67863          	bgeu	a2,a5,8000085c <uvminit+0x62>
    80000810:	8a2a                	mv	s4,a0
    80000812:	89ae                	mv	s3,a1
    80000814:	84b2                	mv	s1,a2
    panic("inituvm: more than a page");
  mem = kalloc();
    80000816:	00000097          	auipc	ra,0x0
    8000081a:	904080e7          	jalr	-1788(ra) # 8000011a <kalloc>
    8000081e:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    80000820:	6605                	lui	a2,0x1
    80000822:	4581                	li	a1,0
    80000824:	00000097          	auipc	ra,0x0
    80000828:	956080e7          	jalr	-1706(ra) # 8000017a <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    8000082c:	4779                	li	a4,30
    8000082e:	86ca                	mv	a3,s2
    80000830:	6605                	lui	a2,0x1
    80000832:	4581                	li	a1,0
    80000834:	8552                	mv	a0,s4
    80000836:	00000097          	auipc	ra,0x0
    8000083a:	d0c080e7          	jalr	-756(ra) # 80000542 <mappages>
  memmove(mem, src, sz);
    8000083e:	8626                	mv	a2,s1
    80000840:	85ce                	mv	a1,s3
    80000842:	854a                	mv	a0,s2
    80000844:	00000097          	auipc	ra,0x0
    80000848:	992080e7          	jalr	-1646(ra) # 800001d6 <memmove>
}
    8000084c:	70a2                	ld	ra,40(sp)
    8000084e:	7402                	ld	s0,32(sp)
    80000850:	64e2                	ld	s1,24(sp)
    80000852:	6942                	ld	s2,16(sp)
    80000854:	69a2                	ld	s3,8(sp)
    80000856:	6a02                	ld	s4,0(sp)
    80000858:	6145                	addi	sp,sp,48
    8000085a:	8082                	ret
    panic("inituvm: more than a page");
    8000085c:	00008517          	auipc	a0,0x8
    80000860:	87c50513          	addi	a0,a0,-1924 # 800080d8 <etext+0xd8>
    80000864:	00005097          	auipc	ra,0x5
    80000868:	34c080e7          	jalr	844(ra) # 80005bb0 <panic>

000000008000086c <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    8000086c:	1101                	addi	sp,sp,-32
    8000086e:	ec06                	sd	ra,24(sp)
    80000870:	e822                	sd	s0,16(sp)
    80000872:	e426                	sd	s1,8(sp)
    80000874:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    80000876:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    80000878:	00b67d63          	bgeu	a2,a1,80000892 <uvmdealloc+0x26>
    8000087c:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    8000087e:	6785                	lui	a5,0x1
    80000880:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80000882:	00f60733          	add	a4,a2,a5
    80000886:	76fd                	lui	a3,0xfffff
    80000888:	8f75                	and	a4,a4,a3
    8000088a:	97ae                	add	a5,a5,a1
    8000088c:	8ff5                	and	a5,a5,a3
    8000088e:	00f76863          	bltu	a4,a5,8000089e <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    80000892:	8526                	mv	a0,s1
    80000894:	60e2                	ld	ra,24(sp)
    80000896:	6442                	ld	s0,16(sp)
    80000898:	64a2                	ld	s1,8(sp)
    8000089a:	6105                	addi	sp,sp,32
    8000089c:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    8000089e:	8f99                	sub	a5,a5,a4
    800008a0:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800008a2:	4685                	li	a3,1
    800008a4:	0007861b          	sext.w	a2,a5
    800008a8:	85ba                	mv	a1,a4
    800008aa:	00000097          	auipc	ra,0x0
    800008ae:	e5e080e7          	jalr	-418(ra) # 80000708 <uvmunmap>
    800008b2:	b7c5                	j	80000892 <uvmdealloc+0x26>

00000000800008b4 <uvmalloc>:
  if(newsz < oldsz)
    800008b4:	0ab66163          	bltu	a2,a1,80000956 <uvmalloc+0xa2>
{
    800008b8:	7139                	addi	sp,sp,-64
    800008ba:	fc06                	sd	ra,56(sp)
    800008bc:	f822                	sd	s0,48(sp)
    800008be:	f426                	sd	s1,40(sp)
    800008c0:	f04a                	sd	s2,32(sp)
    800008c2:	ec4e                	sd	s3,24(sp)
    800008c4:	e852                	sd	s4,16(sp)
    800008c6:	e456                	sd	s5,8(sp)
    800008c8:	0080                	addi	s0,sp,64
    800008ca:	8aaa                	mv	s5,a0
    800008cc:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    800008ce:	6785                	lui	a5,0x1
    800008d0:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800008d2:	95be                	add	a1,a1,a5
    800008d4:	77fd                	lui	a5,0xfffff
    800008d6:	00f5f9b3          	and	s3,a1,a5
  for(a = oldsz; a < newsz; a += PGSIZE){
    800008da:	08c9f063          	bgeu	s3,a2,8000095a <uvmalloc+0xa6>
    800008de:	894e                	mv	s2,s3
    mem = kalloc();
    800008e0:	00000097          	auipc	ra,0x0
    800008e4:	83a080e7          	jalr	-1990(ra) # 8000011a <kalloc>
    800008e8:	84aa                	mv	s1,a0
    if(mem == 0){
    800008ea:	c51d                	beqz	a0,80000918 <uvmalloc+0x64>
    memset(mem, 0, PGSIZE);
    800008ec:	6605                	lui	a2,0x1
    800008ee:	4581                	li	a1,0
    800008f0:	00000097          	auipc	ra,0x0
    800008f4:	88a080e7          	jalr	-1910(ra) # 8000017a <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_W|PTE_X|PTE_R|PTE_U) != 0){
    800008f8:	4779                	li	a4,30
    800008fa:	86a6                	mv	a3,s1
    800008fc:	6605                	lui	a2,0x1
    800008fe:	85ca                	mv	a1,s2
    80000900:	8556                	mv	a0,s5
    80000902:	00000097          	auipc	ra,0x0
    80000906:	c40080e7          	jalr	-960(ra) # 80000542 <mappages>
    8000090a:	e905                	bnez	a0,8000093a <uvmalloc+0x86>
  for(a = oldsz; a < newsz; a += PGSIZE){
    8000090c:	6785                	lui	a5,0x1
    8000090e:	993e                	add	s2,s2,a5
    80000910:	fd4968e3          	bltu	s2,s4,800008e0 <uvmalloc+0x2c>
  return newsz;
    80000914:	8552                	mv	a0,s4
    80000916:	a809                	j	80000928 <uvmalloc+0x74>
      uvmdealloc(pagetable, a, oldsz);
    80000918:	864e                	mv	a2,s3
    8000091a:	85ca                	mv	a1,s2
    8000091c:	8556                	mv	a0,s5
    8000091e:	00000097          	auipc	ra,0x0
    80000922:	f4e080e7          	jalr	-178(ra) # 8000086c <uvmdealloc>
      return 0;
    80000926:	4501                	li	a0,0
}
    80000928:	70e2                	ld	ra,56(sp)
    8000092a:	7442                	ld	s0,48(sp)
    8000092c:	74a2                	ld	s1,40(sp)
    8000092e:	7902                	ld	s2,32(sp)
    80000930:	69e2                	ld	s3,24(sp)
    80000932:	6a42                	ld	s4,16(sp)
    80000934:	6aa2                	ld	s5,8(sp)
    80000936:	6121                	addi	sp,sp,64
    80000938:	8082                	ret
      kfree(mem);
    8000093a:	8526                	mv	a0,s1
    8000093c:	fffff097          	auipc	ra,0xfffff
    80000940:	6e0080e7          	jalr	1760(ra) # 8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80000944:	864e                	mv	a2,s3
    80000946:	85ca                	mv	a1,s2
    80000948:	8556                	mv	a0,s5
    8000094a:	00000097          	auipc	ra,0x0
    8000094e:	f22080e7          	jalr	-222(ra) # 8000086c <uvmdealloc>
      return 0;
    80000952:	4501                	li	a0,0
    80000954:	bfd1                	j	80000928 <uvmalloc+0x74>
    return oldsz;
    80000956:	852e                	mv	a0,a1
}
    80000958:	8082                	ret
  return newsz;
    8000095a:	8532                	mv	a0,a2
    8000095c:	b7f1                	j	80000928 <uvmalloc+0x74>

000000008000095e <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    8000095e:	7179                	addi	sp,sp,-48
    80000960:	f406                	sd	ra,40(sp)
    80000962:	f022                	sd	s0,32(sp)
    80000964:	ec26                	sd	s1,24(sp)
    80000966:	e84a                	sd	s2,16(sp)
    80000968:	e44e                	sd	s3,8(sp)
    8000096a:	e052                	sd	s4,0(sp)
    8000096c:	1800                	addi	s0,sp,48
    8000096e:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    80000970:	84aa                	mv	s1,a0
    80000972:	6905                	lui	s2,0x1
    80000974:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000976:	4985                	li	s3,1
    80000978:	a829                	j	80000992 <freewalk+0x34>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    8000097a:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    8000097c:	00c79513          	slli	a0,a5,0xc
    80000980:	00000097          	auipc	ra,0x0
    80000984:	fde080e7          	jalr	-34(ra) # 8000095e <freewalk>
      pagetable[i] = 0;
    80000988:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    8000098c:	04a1                	addi	s1,s1,8
    8000098e:	03248163          	beq	s1,s2,800009b0 <freewalk+0x52>
    pte_t pte = pagetable[i];
    80000992:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000994:	00f7f713          	andi	a4,a5,15
    80000998:	ff3701e3          	beq	a4,s3,8000097a <freewalk+0x1c>
    } else if(pte & PTE_V){
    8000099c:	8b85                	andi	a5,a5,1
    8000099e:	d7fd                	beqz	a5,8000098c <freewalk+0x2e>
      panic("freewalk: leaf");
    800009a0:	00007517          	auipc	a0,0x7
    800009a4:	75850513          	addi	a0,a0,1880 # 800080f8 <etext+0xf8>
    800009a8:	00005097          	auipc	ra,0x5
    800009ac:	208080e7          	jalr	520(ra) # 80005bb0 <panic>
    }
  }
  kfree((void*)pagetable);
    800009b0:	8552                	mv	a0,s4
    800009b2:	fffff097          	auipc	ra,0xfffff
    800009b6:	66a080e7          	jalr	1642(ra) # 8000001c <kfree>
}
    800009ba:	70a2                	ld	ra,40(sp)
    800009bc:	7402                	ld	s0,32(sp)
    800009be:	64e2                	ld	s1,24(sp)
    800009c0:	6942                	ld	s2,16(sp)
    800009c2:	69a2                	ld	s3,8(sp)
    800009c4:	6a02                	ld	s4,0(sp)
    800009c6:	6145                	addi	sp,sp,48
    800009c8:	8082                	ret

00000000800009ca <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    800009ca:	1101                	addi	sp,sp,-32
    800009cc:	ec06                	sd	ra,24(sp)
    800009ce:	e822                	sd	s0,16(sp)
    800009d0:	e426                	sd	s1,8(sp)
    800009d2:	1000                	addi	s0,sp,32
    800009d4:	84aa                	mv	s1,a0
  if(sz > 0)
    800009d6:	e999                	bnez	a1,800009ec <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    800009d8:	8526                	mv	a0,s1
    800009da:	00000097          	auipc	ra,0x0
    800009de:	f84080e7          	jalr	-124(ra) # 8000095e <freewalk>
}
    800009e2:	60e2                	ld	ra,24(sp)
    800009e4:	6442                	ld	s0,16(sp)
    800009e6:	64a2                	ld	s1,8(sp)
    800009e8:	6105                	addi	sp,sp,32
    800009ea:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    800009ec:	6785                	lui	a5,0x1
    800009ee:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800009f0:	95be                	add	a1,a1,a5
    800009f2:	4685                	li	a3,1
    800009f4:	00c5d613          	srli	a2,a1,0xc
    800009f8:	4581                	li	a1,0
    800009fa:	00000097          	auipc	ra,0x0
    800009fe:	d0e080e7          	jalr	-754(ra) # 80000708 <uvmunmap>
    80000a02:	bfd9                	j	800009d8 <uvmfree+0xe>

0000000080000a04 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80000a04:	c679                	beqz	a2,80000ad2 <uvmcopy+0xce>
{
    80000a06:	715d                	addi	sp,sp,-80
    80000a08:	e486                	sd	ra,72(sp)
    80000a0a:	e0a2                	sd	s0,64(sp)
    80000a0c:	fc26                	sd	s1,56(sp)
    80000a0e:	f84a                	sd	s2,48(sp)
    80000a10:	f44e                	sd	s3,40(sp)
    80000a12:	f052                	sd	s4,32(sp)
    80000a14:	ec56                	sd	s5,24(sp)
    80000a16:	e85a                	sd	s6,16(sp)
    80000a18:	e45e                	sd	s7,8(sp)
    80000a1a:	0880                	addi	s0,sp,80
    80000a1c:	8b2a                	mv	s6,a0
    80000a1e:	8aae                	mv	s5,a1
    80000a20:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80000a22:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    80000a24:	4601                	li	a2,0
    80000a26:	85ce                	mv	a1,s3
    80000a28:	855a                	mv	a0,s6
    80000a2a:	00000097          	auipc	ra,0x0
    80000a2e:	a30080e7          	jalr	-1488(ra) # 8000045a <walk>
    80000a32:	c531                	beqz	a0,80000a7e <uvmcopy+0x7a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    80000a34:	6118                	ld	a4,0(a0)
    80000a36:	00177793          	andi	a5,a4,1
    80000a3a:	cbb1                	beqz	a5,80000a8e <uvmcopy+0x8a>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    80000a3c:	00a75593          	srli	a1,a4,0xa
    80000a40:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80000a44:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    80000a48:	fffff097          	auipc	ra,0xfffff
    80000a4c:	6d2080e7          	jalr	1746(ra) # 8000011a <kalloc>
    80000a50:	892a                	mv	s2,a0
    80000a52:	c939                	beqz	a0,80000aa8 <uvmcopy+0xa4>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80000a54:	6605                	lui	a2,0x1
    80000a56:	85de                	mv	a1,s7
    80000a58:	fffff097          	auipc	ra,0xfffff
    80000a5c:	77e080e7          	jalr	1918(ra) # 800001d6 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80000a60:	8726                	mv	a4,s1
    80000a62:	86ca                	mv	a3,s2
    80000a64:	6605                	lui	a2,0x1
    80000a66:	85ce                	mv	a1,s3
    80000a68:	8556                	mv	a0,s5
    80000a6a:	00000097          	auipc	ra,0x0
    80000a6e:	ad8080e7          	jalr	-1320(ra) # 80000542 <mappages>
    80000a72:	e515                	bnez	a0,80000a9e <uvmcopy+0x9a>
  for(i = 0; i < sz; i += PGSIZE){
    80000a74:	6785                	lui	a5,0x1
    80000a76:	99be                	add	s3,s3,a5
    80000a78:	fb49e6e3          	bltu	s3,s4,80000a24 <uvmcopy+0x20>
    80000a7c:	a081                	j	80000abc <uvmcopy+0xb8>
      panic("uvmcopy: pte should exist");
    80000a7e:	00007517          	auipc	a0,0x7
    80000a82:	68a50513          	addi	a0,a0,1674 # 80008108 <etext+0x108>
    80000a86:	00005097          	auipc	ra,0x5
    80000a8a:	12a080e7          	jalr	298(ra) # 80005bb0 <panic>
      panic("uvmcopy: page not present");
    80000a8e:	00007517          	auipc	a0,0x7
    80000a92:	69a50513          	addi	a0,a0,1690 # 80008128 <etext+0x128>
    80000a96:	00005097          	auipc	ra,0x5
    80000a9a:	11a080e7          	jalr	282(ra) # 80005bb0 <panic>
      kfree(mem);
    80000a9e:	854a                	mv	a0,s2
    80000aa0:	fffff097          	auipc	ra,0xfffff
    80000aa4:	57c080e7          	jalr	1404(ra) # 8000001c <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000aa8:	4685                	li	a3,1
    80000aaa:	00c9d613          	srli	a2,s3,0xc
    80000aae:	4581                	li	a1,0
    80000ab0:	8556                	mv	a0,s5
    80000ab2:	00000097          	auipc	ra,0x0
    80000ab6:	c56080e7          	jalr	-938(ra) # 80000708 <uvmunmap>
  return -1;
    80000aba:	557d                	li	a0,-1
}
    80000abc:	60a6                	ld	ra,72(sp)
    80000abe:	6406                	ld	s0,64(sp)
    80000ac0:	74e2                	ld	s1,56(sp)
    80000ac2:	7942                	ld	s2,48(sp)
    80000ac4:	79a2                	ld	s3,40(sp)
    80000ac6:	7a02                	ld	s4,32(sp)
    80000ac8:	6ae2                	ld	s5,24(sp)
    80000aca:	6b42                	ld	s6,16(sp)
    80000acc:	6ba2                	ld	s7,8(sp)
    80000ace:	6161                	addi	sp,sp,80
    80000ad0:	8082                	ret
  return 0;
    80000ad2:	4501                	li	a0,0
}
    80000ad4:	8082                	ret

0000000080000ad6 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80000ad6:	1141                	addi	sp,sp,-16
    80000ad8:	e406                	sd	ra,8(sp)
    80000ada:	e022                	sd	s0,0(sp)
    80000adc:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80000ade:	4601                	li	a2,0
    80000ae0:	00000097          	auipc	ra,0x0
    80000ae4:	97a080e7          	jalr	-1670(ra) # 8000045a <walk>
  if(pte == 0)
    80000ae8:	c901                	beqz	a0,80000af8 <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80000aea:	611c                	ld	a5,0(a0)
    80000aec:	9bbd                	andi	a5,a5,-17
    80000aee:	e11c                	sd	a5,0(a0)
}
    80000af0:	60a2                	ld	ra,8(sp)
    80000af2:	6402                	ld	s0,0(sp)
    80000af4:	0141                	addi	sp,sp,16
    80000af6:	8082                	ret
    panic("uvmclear");
    80000af8:	00007517          	auipc	a0,0x7
    80000afc:	65050513          	addi	a0,a0,1616 # 80008148 <etext+0x148>
    80000b00:	00005097          	auipc	ra,0x5
    80000b04:	0b0080e7          	jalr	176(ra) # 80005bb0 <panic>

0000000080000b08 <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000b08:	c6bd                	beqz	a3,80000b76 <copyout+0x6e>
{
    80000b0a:	715d                	addi	sp,sp,-80
    80000b0c:	e486                	sd	ra,72(sp)
    80000b0e:	e0a2                	sd	s0,64(sp)
    80000b10:	fc26                	sd	s1,56(sp)
    80000b12:	f84a                	sd	s2,48(sp)
    80000b14:	f44e                	sd	s3,40(sp)
    80000b16:	f052                	sd	s4,32(sp)
    80000b18:	ec56                	sd	s5,24(sp)
    80000b1a:	e85a                	sd	s6,16(sp)
    80000b1c:	e45e                	sd	s7,8(sp)
    80000b1e:	e062                	sd	s8,0(sp)
    80000b20:	0880                	addi	s0,sp,80
    80000b22:	8b2a                	mv	s6,a0
    80000b24:	8c2e                	mv	s8,a1
    80000b26:	8a32                	mv	s4,a2
    80000b28:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80000b2a:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    80000b2c:	6a85                	lui	s5,0x1
    80000b2e:	a015                	j	80000b52 <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000b30:	9562                	add	a0,a0,s8
    80000b32:	0004861b          	sext.w	a2,s1
    80000b36:	85d2                	mv	a1,s4
    80000b38:	41250533          	sub	a0,a0,s2
    80000b3c:	fffff097          	auipc	ra,0xfffff
    80000b40:	69a080e7          	jalr	1690(ra) # 800001d6 <memmove>

    len -= n;
    80000b44:	409989b3          	sub	s3,s3,s1
    src += n;
    80000b48:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    80000b4a:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000b4e:	02098263          	beqz	s3,80000b72 <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    80000b52:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000b56:	85ca                	mv	a1,s2
    80000b58:	855a                	mv	a0,s6
    80000b5a:	00000097          	auipc	ra,0x0
    80000b5e:	9a6080e7          	jalr	-1626(ra) # 80000500 <walkaddr>
    if(pa0 == 0)
    80000b62:	cd01                	beqz	a0,80000b7a <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    80000b64:	418904b3          	sub	s1,s2,s8
    80000b68:	94d6                	add	s1,s1,s5
    80000b6a:	fc99f3e3          	bgeu	s3,s1,80000b30 <copyout+0x28>
    80000b6e:	84ce                	mv	s1,s3
    80000b70:	b7c1                	j	80000b30 <copyout+0x28>
  }
  return 0;
    80000b72:	4501                	li	a0,0
    80000b74:	a021                	j	80000b7c <copyout+0x74>
    80000b76:	4501                	li	a0,0
}
    80000b78:	8082                	ret
      return -1;
    80000b7a:	557d                	li	a0,-1
}
    80000b7c:	60a6                	ld	ra,72(sp)
    80000b7e:	6406                	ld	s0,64(sp)
    80000b80:	74e2                	ld	s1,56(sp)
    80000b82:	7942                	ld	s2,48(sp)
    80000b84:	79a2                	ld	s3,40(sp)
    80000b86:	7a02                	ld	s4,32(sp)
    80000b88:	6ae2                	ld	s5,24(sp)
    80000b8a:	6b42                	ld	s6,16(sp)
    80000b8c:	6ba2                	ld	s7,8(sp)
    80000b8e:	6c02                	ld	s8,0(sp)
    80000b90:	6161                	addi	sp,sp,80
    80000b92:	8082                	ret

0000000080000b94 <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000b94:	caa5                	beqz	a3,80000c04 <copyin+0x70>
{
    80000b96:	715d                	addi	sp,sp,-80
    80000b98:	e486                	sd	ra,72(sp)
    80000b9a:	e0a2                	sd	s0,64(sp)
    80000b9c:	fc26                	sd	s1,56(sp)
    80000b9e:	f84a                	sd	s2,48(sp)
    80000ba0:	f44e                	sd	s3,40(sp)
    80000ba2:	f052                	sd	s4,32(sp)
    80000ba4:	ec56                	sd	s5,24(sp)
    80000ba6:	e85a                	sd	s6,16(sp)
    80000ba8:	e45e                	sd	s7,8(sp)
    80000baa:	e062                	sd	s8,0(sp)
    80000bac:	0880                	addi	s0,sp,80
    80000bae:	8b2a                	mv	s6,a0
    80000bb0:	8a2e                	mv	s4,a1
    80000bb2:	8c32                	mv	s8,a2
    80000bb4:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000bb6:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000bb8:	6a85                	lui	s5,0x1
    80000bba:	a01d                	j	80000be0 <copyin+0x4c>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000bbc:	018505b3          	add	a1,a0,s8
    80000bc0:	0004861b          	sext.w	a2,s1
    80000bc4:	412585b3          	sub	a1,a1,s2
    80000bc8:	8552                	mv	a0,s4
    80000bca:	fffff097          	auipc	ra,0xfffff
    80000bce:	60c080e7          	jalr	1548(ra) # 800001d6 <memmove>

    len -= n;
    80000bd2:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000bd6:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000bd8:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000bdc:	02098263          	beqz	s3,80000c00 <copyin+0x6c>
    va0 = PGROUNDDOWN(srcva);
    80000be0:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000be4:	85ca                	mv	a1,s2
    80000be6:	855a                	mv	a0,s6
    80000be8:	00000097          	auipc	ra,0x0
    80000bec:	918080e7          	jalr	-1768(ra) # 80000500 <walkaddr>
    if(pa0 == 0)
    80000bf0:	cd01                	beqz	a0,80000c08 <copyin+0x74>
    n = PGSIZE - (srcva - va0);
    80000bf2:	418904b3          	sub	s1,s2,s8
    80000bf6:	94d6                	add	s1,s1,s5
    80000bf8:	fc99f2e3          	bgeu	s3,s1,80000bbc <copyin+0x28>
    80000bfc:	84ce                	mv	s1,s3
    80000bfe:	bf7d                	j	80000bbc <copyin+0x28>
  }
  return 0;
    80000c00:	4501                	li	a0,0
    80000c02:	a021                	j	80000c0a <copyin+0x76>
    80000c04:	4501                	li	a0,0
}
    80000c06:	8082                	ret
      return -1;
    80000c08:	557d                	li	a0,-1
}
    80000c0a:	60a6                	ld	ra,72(sp)
    80000c0c:	6406                	ld	s0,64(sp)
    80000c0e:	74e2                	ld	s1,56(sp)
    80000c10:	7942                	ld	s2,48(sp)
    80000c12:	79a2                	ld	s3,40(sp)
    80000c14:	7a02                	ld	s4,32(sp)
    80000c16:	6ae2                	ld	s5,24(sp)
    80000c18:	6b42                	ld	s6,16(sp)
    80000c1a:	6ba2                	ld	s7,8(sp)
    80000c1c:	6c02                	ld	s8,0(sp)
    80000c1e:	6161                	addi	sp,sp,80
    80000c20:	8082                	ret

0000000080000c22 <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80000c22:	c2dd                	beqz	a3,80000cc8 <copyinstr+0xa6>
{
    80000c24:	715d                	addi	sp,sp,-80
    80000c26:	e486                	sd	ra,72(sp)
    80000c28:	e0a2                	sd	s0,64(sp)
    80000c2a:	fc26                	sd	s1,56(sp)
    80000c2c:	f84a                	sd	s2,48(sp)
    80000c2e:	f44e                	sd	s3,40(sp)
    80000c30:	f052                	sd	s4,32(sp)
    80000c32:	ec56                	sd	s5,24(sp)
    80000c34:	e85a                	sd	s6,16(sp)
    80000c36:	e45e                	sd	s7,8(sp)
    80000c38:	0880                	addi	s0,sp,80
    80000c3a:	8a2a                	mv	s4,a0
    80000c3c:	8b2e                	mv	s6,a1
    80000c3e:	8bb2                	mv	s7,a2
    80000c40:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    80000c42:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000c44:	6985                	lui	s3,0x1
    80000c46:	a02d                	j	80000c70 <copyinstr+0x4e>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000c48:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000c4c:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000c4e:	37fd                	addiw	a5,a5,-1
    80000c50:	0007851b          	sext.w	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000c54:	60a6                	ld	ra,72(sp)
    80000c56:	6406                	ld	s0,64(sp)
    80000c58:	74e2                	ld	s1,56(sp)
    80000c5a:	7942                	ld	s2,48(sp)
    80000c5c:	79a2                	ld	s3,40(sp)
    80000c5e:	7a02                	ld	s4,32(sp)
    80000c60:	6ae2                	ld	s5,24(sp)
    80000c62:	6b42                	ld	s6,16(sp)
    80000c64:	6ba2                	ld	s7,8(sp)
    80000c66:	6161                	addi	sp,sp,80
    80000c68:	8082                	ret
    srcva = va0 + PGSIZE;
    80000c6a:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    80000c6e:	c8a9                	beqz	s1,80000cc0 <copyinstr+0x9e>
    va0 = PGROUNDDOWN(srcva);
    80000c70:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000c74:	85ca                	mv	a1,s2
    80000c76:	8552                	mv	a0,s4
    80000c78:	00000097          	auipc	ra,0x0
    80000c7c:	888080e7          	jalr	-1912(ra) # 80000500 <walkaddr>
    if(pa0 == 0)
    80000c80:	c131                	beqz	a0,80000cc4 <copyinstr+0xa2>
    n = PGSIZE - (srcva - va0);
    80000c82:	417906b3          	sub	a3,s2,s7
    80000c86:	96ce                	add	a3,a3,s3
    80000c88:	00d4f363          	bgeu	s1,a3,80000c8e <copyinstr+0x6c>
    80000c8c:	86a6                	mv	a3,s1
    char *p = (char *) (pa0 + (srcva - va0));
    80000c8e:	955e                	add	a0,a0,s7
    80000c90:	41250533          	sub	a0,a0,s2
    while(n > 0){
    80000c94:	daf9                	beqz	a3,80000c6a <copyinstr+0x48>
    80000c96:	87da                	mv	a5,s6
      if(*p == '\0'){
    80000c98:	41650633          	sub	a2,a0,s6
    80000c9c:	fff48593          	addi	a1,s1,-1
    80000ca0:	95da                	add	a1,a1,s6
    while(n > 0){
    80000ca2:	96da                	add	a3,a3,s6
      if(*p == '\0'){
    80000ca4:	00f60733          	add	a4,a2,a5
    80000ca8:	00074703          	lbu	a4,0(a4) # fffffffffffff000 <end+0xffffffff7ffd8dc0>
    80000cac:	df51                	beqz	a4,80000c48 <copyinstr+0x26>
        *dst = *p;
    80000cae:	00e78023          	sb	a4,0(a5)
      --max;
    80000cb2:	40f584b3          	sub	s1,a1,a5
      dst++;
    80000cb6:	0785                	addi	a5,a5,1
    while(n > 0){
    80000cb8:	fed796e3          	bne	a5,a3,80000ca4 <copyinstr+0x82>
      dst++;
    80000cbc:	8b3e                	mv	s6,a5
    80000cbe:	b775                	j	80000c6a <copyinstr+0x48>
    80000cc0:	4781                	li	a5,0
    80000cc2:	b771                	j	80000c4e <copyinstr+0x2c>
      return -1;
    80000cc4:	557d                	li	a0,-1
    80000cc6:	b779                	j	80000c54 <copyinstr+0x32>
  int got_null = 0;
    80000cc8:	4781                	li	a5,0
  if(got_null){
    80000cca:	37fd                	addiw	a5,a5,-1
    80000ccc:	0007851b          	sext.w	a0,a5
}
    80000cd0:	8082                	ret

0000000080000cd2 <proc_mapstacks>:

// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl) {
    80000cd2:	7139                	addi	sp,sp,-64
    80000cd4:	fc06                	sd	ra,56(sp)
    80000cd6:	f822                	sd	s0,48(sp)
    80000cd8:	f426                	sd	s1,40(sp)
    80000cda:	f04a                	sd	s2,32(sp)
    80000cdc:	ec4e                	sd	s3,24(sp)
    80000cde:	e852                	sd	s4,16(sp)
    80000ce0:	e456                	sd	s5,8(sp)
    80000ce2:	e05a                	sd	s6,0(sp)
    80000ce4:	0080                	addi	s0,sp,64
    80000ce6:	89aa                	mv	s3,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000ce8:	00008497          	auipc	s1,0x8
    80000cec:	79848493          	addi	s1,s1,1944 # 80009480 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000cf0:	8b26                	mv	s6,s1
    80000cf2:	00007a97          	auipc	s5,0x7
    80000cf6:	30ea8a93          	addi	s5,s5,782 # 80008000 <etext>
    80000cfa:	04000937          	lui	s2,0x4000
    80000cfe:	197d                	addi	s2,s2,-1 # 3ffffff <_entry-0x7c000001>
    80000d00:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d02:	0000ea17          	auipc	s4,0xe
    80000d06:	77ea0a13          	addi	s4,s4,1918 # 8000f480 <tickslock>
    char *pa = kalloc();
    80000d0a:	fffff097          	auipc	ra,0xfffff
    80000d0e:	410080e7          	jalr	1040(ra) # 8000011a <kalloc>
    80000d12:	862a                	mv	a2,a0
    if(pa == 0)
    80000d14:	c131                	beqz	a0,80000d58 <proc_mapstacks+0x86>
    uint64 va = KSTACK((int) (p - proc));
    80000d16:	416485b3          	sub	a1,s1,s6
    80000d1a:	859d                	srai	a1,a1,0x7
    80000d1c:	000ab783          	ld	a5,0(s5)
    80000d20:	02f585b3          	mul	a1,a1,a5
    80000d24:	2585                	addiw	a1,a1,1
    80000d26:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000d2a:	4719                	li	a4,6
    80000d2c:	6685                	lui	a3,0x1
    80000d2e:	40b905b3          	sub	a1,s2,a1
    80000d32:	854e                	mv	a0,s3
    80000d34:	00000097          	auipc	ra,0x0
    80000d38:	8ae080e7          	jalr	-1874(ra) # 800005e2 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d3c:	18048493          	addi	s1,s1,384
    80000d40:	fd4495e3          	bne	s1,s4,80000d0a <proc_mapstacks+0x38>
  }
}
    80000d44:	70e2                	ld	ra,56(sp)
    80000d46:	7442                	ld	s0,48(sp)
    80000d48:	74a2                	ld	s1,40(sp)
    80000d4a:	7902                	ld	s2,32(sp)
    80000d4c:	69e2                	ld	s3,24(sp)
    80000d4e:	6a42                	ld	s4,16(sp)
    80000d50:	6aa2                	ld	s5,8(sp)
    80000d52:	6b02                	ld	s6,0(sp)
    80000d54:	6121                	addi	sp,sp,64
    80000d56:	8082                	ret
      panic("kalloc");
    80000d58:	00007517          	auipc	a0,0x7
    80000d5c:	40050513          	addi	a0,a0,1024 # 80008158 <etext+0x158>
    80000d60:	00005097          	auipc	ra,0x5
    80000d64:	e50080e7          	jalr	-432(ra) # 80005bb0 <panic>

0000000080000d68 <procinit>:

// initialize the proc table at boot time.
void
procinit(void)
{
    80000d68:	7139                	addi	sp,sp,-64
    80000d6a:	fc06                	sd	ra,56(sp)
    80000d6c:	f822                	sd	s0,48(sp)
    80000d6e:	f426                	sd	s1,40(sp)
    80000d70:	f04a                	sd	s2,32(sp)
    80000d72:	ec4e                	sd	s3,24(sp)
    80000d74:	e852                	sd	s4,16(sp)
    80000d76:	e456                	sd	s5,8(sp)
    80000d78:	e05a                	sd	s6,0(sp)
    80000d7a:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000d7c:	00007597          	auipc	a1,0x7
    80000d80:	3e458593          	addi	a1,a1,996 # 80008160 <etext+0x160>
    80000d84:	00008517          	auipc	a0,0x8
    80000d88:	2cc50513          	addi	a0,a0,716 # 80009050 <pid_lock>
    80000d8c:	00005097          	auipc	ra,0x5
    80000d90:	2cc080e7          	jalr	716(ra) # 80006058 <initlock>
  initlock(&wait_lock, "wait_lock");
    80000d94:	00007597          	auipc	a1,0x7
    80000d98:	3d458593          	addi	a1,a1,980 # 80008168 <etext+0x168>
    80000d9c:	00008517          	auipc	a0,0x8
    80000da0:	2cc50513          	addi	a0,a0,716 # 80009068 <wait_lock>
    80000da4:	00005097          	auipc	ra,0x5
    80000da8:	2b4080e7          	jalr	692(ra) # 80006058 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000dac:	00008497          	auipc	s1,0x8
    80000db0:	6d448493          	addi	s1,s1,1748 # 80009480 <proc>
      initlock(&p->lock, "proc");
    80000db4:	00007b17          	auipc	s6,0x7
    80000db8:	3c4b0b13          	addi	s6,s6,964 # 80008178 <etext+0x178>
      p->kstack = KSTACK((int) (p - proc));
    80000dbc:	8aa6                	mv	s5,s1
    80000dbe:	00007a17          	auipc	s4,0x7
    80000dc2:	242a0a13          	addi	s4,s4,578 # 80008000 <etext>
    80000dc6:	04000937          	lui	s2,0x4000
    80000dca:	197d                	addi	s2,s2,-1 # 3ffffff <_entry-0x7c000001>
    80000dcc:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000dce:	0000e997          	auipc	s3,0xe
    80000dd2:	6b298993          	addi	s3,s3,1714 # 8000f480 <tickslock>
      initlock(&p->lock, "proc");
    80000dd6:	85da                	mv	a1,s6
    80000dd8:	8526                	mv	a0,s1
    80000dda:	00005097          	auipc	ra,0x5
    80000dde:	27e080e7          	jalr	638(ra) # 80006058 <initlock>
      p->kstack = KSTACK((int) (p - proc));
    80000de2:	415487b3          	sub	a5,s1,s5
    80000de6:	879d                	srai	a5,a5,0x7
    80000de8:	000a3703          	ld	a4,0(s4)
    80000dec:	02e787b3          	mul	a5,a5,a4
    80000df0:	2785                	addiw	a5,a5,1
    80000df2:	00d7979b          	slliw	a5,a5,0xd
    80000df6:	40f907b3          	sub	a5,s2,a5
    80000dfa:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000dfc:	18048493          	addi	s1,s1,384
    80000e00:	fd349be3          	bne	s1,s3,80000dd6 <procinit+0x6e>
  }
}
    80000e04:	70e2                	ld	ra,56(sp)
    80000e06:	7442                	ld	s0,48(sp)
    80000e08:	74a2                	ld	s1,40(sp)
    80000e0a:	7902                	ld	s2,32(sp)
    80000e0c:	69e2                	ld	s3,24(sp)
    80000e0e:	6a42                	ld	s4,16(sp)
    80000e10:	6aa2                	ld	s5,8(sp)
    80000e12:	6b02                	ld	s6,0(sp)
    80000e14:	6121                	addi	sp,sp,64
    80000e16:	8082                	ret

0000000080000e18 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000e18:	1141                	addi	sp,sp,-16
    80000e1a:	e422                	sd	s0,8(sp)
    80000e1c:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000e1e:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000e20:	2501                	sext.w	a0,a0
    80000e22:	6422                	ld	s0,8(sp)
    80000e24:	0141                	addi	sp,sp,16
    80000e26:	8082                	ret

0000000080000e28 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void) {
    80000e28:	1141                	addi	sp,sp,-16
    80000e2a:	e422                	sd	s0,8(sp)
    80000e2c:	0800                	addi	s0,sp,16
    80000e2e:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000e30:	2781                	sext.w	a5,a5
    80000e32:	079e                	slli	a5,a5,0x7
  return c;
}
    80000e34:	00008517          	auipc	a0,0x8
    80000e38:	24c50513          	addi	a0,a0,588 # 80009080 <cpus>
    80000e3c:	953e                	add	a0,a0,a5
    80000e3e:	6422                	ld	s0,8(sp)
    80000e40:	0141                	addi	sp,sp,16
    80000e42:	8082                	ret

0000000080000e44 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void) {
    80000e44:	1101                	addi	sp,sp,-32
    80000e46:	ec06                	sd	ra,24(sp)
    80000e48:	e822                	sd	s0,16(sp)
    80000e4a:	e426                	sd	s1,8(sp)
    80000e4c:	1000                	addi	s0,sp,32
  push_off();
    80000e4e:	00005097          	auipc	ra,0x5
    80000e52:	24e080e7          	jalr	590(ra) # 8000609c <push_off>
    80000e56:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000e58:	2781                	sext.w	a5,a5
    80000e5a:	079e                	slli	a5,a5,0x7
    80000e5c:	00008717          	auipc	a4,0x8
    80000e60:	1f470713          	addi	a4,a4,500 # 80009050 <pid_lock>
    80000e64:	97ba                	add	a5,a5,a4
    80000e66:	7b84                	ld	s1,48(a5)
  pop_off();
    80000e68:	00005097          	auipc	ra,0x5
    80000e6c:	2d4080e7          	jalr	724(ra) # 8000613c <pop_off>
  return p;
}
    80000e70:	8526                	mv	a0,s1
    80000e72:	60e2                	ld	ra,24(sp)
    80000e74:	6442                	ld	s0,16(sp)
    80000e76:	64a2                	ld	s1,8(sp)
    80000e78:	6105                	addi	sp,sp,32
    80000e7a:	8082                	ret

0000000080000e7c <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000e7c:	1141                	addi	sp,sp,-16
    80000e7e:	e406                	sd	ra,8(sp)
    80000e80:	e022                	sd	s0,0(sp)
    80000e82:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80000e84:	00000097          	auipc	ra,0x0
    80000e88:	fc0080e7          	jalr	-64(ra) # 80000e44 <myproc>
    80000e8c:	00005097          	auipc	ra,0x5
    80000e90:	310080e7          	jalr	784(ra) # 8000619c <release>

  if (first) {
    80000e94:	00008797          	auipc	a5,0x8
    80000e98:	afc7a783          	lw	a5,-1284(a5) # 80008990 <first.1>
    80000e9c:	eb89                	bnez	a5,80000eae <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80000e9e:	00001097          	auipc	ra,0x1
    80000ea2:	c26080e7          	jalr	-986(ra) # 80001ac4 <usertrapret>
}
    80000ea6:	60a2                	ld	ra,8(sp)
    80000ea8:	6402                	ld	s0,0(sp)
    80000eaa:	0141                	addi	sp,sp,16
    80000eac:	8082                	ret
    first = 0;
    80000eae:	00008797          	auipc	a5,0x8
    80000eb2:	ae07a123          	sw	zero,-1310(a5) # 80008990 <first.1>
    fsinit(ROOTDEV);
    80000eb6:	4505                	li	a0,1
    80000eb8:	00002097          	auipc	ra,0x2
    80000ebc:	a06080e7          	jalr	-1530(ra) # 800028be <fsinit>
    80000ec0:	bff9                	j	80000e9e <forkret+0x22>

0000000080000ec2 <allocpid>:
allocpid() {
    80000ec2:	1101                	addi	sp,sp,-32
    80000ec4:	ec06                	sd	ra,24(sp)
    80000ec6:	e822                	sd	s0,16(sp)
    80000ec8:	e426                	sd	s1,8(sp)
    80000eca:	e04a                	sd	s2,0(sp)
    80000ecc:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80000ece:	00008917          	auipc	s2,0x8
    80000ed2:	18290913          	addi	s2,s2,386 # 80009050 <pid_lock>
    80000ed6:	854a                	mv	a0,s2
    80000ed8:	00005097          	auipc	ra,0x5
    80000edc:	210080e7          	jalr	528(ra) # 800060e8 <acquire>
  pid = nextpid;
    80000ee0:	00008797          	auipc	a5,0x8
    80000ee4:	ab478793          	addi	a5,a5,-1356 # 80008994 <nextpid>
    80000ee8:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000eea:	0014871b          	addiw	a4,s1,1
    80000eee:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000ef0:	854a                	mv	a0,s2
    80000ef2:	00005097          	auipc	ra,0x5
    80000ef6:	2aa080e7          	jalr	682(ra) # 8000619c <release>
}
    80000efa:	8526                	mv	a0,s1
    80000efc:	60e2                	ld	ra,24(sp)
    80000efe:	6442                	ld	s0,16(sp)
    80000f00:	64a2                	ld	s1,8(sp)
    80000f02:	6902                	ld	s2,0(sp)
    80000f04:	6105                	addi	sp,sp,32
    80000f06:	8082                	ret

0000000080000f08 <proc_pagetable>:
{
    80000f08:	1101                	addi	sp,sp,-32
    80000f0a:	ec06                	sd	ra,24(sp)
    80000f0c:	e822                	sd	s0,16(sp)
    80000f0e:	e426                	sd	s1,8(sp)
    80000f10:	e04a                	sd	s2,0(sp)
    80000f12:	1000                	addi	s0,sp,32
    80000f14:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80000f16:	00000097          	auipc	ra,0x0
    80000f1a:	8b6080e7          	jalr	-1866(ra) # 800007cc <uvmcreate>
    80000f1e:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000f20:	c121                	beqz	a0,80000f60 <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80000f22:	4729                	li	a4,10
    80000f24:	00006697          	auipc	a3,0x6
    80000f28:	0dc68693          	addi	a3,a3,220 # 80007000 <_trampoline>
    80000f2c:	6605                	lui	a2,0x1
    80000f2e:	040005b7          	lui	a1,0x4000
    80000f32:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000f34:	05b2                	slli	a1,a1,0xc
    80000f36:	fffff097          	auipc	ra,0xfffff
    80000f3a:	60c080e7          	jalr	1548(ra) # 80000542 <mappages>
    80000f3e:	02054863          	bltz	a0,80000f6e <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80000f42:	4719                	li	a4,6
    80000f44:	05893683          	ld	a3,88(s2)
    80000f48:	6605                	lui	a2,0x1
    80000f4a:	020005b7          	lui	a1,0x2000
    80000f4e:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80000f50:	05b6                	slli	a1,a1,0xd
    80000f52:	8526                	mv	a0,s1
    80000f54:	fffff097          	auipc	ra,0xfffff
    80000f58:	5ee080e7          	jalr	1518(ra) # 80000542 <mappages>
    80000f5c:	02054163          	bltz	a0,80000f7e <proc_pagetable+0x76>
}
    80000f60:	8526                	mv	a0,s1
    80000f62:	60e2                	ld	ra,24(sp)
    80000f64:	6442                	ld	s0,16(sp)
    80000f66:	64a2                	ld	s1,8(sp)
    80000f68:	6902                	ld	s2,0(sp)
    80000f6a:	6105                	addi	sp,sp,32
    80000f6c:	8082                	ret
    uvmfree(pagetable, 0);
    80000f6e:	4581                	li	a1,0
    80000f70:	8526                	mv	a0,s1
    80000f72:	00000097          	auipc	ra,0x0
    80000f76:	a58080e7          	jalr	-1448(ra) # 800009ca <uvmfree>
    return 0;
    80000f7a:	4481                	li	s1,0
    80000f7c:	b7d5                	j	80000f60 <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000f7e:	4681                	li	a3,0
    80000f80:	4605                	li	a2,1
    80000f82:	040005b7          	lui	a1,0x4000
    80000f86:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000f88:	05b2                	slli	a1,a1,0xc
    80000f8a:	8526                	mv	a0,s1
    80000f8c:	fffff097          	auipc	ra,0xfffff
    80000f90:	77c080e7          	jalr	1916(ra) # 80000708 <uvmunmap>
    uvmfree(pagetable, 0);
    80000f94:	4581                	li	a1,0
    80000f96:	8526                	mv	a0,s1
    80000f98:	00000097          	auipc	ra,0x0
    80000f9c:	a32080e7          	jalr	-1486(ra) # 800009ca <uvmfree>
    return 0;
    80000fa0:	4481                	li	s1,0
    80000fa2:	bf7d                	j	80000f60 <proc_pagetable+0x58>

0000000080000fa4 <proc_freepagetable>:
{
    80000fa4:	1101                	addi	sp,sp,-32
    80000fa6:	ec06                	sd	ra,24(sp)
    80000fa8:	e822                	sd	s0,16(sp)
    80000faa:	e426                	sd	s1,8(sp)
    80000fac:	e04a                	sd	s2,0(sp)
    80000fae:	1000                	addi	s0,sp,32
    80000fb0:	84aa                	mv	s1,a0
    80000fb2:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000fb4:	4681                	li	a3,0
    80000fb6:	4605                	li	a2,1
    80000fb8:	040005b7          	lui	a1,0x4000
    80000fbc:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000fbe:	05b2                	slli	a1,a1,0xc
    80000fc0:	fffff097          	auipc	ra,0xfffff
    80000fc4:	748080e7          	jalr	1864(ra) # 80000708 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80000fc8:	4681                	li	a3,0
    80000fca:	4605                	li	a2,1
    80000fcc:	020005b7          	lui	a1,0x2000
    80000fd0:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80000fd2:	05b6                	slli	a1,a1,0xd
    80000fd4:	8526                	mv	a0,s1
    80000fd6:	fffff097          	auipc	ra,0xfffff
    80000fda:	732080e7          	jalr	1842(ra) # 80000708 <uvmunmap>
  uvmfree(pagetable, sz);
    80000fde:	85ca                	mv	a1,s2
    80000fe0:	8526                	mv	a0,s1
    80000fe2:	00000097          	auipc	ra,0x0
    80000fe6:	9e8080e7          	jalr	-1560(ra) # 800009ca <uvmfree>
}
    80000fea:	60e2                	ld	ra,24(sp)
    80000fec:	6442                	ld	s0,16(sp)
    80000fee:	64a2                	ld	s1,8(sp)
    80000ff0:	6902                	ld	s2,0(sp)
    80000ff2:	6105                	addi	sp,sp,32
    80000ff4:	8082                	ret

0000000080000ff6 <freeproc>:
{
    80000ff6:	1101                	addi	sp,sp,-32
    80000ff8:	ec06                	sd	ra,24(sp)
    80000ffa:	e822                	sd	s0,16(sp)
    80000ffc:	e426                	sd	s1,8(sp)
    80000ffe:	1000                	addi	s0,sp,32
    80001000:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001002:	6d28                	ld	a0,88(a0)
    80001004:	c509                	beqz	a0,8000100e <freeproc+0x18>
    kfree((void*)p->trapframe);
    80001006:	fffff097          	auipc	ra,0xfffff
    8000100a:	016080e7          	jalr	22(ra) # 8000001c <kfree>
  p->trapframe = 0;
    8000100e:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80001012:	68a8                	ld	a0,80(s1)
    80001014:	c511                	beqz	a0,80001020 <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    80001016:	64ac                	ld	a1,72(s1)
    80001018:	00000097          	auipc	ra,0x0
    8000101c:	f8c080e7          	jalr	-116(ra) # 80000fa4 <proc_freepagetable>
  p->pagetable = 0;
    80001020:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80001024:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80001028:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    8000102c:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80001030:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80001034:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80001038:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    8000103c:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80001040:	0004ac23          	sw	zero,24(s1)
}
    80001044:	60e2                	ld	ra,24(sp)
    80001046:	6442                	ld	s0,16(sp)
    80001048:	64a2                	ld	s1,8(sp)
    8000104a:	6105                	addi	sp,sp,32
    8000104c:	8082                	ret

000000008000104e <allocproc>:
{
    8000104e:	1101                	addi	sp,sp,-32
    80001050:	ec06                	sd	ra,24(sp)
    80001052:	e822                	sd	s0,16(sp)
    80001054:	e426                	sd	s1,8(sp)
    80001056:	e04a                	sd	s2,0(sp)
    80001058:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    8000105a:	00008497          	auipc	s1,0x8
    8000105e:	42648493          	addi	s1,s1,1062 # 80009480 <proc>
    80001062:	0000e917          	auipc	s2,0xe
    80001066:	41e90913          	addi	s2,s2,1054 # 8000f480 <tickslock>
    acquire(&p->lock);
    8000106a:	8526                	mv	a0,s1
    8000106c:	00005097          	auipc	ra,0x5
    80001070:	07c080e7          	jalr	124(ra) # 800060e8 <acquire>
    if(p->state == UNUSED) {
    80001074:	4c9c                	lw	a5,24(s1)
    80001076:	cf81                	beqz	a5,8000108e <allocproc+0x40>
      release(&p->lock);
    80001078:	8526                	mv	a0,s1
    8000107a:	00005097          	auipc	ra,0x5
    8000107e:	122080e7          	jalr	290(ra) # 8000619c <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001082:	18048493          	addi	s1,s1,384
    80001086:	ff2492e3          	bne	s1,s2,8000106a <allocproc+0x1c>
  return 0;
    8000108a:	4481                	li	s1,0
    8000108c:	a889                	j	800010de <allocproc+0x90>
  p->pid = allocpid();
    8000108e:	00000097          	auipc	ra,0x0
    80001092:	e34080e7          	jalr	-460(ra) # 80000ec2 <allocpid>
    80001096:	d888                	sw	a0,48(s1)
  p->state = USED;
    80001098:	4785                	li	a5,1
    8000109a:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    8000109c:	fffff097          	auipc	ra,0xfffff
    800010a0:	07e080e7          	jalr	126(ra) # 8000011a <kalloc>
    800010a4:	892a                	mv	s2,a0
    800010a6:	eca8                	sd	a0,88(s1)
    800010a8:	c131                	beqz	a0,800010ec <allocproc+0x9e>
  p->pagetable = proc_pagetable(p);
    800010aa:	8526                	mv	a0,s1
    800010ac:	00000097          	auipc	ra,0x0
    800010b0:	e5c080e7          	jalr	-420(ra) # 80000f08 <proc_pagetable>
    800010b4:	892a                	mv	s2,a0
    800010b6:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    800010b8:	c531                	beqz	a0,80001104 <allocproc+0xb6>
  memset(&p->context, 0, sizeof(p->context));
    800010ba:	07000613          	li	a2,112
    800010be:	4581                	li	a1,0
    800010c0:	06048513          	addi	a0,s1,96
    800010c4:	fffff097          	auipc	ra,0xfffff
    800010c8:	0b6080e7          	jalr	182(ra) # 8000017a <memset>
  p->context.ra = (uint64)forkret;
    800010cc:	00000797          	auipc	a5,0x0
    800010d0:	db078793          	addi	a5,a5,-592 # 80000e7c <forkret>
    800010d4:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    800010d6:	60bc                	ld	a5,64(s1)
    800010d8:	6705                	lui	a4,0x1
    800010da:	97ba                	add	a5,a5,a4
    800010dc:	f4bc                	sd	a5,104(s1)
}
    800010de:	8526                	mv	a0,s1
    800010e0:	60e2                	ld	ra,24(sp)
    800010e2:	6442                	ld	s0,16(sp)
    800010e4:	64a2                	ld	s1,8(sp)
    800010e6:	6902                	ld	s2,0(sp)
    800010e8:	6105                	addi	sp,sp,32
    800010ea:	8082                	ret
    freeproc(p);
    800010ec:	8526                	mv	a0,s1
    800010ee:	00000097          	auipc	ra,0x0
    800010f2:	f08080e7          	jalr	-248(ra) # 80000ff6 <freeproc>
    release(&p->lock);
    800010f6:	8526                	mv	a0,s1
    800010f8:	00005097          	auipc	ra,0x5
    800010fc:	0a4080e7          	jalr	164(ra) # 8000619c <release>
    return 0;
    80001100:	84ca                	mv	s1,s2
    80001102:	bff1                	j	800010de <allocproc+0x90>
    freeproc(p);
    80001104:	8526                	mv	a0,s1
    80001106:	00000097          	auipc	ra,0x0
    8000110a:	ef0080e7          	jalr	-272(ra) # 80000ff6 <freeproc>
    release(&p->lock);
    8000110e:	8526                	mv	a0,s1
    80001110:	00005097          	auipc	ra,0x5
    80001114:	08c080e7          	jalr	140(ra) # 8000619c <release>
    return 0;
    80001118:	84ca                	mv	s1,s2
    8000111a:	b7d1                	j	800010de <allocproc+0x90>

000000008000111c <userinit>:
{
    8000111c:	1101                	addi	sp,sp,-32
    8000111e:	ec06                	sd	ra,24(sp)
    80001120:	e822                	sd	s0,16(sp)
    80001122:	e426                	sd	s1,8(sp)
    80001124:	1000                	addi	s0,sp,32
  p = allocproc();
    80001126:	00000097          	auipc	ra,0x0
    8000112a:	f28080e7          	jalr	-216(ra) # 8000104e <allocproc>
    8000112e:	84aa                	mv	s1,a0
  initproc = p;
    80001130:	00008797          	auipc	a5,0x8
    80001134:	eea7b023          	sd	a0,-288(a5) # 80009010 <initproc>
  uvminit(p->pagetable, initcode, sizeof(initcode));
    80001138:	03400613          	li	a2,52
    8000113c:	00008597          	auipc	a1,0x8
    80001140:	86458593          	addi	a1,a1,-1948 # 800089a0 <initcode>
    80001144:	6928                	ld	a0,80(a0)
    80001146:	fffff097          	auipc	ra,0xfffff
    8000114a:	6b4080e7          	jalr	1716(ra) # 800007fa <uvminit>
  p->sz = PGSIZE;
    8000114e:	6785                	lui	a5,0x1
    80001150:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    80001152:	6cb8                	ld	a4,88(s1)
    80001154:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    80001158:	6cb8                	ld	a4,88(s1)
    8000115a:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    8000115c:	4641                	li	a2,16
    8000115e:	00007597          	auipc	a1,0x7
    80001162:	02258593          	addi	a1,a1,34 # 80008180 <etext+0x180>
    80001166:	15848513          	addi	a0,s1,344
    8000116a:	fffff097          	auipc	ra,0xfffff
    8000116e:	15a080e7          	jalr	346(ra) # 800002c4 <safestrcpy>
  p->cwd = namei("/");
    80001172:	00007517          	auipc	a0,0x7
    80001176:	01e50513          	addi	a0,a0,30 # 80008190 <etext+0x190>
    8000117a:	00002097          	auipc	ra,0x2
    8000117e:	17a080e7          	jalr	378(ra) # 800032f4 <namei>
    80001182:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    80001186:	478d                	li	a5,3
    80001188:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    8000118a:	8526                	mv	a0,s1
    8000118c:	00005097          	auipc	ra,0x5
    80001190:	010080e7          	jalr	16(ra) # 8000619c <release>
}
    80001194:	60e2                	ld	ra,24(sp)
    80001196:	6442                	ld	s0,16(sp)
    80001198:	64a2                	ld	s1,8(sp)
    8000119a:	6105                	addi	sp,sp,32
    8000119c:	8082                	ret

000000008000119e <growproc>:
{
    8000119e:	1101                	addi	sp,sp,-32
    800011a0:	ec06                	sd	ra,24(sp)
    800011a2:	e822                	sd	s0,16(sp)
    800011a4:	e426                	sd	s1,8(sp)
    800011a6:	e04a                	sd	s2,0(sp)
    800011a8:	1000                	addi	s0,sp,32
    800011aa:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    800011ac:	00000097          	auipc	ra,0x0
    800011b0:	c98080e7          	jalr	-872(ra) # 80000e44 <myproc>
    800011b4:	892a                	mv	s2,a0
  sz = p->sz;
    800011b6:	652c                	ld	a1,72(a0)
    800011b8:	0005879b          	sext.w	a5,a1
  if(n > 0){
    800011bc:	00904f63          	bgtz	s1,800011da <growproc+0x3c>
  } else if(n < 0){
    800011c0:	0204cd63          	bltz	s1,800011fa <growproc+0x5c>
  p->sz = sz;
    800011c4:	1782                	slli	a5,a5,0x20
    800011c6:	9381                	srli	a5,a5,0x20
    800011c8:	04f93423          	sd	a5,72(s2)
  return 0;
    800011cc:	4501                	li	a0,0
}
    800011ce:	60e2                	ld	ra,24(sp)
    800011d0:	6442                	ld	s0,16(sp)
    800011d2:	64a2                	ld	s1,8(sp)
    800011d4:	6902                	ld	s2,0(sp)
    800011d6:	6105                	addi	sp,sp,32
    800011d8:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0) {
    800011da:	00f4863b          	addw	a2,s1,a5
    800011de:	1602                	slli	a2,a2,0x20
    800011e0:	9201                	srli	a2,a2,0x20
    800011e2:	1582                	slli	a1,a1,0x20
    800011e4:	9181                	srli	a1,a1,0x20
    800011e6:	6928                	ld	a0,80(a0)
    800011e8:	fffff097          	auipc	ra,0xfffff
    800011ec:	6cc080e7          	jalr	1740(ra) # 800008b4 <uvmalloc>
    800011f0:	0005079b          	sext.w	a5,a0
    800011f4:	fbe1                	bnez	a5,800011c4 <growproc+0x26>
      return -1;
    800011f6:	557d                	li	a0,-1
    800011f8:	bfd9                	j	800011ce <growproc+0x30>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    800011fa:	00f4863b          	addw	a2,s1,a5
    800011fe:	1602                	slli	a2,a2,0x20
    80001200:	9201                	srli	a2,a2,0x20
    80001202:	1582                	slli	a1,a1,0x20
    80001204:	9181                	srli	a1,a1,0x20
    80001206:	6928                	ld	a0,80(a0)
    80001208:	fffff097          	auipc	ra,0xfffff
    8000120c:	664080e7          	jalr	1636(ra) # 8000086c <uvmdealloc>
    80001210:	0005079b          	sext.w	a5,a0
    80001214:	bf45                	j	800011c4 <growproc+0x26>

0000000080001216 <fork>:
{
    80001216:	7139                	addi	sp,sp,-64
    80001218:	fc06                	sd	ra,56(sp)
    8000121a:	f822                	sd	s0,48(sp)
    8000121c:	f426                	sd	s1,40(sp)
    8000121e:	f04a                	sd	s2,32(sp)
    80001220:	ec4e                	sd	s3,24(sp)
    80001222:	e852                	sd	s4,16(sp)
    80001224:	e456                	sd	s5,8(sp)
    80001226:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    80001228:	00000097          	auipc	ra,0x0
    8000122c:	c1c080e7          	jalr	-996(ra) # 80000e44 <myproc>
    80001230:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    80001232:	00000097          	auipc	ra,0x0
    80001236:	e1c080e7          	jalr	-484(ra) # 8000104e <allocproc>
    8000123a:	12050563          	beqz	a0,80001364 <fork+0x14e>
    8000123e:	89aa                	mv	s3,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001240:	048ab603          	ld	a2,72(s5)
    80001244:	692c                	ld	a1,80(a0)
    80001246:	050ab503          	ld	a0,80(s5)
    8000124a:	fffff097          	auipc	ra,0xfffff
    8000124e:	7ba080e7          	jalr	1978(ra) # 80000a04 <uvmcopy>
    80001252:	06054163          	bltz	a0,800012b4 <fork+0x9e>
  np->sz = p->sz;
    80001256:	048ab783          	ld	a5,72(s5)
    8000125a:	04f9b423          	sd	a5,72(s3)
safestrcpy(np->mask,p->mask,sizeof(p->mask));
    8000125e:	465d                	li	a2,23
    80001260:	168a8593          	addi	a1,s5,360
    80001264:	16898513          	addi	a0,s3,360
    80001268:	fffff097          	auipc	ra,0xfffff
    8000126c:	05c080e7          	jalr	92(ra) # 800002c4 <safestrcpy>
  *(np->trapframe) = *(p->trapframe);
    80001270:	058ab683          	ld	a3,88(s5)
    80001274:	87b6                	mv	a5,a3
    80001276:	0589b703          	ld	a4,88(s3)
    8000127a:	12068693          	addi	a3,a3,288
    8000127e:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    80001282:	6788                	ld	a0,8(a5)
    80001284:	6b8c                	ld	a1,16(a5)
    80001286:	6f90                	ld	a2,24(a5)
    80001288:	01073023          	sd	a6,0(a4)
    8000128c:	e708                	sd	a0,8(a4)
    8000128e:	eb0c                	sd	a1,16(a4)
    80001290:	ef10                	sd	a2,24(a4)
    80001292:	02078793          	addi	a5,a5,32
    80001296:	02070713          	addi	a4,a4,32
    8000129a:	fed792e3          	bne	a5,a3,8000127e <fork+0x68>
  np->trapframe->a0 = 0;
    8000129e:	0589b783          	ld	a5,88(s3)
    800012a2:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    800012a6:	0d0a8493          	addi	s1,s5,208
    800012aa:	0d098913          	addi	s2,s3,208
    800012ae:	150a8a13          	addi	s4,s5,336
    800012b2:	a00d                	j	800012d4 <fork+0xbe>
    freeproc(np);
    800012b4:	854e                	mv	a0,s3
    800012b6:	00000097          	auipc	ra,0x0
    800012ba:	d40080e7          	jalr	-704(ra) # 80000ff6 <freeproc>
    release(&np->lock);
    800012be:	854e                	mv	a0,s3
    800012c0:	00005097          	auipc	ra,0x5
    800012c4:	edc080e7          	jalr	-292(ra) # 8000619c <release>
    return -1;
    800012c8:	597d                	li	s2,-1
    800012ca:	a059                	j	80001350 <fork+0x13a>
  for(i = 0; i < NOFILE; i++)
    800012cc:	04a1                	addi	s1,s1,8
    800012ce:	0921                	addi	s2,s2,8
    800012d0:	01448b63          	beq	s1,s4,800012e6 <fork+0xd0>
    if(p->ofile[i])
    800012d4:	6088                	ld	a0,0(s1)
    800012d6:	d97d                	beqz	a0,800012cc <fork+0xb6>
      np->ofile[i] = filedup(p->ofile[i]);
    800012d8:	00002097          	auipc	ra,0x2
    800012dc:	6b2080e7          	jalr	1714(ra) # 8000398a <filedup>
    800012e0:	00a93023          	sd	a0,0(s2)
    800012e4:	b7e5                	j	800012cc <fork+0xb6>
  np->cwd = idup(p->cwd);
    800012e6:	150ab503          	ld	a0,336(s5)
    800012ea:	00002097          	auipc	ra,0x2
    800012ee:	810080e7          	jalr	-2032(ra) # 80002afa <idup>
    800012f2:	14a9b823          	sd	a0,336(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    800012f6:	4641                	li	a2,16
    800012f8:	158a8593          	addi	a1,s5,344
    800012fc:	15898513          	addi	a0,s3,344
    80001300:	fffff097          	auipc	ra,0xfffff
    80001304:	fc4080e7          	jalr	-60(ra) # 800002c4 <safestrcpy>
  pid = np->pid;
    80001308:	0309a903          	lw	s2,48(s3)
  release(&np->lock);
    8000130c:	854e                	mv	a0,s3
    8000130e:	00005097          	auipc	ra,0x5
    80001312:	e8e080e7          	jalr	-370(ra) # 8000619c <release>
  acquire(&wait_lock);
    80001316:	00008497          	auipc	s1,0x8
    8000131a:	d5248493          	addi	s1,s1,-686 # 80009068 <wait_lock>
    8000131e:	8526                	mv	a0,s1
    80001320:	00005097          	auipc	ra,0x5
    80001324:	dc8080e7          	jalr	-568(ra) # 800060e8 <acquire>
  np->parent = p;
    80001328:	0359bc23          	sd	s5,56(s3)
  release(&wait_lock);
    8000132c:	8526                	mv	a0,s1
    8000132e:	00005097          	auipc	ra,0x5
    80001332:	e6e080e7          	jalr	-402(ra) # 8000619c <release>
  acquire(&np->lock);
    80001336:	854e                	mv	a0,s3
    80001338:	00005097          	auipc	ra,0x5
    8000133c:	db0080e7          	jalr	-592(ra) # 800060e8 <acquire>
  np->state = RUNNABLE;
    80001340:	478d                	li	a5,3
    80001342:	00f9ac23          	sw	a5,24(s3)
  release(&np->lock);
    80001346:	854e                	mv	a0,s3
    80001348:	00005097          	auipc	ra,0x5
    8000134c:	e54080e7          	jalr	-428(ra) # 8000619c <release>
}
    80001350:	854a                	mv	a0,s2
    80001352:	70e2                	ld	ra,56(sp)
    80001354:	7442                	ld	s0,48(sp)
    80001356:	74a2                	ld	s1,40(sp)
    80001358:	7902                	ld	s2,32(sp)
    8000135a:	69e2                	ld	s3,24(sp)
    8000135c:	6a42                	ld	s4,16(sp)
    8000135e:	6aa2                	ld	s5,8(sp)
    80001360:	6121                	addi	sp,sp,64
    80001362:	8082                	ret
    return -1;
    80001364:	597d                	li	s2,-1
    80001366:	b7ed                	j	80001350 <fork+0x13a>

0000000080001368 <scheduler>:
{
    80001368:	7139                	addi	sp,sp,-64
    8000136a:	fc06                	sd	ra,56(sp)
    8000136c:	f822                	sd	s0,48(sp)
    8000136e:	f426                	sd	s1,40(sp)
    80001370:	f04a                	sd	s2,32(sp)
    80001372:	ec4e                	sd	s3,24(sp)
    80001374:	e852                	sd	s4,16(sp)
    80001376:	e456                	sd	s5,8(sp)
    80001378:	e05a                	sd	s6,0(sp)
    8000137a:	0080                	addi	s0,sp,64
    8000137c:	8792                	mv	a5,tp
  int id = r_tp();
    8000137e:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001380:	00779a93          	slli	s5,a5,0x7
    80001384:	00008717          	auipc	a4,0x8
    80001388:	ccc70713          	addi	a4,a4,-820 # 80009050 <pid_lock>
    8000138c:	9756                	add	a4,a4,s5
    8000138e:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    80001392:	00008717          	auipc	a4,0x8
    80001396:	cf670713          	addi	a4,a4,-778 # 80009088 <cpus+0x8>
    8000139a:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    8000139c:	498d                	li	s3,3
        p->state = RUNNING;
    8000139e:	4b11                	li	s6,4
        c->proc = p;
    800013a0:	079e                	slli	a5,a5,0x7
    800013a2:	00008a17          	auipc	s4,0x8
    800013a6:	caea0a13          	addi	s4,s4,-850 # 80009050 <pid_lock>
    800013aa:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    800013ac:	0000e917          	auipc	s2,0xe
    800013b0:	0d490913          	addi	s2,s2,212 # 8000f480 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800013b4:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800013b8:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800013bc:	10079073          	csrw	sstatus,a5
    800013c0:	00008497          	auipc	s1,0x8
    800013c4:	0c048493          	addi	s1,s1,192 # 80009480 <proc>
    800013c8:	a811                	j	800013dc <scheduler+0x74>
      release(&p->lock);
    800013ca:	8526                	mv	a0,s1
    800013cc:	00005097          	auipc	ra,0x5
    800013d0:	dd0080e7          	jalr	-560(ra) # 8000619c <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    800013d4:	18048493          	addi	s1,s1,384
    800013d8:	fd248ee3          	beq	s1,s2,800013b4 <scheduler+0x4c>
      acquire(&p->lock);
    800013dc:	8526                	mv	a0,s1
    800013de:	00005097          	auipc	ra,0x5
    800013e2:	d0a080e7          	jalr	-758(ra) # 800060e8 <acquire>
      if(p->state == RUNNABLE) {
    800013e6:	4c9c                	lw	a5,24(s1)
    800013e8:	ff3791e3          	bne	a5,s3,800013ca <scheduler+0x62>
        p->state = RUNNING;
    800013ec:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    800013f0:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    800013f4:	06048593          	addi	a1,s1,96
    800013f8:	8556                	mv	a0,s5
    800013fa:	00000097          	auipc	ra,0x0
    800013fe:	620080e7          	jalr	1568(ra) # 80001a1a <swtch>
        c->proc = 0;
    80001402:	020a3823          	sd	zero,48(s4)
    80001406:	b7d1                	j	800013ca <scheduler+0x62>

0000000080001408 <sched>:
{
    80001408:	7179                	addi	sp,sp,-48
    8000140a:	f406                	sd	ra,40(sp)
    8000140c:	f022                	sd	s0,32(sp)
    8000140e:	ec26                	sd	s1,24(sp)
    80001410:	e84a                	sd	s2,16(sp)
    80001412:	e44e                	sd	s3,8(sp)
    80001414:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001416:	00000097          	auipc	ra,0x0
    8000141a:	a2e080e7          	jalr	-1490(ra) # 80000e44 <myproc>
    8000141e:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001420:	00005097          	auipc	ra,0x5
    80001424:	c4e080e7          	jalr	-946(ra) # 8000606e <holding>
    80001428:	c93d                	beqz	a0,8000149e <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000142a:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    8000142c:	2781                	sext.w	a5,a5
    8000142e:	079e                	slli	a5,a5,0x7
    80001430:	00008717          	auipc	a4,0x8
    80001434:	c2070713          	addi	a4,a4,-992 # 80009050 <pid_lock>
    80001438:	97ba                	add	a5,a5,a4
    8000143a:	0a87a703          	lw	a4,168(a5)
    8000143e:	4785                	li	a5,1
    80001440:	06f71763          	bne	a4,a5,800014ae <sched+0xa6>
  if(p->state == RUNNING)
    80001444:	4c98                	lw	a4,24(s1)
    80001446:	4791                	li	a5,4
    80001448:	06f70b63          	beq	a4,a5,800014be <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000144c:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001450:	8b89                	andi	a5,a5,2
  if(intr_get())
    80001452:	efb5                	bnez	a5,800014ce <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001454:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80001456:	00008917          	auipc	s2,0x8
    8000145a:	bfa90913          	addi	s2,s2,-1030 # 80009050 <pid_lock>
    8000145e:	2781                	sext.w	a5,a5
    80001460:	079e                	slli	a5,a5,0x7
    80001462:	97ca                	add	a5,a5,s2
    80001464:	0ac7a983          	lw	s3,172(a5)
    80001468:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    8000146a:	2781                	sext.w	a5,a5
    8000146c:	079e                	slli	a5,a5,0x7
    8000146e:	00008597          	auipc	a1,0x8
    80001472:	c1a58593          	addi	a1,a1,-998 # 80009088 <cpus+0x8>
    80001476:	95be                	add	a1,a1,a5
    80001478:	06048513          	addi	a0,s1,96
    8000147c:	00000097          	auipc	ra,0x0
    80001480:	59e080e7          	jalr	1438(ra) # 80001a1a <swtch>
    80001484:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    80001486:	2781                	sext.w	a5,a5
    80001488:	079e                	slli	a5,a5,0x7
    8000148a:	993e                	add	s2,s2,a5
    8000148c:	0b392623          	sw	s3,172(s2)
}
    80001490:	70a2                	ld	ra,40(sp)
    80001492:	7402                	ld	s0,32(sp)
    80001494:	64e2                	ld	s1,24(sp)
    80001496:	6942                	ld	s2,16(sp)
    80001498:	69a2                	ld	s3,8(sp)
    8000149a:	6145                	addi	sp,sp,48
    8000149c:	8082                	ret
    panic("sched p->lock");
    8000149e:	00007517          	auipc	a0,0x7
    800014a2:	cfa50513          	addi	a0,a0,-774 # 80008198 <etext+0x198>
    800014a6:	00004097          	auipc	ra,0x4
    800014aa:	70a080e7          	jalr	1802(ra) # 80005bb0 <panic>
    panic("sched locks");
    800014ae:	00007517          	auipc	a0,0x7
    800014b2:	cfa50513          	addi	a0,a0,-774 # 800081a8 <etext+0x1a8>
    800014b6:	00004097          	auipc	ra,0x4
    800014ba:	6fa080e7          	jalr	1786(ra) # 80005bb0 <panic>
    panic("sched running");
    800014be:	00007517          	auipc	a0,0x7
    800014c2:	cfa50513          	addi	a0,a0,-774 # 800081b8 <etext+0x1b8>
    800014c6:	00004097          	auipc	ra,0x4
    800014ca:	6ea080e7          	jalr	1770(ra) # 80005bb0 <panic>
    panic("sched interruptible");
    800014ce:	00007517          	auipc	a0,0x7
    800014d2:	cfa50513          	addi	a0,a0,-774 # 800081c8 <etext+0x1c8>
    800014d6:	00004097          	auipc	ra,0x4
    800014da:	6da080e7          	jalr	1754(ra) # 80005bb0 <panic>

00000000800014de <yield>:
{
    800014de:	1101                	addi	sp,sp,-32
    800014e0:	ec06                	sd	ra,24(sp)
    800014e2:	e822                	sd	s0,16(sp)
    800014e4:	e426                	sd	s1,8(sp)
    800014e6:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    800014e8:	00000097          	auipc	ra,0x0
    800014ec:	95c080e7          	jalr	-1700(ra) # 80000e44 <myproc>
    800014f0:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800014f2:	00005097          	auipc	ra,0x5
    800014f6:	bf6080e7          	jalr	-1034(ra) # 800060e8 <acquire>
  p->state = RUNNABLE;
    800014fa:	478d                	li	a5,3
    800014fc:	cc9c                	sw	a5,24(s1)
  sched();
    800014fe:	00000097          	auipc	ra,0x0
    80001502:	f0a080e7          	jalr	-246(ra) # 80001408 <sched>
  release(&p->lock);
    80001506:	8526                	mv	a0,s1
    80001508:	00005097          	auipc	ra,0x5
    8000150c:	c94080e7          	jalr	-876(ra) # 8000619c <release>
}
    80001510:	60e2                	ld	ra,24(sp)
    80001512:	6442                	ld	s0,16(sp)
    80001514:	64a2                	ld	s1,8(sp)
    80001516:	6105                	addi	sp,sp,32
    80001518:	8082                	ret

000000008000151a <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    8000151a:	7179                	addi	sp,sp,-48
    8000151c:	f406                	sd	ra,40(sp)
    8000151e:	f022                	sd	s0,32(sp)
    80001520:	ec26                	sd	s1,24(sp)
    80001522:	e84a                	sd	s2,16(sp)
    80001524:	e44e                	sd	s3,8(sp)
    80001526:	1800                	addi	s0,sp,48
    80001528:	89aa                	mv	s3,a0
    8000152a:	892e                	mv	s2,a1
  struct proc *p = myproc();
    8000152c:	00000097          	auipc	ra,0x0
    80001530:	918080e7          	jalr	-1768(ra) # 80000e44 <myproc>
    80001534:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    80001536:	00005097          	auipc	ra,0x5
    8000153a:	bb2080e7          	jalr	-1102(ra) # 800060e8 <acquire>
  release(lk);
    8000153e:	854a                	mv	a0,s2
    80001540:	00005097          	auipc	ra,0x5
    80001544:	c5c080e7          	jalr	-932(ra) # 8000619c <release>

  // Go to sleep.
  p->chan = chan;
    80001548:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    8000154c:	4789                	li	a5,2
    8000154e:	cc9c                	sw	a5,24(s1)

  sched();
    80001550:	00000097          	auipc	ra,0x0
    80001554:	eb8080e7          	jalr	-328(ra) # 80001408 <sched>

  // Tidy up.
  p->chan = 0;
    80001558:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    8000155c:	8526                	mv	a0,s1
    8000155e:	00005097          	auipc	ra,0x5
    80001562:	c3e080e7          	jalr	-962(ra) # 8000619c <release>
  acquire(lk);
    80001566:	854a                	mv	a0,s2
    80001568:	00005097          	auipc	ra,0x5
    8000156c:	b80080e7          	jalr	-1152(ra) # 800060e8 <acquire>
}
    80001570:	70a2                	ld	ra,40(sp)
    80001572:	7402                	ld	s0,32(sp)
    80001574:	64e2                	ld	s1,24(sp)
    80001576:	6942                	ld	s2,16(sp)
    80001578:	69a2                	ld	s3,8(sp)
    8000157a:	6145                	addi	sp,sp,48
    8000157c:	8082                	ret

000000008000157e <wait>:
{
    8000157e:	715d                	addi	sp,sp,-80
    80001580:	e486                	sd	ra,72(sp)
    80001582:	e0a2                	sd	s0,64(sp)
    80001584:	fc26                	sd	s1,56(sp)
    80001586:	f84a                	sd	s2,48(sp)
    80001588:	f44e                	sd	s3,40(sp)
    8000158a:	f052                	sd	s4,32(sp)
    8000158c:	ec56                	sd	s5,24(sp)
    8000158e:	e85a                	sd	s6,16(sp)
    80001590:	e45e                	sd	s7,8(sp)
    80001592:	e062                	sd	s8,0(sp)
    80001594:	0880                	addi	s0,sp,80
    80001596:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    80001598:	00000097          	auipc	ra,0x0
    8000159c:	8ac080e7          	jalr	-1876(ra) # 80000e44 <myproc>
    800015a0:	892a                	mv	s2,a0
  acquire(&wait_lock);
    800015a2:	00008517          	auipc	a0,0x8
    800015a6:	ac650513          	addi	a0,a0,-1338 # 80009068 <wait_lock>
    800015aa:	00005097          	auipc	ra,0x5
    800015ae:	b3e080e7          	jalr	-1218(ra) # 800060e8 <acquire>
    havekids = 0;
    800015b2:	4b81                	li	s7,0
        if(np->state == ZOMBIE){
    800015b4:	4a15                	li	s4,5
        havekids = 1;
    800015b6:	4a85                	li	s5,1
    for(np = proc; np < &proc[NPROC]; np++){
    800015b8:	0000e997          	auipc	s3,0xe
    800015bc:	ec898993          	addi	s3,s3,-312 # 8000f480 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800015c0:	00008c17          	auipc	s8,0x8
    800015c4:	aa8c0c13          	addi	s8,s8,-1368 # 80009068 <wait_lock>
    havekids = 0;
    800015c8:	875e                	mv	a4,s7
    for(np = proc; np < &proc[NPROC]; np++){
    800015ca:	00008497          	auipc	s1,0x8
    800015ce:	eb648493          	addi	s1,s1,-330 # 80009480 <proc>
    800015d2:	a0bd                	j	80001640 <wait+0xc2>
          pid = np->pid;
    800015d4:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    800015d8:	000b0e63          	beqz	s6,800015f4 <wait+0x76>
    800015dc:	4691                	li	a3,4
    800015de:	02c48613          	addi	a2,s1,44
    800015e2:	85da                	mv	a1,s6
    800015e4:	05093503          	ld	a0,80(s2)
    800015e8:	fffff097          	auipc	ra,0xfffff
    800015ec:	520080e7          	jalr	1312(ra) # 80000b08 <copyout>
    800015f0:	02054563          	bltz	a0,8000161a <wait+0x9c>
          freeproc(np);
    800015f4:	8526                	mv	a0,s1
    800015f6:	00000097          	auipc	ra,0x0
    800015fa:	a00080e7          	jalr	-1536(ra) # 80000ff6 <freeproc>
          release(&np->lock);
    800015fe:	8526                	mv	a0,s1
    80001600:	00005097          	auipc	ra,0x5
    80001604:	b9c080e7          	jalr	-1124(ra) # 8000619c <release>
          release(&wait_lock);
    80001608:	00008517          	auipc	a0,0x8
    8000160c:	a6050513          	addi	a0,a0,-1440 # 80009068 <wait_lock>
    80001610:	00005097          	auipc	ra,0x5
    80001614:	b8c080e7          	jalr	-1140(ra) # 8000619c <release>
          return pid;
    80001618:	a09d                	j	8000167e <wait+0x100>
            release(&np->lock);
    8000161a:	8526                	mv	a0,s1
    8000161c:	00005097          	auipc	ra,0x5
    80001620:	b80080e7          	jalr	-1152(ra) # 8000619c <release>
            release(&wait_lock);
    80001624:	00008517          	auipc	a0,0x8
    80001628:	a4450513          	addi	a0,a0,-1468 # 80009068 <wait_lock>
    8000162c:	00005097          	auipc	ra,0x5
    80001630:	b70080e7          	jalr	-1168(ra) # 8000619c <release>
            return -1;
    80001634:	59fd                	li	s3,-1
    80001636:	a0a1                	j	8000167e <wait+0x100>
    for(np = proc; np < &proc[NPROC]; np++){
    80001638:	18048493          	addi	s1,s1,384
    8000163c:	03348463          	beq	s1,s3,80001664 <wait+0xe6>
      if(np->parent == p){
    80001640:	7c9c                	ld	a5,56(s1)
    80001642:	ff279be3          	bne	a5,s2,80001638 <wait+0xba>
        acquire(&np->lock);
    80001646:	8526                	mv	a0,s1
    80001648:	00005097          	auipc	ra,0x5
    8000164c:	aa0080e7          	jalr	-1376(ra) # 800060e8 <acquire>
        if(np->state == ZOMBIE){
    80001650:	4c9c                	lw	a5,24(s1)
    80001652:	f94781e3          	beq	a5,s4,800015d4 <wait+0x56>
        release(&np->lock);
    80001656:	8526                	mv	a0,s1
    80001658:	00005097          	auipc	ra,0x5
    8000165c:	b44080e7          	jalr	-1212(ra) # 8000619c <release>
        havekids = 1;
    80001660:	8756                	mv	a4,s5
    80001662:	bfd9                	j	80001638 <wait+0xba>
    if(!havekids || p->killed){
    80001664:	c701                	beqz	a4,8000166c <wait+0xee>
    80001666:	02892783          	lw	a5,40(s2)
    8000166a:	c79d                	beqz	a5,80001698 <wait+0x11a>
      release(&wait_lock);
    8000166c:	00008517          	auipc	a0,0x8
    80001670:	9fc50513          	addi	a0,a0,-1540 # 80009068 <wait_lock>
    80001674:	00005097          	auipc	ra,0x5
    80001678:	b28080e7          	jalr	-1240(ra) # 8000619c <release>
      return -1;
    8000167c:	59fd                	li	s3,-1
}
    8000167e:	854e                	mv	a0,s3
    80001680:	60a6                	ld	ra,72(sp)
    80001682:	6406                	ld	s0,64(sp)
    80001684:	74e2                	ld	s1,56(sp)
    80001686:	7942                	ld	s2,48(sp)
    80001688:	79a2                	ld	s3,40(sp)
    8000168a:	7a02                	ld	s4,32(sp)
    8000168c:	6ae2                	ld	s5,24(sp)
    8000168e:	6b42                	ld	s6,16(sp)
    80001690:	6ba2                	ld	s7,8(sp)
    80001692:	6c02                	ld	s8,0(sp)
    80001694:	6161                	addi	sp,sp,80
    80001696:	8082                	ret
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001698:	85e2                	mv	a1,s8
    8000169a:	854a                	mv	a0,s2
    8000169c:	00000097          	auipc	ra,0x0
    800016a0:	e7e080e7          	jalr	-386(ra) # 8000151a <sleep>
    havekids = 0;
    800016a4:	b715                	j	800015c8 <wait+0x4a>

00000000800016a6 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    800016a6:	7139                	addi	sp,sp,-64
    800016a8:	fc06                	sd	ra,56(sp)
    800016aa:	f822                	sd	s0,48(sp)
    800016ac:	f426                	sd	s1,40(sp)
    800016ae:	f04a                	sd	s2,32(sp)
    800016b0:	ec4e                	sd	s3,24(sp)
    800016b2:	e852                	sd	s4,16(sp)
    800016b4:	e456                	sd	s5,8(sp)
    800016b6:	0080                	addi	s0,sp,64
    800016b8:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    800016ba:	00008497          	auipc	s1,0x8
    800016be:	dc648493          	addi	s1,s1,-570 # 80009480 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    800016c2:	4989                	li	s3,2
        p->state = RUNNABLE;
    800016c4:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    800016c6:	0000e917          	auipc	s2,0xe
    800016ca:	dba90913          	addi	s2,s2,-582 # 8000f480 <tickslock>
    800016ce:	a811                	j	800016e2 <wakeup+0x3c>
      }
      release(&p->lock);
    800016d0:	8526                	mv	a0,s1
    800016d2:	00005097          	auipc	ra,0x5
    800016d6:	aca080e7          	jalr	-1334(ra) # 8000619c <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800016da:	18048493          	addi	s1,s1,384
    800016de:	03248663          	beq	s1,s2,8000170a <wakeup+0x64>
    if(p != myproc()){
    800016e2:	fffff097          	auipc	ra,0xfffff
    800016e6:	762080e7          	jalr	1890(ra) # 80000e44 <myproc>
    800016ea:	fea488e3          	beq	s1,a0,800016da <wakeup+0x34>
      acquire(&p->lock);
    800016ee:	8526                	mv	a0,s1
    800016f0:	00005097          	auipc	ra,0x5
    800016f4:	9f8080e7          	jalr	-1544(ra) # 800060e8 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    800016f8:	4c9c                	lw	a5,24(s1)
    800016fa:	fd379be3          	bne	a5,s3,800016d0 <wakeup+0x2a>
    800016fe:	709c                	ld	a5,32(s1)
    80001700:	fd4798e3          	bne	a5,s4,800016d0 <wakeup+0x2a>
        p->state = RUNNABLE;
    80001704:	0154ac23          	sw	s5,24(s1)
    80001708:	b7e1                	j	800016d0 <wakeup+0x2a>
    }
  }
}
    8000170a:	70e2                	ld	ra,56(sp)
    8000170c:	7442                	ld	s0,48(sp)
    8000170e:	74a2                	ld	s1,40(sp)
    80001710:	7902                	ld	s2,32(sp)
    80001712:	69e2                	ld	s3,24(sp)
    80001714:	6a42                	ld	s4,16(sp)
    80001716:	6aa2                	ld	s5,8(sp)
    80001718:	6121                	addi	sp,sp,64
    8000171a:	8082                	ret

000000008000171c <reparent>:
{
    8000171c:	7179                	addi	sp,sp,-48
    8000171e:	f406                	sd	ra,40(sp)
    80001720:	f022                	sd	s0,32(sp)
    80001722:	ec26                	sd	s1,24(sp)
    80001724:	e84a                	sd	s2,16(sp)
    80001726:	e44e                	sd	s3,8(sp)
    80001728:	e052                	sd	s4,0(sp)
    8000172a:	1800                	addi	s0,sp,48
    8000172c:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    8000172e:	00008497          	auipc	s1,0x8
    80001732:	d5248493          	addi	s1,s1,-686 # 80009480 <proc>
      pp->parent = initproc;
    80001736:	00008a17          	auipc	s4,0x8
    8000173a:	8daa0a13          	addi	s4,s4,-1830 # 80009010 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    8000173e:	0000e997          	auipc	s3,0xe
    80001742:	d4298993          	addi	s3,s3,-702 # 8000f480 <tickslock>
    80001746:	a029                	j	80001750 <reparent+0x34>
    80001748:	18048493          	addi	s1,s1,384
    8000174c:	01348d63          	beq	s1,s3,80001766 <reparent+0x4a>
    if(pp->parent == p){
    80001750:	7c9c                	ld	a5,56(s1)
    80001752:	ff279be3          	bne	a5,s2,80001748 <reparent+0x2c>
      pp->parent = initproc;
    80001756:	000a3503          	ld	a0,0(s4)
    8000175a:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    8000175c:	00000097          	auipc	ra,0x0
    80001760:	f4a080e7          	jalr	-182(ra) # 800016a6 <wakeup>
    80001764:	b7d5                	j	80001748 <reparent+0x2c>
}
    80001766:	70a2                	ld	ra,40(sp)
    80001768:	7402                	ld	s0,32(sp)
    8000176a:	64e2                	ld	s1,24(sp)
    8000176c:	6942                	ld	s2,16(sp)
    8000176e:	69a2                	ld	s3,8(sp)
    80001770:	6a02                	ld	s4,0(sp)
    80001772:	6145                	addi	sp,sp,48
    80001774:	8082                	ret

0000000080001776 <exit>:
{
    80001776:	7179                	addi	sp,sp,-48
    80001778:	f406                	sd	ra,40(sp)
    8000177a:	f022                	sd	s0,32(sp)
    8000177c:	ec26                	sd	s1,24(sp)
    8000177e:	e84a                	sd	s2,16(sp)
    80001780:	e44e                	sd	s3,8(sp)
    80001782:	e052                	sd	s4,0(sp)
    80001784:	1800                	addi	s0,sp,48
    80001786:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80001788:	fffff097          	auipc	ra,0xfffff
    8000178c:	6bc080e7          	jalr	1724(ra) # 80000e44 <myproc>
    80001790:	89aa                	mv	s3,a0
  if(p == initproc)
    80001792:	00008797          	auipc	a5,0x8
    80001796:	87e7b783          	ld	a5,-1922(a5) # 80009010 <initproc>
    8000179a:	0d050493          	addi	s1,a0,208
    8000179e:	15050913          	addi	s2,a0,336
    800017a2:	02a79363          	bne	a5,a0,800017c8 <exit+0x52>
    panic("init exiting");
    800017a6:	00007517          	auipc	a0,0x7
    800017aa:	a3a50513          	addi	a0,a0,-1478 # 800081e0 <etext+0x1e0>
    800017ae:	00004097          	auipc	ra,0x4
    800017b2:	402080e7          	jalr	1026(ra) # 80005bb0 <panic>
      fileclose(f);
    800017b6:	00002097          	auipc	ra,0x2
    800017ba:	226080e7          	jalr	550(ra) # 800039dc <fileclose>
      p->ofile[fd] = 0;
    800017be:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    800017c2:	04a1                	addi	s1,s1,8
    800017c4:	01248563          	beq	s1,s2,800017ce <exit+0x58>
    if(p->ofile[fd]){
    800017c8:	6088                	ld	a0,0(s1)
    800017ca:	f575                	bnez	a0,800017b6 <exit+0x40>
    800017cc:	bfdd                	j	800017c2 <exit+0x4c>
  begin_op();
    800017ce:	00002097          	auipc	ra,0x2
    800017d2:	d46080e7          	jalr	-698(ra) # 80003514 <begin_op>
  iput(p->cwd);
    800017d6:	1509b503          	ld	a0,336(s3)
    800017da:	00001097          	auipc	ra,0x1
    800017de:	518080e7          	jalr	1304(ra) # 80002cf2 <iput>
  end_op();
    800017e2:	00002097          	auipc	ra,0x2
    800017e6:	db0080e7          	jalr	-592(ra) # 80003592 <end_op>
  p->cwd = 0;
    800017ea:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    800017ee:	00008497          	auipc	s1,0x8
    800017f2:	87a48493          	addi	s1,s1,-1926 # 80009068 <wait_lock>
    800017f6:	8526                	mv	a0,s1
    800017f8:	00005097          	auipc	ra,0x5
    800017fc:	8f0080e7          	jalr	-1808(ra) # 800060e8 <acquire>
  reparent(p);
    80001800:	854e                	mv	a0,s3
    80001802:	00000097          	auipc	ra,0x0
    80001806:	f1a080e7          	jalr	-230(ra) # 8000171c <reparent>
  wakeup(p->parent);
    8000180a:	0389b503          	ld	a0,56(s3)
    8000180e:	00000097          	auipc	ra,0x0
    80001812:	e98080e7          	jalr	-360(ra) # 800016a6 <wakeup>
  acquire(&p->lock);
    80001816:	854e                	mv	a0,s3
    80001818:	00005097          	auipc	ra,0x5
    8000181c:	8d0080e7          	jalr	-1840(ra) # 800060e8 <acquire>
  p->xstate = status;
    80001820:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    80001824:	4795                	li	a5,5
    80001826:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    8000182a:	8526                	mv	a0,s1
    8000182c:	00005097          	auipc	ra,0x5
    80001830:	970080e7          	jalr	-1680(ra) # 8000619c <release>
  sched();
    80001834:	00000097          	auipc	ra,0x0
    80001838:	bd4080e7          	jalr	-1068(ra) # 80001408 <sched>
  panic("zombie exit");
    8000183c:	00007517          	auipc	a0,0x7
    80001840:	9b450513          	addi	a0,a0,-1612 # 800081f0 <etext+0x1f0>
    80001844:	00004097          	auipc	ra,0x4
    80001848:	36c080e7          	jalr	876(ra) # 80005bb0 <panic>

000000008000184c <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    8000184c:	7179                	addi	sp,sp,-48
    8000184e:	f406                	sd	ra,40(sp)
    80001850:	f022                	sd	s0,32(sp)
    80001852:	ec26                	sd	s1,24(sp)
    80001854:	e84a                	sd	s2,16(sp)
    80001856:	e44e                	sd	s3,8(sp)
    80001858:	1800                	addi	s0,sp,48
    8000185a:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    8000185c:	00008497          	auipc	s1,0x8
    80001860:	c2448493          	addi	s1,s1,-988 # 80009480 <proc>
    80001864:	0000e997          	auipc	s3,0xe
    80001868:	c1c98993          	addi	s3,s3,-996 # 8000f480 <tickslock>
    acquire(&p->lock);
    8000186c:	8526                	mv	a0,s1
    8000186e:	00005097          	auipc	ra,0x5
    80001872:	87a080e7          	jalr	-1926(ra) # 800060e8 <acquire>
    if(p->pid == pid){
    80001876:	589c                	lw	a5,48(s1)
    80001878:	01278d63          	beq	a5,s2,80001892 <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    8000187c:	8526                	mv	a0,s1
    8000187e:	00005097          	auipc	ra,0x5
    80001882:	91e080e7          	jalr	-1762(ra) # 8000619c <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80001886:	18048493          	addi	s1,s1,384
    8000188a:	ff3491e3          	bne	s1,s3,8000186c <kill+0x20>
  }
  return -1;
    8000188e:	557d                	li	a0,-1
    80001890:	a829                	j	800018aa <kill+0x5e>
      p->killed = 1;
    80001892:	4785                	li	a5,1
    80001894:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    80001896:	4c98                	lw	a4,24(s1)
    80001898:	4789                	li	a5,2
    8000189a:	00f70f63          	beq	a4,a5,800018b8 <kill+0x6c>
      release(&p->lock);
    8000189e:	8526                	mv	a0,s1
    800018a0:	00005097          	auipc	ra,0x5
    800018a4:	8fc080e7          	jalr	-1796(ra) # 8000619c <release>
      return 0;
    800018a8:	4501                	li	a0,0
}
    800018aa:	70a2                	ld	ra,40(sp)
    800018ac:	7402                	ld	s0,32(sp)
    800018ae:	64e2                	ld	s1,24(sp)
    800018b0:	6942                	ld	s2,16(sp)
    800018b2:	69a2                	ld	s3,8(sp)
    800018b4:	6145                	addi	sp,sp,48
    800018b6:	8082                	ret
        p->state = RUNNABLE;
    800018b8:	478d                	li	a5,3
    800018ba:	cc9c                	sw	a5,24(s1)
    800018bc:	b7cd                	j	8000189e <kill+0x52>

00000000800018be <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    800018be:	7179                	addi	sp,sp,-48
    800018c0:	f406                	sd	ra,40(sp)
    800018c2:	f022                	sd	s0,32(sp)
    800018c4:	ec26                	sd	s1,24(sp)
    800018c6:	e84a                	sd	s2,16(sp)
    800018c8:	e44e                	sd	s3,8(sp)
    800018ca:	e052                	sd	s4,0(sp)
    800018cc:	1800                	addi	s0,sp,48
    800018ce:	84aa                	mv	s1,a0
    800018d0:	892e                	mv	s2,a1
    800018d2:	89b2                	mv	s3,a2
    800018d4:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800018d6:	fffff097          	auipc	ra,0xfffff
    800018da:	56e080e7          	jalr	1390(ra) # 80000e44 <myproc>
  if(user_dst){
    800018de:	c08d                	beqz	s1,80001900 <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    800018e0:	86d2                	mv	a3,s4
    800018e2:	864e                	mv	a2,s3
    800018e4:	85ca                	mv	a1,s2
    800018e6:	6928                	ld	a0,80(a0)
    800018e8:	fffff097          	auipc	ra,0xfffff
    800018ec:	220080e7          	jalr	544(ra) # 80000b08 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    800018f0:	70a2                	ld	ra,40(sp)
    800018f2:	7402                	ld	s0,32(sp)
    800018f4:	64e2                	ld	s1,24(sp)
    800018f6:	6942                	ld	s2,16(sp)
    800018f8:	69a2                	ld	s3,8(sp)
    800018fa:	6a02                	ld	s4,0(sp)
    800018fc:	6145                	addi	sp,sp,48
    800018fe:	8082                	ret
    memmove((char *)dst, src, len);
    80001900:	000a061b          	sext.w	a2,s4
    80001904:	85ce                	mv	a1,s3
    80001906:	854a                	mv	a0,s2
    80001908:	fffff097          	auipc	ra,0xfffff
    8000190c:	8ce080e7          	jalr	-1842(ra) # 800001d6 <memmove>
    return 0;
    80001910:	8526                	mv	a0,s1
    80001912:	bff9                	j	800018f0 <either_copyout+0x32>

0000000080001914 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80001914:	7179                	addi	sp,sp,-48
    80001916:	f406                	sd	ra,40(sp)
    80001918:	f022                	sd	s0,32(sp)
    8000191a:	ec26                	sd	s1,24(sp)
    8000191c:	e84a                	sd	s2,16(sp)
    8000191e:	e44e                	sd	s3,8(sp)
    80001920:	e052                	sd	s4,0(sp)
    80001922:	1800                	addi	s0,sp,48
    80001924:	892a                	mv	s2,a0
    80001926:	84ae                	mv	s1,a1
    80001928:	89b2                	mv	s3,a2
    8000192a:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    8000192c:	fffff097          	auipc	ra,0xfffff
    80001930:	518080e7          	jalr	1304(ra) # 80000e44 <myproc>
  if(user_src){
    80001934:	c08d                	beqz	s1,80001956 <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    80001936:	86d2                	mv	a3,s4
    80001938:	864e                	mv	a2,s3
    8000193a:	85ca                	mv	a1,s2
    8000193c:	6928                	ld	a0,80(a0)
    8000193e:	fffff097          	auipc	ra,0xfffff
    80001942:	256080e7          	jalr	598(ra) # 80000b94 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80001946:	70a2                	ld	ra,40(sp)
    80001948:	7402                	ld	s0,32(sp)
    8000194a:	64e2                	ld	s1,24(sp)
    8000194c:	6942                	ld	s2,16(sp)
    8000194e:	69a2                	ld	s3,8(sp)
    80001950:	6a02                	ld	s4,0(sp)
    80001952:	6145                	addi	sp,sp,48
    80001954:	8082                	ret
    memmove(dst, (char*)src, len);
    80001956:	000a061b          	sext.w	a2,s4
    8000195a:	85ce                	mv	a1,s3
    8000195c:	854a                	mv	a0,s2
    8000195e:	fffff097          	auipc	ra,0xfffff
    80001962:	878080e7          	jalr	-1928(ra) # 800001d6 <memmove>
    return 0;
    80001966:	8526                	mv	a0,s1
    80001968:	bff9                	j	80001946 <either_copyin+0x32>

000000008000196a <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    8000196a:	715d                	addi	sp,sp,-80
    8000196c:	e486                	sd	ra,72(sp)
    8000196e:	e0a2                	sd	s0,64(sp)
    80001970:	fc26                	sd	s1,56(sp)
    80001972:	f84a                	sd	s2,48(sp)
    80001974:	f44e                	sd	s3,40(sp)
    80001976:	f052                	sd	s4,32(sp)
    80001978:	ec56                	sd	s5,24(sp)
    8000197a:	e85a                	sd	s6,16(sp)
    8000197c:	e45e                	sd	s7,8(sp)
    8000197e:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80001980:	00006517          	auipc	a0,0x6
    80001984:	6c850513          	addi	a0,a0,1736 # 80008048 <etext+0x48>
    80001988:	00004097          	auipc	ra,0x4
    8000198c:	272080e7          	jalr	626(ra) # 80005bfa <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001990:	00008497          	auipc	s1,0x8
    80001994:	c4848493          	addi	s1,s1,-952 # 800095d8 <proc+0x158>
    80001998:	0000e917          	auipc	s2,0xe
    8000199c:	c4090913          	addi	s2,s2,-960 # 8000f5d8 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800019a0:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    800019a2:	00007997          	auipc	s3,0x7
    800019a6:	85e98993          	addi	s3,s3,-1954 # 80008200 <etext+0x200>
    printf("%d %s %s", p->pid, state, p->name);
    800019aa:	00007a97          	auipc	s5,0x7
    800019ae:	85ea8a93          	addi	s5,s5,-1954 # 80008208 <etext+0x208>
    printf("\n");
    800019b2:	00006a17          	auipc	s4,0x6
    800019b6:	696a0a13          	addi	s4,s4,1686 # 80008048 <etext+0x48>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800019ba:	00007b97          	auipc	s7,0x7
    800019be:	886b8b93          	addi	s7,s7,-1914 # 80008240 <states.0>
    800019c2:	a00d                	j	800019e4 <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    800019c4:	ed86a583          	lw	a1,-296(a3)
    800019c8:	8556                	mv	a0,s5
    800019ca:	00004097          	auipc	ra,0x4
    800019ce:	230080e7          	jalr	560(ra) # 80005bfa <printf>
    printf("\n");
    800019d2:	8552                	mv	a0,s4
    800019d4:	00004097          	auipc	ra,0x4
    800019d8:	226080e7          	jalr	550(ra) # 80005bfa <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800019dc:	18048493          	addi	s1,s1,384
    800019e0:	03248263          	beq	s1,s2,80001a04 <procdump+0x9a>
    if(p->state == UNUSED)
    800019e4:	86a6                	mv	a3,s1
    800019e6:	ec04a783          	lw	a5,-320(s1)
    800019ea:	dbed                	beqz	a5,800019dc <procdump+0x72>
      state = "???";
    800019ec:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800019ee:	fcfb6be3          	bltu	s6,a5,800019c4 <procdump+0x5a>
    800019f2:	02079713          	slli	a4,a5,0x20
    800019f6:	01d75793          	srli	a5,a4,0x1d
    800019fa:	97de                	add	a5,a5,s7
    800019fc:	6390                	ld	a2,0(a5)
    800019fe:	f279                	bnez	a2,800019c4 <procdump+0x5a>
      state = "???";
    80001a00:	864e                	mv	a2,s3
    80001a02:	b7c9                	j	800019c4 <procdump+0x5a>
  }
}
    80001a04:	60a6                	ld	ra,72(sp)
    80001a06:	6406                	ld	s0,64(sp)
    80001a08:	74e2                	ld	s1,56(sp)
    80001a0a:	7942                	ld	s2,48(sp)
    80001a0c:	79a2                	ld	s3,40(sp)
    80001a0e:	7a02                	ld	s4,32(sp)
    80001a10:	6ae2                	ld	s5,24(sp)
    80001a12:	6b42                	ld	s6,16(sp)
    80001a14:	6ba2                	ld	s7,8(sp)
    80001a16:	6161                	addi	sp,sp,80
    80001a18:	8082                	ret

0000000080001a1a <swtch>:
    80001a1a:	00153023          	sd	ra,0(a0)
    80001a1e:	00253423          	sd	sp,8(a0)
    80001a22:	e900                	sd	s0,16(a0)
    80001a24:	ed04                	sd	s1,24(a0)
    80001a26:	03253023          	sd	s2,32(a0)
    80001a2a:	03353423          	sd	s3,40(a0)
    80001a2e:	03453823          	sd	s4,48(a0)
    80001a32:	03553c23          	sd	s5,56(a0)
    80001a36:	05653023          	sd	s6,64(a0)
    80001a3a:	05753423          	sd	s7,72(a0)
    80001a3e:	05853823          	sd	s8,80(a0)
    80001a42:	05953c23          	sd	s9,88(a0)
    80001a46:	07a53023          	sd	s10,96(a0)
    80001a4a:	07b53423          	sd	s11,104(a0)
    80001a4e:	0005b083          	ld	ra,0(a1)
    80001a52:	0085b103          	ld	sp,8(a1)
    80001a56:	6980                	ld	s0,16(a1)
    80001a58:	6d84                	ld	s1,24(a1)
    80001a5a:	0205b903          	ld	s2,32(a1)
    80001a5e:	0285b983          	ld	s3,40(a1)
    80001a62:	0305ba03          	ld	s4,48(a1)
    80001a66:	0385ba83          	ld	s5,56(a1)
    80001a6a:	0405bb03          	ld	s6,64(a1)
    80001a6e:	0485bb83          	ld	s7,72(a1)
    80001a72:	0505bc03          	ld	s8,80(a1)
    80001a76:	0585bc83          	ld	s9,88(a1)
    80001a7a:	0605bd03          	ld	s10,96(a1)
    80001a7e:	0685bd83          	ld	s11,104(a1)
    80001a82:	8082                	ret

0000000080001a84 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001a84:	1141                	addi	sp,sp,-16
    80001a86:	e406                	sd	ra,8(sp)
    80001a88:	e022                	sd	s0,0(sp)
    80001a8a:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001a8c:	00006597          	auipc	a1,0x6
    80001a90:	7e458593          	addi	a1,a1,2020 # 80008270 <states.0+0x30>
    80001a94:	0000e517          	auipc	a0,0xe
    80001a98:	9ec50513          	addi	a0,a0,-1556 # 8000f480 <tickslock>
    80001a9c:	00004097          	auipc	ra,0x4
    80001aa0:	5bc080e7          	jalr	1468(ra) # 80006058 <initlock>
}
    80001aa4:	60a2                	ld	ra,8(sp)
    80001aa6:	6402                	ld	s0,0(sp)
    80001aa8:	0141                	addi	sp,sp,16
    80001aaa:	8082                	ret

0000000080001aac <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001aac:	1141                	addi	sp,sp,-16
    80001aae:	e422                	sd	s0,8(sp)
    80001ab0:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001ab2:	00003797          	auipc	a5,0x3
    80001ab6:	55e78793          	addi	a5,a5,1374 # 80005010 <kernelvec>
    80001aba:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001abe:	6422                	ld	s0,8(sp)
    80001ac0:	0141                	addi	sp,sp,16
    80001ac2:	8082                	ret

0000000080001ac4 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001ac4:	1141                	addi	sp,sp,-16
    80001ac6:	e406                	sd	ra,8(sp)
    80001ac8:	e022                	sd	s0,0(sp)
    80001aca:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001acc:	fffff097          	auipc	ra,0xfffff
    80001ad0:	378080e7          	jalr	888(ra) # 80000e44 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001ad4:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001ad8:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001ada:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    80001ade:	00005697          	auipc	a3,0x5
    80001ae2:	52268693          	addi	a3,a3,1314 # 80007000 <_trampoline>
    80001ae6:	00005717          	auipc	a4,0x5
    80001aea:	51a70713          	addi	a4,a4,1306 # 80007000 <_trampoline>
    80001aee:	8f15                	sub	a4,a4,a3
    80001af0:	040007b7          	lui	a5,0x4000
    80001af4:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80001af6:	07b2                	slli	a5,a5,0xc
    80001af8:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001afa:	10571073          	csrw	stvec,a4

  // set up trapframe values that uservec will need when
  // the process next re-enters the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001afe:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001b00:	18002673          	csrr	a2,satp
    80001b04:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001b06:	6d30                	ld	a2,88(a0)
    80001b08:	6138                	ld	a4,64(a0)
    80001b0a:	6585                	lui	a1,0x1
    80001b0c:	972e                	add	a4,a4,a1
    80001b0e:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001b10:	6d38                	ld	a4,88(a0)
    80001b12:	00000617          	auipc	a2,0x0
    80001b16:	13860613          	addi	a2,a2,312 # 80001c4a <usertrap>
    80001b1a:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001b1c:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001b1e:	8612                	mv	a2,tp
    80001b20:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b22:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001b26:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001b2a:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001b2e:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001b32:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001b34:	6f18                	ld	a4,24(a4)
    80001b36:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001b3a:	692c                	ld	a1,80(a0)
    80001b3c:	81b1                	srli	a1,a1,0xc

  // jump to trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    80001b3e:	00005717          	auipc	a4,0x5
    80001b42:	55270713          	addi	a4,a4,1362 # 80007090 <userret>
    80001b46:	8f15                	sub	a4,a4,a3
    80001b48:	97ba                	add	a5,a5,a4
  ((void (*)(uint64,uint64))fn)(TRAPFRAME, satp);
    80001b4a:	577d                	li	a4,-1
    80001b4c:	177e                	slli	a4,a4,0x3f
    80001b4e:	8dd9                	or	a1,a1,a4
    80001b50:	02000537          	lui	a0,0x2000
    80001b54:	157d                	addi	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    80001b56:	0536                	slli	a0,a0,0xd
    80001b58:	9782                	jalr	a5
}
    80001b5a:	60a2                	ld	ra,8(sp)
    80001b5c:	6402                	ld	s0,0(sp)
    80001b5e:	0141                	addi	sp,sp,16
    80001b60:	8082                	ret

0000000080001b62 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001b62:	1101                	addi	sp,sp,-32
    80001b64:	ec06                	sd	ra,24(sp)
    80001b66:	e822                	sd	s0,16(sp)
    80001b68:	e426                	sd	s1,8(sp)
    80001b6a:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001b6c:	0000e497          	auipc	s1,0xe
    80001b70:	91448493          	addi	s1,s1,-1772 # 8000f480 <tickslock>
    80001b74:	8526                	mv	a0,s1
    80001b76:	00004097          	auipc	ra,0x4
    80001b7a:	572080e7          	jalr	1394(ra) # 800060e8 <acquire>
  ticks++;
    80001b7e:	00007517          	auipc	a0,0x7
    80001b82:	49a50513          	addi	a0,a0,1178 # 80009018 <ticks>
    80001b86:	411c                	lw	a5,0(a0)
    80001b88:	2785                	addiw	a5,a5,1
    80001b8a:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001b8c:	00000097          	auipc	ra,0x0
    80001b90:	b1a080e7          	jalr	-1254(ra) # 800016a6 <wakeup>
  release(&tickslock);
    80001b94:	8526                	mv	a0,s1
    80001b96:	00004097          	auipc	ra,0x4
    80001b9a:	606080e7          	jalr	1542(ra) # 8000619c <release>
}
    80001b9e:	60e2                	ld	ra,24(sp)
    80001ba0:	6442                	ld	s0,16(sp)
    80001ba2:	64a2                	ld	s1,8(sp)
    80001ba4:	6105                	addi	sp,sp,32
    80001ba6:	8082                	ret

0000000080001ba8 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80001ba8:	1101                	addi	sp,sp,-32
    80001baa:	ec06                	sd	ra,24(sp)
    80001bac:	e822                	sd	s0,16(sp)
    80001bae:	e426                	sd	s1,8(sp)
    80001bb0:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001bb2:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    80001bb6:	00074d63          	bltz	a4,80001bd0 <devintr+0x28>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000001L){
    80001bba:	57fd                	li	a5,-1
    80001bbc:	17fe                	slli	a5,a5,0x3f
    80001bbe:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001bc0:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001bc2:	06f70363          	beq	a4,a5,80001c28 <devintr+0x80>
  }
}
    80001bc6:	60e2                	ld	ra,24(sp)
    80001bc8:	6442                	ld	s0,16(sp)
    80001bca:	64a2                	ld	s1,8(sp)
    80001bcc:	6105                	addi	sp,sp,32
    80001bce:	8082                	ret
     (scause & 0xff) == 9){
    80001bd0:	0ff77793          	zext.b	a5,a4
  if((scause & 0x8000000000000000L) &&
    80001bd4:	46a5                	li	a3,9
    80001bd6:	fed792e3          	bne	a5,a3,80001bba <devintr+0x12>
    int irq = plic_claim();
    80001bda:	00003097          	auipc	ra,0x3
    80001bde:	53e080e7          	jalr	1342(ra) # 80005118 <plic_claim>
    80001be2:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001be4:	47a9                	li	a5,10
    80001be6:	02f50763          	beq	a0,a5,80001c14 <devintr+0x6c>
    } else if(irq == VIRTIO0_IRQ){
    80001bea:	4785                	li	a5,1
    80001bec:	02f50963          	beq	a0,a5,80001c1e <devintr+0x76>
    return 1;
    80001bf0:	4505                	li	a0,1
    } else if(irq){
    80001bf2:	d8f1                	beqz	s1,80001bc6 <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    80001bf4:	85a6                	mv	a1,s1
    80001bf6:	00006517          	auipc	a0,0x6
    80001bfa:	68250513          	addi	a0,a0,1666 # 80008278 <states.0+0x38>
    80001bfe:	00004097          	auipc	ra,0x4
    80001c02:	ffc080e7          	jalr	-4(ra) # 80005bfa <printf>
      plic_complete(irq);
    80001c06:	8526                	mv	a0,s1
    80001c08:	00003097          	auipc	ra,0x3
    80001c0c:	534080e7          	jalr	1332(ra) # 8000513c <plic_complete>
    return 1;
    80001c10:	4505                	li	a0,1
    80001c12:	bf55                	j	80001bc6 <devintr+0x1e>
      uartintr();
    80001c14:	00004097          	auipc	ra,0x4
    80001c18:	3f4080e7          	jalr	1012(ra) # 80006008 <uartintr>
    80001c1c:	b7ed                	j	80001c06 <devintr+0x5e>
      virtio_disk_intr();
    80001c1e:	00004097          	auipc	ra,0x4
    80001c22:	9aa080e7          	jalr	-1622(ra) # 800055c8 <virtio_disk_intr>
    80001c26:	b7c5                	j	80001c06 <devintr+0x5e>
    if(cpuid() == 0){
    80001c28:	fffff097          	auipc	ra,0xfffff
    80001c2c:	1f0080e7          	jalr	496(ra) # 80000e18 <cpuid>
    80001c30:	c901                	beqz	a0,80001c40 <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001c32:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001c36:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001c38:	14479073          	csrw	sip,a5
    return 2;
    80001c3c:	4509                	li	a0,2
    80001c3e:	b761                	j	80001bc6 <devintr+0x1e>
      clockintr();
    80001c40:	00000097          	auipc	ra,0x0
    80001c44:	f22080e7          	jalr	-222(ra) # 80001b62 <clockintr>
    80001c48:	b7ed                	j	80001c32 <devintr+0x8a>

0000000080001c4a <usertrap>:
{
    80001c4a:	1101                	addi	sp,sp,-32
    80001c4c:	ec06                	sd	ra,24(sp)
    80001c4e:	e822                	sd	s0,16(sp)
    80001c50:	e426                	sd	s1,8(sp)
    80001c52:	e04a                	sd	s2,0(sp)
    80001c54:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001c56:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001c5a:	1007f793          	andi	a5,a5,256
    80001c5e:	e3ad                	bnez	a5,80001cc0 <usertrap+0x76>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001c60:	00003797          	auipc	a5,0x3
    80001c64:	3b078793          	addi	a5,a5,944 # 80005010 <kernelvec>
    80001c68:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001c6c:	fffff097          	auipc	ra,0xfffff
    80001c70:	1d8080e7          	jalr	472(ra) # 80000e44 <myproc>
    80001c74:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001c76:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001c78:	14102773          	csrr	a4,sepc
    80001c7c:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001c7e:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001c82:	47a1                	li	a5,8
    80001c84:	04f71c63          	bne	a4,a5,80001cdc <usertrap+0x92>
    if(p->killed)
    80001c88:	551c                	lw	a5,40(a0)
    80001c8a:	e3b9                	bnez	a5,80001cd0 <usertrap+0x86>
    p->trapframe->epc += 4;
    80001c8c:	6cb8                	ld	a4,88(s1)
    80001c8e:	6f1c                	ld	a5,24(a4)
    80001c90:	0791                	addi	a5,a5,4
    80001c92:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001c94:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001c98:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001c9c:	10079073          	csrw	sstatus,a5
    syscall();
    80001ca0:	00000097          	auipc	ra,0x0
    80001ca4:	2e0080e7          	jalr	736(ra) # 80001f80 <syscall>
  if(p->killed)
    80001ca8:	549c                	lw	a5,40(s1)
    80001caa:	ebc1                	bnez	a5,80001d3a <usertrap+0xf0>
  usertrapret();
    80001cac:	00000097          	auipc	ra,0x0
    80001cb0:	e18080e7          	jalr	-488(ra) # 80001ac4 <usertrapret>
}
    80001cb4:	60e2                	ld	ra,24(sp)
    80001cb6:	6442                	ld	s0,16(sp)
    80001cb8:	64a2                	ld	s1,8(sp)
    80001cba:	6902                	ld	s2,0(sp)
    80001cbc:	6105                	addi	sp,sp,32
    80001cbe:	8082                	ret
    panic("usertrap: not from user mode");
    80001cc0:	00006517          	auipc	a0,0x6
    80001cc4:	5d850513          	addi	a0,a0,1496 # 80008298 <states.0+0x58>
    80001cc8:	00004097          	auipc	ra,0x4
    80001ccc:	ee8080e7          	jalr	-280(ra) # 80005bb0 <panic>
      exit(-1);
    80001cd0:	557d                	li	a0,-1
    80001cd2:	00000097          	auipc	ra,0x0
    80001cd6:	aa4080e7          	jalr	-1372(ra) # 80001776 <exit>
    80001cda:	bf4d                	j	80001c8c <usertrap+0x42>
  } else if((which_dev = devintr()) != 0){
    80001cdc:	00000097          	auipc	ra,0x0
    80001ce0:	ecc080e7          	jalr	-308(ra) # 80001ba8 <devintr>
    80001ce4:	892a                	mv	s2,a0
    80001ce6:	c501                	beqz	a0,80001cee <usertrap+0xa4>
  if(p->killed)
    80001ce8:	549c                	lw	a5,40(s1)
    80001cea:	c3a1                	beqz	a5,80001d2a <usertrap+0xe0>
    80001cec:	a815                	j	80001d20 <usertrap+0xd6>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001cee:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001cf2:	5890                	lw	a2,48(s1)
    80001cf4:	00006517          	auipc	a0,0x6
    80001cf8:	5c450513          	addi	a0,a0,1476 # 800082b8 <states.0+0x78>
    80001cfc:	00004097          	auipc	ra,0x4
    80001d00:	efe080e7          	jalr	-258(ra) # 80005bfa <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001d04:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001d08:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001d0c:	00006517          	auipc	a0,0x6
    80001d10:	5dc50513          	addi	a0,a0,1500 # 800082e8 <states.0+0xa8>
    80001d14:	00004097          	auipc	ra,0x4
    80001d18:	ee6080e7          	jalr	-282(ra) # 80005bfa <printf>
    p->killed = 1;
    80001d1c:	4785                	li	a5,1
    80001d1e:	d49c                	sw	a5,40(s1)
    exit(-1);
    80001d20:	557d                	li	a0,-1
    80001d22:	00000097          	auipc	ra,0x0
    80001d26:	a54080e7          	jalr	-1452(ra) # 80001776 <exit>
  if(which_dev == 2)
    80001d2a:	4789                	li	a5,2
    80001d2c:	f8f910e3          	bne	s2,a5,80001cac <usertrap+0x62>
    yield();
    80001d30:	fffff097          	auipc	ra,0xfffff
    80001d34:	7ae080e7          	jalr	1966(ra) # 800014de <yield>
    80001d38:	bf95                	j	80001cac <usertrap+0x62>
  int which_dev = 0;
    80001d3a:	4901                	li	s2,0
    80001d3c:	b7d5                	j	80001d20 <usertrap+0xd6>

0000000080001d3e <kerneltrap>:
{
    80001d3e:	7179                	addi	sp,sp,-48
    80001d40:	f406                	sd	ra,40(sp)
    80001d42:	f022                	sd	s0,32(sp)
    80001d44:	ec26                	sd	s1,24(sp)
    80001d46:	e84a                	sd	s2,16(sp)
    80001d48:	e44e                	sd	s3,8(sp)
    80001d4a:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001d4c:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d50:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001d54:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001d58:	1004f793          	andi	a5,s1,256
    80001d5c:	cb85                	beqz	a5,80001d8c <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d5e:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001d62:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001d64:	ef85                	bnez	a5,80001d9c <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80001d66:	00000097          	auipc	ra,0x0
    80001d6a:	e42080e7          	jalr	-446(ra) # 80001ba8 <devintr>
    80001d6e:	cd1d                	beqz	a0,80001dac <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001d70:	4789                	li	a5,2
    80001d72:	06f50a63          	beq	a0,a5,80001de6 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001d76:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001d7a:	10049073          	csrw	sstatus,s1
}
    80001d7e:	70a2                	ld	ra,40(sp)
    80001d80:	7402                	ld	s0,32(sp)
    80001d82:	64e2                	ld	s1,24(sp)
    80001d84:	6942                	ld	s2,16(sp)
    80001d86:	69a2                	ld	s3,8(sp)
    80001d88:	6145                	addi	sp,sp,48
    80001d8a:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001d8c:	00006517          	auipc	a0,0x6
    80001d90:	57c50513          	addi	a0,a0,1404 # 80008308 <states.0+0xc8>
    80001d94:	00004097          	auipc	ra,0x4
    80001d98:	e1c080e7          	jalr	-484(ra) # 80005bb0 <panic>
    panic("kerneltrap: interrupts enabled");
    80001d9c:	00006517          	auipc	a0,0x6
    80001da0:	59450513          	addi	a0,a0,1428 # 80008330 <states.0+0xf0>
    80001da4:	00004097          	auipc	ra,0x4
    80001da8:	e0c080e7          	jalr	-500(ra) # 80005bb0 <panic>
    printf("scause %p\n", scause);
    80001dac:	85ce                	mv	a1,s3
    80001dae:	00006517          	auipc	a0,0x6
    80001db2:	5a250513          	addi	a0,a0,1442 # 80008350 <states.0+0x110>
    80001db6:	00004097          	auipc	ra,0x4
    80001dba:	e44080e7          	jalr	-444(ra) # 80005bfa <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001dbe:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001dc2:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001dc6:	00006517          	auipc	a0,0x6
    80001dca:	59a50513          	addi	a0,a0,1434 # 80008360 <states.0+0x120>
    80001dce:	00004097          	auipc	ra,0x4
    80001dd2:	e2c080e7          	jalr	-468(ra) # 80005bfa <printf>
    panic("kerneltrap");
    80001dd6:	00006517          	auipc	a0,0x6
    80001dda:	5a250513          	addi	a0,a0,1442 # 80008378 <states.0+0x138>
    80001dde:	00004097          	auipc	ra,0x4
    80001de2:	dd2080e7          	jalr	-558(ra) # 80005bb0 <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001de6:	fffff097          	auipc	ra,0xfffff
    80001dea:	05e080e7          	jalr	94(ra) # 80000e44 <myproc>
    80001dee:	d541                	beqz	a0,80001d76 <kerneltrap+0x38>
    80001df0:	fffff097          	auipc	ra,0xfffff
    80001df4:	054080e7          	jalr	84(ra) # 80000e44 <myproc>
    80001df8:	4d18                	lw	a4,24(a0)
    80001dfa:	4791                	li	a5,4
    80001dfc:	f6f71de3          	bne	a4,a5,80001d76 <kerneltrap+0x38>
    yield();
    80001e00:	fffff097          	auipc	ra,0xfffff
    80001e04:	6de080e7          	jalr	1758(ra) # 800014de <yield>
    80001e08:	b7bd                	j	80001d76 <kerneltrap+0x38>

0000000080001e0a <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001e0a:	1101                	addi	sp,sp,-32
    80001e0c:	ec06                	sd	ra,24(sp)
    80001e0e:	e822                	sd	s0,16(sp)
    80001e10:	e426                	sd	s1,8(sp)
    80001e12:	1000                	addi	s0,sp,32
    80001e14:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001e16:	fffff097          	auipc	ra,0xfffff
    80001e1a:	02e080e7          	jalr	46(ra) # 80000e44 <myproc>
  switch (n) {
    80001e1e:	4795                	li	a5,5
    80001e20:	0497e163          	bltu	a5,s1,80001e62 <argraw+0x58>
    80001e24:	048a                	slli	s1,s1,0x2
    80001e26:	00006717          	auipc	a4,0x6
    80001e2a:	64a70713          	addi	a4,a4,1610 # 80008470 <states.0+0x230>
    80001e2e:	94ba                	add	s1,s1,a4
    80001e30:	409c                	lw	a5,0(s1)
    80001e32:	97ba                	add	a5,a5,a4
    80001e34:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001e36:	6d3c                	ld	a5,88(a0)
    80001e38:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001e3a:	60e2                	ld	ra,24(sp)
    80001e3c:	6442                	ld	s0,16(sp)
    80001e3e:	64a2                	ld	s1,8(sp)
    80001e40:	6105                	addi	sp,sp,32
    80001e42:	8082                	ret
    return p->trapframe->a1;
    80001e44:	6d3c                	ld	a5,88(a0)
    80001e46:	7fa8                	ld	a0,120(a5)
    80001e48:	bfcd                	j	80001e3a <argraw+0x30>
    return p->trapframe->a2;
    80001e4a:	6d3c                	ld	a5,88(a0)
    80001e4c:	63c8                	ld	a0,128(a5)
    80001e4e:	b7f5                	j	80001e3a <argraw+0x30>
    return p->trapframe->a3;
    80001e50:	6d3c                	ld	a5,88(a0)
    80001e52:	67c8                	ld	a0,136(a5)
    80001e54:	b7dd                	j	80001e3a <argraw+0x30>
    return p->trapframe->a4;
    80001e56:	6d3c                	ld	a5,88(a0)
    80001e58:	6bc8                	ld	a0,144(a5)
    80001e5a:	b7c5                	j	80001e3a <argraw+0x30>
    return p->trapframe->a5;
    80001e5c:	6d3c                	ld	a5,88(a0)
    80001e5e:	6fc8                	ld	a0,152(a5)
    80001e60:	bfe9                	j	80001e3a <argraw+0x30>
  panic("argraw");
    80001e62:	00006517          	auipc	a0,0x6
    80001e66:	52650513          	addi	a0,a0,1318 # 80008388 <states.0+0x148>
    80001e6a:	00004097          	auipc	ra,0x4
    80001e6e:	d46080e7          	jalr	-698(ra) # 80005bb0 <panic>

0000000080001e72 <fetchaddr>:
{
    80001e72:	1101                	addi	sp,sp,-32
    80001e74:	ec06                	sd	ra,24(sp)
    80001e76:	e822                	sd	s0,16(sp)
    80001e78:	e426                	sd	s1,8(sp)
    80001e7a:	e04a                	sd	s2,0(sp)
    80001e7c:	1000                	addi	s0,sp,32
    80001e7e:	84aa                	mv	s1,a0
    80001e80:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001e82:	fffff097          	auipc	ra,0xfffff
    80001e86:	fc2080e7          	jalr	-62(ra) # 80000e44 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz)
    80001e8a:	653c                	ld	a5,72(a0)
    80001e8c:	02f4f863          	bgeu	s1,a5,80001ebc <fetchaddr+0x4a>
    80001e90:	00848713          	addi	a4,s1,8
    80001e94:	02e7e663          	bltu	a5,a4,80001ec0 <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80001e98:	46a1                	li	a3,8
    80001e9a:	8626                	mv	a2,s1
    80001e9c:	85ca                	mv	a1,s2
    80001e9e:	6928                	ld	a0,80(a0)
    80001ea0:	fffff097          	auipc	ra,0xfffff
    80001ea4:	cf4080e7          	jalr	-780(ra) # 80000b94 <copyin>
    80001ea8:	00a03533          	snez	a0,a0
    80001eac:	40a00533          	neg	a0,a0
}
    80001eb0:	60e2                	ld	ra,24(sp)
    80001eb2:	6442                	ld	s0,16(sp)
    80001eb4:	64a2                	ld	s1,8(sp)
    80001eb6:	6902                	ld	s2,0(sp)
    80001eb8:	6105                	addi	sp,sp,32
    80001eba:	8082                	ret
    return -1;
    80001ebc:	557d                	li	a0,-1
    80001ebe:	bfcd                	j	80001eb0 <fetchaddr+0x3e>
    80001ec0:	557d                	li	a0,-1
    80001ec2:	b7fd                	j	80001eb0 <fetchaddr+0x3e>

0000000080001ec4 <fetchstr>:
{
    80001ec4:	7179                	addi	sp,sp,-48
    80001ec6:	f406                	sd	ra,40(sp)
    80001ec8:	f022                	sd	s0,32(sp)
    80001eca:	ec26                	sd	s1,24(sp)
    80001ecc:	e84a                	sd	s2,16(sp)
    80001ece:	e44e                	sd	s3,8(sp)
    80001ed0:	1800                	addi	s0,sp,48
    80001ed2:	892a                	mv	s2,a0
    80001ed4:	84ae                	mv	s1,a1
    80001ed6:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80001ed8:	fffff097          	auipc	ra,0xfffff
    80001edc:	f6c080e7          	jalr	-148(ra) # 80000e44 <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    80001ee0:	86ce                	mv	a3,s3
    80001ee2:	864a                	mv	a2,s2
    80001ee4:	85a6                	mv	a1,s1
    80001ee6:	6928                	ld	a0,80(a0)
    80001ee8:	fffff097          	auipc	ra,0xfffff
    80001eec:	d3a080e7          	jalr	-710(ra) # 80000c22 <copyinstr>
  if(err < 0)
    80001ef0:	00054763          	bltz	a0,80001efe <fetchstr+0x3a>
  return strlen(buf);
    80001ef4:	8526                	mv	a0,s1
    80001ef6:	ffffe097          	auipc	ra,0xffffe
    80001efa:	400080e7          	jalr	1024(ra) # 800002f6 <strlen>
}
    80001efe:	70a2                	ld	ra,40(sp)
    80001f00:	7402                	ld	s0,32(sp)
    80001f02:	64e2                	ld	s1,24(sp)
    80001f04:	6942                	ld	s2,16(sp)
    80001f06:	69a2                	ld	s3,8(sp)
    80001f08:	6145                	addi	sp,sp,48
    80001f0a:	8082                	ret

0000000080001f0c <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    80001f0c:	1101                	addi	sp,sp,-32
    80001f0e:	ec06                	sd	ra,24(sp)
    80001f10:	e822                	sd	s0,16(sp)
    80001f12:	e426                	sd	s1,8(sp)
    80001f14:	1000                	addi	s0,sp,32
    80001f16:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001f18:	00000097          	auipc	ra,0x0
    80001f1c:	ef2080e7          	jalr	-270(ra) # 80001e0a <argraw>
    80001f20:	c088                	sw	a0,0(s1)
  return 0;
}
    80001f22:	4501                	li	a0,0
    80001f24:	60e2                	ld	ra,24(sp)
    80001f26:	6442                	ld	s0,16(sp)
    80001f28:	64a2                	ld	s1,8(sp)
    80001f2a:	6105                	addi	sp,sp,32
    80001f2c:	8082                	ret

0000000080001f2e <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    80001f2e:	1101                	addi	sp,sp,-32
    80001f30:	ec06                	sd	ra,24(sp)
    80001f32:	e822                	sd	s0,16(sp)
    80001f34:	e426                	sd	s1,8(sp)
    80001f36:	1000                	addi	s0,sp,32
    80001f38:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001f3a:	00000097          	auipc	ra,0x0
    80001f3e:	ed0080e7          	jalr	-304(ra) # 80001e0a <argraw>
    80001f42:	e088                	sd	a0,0(s1)
  return 0;
}
    80001f44:	4501                	li	a0,0
    80001f46:	60e2                	ld	ra,24(sp)
    80001f48:	6442                	ld	s0,16(sp)
    80001f4a:	64a2                	ld	s1,8(sp)
    80001f4c:	6105                	addi	sp,sp,32
    80001f4e:	8082                	ret

0000000080001f50 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80001f50:	1101                	addi	sp,sp,-32
    80001f52:	ec06                	sd	ra,24(sp)
    80001f54:	e822                	sd	s0,16(sp)
    80001f56:	e426                	sd	s1,8(sp)
    80001f58:	e04a                	sd	s2,0(sp)
    80001f5a:	1000                	addi	s0,sp,32
    80001f5c:	84ae                	mv	s1,a1
    80001f5e:	8932                	mv	s2,a2
  *ip = argraw(n);
    80001f60:	00000097          	auipc	ra,0x0
    80001f64:	eaa080e7          	jalr	-342(ra) # 80001e0a <argraw>
  uint64 addr;
  if(argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    80001f68:	864a                	mv	a2,s2
    80001f6a:	85a6                	mv	a1,s1
    80001f6c:	00000097          	auipc	ra,0x0
    80001f70:	f58080e7          	jalr	-168(ra) # 80001ec4 <fetchstr>
}
    80001f74:	60e2                	ld	ra,24(sp)
    80001f76:	6442                	ld	s0,16(sp)
    80001f78:	64a2                	ld	s1,8(sp)
    80001f7a:	6902                	ld	s2,0(sp)
    80001f7c:	6105                	addi	sp,sp,32
    80001f7e:	8082                	ret

0000000080001f80 <syscall>:
				"write","mknod","unlink","link","mkdir",
				"close","trace"};

void
syscall(void)
{
    80001f80:	7179                	addi	sp,sp,-48
    80001f82:	f406                	sd	ra,40(sp)
    80001f84:	f022                	sd	s0,32(sp)
    80001f86:	ec26                	sd	s1,24(sp)
    80001f88:	e84a                	sd	s2,16(sp)
    80001f8a:	e44e                	sd	s3,8(sp)
    80001f8c:	1800                	addi	s0,sp,48
  int num;
  struct proc *p = myproc();
    80001f8e:	fffff097          	auipc	ra,0xfffff
    80001f92:	eb6080e7          	jalr	-330(ra) # 80000e44 <myproc>
    80001f96:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80001f98:	05853903          	ld	s2,88(a0)
    80001f9c:	0a893783          	ld	a5,168(s2)
    80001fa0:	0007899b          	sext.w	s3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80001fa4:	37fd                	addiw	a5,a5,-1
    80001fa6:	4755                	li	a4,21
    80001fa8:	06f76163          	bltu	a4,a5,8000200a <syscall+0x8a>
    80001fac:	00399713          	slli	a4,s3,0x3
    80001fb0:	00006797          	auipc	a5,0x6
    80001fb4:	4d878793          	addi	a5,a5,1240 # 80008488 <syscalls>
    80001fb8:	97ba                	add	a5,a5,a4
    80001fba:	639c                	ld	a5,0(a5)
    80001fbc:	c7b9                	beqz	a5,8000200a <syscall+0x8a>
    p->trapframe->a0 = syscalls[num]();
    80001fbe:	9782                	jalr	a5
    80001fc0:	06a93823          	sd	a0,112(s2)
    if(strlen(p->mask) > 0 && p->mask[num] == '1'){
    80001fc4:	16848513          	addi	a0,s1,360
    80001fc8:	ffffe097          	auipc	ra,0xffffe
    80001fcc:	32e080e7          	jalr	814(ra) # 800002f6 <strlen>
    80001fd0:	04a05c63          	blez	a0,80002028 <syscall+0xa8>
    80001fd4:	013487b3          	add	a5,s1,s3
    80001fd8:	1687c703          	lbu	a4,360(a5)
    80001fdc:	03100793          	li	a5,49
    80001fe0:	04f71463          	bne	a4,a5,80002028 <syscall+0xa8>
	    printf("%d: syscall %s -> %d\n",
    80001fe4:	6cb8                	ld	a4,88(s1)
    80001fe6:	098e                	slli	s3,s3,0x3
    80001fe8:	00006797          	auipc	a5,0x6
    80001fec:	4a078793          	addi	a5,a5,1184 # 80008488 <syscalls>
    80001ff0:	97ce                	add	a5,a5,s3
    80001ff2:	7b34                	ld	a3,112(a4)
    80001ff4:	7fd0                	ld	a2,184(a5)
    80001ff6:	588c                	lw	a1,48(s1)
    80001ff8:	00006517          	auipc	a0,0x6
    80001ffc:	39850513          	addi	a0,a0,920 # 80008390 <states.0+0x150>
    80002000:	00004097          	auipc	ra,0x4
    80002004:	bfa080e7          	jalr	-1030(ra) # 80005bfa <printf>
    80002008:	a005                	j	80002028 <syscall+0xa8>
			    p->pid,syscall_names[num],p->trapframe->a0);
    }
  } else {
    printf("%d %s: unknown sys call %d\n",
    8000200a:	86ce                	mv	a3,s3
    8000200c:	15848613          	addi	a2,s1,344
    80002010:	588c                	lw	a1,48(s1)
    80002012:	00006517          	auipc	a0,0x6
    80002016:	39650513          	addi	a0,a0,918 # 800083a8 <states.0+0x168>
    8000201a:	00004097          	auipc	ra,0x4
    8000201e:	be0080e7          	jalr	-1056(ra) # 80005bfa <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80002022:	6cbc                	ld	a5,88(s1)
    80002024:	577d                	li	a4,-1
    80002026:	fbb8                	sd	a4,112(a5)
  }
}
    80002028:	70a2                	ld	ra,40(sp)
    8000202a:	7402                	ld	s0,32(sp)
    8000202c:	64e2                	ld	s1,24(sp)
    8000202e:	6942                	ld	s2,16(sp)
    80002030:	69a2                	ld	s3,8(sp)
    80002032:	6145                	addi	sp,sp,48
    80002034:	8082                	ret

0000000080002036 <sys_trace>:
#include "spinlock.h"
#include "proc.h"


uint64
sys_trace(void){
    80002036:	1101                	addi	sp,sp,-32
    80002038:	ec06                	sd	ra,24(sp)
    8000203a:	e822                	sd	s0,16(sp)
    8000203c:	1000                	addi	s0,sp,32
	int n;
	if(argint(0,&n) < 0)
    8000203e:	fec40593          	addi	a1,s0,-20
    80002042:	4501                	li	a0,0
    80002044:	00000097          	auipc	ra,0x0
    80002048:	ec8080e7          	jalr	-312(ra) # 80001f0c <argint>
		return -1;
    8000204c:	57fd                	li	a5,-1
	if(argint(0,&n) < 0)
    8000204e:	04054563          	bltz	a0,80002098 <sys_trace+0x62>
	struct proc *p = myproc();
    80002052:	fffff097          	auipc	ra,0xfffff
    80002056:	df2080e7          	jalr	-526(ra) # 80000e44 <myproc>
	char *mask = p->mask;
	int i = 0;
	while(i < 23 && n > 0){
    8000205a:	16850513          	addi	a0,a0,360
	struct proc *p = myproc();
    8000205e:	4705                	li	a4,1
		if(n % 2){
			mask[i++] = '1';
		}else{
			mask[i++] = '0';
    80002060:	03000593          	li	a1,48
			mask[i++] = '1';
    80002064:	03100613          	li	a2,49
	while(i < 23 && n > 0){
    80002068:	46e1                	li	a3,24
    8000206a:	a829                	j	80002084 <sys_trace+0x4e>
			mask[i++] = '0';
    8000206c:	00b50023          	sb	a1,0(a0)
		}
		n >>= 1;
    80002070:	fec42783          	lw	a5,-20(s0)
    80002074:	4017d79b          	sraiw	a5,a5,0x1
    80002078:	fef42623          	sw	a5,-20(s0)
	while(i < 23 && n > 0){
    8000207c:	2705                	addiw	a4,a4,1
    8000207e:	0505                	addi	a0,a0,1
    80002080:	02d70163          	beq	a4,a3,800020a2 <sys_trace+0x6c>
    80002084:	fec42783          	lw	a5,-20(s0)
    80002088:	00f05763          	blez	a5,80002096 <sys_trace+0x60>
		if(n % 2){
    8000208c:	8b85                	andi	a5,a5,1
    8000208e:	dff9                	beqz	a5,8000206c <sys_trace+0x36>
			mask[i++] = '1';
    80002090:	00c50023          	sb	a2,0(a0)
    80002094:	bff1                	j	80002070 <sys_trace+0x3a>
	}
	return 0;
    80002096:	4781                	li	a5,0
}
    80002098:	853e                	mv	a0,a5
    8000209a:	60e2                	ld	ra,24(sp)
    8000209c:	6442                	ld	s0,16(sp)
    8000209e:	6105                	addi	sp,sp,32
    800020a0:	8082                	ret
	return 0;
    800020a2:	4781                	li	a5,0
    800020a4:	bfd5                	j	80002098 <sys_trace+0x62>

00000000800020a6 <sys_exit>:

uint64
sys_exit(void)
{
    800020a6:	1101                	addi	sp,sp,-32
    800020a8:	ec06                	sd	ra,24(sp)
    800020aa:	e822                	sd	s0,16(sp)
    800020ac:	1000                	addi	s0,sp,32
  int n;
  if(argint(0, &n) < 0)
    800020ae:	fec40593          	addi	a1,s0,-20
    800020b2:	4501                	li	a0,0
    800020b4:	00000097          	auipc	ra,0x0
    800020b8:	e58080e7          	jalr	-424(ra) # 80001f0c <argint>
    return -1;
    800020bc:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    800020be:	00054963          	bltz	a0,800020d0 <sys_exit+0x2a>
  exit(n);
    800020c2:	fec42503          	lw	a0,-20(s0)
    800020c6:	fffff097          	auipc	ra,0xfffff
    800020ca:	6b0080e7          	jalr	1712(ra) # 80001776 <exit>
  return 0;  // not reached
    800020ce:	4781                	li	a5,0
}
    800020d0:	853e                	mv	a0,a5
    800020d2:	60e2                	ld	ra,24(sp)
    800020d4:	6442                	ld	s0,16(sp)
    800020d6:	6105                	addi	sp,sp,32
    800020d8:	8082                	ret

00000000800020da <sys_getpid>:

uint64
sys_getpid(void)
{
    800020da:	1141                	addi	sp,sp,-16
    800020dc:	e406                	sd	ra,8(sp)
    800020de:	e022                	sd	s0,0(sp)
    800020e0:	0800                	addi	s0,sp,16
  return myproc()->pid;
    800020e2:	fffff097          	auipc	ra,0xfffff
    800020e6:	d62080e7          	jalr	-670(ra) # 80000e44 <myproc>
}
    800020ea:	5908                	lw	a0,48(a0)
    800020ec:	60a2                	ld	ra,8(sp)
    800020ee:	6402                	ld	s0,0(sp)
    800020f0:	0141                	addi	sp,sp,16
    800020f2:	8082                	ret

00000000800020f4 <sys_fork>:

uint64
sys_fork(void)
{
    800020f4:	1141                	addi	sp,sp,-16
    800020f6:	e406                	sd	ra,8(sp)
    800020f8:	e022                	sd	s0,0(sp)
    800020fa:	0800                	addi	s0,sp,16
  return fork();
    800020fc:	fffff097          	auipc	ra,0xfffff
    80002100:	11a080e7          	jalr	282(ra) # 80001216 <fork>
}
    80002104:	60a2                	ld	ra,8(sp)
    80002106:	6402                	ld	s0,0(sp)
    80002108:	0141                	addi	sp,sp,16
    8000210a:	8082                	ret

000000008000210c <sys_wait>:

uint64
sys_wait(void)
{
    8000210c:	1101                	addi	sp,sp,-32
    8000210e:	ec06                	sd	ra,24(sp)
    80002110:	e822                	sd	s0,16(sp)
    80002112:	1000                	addi	s0,sp,32
  uint64 p;
  if(argaddr(0, &p) < 0)
    80002114:	fe840593          	addi	a1,s0,-24
    80002118:	4501                	li	a0,0
    8000211a:	00000097          	auipc	ra,0x0
    8000211e:	e14080e7          	jalr	-492(ra) # 80001f2e <argaddr>
    80002122:	87aa                	mv	a5,a0
    return -1;
    80002124:	557d                	li	a0,-1
  if(argaddr(0, &p) < 0)
    80002126:	0007c863          	bltz	a5,80002136 <sys_wait+0x2a>
  return wait(p);
    8000212a:	fe843503          	ld	a0,-24(s0)
    8000212e:	fffff097          	auipc	ra,0xfffff
    80002132:	450080e7          	jalr	1104(ra) # 8000157e <wait>
}
    80002136:	60e2                	ld	ra,24(sp)
    80002138:	6442                	ld	s0,16(sp)
    8000213a:	6105                	addi	sp,sp,32
    8000213c:	8082                	ret

000000008000213e <sys_sbrk>:

uint64
sys_sbrk(void)
{
    8000213e:	7179                	addi	sp,sp,-48
    80002140:	f406                	sd	ra,40(sp)
    80002142:	f022                	sd	s0,32(sp)
    80002144:	ec26                	sd	s1,24(sp)
    80002146:	1800                	addi	s0,sp,48
  int addr;
  int n;

  if(argint(0, &n) < 0)
    80002148:	fdc40593          	addi	a1,s0,-36
    8000214c:	4501                	li	a0,0
    8000214e:	00000097          	auipc	ra,0x0
    80002152:	dbe080e7          	jalr	-578(ra) # 80001f0c <argint>
    80002156:	87aa                	mv	a5,a0
    return -1;
    80002158:	557d                	li	a0,-1
  if(argint(0, &n) < 0)
    8000215a:	0207c063          	bltz	a5,8000217a <sys_sbrk+0x3c>
  addr = myproc()->sz;
    8000215e:	fffff097          	auipc	ra,0xfffff
    80002162:	ce6080e7          	jalr	-794(ra) # 80000e44 <myproc>
    80002166:	4524                	lw	s1,72(a0)
  if(growproc(n) < 0)
    80002168:	fdc42503          	lw	a0,-36(s0)
    8000216c:	fffff097          	auipc	ra,0xfffff
    80002170:	032080e7          	jalr	50(ra) # 8000119e <growproc>
    80002174:	00054863          	bltz	a0,80002184 <sys_sbrk+0x46>
    return -1;
  return addr;
    80002178:	8526                	mv	a0,s1
}
    8000217a:	70a2                	ld	ra,40(sp)
    8000217c:	7402                	ld	s0,32(sp)
    8000217e:	64e2                	ld	s1,24(sp)
    80002180:	6145                	addi	sp,sp,48
    80002182:	8082                	ret
    return -1;
    80002184:	557d                	li	a0,-1
    80002186:	bfd5                	j	8000217a <sys_sbrk+0x3c>

0000000080002188 <sys_sleep>:

uint64
sys_sleep(void)
{
    80002188:	7139                	addi	sp,sp,-64
    8000218a:	fc06                	sd	ra,56(sp)
    8000218c:	f822                	sd	s0,48(sp)
    8000218e:	f426                	sd	s1,40(sp)
    80002190:	f04a                	sd	s2,32(sp)
    80002192:	ec4e                	sd	s3,24(sp)
    80002194:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    80002196:	fcc40593          	addi	a1,s0,-52
    8000219a:	4501                	li	a0,0
    8000219c:	00000097          	auipc	ra,0x0
    800021a0:	d70080e7          	jalr	-656(ra) # 80001f0c <argint>
    return -1;
    800021a4:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    800021a6:	06054563          	bltz	a0,80002210 <sys_sleep+0x88>
  acquire(&tickslock);
    800021aa:	0000d517          	auipc	a0,0xd
    800021ae:	2d650513          	addi	a0,a0,726 # 8000f480 <tickslock>
    800021b2:	00004097          	auipc	ra,0x4
    800021b6:	f36080e7          	jalr	-202(ra) # 800060e8 <acquire>
  ticks0 = ticks;
    800021ba:	00007917          	auipc	s2,0x7
    800021be:	e5e92903          	lw	s2,-418(s2) # 80009018 <ticks>
  while(ticks - ticks0 < n){
    800021c2:	fcc42783          	lw	a5,-52(s0)
    800021c6:	cf85                	beqz	a5,800021fe <sys_sleep+0x76>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    800021c8:	0000d997          	auipc	s3,0xd
    800021cc:	2b898993          	addi	s3,s3,696 # 8000f480 <tickslock>
    800021d0:	00007497          	auipc	s1,0x7
    800021d4:	e4848493          	addi	s1,s1,-440 # 80009018 <ticks>
    if(myproc()->killed){
    800021d8:	fffff097          	auipc	ra,0xfffff
    800021dc:	c6c080e7          	jalr	-916(ra) # 80000e44 <myproc>
    800021e0:	551c                	lw	a5,40(a0)
    800021e2:	ef9d                	bnez	a5,80002220 <sys_sleep+0x98>
    sleep(&ticks, &tickslock);
    800021e4:	85ce                	mv	a1,s3
    800021e6:	8526                	mv	a0,s1
    800021e8:	fffff097          	auipc	ra,0xfffff
    800021ec:	332080e7          	jalr	818(ra) # 8000151a <sleep>
  while(ticks - ticks0 < n){
    800021f0:	409c                	lw	a5,0(s1)
    800021f2:	412787bb          	subw	a5,a5,s2
    800021f6:	fcc42703          	lw	a4,-52(s0)
    800021fa:	fce7efe3          	bltu	a5,a4,800021d8 <sys_sleep+0x50>
  }
  release(&tickslock);
    800021fe:	0000d517          	auipc	a0,0xd
    80002202:	28250513          	addi	a0,a0,642 # 8000f480 <tickslock>
    80002206:	00004097          	auipc	ra,0x4
    8000220a:	f96080e7          	jalr	-106(ra) # 8000619c <release>
  return 0;
    8000220e:	4781                	li	a5,0
}
    80002210:	853e                	mv	a0,a5
    80002212:	70e2                	ld	ra,56(sp)
    80002214:	7442                	ld	s0,48(sp)
    80002216:	74a2                	ld	s1,40(sp)
    80002218:	7902                	ld	s2,32(sp)
    8000221a:	69e2                	ld	s3,24(sp)
    8000221c:	6121                	addi	sp,sp,64
    8000221e:	8082                	ret
      release(&tickslock);
    80002220:	0000d517          	auipc	a0,0xd
    80002224:	26050513          	addi	a0,a0,608 # 8000f480 <tickslock>
    80002228:	00004097          	auipc	ra,0x4
    8000222c:	f74080e7          	jalr	-140(ra) # 8000619c <release>
      return -1;
    80002230:	57fd                	li	a5,-1
    80002232:	bff9                	j	80002210 <sys_sleep+0x88>

0000000080002234 <sys_kill>:

uint64
sys_kill(void)
{
    80002234:	1101                	addi	sp,sp,-32
    80002236:	ec06                	sd	ra,24(sp)
    80002238:	e822                	sd	s0,16(sp)
    8000223a:	1000                	addi	s0,sp,32
  int pid;

  if(argint(0, &pid) < 0)
    8000223c:	fec40593          	addi	a1,s0,-20
    80002240:	4501                	li	a0,0
    80002242:	00000097          	auipc	ra,0x0
    80002246:	cca080e7          	jalr	-822(ra) # 80001f0c <argint>
    8000224a:	87aa                	mv	a5,a0
    return -1;
    8000224c:	557d                	li	a0,-1
  if(argint(0, &pid) < 0)
    8000224e:	0007c863          	bltz	a5,8000225e <sys_kill+0x2a>
  return kill(pid);
    80002252:	fec42503          	lw	a0,-20(s0)
    80002256:	fffff097          	auipc	ra,0xfffff
    8000225a:	5f6080e7          	jalr	1526(ra) # 8000184c <kill>
}
    8000225e:	60e2                	ld	ra,24(sp)
    80002260:	6442                	ld	s0,16(sp)
    80002262:	6105                	addi	sp,sp,32
    80002264:	8082                	ret

0000000080002266 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002266:	1101                	addi	sp,sp,-32
    80002268:	ec06                	sd	ra,24(sp)
    8000226a:	e822                	sd	s0,16(sp)
    8000226c:	e426                	sd	s1,8(sp)
    8000226e:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002270:	0000d517          	auipc	a0,0xd
    80002274:	21050513          	addi	a0,a0,528 # 8000f480 <tickslock>
    80002278:	00004097          	auipc	ra,0x4
    8000227c:	e70080e7          	jalr	-400(ra) # 800060e8 <acquire>
  xticks = ticks;
    80002280:	00007497          	auipc	s1,0x7
    80002284:	d984a483          	lw	s1,-616(s1) # 80009018 <ticks>
  release(&tickslock);
    80002288:	0000d517          	auipc	a0,0xd
    8000228c:	1f850513          	addi	a0,a0,504 # 8000f480 <tickslock>
    80002290:	00004097          	auipc	ra,0x4
    80002294:	f0c080e7          	jalr	-244(ra) # 8000619c <release>
  return xticks;
}
    80002298:	02049513          	slli	a0,s1,0x20
    8000229c:	9101                	srli	a0,a0,0x20
    8000229e:	60e2                	ld	ra,24(sp)
    800022a0:	6442                	ld	s0,16(sp)
    800022a2:	64a2                	ld	s1,8(sp)
    800022a4:	6105                	addi	sp,sp,32
    800022a6:	8082                	ret

00000000800022a8 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    800022a8:	7179                	addi	sp,sp,-48
    800022aa:	f406                	sd	ra,40(sp)
    800022ac:	f022                	sd	s0,32(sp)
    800022ae:	ec26                	sd	s1,24(sp)
    800022b0:	e84a                	sd	s2,16(sp)
    800022b2:	e44e                	sd	s3,8(sp)
    800022b4:	e052                	sd	s4,0(sp)
    800022b6:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    800022b8:	00006597          	auipc	a1,0x6
    800022bc:	34058593          	addi	a1,a1,832 # 800085f8 <syscall_names+0xb8>
    800022c0:	0000d517          	auipc	a0,0xd
    800022c4:	1d850513          	addi	a0,a0,472 # 8000f498 <bcache>
    800022c8:	00004097          	auipc	ra,0x4
    800022cc:	d90080e7          	jalr	-624(ra) # 80006058 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    800022d0:	00015797          	auipc	a5,0x15
    800022d4:	1c878793          	addi	a5,a5,456 # 80017498 <bcache+0x8000>
    800022d8:	00015717          	auipc	a4,0x15
    800022dc:	42870713          	addi	a4,a4,1064 # 80017700 <bcache+0x8268>
    800022e0:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    800022e4:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800022e8:	0000d497          	auipc	s1,0xd
    800022ec:	1c848493          	addi	s1,s1,456 # 8000f4b0 <bcache+0x18>
    b->next = bcache.head.next;
    800022f0:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    800022f2:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    800022f4:	00006a17          	auipc	s4,0x6
    800022f8:	30ca0a13          	addi	s4,s4,780 # 80008600 <syscall_names+0xc0>
    b->next = bcache.head.next;
    800022fc:	2b893783          	ld	a5,696(s2)
    80002300:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80002302:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80002306:	85d2                	mv	a1,s4
    80002308:	01048513          	addi	a0,s1,16
    8000230c:	00001097          	auipc	ra,0x1
    80002310:	4c2080e7          	jalr	1218(ra) # 800037ce <initsleeplock>
    bcache.head.next->prev = b;
    80002314:	2b893783          	ld	a5,696(s2)
    80002318:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    8000231a:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    8000231e:	45848493          	addi	s1,s1,1112
    80002322:	fd349de3          	bne	s1,s3,800022fc <binit+0x54>
  }
}
    80002326:	70a2                	ld	ra,40(sp)
    80002328:	7402                	ld	s0,32(sp)
    8000232a:	64e2                	ld	s1,24(sp)
    8000232c:	6942                	ld	s2,16(sp)
    8000232e:	69a2                	ld	s3,8(sp)
    80002330:	6a02                	ld	s4,0(sp)
    80002332:	6145                	addi	sp,sp,48
    80002334:	8082                	ret

0000000080002336 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80002336:	7179                	addi	sp,sp,-48
    80002338:	f406                	sd	ra,40(sp)
    8000233a:	f022                	sd	s0,32(sp)
    8000233c:	ec26                	sd	s1,24(sp)
    8000233e:	e84a                	sd	s2,16(sp)
    80002340:	e44e                	sd	s3,8(sp)
    80002342:	1800                	addi	s0,sp,48
    80002344:	892a                	mv	s2,a0
    80002346:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80002348:	0000d517          	auipc	a0,0xd
    8000234c:	15050513          	addi	a0,a0,336 # 8000f498 <bcache>
    80002350:	00004097          	auipc	ra,0x4
    80002354:	d98080e7          	jalr	-616(ra) # 800060e8 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80002358:	00015497          	auipc	s1,0x15
    8000235c:	3f84b483          	ld	s1,1016(s1) # 80017750 <bcache+0x82b8>
    80002360:	00015797          	auipc	a5,0x15
    80002364:	3a078793          	addi	a5,a5,928 # 80017700 <bcache+0x8268>
    80002368:	02f48f63          	beq	s1,a5,800023a6 <bread+0x70>
    8000236c:	873e                	mv	a4,a5
    8000236e:	a021                	j	80002376 <bread+0x40>
    80002370:	68a4                	ld	s1,80(s1)
    80002372:	02e48a63          	beq	s1,a4,800023a6 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    80002376:	449c                	lw	a5,8(s1)
    80002378:	ff279ce3          	bne	a5,s2,80002370 <bread+0x3a>
    8000237c:	44dc                	lw	a5,12(s1)
    8000237e:	ff3799e3          	bne	a5,s3,80002370 <bread+0x3a>
      b->refcnt++;
    80002382:	40bc                	lw	a5,64(s1)
    80002384:	2785                	addiw	a5,a5,1
    80002386:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002388:	0000d517          	auipc	a0,0xd
    8000238c:	11050513          	addi	a0,a0,272 # 8000f498 <bcache>
    80002390:	00004097          	auipc	ra,0x4
    80002394:	e0c080e7          	jalr	-500(ra) # 8000619c <release>
      acquiresleep(&b->lock);
    80002398:	01048513          	addi	a0,s1,16
    8000239c:	00001097          	auipc	ra,0x1
    800023a0:	46c080e7          	jalr	1132(ra) # 80003808 <acquiresleep>
      return b;
    800023a4:	a8b9                	j	80002402 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800023a6:	00015497          	auipc	s1,0x15
    800023aa:	3a24b483          	ld	s1,930(s1) # 80017748 <bcache+0x82b0>
    800023ae:	00015797          	auipc	a5,0x15
    800023b2:	35278793          	addi	a5,a5,850 # 80017700 <bcache+0x8268>
    800023b6:	00f48863          	beq	s1,a5,800023c6 <bread+0x90>
    800023ba:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    800023bc:	40bc                	lw	a5,64(s1)
    800023be:	cf81                	beqz	a5,800023d6 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800023c0:	64a4                	ld	s1,72(s1)
    800023c2:	fee49de3          	bne	s1,a4,800023bc <bread+0x86>
  panic("bget: no buffers");
    800023c6:	00006517          	auipc	a0,0x6
    800023ca:	24250513          	addi	a0,a0,578 # 80008608 <syscall_names+0xc8>
    800023ce:	00003097          	auipc	ra,0x3
    800023d2:	7e2080e7          	jalr	2018(ra) # 80005bb0 <panic>
      b->dev = dev;
    800023d6:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    800023da:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    800023de:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    800023e2:	4785                	li	a5,1
    800023e4:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800023e6:	0000d517          	auipc	a0,0xd
    800023ea:	0b250513          	addi	a0,a0,178 # 8000f498 <bcache>
    800023ee:	00004097          	auipc	ra,0x4
    800023f2:	dae080e7          	jalr	-594(ra) # 8000619c <release>
      acquiresleep(&b->lock);
    800023f6:	01048513          	addi	a0,s1,16
    800023fa:	00001097          	auipc	ra,0x1
    800023fe:	40e080e7          	jalr	1038(ra) # 80003808 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80002402:	409c                	lw	a5,0(s1)
    80002404:	cb89                	beqz	a5,80002416 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80002406:	8526                	mv	a0,s1
    80002408:	70a2                	ld	ra,40(sp)
    8000240a:	7402                	ld	s0,32(sp)
    8000240c:	64e2                	ld	s1,24(sp)
    8000240e:	6942                	ld	s2,16(sp)
    80002410:	69a2                	ld	s3,8(sp)
    80002412:	6145                	addi	sp,sp,48
    80002414:	8082                	ret
    virtio_disk_rw(b, 0);
    80002416:	4581                	li	a1,0
    80002418:	8526                	mv	a0,s1
    8000241a:	00003097          	auipc	ra,0x3
    8000241e:	f28080e7          	jalr	-216(ra) # 80005342 <virtio_disk_rw>
    b->valid = 1;
    80002422:	4785                	li	a5,1
    80002424:	c09c                	sw	a5,0(s1)
  return b;
    80002426:	b7c5                	j	80002406 <bread+0xd0>

0000000080002428 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80002428:	1101                	addi	sp,sp,-32
    8000242a:	ec06                	sd	ra,24(sp)
    8000242c:	e822                	sd	s0,16(sp)
    8000242e:	e426                	sd	s1,8(sp)
    80002430:	1000                	addi	s0,sp,32
    80002432:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002434:	0541                	addi	a0,a0,16
    80002436:	00001097          	auipc	ra,0x1
    8000243a:	46c080e7          	jalr	1132(ra) # 800038a2 <holdingsleep>
    8000243e:	cd01                	beqz	a0,80002456 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80002440:	4585                	li	a1,1
    80002442:	8526                	mv	a0,s1
    80002444:	00003097          	auipc	ra,0x3
    80002448:	efe080e7          	jalr	-258(ra) # 80005342 <virtio_disk_rw>
}
    8000244c:	60e2                	ld	ra,24(sp)
    8000244e:	6442                	ld	s0,16(sp)
    80002450:	64a2                	ld	s1,8(sp)
    80002452:	6105                	addi	sp,sp,32
    80002454:	8082                	ret
    panic("bwrite");
    80002456:	00006517          	auipc	a0,0x6
    8000245a:	1ca50513          	addi	a0,a0,458 # 80008620 <syscall_names+0xe0>
    8000245e:	00003097          	auipc	ra,0x3
    80002462:	752080e7          	jalr	1874(ra) # 80005bb0 <panic>

0000000080002466 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80002466:	1101                	addi	sp,sp,-32
    80002468:	ec06                	sd	ra,24(sp)
    8000246a:	e822                	sd	s0,16(sp)
    8000246c:	e426                	sd	s1,8(sp)
    8000246e:	e04a                	sd	s2,0(sp)
    80002470:	1000                	addi	s0,sp,32
    80002472:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002474:	01050913          	addi	s2,a0,16
    80002478:	854a                	mv	a0,s2
    8000247a:	00001097          	auipc	ra,0x1
    8000247e:	428080e7          	jalr	1064(ra) # 800038a2 <holdingsleep>
    80002482:	c92d                	beqz	a0,800024f4 <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    80002484:	854a                	mv	a0,s2
    80002486:	00001097          	auipc	ra,0x1
    8000248a:	3d8080e7          	jalr	984(ra) # 8000385e <releasesleep>

  acquire(&bcache.lock);
    8000248e:	0000d517          	auipc	a0,0xd
    80002492:	00a50513          	addi	a0,a0,10 # 8000f498 <bcache>
    80002496:	00004097          	auipc	ra,0x4
    8000249a:	c52080e7          	jalr	-942(ra) # 800060e8 <acquire>
  b->refcnt--;
    8000249e:	40bc                	lw	a5,64(s1)
    800024a0:	37fd                	addiw	a5,a5,-1
    800024a2:	0007871b          	sext.w	a4,a5
    800024a6:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    800024a8:	eb05                	bnez	a4,800024d8 <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    800024aa:	68bc                	ld	a5,80(s1)
    800024ac:	64b8                	ld	a4,72(s1)
    800024ae:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    800024b0:	64bc                	ld	a5,72(s1)
    800024b2:	68b8                	ld	a4,80(s1)
    800024b4:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    800024b6:	00015797          	auipc	a5,0x15
    800024ba:	fe278793          	addi	a5,a5,-30 # 80017498 <bcache+0x8000>
    800024be:	2b87b703          	ld	a4,696(a5)
    800024c2:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    800024c4:	00015717          	auipc	a4,0x15
    800024c8:	23c70713          	addi	a4,a4,572 # 80017700 <bcache+0x8268>
    800024cc:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    800024ce:	2b87b703          	ld	a4,696(a5)
    800024d2:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    800024d4:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    800024d8:	0000d517          	auipc	a0,0xd
    800024dc:	fc050513          	addi	a0,a0,-64 # 8000f498 <bcache>
    800024e0:	00004097          	auipc	ra,0x4
    800024e4:	cbc080e7          	jalr	-836(ra) # 8000619c <release>
}
    800024e8:	60e2                	ld	ra,24(sp)
    800024ea:	6442                	ld	s0,16(sp)
    800024ec:	64a2                	ld	s1,8(sp)
    800024ee:	6902                	ld	s2,0(sp)
    800024f0:	6105                	addi	sp,sp,32
    800024f2:	8082                	ret
    panic("brelse");
    800024f4:	00006517          	auipc	a0,0x6
    800024f8:	13450513          	addi	a0,a0,308 # 80008628 <syscall_names+0xe8>
    800024fc:	00003097          	auipc	ra,0x3
    80002500:	6b4080e7          	jalr	1716(ra) # 80005bb0 <panic>

0000000080002504 <bpin>:

void
bpin(struct buf *b) {
    80002504:	1101                	addi	sp,sp,-32
    80002506:	ec06                	sd	ra,24(sp)
    80002508:	e822                	sd	s0,16(sp)
    8000250a:	e426                	sd	s1,8(sp)
    8000250c:	1000                	addi	s0,sp,32
    8000250e:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002510:	0000d517          	auipc	a0,0xd
    80002514:	f8850513          	addi	a0,a0,-120 # 8000f498 <bcache>
    80002518:	00004097          	auipc	ra,0x4
    8000251c:	bd0080e7          	jalr	-1072(ra) # 800060e8 <acquire>
  b->refcnt++;
    80002520:	40bc                	lw	a5,64(s1)
    80002522:	2785                	addiw	a5,a5,1
    80002524:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002526:	0000d517          	auipc	a0,0xd
    8000252a:	f7250513          	addi	a0,a0,-142 # 8000f498 <bcache>
    8000252e:	00004097          	auipc	ra,0x4
    80002532:	c6e080e7          	jalr	-914(ra) # 8000619c <release>
}
    80002536:	60e2                	ld	ra,24(sp)
    80002538:	6442                	ld	s0,16(sp)
    8000253a:	64a2                	ld	s1,8(sp)
    8000253c:	6105                	addi	sp,sp,32
    8000253e:	8082                	ret

0000000080002540 <bunpin>:

void
bunpin(struct buf *b) {
    80002540:	1101                	addi	sp,sp,-32
    80002542:	ec06                	sd	ra,24(sp)
    80002544:	e822                	sd	s0,16(sp)
    80002546:	e426                	sd	s1,8(sp)
    80002548:	1000                	addi	s0,sp,32
    8000254a:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    8000254c:	0000d517          	auipc	a0,0xd
    80002550:	f4c50513          	addi	a0,a0,-180 # 8000f498 <bcache>
    80002554:	00004097          	auipc	ra,0x4
    80002558:	b94080e7          	jalr	-1132(ra) # 800060e8 <acquire>
  b->refcnt--;
    8000255c:	40bc                	lw	a5,64(s1)
    8000255e:	37fd                	addiw	a5,a5,-1
    80002560:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002562:	0000d517          	auipc	a0,0xd
    80002566:	f3650513          	addi	a0,a0,-202 # 8000f498 <bcache>
    8000256a:	00004097          	auipc	ra,0x4
    8000256e:	c32080e7          	jalr	-974(ra) # 8000619c <release>
}
    80002572:	60e2                	ld	ra,24(sp)
    80002574:	6442                	ld	s0,16(sp)
    80002576:	64a2                	ld	s1,8(sp)
    80002578:	6105                	addi	sp,sp,32
    8000257a:	8082                	ret

000000008000257c <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    8000257c:	1101                	addi	sp,sp,-32
    8000257e:	ec06                	sd	ra,24(sp)
    80002580:	e822                	sd	s0,16(sp)
    80002582:	e426                	sd	s1,8(sp)
    80002584:	e04a                	sd	s2,0(sp)
    80002586:	1000                	addi	s0,sp,32
    80002588:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    8000258a:	00d5d59b          	srliw	a1,a1,0xd
    8000258e:	00015797          	auipc	a5,0x15
    80002592:	5e67a783          	lw	a5,1510(a5) # 80017b74 <sb+0x1c>
    80002596:	9dbd                	addw	a1,a1,a5
    80002598:	00000097          	auipc	ra,0x0
    8000259c:	d9e080e7          	jalr	-610(ra) # 80002336 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    800025a0:	0074f713          	andi	a4,s1,7
    800025a4:	4785                	li	a5,1
    800025a6:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    800025aa:	14ce                	slli	s1,s1,0x33
    800025ac:	90d9                	srli	s1,s1,0x36
    800025ae:	00950733          	add	a4,a0,s1
    800025b2:	05874703          	lbu	a4,88(a4)
    800025b6:	00e7f6b3          	and	a3,a5,a4
    800025ba:	c69d                	beqz	a3,800025e8 <bfree+0x6c>
    800025bc:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    800025be:	94aa                	add	s1,s1,a0
    800025c0:	fff7c793          	not	a5,a5
    800025c4:	8f7d                	and	a4,a4,a5
    800025c6:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    800025ca:	00001097          	auipc	ra,0x1
    800025ce:	120080e7          	jalr	288(ra) # 800036ea <log_write>
  brelse(bp);
    800025d2:	854a                	mv	a0,s2
    800025d4:	00000097          	auipc	ra,0x0
    800025d8:	e92080e7          	jalr	-366(ra) # 80002466 <brelse>
}
    800025dc:	60e2                	ld	ra,24(sp)
    800025de:	6442                	ld	s0,16(sp)
    800025e0:	64a2                	ld	s1,8(sp)
    800025e2:	6902                	ld	s2,0(sp)
    800025e4:	6105                	addi	sp,sp,32
    800025e6:	8082                	ret
    panic("freeing free block");
    800025e8:	00006517          	auipc	a0,0x6
    800025ec:	04850513          	addi	a0,a0,72 # 80008630 <syscall_names+0xf0>
    800025f0:	00003097          	auipc	ra,0x3
    800025f4:	5c0080e7          	jalr	1472(ra) # 80005bb0 <panic>

00000000800025f8 <balloc>:
{
    800025f8:	711d                	addi	sp,sp,-96
    800025fa:	ec86                	sd	ra,88(sp)
    800025fc:	e8a2                	sd	s0,80(sp)
    800025fe:	e4a6                	sd	s1,72(sp)
    80002600:	e0ca                	sd	s2,64(sp)
    80002602:	fc4e                	sd	s3,56(sp)
    80002604:	f852                	sd	s4,48(sp)
    80002606:	f456                	sd	s5,40(sp)
    80002608:	f05a                	sd	s6,32(sp)
    8000260a:	ec5e                	sd	s7,24(sp)
    8000260c:	e862                	sd	s8,16(sp)
    8000260e:	e466                	sd	s9,8(sp)
    80002610:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80002612:	00015797          	auipc	a5,0x15
    80002616:	54a7a783          	lw	a5,1354(a5) # 80017b5c <sb+0x4>
    8000261a:	cbc1                	beqz	a5,800026aa <balloc+0xb2>
    8000261c:	8baa                	mv	s7,a0
    8000261e:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80002620:	00015b17          	auipc	s6,0x15
    80002624:	538b0b13          	addi	s6,s6,1336 # 80017b58 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002628:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    8000262a:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000262c:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    8000262e:	6c89                	lui	s9,0x2
    80002630:	a831                	j	8000264c <balloc+0x54>
    brelse(bp);
    80002632:	854a                	mv	a0,s2
    80002634:	00000097          	auipc	ra,0x0
    80002638:	e32080e7          	jalr	-462(ra) # 80002466 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    8000263c:	015c87bb          	addw	a5,s9,s5
    80002640:	00078a9b          	sext.w	s5,a5
    80002644:	004b2703          	lw	a4,4(s6)
    80002648:	06eaf163          	bgeu	s5,a4,800026aa <balloc+0xb2>
    bp = bread(dev, BBLOCK(b, sb));
    8000264c:	41fad79b          	sraiw	a5,s5,0x1f
    80002650:	0137d79b          	srliw	a5,a5,0x13
    80002654:	015787bb          	addw	a5,a5,s5
    80002658:	40d7d79b          	sraiw	a5,a5,0xd
    8000265c:	01cb2583          	lw	a1,28(s6)
    80002660:	9dbd                	addw	a1,a1,a5
    80002662:	855e                	mv	a0,s7
    80002664:	00000097          	auipc	ra,0x0
    80002668:	cd2080e7          	jalr	-814(ra) # 80002336 <bread>
    8000266c:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000266e:	004b2503          	lw	a0,4(s6)
    80002672:	000a849b          	sext.w	s1,s5
    80002676:	8762                	mv	a4,s8
    80002678:	faa4fde3          	bgeu	s1,a0,80002632 <balloc+0x3a>
      m = 1 << (bi % 8);
    8000267c:	00777693          	andi	a3,a4,7
    80002680:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80002684:	41f7579b          	sraiw	a5,a4,0x1f
    80002688:	01d7d79b          	srliw	a5,a5,0x1d
    8000268c:	9fb9                	addw	a5,a5,a4
    8000268e:	4037d79b          	sraiw	a5,a5,0x3
    80002692:	00f90633          	add	a2,s2,a5
    80002696:	05864603          	lbu	a2,88(a2)
    8000269a:	00c6f5b3          	and	a1,a3,a2
    8000269e:	cd91                	beqz	a1,800026ba <balloc+0xc2>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800026a0:	2705                	addiw	a4,a4,1
    800026a2:	2485                	addiw	s1,s1,1
    800026a4:	fd471ae3          	bne	a4,s4,80002678 <balloc+0x80>
    800026a8:	b769                	j	80002632 <balloc+0x3a>
  panic("balloc: out of blocks");
    800026aa:	00006517          	auipc	a0,0x6
    800026ae:	f9e50513          	addi	a0,a0,-98 # 80008648 <syscall_names+0x108>
    800026b2:	00003097          	auipc	ra,0x3
    800026b6:	4fe080e7          	jalr	1278(ra) # 80005bb0 <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    800026ba:	97ca                	add	a5,a5,s2
    800026bc:	8e55                	or	a2,a2,a3
    800026be:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    800026c2:	854a                	mv	a0,s2
    800026c4:	00001097          	auipc	ra,0x1
    800026c8:	026080e7          	jalr	38(ra) # 800036ea <log_write>
        brelse(bp);
    800026cc:	854a                	mv	a0,s2
    800026ce:	00000097          	auipc	ra,0x0
    800026d2:	d98080e7          	jalr	-616(ra) # 80002466 <brelse>
  bp = bread(dev, bno);
    800026d6:	85a6                	mv	a1,s1
    800026d8:	855e                	mv	a0,s7
    800026da:	00000097          	auipc	ra,0x0
    800026de:	c5c080e7          	jalr	-932(ra) # 80002336 <bread>
    800026e2:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    800026e4:	40000613          	li	a2,1024
    800026e8:	4581                	li	a1,0
    800026ea:	05850513          	addi	a0,a0,88
    800026ee:	ffffe097          	auipc	ra,0xffffe
    800026f2:	a8c080e7          	jalr	-1396(ra) # 8000017a <memset>
  log_write(bp);
    800026f6:	854a                	mv	a0,s2
    800026f8:	00001097          	auipc	ra,0x1
    800026fc:	ff2080e7          	jalr	-14(ra) # 800036ea <log_write>
  brelse(bp);
    80002700:	854a                	mv	a0,s2
    80002702:	00000097          	auipc	ra,0x0
    80002706:	d64080e7          	jalr	-668(ra) # 80002466 <brelse>
}
    8000270a:	8526                	mv	a0,s1
    8000270c:	60e6                	ld	ra,88(sp)
    8000270e:	6446                	ld	s0,80(sp)
    80002710:	64a6                	ld	s1,72(sp)
    80002712:	6906                	ld	s2,64(sp)
    80002714:	79e2                	ld	s3,56(sp)
    80002716:	7a42                	ld	s4,48(sp)
    80002718:	7aa2                	ld	s5,40(sp)
    8000271a:	7b02                	ld	s6,32(sp)
    8000271c:	6be2                	ld	s7,24(sp)
    8000271e:	6c42                	ld	s8,16(sp)
    80002720:	6ca2                	ld	s9,8(sp)
    80002722:	6125                	addi	sp,sp,96
    80002724:	8082                	ret

0000000080002726 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    80002726:	7179                	addi	sp,sp,-48
    80002728:	f406                	sd	ra,40(sp)
    8000272a:	f022                	sd	s0,32(sp)
    8000272c:	ec26                	sd	s1,24(sp)
    8000272e:	e84a                	sd	s2,16(sp)
    80002730:	e44e                	sd	s3,8(sp)
    80002732:	e052                	sd	s4,0(sp)
    80002734:	1800                	addi	s0,sp,48
    80002736:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80002738:	47ad                	li	a5,11
    8000273a:	04b7fe63          	bgeu	a5,a1,80002796 <bmap+0x70>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    8000273e:	ff45849b          	addiw	s1,a1,-12
    80002742:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    80002746:	0ff00793          	li	a5,255
    8000274a:	0ae7e463          	bltu	a5,a4,800027f2 <bmap+0xcc>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
    8000274e:	08052583          	lw	a1,128(a0)
    80002752:	c5b5                	beqz	a1,800027be <bmap+0x98>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    80002754:	00092503          	lw	a0,0(s2)
    80002758:	00000097          	auipc	ra,0x0
    8000275c:	bde080e7          	jalr	-1058(ra) # 80002336 <bread>
    80002760:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80002762:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    80002766:	02049713          	slli	a4,s1,0x20
    8000276a:	01e75593          	srli	a1,a4,0x1e
    8000276e:	00b784b3          	add	s1,a5,a1
    80002772:	0004a983          	lw	s3,0(s1)
    80002776:	04098e63          	beqz	s3,800027d2 <bmap+0xac>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    8000277a:	8552                	mv	a0,s4
    8000277c:	00000097          	auipc	ra,0x0
    80002780:	cea080e7          	jalr	-790(ra) # 80002466 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    80002784:	854e                	mv	a0,s3
    80002786:	70a2                	ld	ra,40(sp)
    80002788:	7402                	ld	s0,32(sp)
    8000278a:	64e2                	ld	s1,24(sp)
    8000278c:	6942                	ld	s2,16(sp)
    8000278e:	69a2                	ld	s3,8(sp)
    80002790:	6a02                	ld	s4,0(sp)
    80002792:	6145                	addi	sp,sp,48
    80002794:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    80002796:	02059793          	slli	a5,a1,0x20
    8000279a:	01e7d593          	srli	a1,a5,0x1e
    8000279e:	00b504b3          	add	s1,a0,a1
    800027a2:	0504a983          	lw	s3,80(s1)
    800027a6:	fc099fe3          	bnez	s3,80002784 <bmap+0x5e>
      ip->addrs[bn] = addr = balloc(ip->dev);
    800027aa:	4108                	lw	a0,0(a0)
    800027ac:	00000097          	auipc	ra,0x0
    800027b0:	e4c080e7          	jalr	-436(ra) # 800025f8 <balloc>
    800027b4:	0005099b          	sext.w	s3,a0
    800027b8:	0534a823          	sw	s3,80(s1)
    800027bc:	b7e1                	j	80002784 <bmap+0x5e>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    800027be:	4108                	lw	a0,0(a0)
    800027c0:	00000097          	auipc	ra,0x0
    800027c4:	e38080e7          	jalr	-456(ra) # 800025f8 <balloc>
    800027c8:	0005059b          	sext.w	a1,a0
    800027cc:	08b92023          	sw	a1,128(s2)
    800027d0:	b751                	j	80002754 <bmap+0x2e>
      a[bn] = addr = balloc(ip->dev);
    800027d2:	00092503          	lw	a0,0(s2)
    800027d6:	00000097          	auipc	ra,0x0
    800027da:	e22080e7          	jalr	-478(ra) # 800025f8 <balloc>
    800027de:	0005099b          	sext.w	s3,a0
    800027e2:	0134a023          	sw	s3,0(s1)
      log_write(bp);
    800027e6:	8552                	mv	a0,s4
    800027e8:	00001097          	auipc	ra,0x1
    800027ec:	f02080e7          	jalr	-254(ra) # 800036ea <log_write>
    800027f0:	b769                	j	8000277a <bmap+0x54>
  panic("bmap: out of range");
    800027f2:	00006517          	auipc	a0,0x6
    800027f6:	e6e50513          	addi	a0,a0,-402 # 80008660 <syscall_names+0x120>
    800027fa:	00003097          	auipc	ra,0x3
    800027fe:	3b6080e7          	jalr	950(ra) # 80005bb0 <panic>

0000000080002802 <iget>:
{
    80002802:	7179                	addi	sp,sp,-48
    80002804:	f406                	sd	ra,40(sp)
    80002806:	f022                	sd	s0,32(sp)
    80002808:	ec26                	sd	s1,24(sp)
    8000280a:	e84a                	sd	s2,16(sp)
    8000280c:	e44e                	sd	s3,8(sp)
    8000280e:	e052                	sd	s4,0(sp)
    80002810:	1800                	addi	s0,sp,48
    80002812:	89aa                	mv	s3,a0
    80002814:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80002816:	00015517          	auipc	a0,0x15
    8000281a:	36250513          	addi	a0,a0,866 # 80017b78 <itable>
    8000281e:	00004097          	auipc	ra,0x4
    80002822:	8ca080e7          	jalr	-1846(ra) # 800060e8 <acquire>
  empty = 0;
    80002826:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002828:	00015497          	auipc	s1,0x15
    8000282c:	36848493          	addi	s1,s1,872 # 80017b90 <itable+0x18>
    80002830:	00017697          	auipc	a3,0x17
    80002834:	df068693          	addi	a3,a3,-528 # 80019620 <log>
    80002838:	a039                	j	80002846 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    8000283a:	02090b63          	beqz	s2,80002870 <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    8000283e:	08848493          	addi	s1,s1,136
    80002842:	02d48a63          	beq	s1,a3,80002876 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80002846:	449c                	lw	a5,8(s1)
    80002848:	fef059e3          	blez	a5,8000283a <iget+0x38>
    8000284c:	4098                	lw	a4,0(s1)
    8000284e:	ff3716e3          	bne	a4,s3,8000283a <iget+0x38>
    80002852:	40d8                	lw	a4,4(s1)
    80002854:	ff4713e3          	bne	a4,s4,8000283a <iget+0x38>
      ip->ref++;
    80002858:	2785                	addiw	a5,a5,1
    8000285a:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    8000285c:	00015517          	auipc	a0,0x15
    80002860:	31c50513          	addi	a0,a0,796 # 80017b78 <itable>
    80002864:	00004097          	auipc	ra,0x4
    80002868:	938080e7          	jalr	-1736(ra) # 8000619c <release>
      return ip;
    8000286c:	8926                	mv	s2,s1
    8000286e:	a03d                	j	8000289c <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002870:	f7f9                	bnez	a5,8000283e <iget+0x3c>
    80002872:	8926                	mv	s2,s1
    80002874:	b7e9                	j	8000283e <iget+0x3c>
  if(empty == 0)
    80002876:	02090c63          	beqz	s2,800028ae <iget+0xac>
  ip->dev = dev;
    8000287a:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    8000287e:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80002882:	4785                	li	a5,1
    80002884:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80002888:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    8000288c:	00015517          	auipc	a0,0x15
    80002890:	2ec50513          	addi	a0,a0,748 # 80017b78 <itable>
    80002894:	00004097          	auipc	ra,0x4
    80002898:	908080e7          	jalr	-1784(ra) # 8000619c <release>
}
    8000289c:	854a                	mv	a0,s2
    8000289e:	70a2                	ld	ra,40(sp)
    800028a0:	7402                	ld	s0,32(sp)
    800028a2:	64e2                	ld	s1,24(sp)
    800028a4:	6942                	ld	s2,16(sp)
    800028a6:	69a2                	ld	s3,8(sp)
    800028a8:	6a02                	ld	s4,0(sp)
    800028aa:	6145                	addi	sp,sp,48
    800028ac:	8082                	ret
    panic("iget: no inodes");
    800028ae:	00006517          	auipc	a0,0x6
    800028b2:	dca50513          	addi	a0,a0,-566 # 80008678 <syscall_names+0x138>
    800028b6:	00003097          	auipc	ra,0x3
    800028ba:	2fa080e7          	jalr	762(ra) # 80005bb0 <panic>

00000000800028be <fsinit>:
fsinit(int dev) {
    800028be:	7179                	addi	sp,sp,-48
    800028c0:	f406                	sd	ra,40(sp)
    800028c2:	f022                	sd	s0,32(sp)
    800028c4:	ec26                	sd	s1,24(sp)
    800028c6:	e84a                	sd	s2,16(sp)
    800028c8:	e44e                	sd	s3,8(sp)
    800028ca:	1800                	addi	s0,sp,48
    800028cc:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    800028ce:	4585                	li	a1,1
    800028d0:	00000097          	auipc	ra,0x0
    800028d4:	a66080e7          	jalr	-1434(ra) # 80002336 <bread>
    800028d8:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    800028da:	00015997          	auipc	s3,0x15
    800028de:	27e98993          	addi	s3,s3,638 # 80017b58 <sb>
    800028e2:	02000613          	li	a2,32
    800028e6:	05850593          	addi	a1,a0,88
    800028ea:	854e                	mv	a0,s3
    800028ec:	ffffe097          	auipc	ra,0xffffe
    800028f0:	8ea080e7          	jalr	-1814(ra) # 800001d6 <memmove>
  brelse(bp);
    800028f4:	8526                	mv	a0,s1
    800028f6:	00000097          	auipc	ra,0x0
    800028fa:	b70080e7          	jalr	-1168(ra) # 80002466 <brelse>
  if(sb.magic != FSMAGIC)
    800028fe:	0009a703          	lw	a4,0(s3)
    80002902:	102037b7          	lui	a5,0x10203
    80002906:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    8000290a:	02f71263          	bne	a4,a5,8000292e <fsinit+0x70>
  initlog(dev, &sb);
    8000290e:	00015597          	auipc	a1,0x15
    80002912:	24a58593          	addi	a1,a1,586 # 80017b58 <sb>
    80002916:	854a                	mv	a0,s2
    80002918:	00001097          	auipc	ra,0x1
    8000291c:	b56080e7          	jalr	-1194(ra) # 8000346e <initlog>
}
    80002920:	70a2                	ld	ra,40(sp)
    80002922:	7402                	ld	s0,32(sp)
    80002924:	64e2                	ld	s1,24(sp)
    80002926:	6942                	ld	s2,16(sp)
    80002928:	69a2                	ld	s3,8(sp)
    8000292a:	6145                	addi	sp,sp,48
    8000292c:	8082                	ret
    panic("invalid file system");
    8000292e:	00006517          	auipc	a0,0x6
    80002932:	d5a50513          	addi	a0,a0,-678 # 80008688 <syscall_names+0x148>
    80002936:	00003097          	auipc	ra,0x3
    8000293a:	27a080e7          	jalr	634(ra) # 80005bb0 <panic>

000000008000293e <iinit>:
{
    8000293e:	7179                	addi	sp,sp,-48
    80002940:	f406                	sd	ra,40(sp)
    80002942:	f022                	sd	s0,32(sp)
    80002944:	ec26                	sd	s1,24(sp)
    80002946:	e84a                	sd	s2,16(sp)
    80002948:	e44e                	sd	s3,8(sp)
    8000294a:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    8000294c:	00006597          	auipc	a1,0x6
    80002950:	d5458593          	addi	a1,a1,-684 # 800086a0 <syscall_names+0x160>
    80002954:	00015517          	auipc	a0,0x15
    80002958:	22450513          	addi	a0,a0,548 # 80017b78 <itable>
    8000295c:	00003097          	auipc	ra,0x3
    80002960:	6fc080e7          	jalr	1788(ra) # 80006058 <initlock>
  for(i = 0; i < NINODE; i++) {
    80002964:	00015497          	auipc	s1,0x15
    80002968:	23c48493          	addi	s1,s1,572 # 80017ba0 <itable+0x28>
    8000296c:	00017997          	auipc	s3,0x17
    80002970:	cc498993          	addi	s3,s3,-828 # 80019630 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002974:	00006917          	auipc	s2,0x6
    80002978:	d3490913          	addi	s2,s2,-716 # 800086a8 <syscall_names+0x168>
    8000297c:	85ca                	mv	a1,s2
    8000297e:	8526                	mv	a0,s1
    80002980:	00001097          	auipc	ra,0x1
    80002984:	e4e080e7          	jalr	-434(ra) # 800037ce <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002988:	08848493          	addi	s1,s1,136
    8000298c:	ff3498e3          	bne	s1,s3,8000297c <iinit+0x3e>
}
    80002990:	70a2                	ld	ra,40(sp)
    80002992:	7402                	ld	s0,32(sp)
    80002994:	64e2                	ld	s1,24(sp)
    80002996:	6942                	ld	s2,16(sp)
    80002998:	69a2                	ld	s3,8(sp)
    8000299a:	6145                	addi	sp,sp,48
    8000299c:	8082                	ret

000000008000299e <ialloc>:
{
    8000299e:	715d                	addi	sp,sp,-80
    800029a0:	e486                	sd	ra,72(sp)
    800029a2:	e0a2                	sd	s0,64(sp)
    800029a4:	fc26                	sd	s1,56(sp)
    800029a6:	f84a                	sd	s2,48(sp)
    800029a8:	f44e                	sd	s3,40(sp)
    800029aa:	f052                	sd	s4,32(sp)
    800029ac:	ec56                	sd	s5,24(sp)
    800029ae:	e85a                	sd	s6,16(sp)
    800029b0:	e45e                	sd	s7,8(sp)
    800029b2:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    800029b4:	00015717          	auipc	a4,0x15
    800029b8:	1b072703          	lw	a4,432(a4) # 80017b64 <sb+0xc>
    800029bc:	4785                	li	a5,1
    800029be:	04e7fa63          	bgeu	a5,a4,80002a12 <ialloc+0x74>
    800029c2:	8aaa                	mv	s5,a0
    800029c4:	8bae                	mv	s7,a1
    800029c6:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    800029c8:	00015a17          	auipc	s4,0x15
    800029cc:	190a0a13          	addi	s4,s4,400 # 80017b58 <sb>
    800029d0:	00048b1b          	sext.w	s6,s1
    800029d4:	0044d593          	srli	a1,s1,0x4
    800029d8:	018a2783          	lw	a5,24(s4)
    800029dc:	9dbd                	addw	a1,a1,a5
    800029de:	8556                	mv	a0,s5
    800029e0:	00000097          	auipc	ra,0x0
    800029e4:	956080e7          	jalr	-1706(ra) # 80002336 <bread>
    800029e8:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    800029ea:	05850993          	addi	s3,a0,88
    800029ee:	00f4f793          	andi	a5,s1,15
    800029f2:	079a                	slli	a5,a5,0x6
    800029f4:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    800029f6:	00099783          	lh	a5,0(s3)
    800029fa:	c785                	beqz	a5,80002a22 <ialloc+0x84>
    brelse(bp);
    800029fc:	00000097          	auipc	ra,0x0
    80002a00:	a6a080e7          	jalr	-1430(ra) # 80002466 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002a04:	0485                	addi	s1,s1,1
    80002a06:	00ca2703          	lw	a4,12(s4)
    80002a0a:	0004879b          	sext.w	a5,s1
    80002a0e:	fce7e1e3          	bltu	a5,a4,800029d0 <ialloc+0x32>
  panic("ialloc: no inodes");
    80002a12:	00006517          	auipc	a0,0x6
    80002a16:	c9e50513          	addi	a0,a0,-866 # 800086b0 <syscall_names+0x170>
    80002a1a:	00003097          	auipc	ra,0x3
    80002a1e:	196080e7          	jalr	406(ra) # 80005bb0 <panic>
      memset(dip, 0, sizeof(*dip));
    80002a22:	04000613          	li	a2,64
    80002a26:	4581                	li	a1,0
    80002a28:	854e                	mv	a0,s3
    80002a2a:	ffffd097          	auipc	ra,0xffffd
    80002a2e:	750080e7          	jalr	1872(ra) # 8000017a <memset>
      dip->type = type;
    80002a32:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002a36:	854a                	mv	a0,s2
    80002a38:	00001097          	auipc	ra,0x1
    80002a3c:	cb2080e7          	jalr	-846(ra) # 800036ea <log_write>
      brelse(bp);
    80002a40:	854a                	mv	a0,s2
    80002a42:	00000097          	auipc	ra,0x0
    80002a46:	a24080e7          	jalr	-1500(ra) # 80002466 <brelse>
      return iget(dev, inum);
    80002a4a:	85da                	mv	a1,s6
    80002a4c:	8556                	mv	a0,s5
    80002a4e:	00000097          	auipc	ra,0x0
    80002a52:	db4080e7          	jalr	-588(ra) # 80002802 <iget>
}
    80002a56:	60a6                	ld	ra,72(sp)
    80002a58:	6406                	ld	s0,64(sp)
    80002a5a:	74e2                	ld	s1,56(sp)
    80002a5c:	7942                	ld	s2,48(sp)
    80002a5e:	79a2                	ld	s3,40(sp)
    80002a60:	7a02                	ld	s4,32(sp)
    80002a62:	6ae2                	ld	s5,24(sp)
    80002a64:	6b42                	ld	s6,16(sp)
    80002a66:	6ba2                	ld	s7,8(sp)
    80002a68:	6161                	addi	sp,sp,80
    80002a6a:	8082                	ret

0000000080002a6c <iupdate>:
{
    80002a6c:	1101                	addi	sp,sp,-32
    80002a6e:	ec06                	sd	ra,24(sp)
    80002a70:	e822                	sd	s0,16(sp)
    80002a72:	e426                	sd	s1,8(sp)
    80002a74:	e04a                	sd	s2,0(sp)
    80002a76:	1000                	addi	s0,sp,32
    80002a78:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002a7a:	415c                	lw	a5,4(a0)
    80002a7c:	0047d79b          	srliw	a5,a5,0x4
    80002a80:	00015597          	auipc	a1,0x15
    80002a84:	0f05a583          	lw	a1,240(a1) # 80017b70 <sb+0x18>
    80002a88:	9dbd                	addw	a1,a1,a5
    80002a8a:	4108                	lw	a0,0(a0)
    80002a8c:	00000097          	auipc	ra,0x0
    80002a90:	8aa080e7          	jalr	-1878(ra) # 80002336 <bread>
    80002a94:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002a96:	05850793          	addi	a5,a0,88
    80002a9a:	40d8                	lw	a4,4(s1)
    80002a9c:	8b3d                	andi	a4,a4,15
    80002a9e:	071a                	slli	a4,a4,0x6
    80002aa0:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80002aa2:	04449703          	lh	a4,68(s1)
    80002aa6:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80002aaa:	04649703          	lh	a4,70(s1)
    80002aae:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80002ab2:	04849703          	lh	a4,72(s1)
    80002ab6:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80002aba:	04a49703          	lh	a4,74(s1)
    80002abe:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80002ac2:	44f8                	lw	a4,76(s1)
    80002ac4:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002ac6:	03400613          	li	a2,52
    80002aca:	05048593          	addi	a1,s1,80
    80002ace:	00c78513          	addi	a0,a5,12
    80002ad2:	ffffd097          	auipc	ra,0xffffd
    80002ad6:	704080e7          	jalr	1796(ra) # 800001d6 <memmove>
  log_write(bp);
    80002ada:	854a                	mv	a0,s2
    80002adc:	00001097          	auipc	ra,0x1
    80002ae0:	c0e080e7          	jalr	-1010(ra) # 800036ea <log_write>
  brelse(bp);
    80002ae4:	854a                	mv	a0,s2
    80002ae6:	00000097          	auipc	ra,0x0
    80002aea:	980080e7          	jalr	-1664(ra) # 80002466 <brelse>
}
    80002aee:	60e2                	ld	ra,24(sp)
    80002af0:	6442                	ld	s0,16(sp)
    80002af2:	64a2                	ld	s1,8(sp)
    80002af4:	6902                	ld	s2,0(sp)
    80002af6:	6105                	addi	sp,sp,32
    80002af8:	8082                	ret

0000000080002afa <idup>:
{
    80002afa:	1101                	addi	sp,sp,-32
    80002afc:	ec06                	sd	ra,24(sp)
    80002afe:	e822                	sd	s0,16(sp)
    80002b00:	e426                	sd	s1,8(sp)
    80002b02:	1000                	addi	s0,sp,32
    80002b04:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002b06:	00015517          	auipc	a0,0x15
    80002b0a:	07250513          	addi	a0,a0,114 # 80017b78 <itable>
    80002b0e:	00003097          	auipc	ra,0x3
    80002b12:	5da080e7          	jalr	1498(ra) # 800060e8 <acquire>
  ip->ref++;
    80002b16:	449c                	lw	a5,8(s1)
    80002b18:	2785                	addiw	a5,a5,1
    80002b1a:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002b1c:	00015517          	auipc	a0,0x15
    80002b20:	05c50513          	addi	a0,a0,92 # 80017b78 <itable>
    80002b24:	00003097          	auipc	ra,0x3
    80002b28:	678080e7          	jalr	1656(ra) # 8000619c <release>
}
    80002b2c:	8526                	mv	a0,s1
    80002b2e:	60e2                	ld	ra,24(sp)
    80002b30:	6442                	ld	s0,16(sp)
    80002b32:	64a2                	ld	s1,8(sp)
    80002b34:	6105                	addi	sp,sp,32
    80002b36:	8082                	ret

0000000080002b38 <ilock>:
{
    80002b38:	1101                	addi	sp,sp,-32
    80002b3a:	ec06                	sd	ra,24(sp)
    80002b3c:	e822                	sd	s0,16(sp)
    80002b3e:	e426                	sd	s1,8(sp)
    80002b40:	e04a                	sd	s2,0(sp)
    80002b42:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002b44:	c115                	beqz	a0,80002b68 <ilock+0x30>
    80002b46:	84aa                	mv	s1,a0
    80002b48:	451c                	lw	a5,8(a0)
    80002b4a:	00f05f63          	blez	a5,80002b68 <ilock+0x30>
  acquiresleep(&ip->lock);
    80002b4e:	0541                	addi	a0,a0,16
    80002b50:	00001097          	auipc	ra,0x1
    80002b54:	cb8080e7          	jalr	-840(ra) # 80003808 <acquiresleep>
  if(ip->valid == 0){
    80002b58:	40bc                	lw	a5,64(s1)
    80002b5a:	cf99                	beqz	a5,80002b78 <ilock+0x40>
}
    80002b5c:	60e2                	ld	ra,24(sp)
    80002b5e:	6442                	ld	s0,16(sp)
    80002b60:	64a2                	ld	s1,8(sp)
    80002b62:	6902                	ld	s2,0(sp)
    80002b64:	6105                	addi	sp,sp,32
    80002b66:	8082                	ret
    panic("ilock");
    80002b68:	00006517          	auipc	a0,0x6
    80002b6c:	b6050513          	addi	a0,a0,-1184 # 800086c8 <syscall_names+0x188>
    80002b70:	00003097          	auipc	ra,0x3
    80002b74:	040080e7          	jalr	64(ra) # 80005bb0 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002b78:	40dc                	lw	a5,4(s1)
    80002b7a:	0047d79b          	srliw	a5,a5,0x4
    80002b7e:	00015597          	auipc	a1,0x15
    80002b82:	ff25a583          	lw	a1,-14(a1) # 80017b70 <sb+0x18>
    80002b86:	9dbd                	addw	a1,a1,a5
    80002b88:	4088                	lw	a0,0(s1)
    80002b8a:	fffff097          	auipc	ra,0xfffff
    80002b8e:	7ac080e7          	jalr	1964(ra) # 80002336 <bread>
    80002b92:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002b94:	05850593          	addi	a1,a0,88
    80002b98:	40dc                	lw	a5,4(s1)
    80002b9a:	8bbd                	andi	a5,a5,15
    80002b9c:	079a                	slli	a5,a5,0x6
    80002b9e:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002ba0:	00059783          	lh	a5,0(a1)
    80002ba4:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002ba8:	00259783          	lh	a5,2(a1)
    80002bac:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002bb0:	00459783          	lh	a5,4(a1)
    80002bb4:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002bb8:	00659783          	lh	a5,6(a1)
    80002bbc:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002bc0:	459c                	lw	a5,8(a1)
    80002bc2:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002bc4:	03400613          	li	a2,52
    80002bc8:	05b1                	addi	a1,a1,12
    80002bca:	05048513          	addi	a0,s1,80
    80002bce:	ffffd097          	auipc	ra,0xffffd
    80002bd2:	608080e7          	jalr	1544(ra) # 800001d6 <memmove>
    brelse(bp);
    80002bd6:	854a                	mv	a0,s2
    80002bd8:	00000097          	auipc	ra,0x0
    80002bdc:	88e080e7          	jalr	-1906(ra) # 80002466 <brelse>
    ip->valid = 1;
    80002be0:	4785                	li	a5,1
    80002be2:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002be4:	04449783          	lh	a5,68(s1)
    80002be8:	fbb5                	bnez	a5,80002b5c <ilock+0x24>
      panic("ilock: no type");
    80002bea:	00006517          	auipc	a0,0x6
    80002bee:	ae650513          	addi	a0,a0,-1306 # 800086d0 <syscall_names+0x190>
    80002bf2:	00003097          	auipc	ra,0x3
    80002bf6:	fbe080e7          	jalr	-66(ra) # 80005bb0 <panic>

0000000080002bfa <iunlock>:
{
    80002bfa:	1101                	addi	sp,sp,-32
    80002bfc:	ec06                	sd	ra,24(sp)
    80002bfe:	e822                	sd	s0,16(sp)
    80002c00:	e426                	sd	s1,8(sp)
    80002c02:	e04a                	sd	s2,0(sp)
    80002c04:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002c06:	c905                	beqz	a0,80002c36 <iunlock+0x3c>
    80002c08:	84aa                	mv	s1,a0
    80002c0a:	01050913          	addi	s2,a0,16
    80002c0e:	854a                	mv	a0,s2
    80002c10:	00001097          	auipc	ra,0x1
    80002c14:	c92080e7          	jalr	-878(ra) # 800038a2 <holdingsleep>
    80002c18:	cd19                	beqz	a0,80002c36 <iunlock+0x3c>
    80002c1a:	449c                	lw	a5,8(s1)
    80002c1c:	00f05d63          	blez	a5,80002c36 <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002c20:	854a                	mv	a0,s2
    80002c22:	00001097          	auipc	ra,0x1
    80002c26:	c3c080e7          	jalr	-964(ra) # 8000385e <releasesleep>
}
    80002c2a:	60e2                	ld	ra,24(sp)
    80002c2c:	6442                	ld	s0,16(sp)
    80002c2e:	64a2                	ld	s1,8(sp)
    80002c30:	6902                	ld	s2,0(sp)
    80002c32:	6105                	addi	sp,sp,32
    80002c34:	8082                	ret
    panic("iunlock");
    80002c36:	00006517          	auipc	a0,0x6
    80002c3a:	aaa50513          	addi	a0,a0,-1366 # 800086e0 <syscall_names+0x1a0>
    80002c3e:	00003097          	auipc	ra,0x3
    80002c42:	f72080e7          	jalr	-142(ra) # 80005bb0 <panic>

0000000080002c46 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002c46:	7179                	addi	sp,sp,-48
    80002c48:	f406                	sd	ra,40(sp)
    80002c4a:	f022                	sd	s0,32(sp)
    80002c4c:	ec26                	sd	s1,24(sp)
    80002c4e:	e84a                	sd	s2,16(sp)
    80002c50:	e44e                	sd	s3,8(sp)
    80002c52:	e052                	sd	s4,0(sp)
    80002c54:	1800                	addi	s0,sp,48
    80002c56:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002c58:	05050493          	addi	s1,a0,80
    80002c5c:	08050913          	addi	s2,a0,128
    80002c60:	a021                	j	80002c68 <itrunc+0x22>
    80002c62:	0491                	addi	s1,s1,4
    80002c64:	01248d63          	beq	s1,s2,80002c7e <itrunc+0x38>
    if(ip->addrs[i]){
    80002c68:	408c                	lw	a1,0(s1)
    80002c6a:	dde5                	beqz	a1,80002c62 <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80002c6c:	0009a503          	lw	a0,0(s3)
    80002c70:	00000097          	auipc	ra,0x0
    80002c74:	90c080e7          	jalr	-1780(ra) # 8000257c <bfree>
      ip->addrs[i] = 0;
    80002c78:	0004a023          	sw	zero,0(s1)
    80002c7c:	b7dd                	j	80002c62 <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002c7e:	0809a583          	lw	a1,128(s3)
    80002c82:	e185                	bnez	a1,80002ca2 <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002c84:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002c88:	854e                	mv	a0,s3
    80002c8a:	00000097          	auipc	ra,0x0
    80002c8e:	de2080e7          	jalr	-542(ra) # 80002a6c <iupdate>
}
    80002c92:	70a2                	ld	ra,40(sp)
    80002c94:	7402                	ld	s0,32(sp)
    80002c96:	64e2                	ld	s1,24(sp)
    80002c98:	6942                	ld	s2,16(sp)
    80002c9a:	69a2                	ld	s3,8(sp)
    80002c9c:	6a02                	ld	s4,0(sp)
    80002c9e:	6145                	addi	sp,sp,48
    80002ca0:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002ca2:	0009a503          	lw	a0,0(s3)
    80002ca6:	fffff097          	auipc	ra,0xfffff
    80002caa:	690080e7          	jalr	1680(ra) # 80002336 <bread>
    80002cae:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002cb0:	05850493          	addi	s1,a0,88
    80002cb4:	45850913          	addi	s2,a0,1112
    80002cb8:	a021                	j	80002cc0 <itrunc+0x7a>
    80002cba:	0491                	addi	s1,s1,4
    80002cbc:	01248b63          	beq	s1,s2,80002cd2 <itrunc+0x8c>
      if(a[j])
    80002cc0:	408c                	lw	a1,0(s1)
    80002cc2:	dde5                	beqz	a1,80002cba <itrunc+0x74>
        bfree(ip->dev, a[j]);
    80002cc4:	0009a503          	lw	a0,0(s3)
    80002cc8:	00000097          	auipc	ra,0x0
    80002ccc:	8b4080e7          	jalr	-1868(ra) # 8000257c <bfree>
    80002cd0:	b7ed                	j	80002cba <itrunc+0x74>
    brelse(bp);
    80002cd2:	8552                	mv	a0,s4
    80002cd4:	fffff097          	auipc	ra,0xfffff
    80002cd8:	792080e7          	jalr	1938(ra) # 80002466 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002cdc:	0809a583          	lw	a1,128(s3)
    80002ce0:	0009a503          	lw	a0,0(s3)
    80002ce4:	00000097          	auipc	ra,0x0
    80002ce8:	898080e7          	jalr	-1896(ra) # 8000257c <bfree>
    ip->addrs[NDIRECT] = 0;
    80002cec:	0809a023          	sw	zero,128(s3)
    80002cf0:	bf51                	j	80002c84 <itrunc+0x3e>

0000000080002cf2 <iput>:
{
    80002cf2:	1101                	addi	sp,sp,-32
    80002cf4:	ec06                	sd	ra,24(sp)
    80002cf6:	e822                	sd	s0,16(sp)
    80002cf8:	e426                	sd	s1,8(sp)
    80002cfa:	e04a                	sd	s2,0(sp)
    80002cfc:	1000                	addi	s0,sp,32
    80002cfe:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002d00:	00015517          	auipc	a0,0x15
    80002d04:	e7850513          	addi	a0,a0,-392 # 80017b78 <itable>
    80002d08:	00003097          	auipc	ra,0x3
    80002d0c:	3e0080e7          	jalr	992(ra) # 800060e8 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002d10:	4498                	lw	a4,8(s1)
    80002d12:	4785                	li	a5,1
    80002d14:	02f70363          	beq	a4,a5,80002d3a <iput+0x48>
  ip->ref--;
    80002d18:	449c                	lw	a5,8(s1)
    80002d1a:	37fd                	addiw	a5,a5,-1
    80002d1c:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002d1e:	00015517          	auipc	a0,0x15
    80002d22:	e5a50513          	addi	a0,a0,-422 # 80017b78 <itable>
    80002d26:	00003097          	auipc	ra,0x3
    80002d2a:	476080e7          	jalr	1142(ra) # 8000619c <release>
}
    80002d2e:	60e2                	ld	ra,24(sp)
    80002d30:	6442                	ld	s0,16(sp)
    80002d32:	64a2                	ld	s1,8(sp)
    80002d34:	6902                	ld	s2,0(sp)
    80002d36:	6105                	addi	sp,sp,32
    80002d38:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002d3a:	40bc                	lw	a5,64(s1)
    80002d3c:	dff1                	beqz	a5,80002d18 <iput+0x26>
    80002d3e:	04a49783          	lh	a5,74(s1)
    80002d42:	fbf9                	bnez	a5,80002d18 <iput+0x26>
    acquiresleep(&ip->lock);
    80002d44:	01048913          	addi	s2,s1,16
    80002d48:	854a                	mv	a0,s2
    80002d4a:	00001097          	auipc	ra,0x1
    80002d4e:	abe080e7          	jalr	-1346(ra) # 80003808 <acquiresleep>
    release(&itable.lock);
    80002d52:	00015517          	auipc	a0,0x15
    80002d56:	e2650513          	addi	a0,a0,-474 # 80017b78 <itable>
    80002d5a:	00003097          	auipc	ra,0x3
    80002d5e:	442080e7          	jalr	1090(ra) # 8000619c <release>
    itrunc(ip);
    80002d62:	8526                	mv	a0,s1
    80002d64:	00000097          	auipc	ra,0x0
    80002d68:	ee2080e7          	jalr	-286(ra) # 80002c46 <itrunc>
    ip->type = 0;
    80002d6c:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002d70:	8526                	mv	a0,s1
    80002d72:	00000097          	auipc	ra,0x0
    80002d76:	cfa080e7          	jalr	-774(ra) # 80002a6c <iupdate>
    ip->valid = 0;
    80002d7a:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002d7e:	854a                	mv	a0,s2
    80002d80:	00001097          	auipc	ra,0x1
    80002d84:	ade080e7          	jalr	-1314(ra) # 8000385e <releasesleep>
    acquire(&itable.lock);
    80002d88:	00015517          	auipc	a0,0x15
    80002d8c:	df050513          	addi	a0,a0,-528 # 80017b78 <itable>
    80002d90:	00003097          	auipc	ra,0x3
    80002d94:	358080e7          	jalr	856(ra) # 800060e8 <acquire>
    80002d98:	b741                	j	80002d18 <iput+0x26>

0000000080002d9a <iunlockput>:
{
    80002d9a:	1101                	addi	sp,sp,-32
    80002d9c:	ec06                	sd	ra,24(sp)
    80002d9e:	e822                	sd	s0,16(sp)
    80002da0:	e426                	sd	s1,8(sp)
    80002da2:	1000                	addi	s0,sp,32
    80002da4:	84aa                	mv	s1,a0
  iunlock(ip);
    80002da6:	00000097          	auipc	ra,0x0
    80002daa:	e54080e7          	jalr	-428(ra) # 80002bfa <iunlock>
  iput(ip);
    80002dae:	8526                	mv	a0,s1
    80002db0:	00000097          	auipc	ra,0x0
    80002db4:	f42080e7          	jalr	-190(ra) # 80002cf2 <iput>
}
    80002db8:	60e2                	ld	ra,24(sp)
    80002dba:	6442                	ld	s0,16(sp)
    80002dbc:	64a2                	ld	s1,8(sp)
    80002dbe:	6105                	addi	sp,sp,32
    80002dc0:	8082                	ret

0000000080002dc2 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002dc2:	1141                	addi	sp,sp,-16
    80002dc4:	e422                	sd	s0,8(sp)
    80002dc6:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002dc8:	411c                	lw	a5,0(a0)
    80002dca:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002dcc:	415c                	lw	a5,4(a0)
    80002dce:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002dd0:	04451783          	lh	a5,68(a0)
    80002dd4:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002dd8:	04a51783          	lh	a5,74(a0)
    80002ddc:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002de0:	04c56783          	lwu	a5,76(a0)
    80002de4:	e99c                	sd	a5,16(a1)
}
    80002de6:	6422                	ld	s0,8(sp)
    80002de8:	0141                	addi	sp,sp,16
    80002dea:	8082                	ret

0000000080002dec <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002dec:	457c                	lw	a5,76(a0)
    80002dee:	0ed7e963          	bltu	a5,a3,80002ee0 <readi+0xf4>
{
    80002df2:	7159                	addi	sp,sp,-112
    80002df4:	f486                	sd	ra,104(sp)
    80002df6:	f0a2                	sd	s0,96(sp)
    80002df8:	eca6                	sd	s1,88(sp)
    80002dfa:	e8ca                	sd	s2,80(sp)
    80002dfc:	e4ce                	sd	s3,72(sp)
    80002dfe:	e0d2                	sd	s4,64(sp)
    80002e00:	fc56                	sd	s5,56(sp)
    80002e02:	f85a                	sd	s6,48(sp)
    80002e04:	f45e                	sd	s7,40(sp)
    80002e06:	f062                	sd	s8,32(sp)
    80002e08:	ec66                	sd	s9,24(sp)
    80002e0a:	e86a                	sd	s10,16(sp)
    80002e0c:	e46e                	sd	s11,8(sp)
    80002e0e:	1880                	addi	s0,sp,112
    80002e10:	8baa                	mv	s7,a0
    80002e12:	8c2e                	mv	s8,a1
    80002e14:	8ab2                	mv	s5,a2
    80002e16:	84b6                	mv	s1,a3
    80002e18:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80002e1a:	9f35                	addw	a4,a4,a3
    return 0;
    80002e1c:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002e1e:	0ad76063          	bltu	a4,a3,80002ebe <readi+0xd2>
  if(off + n > ip->size)
    80002e22:	00e7f463          	bgeu	a5,a4,80002e2a <readi+0x3e>
    n = ip->size - off;
    80002e26:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002e2a:	0a0b0963          	beqz	s6,80002edc <readi+0xf0>
    80002e2e:	4981                	li	s3,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80002e30:	40000d13          	li	s10,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002e34:	5cfd                	li	s9,-1
    80002e36:	a82d                	j	80002e70 <readi+0x84>
    80002e38:	020a1d93          	slli	s11,s4,0x20
    80002e3c:	020ddd93          	srli	s11,s11,0x20
    80002e40:	05890613          	addi	a2,s2,88
    80002e44:	86ee                	mv	a3,s11
    80002e46:	963a                	add	a2,a2,a4
    80002e48:	85d6                	mv	a1,s5
    80002e4a:	8562                	mv	a0,s8
    80002e4c:	fffff097          	auipc	ra,0xfffff
    80002e50:	a72080e7          	jalr	-1422(ra) # 800018be <either_copyout>
    80002e54:	05950d63          	beq	a0,s9,80002eae <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002e58:	854a                	mv	a0,s2
    80002e5a:	fffff097          	auipc	ra,0xfffff
    80002e5e:	60c080e7          	jalr	1548(ra) # 80002466 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002e62:	013a09bb          	addw	s3,s4,s3
    80002e66:	009a04bb          	addw	s1,s4,s1
    80002e6a:	9aee                	add	s5,s5,s11
    80002e6c:	0569f763          	bgeu	s3,s6,80002eba <readi+0xce>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80002e70:	000ba903          	lw	s2,0(s7)
    80002e74:	00a4d59b          	srliw	a1,s1,0xa
    80002e78:	855e                	mv	a0,s7
    80002e7a:	00000097          	auipc	ra,0x0
    80002e7e:	8ac080e7          	jalr	-1876(ra) # 80002726 <bmap>
    80002e82:	0005059b          	sext.w	a1,a0
    80002e86:	854a                	mv	a0,s2
    80002e88:	fffff097          	auipc	ra,0xfffff
    80002e8c:	4ae080e7          	jalr	1198(ra) # 80002336 <bread>
    80002e90:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002e92:	3ff4f713          	andi	a4,s1,1023
    80002e96:	40ed07bb          	subw	a5,s10,a4
    80002e9a:	413b06bb          	subw	a3,s6,s3
    80002e9e:	8a3e                	mv	s4,a5
    80002ea0:	2781                	sext.w	a5,a5
    80002ea2:	0006861b          	sext.w	a2,a3
    80002ea6:	f8f679e3          	bgeu	a2,a5,80002e38 <readi+0x4c>
    80002eaa:	8a36                	mv	s4,a3
    80002eac:	b771                	j	80002e38 <readi+0x4c>
      brelse(bp);
    80002eae:	854a                	mv	a0,s2
    80002eb0:	fffff097          	auipc	ra,0xfffff
    80002eb4:	5b6080e7          	jalr	1462(ra) # 80002466 <brelse>
      tot = -1;
    80002eb8:	59fd                	li	s3,-1
  }
  return tot;
    80002eba:	0009851b          	sext.w	a0,s3
}
    80002ebe:	70a6                	ld	ra,104(sp)
    80002ec0:	7406                	ld	s0,96(sp)
    80002ec2:	64e6                	ld	s1,88(sp)
    80002ec4:	6946                	ld	s2,80(sp)
    80002ec6:	69a6                	ld	s3,72(sp)
    80002ec8:	6a06                	ld	s4,64(sp)
    80002eca:	7ae2                	ld	s5,56(sp)
    80002ecc:	7b42                	ld	s6,48(sp)
    80002ece:	7ba2                	ld	s7,40(sp)
    80002ed0:	7c02                	ld	s8,32(sp)
    80002ed2:	6ce2                	ld	s9,24(sp)
    80002ed4:	6d42                	ld	s10,16(sp)
    80002ed6:	6da2                	ld	s11,8(sp)
    80002ed8:	6165                	addi	sp,sp,112
    80002eda:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002edc:	89da                	mv	s3,s6
    80002ede:	bff1                	j	80002eba <readi+0xce>
    return 0;
    80002ee0:	4501                	li	a0,0
}
    80002ee2:	8082                	ret

0000000080002ee4 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002ee4:	457c                	lw	a5,76(a0)
    80002ee6:	10d7e863          	bltu	a5,a3,80002ff6 <writei+0x112>
{
    80002eea:	7159                	addi	sp,sp,-112
    80002eec:	f486                	sd	ra,104(sp)
    80002eee:	f0a2                	sd	s0,96(sp)
    80002ef0:	eca6                	sd	s1,88(sp)
    80002ef2:	e8ca                	sd	s2,80(sp)
    80002ef4:	e4ce                	sd	s3,72(sp)
    80002ef6:	e0d2                	sd	s4,64(sp)
    80002ef8:	fc56                	sd	s5,56(sp)
    80002efa:	f85a                	sd	s6,48(sp)
    80002efc:	f45e                	sd	s7,40(sp)
    80002efe:	f062                	sd	s8,32(sp)
    80002f00:	ec66                	sd	s9,24(sp)
    80002f02:	e86a                	sd	s10,16(sp)
    80002f04:	e46e                	sd	s11,8(sp)
    80002f06:	1880                	addi	s0,sp,112
    80002f08:	8b2a                	mv	s6,a0
    80002f0a:	8c2e                	mv	s8,a1
    80002f0c:	8ab2                	mv	s5,a2
    80002f0e:	8936                	mv	s2,a3
    80002f10:	8bba                	mv	s7,a4
  if(off > ip->size || off + n < off)
    80002f12:	00e687bb          	addw	a5,a3,a4
    80002f16:	0ed7e263          	bltu	a5,a3,80002ffa <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80002f1a:	00043737          	lui	a4,0x43
    80002f1e:	0ef76063          	bltu	a4,a5,80002ffe <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002f22:	0c0b8863          	beqz	s7,80002ff2 <writei+0x10e>
    80002f26:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80002f28:	40000d13          	li	s10,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80002f2c:	5cfd                	li	s9,-1
    80002f2e:	a091                	j	80002f72 <writei+0x8e>
    80002f30:	02099d93          	slli	s11,s3,0x20
    80002f34:	020ddd93          	srli	s11,s11,0x20
    80002f38:	05848513          	addi	a0,s1,88
    80002f3c:	86ee                	mv	a3,s11
    80002f3e:	8656                	mv	a2,s5
    80002f40:	85e2                	mv	a1,s8
    80002f42:	953a                	add	a0,a0,a4
    80002f44:	fffff097          	auipc	ra,0xfffff
    80002f48:	9d0080e7          	jalr	-1584(ra) # 80001914 <either_copyin>
    80002f4c:	07950263          	beq	a0,s9,80002fb0 <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80002f50:	8526                	mv	a0,s1
    80002f52:	00000097          	auipc	ra,0x0
    80002f56:	798080e7          	jalr	1944(ra) # 800036ea <log_write>
    brelse(bp);
    80002f5a:	8526                	mv	a0,s1
    80002f5c:	fffff097          	auipc	ra,0xfffff
    80002f60:	50a080e7          	jalr	1290(ra) # 80002466 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002f64:	01498a3b          	addw	s4,s3,s4
    80002f68:	0129893b          	addw	s2,s3,s2
    80002f6c:	9aee                	add	s5,s5,s11
    80002f6e:	057a7663          	bgeu	s4,s7,80002fba <writei+0xd6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80002f72:	000b2483          	lw	s1,0(s6)
    80002f76:	00a9559b          	srliw	a1,s2,0xa
    80002f7a:	855a                	mv	a0,s6
    80002f7c:	fffff097          	auipc	ra,0xfffff
    80002f80:	7aa080e7          	jalr	1962(ra) # 80002726 <bmap>
    80002f84:	0005059b          	sext.w	a1,a0
    80002f88:	8526                	mv	a0,s1
    80002f8a:	fffff097          	auipc	ra,0xfffff
    80002f8e:	3ac080e7          	jalr	940(ra) # 80002336 <bread>
    80002f92:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002f94:	3ff97713          	andi	a4,s2,1023
    80002f98:	40ed07bb          	subw	a5,s10,a4
    80002f9c:	414b86bb          	subw	a3,s7,s4
    80002fa0:	89be                	mv	s3,a5
    80002fa2:	2781                	sext.w	a5,a5
    80002fa4:	0006861b          	sext.w	a2,a3
    80002fa8:	f8f674e3          	bgeu	a2,a5,80002f30 <writei+0x4c>
    80002fac:	89b6                	mv	s3,a3
    80002fae:	b749                	j	80002f30 <writei+0x4c>
      brelse(bp);
    80002fb0:	8526                	mv	a0,s1
    80002fb2:	fffff097          	auipc	ra,0xfffff
    80002fb6:	4b4080e7          	jalr	1204(ra) # 80002466 <brelse>
  }

  if(off > ip->size)
    80002fba:	04cb2783          	lw	a5,76(s6)
    80002fbe:	0127f463          	bgeu	a5,s2,80002fc6 <writei+0xe2>
    ip->size = off;
    80002fc2:	052b2623          	sw	s2,76(s6)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80002fc6:	855a                	mv	a0,s6
    80002fc8:	00000097          	auipc	ra,0x0
    80002fcc:	aa4080e7          	jalr	-1372(ra) # 80002a6c <iupdate>

  return tot;
    80002fd0:	000a051b          	sext.w	a0,s4
}
    80002fd4:	70a6                	ld	ra,104(sp)
    80002fd6:	7406                	ld	s0,96(sp)
    80002fd8:	64e6                	ld	s1,88(sp)
    80002fda:	6946                	ld	s2,80(sp)
    80002fdc:	69a6                	ld	s3,72(sp)
    80002fde:	6a06                	ld	s4,64(sp)
    80002fe0:	7ae2                	ld	s5,56(sp)
    80002fe2:	7b42                	ld	s6,48(sp)
    80002fe4:	7ba2                	ld	s7,40(sp)
    80002fe6:	7c02                	ld	s8,32(sp)
    80002fe8:	6ce2                	ld	s9,24(sp)
    80002fea:	6d42                	ld	s10,16(sp)
    80002fec:	6da2                	ld	s11,8(sp)
    80002fee:	6165                	addi	sp,sp,112
    80002ff0:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002ff2:	8a5e                	mv	s4,s7
    80002ff4:	bfc9                	j	80002fc6 <writei+0xe2>
    return -1;
    80002ff6:	557d                	li	a0,-1
}
    80002ff8:	8082                	ret
    return -1;
    80002ffa:	557d                	li	a0,-1
    80002ffc:	bfe1                	j	80002fd4 <writei+0xf0>
    return -1;
    80002ffe:	557d                	li	a0,-1
    80003000:	bfd1                	j	80002fd4 <writei+0xf0>

0000000080003002 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80003002:	1141                	addi	sp,sp,-16
    80003004:	e406                	sd	ra,8(sp)
    80003006:	e022                	sd	s0,0(sp)
    80003008:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    8000300a:	4639                	li	a2,14
    8000300c:	ffffd097          	auipc	ra,0xffffd
    80003010:	23e080e7          	jalr	574(ra) # 8000024a <strncmp>
}
    80003014:	60a2                	ld	ra,8(sp)
    80003016:	6402                	ld	s0,0(sp)
    80003018:	0141                	addi	sp,sp,16
    8000301a:	8082                	ret

000000008000301c <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    8000301c:	7139                	addi	sp,sp,-64
    8000301e:	fc06                	sd	ra,56(sp)
    80003020:	f822                	sd	s0,48(sp)
    80003022:	f426                	sd	s1,40(sp)
    80003024:	f04a                	sd	s2,32(sp)
    80003026:	ec4e                	sd	s3,24(sp)
    80003028:	e852                	sd	s4,16(sp)
    8000302a:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    8000302c:	04451703          	lh	a4,68(a0)
    80003030:	4785                	li	a5,1
    80003032:	00f71a63          	bne	a4,a5,80003046 <dirlookup+0x2a>
    80003036:	892a                	mv	s2,a0
    80003038:	89ae                	mv	s3,a1
    8000303a:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    8000303c:	457c                	lw	a5,76(a0)
    8000303e:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80003040:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003042:	e79d                	bnez	a5,80003070 <dirlookup+0x54>
    80003044:	a8a5                	j	800030bc <dirlookup+0xa0>
    panic("dirlookup not DIR");
    80003046:	00005517          	auipc	a0,0x5
    8000304a:	6a250513          	addi	a0,a0,1698 # 800086e8 <syscall_names+0x1a8>
    8000304e:	00003097          	auipc	ra,0x3
    80003052:	b62080e7          	jalr	-1182(ra) # 80005bb0 <panic>
      panic("dirlookup read");
    80003056:	00005517          	auipc	a0,0x5
    8000305a:	6aa50513          	addi	a0,a0,1706 # 80008700 <syscall_names+0x1c0>
    8000305e:	00003097          	auipc	ra,0x3
    80003062:	b52080e7          	jalr	-1198(ra) # 80005bb0 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003066:	24c1                	addiw	s1,s1,16
    80003068:	04c92783          	lw	a5,76(s2)
    8000306c:	04f4f763          	bgeu	s1,a5,800030ba <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003070:	4741                	li	a4,16
    80003072:	86a6                	mv	a3,s1
    80003074:	fc040613          	addi	a2,s0,-64
    80003078:	4581                	li	a1,0
    8000307a:	854a                	mv	a0,s2
    8000307c:	00000097          	auipc	ra,0x0
    80003080:	d70080e7          	jalr	-656(ra) # 80002dec <readi>
    80003084:	47c1                	li	a5,16
    80003086:	fcf518e3          	bne	a0,a5,80003056 <dirlookup+0x3a>
    if(de.inum == 0)
    8000308a:	fc045783          	lhu	a5,-64(s0)
    8000308e:	dfe1                	beqz	a5,80003066 <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    80003090:	fc240593          	addi	a1,s0,-62
    80003094:	854e                	mv	a0,s3
    80003096:	00000097          	auipc	ra,0x0
    8000309a:	f6c080e7          	jalr	-148(ra) # 80003002 <namecmp>
    8000309e:	f561                	bnez	a0,80003066 <dirlookup+0x4a>
      if(poff)
    800030a0:	000a0463          	beqz	s4,800030a8 <dirlookup+0x8c>
        *poff = off;
    800030a4:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    800030a8:	fc045583          	lhu	a1,-64(s0)
    800030ac:	00092503          	lw	a0,0(s2)
    800030b0:	fffff097          	auipc	ra,0xfffff
    800030b4:	752080e7          	jalr	1874(ra) # 80002802 <iget>
    800030b8:	a011                	j	800030bc <dirlookup+0xa0>
  return 0;
    800030ba:	4501                	li	a0,0
}
    800030bc:	70e2                	ld	ra,56(sp)
    800030be:	7442                	ld	s0,48(sp)
    800030c0:	74a2                	ld	s1,40(sp)
    800030c2:	7902                	ld	s2,32(sp)
    800030c4:	69e2                	ld	s3,24(sp)
    800030c6:	6a42                	ld	s4,16(sp)
    800030c8:	6121                	addi	sp,sp,64
    800030ca:	8082                	ret

00000000800030cc <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    800030cc:	711d                	addi	sp,sp,-96
    800030ce:	ec86                	sd	ra,88(sp)
    800030d0:	e8a2                	sd	s0,80(sp)
    800030d2:	e4a6                	sd	s1,72(sp)
    800030d4:	e0ca                	sd	s2,64(sp)
    800030d6:	fc4e                	sd	s3,56(sp)
    800030d8:	f852                	sd	s4,48(sp)
    800030da:	f456                	sd	s5,40(sp)
    800030dc:	f05a                	sd	s6,32(sp)
    800030de:	ec5e                	sd	s7,24(sp)
    800030e0:	e862                	sd	s8,16(sp)
    800030e2:	e466                	sd	s9,8(sp)
    800030e4:	e06a                	sd	s10,0(sp)
    800030e6:	1080                	addi	s0,sp,96
    800030e8:	84aa                	mv	s1,a0
    800030ea:	8b2e                	mv	s6,a1
    800030ec:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    800030ee:	00054703          	lbu	a4,0(a0)
    800030f2:	02f00793          	li	a5,47
    800030f6:	02f70363          	beq	a4,a5,8000311c <namex+0x50>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    800030fa:	ffffe097          	auipc	ra,0xffffe
    800030fe:	d4a080e7          	jalr	-694(ra) # 80000e44 <myproc>
    80003102:	15053503          	ld	a0,336(a0)
    80003106:	00000097          	auipc	ra,0x0
    8000310a:	9f4080e7          	jalr	-1548(ra) # 80002afa <idup>
    8000310e:	8a2a                	mv	s4,a0
  while(*path == '/')
    80003110:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    80003114:	4cb5                	li	s9,13
  len = path - s;
    80003116:	4b81                	li	s7,0

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80003118:	4c05                	li	s8,1
    8000311a:	a87d                	j	800031d8 <namex+0x10c>
    ip = iget(ROOTDEV, ROOTINO);
    8000311c:	4585                	li	a1,1
    8000311e:	4505                	li	a0,1
    80003120:	fffff097          	auipc	ra,0xfffff
    80003124:	6e2080e7          	jalr	1762(ra) # 80002802 <iget>
    80003128:	8a2a                	mv	s4,a0
    8000312a:	b7dd                	j	80003110 <namex+0x44>
      iunlockput(ip);
    8000312c:	8552                	mv	a0,s4
    8000312e:	00000097          	auipc	ra,0x0
    80003132:	c6c080e7          	jalr	-916(ra) # 80002d9a <iunlockput>
      return 0;
    80003136:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80003138:	8552                	mv	a0,s4
    8000313a:	60e6                	ld	ra,88(sp)
    8000313c:	6446                	ld	s0,80(sp)
    8000313e:	64a6                	ld	s1,72(sp)
    80003140:	6906                	ld	s2,64(sp)
    80003142:	79e2                	ld	s3,56(sp)
    80003144:	7a42                	ld	s4,48(sp)
    80003146:	7aa2                	ld	s5,40(sp)
    80003148:	7b02                	ld	s6,32(sp)
    8000314a:	6be2                	ld	s7,24(sp)
    8000314c:	6c42                	ld	s8,16(sp)
    8000314e:	6ca2                	ld	s9,8(sp)
    80003150:	6d02                	ld	s10,0(sp)
    80003152:	6125                	addi	sp,sp,96
    80003154:	8082                	ret
      iunlock(ip);
    80003156:	8552                	mv	a0,s4
    80003158:	00000097          	auipc	ra,0x0
    8000315c:	aa2080e7          	jalr	-1374(ra) # 80002bfa <iunlock>
      return ip;
    80003160:	bfe1                	j	80003138 <namex+0x6c>
      iunlockput(ip);
    80003162:	8552                	mv	a0,s4
    80003164:	00000097          	auipc	ra,0x0
    80003168:	c36080e7          	jalr	-970(ra) # 80002d9a <iunlockput>
      return 0;
    8000316c:	8a4e                	mv	s4,s3
    8000316e:	b7e9                	j	80003138 <namex+0x6c>
  len = path - s;
    80003170:	40998633          	sub	a2,s3,s1
    80003174:	00060d1b          	sext.w	s10,a2
  if(len >= DIRSIZ)
    80003178:	09acd863          	bge	s9,s10,80003208 <namex+0x13c>
    memmove(name, s, DIRSIZ);
    8000317c:	4639                	li	a2,14
    8000317e:	85a6                	mv	a1,s1
    80003180:	8556                	mv	a0,s5
    80003182:	ffffd097          	auipc	ra,0xffffd
    80003186:	054080e7          	jalr	84(ra) # 800001d6 <memmove>
    8000318a:	84ce                	mv	s1,s3
  while(*path == '/')
    8000318c:	0004c783          	lbu	a5,0(s1)
    80003190:	01279763          	bne	a5,s2,8000319e <namex+0xd2>
    path++;
    80003194:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003196:	0004c783          	lbu	a5,0(s1)
    8000319a:	ff278de3          	beq	a5,s2,80003194 <namex+0xc8>
    ilock(ip);
    8000319e:	8552                	mv	a0,s4
    800031a0:	00000097          	auipc	ra,0x0
    800031a4:	998080e7          	jalr	-1640(ra) # 80002b38 <ilock>
    if(ip->type != T_DIR){
    800031a8:	044a1783          	lh	a5,68(s4)
    800031ac:	f98790e3          	bne	a5,s8,8000312c <namex+0x60>
    if(nameiparent && *path == '\0'){
    800031b0:	000b0563          	beqz	s6,800031ba <namex+0xee>
    800031b4:	0004c783          	lbu	a5,0(s1)
    800031b8:	dfd9                	beqz	a5,80003156 <namex+0x8a>
    if((next = dirlookup(ip, name, 0)) == 0){
    800031ba:	865e                	mv	a2,s7
    800031bc:	85d6                	mv	a1,s5
    800031be:	8552                	mv	a0,s4
    800031c0:	00000097          	auipc	ra,0x0
    800031c4:	e5c080e7          	jalr	-420(ra) # 8000301c <dirlookup>
    800031c8:	89aa                	mv	s3,a0
    800031ca:	dd41                	beqz	a0,80003162 <namex+0x96>
    iunlockput(ip);
    800031cc:	8552                	mv	a0,s4
    800031ce:	00000097          	auipc	ra,0x0
    800031d2:	bcc080e7          	jalr	-1076(ra) # 80002d9a <iunlockput>
    ip = next;
    800031d6:	8a4e                	mv	s4,s3
  while(*path == '/')
    800031d8:	0004c783          	lbu	a5,0(s1)
    800031dc:	01279763          	bne	a5,s2,800031ea <namex+0x11e>
    path++;
    800031e0:	0485                	addi	s1,s1,1
  while(*path == '/')
    800031e2:	0004c783          	lbu	a5,0(s1)
    800031e6:	ff278de3          	beq	a5,s2,800031e0 <namex+0x114>
  if(*path == 0)
    800031ea:	cb9d                	beqz	a5,80003220 <namex+0x154>
  while(*path != '/' && *path != 0)
    800031ec:	0004c783          	lbu	a5,0(s1)
    800031f0:	89a6                	mv	s3,s1
  len = path - s;
    800031f2:	8d5e                	mv	s10,s7
    800031f4:	865e                	mv	a2,s7
  while(*path != '/' && *path != 0)
    800031f6:	01278963          	beq	a5,s2,80003208 <namex+0x13c>
    800031fa:	dbbd                	beqz	a5,80003170 <namex+0xa4>
    path++;
    800031fc:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    800031fe:	0009c783          	lbu	a5,0(s3)
    80003202:	ff279ce3          	bne	a5,s2,800031fa <namex+0x12e>
    80003206:	b7ad                	j	80003170 <namex+0xa4>
    memmove(name, s, len);
    80003208:	2601                	sext.w	a2,a2
    8000320a:	85a6                	mv	a1,s1
    8000320c:	8556                	mv	a0,s5
    8000320e:	ffffd097          	auipc	ra,0xffffd
    80003212:	fc8080e7          	jalr	-56(ra) # 800001d6 <memmove>
    name[len] = 0;
    80003216:	9d56                	add	s10,s10,s5
    80003218:	000d0023          	sb	zero,0(s10)
    8000321c:	84ce                	mv	s1,s3
    8000321e:	b7bd                	j	8000318c <namex+0xc0>
  if(nameiparent){
    80003220:	f00b0ce3          	beqz	s6,80003138 <namex+0x6c>
    iput(ip);
    80003224:	8552                	mv	a0,s4
    80003226:	00000097          	auipc	ra,0x0
    8000322a:	acc080e7          	jalr	-1332(ra) # 80002cf2 <iput>
    return 0;
    8000322e:	4a01                	li	s4,0
    80003230:	b721                	j	80003138 <namex+0x6c>

0000000080003232 <dirlink>:
{
    80003232:	7139                	addi	sp,sp,-64
    80003234:	fc06                	sd	ra,56(sp)
    80003236:	f822                	sd	s0,48(sp)
    80003238:	f426                	sd	s1,40(sp)
    8000323a:	f04a                	sd	s2,32(sp)
    8000323c:	ec4e                	sd	s3,24(sp)
    8000323e:	e852                	sd	s4,16(sp)
    80003240:	0080                	addi	s0,sp,64
    80003242:	892a                	mv	s2,a0
    80003244:	8a2e                	mv	s4,a1
    80003246:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80003248:	4601                	li	a2,0
    8000324a:	00000097          	auipc	ra,0x0
    8000324e:	dd2080e7          	jalr	-558(ra) # 8000301c <dirlookup>
    80003252:	e93d                	bnez	a0,800032c8 <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003254:	04c92483          	lw	s1,76(s2)
    80003258:	c49d                	beqz	s1,80003286 <dirlink+0x54>
    8000325a:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000325c:	4741                	li	a4,16
    8000325e:	86a6                	mv	a3,s1
    80003260:	fc040613          	addi	a2,s0,-64
    80003264:	4581                	li	a1,0
    80003266:	854a                	mv	a0,s2
    80003268:	00000097          	auipc	ra,0x0
    8000326c:	b84080e7          	jalr	-1148(ra) # 80002dec <readi>
    80003270:	47c1                	li	a5,16
    80003272:	06f51163          	bne	a0,a5,800032d4 <dirlink+0xa2>
    if(de.inum == 0)
    80003276:	fc045783          	lhu	a5,-64(s0)
    8000327a:	c791                	beqz	a5,80003286 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000327c:	24c1                	addiw	s1,s1,16
    8000327e:	04c92783          	lw	a5,76(s2)
    80003282:	fcf4ede3          	bltu	s1,a5,8000325c <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    80003286:	4639                	li	a2,14
    80003288:	85d2                	mv	a1,s4
    8000328a:	fc240513          	addi	a0,s0,-62
    8000328e:	ffffd097          	auipc	ra,0xffffd
    80003292:	ff8080e7          	jalr	-8(ra) # 80000286 <strncpy>
  de.inum = inum;
    80003296:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000329a:	4741                	li	a4,16
    8000329c:	86a6                	mv	a3,s1
    8000329e:	fc040613          	addi	a2,s0,-64
    800032a2:	4581                	li	a1,0
    800032a4:	854a                	mv	a0,s2
    800032a6:	00000097          	auipc	ra,0x0
    800032aa:	c3e080e7          	jalr	-962(ra) # 80002ee4 <writei>
    800032ae:	872a                	mv	a4,a0
    800032b0:	47c1                	li	a5,16
  return 0;
    800032b2:	4501                	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800032b4:	02f71863          	bne	a4,a5,800032e4 <dirlink+0xb2>
}
    800032b8:	70e2                	ld	ra,56(sp)
    800032ba:	7442                	ld	s0,48(sp)
    800032bc:	74a2                	ld	s1,40(sp)
    800032be:	7902                	ld	s2,32(sp)
    800032c0:	69e2                	ld	s3,24(sp)
    800032c2:	6a42                	ld	s4,16(sp)
    800032c4:	6121                	addi	sp,sp,64
    800032c6:	8082                	ret
    iput(ip);
    800032c8:	00000097          	auipc	ra,0x0
    800032cc:	a2a080e7          	jalr	-1494(ra) # 80002cf2 <iput>
    return -1;
    800032d0:	557d                	li	a0,-1
    800032d2:	b7dd                	j	800032b8 <dirlink+0x86>
      panic("dirlink read");
    800032d4:	00005517          	auipc	a0,0x5
    800032d8:	43c50513          	addi	a0,a0,1084 # 80008710 <syscall_names+0x1d0>
    800032dc:	00003097          	auipc	ra,0x3
    800032e0:	8d4080e7          	jalr	-1836(ra) # 80005bb0 <panic>
    panic("dirlink");
    800032e4:	00005517          	auipc	a0,0x5
    800032e8:	53450513          	addi	a0,a0,1332 # 80008818 <syscall_names+0x2d8>
    800032ec:	00003097          	auipc	ra,0x3
    800032f0:	8c4080e7          	jalr	-1852(ra) # 80005bb0 <panic>

00000000800032f4 <namei>:

struct inode*
namei(char *path)
{
    800032f4:	1101                	addi	sp,sp,-32
    800032f6:	ec06                	sd	ra,24(sp)
    800032f8:	e822                	sd	s0,16(sp)
    800032fa:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    800032fc:	fe040613          	addi	a2,s0,-32
    80003300:	4581                	li	a1,0
    80003302:	00000097          	auipc	ra,0x0
    80003306:	dca080e7          	jalr	-566(ra) # 800030cc <namex>
}
    8000330a:	60e2                	ld	ra,24(sp)
    8000330c:	6442                	ld	s0,16(sp)
    8000330e:	6105                	addi	sp,sp,32
    80003310:	8082                	ret

0000000080003312 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80003312:	1141                	addi	sp,sp,-16
    80003314:	e406                	sd	ra,8(sp)
    80003316:	e022                	sd	s0,0(sp)
    80003318:	0800                	addi	s0,sp,16
    8000331a:	862e                	mv	a2,a1
  return namex(path, 1, name);
    8000331c:	4585                	li	a1,1
    8000331e:	00000097          	auipc	ra,0x0
    80003322:	dae080e7          	jalr	-594(ra) # 800030cc <namex>
}
    80003326:	60a2                	ld	ra,8(sp)
    80003328:	6402                	ld	s0,0(sp)
    8000332a:	0141                	addi	sp,sp,16
    8000332c:	8082                	ret

000000008000332e <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    8000332e:	1101                	addi	sp,sp,-32
    80003330:	ec06                	sd	ra,24(sp)
    80003332:	e822                	sd	s0,16(sp)
    80003334:	e426                	sd	s1,8(sp)
    80003336:	e04a                	sd	s2,0(sp)
    80003338:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    8000333a:	00016917          	auipc	s2,0x16
    8000333e:	2e690913          	addi	s2,s2,742 # 80019620 <log>
    80003342:	01892583          	lw	a1,24(s2)
    80003346:	02892503          	lw	a0,40(s2)
    8000334a:	fffff097          	auipc	ra,0xfffff
    8000334e:	fec080e7          	jalr	-20(ra) # 80002336 <bread>
    80003352:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80003354:	02c92683          	lw	a3,44(s2)
    80003358:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    8000335a:	02d05863          	blez	a3,8000338a <write_head+0x5c>
    8000335e:	00016797          	auipc	a5,0x16
    80003362:	2f278793          	addi	a5,a5,754 # 80019650 <log+0x30>
    80003366:	05c50713          	addi	a4,a0,92
    8000336a:	36fd                	addiw	a3,a3,-1
    8000336c:	02069613          	slli	a2,a3,0x20
    80003370:	01e65693          	srli	a3,a2,0x1e
    80003374:	00016617          	auipc	a2,0x16
    80003378:	2e060613          	addi	a2,a2,736 # 80019654 <log+0x34>
    8000337c:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    8000337e:	4390                	lw	a2,0(a5)
    80003380:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003382:	0791                	addi	a5,a5,4
    80003384:	0711                	addi	a4,a4,4 # 43004 <_entry-0x7ffbcffc>
    80003386:	fed79ce3          	bne	a5,a3,8000337e <write_head+0x50>
  }
  bwrite(buf);
    8000338a:	8526                	mv	a0,s1
    8000338c:	fffff097          	auipc	ra,0xfffff
    80003390:	09c080e7          	jalr	156(ra) # 80002428 <bwrite>
  brelse(buf);
    80003394:	8526                	mv	a0,s1
    80003396:	fffff097          	auipc	ra,0xfffff
    8000339a:	0d0080e7          	jalr	208(ra) # 80002466 <brelse>
}
    8000339e:	60e2                	ld	ra,24(sp)
    800033a0:	6442                	ld	s0,16(sp)
    800033a2:	64a2                	ld	s1,8(sp)
    800033a4:	6902                	ld	s2,0(sp)
    800033a6:	6105                	addi	sp,sp,32
    800033a8:	8082                	ret

00000000800033aa <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    800033aa:	00016797          	auipc	a5,0x16
    800033ae:	2a27a783          	lw	a5,674(a5) # 8001964c <log+0x2c>
    800033b2:	0af05d63          	blez	a5,8000346c <install_trans+0xc2>
{
    800033b6:	7139                	addi	sp,sp,-64
    800033b8:	fc06                	sd	ra,56(sp)
    800033ba:	f822                	sd	s0,48(sp)
    800033bc:	f426                	sd	s1,40(sp)
    800033be:	f04a                	sd	s2,32(sp)
    800033c0:	ec4e                	sd	s3,24(sp)
    800033c2:	e852                	sd	s4,16(sp)
    800033c4:	e456                	sd	s5,8(sp)
    800033c6:	e05a                	sd	s6,0(sp)
    800033c8:	0080                	addi	s0,sp,64
    800033ca:	8b2a                	mv	s6,a0
    800033cc:	00016a97          	auipc	s5,0x16
    800033d0:	284a8a93          	addi	s5,s5,644 # 80019650 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    800033d4:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800033d6:	00016997          	auipc	s3,0x16
    800033da:	24a98993          	addi	s3,s3,586 # 80019620 <log>
    800033de:	a00d                	j	80003400 <install_trans+0x56>
    brelse(lbuf);
    800033e0:	854a                	mv	a0,s2
    800033e2:	fffff097          	auipc	ra,0xfffff
    800033e6:	084080e7          	jalr	132(ra) # 80002466 <brelse>
    brelse(dbuf);
    800033ea:	8526                	mv	a0,s1
    800033ec:	fffff097          	auipc	ra,0xfffff
    800033f0:	07a080e7          	jalr	122(ra) # 80002466 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800033f4:	2a05                	addiw	s4,s4,1
    800033f6:	0a91                	addi	s5,s5,4
    800033f8:	02c9a783          	lw	a5,44(s3)
    800033fc:	04fa5e63          	bge	s4,a5,80003458 <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003400:	0189a583          	lw	a1,24(s3)
    80003404:	014585bb          	addw	a1,a1,s4
    80003408:	2585                	addiw	a1,a1,1
    8000340a:	0289a503          	lw	a0,40(s3)
    8000340e:	fffff097          	auipc	ra,0xfffff
    80003412:	f28080e7          	jalr	-216(ra) # 80002336 <bread>
    80003416:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80003418:	000aa583          	lw	a1,0(s5)
    8000341c:	0289a503          	lw	a0,40(s3)
    80003420:	fffff097          	auipc	ra,0xfffff
    80003424:	f16080e7          	jalr	-234(ra) # 80002336 <bread>
    80003428:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    8000342a:	40000613          	li	a2,1024
    8000342e:	05890593          	addi	a1,s2,88
    80003432:	05850513          	addi	a0,a0,88
    80003436:	ffffd097          	auipc	ra,0xffffd
    8000343a:	da0080e7          	jalr	-608(ra) # 800001d6 <memmove>
    bwrite(dbuf);  // write dst to disk
    8000343e:	8526                	mv	a0,s1
    80003440:	fffff097          	auipc	ra,0xfffff
    80003444:	fe8080e7          	jalr	-24(ra) # 80002428 <bwrite>
    if(recovering == 0)
    80003448:	f80b1ce3          	bnez	s6,800033e0 <install_trans+0x36>
      bunpin(dbuf);
    8000344c:	8526                	mv	a0,s1
    8000344e:	fffff097          	auipc	ra,0xfffff
    80003452:	0f2080e7          	jalr	242(ra) # 80002540 <bunpin>
    80003456:	b769                	j	800033e0 <install_trans+0x36>
}
    80003458:	70e2                	ld	ra,56(sp)
    8000345a:	7442                	ld	s0,48(sp)
    8000345c:	74a2                	ld	s1,40(sp)
    8000345e:	7902                	ld	s2,32(sp)
    80003460:	69e2                	ld	s3,24(sp)
    80003462:	6a42                	ld	s4,16(sp)
    80003464:	6aa2                	ld	s5,8(sp)
    80003466:	6b02                	ld	s6,0(sp)
    80003468:	6121                	addi	sp,sp,64
    8000346a:	8082                	ret
    8000346c:	8082                	ret

000000008000346e <initlog>:
{
    8000346e:	7179                	addi	sp,sp,-48
    80003470:	f406                	sd	ra,40(sp)
    80003472:	f022                	sd	s0,32(sp)
    80003474:	ec26                	sd	s1,24(sp)
    80003476:	e84a                	sd	s2,16(sp)
    80003478:	e44e                	sd	s3,8(sp)
    8000347a:	1800                	addi	s0,sp,48
    8000347c:	892a                	mv	s2,a0
    8000347e:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80003480:	00016497          	auipc	s1,0x16
    80003484:	1a048493          	addi	s1,s1,416 # 80019620 <log>
    80003488:	00005597          	auipc	a1,0x5
    8000348c:	29858593          	addi	a1,a1,664 # 80008720 <syscall_names+0x1e0>
    80003490:	8526                	mv	a0,s1
    80003492:	00003097          	auipc	ra,0x3
    80003496:	bc6080e7          	jalr	-1082(ra) # 80006058 <initlock>
  log.start = sb->logstart;
    8000349a:	0149a583          	lw	a1,20(s3)
    8000349e:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    800034a0:	0109a783          	lw	a5,16(s3)
    800034a4:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    800034a6:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    800034aa:	854a                	mv	a0,s2
    800034ac:	fffff097          	auipc	ra,0xfffff
    800034b0:	e8a080e7          	jalr	-374(ra) # 80002336 <bread>
  log.lh.n = lh->n;
    800034b4:	4d34                	lw	a3,88(a0)
    800034b6:	d4d4                	sw	a3,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    800034b8:	02d05663          	blez	a3,800034e4 <initlog+0x76>
    800034bc:	05c50793          	addi	a5,a0,92
    800034c0:	00016717          	auipc	a4,0x16
    800034c4:	19070713          	addi	a4,a4,400 # 80019650 <log+0x30>
    800034c8:	36fd                	addiw	a3,a3,-1
    800034ca:	02069613          	slli	a2,a3,0x20
    800034ce:	01e65693          	srli	a3,a2,0x1e
    800034d2:	06050613          	addi	a2,a0,96
    800034d6:	96b2                	add	a3,a3,a2
    log.lh.block[i] = lh->block[i];
    800034d8:	4390                	lw	a2,0(a5)
    800034da:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    800034dc:	0791                	addi	a5,a5,4
    800034de:	0711                	addi	a4,a4,4
    800034e0:	fed79ce3          	bne	a5,a3,800034d8 <initlog+0x6a>
  brelse(buf);
    800034e4:	fffff097          	auipc	ra,0xfffff
    800034e8:	f82080e7          	jalr	-126(ra) # 80002466 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    800034ec:	4505                	li	a0,1
    800034ee:	00000097          	auipc	ra,0x0
    800034f2:	ebc080e7          	jalr	-324(ra) # 800033aa <install_trans>
  log.lh.n = 0;
    800034f6:	00016797          	auipc	a5,0x16
    800034fa:	1407ab23          	sw	zero,342(a5) # 8001964c <log+0x2c>
  write_head(); // clear the log
    800034fe:	00000097          	auipc	ra,0x0
    80003502:	e30080e7          	jalr	-464(ra) # 8000332e <write_head>
}
    80003506:	70a2                	ld	ra,40(sp)
    80003508:	7402                	ld	s0,32(sp)
    8000350a:	64e2                	ld	s1,24(sp)
    8000350c:	6942                	ld	s2,16(sp)
    8000350e:	69a2                	ld	s3,8(sp)
    80003510:	6145                	addi	sp,sp,48
    80003512:	8082                	ret

0000000080003514 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80003514:	1101                	addi	sp,sp,-32
    80003516:	ec06                	sd	ra,24(sp)
    80003518:	e822                	sd	s0,16(sp)
    8000351a:	e426                	sd	s1,8(sp)
    8000351c:	e04a                	sd	s2,0(sp)
    8000351e:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80003520:	00016517          	auipc	a0,0x16
    80003524:	10050513          	addi	a0,a0,256 # 80019620 <log>
    80003528:	00003097          	auipc	ra,0x3
    8000352c:	bc0080e7          	jalr	-1088(ra) # 800060e8 <acquire>
  while(1){
    if(log.committing){
    80003530:	00016497          	auipc	s1,0x16
    80003534:	0f048493          	addi	s1,s1,240 # 80019620 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003538:	4979                	li	s2,30
    8000353a:	a039                	j	80003548 <begin_op+0x34>
      sleep(&log, &log.lock);
    8000353c:	85a6                	mv	a1,s1
    8000353e:	8526                	mv	a0,s1
    80003540:	ffffe097          	auipc	ra,0xffffe
    80003544:	fda080e7          	jalr	-38(ra) # 8000151a <sleep>
    if(log.committing){
    80003548:	50dc                	lw	a5,36(s1)
    8000354a:	fbed                	bnez	a5,8000353c <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    8000354c:	5098                	lw	a4,32(s1)
    8000354e:	2705                	addiw	a4,a4,1
    80003550:	0007069b          	sext.w	a3,a4
    80003554:	0027179b          	slliw	a5,a4,0x2
    80003558:	9fb9                	addw	a5,a5,a4
    8000355a:	0017979b          	slliw	a5,a5,0x1
    8000355e:	54d8                	lw	a4,44(s1)
    80003560:	9fb9                	addw	a5,a5,a4
    80003562:	00f95963          	bge	s2,a5,80003574 <begin_op+0x60>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80003566:	85a6                	mv	a1,s1
    80003568:	8526                	mv	a0,s1
    8000356a:	ffffe097          	auipc	ra,0xffffe
    8000356e:	fb0080e7          	jalr	-80(ra) # 8000151a <sleep>
    80003572:	bfd9                	j	80003548 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    80003574:	00016517          	auipc	a0,0x16
    80003578:	0ac50513          	addi	a0,a0,172 # 80019620 <log>
    8000357c:	d114                	sw	a3,32(a0)
      release(&log.lock);
    8000357e:	00003097          	auipc	ra,0x3
    80003582:	c1e080e7          	jalr	-994(ra) # 8000619c <release>
      break;
    }
  }
}
    80003586:	60e2                	ld	ra,24(sp)
    80003588:	6442                	ld	s0,16(sp)
    8000358a:	64a2                	ld	s1,8(sp)
    8000358c:	6902                	ld	s2,0(sp)
    8000358e:	6105                	addi	sp,sp,32
    80003590:	8082                	ret

0000000080003592 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80003592:	7139                	addi	sp,sp,-64
    80003594:	fc06                	sd	ra,56(sp)
    80003596:	f822                	sd	s0,48(sp)
    80003598:	f426                	sd	s1,40(sp)
    8000359a:	f04a                	sd	s2,32(sp)
    8000359c:	ec4e                	sd	s3,24(sp)
    8000359e:	e852                	sd	s4,16(sp)
    800035a0:	e456                	sd	s5,8(sp)
    800035a2:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    800035a4:	00016497          	auipc	s1,0x16
    800035a8:	07c48493          	addi	s1,s1,124 # 80019620 <log>
    800035ac:	8526                	mv	a0,s1
    800035ae:	00003097          	auipc	ra,0x3
    800035b2:	b3a080e7          	jalr	-1222(ra) # 800060e8 <acquire>
  log.outstanding -= 1;
    800035b6:	509c                	lw	a5,32(s1)
    800035b8:	37fd                	addiw	a5,a5,-1
    800035ba:	0007891b          	sext.w	s2,a5
    800035be:	d09c                	sw	a5,32(s1)
  if(log.committing)
    800035c0:	50dc                	lw	a5,36(s1)
    800035c2:	e7b9                	bnez	a5,80003610 <end_op+0x7e>
    panic("log.committing");
  if(log.outstanding == 0){
    800035c4:	04091e63          	bnez	s2,80003620 <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    800035c8:	00016497          	auipc	s1,0x16
    800035cc:	05848493          	addi	s1,s1,88 # 80019620 <log>
    800035d0:	4785                	li	a5,1
    800035d2:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    800035d4:	8526                	mv	a0,s1
    800035d6:	00003097          	auipc	ra,0x3
    800035da:	bc6080e7          	jalr	-1082(ra) # 8000619c <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    800035de:	54dc                	lw	a5,44(s1)
    800035e0:	06f04763          	bgtz	a5,8000364e <end_op+0xbc>
    acquire(&log.lock);
    800035e4:	00016497          	auipc	s1,0x16
    800035e8:	03c48493          	addi	s1,s1,60 # 80019620 <log>
    800035ec:	8526                	mv	a0,s1
    800035ee:	00003097          	auipc	ra,0x3
    800035f2:	afa080e7          	jalr	-1286(ra) # 800060e8 <acquire>
    log.committing = 0;
    800035f6:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    800035fa:	8526                	mv	a0,s1
    800035fc:	ffffe097          	auipc	ra,0xffffe
    80003600:	0aa080e7          	jalr	170(ra) # 800016a6 <wakeup>
    release(&log.lock);
    80003604:	8526                	mv	a0,s1
    80003606:	00003097          	auipc	ra,0x3
    8000360a:	b96080e7          	jalr	-1130(ra) # 8000619c <release>
}
    8000360e:	a03d                	j	8000363c <end_op+0xaa>
    panic("log.committing");
    80003610:	00005517          	auipc	a0,0x5
    80003614:	11850513          	addi	a0,a0,280 # 80008728 <syscall_names+0x1e8>
    80003618:	00002097          	auipc	ra,0x2
    8000361c:	598080e7          	jalr	1432(ra) # 80005bb0 <panic>
    wakeup(&log);
    80003620:	00016497          	auipc	s1,0x16
    80003624:	00048493          	mv	s1,s1
    80003628:	8526                	mv	a0,s1
    8000362a:	ffffe097          	auipc	ra,0xffffe
    8000362e:	07c080e7          	jalr	124(ra) # 800016a6 <wakeup>
  release(&log.lock);
    80003632:	8526                	mv	a0,s1
    80003634:	00003097          	auipc	ra,0x3
    80003638:	b68080e7          	jalr	-1176(ra) # 8000619c <release>
}
    8000363c:	70e2                	ld	ra,56(sp)
    8000363e:	7442                	ld	s0,48(sp)
    80003640:	74a2                	ld	s1,40(sp)
    80003642:	7902                	ld	s2,32(sp)
    80003644:	69e2                	ld	s3,24(sp)
    80003646:	6a42                	ld	s4,16(sp)
    80003648:	6aa2                	ld	s5,8(sp)
    8000364a:	6121                	addi	sp,sp,64
    8000364c:	8082                	ret
  for (tail = 0; tail < log.lh.n; tail++) {
    8000364e:	00016a97          	auipc	s5,0x16
    80003652:	002a8a93          	addi	s5,s5,2 # 80019650 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80003656:	00016a17          	auipc	s4,0x16
    8000365a:	fcaa0a13          	addi	s4,s4,-54 # 80019620 <log>
    8000365e:	018a2583          	lw	a1,24(s4)
    80003662:	012585bb          	addw	a1,a1,s2
    80003666:	2585                	addiw	a1,a1,1
    80003668:	028a2503          	lw	a0,40(s4)
    8000366c:	fffff097          	auipc	ra,0xfffff
    80003670:	cca080e7          	jalr	-822(ra) # 80002336 <bread>
    80003674:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80003676:	000aa583          	lw	a1,0(s5)
    8000367a:	028a2503          	lw	a0,40(s4)
    8000367e:	fffff097          	auipc	ra,0xfffff
    80003682:	cb8080e7          	jalr	-840(ra) # 80002336 <bread>
    80003686:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80003688:	40000613          	li	a2,1024
    8000368c:	05850593          	addi	a1,a0,88
    80003690:	05848513          	addi	a0,s1,88 # 80019678 <log+0x58>
    80003694:	ffffd097          	auipc	ra,0xffffd
    80003698:	b42080e7          	jalr	-1214(ra) # 800001d6 <memmove>
    bwrite(to);  // write the log
    8000369c:	8526                	mv	a0,s1
    8000369e:	fffff097          	auipc	ra,0xfffff
    800036a2:	d8a080e7          	jalr	-630(ra) # 80002428 <bwrite>
    brelse(from);
    800036a6:	854e                	mv	a0,s3
    800036a8:	fffff097          	auipc	ra,0xfffff
    800036ac:	dbe080e7          	jalr	-578(ra) # 80002466 <brelse>
    brelse(to);
    800036b0:	8526                	mv	a0,s1
    800036b2:	fffff097          	auipc	ra,0xfffff
    800036b6:	db4080e7          	jalr	-588(ra) # 80002466 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800036ba:	2905                	addiw	s2,s2,1
    800036bc:	0a91                	addi	s5,s5,4
    800036be:	02ca2783          	lw	a5,44(s4)
    800036c2:	f8f94ee3          	blt	s2,a5,8000365e <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    800036c6:	00000097          	auipc	ra,0x0
    800036ca:	c68080e7          	jalr	-920(ra) # 8000332e <write_head>
    install_trans(0); // Now install writes to home locations
    800036ce:	4501                	li	a0,0
    800036d0:	00000097          	auipc	ra,0x0
    800036d4:	cda080e7          	jalr	-806(ra) # 800033aa <install_trans>
    log.lh.n = 0;
    800036d8:	00016797          	auipc	a5,0x16
    800036dc:	f607aa23          	sw	zero,-140(a5) # 8001964c <log+0x2c>
    write_head();    // Erase the transaction from the log
    800036e0:	00000097          	auipc	ra,0x0
    800036e4:	c4e080e7          	jalr	-946(ra) # 8000332e <write_head>
    800036e8:	bdf5                	j	800035e4 <end_op+0x52>

00000000800036ea <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    800036ea:	1101                	addi	sp,sp,-32
    800036ec:	ec06                	sd	ra,24(sp)
    800036ee:	e822                	sd	s0,16(sp)
    800036f0:	e426                	sd	s1,8(sp)
    800036f2:	e04a                	sd	s2,0(sp)
    800036f4:	1000                	addi	s0,sp,32
    800036f6:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    800036f8:	00016917          	auipc	s2,0x16
    800036fc:	f2890913          	addi	s2,s2,-216 # 80019620 <log>
    80003700:	854a                	mv	a0,s2
    80003702:	00003097          	auipc	ra,0x3
    80003706:	9e6080e7          	jalr	-1562(ra) # 800060e8 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    8000370a:	02c92603          	lw	a2,44(s2)
    8000370e:	47f5                	li	a5,29
    80003710:	06c7c563          	blt	a5,a2,8000377a <log_write+0x90>
    80003714:	00016797          	auipc	a5,0x16
    80003718:	f287a783          	lw	a5,-216(a5) # 8001963c <log+0x1c>
    8000371c:	37fd                	addiw	a5,a5,-1
    8000371e:	04f65e63          	bge	a2,a5,8000377a <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80003722:	00016797          	auipc	a5,0x16
    80003726:	f1e7a783          	lw	a5,-226(a5) # 80019640 <log+0x20>
    8000372a:	06f05063          	blez	a5,8000378a <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    8000372e:	4781                	li	a5,0
    80003730:	06c05563          	blez	a2,8000379a <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003734:	44cc                	lw	a1,12(s1)
    80003736:	00016717          	auipc	a4,0x16
    8000373a:	f1a70713          	addi	a4,a4,-230 # 80019650 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    8000373e:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003740:	4314                	lw	a3,0(a4)
    80003742:	04b68c63          	beq	a3,a1,8000379a <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    80003746:	2785                	addiw	a5,a5,1
    80003748:	0711                	addi	a4,a4,4
    8000374a:	fef61be3          	bne	a2,a5,80003740 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    8000374e:	0621                	addi	a2,a2,8
    80003750:	060a                	slli	a2,a2,0x2
    80003752:	00016797          	auipc	a5,0x16
    80003756:	ece78793          	addi	a5,a5,-306 # 80019620 <log>
    8000375a:	97b2                	add	a5,a5,a2
    8000375c:	44d8                	lw	a4,12(s1)
    8000375e:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80003760:	8526                	mv	a0,s1
    80003762:	fffff097          	auipc	ra,0xfffff
    80003766:	da2080e7          	jalr	-606(ra) # 80002504 <bpin>
    log.lh.n++;
    8000376a:	00016717          	auipc	a4,0x16
    8000376e:	eb670713          	addi	a4,a4,-330 # 80019620 <log>
    80003772:	575c                	lw	a5,44(a4)
    80003774:	2785                	addiw	a5,a5,1
    80003776:	d75c                	sw	a5,44(a4)
    80003778:	a82d                	j	800037b2 <log_write+0xc8>
    panic("too big a transaction");
    8000377a:	00005517          	auipc	a0,0x5
    8000377e:	fbe50513          	addi	a0,a0,-66 # 80008738 <syscall_names+0x1f8>
    80003782:	00002097          	auipc	ra,0x2
    80003786:	42e080e7          	jalr	1070(ra) # 80005bb0 <panic>
    panic("log_write outside of trans");
    8000378a:	00005517          	auipc	a0,0x5
    8000378e:	fc650513          	addi	a0,a0,-58 # 80008750 <syscall_names+0x210>
    80003792:	00002097          	auipc	ra,0x2
    80003796:	41e080e7          	jalr	1054(ra) # 80005bb0 <panic>
  log.lh.block[i] = b->blockno;
    8000379a:	00878693          	addi	a3,a5,8
    8000379e:	068a                	slli	a3,a3,0x2
    800037a0:	00016717          	auipc	a4,0x16
    800037a4:	e8070713          	addi	a4,a4,-384 # 80019620 <log>
    800037a8:	9736                	add	a4,a4,a3
    800037aa:	44d4                	lw	a3,12(s1)
    800037ac:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    800037ae:	faf609e3          	beq	a2,a5,80003760 <log_write+0x76>
  }
  release(&log.lock);
    800037b2:	00016517          	auipc	a0,0x16
    800037b6:	e6e50513          	addi	a0,a0,-402 # 80019620 <log>
    800037ba:	00003097          	auipc	ra,0x3
    800037be:	9e2080e7          	jalr	-1566(ra) # 8000619c <release>
}
    800037c2:	60e2                	ld	ra,24(sp)
    800037c4:	6442                	ld	s0,16(sp)
    800037c6:	64a2                	ld	s1,8(sp)
    800037c8:	6902                	ld	s2,0(sp)
    800037ca:	6105                	addi	sp,sp,32
    800037cc:	8082                	ret

00000000800037ce <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    800037ce:	1101                	addi	sp,sp,-32
    800037d0:	ec06                	sd	ra,24(sp)
    800037d2:	e822                	sd	s0,16(sp)
    800037d4:	e426                	sd	s1,8(sp)
    800037d6:	e04a                	sd	s2,0(sp)
    800037d8:	1000                	addi	s0,sp,32
    800037da:	84aa                	mv	s1,a0
    800037dc:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    800037de:	00005597          	auipc	a1,0x5
    800037e2:	f9258593          	addi	a1,a1,-110 # 80008770 <syscall_names+0x230>
    800037e6:	0521                	addi	a0,a0,8
    800037e8:	00003097          	auipc	ra,0x3
    800037ec:	870080e7          	jalr	-1936(ra) # 80006058 <initlock>
  lk->name = name;
    800037f0:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    800037f4:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800037f8:	0204a423          	sw	zero,40(s1)
}
    800037fc:	60e2                	ld	ra,24(sp)
    800037fe:	6442                	ld	s0,16(sp)
    80003800:	64a2                	ld	s1,8(sp)
    80003802:	6902                	ld	s2,0(sp)
    80003804:	6105                	addi	sp,sp,32
    80003806:	8082                	ret

0000000080003808 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80003808:	1101                	addi	sp,sp,-32
    8000380a:	ec06                	sd	ra,24(sp)
    8000380c:	e822                	sd	s0,16(sp)
    8000380e:	e426                	sd	s1,8(sp)
    80003810:	e04a                	sd	s2,0(sp)
    80003812:	1000                	addi	s0,sp,32
    80003814:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003816:	00850913          	addi	s2,a0,8
    8000381a:	854a                	mv	a0,s2
    8000381c:	00003097          	auipc	ra,0x3
    80003820:	8cc080e7          	jalr	-1844(ra) # 800060e8 <acquire>
  while (lk->locked) {
    80003824:	409c                	lw	a5,0(s1)
    80003826:	cb89                	beqz	a5,80003838 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    80003828:	85ca                	mv	a1,s2
    8000382a:	8526                	mv	a0,s1
    8000382c:	ffffe097          	auipc	ra,0xffffe
    80003830:	cee080e7          	jalr	-786(ra) # 8000151a <sleep>
  while (lk->locked) {
    80003834:	409c                	lw	a5,0(s1)
    80003836:	fbed                	bnez	a5,80003828 <acquiresleep+0x20>
  }
  lk->locked = 1;
    80003838:	4785                	li	a5,1
    8000383a:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    8000383c:	ffffd097          	auipc	ra,0xffffd
    80003840:	608080e7          	jalr	1544(ra) # 80000e44 <myproc>
    80003844:	591c                	lw	a5,48(a0)
    80003846:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80003848:	854a                	mv	a0,s2
    8000384a:	00003097          	auipc	ra,0x3
    8000384e:	952080e7          	jalr	-1710(ra) # 8000619c <release>
}
    80003852:	60e2                	ld	ra,24(sp)
    80003854:	6442                	ld	s0,16(sp)
    80003856:	64a2                	ld	s1,8(sp)
    80003858:	6902                	ld	s2,0(sp)
    8000385a:	6105                	addi	sp,sp,32
    8000385c:	8082                	ret

000000008000385e <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    8000385e:	1101                	addi	sp,sp,-32
    80003860:	ec06                	sd	ra,24(sp)
    80003862:	e822                	sd	s0,16(sp)
    80003864:	e426                	sd	s1,8(sp)
    80003866:	e04a                	sd	s2,0(sp)
    80003868:	1000                	addi	s0,sp,32
    8000386a:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    8000386c:	00850913          	addi	s2,a0,8
    80003870:	854a                	mv	a0,s2
    80003872:	00003097          	auipc	ra,0x3
    80003876:	876080e7          	jalr	-1930(ra) # 800060e8 <acquire>
  lk->locked = 0;
    8000387a:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    8000387e:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003882:	8526                	mv	a0,s1
    80003884:	ffffe097          	auipc	ra,0xffffe
    80003888:	e22080e7          	jalr	-478(ra) # 800016a6 <wakeup>
  release(&lk->lk);
    8000388c:	854a                	mv	a0,s2
    8000388e:	00003097          	auipc	ra,0x3
    80003892:	90e080e7          	jalr	-1778(ra) # 8000619c <release>
}
    80003896:	60e2                	ld	ra,24(sp)
    80003898:	6442                	ld	s0,16(sp)
    8000389a:	64a2                	ld	s1,8(sp)
    8000389c:	6902                	ld	s2,0(sp)
    8000389e:	6105                	addi	sp,sp,32
    800038a0:	8082                	ret

00000000800038a2 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    800038a2:	7179                	addi	sp,sp,-48
    800038a4:	f406                	sd	ra,40(sp)
    800038a6:	f022                	sd	s0,32(sp)
    800038a8:	ec26                	sd	s1,24(sp)
    800038aa:	e84a                	sd	s2,16(sp)
    800038ac:	e44e                	sd	s3,8(sp)
    800038ae:	1800                	addi	s0,sp,48
    800038b0:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    800038b2:	00850913          	addi	s2,a0,8
    800038b6:	854a                	mv	a0,s2
    800038b8:	00003097          	auipc	ra,0x3
    800038bc:	830080e7          	jalr	-2000(ra) # 800060e8 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    800038c0:	409c                	lw	a5,0(s1)
    800038c2:	ef99                	bnez	a5,800038e0 <holdingsleep+0x3e>
    800038c4:	4481                	li	s1,0
  release(&lk->lk);
    800038c6:	854a                	mv	a0,s2
    800038c8:	00003097          	auipc	ra,0x3
    800038cc:	8d4080e7          	jalr	-1836(ra) # 8000619c <release>
  return r;
}
    800038d0:	8526                	mv	a0,s1
    800038d2:	70a2                	ld	ra,40(sp)
    800038d4:	7402                	ld	s0,32(sp)
    800038d6:	64e2                	ld	s1,24(sp)
    800038d8:	6942                	ld	s2,16(sp)
    800038da:	69a2                	ld	s3,8(sp)
    800038dc:	6145                	addi	sp,sp,48
    800038de:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    800038e0:	0284a983          	lw	s3,40(s1)
    800038e4:	ffffd097          	auipc	ra,0xffffd
    800038e8:	560080e7          	jalr	1376(ra) # 80000e44 <myproc>
    800038ec:	5904                	lw	s1,48(a0)
    800038ee:	413484b3          	sub	s1,s1,s3
    800038f2:	0014b493          	seqz	s1,s1
    800038f6:	bfc1                	j	800038c6 <holdingsleep+0x24>

00000000800038f8 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    800038f8:	1141                	addi	sp,sp,-16
    800038fa:	e406                	sd	ra,8(sp)
    800038fc:	e022                	sd	s0,0(sp)
    800038fe:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003900:	00005597          	auipc	a1,0x5
    80003904:	e8058593          	addi	a1,a1,-384 # 80008780 <syscall_names+0x240>
    80003908:	00016517          	auipc	a0,0x16
    8000390c:	e6050513          	addi	a0,a0,-416 # 80019768 <ftable>
    80003910:	00002097          	auipc	ra,0x2
    80003914:	748080e7          	jalr	1864(ra) # 80006058 <initlock>
}
    80003918:	60a2                	ld	ra,8(sp)
    8000391a:	6402                	ld	s0,0(sp)
    8000391c:	0141                	addi	sp,sp,16
    8000391e:	8082                	ret

0000000080003920 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003920:	1101                	addi	sp,sp,-32
    80003922:	ec06                	sd	ra,24(sp)
    80003924:	e822                	sd	s0,16(sp)
    80003926:	e426                	sd	s1,8(sp)
    80003928:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    8000392a:	00016517          	auipc	a0,0x16
    8000392e:	e3e50513          	addi	a0,a0,-450 # 80019768 <ftable>
    80003932:	00002097          	auipc	ra,0x2
    80003936:	7b6080e7          	jalr	1974(ra) # 800060e8 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    8000393a:	00016497          	auipc	s1,0x16
    8000393e:	e4648493          	addi	s1,s1,-442 # 80019780 <ftable+0x18>
    80003942:	00017717          	auipc	a4,0x17
    80003946:	dde70713          	addi	a4,a4,-546 # 8001a720 <ftable+0xfb8>
    if(f->ref == 0){
    8000394a:	40dc                	lw	a5,4(s1)
    8000394c:	cf99                	beqz	a5,8000396a <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    8000394e:	02848493          	addi	s1,s1,40
    80003952:	fee49ce3          	bne	s1,a4,8000394a <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003956:	00016517          	auipc	a0,0x16
    8000395a:	e1250513          	addi	a0,a0,-494 # 80019768 <ftable>
    8000395e:	00003097          	auipc	ra,0x3
    80003962:	83e080e7          	jalr	-1986(ra) # 8000619c <release>
  return 0;
    80003966:	4481                	li	s1,0
    80003968:	a819                	j	8000397e <filealloc+0x5e>
      f->ref = 1;
    8000396a:	4785                	li	a5,1
    8000396c:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    8000396e:	00016517          	auipc	a0,0x16
    80003972:	dfa50513          	addi	a0,a0,-518 # 80019768 <ftable>
    80003976:	00003097          	auipc	ra,0x3
    8000397a:	826080e7          	jalr	-2010(ra) # 8000619c <release>
}
    8000397e:	8526                	mv	a0,s1
    80003980:	60e2                	ld	ra,24(sp)
    80003982:	6442                	ld	s0,16(sp)
    80003984:	64a2                	ld	s1,8(sp)
    80003986:	6105                	addi	sp,sp,32
    80003988:	8082                	ret

000000008000398a <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    8000398a:	1101                	addi	sp,sp,-32
    8000398c:	ec06                	sd	ra,24(sp)
    8000398e:	e822                	sd	s0,16(sp)
    80003990:	e426                	sd	s1,8(sp)
    80003992:	1000                	addi	s0,sp,32
    80003994:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003996:	00016517          	auipc	a0,0x16
    8000399a:	dd250513          	addi	a0,a0,-558 # 80019768 <ftable>
    8000399e:	00002097          	auipc	ra,0x2
    800039a2:	74a080e7          	jalr	1866(ra) # 800060e8 <acquire>
  if(f->ref < 1)
    800039a6:	40dc                	lw	a5,4(s1)
    800039a8:	02f05263          	blez	a5,800039cc <filedup+0x42>
    panic("filedup");
  f->ref++;
    800039ac:	2785                	addiw	a5,a5,1
    800039ae:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    800039b0:	00016517          	auipc	a0,0x16
    800039b4:	db850513          	addi	a0,a0,-584 # 80019768 <ftable>
    800039b8:	00002097          	auipc	ra,0x2
    800039bc:	7e4080e7          	jalr	2020(ra) # 8000619c <release>
  return f;
}
    800039c0:	8526                	mv	a0,s1
    800039c2:	60e2                	ld	ra,24(sp)
    800039c4:	6442                	ld	s0,16(sp)
    800039c6:	64a2                	ld	s1,8(sp)
    800039c8:	6105                	addi	sp,sp,32
    800039ca:	8082                	ret
    panic("filedup");
    800039cc:	00005517          	auipc	a0,0x5
    800039d0:	dbc50513          	addi	a0,a0,-580 # 80008788 <syscall_names+0x248>
    800039d4:	00002097          	auipc	ra,0x2
    800039d8:	1dc080e7          	jalr	476(ra) # 80005bb0 <panic>

00000000800039dc <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    800039dc:	7139                	addi	sp,sp,-64
    800039de:	fc06                	sd	ra,56(sp)
    800039e0:	f822                	sd	s0,48(sp)
    800039e2:	f426                	sd	s1,40(sp)
    800039e4:	f04a                	sd	s2,32(sp)
    800039e6:	ec4e                	sd	s3,24(sp)
    800039e8:	e852                	sd	s4,16(sp)
    800039ea:	e456                	sd	s5,8(sp)
    800039ec:	0080                	addi	s0,sp,64
    800039ee:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    800039f0:	00016517          	auipc	a0,0x16
    800039f4:	d7850513          	addi	a0,a0,-648 # 80019768 <ftable>
    800039f8:	00002097          	auipc	ra,0x2
    800039fc:	6f0080e7          	jalr	1776(ra) # 800060e8 <acquire>
  if(f->ref < 1)
    80003a00:	40dc                	lw	a5,4(s1)
    80003a02:	06f05163          	blez	a5,80003a64 <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80003a06:	37fd                	addiw	a5,a5,-1
    80003a08:	0007871b          	sext.w	a4,a5
    80003a0c:	c0dc                	sw	a5,4(s1)
    80003a0e:	06e04363          	bgtz	a4,80003a74 <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003a12:	0004a903          	lw	s2,0(s1)
    80003a16:	0094ca83          	lbu	s5,9(s1)
    80003a1a:	0104ba03          	ld	s4,16(s1)
    80003a1e:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003a22:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003a26:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003a2a:	00016517          	auipc	a0,0x16
    80003a2e:	d3e50513          	addi	a0,a0,-706 # 80019768 <ftable>
    80003a32:	00002097          	auipc	ra,0x2
    80003a36:	76a080e7          	jalr	1898(ra) # 8000619c <release>

  if(ff.type == FD_PIPE){
    80003a3a:	4785                	li	a5,1
    80003a3c:	04f90d63          	beq	s2,a5,80003a96 <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003a40:	3979                	addiw	s2,s2,-2
    80003a42:	4785                	li	a5,1
    80003a44:	0527e063          	bltu	a5,s2,80003a84 <fileclose+0xa8>
    begin_op();
    80003a48:	00000097          	auipc	ra,0x0
    80003a4c:	acc080e7          	jalr	-1332(ra) # 80003514 <begin_op>
    iput(ff.ip);
    80003a50:	854e                	mv	a0,s3
    80003a52:	fffff097          	auipc	ra,0xfffff
    80003a56:	2a0080e7          	jalr	672(ra) # 80002cf2 <iput>
    end_op();
    80003a5a:	00000097          	auipc	ra,0x0
    80003a5e:	b38080e7          	jalr	-1224(ra) # 80003592 <end_op>
    80003a62:	a00d                	j	80003a84 <fileclose+0xa8>
    panic("fileclose");
    80003a64:	00005517          	auipc	a0,0x5
    80003a68:	d2c50513          	addi	a0,a0,-724 # 80008790 <syscall_names+0x250>
    80003a6c:	00002097          	auipc	ra,0x2
    80003a70:	144080e7          	jalr	324(ra) # 80005bb0 <panic>
    release(&ftable.lock);
    80003a74:	00016517          	auipc	a0,0x16
    80003a78:	cf450513          	addi	a0,a0,-780 # 80019768 <ftable>
    80003a7c:	00002097          	auipc	ra,0x2
    80003a80:	720080e7          	jalr	1824(ra) # 8000619c <release>
  }
}
    80003a84:	70e2                	ld	ra,56(sp)
    80003a86:	7442                	ld	s0,48(sp)
    80003a88:	74a2                	ld	s1,40(sp)
    80003a8a:	7902                	ld	s2,32(sp)
    80003a8c:	69e2                	ld	s3,24(sp)
    80003a8e:	6a42                	ld	s4,16(sp)
    80003a90:	6aa2                	ld	s5,8(sp)
    80003a92:	6121                	addi	sp,sp,64
    80003a94:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003a96:	85d6                	mv	a1,s5
    80003a98:	8552                	mv	a0,s4
    80003a9a:	00000097          	auipc	ra,0x0
    80003a9e:	34c080e7          	jalr	844(ra) # 80003de6 <pipeclose>
    80003aa2:	b7cd                	j	80003a84 <fileclose+0xa8>

0000000080003aa4 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003aa4:	715d                	addi	sp,sp,-80
    80003aa6:	e486                	sd	ra,72(sp)
    80003aa8:	e0a2                	sd	s0,64(sp)
    80003aaa:	fc26                	sd	s1,56(sp)
    80003aac:	f84a                	sd	s2,48(sp)
    80003aae:	f44e                	sd	s3,40(sp)
    80003ab0:	0880                	addi	s0,sp,80
    80003ab2:	84aa                	mv	s1,a0
    80003ab4:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003ab6:	ffffd097          	auipc	ra,0xffffd
    80003aba:	38e080e7          	jalr	910(ra) # 80000e44 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003abe:	409c                	lw	a5,0(s1)
    80003ac0:	37f9                	addiw	a5,a5,-2
    80003ac2:	4705                	li	a4,1
    80003ac4:	04f76763          	bltu	a4,a5,80003b12 <filestat+0x6e>
    80003ac8:	892a                	mv	s2,a0
    ilock(f->ip);
    80003aca:	6c88                	ld	a0,24(s1)
    80003acc:	fffff097          	auipc	ra,0xfffff
    80003ad0:	06c080e7          	jalr	108(ra) # 80002b38 <ilock>
    stati(f->ip, &st);
    80003ad4:	fb840593          	addi	a1,s0,-72
    80003ad8:	6c88                	ld	a0,24(s1)
    80003ada:	fffff097          	auipc	ra,0xfffff
    80003ade:	2e8080e7          	jalr	744(ra) # 80002dc2 <stati>
    iunlock(f->ip);
    80003ae2:	6c88                	ld	a0,24(s1)
    80003ae4:	fffff097          	auipc	ra,0xfffff
    80003ae8:	116080e7          	jalr	278(ra) # 80002bfa <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003aec:	46e1                	li	a3,24
    80003aee:	fb840613          	addi	a2,s0,-72
    80003af2:	85ce                	mv	a1,s3
    80003af4:	05093503          	ld	a0,80(s2)
    80003af8:	ffffd097          	auipc	ra,0xffffd
    80003afc:	010080e7          	jalr	16(ra) # 80000b08 <copyout>
    80003b00:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80003b04:	60a6                	ld	ra,72(sp)
    80003b06:	6406                	ld	s0,64(sp)
    80003b08:	74e2                	ld	s1,56(sp)
    80003b0a:	7942                	ld	s2,48(sp)
    80003b0c:	79a2                	ld	s3,40(sp)
    80003b0e:	6161                	addi	sp,sp,80
    80003b10:	8082                	ret
  return -1;
    80003b12:	557d                	li	a0,-1
    80003b14:	bfc5                	j	80003b04 <filestat+0x60>

0000000080003b16 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003b16:	7179                	addi	sp,sp,-48
    80003b18:	f406                	sd	ra,40(sp)
    80003b1a:	f022                	sd	s0,32(sp)
    80003b1c:	ec26                	sd	s1,24(sp)
    80003b1e:	e84a                	sd	s2,16(sp)
    80003b20:	e44e                	sd	s3,8(sp)
    80003b22:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003b24:	00854783          	lbu	a5,8(a0)
    80003b28:	c3d5                	beqz	a5,80003bcc <fileread+0xb6>
    80003b2a:	84aa                	mv	s1,a0
    80003b2c:	89ae                	mv	s3,a1
    80003b2e:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003b30:	411c                	lw	a5,0(a0)
    80003b32:	4705                	li	a4,1
    80003b34:	04e78963          	beq	a5,a4,80003b86 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003b38:	470d                	li	a4,3
    80003b3a:	04e78d63          	beq	a5,a4,80003b94 <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003b3e:	4709                	li	a4,2
    80003b40:	06e79e63          	bne	a5,a4,80003bbc <fileread+0xa6>
    ilock(f->ip);
    80003b44:	6d08                	ld	a0,24(a0)
    80003b46:	fffff097          	auipc	ra,0xfffff
    80003b4a:	ff2080e7          	jalr	-14(ra) # 80002b38 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003b4e:	874a                	mv	a4,s2
    80003b50:	5094                	lw	a3,32(s1)
    80003b52:	864e                	mv	a2,s3
    80003b54:	4585                	li	a1,1
    80003b56:	6c88                	ld	a0,24(s1)
    80003b58:	fffff097          	auipc	ra,0xfffff
    80003b5c:	294080e7          	jalr	660(ra) # 80002dec <readi>
    80003b60:	892a                	mv	s2,a0
    80003b62:	00a05563          	blez	a0,80003b6c <fileread+0x56>
      f->off += r;
    80003b66:	509c                	lw	a5,32(s1)
    80003b68:	9fa9                	addw	a5,a5,a0
    80003b6a:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003b6c:	6c88                	ld	a0,24(s1)
    80003b6e:	fffff097          	auipc	ra,0xfffff
    80003b72:	08c080e7          	jalr	140(ra) # 80002bfa <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80003b76:	854a                	mv	a0,s2
    80003b78:	70a2                	ld	ra,40(sp)
    80003b7a:	7402                	ld	s0,32(sp)
    80003b7c:	64e2                	ld	s1,24(sp)
    80003b7e:	6942                	ld	s2,16(sp)
    80003b80:	69a2                	ld	s3,8(sp)
    80003b82:	6145                	addi	sp,sp,48
    80003b84:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003b86:	6908                	ld	a0,16(a0)
    80003b88:	00000097          	auipc	ra,0x0
    80003b8c:	3c0080e7          	jalr	960(ra) # 80003f48 <piperead>
    80003b90:	892a                	mv	s2,a0
    80003b92:	b7d5                	j	80003b76 <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003b94:	02451783          	lh	a5,36(a0)
    80003b98:	03079693          	slli	a3,a5,0x30
    80003b9c:	92c1                	srli	a3,a3,0x30
    80003b9e:	4725                	li	a4,9
    80003ba0:	02d76863          	bltu	a4,a3,80003bd0 <fileread+0xba>
    80003ba4:	0792                	slli	a5,a5,0x4
    80003ba6:	00016717          	auipc	a4,0x16
    80003baa:	b2270713          	addi	a4,a4,-1246 # 800196c8 <devsw>
    80003bae:	97ba                	add	a5,a5,a4
    80003bb0:	639c                	ld	a5,0(a5)
    80003bb2:	c38d                	beqz	a5,80003bd4 <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80003bb4:	4505                	li	a0,1
    80003bb6:	9782                	jalr	a5
    80003bb8:	892a                	mv	s2,a0
    80003bba:	bf75                	j	80003b76 <fileread+0x60>
    panic("fileread");
    80003bbc:	00005517          	auipc	a0,0x5
    80003bc0:	be450513          	addi	a0,a0,-1052 # 800087a0 <syscall_names+0x260>
    80003bc4:	00002097          	auipc	ra,0x2
    80003bc8:	fec080e7          	jalr	-20(ra) # 80005bb0 <panic>
    return -1;
    80003bcc:	597d                	li	s2,-1
    80003bce:	b765                	j	80003b76 <fileread+0x60>
      return -1;
    80003bd0:	597d                	li	s2,-1
    80003bd2:	b755                	j	80003b76 <fileread+0x60>
    80003bd4:	597d                	li	s2,-1
    80003bd6:	b745                	j	80003b76 <fileread+0x60>

0000000080003bd8 <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    80003bd8:	715d                	addi	sp,sp,-80
    80003bda:	e486                	sd	ra,72(sp)
    80003bdc:	e0a2                	sd	s0,64(sp)
    80003bde:	fc26                	sd	s1,56(sp)
    80003be0:	f84a                	sd	s2,48(sp)
    80003be2:	f44e                	sd	s3,40(sp)
    80003be4:	f052                	sd	s4,32(sp)
    80003be6:	ec56                	sd	s5,24(sp)
    80003be8:	e85a                	sd	s6,16(sp)
    80003bea:	e45e                	sd	s7,8(sp)
    80003bec:	e062                	sd	s8,0(sp)
    80003bee:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    80003bf0:	00954783          	lbu	a5,9(a0)
    80003bf4:	10078663          	beqz	a5,80003d00 <filewrite+0x128>
    80003bf8:	892a                	mv	s2,a0
    80003bfa:	8b2e                	mv	s6,a1
    80003bfc:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003bfe:	411c                	lw	a5,0(a0)
    80003c00:	4705                	li	a4,1
    80003c02:	02e78263          	beq	a5,a4,80003c26 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003c06:	470d                	li	a4,3
    80003c08:	02e78663          	beq	a5,a4,80003c34 <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003c0c:	4709                	li	a4,2
    80003c0e:	0ee79163          	bne	a5,a4,80003cf0 <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003c12:	0ac05d63          	blez	a2,80003ccc <filewrite+0xf4>
    int i = 0;
    80003c16:	4981                	li	s3,0
    80003c18:	6b85                	lui	s7,0x1
    80003c1a:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80003c1e:	6c05                	lui	s8,0x1
    80003c20:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    80003c24:	a861                	j	80003cbc <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    80003c26:	6908                	ld	a0,16(a0)
    80003c28:	00000097          	auipc	ra,0x0
    80003c2c:	22e080e7          	jalr	558(ra) # 80003e56 <pipewrite>
    80003c30:	8a2a                	mv	s4,a0
    80003c32:	a045                	j	80003cd2 <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003c34:	02451783          	lh	a5,36(a0)
    80003c38:	03079693          	slli	a3,a5,0x30
    80003c3c:	92c1                	srli	a3,a3,0x30
    80003c3e:	4725                	li	a4,9
    80003c40:	0cd76263          	bltu	a4,a3,80003d04 <filewrite+0x12c>
    80003c44:	0792                	slli	a5,a5,0x4
    80003c46:	00016717          	auipc	a4,0x16
    80003c4a:	a8270713          	addi	a4,a4,-1406 # 800196c8 <devsw>
    80003c4e:	97ba                	add	a5,a5,a4
    80003c50:	679c                	ld	a5,8(a5)
    80003c52:	cbdd                	beqz	a5,80003d08 <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    80003c54:	4505                	li	a0,1
    80003c56:	9782                	jalr	a5
    80003c58:	8a2a                	mv	s4,a0
    80003c5a:	a8a5                	j	80003cd2 <filewrite+0xfa>
    80003c5c:	00048a9b          	sext.w	s5,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80003c60:	00000097          	auipc	ra,0x0
    80003c64:	8b4080e7          	jalr	-1868(ra) # 80003514 <begin_op>
      ilock(f->ip);
    80003c68:	01893503          	ld	a0,24(s2)
    80003c6c:	fffff097          	auipc	ra,0xfffff
    80003c70:	ecc080e7          	jalr	-308(ra) # 80002b38 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003c74:	8756                	mv	a4,s5
    80003c76:	02092683          	lw	a3,32(s2)
    80003c7a:	01698633          	add	a2,s3,s6
    80003c7e:	4585                	li	a1,1
    80003c80:	01893503          	ld	a0,24(s2)
    80003c84:	fffff097          	auipc	ra,0xfffff
    80003c88:	260080e7          	jalr	608(ra) # 80002ee4 <writei>
    80003c8c:	84aa                	mv	s1,a0
    80003c8e:	00a05763          	blez	a0,80003c9c <filewrite+0xc4>
        f->off += r;
    80003c92:	02092783          	lw	a5,32(s2)
    80003c96:	9fa9                	addw	a5,a5,a0
    80003c98:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003c9c:	01893503          	ld	a0,24(s2)
    80003ca0:	fffff097          	auipc	ra,0xfffff
    80003ca4:	f5a080e7          	jalr	-166(ra) # 80002bfa <iunlock>
      end_op();
    80003ca8:	00000097          	auipc	ra,0x0
    80003cac:	8ea080e7          	jalr	-1814(ra) # 80003592 <end_op>

      if(r != n1){
    80003cb0:	009a9f63          	bne	s5,s1,80003cce <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    80003cb4:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003cb8:	0149db63          	bge	s3,s4,80003cce <filewrite+0xf6>
      int n1 = n - i;
    80003cbc:	413a04bb          	subw	s1,s4,s3
    80003cc0:	0004879b          	sext.w	a5,s1
    80003cc4:	f8fbdce3          	bge	s7,a5,80003c5c <filewrite+0x84>
    80003cc8:	84e2                	mv	s1,s8
    80003cca:	bf49                	j	80003c5c <filewrite+0x84>
    int i = 0;
    80003ccc:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80003cce:	013a1f63          	bne	s4,s3,80003cec <filewrite+0x114>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003cd2:	8552                	mv	a0,s4
    80003cd4:	60a6                	ld	ra,72(sp)
    80003cd6:	6406                	ld	s0,64(sp)
    80003cd8:	74e2                	ld	s1,56(sp)
    80003cda:	7942                	ld	s2,48(sp)
    80003cdc:	79a2                	ld	s3,40(sp)
    80003cde:	7a02                	ld	s4,32(sp)
    80003ce0:	6ae2                	ld	s5,24(sp)
    80003ce2:	6b42                	ld	s6,16(sp)
    80003ce4:	6ba2                	ld	s7,8(sp)
    80003ce6:	6c02                	ld	s8,0(sp)
    80003ce8:	6161                	addi	sp,sp,80
    80003cea:	8082                	ret
    ret = (i == n ? n : -1);
    80003cec:	5a7d                	li	s4,-1
    80003cee:	b7d5                	j	80003cd2 <filewrite+0xfa>
    panic("filewrite");
    80003cf0:	00005517          	auipc	a0,0x5
    80003cf4:	ac050513          	addi	a0,a0,-1344 # 800087b0 <syscall_names+0x270>
    80003cf8:	00002097          	auipc	ra,0x2
    80003cfc:	eb8080e7          	jalr	-328(ra) # 80005bb0 <panic>
    return -1;
    80003d00:	5a7d                	li	s4,-1
    80003d02:	bfc1                	j	80003cd2 <filewrite+0xfa>
      return -1;
    80003d04:	5a7d                	li	s4,-1
    80003d06:	b7f1                	j	80003cd2 <filewrite+0xfa>
    80003d08:	5a7d                	li	s4,-1
    80003d0a:	b7e1                	j	80003cd2 <filewrite+0xfa>

0000000080003d0c <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003d0c:	7179                	addi	sp,sp,-48
    80003d0e:	f406                	sd	ra,40(sp)
    80003d10:	f022                	sd	s0,32(sp)
    80003d12:	ec26                	sd	s1,24(sp)
    80003d14:	e84a                	sd	s2,16(sp)
    80003d16:	e44e                	sd	s3,8(sp)
    80003d18:	e052                	sd	s4,0(sp)
    80003d1a:	1800                	addi	s0,sp,48
    80003d1c:	84aa                	mv	s1,a0
    80003d1e:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003d20:	0005b023          	sd	zero,0(a1)
    80003d24:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003d28:	00000097          	auipc	ra,0x0
    80003d2c:	bf8080e7          	jalr	-1032(ra) # 80003920 <filealloc>
    80003d30:	e088                	sd	a0,0(s1)
    80003d32:	c551                	beqz	a0,80003dbe <pipealloc+0xb2>
    80003d34:	00000097          	auipc	ra,0x0
    80003d38:	bec080e7          	jalr	-1044(ra) # 80003920 <filealloc>
    80003d3c:	00aa3023          	sd	a0,0(s4)
    80003d40:	c92d                	beqz	a0,80003db2 <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003d42:	ffffc097          	auipc	ra,0xffffc
    80003d46:	3d8080e7          	jalr	984(ra) # 8000011a <kalloc>
    80003d4a:	892a                	mv	s2,a0
    80003d4c:	c125                	beqz	a0,80003dac <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80003d4e:	4985                	li	s3,1
    80003d50:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003d54:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003d58:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003d5c:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003d60:	00004597          	auipc	a1,0x4
    80003d64:	68058593          	addi	a1,a1,1664 # 800083e0 <states.0+0x1a0>
    80003d68:	00002097          	auipc	ra,0x2
    80003d6c:	2f0080e7          	jalr	752(ra) # 80006058 <initlock>
  (*f0)->type = FD_PIPE;
    80003d70:	609c                	ld	a5,0(s1)
    80003d72:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003d76:	609c                	ld	a5,0(s1)
    80003d78:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003d7c:	609c                	ld	a5,0(s1)
    80003d7e:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003d82:	609c                	ld	a5,0(s1)
    80003d84:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003d88:	000a3783          	ld	a5,0(s4)
    80003d8c:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003d90:	000a3783          	ld	a5,0(s4)
    80003d94:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003d98:	000a3783          	ld	a5,0(s4)
    80003d9c:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003da0:	000a3783          	ld	a5,0(s4)
    80003da4:	0127b823          	sd	s2,16(a5)
  return 0;
    80003da8:	4501                	li	a0,0
    80003daa:	a025                	j	80003dd2 <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003dac:	6088                	ld	a0,0(s1)
    80003dae:	e501                	bnez	a0,80003db6 <pipealloc+0xaa>
    80003db0:	a039                	j	80003dbe <pipealloc+0xb2>
    80003db2:	6088                	ld	a0,0(s1)
    80003db4:	c51d                	beqz	a0,80003de2 <pipealloc+0xd6>
    fileclose(*f0);
    80003db6:	00000097          	auipc	ra,0x0
    80003dba:	c26080e7          	jalr	-986(ra) # 800039dc <fileclose>
  if(*f1)
    80003dbe:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003dc2:	557d                	li	a0,-1
  if(*f1)
    80003dc4:	c799                	beqz	a5,80003dd2 <pipealloc+0xc6>
    fileclose(*f1);
    80003dc6:	853e                	mv	a0,a5
    80003dc8:	00000097          	auipc	ra,0x0
    80003dcc:	c14080e7          	jalr	-1004(ra) # 800039dc <fileclose>
  return -1;
    80003dd0:	557d                	li	a0,-1
}
    80003dd2:	70a2                	ld	ra,40(sp)
    80003dd4:	7402                	ld	s0,32(sp)
    80003dd6:	64e2                	ld	s1,24(sp)
    80003dd8:	6942                	ld	s2,16(sp)
    80003dda:	69a2                	ld	s3,8(sp)
    80003ddc:	6a02                	ld	s4,0(sp)
    80003dde:	6145                	addi	sp,sp,48
    80003de0:	8082                	ret
  return -1;
    80003de2:	557d                	li	a0,-1
    80003de4:	b7fd                	j	80003dd2 <pipealloc+0xc6>

0000000080003de6 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003de6:	1101                	addi	sp,sp,-32
    80003de8:	ec06                	sd	ra,24(sp)
    80003dea:	e822                	sd	s0,16(sp)
    80003dec:	e426                	sd	s1,8(sp)
    80003dee:	e04a                	sd	s2,0(sp)
    80003df0:	1000                	addi	s0,sp,32
    80003df2:	84aa                	mv	s1,a0
    80003df4:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003df6:	00002097          	auipc	ra,0x2
    80003dfa:	2f2080e7          	jalr	754(ra) # 800060e8 <acquire>
  if(writable){
    80003dfe:	02090d63          	beqz	s2,80003e38 <pipeclose+0x52>
    pi->writeopen = 0;
    80003e02:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003e06:	21848513          	addi	a0,s1,536
    80003e0a:	ffffe097          	auipc	ra,0xffffe
    80003e0e:	89c080e7          	jalr	-1892(ra) # 800016a6 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003e12:	2204b783          	ld	a5,544(s1)
    80003e16:	eb95                	bnez	a5,80003e4a <pipeclose+0x64>
    release(&pi->lock);
    80003e18:	8526                	mv	a0,s1
    80003e1a:	00002097          	auipc	ra,0x2
    80003e1e:	382080e7          	jalr	898(ra) # 8000619c <release>
    kfree((char*)pi);
    80003e22:	8526                	mv	a0,s1
    80003e24:	ffffc097          	auipc	ra,0xffffc
    80003e28:	1f8080e7          	jalr	504(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80003e2c:	60e2                	ld	ra,24(sp)
    80003e2e:	6442                	ld	s0,16(sp)
    80003e30:	64a2                	ld	s1,8(sp)
    80003e32:	6902                	ld	s2,0(sp)
    80003e34:	6105                	addi	sp,sp,32
    80003e36:	8082                	ret
    pi->readopen = 0;
    80003e38:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80003e3c:	21c48513          	addi	a0,s1,540
    80003e40:	ffffe097          	auipc	ra,0xffffe
    80003e44:	866080e7          	jalr	-1946(ra) # 800016a6 <wakeup>
    80003e48:	b7e9                	j	80003e12 <pipeclose+0x2c>
    release(&pi->lock);
    80003e4a:	8526                	mv	a0,s1
    80003e4c:	00002097          	auipc	ra,0x2
    80003e50:	350080e7          	jalr	848(ra) # 8000619c <release>
}
    80003e54:	bfe1                	j	80003e2c <pipeclose+0x46>

0000000080003e56 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80003e56:	711d                	addi	sp,sp,-96
    80003e58:	ec86                	sd	ra,88(sp)
    80003e5a:	e8a2                	sd	s0,80(sp)
    80003e5c:	e4a6                	sd	s1,72(sp)
    80003e5e:	e0ca                	sd	s2,64(sp)
    80003e60:	fc4e                	sd	s3,56(sp)
    80003e62:	f852                	sd	s4,48(sp)
    80003e64:	f456                	sd	s5,40(sp)
    80003e66:	f05a                	sd	s6,32(sp)
    80003e68:	ec5e                	sd	s7,24(sp)
    80003e6a:	e862                	sd	s8,16(sp)
    80003e6c:	1080                	addi	s0,sp,96
    80003e6e:	84aa                	mv	s1,a0
    80003e70:	8aae                	mv	s5,a1
    80003e72:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80003e74:	ffffd097          	auipc	ra,0xffffd
    80003e78:	fd0080e7          	jalr	-48(ra) # 80000e44 <myproc>
    80003e7c:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80003e7e:	8526                	mv	a0,s1
    80003e80:	00002097          	auipc	ra,0x2
    80003e84:	268080e7          	jalr	616(ra) # 800060e8 <acquire>
  while(i < n){
    80003e88:	0b405363          	blez	s4,80003f2e <pipewrite+0xd8>
  int i = 0;
    80003e8c:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003e8e:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80003e90:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80003e94:	21c48b93          	addi	s7,s1,540
    80003e98:	a089                	j	80003eda <pipewrite+0x84>
      release(&pi->lock);
    80003e9a:	8526                	mv	a0,s1
    80003e9c:	00002097          	auipc	ra,0x2
    80003ea0:	300080e7          	jalr	768(ra) # 8000619c <release>
      return -1;
    80003ea4:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80003ea6:	854a                	mv	a0,s2
    80003ea8:	60e6                	ld	ra,88(sp)
    80003eaa:	6446                	ld	s0,80(sp)
    80003eac:	64a6                	ld	s1,72(sp)
    80003eae:	6906                	ld	s2,64(sp)
    80003eb0:	79e2                	ld	s3,56(sp)
    80003eb2:	7a42                	ld	s4,48(sp)
    80003eb4:	7aa2                	ld	s5,40(sp)
    80003eb6:	7b02                	ld	s6,32(sp)
    80003eb8:	6be2                	ld	s7,24(sp)
    80003eba:	6c42                	ld	s8,16(sp)
    80003ebc:	6125                	addi	sp,sp,96
    80003ebe:	8082                	ret
      wakeup(&pi->nread);
    80003ec0:	8562                	mv	a0,s8
    80003ec2:	ffffd097          	auipc	ra,0xffffd
    80003ec6:	7e4080e7          	jalr	2020(ra) # 800016a6 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80003eca:	85a6                	mv	a1,s1
    80003ecc:	855e                	mv	a0,s7
    80003ece:	ffffd097          	auipc	ra,0xffffd
    80003ed2:	64c080e7          	jalr	1612(ra) # 8000151a <sleep>
  while(i < n){
    80003ed6:	05495d63          	bge	s2,s4,80003f30 <pipewrite+0xda>
    if(pi->readopen == 0 || pr->killed){
    80003eda:	2204a783          	lw	a5,544(s1)
    80003ede:	dfd5                	beqz	a5,80003e9a <pipewrite+0x44>
    80003ee0:	0289a783          	lw	a5,40(s3)
    80003ee4:	fbdd                	bnez	a5,80003e9a <pipewrite+0x44>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80003ee6:	2184a783          	lw	a5,536(s1)
    80003eea:	21c4a703          	lw	a4,540(s1)
    80003eee:	2007879b          	addiw	a5,a5,512
    80003ef2:	fcf707e3          	beq	a4,a5,80003ec0 <pipewrite+0x6a>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003ef6:	4685                	li	a3,1
    80003ef8:	01590633          	add	a2,s2,s5
    80003efc:	faf40593          	addi	a1,s0,-81
    80003f00:	0509b503          	ld	a0,80(s3)
    80003f04:	ffffd097          	auipc	ra,0xffffd
    80003f08:	c90080e7          	jalr	-880(ra) # 80000b94 <copyin>
    80003f0c:	03650263          	beq	a0,s6,80003f30 <pipewrite+0xda>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80003f10:	21c4a783          	lw	a5,540(s1)
    80003f14:	0017871b          	addiw	a4,a5,1
    80003f18:	20e4ae23          	sw	a4,540(s1)
    80003f1c:	1ff7f793          	andi	a5,a5,511
    80003f20:	97a6                	add	a5,a5,s1
    80003f22:	faf44703          	lbu	a4,-81(s0)
    80003f26:	00e78c23          	sb	a4,24(a5)
      i++;
    80003f2a:	2905                	addiw	s2,s2,1
    80003f2c:	b76d                	j	80003ed6 <pipewrite+0x80>
  int i = 0;
    80003f2e:	4901                	li	s2,0
  wakeup(&pi->nread);
    80003f30:	21848513          	addi	a0,s1,536
    80003f34:	ffffd097          	auipc	ra,0xffffd
    80003f38:	772080e7          	jalr	1906(ra) # 800016a6 <wakeup>
  release(&pi->lock);
    80003f3c:	8526                	mv	a0,s1
    80003f3e:	00002097          	auipc	ra,0x2
    80003f42:	25e080e7          	jalr	606(ra) # 8000619c <release>
  return i;
    80003f46:	b785                	j	80003ea6 <pipewrite+0x50>

0000000080003f48 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80003f48:	715d                	addi	sp,sp,-80
    80003f4a:	e486                	sd	ra,72(sp)
    80003f4c:	e0a2                	sd	s0,64(sp)
    80003f4e:	fc26                	sd	s1,56(sp)
    80003f50:	f84a                	sd	s2,48(sp)
    80003f52:	f44e                	sd	s3,40(sp)
    80003f54:	f052                	sd	s4,32(sp)
    80003f56:	ec56                	sd	s5,24(sp)
    80003f58:	e85a                	sd	s6,16(sp)
    80003f5a:	0880                	addi	s0,sp,80
    80003f5c:	84aa                	mv	s1,a0
    80003f5e:	892e                	mv	s2,a1
    80003f60:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80003f62:	ffffd097          	auipc	ra,0xffffd
    80003f66:	ee2080e7          	jalr	-286(ra) # 80000e44 <myproc>
    80003f6a:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80003f6c:	8526                	mv	a0,s1
    80003f6e:	00002097          	auipc	ra,0x2
    80003f72:	17a080e7          	jalr	378(ra) # 800060e8 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003f76:	2184a703          	lw	a4,536(s1)
    80003f7a:	21c4a783          	lw	a5,540(s1)
    if(pr->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80003f7e:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003f82:	02f71463          	bne	a4,a5,80003faa <piperead+0x62>
    80003f86:	2244a783          	lw	a5,548(s1)
    80003f8a:	c385                	beqz	a5,80003faa <piperead+0x62>
    if(pr->killed){
    80003f8c:	028a2783          	lw	a5,40(s4)
    80003f90:	ebc9                	bnez	a5,80004022 <piperead+0xda>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80003f92:	85a6                	mv	a1,s1
    80003f94:	854e                	mv	a0,s3
    80003f96:	ffffd097          	auipc	ra,0xffffd
    80003f9a:	584080e7          	jalr	1412(ra) # 8000151a <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003f9e:	2184a703          	lw	a4,536(s1)
    80003fa2:	21c4a783          	lw	a5,540(s1)
    80003fa6:	fef700e3          	beq	a4,a5,80003f86 <piperead+0x3e>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003faa:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80003fac:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003fae:	05505463          	blez	s5,80003ff6 <piperead+0xae>
    if(pi->nread == pi->nwrite)
    80003fb2:	2184a783          	lw	a5,536(s1)
    80003fb6:	21c4a703          	lw	a4,540(s1)
    80003fba:	02f70e63          	beq	a4,a5,80003ff6 <piperead+0xae>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80003fbe:	0017871b          	addiw	a4,a5,1
    80003fc2:	20e4ac23          	sw	a4,536(s1)
    80003fc6:	1ff7f793          	andi	a5,a5,511
    80003fca:	97a6                	add	a5,a5,s1
    80003fcc:	0187c783          	lbu	a5,24(a5)
    80003fd0:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80003fd4:	4685                	li	a3,1
    80003fd6:	fbf40613          	addi	a2,s0,-65
    80003fda:	85ca                	mv	a1,s2
    80003fdc:	050a3503          	ld	a0,80(s4)
    80003fe0:	ffffd097          	auipc	ra,0xffffd
    80003fe4:	b28080e7          	jalr	-1240(ra) # 80000b08 <copyout>
    80003fe8:	01650763          	beq	a0,s6,80003ff6 <piperead+0xae>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003fec:	2985                	addiw	s3,s3,1
    80003fee:	0905                	addi	s2,s2,1
    80003ff0:	fd3a91e3          	bne	s5,s3,80003fb2 <piperead+0x6a>
    80003ff4:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80003ff6:	21c48513          	addi	a0,s1,540
    80003ffa:	ffffd097          	auipc	ra,0xffffd
    80003ffe:	6ac080e7          	jalr	1708(ra) # 800016a6 <wakeup>
  release(&pi->lock);
    80004002:	8526                	mv	a0,s1
    80004004:	00002097          	auipc	ra,0x2
    80004008:	198080e7          	jalr	408(ra) # 8000619c <release>
  return i;
}
    8000400c:	854e                	mv	a0,s3
    8000400e:	60a6                	ld	ra,72(sp)
    80004010:	6406                	ld	s0,64(sp)
    80004012:	74e2                	ld	s1,56(sp)
    80004014:	7942                	ld	s2,48(sp)
    80004016:	79a2                	ld	s3,40(sp)
    80004018:	7a02                	ld	s4,32(sp)
    8000401a:	6ae2                	ld	s5,24(sp)
    8000401c:	6b42                	ld	s6,16(sp)
    8000401e:	6161                	addi	sp,sp,80
    80004020:	8082                	ret
      release(&pi->lock);
    80004022:	8526                	mv	a0,s1
    80004024:	00002097          	auipc	ra,0x2
    80004028:	178080e7          	jalr	376(ra) # 8000619c <release>
      return -1;
    8000402c:	59fd                	li	s3,-1
    8000402e:	bff9                	j	8000400c <piperead+0xc4>

0000000080004030 <exec>:

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset, uint sz);

int
exec(char *path, char **argv)
{
    80004030:	de010113          	addi	sp,sp,-544
    80004034:	20113c23          	sd	ra,536(sp)
    80004038:	20813823          	sd	s0,528(sp)
    8000403c:	20913423          	sd	s1,520(sp)
    80004040:	21213023          	sd	s2,512(sp)
    80004044:	ffce                	sd	s3,504(sp)
    80004046:	fbd2                	sd	s4,496(sp)
    80004048:	f7d6                	sd	s5,488(sp)
    8000404a:	f3da                	sd	s6,480(sp)
    8000404c:	efde                	sd	s7,472(sp)
    8000404e:	ebe2                	sd	s8,464(sp)
    80004050:	e7e6                	sd	s9,456(sp)
    80004052:	e3ea                	sd	s10,448(sp)
    80004054:	ff6e                	sd	s11,440(sp)
    80004056:	1400                	addi	s0,sp,544
    80004058:	892a                	mv	s2,a0
    8000405a:	dea43423          	sd	a0,-536(s0)
    8000405e:	deb43823          	sd	a1,-528(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80004062:	ffffd097          	auipc	ra,0xffffd
    80004066:	de2080e7          	jalr	-542(ra) # 80000e44 <myproc>
    8000406a:	84aa                	mv	s1,a0

  begin_op();
    8000406c:	fffff097          	auipc	ra,0xfffff
    80004070:	4a8080e7          	jalr	1192(ra) # 80003514 <begin_op>

  if((ip = namei(path)) == 0){
    80004074:	854a                	mv	a0,s2
    80004076:	fffff097          	auipc	ra,0xfffff
    8000407a:	27e080e7          	jalr	638(ra) # 800032f4 <namei>
    8000407e:	c93d                	beqz	a0,800040f4 <exec+0xc4>
    80004080:	8aaa                	mv	s5,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80004082:	fffff097          	auipc	ra,0xfffff
    80004086:	ab6080e7          	jalr	-1354(ra) # 80002b38 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    8000408a:	04000713          	li	a4,64
    8000408e:	4681                	li	a3,0
    80004090:	e5040613          	addi	a2,s0,-432
    80004094:	4581                	li	a1,0
    80004096:	8556                	mv	a0,s5
    80004098:	fffff097          	auipc	ra,0xfffff
    8000409c:	d54080e7          	jalr	-684(ra) # 80002dec <readi>
    800040a0:	04000793          	li	a5,64
    800040a4:	00f51a63          	bne	a0,a5,800040b8 <exec+0x88>
    goto bad;
  if(elf.magic != ELF_MAGIC)
    800040a8:	e5042703          	lw	a4,-432(s0)
    800040ac:	464c47b7          	lui	a5,0x464c4
    800040b0:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    800040b4:	04f70663          	beq	a4,a5,80004100 <exec+0xd0>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    800040b8:	8556                	mv	a0,s5
    800040ba:	fffff097          	auipc	ra,0xfffff
    800040be:	ce0080e7          	jalr	-800(ra) # 80002d9a <iunlockput>
    end_op();
    800040c2:	fffff097          	auipc	ra,0xfffff
    800040c6:	4d0080e7          	jalr	1232(ra) # 80003592 <end_op>
  }
  return -1;
    800040ca:	557d                	li	a0,-1
}
    800040cc:	21813083          	ld	ra,536(sp)
    800040d0:	21013403          	ld	s0,528(sp)
    800040d4:	20813483          	ld	s1,520(sp)
    800040d8:	20013903          	ld	s2,512(sp)
    800040dc:	79fe                	ld	s3,504(sp)
    800040de:	7a5e                	ld	s4,496(sp)
    800040e0:	7abe                	ld	s5,488(sp)
    800040e2:	7b1e                	ld	s6,480(sp)
    800040e4:	6bfe                	ld	s7,472(sp)
    800040e6:	6c5e                	ld	s8,464(sp)
    800040e8:	6cbe                	ld	s9,456(sp)
    800040ea:	6d1e                	ld	s10,448(sp)
    800040ec:	7dfa                	ld	s11,440(sp)
    800040ee:	22010113          	addi	sp,sp,544
    800040f2:	8082                	ret
    end_op();
    800040f4:	fffff097          	auipc	ra,0xfffff
    800040f8:	49e080e7          	jalr	1182(ra) # 80003592 <end_op>
    return -1;
    800040fc:	557d                	li	a0,-1
    800040fe:	b7f9                	j	800040cc <exec+0x9c>
  if((pagetable = proc_pagetable(p)) == 0)
    80004100:	8526                	mv	a0,s1
    80004102:	ffffd097          	auipc	ra,0xffffd
    80004106:	e06080e7          	jalr	-506(ra) # 80000f08 <proc_pagetable>
    8000410a:	8b2a                	mv	s6,a0
    8000410c:	d555                	beqz	a0,800040b8 <exec+0x88>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000410e:	e7042783          	lw	a5,-400(s0)
    80004112:	e8845703          	lhu	a4,-376(s0)
    80004116:	c735                	beqz	a4,80004182 <exec+0x152>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004118:	4481                	li	s1,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000411a:	e0043423          	sd	zero,-504(s0)
    if((ph.vaddr % PGSIZE) != 0)
    8000411e:	6a05                	lui	s4,0x1
    80004120:	fffa0713          	addi	a4,s4,-1 # fff <_entry-0x7ffff001>
    80004124:	dee43023          	sd	a4,-544(s0)
loadseg(pagetable_t pagetable, uint64 va, struct inode *ip, uint offset, uint sz)
{
  uint i, n;
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    80004128:	6d85                	lui	s11,0x1
    8000412a:	7d7d                	lui	s10,0xfffff
    8000412c:	ac1d                	j	80004362 <exec+0x332>
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    8000412e:	00004517          	auipc	a0,0x4
    80004132:	69250513          	addi	a0,a0,1682 # 800087c0 <syscall_names+0x280>
    80004136:	00002097          	auipc	ra,0x2
    8000413a:	a7a080e7          	jalr	-1414(ra) # 80005bb0 <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    8000413e:	874a                	mv	a4,s2
    80004140:	009c86bb          	addw	a3,s9,s1
    80004144:	4581                	li	a1,0
    80004146:	8556                	mv	a0,s5
    80004148:	fffff097          	auipc	ra,0xfffff
    8000414c:	ca4080e7          	jalr	-860(ra) # 80002dec <readi>
    80004150:	2501                	sext.w	a0,a0
    80004152:	1aa91863          	bne	s2,a0,80004302 <exec+0x2d2>
  for(i = 0; i < sz; i += PGSIZE){
    80004156:	009d84bb          	addw	s1,s11,s1
    8000415a:	013d09bb          	addw	s3,s10,s3
    8000415e:	1f74f263          	bgeu	s1,s7,80004342 <exec+0x312>
    pa = walkaddr(pagetable, va + i);
    80004162:	02049593          	slli	a1,s1,0x20
    80004166:	9181                	srli	a1,a1,0x20
    80004168:	95e2                	add	a1,a1,s8
    8000416a:	855a                	mv	a0,s6
    8000416c:	ffffc097          	auipc	ra,0xffffc
    80004170:	394080e7          	jalr	916(ra) # 80000500 <walkaddr>
    80004174:	862a                	mv	a2,a0
    if(pa == 0)
    80004176:	dd45                	beqz	a0,8000412e <exec+0xfe>
      n = PGSIZE;
    80004178:	8952                	mv	s2,s4
    if(sz - i < PGSIZE)
    8000417a:	fd49f2e3          	bgeu	s3,s4,8000413e <exec+0x10e>
      n = sz - i;
    8000417e:	894e                	mv	s2,s3
    80004180:	bf7d                	j	8000413e <exec+0x10e>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004182:	4481                	li	s1,0
  iunlockput(ip);
    80004184:	8556                	mv	a0,s5
    80004186:	fffff097          	auipc	ra,0xfffff
    8000418a:	c14080e7          	jalr	-1004(ra) # 80002d9a <iunlockput>
  end_op();
    8000418e:	fffff097          	auipc	ra,0xfffff
    80004192:	404080e7          	jalr	1028(ra) # 80003592 <end_op>
  p = myproc();
    80004196:	ffffd097          	auipc	ra,0xffffd
    8000419a:	cae080e7          	jalr	-850(ra) # 80000e44 <myproc>
    8000419e:	8baa                	mv	s7,a0
  uint64 oldsz = p->sz;
    800041a0:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    800041a4:	6785                	lui	a5,0x1
    800041a6:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800041a8:	97a6                	add	a5,a5,s1
    800041aa:	777d                	lui	a4,0xfffff
    800041ac:	8ff9                	and	a5,a5,a4
    800041ae:	def43c23          	sd	a5,-520(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    800041b2:	6609                	lui	a2,0x2
    800041b4:	963e                	add	a2,a2,a5
    800041b6:	85be                	mv	a1,a5
    800041b8:	855a                	mv	a0,s6
    800041ba:	ffffc097          	auipc	ra,0xffffc
    800041be:	6fa080e7          	jalr	1786(ra) # 800008b4 <uvmalloc>
    800041c2:	8c2a                	mv	s8,a0
  ip = 0;
    800041c4:	4a81                	li	s5,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    800041c6:	12050e63          	beqz	a0,80004302 <exec+0x2d2>
  uvmclear(pagetable, sz-2*PGSIZE);
    800041ca:	75f9                	lui	a1,0xffffe
    800041cc:	95aa                	add	a1,a1,a0
    800041ce:	855a                	mv	a0,s6
    800041d0:	ffffd097          	auipc	ra,0xffffd
    800041d4:	906080e7          	jalr	-1786(ra) # 80000ad6 <uvmclear>
  stackbase = sp - PGSIZE;
    800041d8:	7afd                	lui	s5,0xfffff
    800041da:	9ae2                	add	s5,s5,s8
  for(argc = 0; argv[argc]; argc++) {
    800041dc:	df043783          	ld	a5,-528(s0)
    800041e0:	6388                	ld	a0,0(a5)
    800041e2:	c925                	beqz	a0,80004252 <exec+0x222>
    800041e4:	e9040993          	addi	s3,s0,-368
    800041e8:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    800041ec:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    800041ee:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    800041f0:	ffffc097          	auipc	ra,0xffffc
    800041f4:	106080e7          	jalr	262(ra) # 800002f6 <strlen>
    800041f8:	0015079b          	addiw	a5,a0,1
    800041fc:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80004200:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    80004204:	13596363          	bltu	s2,s5,8000432a <exec+0x2fa>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80004208:	df043d83          	ld	s11,-528(s0)
    8000420c:	000dba03          	ld	s4,0(s11) # 1000 <_entry-0x7ffff000>
    80004210:	8552                	mv	a0,s4
    80004212:	ffffc097          	auipc	ra,0xffffc
    80004216:	0e4080e7          	jalr	228(ra) # 800002f6 <strlen>
    8000421a:	0015069b          	addiw	a3,a0,1
    8000421e:	8652                	mv	a2,s4
    80004220:	85ca                	mv	a1,s2
    80004222:	855a                	mv	a0,s6
    80004224:	ffffd097          	auipc	ra,0xffffd
    80004228:	8e4080e7          	jalr	-1820(ra) # 80000b08 <copyout>
    8000422c:	10054363          	bltz	a0,80004332 <exec+0x302>
    ustack[argc] = sp;
    80004230:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80004234:	0485                	addi	s1,s1,1
    80004236:	008d8793          	addi	a5,s11,8
    8000423a:	def43823          	sd	a5,-528(s0)
    8000423e:	008db503          	ld	a0,8(s11)
    80004242:	c911                	beqz	a0,80004256 <exec+0x226>
    if(argc >= MAXARG)
    80004244:	09a1                	addi	s3,s3,8
    80004246:	fb3c95e3          	bne	s9,s3,800041f0 <exec+0x1c0>
  sz = sz1;
    8000424a:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    8000424e:	4a81                	li	s5,0
    80004250:	a84d                	j	80004302 <exec+0x2d2>
  sp = sz;
    80004252:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    80004254:	4481                	li	s1,0
  ustack[argc] = 0;
    80004256:	00349793          	slli	a5,s1,0x3
    8000425a:	f9078793          	addi	a5,a5,-112
    8000425e:	97a2                	add	a5,a5,s0
    80004260:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    80004264:	00148693          	addi	a3,s1,1
    80004268:	068e                	slli	a3,a3,0x3
    8000426a:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    8000426e:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    80004272:	01597663          	bgeu	s2,s5,8000427e <exec+0x24e>
  sz = sz1;
    80004276:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    8000427a:	4a81                	li	s5,0
    8000427c:	a059                	j	80004302 <exec+0x2d2>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    8000427e:	e9040613          	addi	a2,s0,-368
    80004282:	85ca                	mv	a1,s2
    80004284:	855a                	mv	a0,s6
    80004286:	ffffd097          	auipc	ra,0xffffd
    8000428a:	882080e7          	jalr	-1918(ra) # 80000b08 <copyout>
    8000428e:	0a054663          	bltz	a0,8000433a <exec+0x30a>
  p->trapframe->a1 = sp;
    80004292:	058bb783          	ld	a5,88(s7)
    80004296:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    8000429a:	de843783          	ld	a5,-536(s0)
    8000429e:	0007c703          	lbu	a4,0(a5)
    800042a2:	cf11                	beqz	a4,800042be <exec+0x28e>
    800042a4:	0785                	addi	a5,a5,1
    if(*s == '/')
    800042a6:	02f00693          	li	a3,47
    800042aa:	a039                	j	800042b8 <exec+0x288>
      last = s+1;
    800042ac:	def43423          	sd	a5,-536(s0)
  for(last=s=path; *s; s++)
    800042b0:	0785                	addi	a5,a5,1
    800042b2:	fff7c703          	lbu	a4,-1(a5)
    800042b6:	c701                	beqz	a4,800042be <exec+0x28e>
    if(*s == '/')
    800042b8:	fed71ce3          	bne	a4,a3,800042b0 <exec+0x280>
    800042bc:	bfc5                	j	800042ac <exec+0x27c>
  safestrcpy(p->name, last, sizeof(p->name));
    800042be:	4641                	li	a2,16
    800042c0:	de843583          	ld	a1,-536(s0)
    800042c4:	158b8513          	addi	a0,s7,344
    800042c8:	ffffc097          	auipc	ra,0xffffc
    800042cc:	ffc080e7          	jalr	-4(ra) # 800002c4 <safestrcpy>
  oldpagetable = p->pagetable;
    800042d0:	050bb503          	ld	a0,80(s7)
  p->pagetable = pagetable;
    800042d4:	056bb823          	sd	s6,80(s7)
  p->sz = sz;
    800042d8:	058bb423          	sd	s8,72(s7)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    800042dc:	058bb783          	ld	a5,88(s7)
    800042e0:	e6843703          	ld	a4,-408(s0)
    800042e4:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    800042e6:	058bb783          	ld	a5,88(s7)
    800042ea:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    800042ee:	85ea                	mv	a1,s10
    800042f0:	ffffd097          	auipc	ra,0xffffd
    800042f4:	cb4080e7          	jalr	-844(ra) # 80000fa4 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    800042f8:	0004851b          	sext.w	a0,s1
    800042fc:	bbc1                	j	800040cc <exec+0x9c>
    800042fe:	de943c23          	sd	s1,-520(s0)
    proc_freepagetable(pagetable, sz);
    80004302:	df843583          	ld	a1,-520(s0)
    80004306:	855a                	mv	a0,s6
    80004308:	ffffd097          	auipc	ra,0xffffd
    8000430c:	c9c080e7          	jalr	-868(ra) # 80000fa4 <proc_freepagetable>
  if(ip){
    80004310:	da0a94e3          	bnez	s5,800040b8 <exec+0x88>
  return -1;
    80004314:	557d                	li	a0,-1
    80004316:	bb5d                	j	800040cc <exec+0x9c>
    80004318:	de943c23          	sd	s1,-520(s0)
    8000431c:	b7dd                	j	80004302 <exec+0x2d2>
    8000431e:	de943c23          	sd	s1,-520(s0)
    80004322:	b7c5                	j	80004302 <exec+0x2d2>
    80004324:	de943c23          	sd	s1,-520(s0)
    80004328:	bfe9                	j	80004302 <exec+0x2d2>
  sz = sz1;
    8000432a:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    8000432e:	4a81                	li	s5,0
    80004330:	bfc9                	j	80004302 <exec+0x2d2>
  sz = sz1;
    80004332:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80004336:	4a81                	li	s5,0
    80004338:	b7e9                	j	80004302 <exec+0x2d2>
  sz = sz1;
    8000433a:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    8000433e:	4a81                	li	s5,0
    80004340:	b7c9                	j	80004302 <exec+0x2d2>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    80004342:	df843483          	ld	s1,-520(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004346:	e0843783          	ld	a5,-504(s0)
    8000434a:	0017869b          	addiw	a3,a5,1
    8000434e:	e0d43423          	sd	a3,-504(s0)
    80004352:	e0043783          	ld	a5,-512(s0)
    80004356:	0387879b          	addiw	a5,a5,56
    8000435a:	e8845703          	lhu	a4,-376(s0)
    8000435e:	e2e6d3e3          	bge	a3,a4,80004184 <exec+0x154>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80004362:	2781                	sext.w	a5,a5
    80004364:	e0f43023          	sd	a5,-512(s0)
    80004368:	03800713          	li	a4,56
    8000436c:	86be                	mv	a3,a5
    8000436e:	e1840613          	addi	a2,s0,-488
    80004372:	4581                	li	a1,0
    80004374:	8556                	mv	a0,s5
    80004376:	fffff097          	auipc	ra,0xfffff
    8000437a:	a76080e7          	jalr	-1418(ra) # 80002dec <readi>
    8000437e:	03800793          	li	a5,56
    80004382:	f6f51ee3          	bne	a0,a5,800042fe <exec+0x2ce>
    if(ph.type != ELF_PROG_LOAD)
    80004386:	e1842783          	lw	a5,-488(s0)
    8000438a:	4705                	li	a4,1
    8000438c:	fae79de3          	bne	a5,a4,80004346 <exec+0x316>
    if(ph.memsz < ph.filesz)
    80004390:	e4043603          	ld	a2,-448(s0)
    80004394:	e3843783          	ld	a5,-456(s0)
    80004398:	f8f660e3          	bltu	a2,a5,80004318 <exec+0x2e8>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    8000439c:	e2843783          	ld	a5,-472(s0)
    800043a0:	963e                	add	a2,a2,a5
    800043a2:	f6f66ee3          	bltu	a2,a5,8000431e <exec+0x2ee>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    800043a6:	85a6                	mv	a1,s1
    800043a8:	855a                	mv	a0,s6
    800043aa:	ffffc097          	auipc	ra,0xffffc
    800043ae:	50a080e7          	jalr	1290(ra) # 800008b4 <uvmalloc>
    800043b2:	dea43c23          	sd	a0,-520(s0)
    800043b6:	d53d                	beqz	a0,80004324 <exec+0x2f4>
    if((ph.vaddr % PGSIZE) != 0)
    800043b8:	e2843c03          	ld	s8,-472(s0)
    800043bc:	de043783          	ld	a5,-544(s0)
    800043c0:	00fc77b3          	and	a5,s8,a5
    800043c4:	ff9d                	bnez	a5,80004302 <exec+0x2d2>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    800043c6:	e2042c83          	lw	s9,-480(s0)
    800043ca:	e3842b83          	lw	s7,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    800043ce:	f60b8ae3          	beqz	s7,80004342 <exec+0x312>
    800043d2:	89de                	mv	s3,s7
    800043d4:	4481                	li	s1,0
    800043d6:	b371                	j	80004162 <exec+0x132>

00000000800043d8 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    800043d8:	7179                	addi	sp,sp,-48
    800043da:	f406                	sd	ra,40(sp)
    800043dc:	f022                	sd	s0,32(sp)
    800043de:	ec26                	sd	s1,24(sp)
    800043e0:	e84a                	sd	s2,16(sp)
    800043e2:	1800                	addi	s0,sp,48
    800043e4:	892e                	mv	s2,a1
    800043e6:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    800043e8:	fdc40593          	addi	a1,s0,-36
    800043ec:	ffffe097          	auipc	ra,0xffffe
    800043f0:	b20080e7          	jalr	-1248(ra) # 80001f0c <argint>
    800043f4:	04054063          	bltz	a0,80004434 <argfd+0x5c>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    800043f8:	fdc42703          	lw	a4,-36(s0)
    800043fc:	47bd                	li	a5,15
    800043fe:	02e7ed63          	bltu	a5,a4,80004438 <argfd+0x60>
    80004402:	ffffd097          	auipc	ra,0xffffd
    80004406:	a42080e7          	jalr	-1470(ra) # 80000e44 <myproc>
    8000440a:	fdc42703          	lw	a4,-36(s0)
    8000440e:	01a70793          	addi	a5,a4,26 # fffffffffffff01a <end+0xffffffff7ffd8dda>
    80004412:	078e                	slli	a5,a5,0x3
    80004414:	953e                	add	a0,a0,a5
    80004416:	611c                	ld	a5,0(a0)
    80004418:	c395                	beqz	a5,8000443c <argfd+0x64>
    return -1;
  if(pfd)
    8000441a:	00090463          	beqz	s2,80004422 <argfd+0x4a>
    *pfd = fd;
    8000441e:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80004422:	4501                	li	a0,0
  if(pf)
    80004424:	c091                	beqz	s1,80004428 <argfd+0x50>
    *pf = f;
    80004426:	e09c                	sd	a5,0(s1)
}
    80004428:	70a2                	ld	ra,40(sp)
    8000442a:	7402                	ld	s0,32(sp)
    8000442c:	64e2                	ld	s1,24(sp)
    8000442e:	6942                	ld	s2,16(sp)
    80004430:	6145                	addi	sp,sp,48
    80004432:	8082                	ret
    return -1;
    80004434:	557d                	li	a0,-1
    80004436:	bfcd                	j	80004428 <argfd+0x50>
    return -1;
    80004438:	557d                	li	a0,-1
    8000443a:	b7fd                	j	80004428 <argfd+0x50>
    8000443c:	557d                	li	a0,-1
    8000443e:	b7ed                	j	80004428 <argfd+0x50>

0000000080004440 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80004440:	1101                	addi	sp,sp,-32
    80004442:	ec06                	sd	ra,24(sp)
    80004444:	e822                	sd	s0,16(sp)
    80004446:	e426                	sd	s1,8(sp)
    80004448:	1000                	addi	s0,sp,32
    8000444a:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    8000444c:	ffffd097          	auipc	ra,0xffffd
    80004450:	9f8080e7          	jalr	-1544(ra) # 80000e44 <myproc>
    80004454:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80004456:	0d050793          	addi	a5,a0,208
    8000445a:	4501                	li	a0,0
    8000445c:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    8000445e:	6398                	ld	a4,0(a5)
    80004460:	cb19                	beqz	a4,80004476 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    80004462:	2505                	addiw	a0,a0,1
    80004464:	07a1                	addi	a5,a5,8
    80004466:	fed51ce3          	bne	a0,a3,8000445e <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    8000446a:	557d                	li	a0,-1
}
    8000446c:	60e2                	ld	ra,24(sp)
    8000446e:	6442                	ld	s0,16(sp)
    80004470:	64a2                	ld	s1,8(sp)
    80004472:	6105                	addi	sp,sp,32
    80004474:	8082                	ret
      p->ofile[fd] = f;
    80004476:	01a50793          	addi	a5,a0,26
    8000447a:	078e                	slli	a5,a5,0x3
    8000447c:	963e                	add	a2,a2,a5
    8000447e:	e204                	sd	s1,0(a2)
      return fd;
    80004480:	b7f5                	j	8000446c <fdalloc+0x2c>

0000000080004482 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80004482:	715d                	addi	sp,sp,-80
    80004484:	e486                	sd	ra,72(sp)
    80004486:	e0a2                	sd	s0,64(sp)
    80004488:	fc26                	sd	s1,56(sp)
    8000448a:	f84a                	sd	s2,48(sp)
    8000448c:	f44e                	sd	s3,40(sp)
    8000448e:	f052                	sd	s4,32(sp)
    80004490:	ec56                	sd	s5,24(sp)
    80004492:	0880                	addi	s0,sp,80
    80004494:	89ae                	mv	s3,a1
    80004496:	8ab2                	mv	s5,a2
    80004498:	8a36                	mv	s4,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    8000449a:	fb040593          	addi	a1,s0,-80
    8000449e:	fffff097          	auipc	ra,0xfffff
    800044a2:	e74080e7          	jalr	-396(ra) # 80003312 <nameiparent>
    800044a6:	892a                	mv	s2,a0
    800044a8:	12050e63          	beqz	a0,800045e4 <create+0x162>
    return 0;

  ilock(dp);
    800044ac:	ffffe097          	auipc	ra,0xffffe
    800044b0:	68c080e7          	jalr	1676(ra) # 80002b38 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    800044b4:	4601                	li	a2,0
    800044b6:	fb040593          	addi	a1,s0,-80
    800044ba:	854a                	mv	a0,s2
    800044bc:	fffff097          	auipc	ra,0xfffff
    800044c0:	b60080e7          	jalr	-1184(ra) # 8000301c <dirlookup>
    800044c4:	84aa                	mv	s1,a0
    800044c6:	c921                	beqz	a0,80004516 <create+0x94>
    iunlockput(dp);
    800044c8:	854a                	mv	a0,s2
    800044ca:	fffff097          	auipc	ra,0xfffff
    800044ce:	8d0080e7          	jalr	-1840(ra) # 80002d9a <iunlockput>
    ilock(ip);
    800044d2:	8526                	mv	a0,s1
    800044d4:	ffffe097          	auipc	ra,0xffffe
    800044d8:	664080e7          	jalr	1636(ra) # 80002b38 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    800044dc:	2981                	sext.w	s3,s3
    800044de:	4789                	li	a5,2
    800044e0:	02f99463          	bne	s3,a5,80004508 <create+0x86>
    800044e4:	0444d783          	lhu	a5,68(s1)
    800044e8:	37f9                	addiw	a5,a5,-2
    800044ea:	17c2                	slli	a5,a5,0x30
    800044ec:	93c1                	srli	a5,a5,0x30
    800044ee:	4705                	li	a4,1
    800044f0:	00f76c63          	bltu	a4,a5,80004508 <create+0x86>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    800044f4:	8526                	mv	a0,s1
    800044f6:	60a6                	ld	ra,72(sp)
    800044f8:	6406                	ld	s0,64(sp)
    800044fa:	74e2                	ld	s1,56(sp)
    800044fc:	7942                	ld	s2,48(sp)
    800044fe:	79a2                	ld	s3,40(sp)
    80004500:	7a02                	ld	s4,32(sp)
    80004502:	6ae2                	ld	s5,24(sp)
    80004504:	6161                	addi	sp,sp,80
    80004506:	8082                	ret
    iunlockput(ip);
    80004508:	8526                	mv	a0,s1
    8000450a:	fffff097          	auipc	ra,0xfffff
    8000450e:	890080e7          	jalr	-1904(ra) # 80002d9a <iunlockput>
    return 0;
    80004512:	4481                	li	s1,0
    80004514:	b7c5                	j	800044f4 <create+0x72>
  if((ip = ialloc(dp->dev, type)) == 0)
    80004516:	85ce                	mv	a1,s3
    80004518:	00092503          	lw	a0,0(s2)
    8000451c:	ffffe097          	auipc	ra,0xffffe
    80004520:	482080e7          	jalr	1154(ra) # 8000299e <ialloc>
    80004524:	84aa                	mv	s1,a0
    80004526:	c521                	beqz	a0,8000456e <create+0xec>
  ilock(ip);
    80004528:	ffffe097          	auipc	ra,0xffffe
    8000452c:	610080e7          	jalr	1552(ra) # 80002b38 <ilock>
  ip->major = major;
    80004530:	05549323          	sh	s5,70(s1)
  ip->minor = minor;
    80004534:	05449423          	sh	s4,72(s1)
  ip->nlink = 1;
    80004538:	4a05                	li	s4,1
    8000453a:	05449523          	sh	s4,74(s1)
  iupdate(ip);
    8000453e:	8526                	mv	a0,s1
    80004540:	ffffe097          	auipc	ra,0xffffe
    80004544:	52c080e7          	jalr	1324(ra) # 80002a6c <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80004548:	2981                	sext.w	s3,s3
    8000454a:	03498a63          	beq	s3,s4,8000457e <create+0xfc>
  if(dirlink(dp, name, ip->inum) < 0)
    8000454e:	40d0                	lw	a2,4(s1)
    80004550:	fb040593          	addi	a1,s0,-80
    80004554:	854a                	mv	a0,s2
    80004556:	fffff097          	auipc	ra,0xfffff
    8000455a:	cdc080e7          	jalr	-804(ra) # 80003232 <dirlink>
    8000455e:	06054b63          	bltz	a0,800045d4 <create+0x152>
  iunlockput(dp);
    80004562:	854a                	mv	a0,s2
    80004564:	fffff097          	auipc	ra,0xfffff
    80004568:	836080e7          	jalr	-1994(ra) # 80002d9a <iunlockput>
  return ip;
    8000456c:	b761                	j	800044f4 <create+0x72>
    panic("create: ialloc");
    8000456e:	00004517          	auipc	a0,0x4
    80004572:	27250513          	addi	a0,a0,626 # 800087e0 <syscall_names+0x2a0>
    80004576:	00001097          	auipc	ra,0x1
    8000457a:	63a080e7          	jalr	1594(ra) # 80005bb0 <panic>
    dp->nlink++;  // for ".."
    8000457e:	04a95783          	lhu	a5,74(s2)
    80004582:	2785                	addiw	a5,a5,1
    80004584:	04f91523          	sh	a5,74(s2)
    iupdate(dp);
    80004588:	854a                	mv	a0,s2
    8000458a:	ffffe097          	auipc	ra,0xffffe
    8000458e:	4e2080e7          	jalr	1250(ra) # 80002a6c <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80004592:	40d0                	lw	a2,4(s1)
    80004594:	00004597          	auipc	a1,0x4
    80004598:	25c58593          	addi	a1,a1,604 # 800087f0 <syscall_names+0x2b0>
    8000459c:	8526                	mv	a0,s1
    8000459e:	fffff097          	auipc	ra,0xfffff
    800045a2:	c94080e7          	jalr	-876(ra) # 80003232 <dirlink>
    800045a6:	00054f63          	bltz	a0,800045c4 <create+0x142>
    800045aa:	00492603          	lw	a2,4(s2)
    800045ae:	00004597          	auipc	a1,0x4
    800045b2:	24a58593          	addi	a1,a1,586 # 800087f8 <syscall_names+0x2b8>
    800045b6:	8526                	mv	a0,s1
    800045b8:	fffff097          	auipc	ra,0xfffff
    800045bc:	c7a080e7          	jalr	-902(ra) # 80003232 <dirlink>
    800045c0:	f80557e3          	bgez	a0,8000454e <create+0xcc>
      panic("create dots");
    800045c4:	00004517          	auipc	a0,0x4
    800045c8:	23c50513          	addi	a0,a0,572 # 80008800 <syscall_names+0x2c0>
    800045cc:	00001097          	auipc	ra,0x1
    800045d0:	5e4080e7          	jalr	1508(ra) # 80005bb0 <panic>
    panic("create: dirlink");
    800045d4:	00004517          	auipc	a0,0x4
    800045d8:	23c50513          	addi	a0,a0,572 # 80008810 <syscall_names+0x2d0>
    800045dc:	00001097          	auipc	ra,0x1
    800045e0:	5d4080e7          	jalr	1492(ra) # 80005bb0 <panic>
    return 0;
    800045e4:	84aa                	mv	s1,a0
    800045e6:	b739                	j	800044f4 <create+0x72>

00000000800045e8 <sys_dup>:
{
    800045e8:	7179                	addi	sp,sp,-48
    800045ea:	f406                	sd	ra,40(sp)
    800045ec:	f022                	sd	s0,32(sp)
    800045ee:	ec26                	sd	s1,24(sp)
    800045f0:	e84a                	sd	s2,16(sp)
    800045f2:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    800045f4:	fd840613          	addi	a2,s0,-40
    800045f8:	4581                	li	a1,0
    800045fa:	4501                	li	a0,0
    800045fc:	00000097          	auipc	ra,0x0
    80004600:	ddc080e7          	jalr	-548(ra) # 800043d8 <argfd>
    return -1;
    80004604:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80004606:	02054363          	bltz	a0,8000462c <sys_dup+0x44>
  if((fd=fdalloc(f)) < 0)
    8000460a:	fd843903          	ld	s2,-40(s0)
    8000460e:	854a                	mv	a0,s2
    80004610:	00000097          	auipc	ra,0x0
    80004614:	e30080e7          	jalr	-464(ra) # 80004440 <fdalloc>
    80004618:	84aa                	mv	s1,a0
    return -1;
    8000461a:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    8000461c:	00054863          	bltz	a0,8000462c <sys_dup+0x44>
  filedup(f);
    80004620:	854a                	mv	a0,s2
    80004622:	fffff097          	auipc	ra,0xfffff
    80004626:	368080e7          	jalr	872(ra) # 8000398a <filedup>
  return fd;
    8000462a:	87a6                	mv	a5,s1
}
    8000462c:	853e                	mv	a0,a5
    8000462e:	70a2                	ld	ra,40(sp)
    80004630:	7402                	ld	s0,32(sp)
    80004632:	64e2                	ld	s1,24(sp)
    80004634:	6942                	ld	s2,16(sp)
    80004636:	6145                	addi	sp,sp,48
    80004638:	8082                	ret

000000008000463a <sys_read>:
{
    8000463a:	7179                	addi	sp,sp,-48
    8000463c:	f406                	sd	ra,40(sp)
    8000463e:	f022                	sd	s0,32(sp)
    80004640:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004642:	fe840613          	addi	a2,s0,-24
    80004646:	4581                	li	a1,0
    80004648:	4501                	li	a0,0
    8000464a:	00000097          	auipc	ra,0x0
    8000464e:	d8e080e7          	jalr	-626(ra) # 800043d8 <argfd>
    return -1;
    80004652:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004654:	04054163          	bltz	a0,80004696 <sys_read+0x5c>
    80004658:	fe440593          	addi	a1,s0,-28
    8000465c:	4509                	li	a0,2
    8000465e:	ffffe097          	auipc	ra,0xffffe
    80004662:	8ae080e7          	jalr	-1874(ra) # 80001f0c <argint>
    return -1;
    80004666:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004668:	02054763          	bltz	a0,80004696 <sys_read+0x5c>
    8000466c:	fd840593          	addi	a1,s0,-40
    80004670:	4505                	li	a0,1
    80004672:	ffffe097          	auipc	ra,0xffffe
    80004676:	8bc080e7          	jalr	-1860(ra) # 80001f2e <argaddr>
    return -1;
    8000467a:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000467c:	00054d63          	bltz	a0,80004696 <sys_read+0x5c>
  return fileread(f, p, n);
    80004680:	fe442603          	lw	a2,-28(s0)
    80004684:	fd843583          	ld	a1,-40(s0)
    80004688:	fe843503          	ld	a0,-24(s0)
    8000468c:	fffff097          	auipc	ra,0xfffff
    80004690:	48a080e7          	jalr	1162(ra) # 80003b16 <fileread>
    80004694:	87aa                	mv	a5,a0
}
    80004696:	853e                	mv	a0,a5
    80004698:	70a2                	ld	ra,40(sp)
    8000469a:	7402                	ld	s0,32(sp)
    8000469c:	6145                	addi	sp,sp,48
    8000469e:	8082                	ret

00000000800046a0 <sys_write>:
{
    800046a0:	7179                	addi	sp,sp,-48
    800046a2:	f406                	sd	ra,40(sp)
    800046a4:	f022                	sd	s0,32(sp)
    800046a6:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800046a8:	fe840613          	addi	a2,s0,-24
    800046ac:	4581                	li	a1,0
    800046ae:	4501                	li	a0,0
    800046b0:	00000097          	auipc	ra,0x0
    800046b4:	d28080e7          	jalr	-728(ra) # 800043d8 <argfd>
    return -1;
    800046b8:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800046ba:	04054163          	bltz	a0,800046fc <sys_write+0x5c>
    800046be:	fe440593          	addi	a1,s0,-28
    800046c2:	4509                	li	a0,2
    800046c4:	ffffe097          	auipc	ra,0xffffe
    800046c8:	848080e7          	jalr	-1976(ra) # 80001f0c <argint>
    return -1;
    800046cc:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800046ce:	02054763          	bltz	a0,800046fc <sys_write+0x5c>
    800046d2:	fd840593          	addi	a1,s0,-40
    800046d6:	4505                	li	a0,1
    800046d8:	ffffe097          	auipc	ra,0xffffe
    800046dc:	856080e7          	jalr	-1962(ra) # 80001f2e <argaddr>
    return -1;
    800046e0:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800046e2:	00054d63          	bltz	a0,800046fc <sys_write+0x5c>
  return filewrite(f, p, n);
    800046e6:	fe442603          	lw	a2,-28(s0)
    800046ea:	fd843583          	ld	a1,-40(s0)
    800046ee:	fe843503          	ld	a0,-24(s0)
    800046f2:	fffff097          	auipc	ra,0xfffff
    800046f6:	4e6080e7          	jalr	1254(ra) # 80003bd8 <filewrite>
    800046fa:	87aa                	mv	a5,a0
}
    800046fc:	853e                	mv	a0,a5
    800046fe:	70a2                	ld	ra,40(sp)
    80004700:	7402                	ld	s0,32(sp)
    80004702:	6145                	addi	sp,sp,48
    80004704:	8082                	ret

0000000080004706 <sys_close>:
{
    80004706:	1101                	addi	sp,sp,-32
    80004708:	ec06                	sd	ra,24(sp)
    8000470a:	e822                	sd	s0,16(sp)
    8000470c:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    8000470e:	fe040613          	addi	a2,s0,-32
    80004712:	fec40593          	addi	a1,s0,-20
    80004716:	4501                	li	a0,0
    80004718:	00000097          	auipc	ra,0x0
    8000471c:	cc0080e7          	jalr	-832(ra) # 800043d8 <argfd>
    return -1;
    80004720:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80004722:	02054463          	bltz	a0,8000474a <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    80004726:	ffffc097          	auipc	ra,0xffffc
    8000472a:	71e080e7          	jalr	1822(ra) # 80000e44 <myproc>
    8000472e:	fec42783          	lw	a5,-20(s0)
    80004732:	07e9                	addi	a5,a5,26
    80004734:	078e                	slli	a5,a5,0x3
    80004736:	953e                	add	a0,a0,a5
    80004738:	00053023          	sd	zero,0(a0)
  fileclose(f);
    8000473c:	fe043503          	ld	a0,-32(s0)
    80004740:	fffff097          	auipc	ra,0xfffff
    80004744:	29c080e7          	jalr	668(ra) # 800039dc <fileclose>
  return 0;
    80004748:	4781                	li	a5,0
}
    8000474a:	853e                	mv	a0,a5
    8000474c:	60e2                	ld	ra,24(sp)
    8000474e:	6442                	ld	s0,16(sp)
    80004750:	6105                	addi	sp,sp,32
    80004752:	8082                	ret

0000000080004754 <sys_fstat>:
{
    80004754:	1101                	addi	sp,sp,-32
    80004756:	ec06                	sd	ra,24(sp)
    80004758:	e822                	sd	s0,16(sp)
    8000475a:	1000                	addi	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    8000475c:	fe840613          	addi	a2,s0,-24
    80004760:	4581                	li	a1,0
    80004762:	4501                	li	a0,0
    80004764:	00000097          	auipc	ra,0x0
    80004768:	c74080e7          	jalr	-908(ra) # 800043d8 <argfd>
    return -1;
    8000476c:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    8000476e:	02054563          	bltz	a0,80004798 <sys_fstat+0x44>
    80004772:	fe040593          	addi	a1,s0,-32
    80004776:	4505                	li	a0,1
    80004778:	ffffd097          	auipc	ra,0xffffd
    8000477c:	7b6080e7          	jalr	1974(ra) # 80001f2e <argaddr>
    return -1;
    80004780:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80004782:	00054b63          	bltz	a0,80004798 <sys_fstat+0x44>
  return filestat(f, st);
    80004786:	fe043583          	ld	a1,-32(s0)
    8000478a:	fe843503          	ld	a0,-24(s0)
    8000478e:	fffff097          	auipc	ra,0xfffff
    80004792:	316080e7          	jalr	790(ra) # 80003aa4 <filestat>
    80004796:	87aa                	mv	a5,a0
}
    80004798:	853e                	mv	a0,a5
    8000479a:	60e2                	ld	ra,24(sp)
    8000479c:	6442                	ld	s0,16(sp)
    8000479e:	6105                	addi	sp,sp,32
    800047a0:	8082                	ret

00000000800047a2 <sys_link>:
{
    800047a2:	7169                	addi	sp,sp,-304
    800047a4:	f606                	sd	ra,296(sp)
    800047a6:	f222                	sd	s0,288(sp)
    800047a8:	ee26                	sd	s1,280(sp)
    800047aa:	ea4a                	sd	s2,272(sp)
    800047ac:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800047ae:	08000613          	li	a2,128
    800047b2:	ed040593          	addi	a1,s0,-304
    800047b6:	4501                	li	a0,0
    800047b8:	ffffd097          	auipc	ra,0xffffd
    800047bc:	798080e7          	jalr	1944(ra) # 80001f50 <argstr>
    return -1;
    800047c0:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800047c2:	10054e63          	bltz	a0,800048de <sys_link+0x13c>
    800047c6:	08000613          	li	a2,128
    800047ca:	f5040593          	addi	a1,s0,-176
    800047ce:	4505                	li	a0,1
    800047d0:	ffffd097          	auipc	ra,0xffffd
    800047d4:	780080e7          	jalr	1920(ra) # 80001f50 <argstr>
    return -1;
    800047d8:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800047da:	10054263          	bltz	a0,800048de <sys_link+0x13c>
  begin_op();
    800047de:	fffff097          	auipc	ra,0xfffff
    800047e2:	d36080e7          	jalr	-714(ra) # 80003514 <begin_op>
  if((ip = namei(old)) == 0){
    800047e6:	ed040513          	addi	a0,s0,-304
    800047ea:	fffff097          	auipc	ra,0xfffff
    800047ee:	b0a080e7          	jalr	-1270(ra) # 800032f4 <namei>
    800047f2:	84aa                	mv	s1,a0
    800047f4:	c551                	beqz	a0,80004880 <sys_link+0xde>
  ilock(ip);
    800047f6:	ffffe097          	auipc	ra,0xffffe
    800047fa:	342080e7          	jalr	834(ra) # 80002b38 <ilock>
  if(ip->type == T_DIR){
    800047fe:	04449703          	lh	a4,68(s1)
    80004802:	4785                	li	a5,1
    80004804:	08f70463          	beq	a4,a5,8000488c <sys_link+0xea>
  ip->nlink++;
    80004808:	04a4d783          	lhu	a5,74(s1)
    8000480c:	2785                	addiw	a5,a5,1
    8000480e:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004812:	8526                	mv	a0,s1
    80004814:	ffffe097          	auipc	ra,0xffffe
    80004818:	258080e7          	jalr	600(ra) # 80002a6c <iupdate>
  iunlock(ip);
    8000481c:	8526                	mv	a0,s1
    8000481e:	ffffe097          	auipc	ra,0xffffe
    80004822:	3dc080e7          	jalr	988(ra) # 80002bfa <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80004826:	fd040593          	addi	a1,s0,-48
    8000482a:	f5040513          	addi	a0,s0,-176
    8000482e:	fffff097          	auipc	ra,0xfffff
    80004832:	ae4080e7          	jalr	-1308(ra) # 80003312 <nameiparent>
    80004836:	892a                	mv	s2,a0
    80004838:	c935                	beqz	a0,800048ac <sys_link+0x10a>
  ilock(dp);
    8000483a:	ffffe097          	auipc	ra,0xffffe
    8000483e:	2fe080e7          	jalr	766(ra) # 80002b38 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004842:	00092703          	lw	a4,0(s2)
    80004846:	409c                	lw	a5,0(s1)
    80004848:	04f71d63          	bne	a4,a5,800048a2 <sys_link+0x100>
    8000484c:	40d0                	lw	a2,4(s1)
    8000484e:	fd040593          	addi	a1,s0,-48
    80004852:	854a                	mv	a0,s2
    80004854:	fffff097          	auipc	ra,0xfffff
    80004858:	9de080e7          	jalr	-1570(ra) # 80003232 <dirlink>
    8000485c:	04054363          	bltz	a0,800048a2 <sys_link+0x100>
  iunlockput(dp);
    80004860:	854a                	mv	a0,s2
    80004862:	ffffe097          	auipc	ra,0xffffe
    80004866:	538080e7          	jalr	1336(ra) # 80002d9a <iunlockput>
  iput(ip);
    8000486a:	8526                	mv	a0,s1
    8000486c:	ffffe097          	auipc	ra,0xffffe
    80004870:	486080e7          	jalr	1158(ra) # 80002cf2 <iput>
  end_op();
    80004874:	fffff097          	auipc	ra,0xfffff
    80004878:	d1e080e7          	jalr	-738(ra) # 80003592 <end_op>
  return 0;
    8000487c:	4781                	li	a5,0
    8000487e:	a085                	j	800048de <sys_link+0x13c>
    end_op();
    80004880:	fffff097          	auipc	ra,0xfffff
    80004884:	d12080e7          	jalr	-750(ra) # 80003592 <end_op>
    return -1;
    80004888:	57fd                	li	a5,-1
    8000488a:	a891                	j	800048de <sys_link+0x13c>
    iunlockput(ip);
    8000488c:	8526                	mv	a0,s1
    8000488e:	ffffe097          	auipc	ra,0xffffe
    80004892:	50c080e7          	jalr	1292(ra) # 80002d9a <iunlockput>
    end_op();
    80004896:	fffff097          	auipc	ra,0xfffff
    8000489a:	cfc080e7          	jalr	-772(ra) # 80003592 <end_op>
    return -1;
    8000489e:	57fd                	li	a5,-1
    800048a0:	a83d                	j	800048de <sys_link+0x13c>
    iunlockput(dp);
    800048a2:	854a                	mv	a0,s2
    800048a4:	ffffe097          	auipc	ra,0xffffe
    800048a8:	4f6080e7          	jalr	1270(ra) # 80002d9a <iunlockput>
  ilock(ip);
    800048ac:	8526                	mv	a0,s1
    800048ae:	ffffe097          	auipc	ra,0xffffe
    800048b2:	28a080e7          	jalr	650(ra) # 80002b38 <ilock>
  ip->nlink--;
    800048b6:	04a4d783          	lhu	a5,74(s1)
    800048ba:	37fd                	addiw	a5,a5,-1
    800048bc:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800048c0:	8526                	mv	a0,s1
    800048c2:	ffffe097          	auipc	ra,0xffffe
    800048c6:	1aa080e7          	jalr	426(ra) # 80002a6c <iupdate>
  iunlockput(ip);
    800048ca:	8526                	mv	a0,s1
    800048cc:	ffffe097          	auipc	ra,0xffffe
    800048d0:	4ce080e7          	jalr	1230(ra) # 80002d9a <iunlockput>
  end_op();
    800048d4:	fffff097          	auipc	ra,0xfffff
    800048d8:	cbe080e7          	jalr	-834(ra) # 80003592 <end_op>
  return -1;
    800048dc:	57fd                	li	a5,-1
}
    800048de:	853e                	mv	a0,a5
    800048e0:	70b2                	ld	ra,296(sp)
    800048e2:	7412                	ld	s0,288(sp)
    800048e4:	64f2                	ld	s1,280(sp)
    800048e6:	6952                	ld	s2,272(sp)
    800048e8:	6155                	addi	sp,sp,304
    800048ea:	8082                	ret

00000000800048ec <sys_unlink>:
{
    800048ec:	7151                	addi	sp,sp,-240
    800048ee:	f586                	sd	ra,232(sp)
    800048f0:	f1a2                	sd	s0,224(sp)
    800048f2:	eda6                	sd	s1,216(sp)
    800048f4:	e9ca                	sd	s2,208(sp)
    800048f6:	e5ce                	sd	s3,200(sp)
    800048f8:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    800048fa:	08000613          	li	a2,128
    800048fe:	f3040593          	addi	a1,s0,-208
    80004902:	4501                	li	a0,0
    80004904:	ffffd097          	auipc	ra,0xffffd
    80004908:	64c080e7          	jalr	1612(ra) # 80001f50 <argstr>
    8000490c:	18054163          	bltz	a0,80004a8e <sys_unlink+0x1a2>
  begin_op();
    80004910:	fffff097          	auipc	ra,0xfffff
    80004914:	c04080e7          	jalr	-1020(ra) # 80003514 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004918:	fb040593          	addi	a1,s0,-80
    8000491c:	f3040513          	addi	a0,s0,-208
    80004920:	fffff097          	auipc	ra,0xfffff
    80004924:	9f2080e7          	jalr	-1550(ra) # 80003312 <nameiparent>
    80004928:	84aa                	mv	s1,a0
    8000492a:	c979                	beqz	a0,80004a00 <sys_unlink+0x114>
  ilock(dp);
    8000492c:	ffffe097          	auipc	ra,0xffffe
    80004930:	20c080e7          	jalr	524(ra) # 80002b38 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004934:	00004597          	auipc	a1,0x4
    80004938:	ebc58593          	addi	a1,a1,-324 # 800087f0 <syscall_names+0x2b0>
    8000493c:	fb040513          	addi	a0,s0,-80
    80004940:	ffffe097          	auipc	ra,0xffffe
    80004944:	6c2080e7          	jalr	1730(ra) # 80003002 <namecmp>
    80004948:	14050a63          	beqz	a0,80004a9c <sys_unlink+0x1b0>
    8000494c:	00004597          	auipc	a1,0x4
    80004950:	eac58593          	addi	a1,a1,-340 # 800087f8 <syscall_names+0x2b8>
    80004954:	fb040513          	addi	a0,s0,-80
    80004958:	ffffe097          	auipc	ra,0xffffe
    8000495c:	6aa080e7          	jalr	1706(ra) # 80003002 <namecmp>
    80004960:	12050e63          	beqz	a0,80004a9c <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004964:	f2c40613          	addi	a2,s0,-212
    80004968:	fb040593          	addi	a1,s0,-80
    8000496c:	8526                	mv	a0,s1
    8000496e:	ffffe097          	auipc	ra,0xffffe
    80004972:	6ae080e7          	jalr	1710(ra) # 8000301c <dirlookup>
    80004976:	892a                	mv	s2,a0
    80004978:	12050263          	beqz	a0,80004a9c <sys_unlink+0x1b0>
  ilock(ip);
    8000497c:	ffffe097          	auipc	ra,0xffffe
    80004980:	1bc080e7          	jalr	444(ra) # 80002b38 <ilock>
  if(ip->nlink < 1)
    80004984:	04a91783          	lh	a5,74(s2)
    80004988:	08f05263          	blez	a5,80004a0c <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    8000498c:	04491703          	lh	a4,68(s2)
    80004990:	4785                	li	a5,1
    80004992:	08f70563          	beq	a4,a5,80004a1c <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80004996:	4641                	li	a2,16
    80004998:	4581                	li	a1,0
    8000499a:	fc040513          	addi	a0,s0,-64
    8000499e:	ffffb097          	auipc	ra,0xffffb
    800049a2:	7dc080e7          	jalr	2012(ra) # 8000017a <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800049a6:	4741                	li	a4,16
    800049a8:	f2c42683          	lw	a3,-212(s0)
    800049ac:	fc040613          	addi	a2,s0,-64
    800049b0:	4581                	li	a1,0
    800049b2:	8526                	mv	a0,s1
    800049b4:	ffffe097          	auipc	ra,0xffffe
    800049b8:	530080e7          	jalr	1328(ra) # 80002ee4 <writei>
    800049bc:	47c1                	li	a5,16
    800049be:	0af51563          	bne	a0,a5,80004a68 <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    800049c2:	04491703          	lh	a4,68(s2)
    800049c6:	4785                	li	a5,1
    800049c8:	0af70863          	beq	a4,a5,80004a78 <sys_unlink+0x18c>
  iunlockput(dp);
    800049cc:	8526                	mv	a0,s1
    800049ce:	ffffe097          	auipc	ra,0xffffe
    800049d2:	3cc080e7          	jalr	972(ra) # 80002d9a <iunlockput>
  ip->nlink--;
    800049d6:	04a95783          	lhu	a5,74(s2)
    800049da:	37fd                	addiw	a5,a5,-1
    800049dc:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    800049e0:	854a                	mv	a0,s2
    800049e2:	ffffe097          	auipc	ra,0xffffe
    800049e6:	08a080e7          	jalr	138(ra) # 80002a6c <iupdate>
  iunlockput(ip);
    800049ea:	854a                	mv	a0,s2
    800049ec:	ffffe097          	auipc	ra,0xffffe
    800049f0:	3ae080e7          	jalr	942(ra) # 80002d9a <iunlockput>
  end_op();
    800049f4:	fffff097          	auipc	ra,0xfffff
    800049f8:	b9e080e7          	jalr	-1122(ra) # 80003592 <end_op>
  return 0;
    800049fc:	4501                	li	a0,0
    800049fe:	a84d                	j	80004ab0 <sys_unlink+0x1c4>
    end_op();
    80004a00:	fffff097          	auipc	ra,0xfffff
    80004a04:	b92080e7          	jalr	-1134(ra) # 80003592 <end_op>
    return -1;
    80004a08:	557d                	li	a0,-1
    80004a0a:	a05d                	j	80004ab0 <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80004a0c:	00004517          	auipc	a0,0x4
    80004a10:	e1450513          	addi	a0,a0,-492 # 80008820 <syscall_names+0x2e0>
    80004a14:	00001097          	auipc	ra,0x1
    80004a18:	19c080e7          	jalr	412(ra) # 80005bb0 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004a1c:	04c92703          	lw	a4,76(s2)
    80004a20:	02000793          	li	a5,32
    80004a24:	f6e7f9e3          	bgeu	a5,a4,80004996 <sys_unlink+0xaa>
    80004a28:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004a2c:	4741                	li	a4,16
    80004a2e:	86ce                	mv	a3,s3
    80004a30:	f1840613          	addi	a2,s0,-232
    80004a34:	4581                	li	a1,0
    80004a36:	854a                	mv	a0,s2
    80004a38:	ffffe097          	auipc	ra,0xffffe
    80004a3c:	3b4080e7          	jalr	948(ra) # 80002dec <readi>
    80004a40:	47c1                	li	a5,16
    80004a42:	00f51b63          	bne	a0,a5,80004a58 <sys_unlink+0x16c>
    if(de.inum != 0)
    80004a46:	f1845783          	lhu	a5,-232(s0)
    80004a4a:	e7a1                	bnez	a5,80004a92 <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004a4c:	29c1                	addiw	s3,s3,16
    80004a4e:	04c92783          	lw	a5,76(s2)
    80004a52:	fcf9ede3          	bltu	s3,a5,80004a2c <sys_unlink+0x140>
    80004a56:	b781                	j	80004996 <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80004a58:	00004517          	auipc	a0,0x4
    80004a5c:	de050513          	addi	a0,a0,-544 # 80008838 <syscall_names+0x2f8>
    80004a60:	00001097          	auipc	ra,0x1
    80004a64:	150080e7          	jalr	336(ra) # 80005bb0 <panic>
    panic("unlink: writei");
    80004a68:	00004517          	auipc	a0,0x4
    80004a6c:	de850513          	addi	a0,a0,-536 # 80008850 <syscall_names+0x310>
    80004a70:	00001097          	auipc	ra,0x1
    80004a74:	140080e7          	jalr	320(ra) # 80005bb0 <panic>
    dp->nlink--;
    80004a78:	04a4d783          	lhu	a5,74(s1)
    80004a7c:	37fd                	addiw	a5,a5,-1
    80004a7e:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004a82:	8526                	mv	a0,s1
    80004a84:	ffffe097          	auipc	ra,0xffffe
    80004a88:	fe8080e7          	jalr	-24(ra) # 80002a6c <iupdate>
    80004a8c:	b781                	j	800049cc <sys_unlink+0xe0>
    return -1;
    80004a8e:	557d                	li	a0,-1
    80004a90:	a005                	j	80004ab0 <sys_unlink+0x1c4>
    iunlockput(ip);
    80004a92:	854a                	mv	a0,s2
    80004a94:	ffffe097          	auipc	ra,0xffffe
    80004a98:	306080e7          	jalr	774(ra) # 80002d9a <iunlockput>
  iunlockput(dp);
    80004a9c:	8526                	mv	a0,s1
    80004a9e:	ffffe097          	auipc	ra,0xffffe
    80004aa2:	2fc080e7          	jalr	764(ra) # 80002d9a <iunlockput>
  end_op();
    80004aa6:	fffff097          	auipc	ra,0xfffff
    80004aaa:	aec080e7          	jalr	-1300(ra) # 80003592 <end_op>
  return -1;
    80004aae:	557d                	li	a0,-1
}
    80004ab0:	70ae                	ld	ra,232(sp)
    80004ab2:	740e                	ld	s0,224(sp)
    80004ab4:	64ee                	ld	s1,216(sp)
    80004ab6:	694e                	ld	s2,208(sp)
    80004ab8:	69ae                	ld	s3,200(sp)
    80004aba:	616d                	addi	sp,sp,240
    80004abc:	8082                	ret

0000000080004abe <sys_open>:

uint64
sys_open(void)
{
    80004abe:	7131                	addi	sp,sp,-192
    80004ac0:	fd06                	sd	ra,184(sp)
    80004ac2:	f922                	sd	s0,176(sp)
    80004ac4:	f526                	sd	s1,168(sp)
    80004ac6:	f14a                	sd	s2,160(sp)
    80004ac8:	ed4e                	sd	s3,152(sp)
    80004aca:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004acc:	08000613          	li	a2,128
    80004ad0:	f5040593          	addi	a1,s0,-176
    80004ad4:	4501                	li	a0,0
    80004ad6:	ffffd097          	auipc	ra,0xffffd
    80004ada:	47a080e7          	jalr	1146(ra) # 80001f50 <argstr>
    return -1;
    80004ade:	54fd                	li	s1,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004ae0:	0c054163          	bltz	a0,80004ba2 <sys_open+0xe4>
    80004ae4:	f4c40593          	addi	a1,s0,-180
    80004ae8:	4505                	li	a0,1
    80004aea:	ffffd097          	auipc	ra,0xffffd
    80004aee:	422080e7          	jalr	1058(ra) # 80001f0c <argint>
    80004af2:	0a054863          	bltz	a0,80004ba2 <sys_open+0xe4>

  begin_op();
    80004af6:	fffff097          	auipc	ra,0xfffff
    80004afa:	a1e080e7          	jalr	-1506(ra) # 80003514 <begin_op>

  if(omode & O_CREATE){
    80004afe:	f4c42783          	lw	a5,-180(s0)
    80004b02:	2007f793          	andi	a5,a5,512
    80004b06:	cbdd                	beqz	a5,80004bbc <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80004b08:	4681                	li	a3,0
    80004b0a:	4601                	li	a2,0
    80004b0c:	4589                	li	a1,2
    80004b0e:	f5040513          	addi	a0,s0,-176
    80004b12:	00000097          	auipc	ra,0x0
    80004b16:	970080e7          	jalr	-1680(ra) # 80004482 <create>
    80004b1a:	892a                	mv	s2,a0
    if(ip == 0){
    80004b1c:	c959                	beqz	a0,80004bb2 <sys_open+0xf4>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004b1e:	04491703          	lh	a4,68(s2)
    80004b22:	478d                	li	a5,3
    80004b24:	00f71763          	bne	a4,a5,80004b32 <sys_open+0x74>
    80004b28:	04695703          	lhu	a4,70(s2)
    80004b2c:	47a5                	li	a5,9
    80004b2e:	0ce7ec63          	bltu	a5,a4,80004c06 <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004b32:	fffff097          	auipc	ra,0xfffff
    80004b36:	dee080e7          	jalr	-530(ra) # 80003920 <filealloc>
    80004b3a:	89aa                	mv	s3,a0
    80004b3c:	10050263          	beqz	a0,80004c40 <sys_open+0x182>
    80004b40:	00000097          	auipc	ra,0x0
    80004b44:	900080e7          	jalr	-1792(ra) # 80004440 <fdalloc>
    80004b48:	84aa                	mv	s1,a0
    80004b4a:	0e054663          	bltz	a0,80004c36 <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004b4e:	04491703          	lh	a4,68(s2)
    80004b52:	478d                	li	a5,3
    80004b54:	0cf70463          	beq	a4,a5,80004c1c <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004b58:	4789                	li	a5,2
    80004b5a:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004b5e:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004b62:	0129bc23          	sd	s2,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004b66:	f4c42783          	lw	a5,-180(s0)
    80004b6a:	0017c713          	xori	a4,a5,1
    80004b6e:	8b05                	andi	a4,a4,1
    80004b70:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004b74:	0037f713          	andi	a4,a5,3
    80004b78:	00e03733          	snez	a4,a4
    80004b7c:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004b80:	4007f793          	andi	a5,a5,1024
    80004b84:	c791                	beqz	a5,80004b90 <sys_open+0xd2>
    80004b86:	04491703          	lh	a4,68(s2)
    80004b8a:	4789                	li	a5,2
    80004b8c:	08f70f63          	beq	a4,a5,80004c2a <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    80004b90:	854a                	mv	a0,s2
    80004b92:	ffffe097          	auipc	ra,0xffffe
    80004b96:	068080e7          	jalr	104(ra) # 80002bfa <iunlock>
  end_op();
    80004b9a:	fffff097          	auipc	ra,0xfffff
    80004b9e:	9f8080e7          	jalr	-1544(ra) # 80003592 <end_op>

  return fd;
}
    80004ba2:	8526                	mv	a0,s1
    80004ba4:	70ea                	ld	ra,184(sp)
    80004ba6:	744a                	ld	s0,176(sp)
    80004ba8:	74aa                	ld	s1,168(sp)
    80004baa:	790a                	ld	s2,160(sp)
    80004bac:	69ea                	ld	s3,152(sp)
    80004bae:	6129                	addi	sp,sp,192
    80004bb0:	8082                	ret
      end_op();
    80004bb2:	fffff097          	auipc	ra,0xfffff
    80004bb6:	9e0080e7          	jalr	-1568(ra) # 80003592 <end_op>
      return -1;
    80004bba:	b7e5                	j	80004ba2 <sys_open+0xe4>
    if((ip = namei(path)) == 0){
    80004bbc:	f5040513          	addi	a0,s0,-176
    80004bc0:	ffffe097          	auipc	ra,0xffffe
    80004bc4:	734080e7          	jalr	1844(ra) # 800032f4 <namei>
    80004bc8:	892a                	mv	s2,a0
    80004bca:	c905                	beqz	a0,80004bfa <sys_open+0x13c>
    ilock(ip);
    80004bcc:	ffffe097          	auipc	ra,0xffffe
    80004bd0:	f6c080e7          	jalr	-148(ra) # 80002b38 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004bd4:	04491703          	lh	a4,68(s2)
    80004bd8:	4785                	li	a5,1
    80004bda:	f4f712e3          	bne	a4,a5,80004b1e <sys_open+0x60>
    80004bde:	f4c42783          	lw	a5,-180(s0)
    80004be2:	dba1                	beqz	a5,80004b32 <sys_open+0x74>
      iunlockput(ip);
    80004be4:	854a                	mv	a0,s2
    80004be6:	ffffe097          	auipc	ra,0xffffe
    80004bea:	1b4080e7          	jalr	436(ra) # 80002d9a <iunlockput>
      end_op();
    80004bee:	fffff097          	auipc	ra,0xfffff
    80004bf2:	9a4080e7          	jalr	-1628(ra) # 80003592 <end_op>
      return -1;
    80004bf6:	54fd                	li	s1,-1
    80004bf8:	b76d                	j	80004ba2 <sys_open+0xe4>
      end_op();
    80004bfa:	fffff097          	auipc	ra,0xfffff
    80004bfe:	998080e7          	jalr	-1640(ra) # 80003592 <end_op>
      return -1;
    80004c02:	54fd                	li	s1,-1
    80004c04:	bf79                	j	80004ba2 <sys_open+0xe4>
    iunlockput(ip);
    80004c06:	854a                	mv	a0,s2
    80004c08:	ffffe097          	auipc	ra,0xffffe
    80004c0c:	192080e7          	jalr	402(ra) # 80002d9a <iunlockput>
    end_op();
    80004c10:	fffff097          	auipc	ra,0xfffff
    80004c14:	982080e7          	jalr	-1662(ra) # 80003592 <end_op>
    return -1;
    80004c18:	54fd                	li	s1,-1
    80004c1a:	b761                	j	80004ba2 <sys_open+0xe4>
    f->type = FD_DEVICE;
    80004c1c:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004c20:	04691783          	lh	a5,70(s2)
    80004c24:	02f99223          	sh	a5,36(s3)
    80004c28:	bf2d                	j	80004b62 <sys_open+0xa4>
    itrunc(ip);
    80004c2a:	854a                	mv	a0,s2
    80004c2c:	ffffe097          	auipc	ra,0xffffe
    80004c30:	01a080e7          	jalr	26(ra) # 80002c46 <itrunc>
    80004c34:	bfb1                	j	80004b90 <sys_open+0xd2>
      fileclose(f);
    80004c36:	854e                	mv	a0,s3
    80004c38:	fffff097          	auipc	ra,0xfffff
    80004c3c:	da4080e7          	jalr	-604(ra) # 800039dc <fileclose>
    iunlockput(ip);
    80004c40:	854a                	mv	a0,s2
    80004c42:	ffffe097          	auipc	ra,0xffffe
    80004c46:	158080e7          	jalr	344(ra) # 80002d9a <iunlockput>
    end_op();
    80004c4a:	fffff097          	auipc	ra,0xfffff
    80004c4e:	948080e7          	jalr	-1720(ra) # 80003592 <end_op>
    return -1;
    80004c52:	54fd                	li	s1,-1
    80004c54:	b7b9                	j	80004ba2 <sys_open+0xe4>

0000000080004c56 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004c56:	7175                	addi	sp,sp,-144
    80004c58:	e506                	sd	ra,136(sp)
    80004c5a:	e122                	sd	s0,128(sp)
    80004c5c:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004c5e:	fffff097          	auipc	ra,0xfffff
    80004c62:	8b6080e7          	jalr	-1866(ra) # 80003514 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004c66:	08000613          	li	a2,128
    80004c6a:	f7040593          	addi	a1,s0,-144
    80004c6e:	4501                	li	a0,0
    80004c70:	ffffd097          	auipc	ra,0xffffd
    80004c74:	2e0080e7          	jalr	736(ra) # 80001f50 <argstr>
    80004c78:	02054963          	bltz	a0,80004caa <sys_mkdir+0x54>
    80004c7c:	4681                	li	a3,0
    80004c7e:	4601                	li	a2,0
    80004c80:	4585                	li	a1,1
    80004c82:	f7040513          	addi	a0,s0,-144
    80004c86:	fffff097          	auipc	ra,0xfffff
    80004c8a:	7fc080e7          	jalr	2044(ra) # 80004482 <create>
    80004c8e:	cd11                	beqz	a0,80004caa <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004c90:	ffffe097          	auipc	ra,0xffffe
    80004c94:	10a080e7          	jalr	266(ra) # 80002d9a <iunlockput>
  end_op();
    80004c98:	fffff097          	auipc	ra,0xfffff
    80004c9c:	8fa080e7          	jalr	-1798(ra) # 80003592 <end_op>
  return 0;
    80004ca0:	4501                	li	a0,0
}
    80004ca2:	60aa                	ld	ra,136(sp)
    80004ca4:	640a                	ld	s0,128(sp)
    80004ca6:	6149                	addi	sp,sp,144
    80004ca8:	8082                	ret
    end_op();
    80004caa:	fffff097          	auipc	ra,0xfffff
    80004cae:	8e8080e7          	jalr	-1816(ra) # 80003592 <end_op>
    return -1;
    80004cb2:	557d                	li	a0,-1
    80004cb4:	b7fd                	j	80004ca2 <sys_mkdir+0x4c>

0000000080004cb6 <sys_mknod>:

uint64
sys_mknod(void)
{
    80004cb6:	7135                	addi	sp,sp,-160
    80004cb8:	ed06                	sd	ra,152(sp)
    80004cba:	e922                	sd	s0,144(sp)
    80004cbc:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004cbe:	fffff097          	auipc	ra,0xfffff
    80004cc2:	856080e7          	jalr	-1962(ra) # 80003514 <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004cc6:	08000613          	li	a2,128
    80004cca:	f7040593          	addi	a1,s0,-144
    80004cce:	4501                	li	a0,0
    80004cd0:	ffffd097          	auipc	ra,0xffffd
    80004cd4:	280080e7          	jalr	640(ra) # 80001f50 <argstr>
    80004cd8:	04054a63          	bltz	a0,80004d2c <sys_mknod+0x76>
     argint(1, &major) < 0 ||
    80004cdc:	f6c40593          	addi	a1,s0,-148
    80004ce0:	4505                	li	a0,1
    80004ce2:	ffffd097          	auipc	ra,0xffffd
    80004ce6:	22a080e7          	jalr	554(ra) # 80001f0c <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004cea:	04054163          	bltz	a0,80004d2c <sys_mknod+0x76>
     argint(2, &minor) < 0 ||
    80004cee:	f6840593          	addi	a1,s0,-152
    80004cf2:	4509                	li	a0,2
    80004cf4:	ffffd097          	auipc	ra,0xffffd
    80004cf8:	218080e7          	jalr	536(ra) # 80001f0c <argint>
     argint(1, &major) < 0 ||
    80004cfc:	02054863          	bltz	a0,80004d2c <sys_mknod+0x76>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004d00:	f6841683          	lh	a3,-152(s0)
    80004d04:	f6c41603          	lh	a2,-148(s0)
    80004d08:	458d                	li	a1,3
    80004d0a:	f7040513          	addi	a0,s0,-144
    80004d0e:	fffff097          	auipc	ra,0xfffff
    80004d12:	774080e7          	jalr	1908(ra) # 80004482 <create>
     argint(2, &minor) < 0 ||
    80004d16:	c919                	beqz	a0,80004d2c <sys_mknod+0x76>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004d18:	ffffe097          	auipc	ra,0xffffe
    80004d1c:	082080e7          	jalr	130(ra) # 80002d9a <iunlockput>
  end_op();
    80004d20:	fffff097          	auipc	ra,0xfffff
    80004d24:	872080e7          	jalr	-1934(ra) # 80003592 <end_op>
  return 0;
    80004d28:	4501                	li	a0,0
    80004d2a:	a031                	j	80004d36 <sys_mknod+0x80>
    end_op();
    80004d2c:	fffff097          	auipc	ra,0xfffff
    80004d30:	866080e7          	jalr	-1946(ra) # 80003592 <end_op>
    return -1;
    80004d34:	557d                	li	a0,-1
}
    80004d36:	60ea                	ld	ra,152(sp)
    80004d38:	644a                	ld	s0,144(sp)
    80004d3a:	610d                	addi	sp,sp,160
    80004d3c:	8082                	ret

0000000080004d3e <sys_chdir>:

uint64
sys_chdir(void)
{
    80004d3e:	7135                	addi	sp,sp,-160
    80004d40:	ed06                	sd	ra,152(sp)
    80004d42:	e922                	sd	s0,144(sp)
    80004d44:	e526                	sd	s1,136(sp)
    80004d46:	e14a                	sd	s2,128(sp)
    80004d48:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004d4a:	ffffc097          	auipc	ra,0xffffc
    80004d4e:	0fa080e7          	jalr	250(ra) # 80000e44 <myproc>
    80004d52:	892a                	mv	s2,a0
  
  begin_op();
    80004d54:	ffffe097          	auipc	ra,0xffffe
    80004d58:	7c0080e7          	jalr	1984(ra) # 80003514 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004d5c:	08000613          	li	a2,128
    80004d60:	f6040593          	addi	a1,s0,-160
    80004d64:	4501                	li	a0,0
    80004d66:	ffffd097          	auipc	ra,0xffffd
    80004d6a:	1ea080e7          	jalr	490(ra) # 80001f50 <argstr>
    80004d6e:	04054b63          	bltz	a0,80004dc4 <sys_chdir+0x86>
    80004d72:	f6040513          	addi	a0,s0,-160
    80004d76:	ffffe097          	auipc	ra,0xffffe
    80004d7a:	57e080e7          	jalr	1406(ra) # 800032f4 <namei>
    80004d7e:	84aa                	mv	s1,a0
    80004d80:	c131                	beqz	a0,80004dc4 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80004d82:	ffffe097          	auipc	ra,0xffffe
    80004d86:	db6080e7          	jalr	-586(ra) # 80002b38 <ilock>
  if(ip->type != T_DIR){
    80004d8a:	04449703          	lh	a4,68(s1)
    80004d8e:	4785                	li	a5,1
    80004d90:	04f71063          	bne	a4,a5,80004dd0 <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004d94:	8526                	mv	a0,s1
    80004d96:	ffffe097          	auipc	ra,0xffffe
    80004d9a:	e64080e7          	jalr	-412(ra) # 80002bfa <iunlock>
  iput(p->cwd);
    80004d9e:	15093503          	ld	a0,336(s2)
    80004da2:	ffffe097          	auipc	ra,0xffffe
    80004da6:	f50080e7          	jalr	-176(ra) # 80002cf2 <iput>
  end_op();
    80004daa:	ffffe097          	auipc	ra,0xffffe
    80004dae:	7e8080e7          	jalr	2024(ra) # 80003592 <end_op>
  p->cwd = ip;
    80004db2:	14993823          	sd	s1,336(s2)
  return 0;
    80004db6:	4501                	li	a0,0
}
    80004db8:	60ea                	ld	ra,152(sp)
    80004dba:	644a                	ld	s0,144(sp)
    80004dbc:	64aa                	ld	s1,136(sp)
    80004dbe:	690a                	ld	s2,128(sp)
    80004dc0:	610d                	addi	sp,sp,160
    80004dc2:	8082                	ret
    end_op();
    80004dc4:	ffffe097          	auipc	ra,0xffffe
    80004dc8:	7ce080e7          	jalr	1998(ra) # 80003592 <end_op>
    return -1;
    80004dcc:	557d                	li	a0,-1
    80004dce:	b7ed                	j	80004db8 <sys_chdir+0x7a>
    iunlockput(ip);
    80004dd0:	8526                	mv	a0,s1
    80004dd2:	ffffe097          	auipc	ra,0xffffe
    80004dd6:	fc8080e7          	jalr	-56(ra) # 80002d9a <iunlockput>
    end_op();
    80004dda:	ffffe097          	auipc	ra,0xffffe
    80004dde:	7b8080e7          	jalr	1976(ra) # 80003592 <end_op>
    return -1;
    80004de2:	557d                	li	a0,-1
    80004de4:	bfd1                	j	80004db8 <sys_chdir+0x7a>

0000000080004de6 <sys_exec>:

uint64
sys_exec(void)
{
    80004de6:	7145                	addi	sp,sp,-464
    80004de8:	e786                	sd	ra,456(sp)
    80004dea:	e3a2                	sd	s0,448(sp)
    80004dec:	ff26                	sd	s1,440(sp)
    80004dee:	fb4a                	sd	s2,432(sp)
    80004df0:	f74e                	sd	s3,424(sp)
    80004df2:	f352                	sd	s4,416(sp)
    80004df4:	ef56                	sd	s5,408(sp)
    80004df6:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80004df8:	08000613          	li	a2,128
    80004dfc:	f4040593          	addi	a1,s0,-192
    80004e00:	4501                	li	a0,0
    80004e02:	ffffd097          	auipc	ra,0xffffd
    80004e06:	14e080e7          	jalr	334(ra) # 80001f50 <argstr>
    return -1;
    80004e0a:	597d                	li	s2,-1
  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80004e0c:	0c054b63          	bltz	a0,80004ee2 <sys_exec+0xfc>
    80004e10:	e3840593          	addi	a1,s0,-456
    80004e14:	4505                	li	a0,1
    80004e16:	ffffd097          	auipc	ra,0xffffd
    80004e1a:	118080e7          	jalr	280(ra) # 80001f2e <argaddr>
    80004e1e:	0c054263          	bltz	a0,80004ee2 <sys_exec+0xfc>
  }
  memset(argv, 0, sizeof(argv));
    80004e22:	10000613          	li	a2,256
    80004e26:	4581                	li	a1,0
    80004e28:	e4040513          	addi	a0,s0,-448
    80004e2c:	ffffb097          	auipc	ra,0xffffb
    80004e30:	34e080e7          	jalr	846(ra) # 8000017a <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80004e34:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    80004e38:	89a6                	mv	s3,s1
    80004e3a:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80004e3c:	02000a13          	li	s4,32
    80004e40:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80004e44:	00391513          	slli	a0,s2,0x3
    80004e48:	e3040593          	addi	a1,s0,-464
    80004e4c:	e3843783          	ld	a5,-456(s0)
    80004e50:	953e                	add	a0,a0,a5
    80004e52:	ffffd097          	auipc	ra,0xffffd
    80004e56:	020080e7          	jalr	32(ra) # 80001e72 <fetchaddr>
    80004e5a:	02054a63          	bltz	a0,80004e8e <sys_exec+0xa8>
      goto bad;
    }
    if(uarg == 0){
    80004e5e:	e3043783          	ld	a5,-464(s0)
    80004e62:	c3b9                	beqz	a5,80004ea8 <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80004e64:	ffffb097          	auipc	ra,0xffffb
    80004e68:	2b6080e7          	jalr	694(ra) # 8000011a <kalloc>
    80004e6c:	85aa                	mv	a1,a0
    80004e6e:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80004e72:	cd11                	beqz	a0,80004e8e <sys_exec+0xa8>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80004e74:	6605                	lui	a2,0x1
    80004e76:	e3043503          	ld	a0,-464(s0)
    80004e7a:	ffffd097          	auipc	ra,0xffffd
    80004e7e:	04a080e7          	jalr	74(ra) # 80001ec4 <fetchstr>
    80004e82:	00054663          	bltz	a0,80004e8e <sys_exec+0xa8>
    if(i >= NELEM(argv)){
    80004e86:	0905                	addi	s2,s2,1
    80004e88:	09a1                	addi	s3,s3,8
    80004e8a:	fb491be3          	bne	s2,s4,80004e40 <sys_exec+0x5a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004e8e:	f4040913          	addi	s2,s0,-192
    80004e92:	6088                	ld	a0,0(s1)
    80004e94:	c531                	beqz	a0,80004ee0 <sys_exec+0xfa>
    kfree(argv[i]);
    80004e96:	ffffb097          	auipc	ra,0xffffb
    80004e9a:	186080e7          	jalr	390(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004e9e:	04a1                	addi	s1,s1,8
    80004ea0:	ff2499e3          	bne	s1,s2,80004e92 <sys_exec+0xac>
  return -1;
    80004ea4:	597d                	li	s2,-1
    80004ea6:	a835                	j	80004ee2 <sys_exec+0xfc>
      argv[i] = 0;
    80004ea8:	0a8e                	slli	s5,s5,0x3
    80004eaa:	fc0a8793          	addi	a5,s5,-64 # ffffffffffffefc0 <end+0xffffffff7ffd8d80>
    80004eae:	00878ab3          	add	s5,a5,s0
    80004eb2:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    80004eb6:	e4040593          	addi	a1,s0,-448
    80004eba:	f4040513          	addi	a0,s0,-192
    80004ebe:	fffff097          	auipc	ra,0xfffff
    80004ec2:	172080e7          	jalr	370(ra) # 80004030 <exec>
    80004ec6:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004ec8:	f4040993          	addi	s3,s0,-192
    80004ecc:	6088                	ld	a0,0(s1)
    80004ece:	c911                	beqz	a0,80004ee2 <sys_exec+0xfc>
    kfree(argv[i]);
    80004ed0:	ffffb097          	auipc	ra,0xffffb
    80004ed4:	14c080e7          	jalr	332(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004ed8:	04a1                	addi	s1,s1,8
    80004eda:	ff3499e3          	bne	s1,s3,80004ecc <sys_exec+0xe6>
    80004ede:	a011                	j	80004ee2 <sys_exec+0xfc>
  return -1;
    80004ee0:	597d                	li	s2,-1
}
    80004ee2:	854a                	mv	a0,s2
    80004ee4:	60be                	ld	ra,456(sp)
    80004ee6:	641e                	ld	s0,448(sp)
    80004ee8:	74fa                	ld	s1,440(sp)
    80004eea:	795a                	ld	s2,432(sp)
    80004eec:	79ba                	ld	s3,424(sp)
    80004eee:	7a1a                	ld	s4,416(sp)
    80004ef0:	6afa                	ld	s5,408(sp)
    80004ef2:	6179                	addi	sp,sp,464
    80004ef4:	8082                	ret

0000000080004ef6 <sys_pipe>:

uint64
sys_pipe(void)
{
    80004ef6:	7139                	addi	sp,sp,-64
    80004ef8:	fc06                	sd	ra,56(sp)
    80004efa:	f822                	sd	s0,48(sp)
    80004efc:	f426                	sd	s1,40(sp)
    80004efe:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80004f00:	ffffc097          	auipc	ra,0xffffc
    80004f04:	f44080e7          	jalr	-188(ra) # 80000e44 <myproc>
    80004f08:	84aa                	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    80004f0a:	fd840593          	addi	a1,s0,-40
    80004f0e:	4501                	li	a0,0
    80004f10:	ffffd097          	auipc	ra,0xffffd
    80004f14:	01e080e7          	jalr	30(ra) # 80001f2e <argaddr>
    return -1;
    80004f18:	57fd                	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    80004f1a:	0e054063          	bltz	a0,80004ffa <sys_pipe+0x104>
  if(pipealloc(&rf, &wf) < 0)
    80004f1e:	fc840593          	addi	a1,s0,-56
    80004f22:	fd040513          	addi	a0,s0,-48
    80004f26:	fffff097          	auipc	ra,0xfffff
    80004f2a:	de6080e7          	jalr	-538(ra) # 80003d0c <pipealloc>
    return -1;
    80004f2e:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80004f30:	0c054563          	bltz	a0,80004ffa <sys_pipe+0x104>
  fd0 = -1;
    80004f34:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80004f38:	fd043503          	ld	a0,-48(s0)
    80004f3c:	fffff097          	auipc	ra,0xfffff
    80004f40:	504080e7          	jalr	1284(ra) # 80004440 <fdalloc>
    80004f44:	fca42223          	sw	a0,-60(s0)
    80004f48:	08054c63          	bltz	a0,80004fe0 <sys_pipe+0xea>
    80004f4c:	fc843503          	ld	a0,-56(s0)
    80004f50:	fffff097          	auipc	ra,0xfffff
    80004f54:	4f0080e7          	jalr	1264(ra) # 80004440 <fdalloc>
    80004f58:	fca42023          	sw	a0,-64(s0)
    80004f5c:	06054963          	bltz	a0,80004fce <sys_pipe+0xd8>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80004f60:	4691                	li	a3,4
    80004f62:	fc440613          	addi	a2,s0,-60
    80004f66:	fd843583          	ld	a1,-40(s0)
    80004f6a:	68a8                	ld	a0,80(s1)
    80004f6c:	ffffc097          	auipc	ra,0xffffc
    80004f70:	b9c080e7          	jalr	-1124(ra) # 80000b08 <copyout>
    80004f74:	02054063          	bltz	a0,80004f94 <sys_pipe+0x9e>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80004f78:	4691                	li	a3,4
    80004f7a:	fc040613          	addi	a2,s0,-64
    80004f7e:	fd843583          	ld	a1,-40(s0)
    80004f82:	0591                	addi	a1,a1,4
    80004f84:	68a8                	ld	a0,80(s1)
    80004f86:	ffffc097          	auipc	ra,0xffffc
    80004f8a:	b82080e7          	jalr	-1150(ra) # 80000b08 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80004f8e:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80004f90:	06055563          	bgez	a0,80004ffa <sys_pipe+0x104>
    p->ofile[fd0] = 0;
    80004f94:	fc442783          	lw	a5,-60(s0)
    80004f98:	07e9                	addi	a5,a5,26
    80004f9a:	078e                	slli	a5,a5,0x3
    80004f9c:	97a6                	add	a5,a5,s1
    80004f9e:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80004fa2:	fc042783          	lw	a5,-64(s0)
    80004fa6:	07e9                	addi	a5,a5,26
    80004fa8:	078e                	slli	a5,a5,0x3
    80004faa:	00f48533          	add	a0,s1,a5
    80004fae:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    80004fb2:	fd043503          	ld	a0,-48(s0)
    80004fb6:	fffff097          	auipc	ra,0xfffff
    80004fba:	a26080e7          	jalr	-1498(ra) # 800039dc <fileclose>
    fileclose(wf);
    80004fbe:	fc843503          	ld	a0,-56(s0)
    80004fc2:	fffff097          	auipc	ra,0xfffff
    80004fc6:	a1a080e7          	jalr	-1510(ra) # 800039dc <fileclose>
    return -1;
    80004fca:	57fd                	li	a5,-1
    80004fcc:	a03d                	j	80004ffa <sys_pipe+0x104>
    if(fd0 >= 0)
    80004fce:	fc442783          	lw	a5,-60(s0)
    80004fd2:	0007c763          	bltz	a5,80004fe0 <sys_pipe+0xea>
      p->ofile[fd0] = 0;
    80004fd6:	07e9                	addi	a5,a5,26
    80004fd8:	078e                	slli	a5,a5,0x3
    80004fda:	97a6                	add	a5,a5,s1
    80004fdc:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    80004fe0:	fd043503          	ld	a0,-48(s0)
    80004fe4:	fffff097          	auipc	ra,0xfffff
    80004fe8:	9f8080e7          	jalr	-1544(ra) # 800039dc <fileclose>
    fileclose(wf);
    80004fec:	fc843503          	ld	a0,-56(s0)
    80004ff0:	fffff097          	auipc	ra,0xfffff
    80004ff4:	9ec080e7          	jalr	-1556(ra) # 800039dc <fileclose>
    return -1;
    80004ff8:	57fd                	li	a5,-1
}
    80004ffa:	853e                	mv	a0,a5
    80004ffc:	70e2                	ld	ra,56(sp)
    80004ffe:	7442                	ld	s0,48(sp)
    80005000:	74a2                	ld	s1,40(sp)
    80005002:	6121                	addi	sp,sp,64
    80005004:	8082                	ret
	...

0000000080005010 <kernelvec>:
    80005010:	7111                	addi	sp,sp,-256
    80005012:	e006                	sd	ra,0(sp)
    80005014:	e40a                	sd	sp,8(sp)
    80005016:	e80e                	sd	gp,16(sp)
    80005018:	ec12                	sd	tp,24(sp)
    8000501a:	f016                	sd	t0,32(sp)
    8000501c:	f41a                	sd	t1,40(sp)
    8000501e:	f81e                	sd	t2,48(sp)
    80005020:	fc22                	sd	s0,56(sp)
    80005022:	e0a6                	sd	s1,64(sp)
    80005024:	e4aa                	sd	a0,72(sp)
    80005026:	e8ae                	sd	a1,80(sp)
    80005028:	ecb2                	sd	a2,88(sp)
    8000502a:	f0b6                	sd	a3,96(sp)
    8000502c:	f4ba                	sd	a4,104(sp)
    8000502e:	f8be                	sd	a5,112(sp)
    80005030:	fcc2                	sd	a6,120(sp)
    80005032:	e146                	sd	a7,128(sp)
    80005034:	e54a                	sd	s2,136(sp)
    80005036:	e94e                	sd	s3,144(sp)
    80005038:	ed52                	sd	s4,152(sp)
    8000503a:	f156                	sd	s5,160(sp)
    8000503c:	f55a                	sd	s6,168(sp)
    8000503e:	f95e                	sd	s7,176(sp)
    80005040:	fd62                	sd	s8,184(sp)
    80005042:	e1e6                	sd	s9,192(sp)
    80005044:	e5ea                	sd	s10,200(sp)
    80005046:	e9ee                	sd	s11,208(sp)
    80005048:	edf2                	sd	t3,216(sp)
    8000504a:	f1f6                	sd	t4,224(sp)
    8000504c:	f5fa                	sd	t5,232(sp)
    8000504e:	f9fe                	sd	t6,240(sp)
    80005050:	ceffc0ef          	jal	ra,80001d3e <kerneltrap>
    80005054:	6082                	ld	ra,0(sp)
    80005056:	6122                	ld	sp,8(sp)
    80005058:	61c2                	ld	gp,16(sp)
    8000505a:	7282                	ld	t0,32(sp)
    8000505c:	7322                	ld	t1,40(sp)
    8000505e:	73c2                	ld	t2,48(sp)
    80005060:	7462                	ld	s0,56(sp)
    80005062:	6486                	ld	s1,64(sp)
    80005064:	6526                	ld	a0,72(sp)
    80005066:	65c6                	ld	a1,80(sp)
    80005068:	6666                	ld	a2,88(sp)
    8000506a:	7686                	ld	a3,96(sp)
    8000506c:	7726                	ld	a4,104(sp)
    8000506e:	77c6                	ld	a5,112(sp)
    80005070:	7866                	ld	a6,120(sp)
    80005072:	688a                	ld	a7,128(sp)
    80005074:	692a                	ld	s2,136(sp)
    80005076:	69ca                	ld	s3,144(sp)
    80005078:	6a6a                	ld	s4,152(sp)
    8000507a:	7a8a                	ld	s5,160(sp)
    8000507c:	7b2a                	ld	s6,168(sp)
    8000507e:	7bca                	ld	s7,176(sp)
    80005080:	7c6a                	ld	s8,184(sp)
    80005082:	6c8e                	ld	s9,192(sp)
    80005084:	6d2e                	ld	s10,200(sp)
    80005086:	6dce                	ld	s11,208(sp)
    80005088:	6e6e                	ld	t3,216(sp)
    8000508a:	7e8e                	ld	t4,224(sp)
    8000508c:	7f2e                	ld	t5,232(sp)
    8000508e:	7fce                	ld	t6,240(sp)
    80005090:	6111                	addi	sp,sp,256
    80005092:	10200073          	sret
    80005096:	00000013          	nop
    8000509a:	00000013          	nop
    8000509e:	0001                	nop

00000000800050a0 <timervec>:
    800050a0:	34051573          	csrrw	a0,mscratch,a0
    800050a4:	e10c                	sd	a1,0(a0)
    800050a6:	e510                	sd	a2,8(a0)
    800050a8:	e914                	sd	a3,16(a0)
    800050aa:	6d0c                	ld	a1,24(a0)
    800050ac:	7110                	ld	a2,32(a0)
    800050ae:	6194                	ld	a3,0(a1)
    800050b0:	96b2                	add	a3,a3,a2
    800050b2:	e194                	sd	a3,0(a1)
    800050b4:	4589                	li	a1,2
    800050b6:	14459073          	csrw	sip,a1
    800050ba:	6914                	ld	a3,16(a0)
    800050bc:	6510                	ld	a2,8(a0)
    800050be:	610c                	ld	a1,0(a0)
    800050c0:	34051573          	csrrw	a0,mscratch,a0
    800050c4:	30200073          	mret
	...

00000000800050ca <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    800050ca:	1141                	addi	sp,sp,-16
    800050cc:	e422                	sd	s0,8(sp)
    800050ce:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    800050d0:	0c0007b7          	lui	a5,0xc000
    800050d4:	4705                	li	a4,1
    800050d6:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    800050d8:	c3d8                	sw	a4,4(a5)
}
    800050da:	6422                	ld	s0,8(sp)
    800050dc:	0141                	addi	sp,sp,16
    800050de:	8082                	ret

00000000800050e0 <plicinithart>:

void
plicinithart(void)
{
    800050e0:	1141                	addi	sp,sp,-16
    800050e2:	e406                	sd	ra,8(sp)
    800050e4:	e022                	sd	s0,0(sp)
    800050e6:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800050e8:	ffffc097          	auipc	ra,0xffffc
    800050ec:	d30080e7          	jalr	-720(ra) # 80000e18 <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    800050f0:	0085171b          	slliw	a4,a0,0x8
    800050f4:	0c0027b7          	lui	a5,0xc002
    800050f8:	97ba                	add	a5,a5,a4
    800050fa:	40200713          	li	a4,1026
    800050fe:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005102:	00d5151b          	slliw	a0,a0,0xd
    80005106:	0c2017b7          	lui	a5,0xc201
    8000510a:	97aa                	add	a5,a5,a0
    8000510c:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80005110:	60a2                	ld	ra,8(sp)
    80005112:	6402                	ld	s0,0(sp)
    80005114:	0141                	addi	sp,sp,16
    80005116:	8082                	ret

0000000080005118 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80005118:	1141                	addi	sp,sp,-16
    8000511a:	e406                	sd	ra,8(sp)
    8000511c:	e022                	sd	s0,0(sp)
    8000511e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005120:	ffffc097          	auipc	ra,0xffffc
    80005124:	cf8080e7          	jalr	-776(ra) # 80000e18 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80005128:	00d5151b          	slliw	a0,a0,0xd
    8000512c:	0c2017b7          	lui	a5,0xc201
    80005130:	97aa                	add	a5,a5,a0
  return irq;
}
    80005132:	43c8                	lw	a0,4(a5)
    80005134:	60a2                	ld	ra,8(sp)
    80005136:	6402                	ld	s0,0(sp)
    80005138:	0141                	addi	sp,sp,16
    8000513a:	8082                	ret

000000008000513c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    8000513c:	1101                	addi	sp,sp,-32
    8000513e:	ec06                	sd	ra,24(sp)
    80005140:	e822                	sd	s0,16(sp)
    80005142:	e426                	sd	s1,8(sp)
    80005144:	1000                	addi	s0,sp,32
    80005146:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005148:	ffffc097          	auipc	ra,0xffffc
    8000514c:	cd0080e7          	jalr	-816(ra) # 80000e18 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005150:	00d5151b          	slliw	a0,a0,0xd
    80005154:	0c2017b7          	lui	a5,0xc201
    80005158:	97aa                	add	a5,a5,a0
    8000515a:	c3c4                	sw	s1,4(a5)
}
    8000515c:	60e2                	ld	ra,24(sp)
    8000515e:	6442                	ld	s0,16(sp)
    80005160:	64a2                	ld	s1,8(sp)
    80005162:	6105                	addi	sp,sp,32
    80005164:	8082                	ret

0000000080005166 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80005166:	1141                	addi	sp,sp,-16
    80005168:	e406                	sd	ra,8(sp)
    8000516a:	e022                	sd	s0,0(sp)
    8000516c:	0800                	addi	s0,sp,16
  if(i >= NUM)
    8000516e:	479d                	li	a5,7
    80005170:	06a7c863          	blt	a5,a0,800051e0 <free_desc+0x7a>
    panic("free_desc 1");
  if(disk.free[i])
    80005174:	00016717          	auipc	a4,0x16
    80005178:	e8c70713          	addi	a4,a4,-372 # 8001b000 <disk>
    8000517c:	972a                	add	a4,a4,a0
    8000517e:	6789                	lui	a5,0x2
    80005180:	97ba                	add	a5,a5,a4
    80005182:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    80005186:	e7ad                	bnez	a5,800051f0 <free_desc+0x8a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80005188:	00451793          	slli	a5,a0,0x4
    8000518c:	00018717          	auipc	a4,0x18
    80005190:	e7470713          	addi	a4,a4,-396 # 8001d000 <disk+0x2000>
    80005194:	6314                	ld	a3,0(a4)
    80005196:	96be                	add	a3,a3,a5
    80005198:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    8000519c:	6314                	ld	a3,0(a4)
    8000519e:	96be                	add	a3,a3,a5
    800051a0:	0006a423          	sw	zero,8(a3)
  disk.desc[i].flags = 0;
    800051a4:	6314                	ld	a3,0(a4)
    800051a6:	96be                	add	a3,a3,a5
    800051a8:	00069623          	sh	zero,12(a3)
  disk.desc[i].next = 0;
    800051ac:	6318                	ld	a4,0(a4)
    800051ae:	97ba                	add	a5,a5,a4
    800051b0:	00079723          	sh	zero,14(a5)
  disk.free[i] = 1;
    800051b4:	00016717          	auipc	a4,0x16
    800051b8:	e4c70713          	addi	a4,a4,-436 # 8001b000 <disk>
    800051bc:	972a                	add	a4,a4,a0
    800051be:	6789                	lui	a5,0x2
    800051c0:	97ba                	add	a5,a5,a4
    800051c2:	4705                	li	a4,1
    800051c4:	00e78c23          	sb	a4,24(a5) # 2018 <_entry-0x7fffdfe8>
  wakeup(&disk.free[0]);
    800051c8:	00018517          	auipc	a0,0x18
    800051cc:	e5050513          	addi	a0,a0,-432 # 8001d018 <disk+0x2018>
    800051d0:	ffffc097          	auipc	ra,0xffffc
    800051d4:	4d6080e7          	jalr	1238(ra) # 800016a6 <wakeup>
}
    800051d8:	60a2                	ld	ra,8(sp)
    800051da:	6402                	ld	s0,0(sp)
    800051dc:	0141                	addi	sp,sp,16
    800051de:	8082                	ret
    panic("free_desc 1");
    800051e0:	00003517          	auipc	a0,0x3
    800051e4:	68050513          	addi	a0,a0,1664 # 80008860 <syscall_names+0x320>
    800051e8:	00001097          	auipc	ra,0x1
    800051ec:	9c8080e7          	jalr	-1592(ra) # 80005bb0 <panic>
    panic("free_desc 2");
    800051f0:	00003517          	auipc	a0,0x3
    800051f4:	68050513          	addi	a0,a0,1664 # 80008870 <syscall_names+0x330>
    800051f8:	00001097          	auipc	ra,0x1
    800051fc:	9b8080e7          	jalr	-1608(ra) # 80005bb0 <panic>

0000000080005200 <virtio_disk_init>:
{
    80005200:	1101                	addi	sp,sp,-32
    80005202:	ec06                	sd	ra,24(sp)
    80005204:	e822                	sd	s0,16(sp)
    80005206:	e426                	sd	s1,8(sp)
    80005208:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    8000520a:	00003597          	auipc	a1,0x3
    8000520e:	67658593          	addi	a1,a1,1654 # 80008880 <syscall_names+0x340>
    80005212:	00018517          	auipc	a0,0x18
    80005216:	f1650513          	addi	a0,a0,-234 # 8001d128 <disk+0x2128>
    8000521a:	00001097          	auipc	ra,0x1
    8000521e:	e3e080e7          	jalr	-450(ra) # 80006058 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005222:	100017b7          	lui	a5,0x10001
    80005226:	4398                	lw	a4,0(a5)
    80005228:	2701                	sext.w	a4,a4
    8000522a:	747277b7          	lui	a5,0x74727
    8000522e:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80005232:	0ef71063          	bne	a4,a5,80005312 <virtio_disk_init+0x112>
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    80005236:	100017b7          	lui	a5,0x10001
    8000523a:	43dc                	lw	a5,4(a5)
    8000523c:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    8000523e:	4705                	li	a4,1
    80005240:	0ce79963          	bne	a5,a4,80005312 <virtio_disk_init+0x112>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005244:	100017b7          	lui	a5,0x10001
    80005248:	479c                	lw	a5,8(a5)
    8000524a:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    8000524c:	4709                	li	a4,2
    8000524e:	0ce79263          	bne	a5,a4,80005312 <virtio_disk_init+0x112>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80005252:	100017b7          	lui	a5,0x10001
    80005256:	47d8                	lw	a4,12(a5)
    80005258:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000525a:	554d47b7          	lui	a5,0x554d4
    8000525e:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80005262:	0af71863          	bne	a4,a5,80005312 <virtio_disk_init+0x112>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005266:	100017b7          	lui	a5,0x10001
    8000526a:	4705                	li	a4,1
    8000526c:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000526e:	470d                	li	a4,3
    80005270:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80005272:	4b98                	lw	a4,16(a5)
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005274:	c7ffe6b7          	lui	a3,0xc7ffe
    80005278:	75f68693          	addi	a3,a3,1887 # ffffffffc7ffe75f <end+0xffffffff47fd851f>
    8000527c:	8f75                	and	a4,a4,a3
    8000527e:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005280:	472d                	li	a4,11
    80005282:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005284:	473d                	li	a4,15
    80005286:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    80005288:	6705                	lui	a4,0x1
    8000528a:	d798                	sw	a4,40(a5)
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    8000528c:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005290:	5bdc                	lw	a5,52(a5)
    80005292:	2781                	sext.w	a5,a5
  if(max == 0)
    80005294:	c7d9                	beqz	a5,80005322 <virtio_disk_init+0x122>
  if(max < NUM)
    80005296:	471d                	li	a4,7
    80005298:	08f77d63          	bgeu	a4,a5,80005332 <virtio_disk_init+0x132>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    8000529c:	100014b7          	lui	s1,0x10001
    800052a0:	47a1                	li	a5,8
    800052a2:	dc9c                	sw	a5,56(s1)
  memset(disk.pages, 0, sizeof(disk.pages));
    800052a4:	6609                	lui	a2,0x2
    800052a6:	4581                	li	a1,0
    800052a8:	00016517          	auipc	a0,0x16
    800052ac:	d5850513          	addi	a0,a0,-680 # 8001b000 <disk>
    800052b0:	ffffb097          	auipc	ra,0xffffb
    800052b4:	eca080e7          	jalr	-310(ra) # 8000017a <memset>
  *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk.pages) >> PGSHIFT;
    800052b8:	00016717          	auipc	a4,0x16
    800052bc:	d4870713          	addi	a4,a4,-696 # 8001b000 <disk>
    800052c0:	00c75793          	srli	a5,a4,0xc
    800052c4:	2781                	sext.w	a5,a5
    800052c6:	c0bc                	sw	a5,64(s1)
  disk.desc = (struct virtq_desc *) disk.pages;
    800052c8:	00018797          	auipc	a5,0x18
    800052cc:	d3878793          	addi	a5,a5,-712 # 8001d000 <disk+0x2000>
    800052d0:	e398                	sd	a4,0(a5)
  disk.avail = (struct virtq_avail *)(disk.pages + NUM*sizeof(struct virtq_desc));
    800052d2:	00016717          	auipc	a4,0x16
    800052d6:	dae70713          	addi	a4,a4,-594 # 8001b080 <disk+0x80>
    800052da:	e798                	sd	a4,8(a5)
  disk.used = (struct virtq_used *) (disk.pages + PGSIZE);
    800052dc:	00017717          	auipc	a4,0x17
    800052e0:	d2470713          	addi	a4,a4,-732 # 8001c000 <disk+0x1000>
    800052e4:	eb98                	sd	a4,16(a5)
    disk.free[i] = 1;
    800052e6:	4705                	li	a4,1
    800052e8:	00e78c23          	sb	a4,24(a5)
    800052ec:	00e78ca3          	sb	a4,25(a5)
    800052f0:	00e78d23          	sb	a4,26(a5)
    800052f4:	00e78da3          	sb	a4,27(a5)
    800052f8:	00e78e23          	sb	a4,28(a5)
    800052fc:	00e78ea3          	sb	a4,29(a5)
    80005300:	00e78f23          	sb	a4,30(a5)
    80005304:	00e78fa3          	sb	a4,31(a5)
}
    80005308:	60e2                	ld	ra,24(sp)
    8000530a:	6442                	ld	s0,16(sp)
    8000530c:	64a2                	ld	s1,8(sp)
    8000530e:	6105                	addi	sp,sp,32
    80005310:	8082                	ret
    panic("could not find virtio disk");
    80005312:	00003517          	auipc	a0,0x3
    80005316:	57e50513          	addi	a0,a0,1406 # 80008890 <syscall_names+0x350>
    8000531a:	00001097          	auipc	ra,0x1
    8000531e:	896080e7          	jalr	-1898(ra) # 80005bb0 <panic>
    panic("virtio disk has no queue 0");
    80005322:	00003517          	auipc	a0,0x3
    80005326:	58e50513          	addi	a0,a0,1422 # 800088b0 <syscall_names+0x370>
    8000532a:	00001097          	auipc	ra,0x1
    8000532e:	886080e7          	jalr	-1914(ra) # 80005bb0 <panic>
    panic("virtio disk max queue too short");
    80005332:	00003517          	auipc	a0,0x3
    80005336:	59e50513          	addi	a0,a0,1438 # 800088d0 <syscall_names+0x390>
    8000533a:	00001097          	auipc	ra,0x1
    8000533e:	876080e7          	jalr	-1930(ra) # 80005bb0 <panic>

0000000080005342 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005342:	7119                	addi	sp,sp,-128
    80005344:	fc86                	sd	ra,120(sp)
    80005346:	f8a2                	sd	s0,112(sp)
    80005348:	f4a6                	sd	s1,104(sp)
    8000534a:	f0ca                	sd	s2,96(sp)
    8000534c:	ecce                	sd	s3,88(sp)
    8000534e:	e8d2                	sd	s4,80(sp)
    80005350:	e4d6                	sd	s5,72(sp)
    80005352:	e0da                	sd	s6,64(sp)
    80005354:	fc5e                	sd	s7,56(sp)
    80005356:	f862                	sd	s8,48(sp)
    80005358:	f466                	sd	s9,40(sp)
    8000535a:	f06a                	sd	s10,32(sp)
    8000535c:	ec6e                	sd	s11,24(sp)
    8000535e:	0100                	addi	s0,sp,128
    80005360:	8aaa                	mv	s5,a0
    80005362:	8d2e                	mv	s10,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80005364:	00c52c83          	lw	s9,12(a0)
    80005368:	001c9c9b          	slliw	s9,s9,0x1
    8000536c:	1c82                	slli	s9,s9,0x20
    8000536e:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    80005372:	00018517          	auipc	a0,0x18
    80005376:	db650513          	addi	a0,a0,-586 # 8001d128 <disk+0x2128>
    8000537a:	00001097          	auipc	ra,0x1
    8000537e:	d6e080e7          	jalr	-658(ra) # 800060e8 <acquire>
  for(int i = 0; i < 3; i++){
    80005382:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80005384:	44a1                	li	s1,8
      disk.free[i] = 0;
    80005386:	00016c17          	auipc	s8,0x16
    8000538a:	c7ac0c13          	addi	s8,s8,-902 # 8001b000 <disk>
    8000538e:	6b89                	lui	s7,0x2
  for(int i = 0; i < 3; i++){
    80005390:	4b0d                	li	s6,3
    80005392:	a0ad                	j	800053fc <virtio_disk_rw+0xba>
      disk.free[i] = 0;
    80005394:	00fc0733          	add	a4,s8,a5
    80005398:	975e                	add	a4,a4,s7
    8000539a:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    8000539e:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    800053a0:	0207c563          	bltz	a5,800053ca <virtio_disk_rw+0x88>
  for(int i = 0; i < 3; i++){
    800053a4:	2905                	addiw	s2,s2,1
    800053a6:	0611                	addi	a2,a2,4 # 2004 <_entry-0x7fffdffc>
    800053a8:	19690c63          	beq	s2,s6,80005540 <virtio_disk_rw+0x1fe>
    idx[i] = alloc_desc();
    800053ac:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    800053ae:	00018717          	auipc	a4,0x18
    800053b2:	c6a70713          	addi	a4,a4,-918 # 8001d018 <disk+0x2018>
    800053b6:	87ce                	mv	a5,s3
    if(disk.free[i]){
    800053b8:	00074683          	lbu	a3,0(a4)
    800053bc:	fee1                	bnez	a3,80005394 <virtio_disk_rw+0x52>
  for(int i = 0; i < NUM; i++){
    800053be:	2785                	addiw	a5,a5,1
    800053c0:	0705                	addi	a4,a4,1
    800053c2:	fe979be3          	bne	a5,s1,800053b8 <virtio_disk_rw+0x76>
    idx[i] = alloc_desc();
    800053c6:	57fd                	li	a5,-1
    800053c8:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    800053ca:	01205d63          	blez	s2,800053e4 <virtio_disk_rw+0xa2>
    800053ce:	8dce                	mv	s11,s3
        free_desc(idx[j]);
    800053d0:	000a2503          	lw	a0,0(s4)
    800053d4:	00000097          	auipc	ra,0x0
    800053d8:	d92080e7          	jalr	-622(ra) # 80005166 <free_desc>
      for(int j = 0; j < i; j++)
    800053dc:	2d85                	addiw	s11,s11,1
    800053de:	0a11                	addi	s4,s4,4
    800053e0:	ff2d98e3          	bne	s11,s2,800053d0 <virtio_disk_rw+0x8e>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    800053e4:	00018597          	auipc	a1,0x18
    800053e8:	d4458593          	addi	a1,a1,-700 # 8001d128 <disk+0x2128>
    800053ec:	00018517          	auipc	a0,0x18
    800053f0:	c2c50513          	addi	a0,a0,-980 # 8001d018 <disk+0x2018>
    800053f4:	ffffc097          	auipc	ra,0xffffc
    800053f8:	126080e7          	jalr	294(ra) # 8000151a <sleep>
  for(int i = 0; i < 3; i++){
    800053fc:	f8040a13          	addi	s4,s0,-128
{
    80005400:	8652                	mv	a2,s4
  for(int i = 0; i < 3; i++){
    80005402:	894e                	mv	s2,s3
    80005404:	b765                	j	800053ac <virtio_disk_rw+0x6a>
  disk.desc[idx[0]].next = idx[1];

  disk.desc[idx[1]].addr = (uint64) b->data;
  disk.desc[idx[1]].len = BSIZE;
  if(write)
    disk.desc[idx[1]].flags = 0; // device reads b->data
    80005406:	00018697          	auipc	a3,0x18
    8000540a:	bfa6b683          	ld	a3,-1030(a3) # 8001d000 <disk+0x2000>
    8000540e:	96ba                	add	a3,a3,a4
    80005410:	00069623          	sh	zero,12(a3)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80005414:	00016817          	auipc	a6,0x16
    80005418:	bec80813          	addi	a6,a6,-1044 # 8001b000 <disk>
    8000541c:	00018697          	auipc	a3,0x18
    80005420:	be468693          	addi	a3,a3,-1052 # 8001d000 <disk+0x2000>
    80005424:	6290                	ld	a2,0(a3)
    80005426:	963a                	add	a2,a2,a4
    80005428:	00c65583          	lhu	a1,12(a2)
    8000542c:	0015e593          	ori	a1,a1,1
    80005430:	00b61623          	sh	a1,12(a2)
  disk.desc[idx[1]].next = idx[2];
    80005434:	f8842603          	lw	a2,-120(s0)
    80005438:	628c                	ld	a1,0(a3)
    8000543a:	972e                	add	a4,a4,a1
    8000543c:	00c71723          	sh	a2,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80005440:	20050593          	addi	a1,a0,512
    80005444:	0592                	slli	a1,a1,0x4
    80005446:	95c2                	add	a1,a1,a6
    80005448:	577d                	li	a4,-1
    8000544a:	02e58823          	sb	a4,48(a1)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    8000544e:	00461713          	slli	a4,a2,0x4
    80005452:	6290                	ld	a2,0(a3)
    80005454:	963a                	add	a2,a2,a4
    80005456:	03078793          	addi	a5,a5,48
    8000545a:	97c2                	add	a5,a5,a6
    8000545c:	e21c                	sd	a5,0(a2)
  disk.desc[idx[2]].len = 1;
    8000545e:	629c                	ld	a5,0(a3)
    80005460:	97ba                	add	a5,a5,a4
    80005462:	4605                	li	a2,1
    80005464:	c790                	sw	a2,8(a5)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80005466:	629c                	ld	a5,0(a3)
    80005468:	97ba                	add	a5,a5,a4
    8000546a:	4809                	li	a6,2
    8000546c:	01079623          	sh	a6,12(a5)
  disk.desc[idx[2]].next = 0;
    80005470:	629c                	ld	a5,0(a3)
    80005472:	97ba                	add	a5,a5,a4
    80005474:	00079723          	sh	zero,14(a5)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80005478:	00caa223          	sw	a2,4(s5)
  disk.info[idx[0]].b = b;
    8000547c:	0355b423          	sd	s5,40(a1)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80005480:	6698                	ld	a4,8(a3)
    80005482:	00275783          	lhu	a5,2(a4)
    80005486:	8b9d                	andi	a5,a5,7
    80005488:	0786                	slli	a5,a5,0x1
    8000548a:	973e                	add	a4,a4,a5
    8000548c:	00a71223          	sh	a0,4(a4)

  __sync_synchronize();
    80005490:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80005494:	6698                	ld	a4,8(a3)
    80005496:	00275783          	lhu	a5,2(a4)
    8000549a:	2785                	addiw	a5,a5,1
    8000549c:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    800054a0:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    800054a4:	100017b7          	lui	a5,0x10001
    800054a8:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    800054ac:	004aa783          	lw	a5,4(s5)
    800054b0:	02c79163          	bne	a5,a2,800054d2 <virtio_disk_rw+0x190>
    sleep(b, &disk.vdisk_lock);
    800054b4:	00018917          	auipc	s2,0x18
    800054b8:	c7490913          	addi	s2,s2,-908 # 8001d128 <disk+0x2128>
  while(b->disk == 1) {
    800054bc:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    800054be:	85ca                	mv	a1,s2
    800054c0:	8556                	mv	a0,s5
    800054c2:	ffffc097          	auipc	ra,0xffffc
    800054c6:	058080e7          	jalr	88(ra) # 8000151a <sleep>
  while(b->disk == 1) {
    800054ca:	004aa783          	lw	a5,4(s5)
    800054ce:	fe9788e3          	beq	a5,s1,800054be <virtio_disk_rw+0x17c>
  }

  disk.info[idx[0]].b = 0;
    800054d2:	f8042903          	lw	s2,-128(s0)
    800054d6:	20090713          	addi	a4,s2,512
    800054da:	0712                	slli	a4,a4,0x4
    800054dc:	00016797          	auipc	a5,0x16
    800054e0:	b2478793          	addi	a5,a5,-1244 # 8001b000 <disk>
    800054e4:	97ba                	add	a5,a5,a4
    800054e6:	0207b423          	sd	zero,40(a5)
    int flag = disk.desc[i].flags;
    800054ea:	00018997          	auipc	s3,0x18
    800054ee:	b1698993          	addi	s3,s3,-1258 # 8001d000 <disk+0x2000>
    800054f2:	00491713          	slli	a4,s2,0x4
    800054f6:	0009b783          	ld	a5,0(s3)
    800054fa:	97ba                	add	a5,a5,a4
    800054fc:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80005500:	854a                	mv	a0,s2
    80005502:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80005506:	00000097          	auipc	ra,0x0
    8000550a:	c60080e7          	jalr	-928(ra) # 80005166 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    8000550e:	8885                	andi	s1,s1,1
    80005510:	f0ed                	bnez	s1,800054f2 <virtio_disk_rw+0x1b0>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80005512:	00018517          	auipc	a0,0x18
    80005516:	c1650513          	addi	a0,a0,-1002 # 8001d128 <disk+0x2128>
    8000551a:	00001097          	auipc	ra,0x1
    8000551e:	c82080e7          	jalr	-894(ra) # 8000619c <release>
}
    80005522:	70e6                	ld	ra,120(sp)
    80005524:	7446                	ld	s0,112(sp)
    80005526:	74a6                	ld	s1,104(sp)
    80005528:	7906                	ld	s2,96(sp)
    8000552a:	69e6                	ld	s3,88(sp)
    8000552c:	6a46                	ld	s4,80(sp)
    8000552e:	6aa6                	ld	s5,72(sp)
    80005530:	6b06                	ld	s6,64(sp)
    80005532:	7be2                	ld	s7,56(sp)
    80005534:	7c42                	ld	s8,48(sp)
    80005536:	7ca2                	ld	s9,40(sp)
    80005538:	7d02                	ld	s10,32(sp)
    8000553a:	6de2                	ld	s11,24(sp)
    8000553c:	6109                	addi	sp,sp,128
    8000553e:	8082                	ret
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005540:	f8042503          	lw	a0,-128(s0)
    80005544:	20050793          	addi	a5,a0,512
    80005548:	0792                	slli	a5,a5,0x4
  if(write)
    8000554a:	00016817          	auipc	a6,0x16
    8000554e:	ab680813          	addi	a6,a6,-1354 # 8001b000 <disk>
    80005552:	00f80733          	add	a4,a6,a5
    80005556:	01a036b3          	snez	a3,s10
    8000555a:	0ad72423          	sw	a3,168(a4)
  buf0->reserved = 0;
    8000555e:	0a072623          	sw	zero,172(a4)
  buf0->sector = sector;
    80005562:	0b973823          	sd	s9,176(a4)
  disk.desc[idx[0]].addr = (uint64) buf0;
    80005566:	7679                	lui	a2,0xffffe
    80005568:	963e                	add	a2,a2,a5
    8000556a:	00018697          	auipc	a3,0x18
    8000556e:	a9668693          	addi	a3,a3,-1386 # 8001d000 <disk+0x2000>
    80005572:	6298                	ld	a4,0(a3)
    80005574:	9732                	add	a4,a4,a2
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005576:	0a878593          	addi	a1,a5,168
    8000557a:	95c2                	add	a1,a1,a6
  disk.desc[idx[0]].addr = (uint64) buf0;
    8000557c:	e30c                	sd	a1,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    8000557e:	6298                	ld	a4,0(a3)
    80005580:	9732                	add	a4,a4,a2
    80005582:	45c1                	li	a1,16
    80005584:	c70c                	sw	a1,8(a4)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80005586:	6298                	ld	a4,0(a3)
    80005588:	9732                	add	a4,a4,a2
    8000558a:	4585                	li	a1,1
    8000558c:	00b71623          	sh	a1,12(a4)
  disk.desc[idx[0]].next = idx[1];
    80005590:	f8442703          	lw	a4,-124(s0)
    80005594:	628c                	ld	a1,0(a3)
    80005596:	962e                	add	a2,a2,a1
    80005598:	00e61723          	sh	a4,14(a2) # ffffffffffffe00e <end+0xffffffff7ffd7dce>
  disk.desc[idx[1]].addr = (uint64) b->data;
    8000559c:	0712                	slli	a4,a4,0x4
    8000559e:	6290                	ld	a2,0(a3)
    800055a0:	963a                	add	a2,a2,a4
    800055a2:	058a8593          	addi	a1,s5,88
    800055a6:	e20c                	sd	a1,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    800055a8:	6294                	ld	a3,0(a3)
    800055aa:	96ba                	add	a3,a3,a4
    800055ac:	40000613          	li	a2,1024
    800055b0:	c690                	sw	a2,8(a3)
  if(write)
    800055b2:	e40d1ae3          	bnez	s10,80005406 <virtio_disk_rw+0xc4>
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    800055b6:	00018697          	auipc	a3,0x18
    800055ba:	a4a6b683          	ld	a3,-1462(a3) # 8001d000 <disk+0x2000>
    800055be:	96ba                	add	a3,a3,a4
    800055c0:	4609                	li	a2,2
    800055c2:	00c69623          	sh	a2,12(a3)
    800055c6:	b5b9                	j	80005414 <virtio_disk_rw+0xd2>

00000000800055c8 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    800055c8:	1101                	addi	sp,sp,-32
    800055ca:	ec06                	sd	ra,24(sp)
    800055cc:	e822                	sd	s0,16(sp)
    800055ce:	e426                	sd	s1,8(sp)
    800055d0:	e04a                	sd	s2,0(sp)
    800055d2:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    800055d4:	00018517          	auipc	a0,0x18
    800055d8:	b5450513          	addi	a0,a0,-1196 # 8001d128 <disk+0x2128>
    800055dc:	00001097          	auipc	ra,0x1
    800055e0:	b0c080e7          	jalr	-1268(ra) # 800060e8 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    800055e4:	10001737          	lui	a4,0x10001
    800055e8:	533c                	lw	a5,96(a4)
    800055ea:	8b8d                	andi	a5,a5,3
    800055ec:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    800055ee:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    800055f2:	00018797          	auipc	a5,0x18
    800055f6:	a0e78793          	addi	a5,a5,-1522 # 8001d000 <disk+0x2000>
    800055fa:	6b94                	ld	a3,16(a5)
    800055fc:	0207d703          	lhu	a4,32(a5)
    80005600:	0026d783          	lhu	a5,2(a3)
    80005604:	06f70163          	beq	a4,a5,80005666 <virtio_disk_intr+0x9e>
    __sync_synchronize();
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005608:	00016917          	auipc	s2,0x16
    8000560c:	9f890913          	addi	s2,s2,-1544 # 8001b000 <disk>
    80005610:	00018497          	auipc	s1,0x18
    80005614:	9f048493          	addi	s1,s1,-1552 # 8001d000 <disk+0x2000>
    __sync_synchronize();
    80005618:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    8000561c:	6898                	ld	a4,16(s1)
    8000561e:	0204d783          	lhu	a5,32(s1)
    80005622:	8b9d                	andi	a5,a5,7
    80005624:	078e                	slli	a5,a5,0x3
    80005626:	97ba                	add	a5,a5,a4
    80005628:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    8000562a:	20078713          	addi	a4,a5,512
    8000562e:	0712                	slli	a4,a4,0x4
    80005630:	974a                	add	a4,a4,s2
    80005632:	03074703          	lbu	a4,48(a4) # 10001030 <_entry-0x6fffefd0>
    80005636:	e731                	bnez	a4,80005682 <virtio_disk_intr+0xba>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80005638:	20078793          	addi	a5,a5,512
    8000563c:	0792                	slli	a5,a5,0x4
    8000563e:	97ca                	add	a5,a5,s2
    80005640:	7788                	ld	a0,40(a5)
    b->disk = 0;   // disk is done with buf
    80005642:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80005646:	ffffc097          	auipc	ra,0xffffc
    8000564a:	060080e7          	jalr	96(ra) # 800016a6 <wakeup>

    disk.used_idx += 1;
    8000564e:	0204d783          	lhu	a5,32(s1)
    80005652:	2785                	addiw	a5,a5,1
    80005654:	17c2                	slli	a5,a5,0x30
    80005656:	93c1                	srli	a5,a5,0x30
    80005658:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    8000565c:	6898                	ld	a4,16(s1)
    8000565e:	00275703          	lhu	a4,2(a4)
    80005662:	faf71be3          	bne	a4,a5,80005618 <virtio_disk_intr+0x50>
  }

  release(&disk.vdisk_lock);
    80005666:	00018517          	auipc	a0,0x18
    8000566a:	ac250513          	addi	a0,a0,-1342 # 8001d128 <disk+0x2128>
    8000566e:	00001097          	auipc	ra,0x1
    80005672:	b2e080e7          	jalr	-1234(ra) # 8000619c <release>
}
    80005676:	60e2                	ld	ra,24(sp)
    80005678:	6442                	ld	s0,16(sp)
    8000567a:	64a2                	ld	s1,8(sp)
    8000567c:	6902                	ld	s2,0(sp)
    8000567e:	6105                	addi	sp,sp,32
    80005680:	8082                	ret
      panic("virtio_disk_intr status");
    80005682:	00003517          	auipc	a0,0x3
    80005686:	26e50513          	addi	a0,a0,622 # 800088f0 <syscall_names+0x3b0>
    8000568a:	00000097          	auipc	ra,0x0
    8000568e:	526080e7          	jalr	1318(ra) # 80005bb0 <panic>

0000000080005692 <timerinit>:
// which arrive at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    80005692:	1141                	addi	sp,sp,-16
    80005694:	e422                	sd	s0,8(sp)
    80005696:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005698:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    8000569c:	0007859b          	sext.w	a1,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    800056a0:	0037979b          	slliw	a5,a5,0x3
    800056a4:	02004737          	lui	a4,0x2004
    800056a8:	97ba                	add	a5,a5,a4
    800056aa:	0200c737          	lui	a4,0x200c
    800056ae:	ff873703          	ld	a4,-8(a4) # 200bff8 <_entry-0x7dff4008>
    800056b2:	000f4637          	lui	a2,0xf4
    800056b6:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    800056ba:	9732                	add	a4,a4,a2
    800056bc:	e398                	sd	a4,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    800056be:	00259693          	slli	a3,a1,0x2
    800056c2:	96ae                	add	a3,a3,a1
    800056c4:	068e                	slli	a3,a3,0x3
    800056c6:	00019717          	auipc	a4,0x19
    800056ca:	93a70713          	addi	a4,a4,-1734 # 8001e000 <timer_scratch>
    800056ce:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    800056d0:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    800056d2:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    800056d4:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    800056d8:	00000797          	auipc	a5,0x0
    800056dc:	9c878793          	addi	a5,a5,-1592 # 800050a0 <timervec>
    800056e0:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    800056e4:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    800056e8:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800056ec:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    800056f0:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    800056f4:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    800056f8:	30479073          	csrw	mie,a5
}
    800056fc:	6422                	ld	s0,8(sp)
    800056fe:	0141                	addi	sp,sp,16
    80005700:	8082                	ret

0000000080005702 <start>:
{
    80005702:	1141                	addi	sp,sp,-16
    80005704:	e406                	sd	ra,8(sp)
    80005706:	e022                	sd	s0,0(sp)
    80005708:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    8000570a:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    8000570e:	7779                	lui	a4,0xffffe
    80005710:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffd85bf>
    80005714:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80005716:	6705                	lui	a4,0x1
    80005718:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    8000571c:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    8000571e:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80005722:	ffffb797          	auipc	a5,0xffffb
    80005726:	bfe78793          	addi	a5,a5,-1026 # 80000320 <main>
    8000572a:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    8000572e:	4781                	li	a5,0
    80005730:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80005734:	67c1                	lui	a5,0x10
    80005736:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    80005738:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    8000573c:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    80005740:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    80005744:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    80005748:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    8000574c:	57fd                	li	a5,-1
    8000574e:	83a9                	srli	a5,a5,0xa
    80005750:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    80005754:	47bd                	li	a5,15
    80005756:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    8000575a:	00000097          	auipc	ra,0x0
    8000575e:	f38080e7          	jalr	-200(ra) # 80005692 <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005762:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    80005766:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    80005768:	823e                	mv	tp,a5
  asm volatile("mret");
    8000576a:	30200073          	mret
}
    8000576e:	60a2                	ld	ra,8(sp)
    80005770:	6402                	ld	s0,0(sp)
    80005772:	0141                	addi	sp,sp,16
    80005774:	8082                	ret

0000000080005776 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80005776:	715d                	addi	sp,sp,-80
    80005778:	e486                	sd	ra,72(sp)
    8000577a:	e0a2                	sd	s0,64(sp)
    8000577c:	fc26                	sd	s1,56(sp)
    8000577e:	f84a                	sd	s2,48(sp)
    80005780:	f44e                	sd	s3,40(sp)
    80005782:	f052                	sd	s4,32(sp)
    80005784:	ec56                	sd	s5,24(sp)
    80005786:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    80005788:	04c05763          	blez	a2,800057d6 <consolewrite+0x60>
    8000578c:	8a2a                	mv	s4,a0
    8000578e:	84ae                	mv	s1,a1
    80005790:	89b2                	mv	s3,a2
    80005792:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    80005794:	5afd                	li	s5,-1
    80005796:	4685                	li	a3,1
    80005798:	8626                	mv	a2,s1
    8000579a:	85d2                	mv	a1,s4
    8000579c:	fbf40513          	addi	a0,s0,-65
    800057a0:	ffffc097          	auipc	ra,0xffffc
    800057a4:	174080e7          	jalr	372(ra) # 80001914 <either_copyin>
    800057a8:	01550d63          	beq	a0,s5,800057c2 <consolewrite+0x4c>
      break;
    uartputc(c);
    800057ac:	fbf44503          	lbu	a0,-65(s0)
    800057b0:	00000097          	auipc	ra,0x0
    800057b4:	77e080e7          	jalr	1918(ra) # 80005f2e <uartputc>
  for(i = 0; i < n; i++){
    800057b8:	2905                	addiw	s2,s2,1
    800057ba:	0485                	addi	s1,s1,1
    800057bc:	fd299de3          	bne	s3,s2,80005796 <consolewrite+0x20>
    800057c0:	894e                	mv	s2,s3
  }

  return i;
}
    800057c2:	854a                	mv	a0,s2
    800057c4:	60a6                	ld	ra,72(sp)
    800057c6:	6406                	ld	s0,64(sp)
    800057c8:	74e2                	ld	s1,56(sp)
    800057ca:	7942                	ld	s2,48(sp)
    800057cc:	79a2                	ld	s3,40(sp)
    800057ce:	7a02                	ld	s4,32(sp)
    800057d0:	6ae2                	ld	s5,24(sp)
    800057d2:	6161                	addi	sp,sp,80
    800057d4:	8082                	ret
  for(i = 0; i < n; i++){
    800057d6:	4901                	li	s2,0
    800057d8:	b7ed                	j	800057c2 <consolewrite+0x4c>

00000000800057da <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    800057da:	7159                	addi	sp,sp,-112
    800057dc:	f486                	sd	ra,104(sp)
    800057de:	f0a2                	sd	s0,96(sp)
    800057e0:	eca6                	sd	s1,88(sp)
    800057e2:	e8ca                	sd	s2,80(sp)
    800057e4:	e4ce                	sd	s3,72(sp)
    800057e6:	e0d2                	sd	s4,64(sp)
    800057e8:	fc56                	sd	s5,56(sp)
    800057ea:	f85a                	sd	s6,48(sp)
    800057ec:	f45e                	sd	s7,40(sp)
    800057ee:	f062                	sd	s8,32(sp)
    800057f0:	ec66                	sd	s9,24(sp)
    800057f2:	e86a                	sd	s10,16(sp)
    800057f4:	1880                	addi	s0,sp,112
    800057f6:	8aaa                	mv	s5,a0
    800057f8:	8a2e                	mv	s4,a1
    800057fa:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    800057fc:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    80005800:	00021517          	auipc	a0,0x21
    80005804:	94050513          	addi	a0,a0,-1728 # 80026140 <cons>
    80005808:	00001097          	auipc	ra,0x1
    8000580c:	8e0080e7          	jalr	-1824(ra) # 800060e8 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80005810:	00021497          	auipc	s1,0x21
    80005814:	93048493          	addi	s1,s1,-1744 # 80026140 <cons>
      if(myproc()->killed){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80005818:	00021917          	auipc	s2,0x21
    8000581c:	9c090913          	addi	s2,s2,-1600 # 800261d8 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF];

    if(c == C('D')){  // end-of-file
    80005820:	4b91                	li	s7,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005822:	5c7d                	li	s8,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    80005824:	4ca9                	li	s9,10
  while(n > 0){
    80005826:	07305863          	blez	s3,80005896 <consoleread+0xbc>
    while(cons.r == cons.w){
    8000582a:	0984a783          	lw	a5,152(s1)
    8000582e:	09c4a703          	lw	a4,156(s1)
    80005832:	02f71463          	bne	a4,a5,8000585a <consoleread+0x80>
      if(myproc()->killed){
    80005836:	ffffb097          	auipc	ra,0xffffb
    8000583a:	60e080e7          	jalr	1550(ra) # 80000e44 <myproc>
    8000583e:	551c                	lw	a5,40(a0)
    80005840:	e7b5                	bnez	a5,800058ac <consoleread+0xd2>
      sleep(&cons.r, &cons.lock);
    80005842:	85a6                	mv	a1,s1
    80005844:	854a                	mv	a0,s2
    80005846:	ffffc097          	auipc	ra,0xffffc
    8000584a:	cd4080e7          	jalr	-812(ra) # 8000151a <sleep>
    while(cons.r == cons.w){
    8000584e:	0984a783          	lw	a5,152(s1)
    80005852:	09c4a703          	lw	a4,156(s1)
    80005856:	fef700e3          	beq	a4,a5,80005836 <consoleread+0x5c>
    c = cons.buf[cons.r++ % INPUT_BUF];
    8000585a:	0017871b          	addiw	a4,a5,1
    8000585e:	08e4ac23          	sw	a4,152(s1)
    80005862:	07f7f713          	andi	a4,a5,127
    80005866:	9726                	add	a4,a4,s1
    80005868:	01874703          	lbu	a4,24(a4)
    8000586c:	00070d1b          	sext.w	s10,a4
    if(c == C('D')){  // end-of-file
    80005870:	077d0563          	beq	s10,s7,800058da <consoleread+0x100>
    cbuf = c;
    80005874:	f8e40fa3          	sb	a4,-97(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005878:	4685                	li	a3,1
    8000587a:	f9f40613          	addi	a2,s0,-97
    8000587e:	85d2                	mv	a1,s4
    80005880:	8556                	mv	a0,s5
    80005882:	ffffc097          	auipc	ra,0xffffc
    80005886:	03c080e7          	jalr	60(ra) # 800018be <either_copyout>
    8000588a:	01850663          	beq	a0,s8,80005896 <consoleread+0xbc>
    dst++;
    8000588e:	0a05                	addi	s4,s4,1
    --n;
    80005890:	39fd                	addiw	s3,s3,-1
    if(c == '\n'){
    80005892:	f99d1ae3          	bne	s10,s9,80005826 <consoleread+0x4c>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    80005896:	00021517          	auipc	a0,0x21
    8000589a:	8aa50513          	addi	a0,a0,-1878 # 80026140 <cons>
    8000589e:	00001097          	auipc	ra,0x1
    800058a2:	8fe080e7          	jalr	-1794(ra) # 8000619c <release>

  return target - n;
    800058a6:	413b053b          	subw	a0,s6,s3
    800058aa:	a811                	j	800058be <consoleread+0xe4>
        release(&cons.lock);
    800058ac:	00021517          	auipc	a0,0x21
    800058b0:	89450513          	addi	a0,a0,-1900 # 80026140 <cons>
    800058b4:	00001097          	auipc	ra,0x1
    800058b8:	8e8080e7          	jalr	-1816(ra) # 8000619c <release>
        return -1;
    800058bc:	557d                	li	a0,-1
}
    800058be:	70a6                	ld	ra,104(sp)
    800058c0:	7406                	ld	s0,96(sp)
    800058c2:	64e6                	ld	s1,88(sp)
    800058c4:	6946                	ld	s2,80(sp)
    800058c6:	69a6                	ld	s3,72(sp)
    800058c8:	6a06                	ld	s4,64(sp)
    800058ca:	7ae2                	ld	s5,56(sp)
    800058cc:	7b42                	ld	s6,48(sp)
    800058ce:	7ba2                	ld	s7,40(sp)
    800058d0:	7c02                	ld	s8,32(sp)
    800058d2:	6ce2                	ld	s9,24(sp)
    800058d4:	6d42                	ld	s10,16(sp)
    800058d6:	6165                	addi	sp,sp,112
    800058d8:	8082                	ret
      if(n < target){
    800058da:	0009871b          	sext.w	a4,s3
    800058de:	fb677ce3          	bgeu	a4,s6,80005896 <consoleread+0xbc>
        cons.r--;
    800058e2:	00021717          	auipc	a4,0x21
    800058e6:	8ef72b23          	sw	a5,-1802(a4) # 800261d8 <cons+0x98>
    800058ea:	b775                	j	80005896 <consoleread+0xbc>

00000000800058ec <consputc>:
{
    800058ec:	1141                	addi	sp,sp,-16
    800058ee:	e406                	sd	ra,8(sp)
    800058f0:	e022                	sd	s0,0(sp)
    800058f2:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    800058f4:	10000793          	li	a5,256
    800058f8:	00f50a63          	beq	a0,a5,8000590c <consputc+0x20>
    uartputc_sync(c);
    800058fc:	00000097          	auipc	ra,0x0
    80005900:	560080e7          	jalr	1376(ra) # 80005e5c <uartputc_sync>
}
    80005904:	60a2                	ld	ra,8(sp)
    80005906:	6402                	ld	s0,0(sp)
    80005908:	0141                	addi	sp,sp,16
    8000590a:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    8000590c:	4521                	li	a0,8
    8000590e:	00000097          	auipc	ra,0x0
    80005912:	54e080e7          	jalr	1358(ra) # 80005e5c <uartputc_sync>
    80005916:	02000513          	li	a0,32
    8000591a:	00000097          	auipc	ra,0x0
    8000591e:	542080e7          	jalr	1346(ra) # 80005e5c <uartputc_sync>
    80005922:	4521                	li	a0,8
    80005924:	00000097          	auipc	ra,0x0
    80005928:	538080e7          	jalr	1336(ra) # 80005e5c <uartputc_sync>
    8000592c:	bfe1                	j	80005904 <consputc+0x18>

000000008000592e <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    8000592e:	1101                	addi	sp,sp,-32
    80005930:	ec06                	sd	ra,24(sp)
    80005932:	e822                	sd	s0,16(sp)
    80005934:	e426                	sd	s1,8(sp)
    80005936:	e04a                	sd	s2,0(sp)
    80005938:	1000                	addi	s0,sp,32
    8000593a:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    8000593c:	00021517          	auipc	a0,0x21
    80005940:	80450513          	addi	a0,a0,-2044 # 80026140 <cons>
    80005944:	00000097          	auipc	ra,0x0
    80005948:	7a4080e7          	jalr	1956(ra) # 800060e8 <acquire>

  switch(c){
    8000594c:	47d5                	li	a5,21
    8000594e:	0af48663          	beq	s1,a5,800059fa <consoleintr+0xcc>
    80005952:	0297ca63          	blt	a5,s1,80005986 <consoleintr+0x58>
    80005956:	47a1                	li	a5,8
    80005958:	0ef48763          	beq	s1,a5,80005a46 <consoleintr+0x118>
    8000595c:	47c1                	li	a5,16
    8000595e:	10f49a63          	bne	s1,a5,80005a72 <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    80005962:	ffffc097          	auipc	ra,0xffffc
    80005966:	008080e7          	jalr	8(ra) # 8000196a <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    8000596a:	00020517          	auipc	a0,0x20
    8000596e:	7d650513          	addi	a0,a0,2006 # 80026140 <cons>
    80005972:	00001097          	auipc	ra,0x1
    80005976:	82a080e7          	jalr	-2006(ra) # 8000619c <release>
}
    8000597a:	60e2                	ld	ra,24(sp)
    8000597c:	6442                	ld	s0,16(sp)
    8000597e:	64a2                	ld	s1,8(sp)
    80005980:	6902                	ld	s2,0(sp)
    80005982:	6105                	addi	sp,sp,32
    80005984:	8082                	ret
  switch(c){
    80005986:	07f00793          	li	a5,127
    8000598a:	0af48e63          	beq	s1,a5,80005a46 <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    8000598e:	00020717          	auipc	a4,0x20
    80005992:	7b270713          	addi	a4,a4,1970 # 80026140 <cons>
    80005996:	0a072783          	lw	a5,160(a4)
    8000599a:	09872703          	lw	a4,152(a4)
    8000599e:	9f99                	subw	a5,a5,a4
    800059a0:	07f00713          	li	a4,127
    800059a4:	fcf763e3          	bltu	a4,a5,8000596a <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    800059a8:	47b5                	li	a5,13
    800059aa:	0cf48763          	beq	s1,a5,80005a78 <consoleintr+0x14a>
      consputc(c);
    800059ae:	8526                	mv	a0,s1
    800059b0:	00000097          	auipc	ra,0x0
    800059b4:	f3c080e7          	jalr	-196(ra) # 800058ec <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    800059b8:	00020797          	auipc	a5,0x20
    800059bc:	78878793          	addi	a5,a5,1928 # 80026140 <cons>
    800059c0:	0a07a703          	lw	a4,160(a5)
    800059c4:	0017069b          	addiw	a3,a4,1
    800059c8:	0006861b          	sext.w	a2,a3
    800059cc:	0ad7a023          	sw	a3,160(a5)
    800059d0:	07f77713          	andi	a4,a4,127
    800059d4:	97ba                	add	a5,a5,a4
    800059d6:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e == cons.r+INPUT_BUF){
    800059da:	47a9                	li	a5,10
    800059dc:	0cf48563          	beq	s1,a5,80005aa6 <consoleintr+0x178>
    800059e0:	4791                	li	a5,4
    800059e2:	0cf48263          	beq	s1,a5,80005aa6 <consoleintr+0x178>
    800059e6:	00020797          	auipc	a5,0x20
    800059ea:	7f27a783          	lw	a5,2034(a5) # 800261d8 <cons+0x98>
    800059ee:	0807879b          	addiw	a5,a5,128
    800059f2:	f6f61ce3          	bne	a2,a5,8000596a <consoleintr+0x3c>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    800059f6:	863e                	mv	a2,a5
    800059f8:	a07d                	j	80005aa6 <consoleintr+0x178>
    while(cons.e != cons.w &&
    800059fa:	00020717          	auipc	a4,0x20
    800059fe:	74670713          	addi	a4,a4,1862 # 80026140 <cons>
    80005a02:	0a072783          	lw	a5,160(a4)
    80005a06:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005a0a:	00020497          	auipc	s1,0x20
    80005a0e:	73648493          	addi	s1,s1,1846 # 80026140 <cons>
    while(cons.e != cons.w &&
    80005a12:	4929                	li	s2,10
    80005a14:	f4f70be3          	beq	a4,a5,8000596a <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005a18:	37fd                	addiw	a5,a5,-1
    80005a1a:	07f7f713          	andi	a4,a5,127
    80005a1e:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005a20:	01874703          	lbu	a4,24(a4)
    80005a24:	f52703e3          	beq	a4,s2,8000596a <consoleintr+0x3c>
      cons.e--;
    80005a28:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005a2c:	10000513          	li	a0,256
    80005a30:	00000097          	auipc	ra,0x0
    80005a34:	ebc080e7          	jalr	-324(ra) # 800058ec <consputc>
    while(cons.e != cons.w &&
    80005a38:	0a04a783          	lw	a5,160(s1)
    80005a3c:	09c4a703          	lw	a4,156(s1)
    80005a40:	fcf71ce3          	bne	a4,a5,80005a18 <consoleintr+0xea>
    80005a44:	b71d                	j	8000596a <consoleintr+0x3c>
    if(cons.e != cons.w){
    80005a46:	00020717          	auipc	a4,0x20
    80005a4a:	6fa70713          	addi	a4,a4,1786 # 80026140 <cons>
    80005a4e:	0a072783          	lw	a5,160(a4)
    80005a52:	09c72703          	lw	a4,156(a4)
    80005a56:	f0f70ae3          	beq	a4,a5,8000596a <consoleintr+0x3c>
      cons.e--;
    80005a5a:	37fd                	addiw	a5,a5,-1
    80005a5c:	00020717          	auipc	a4,0x20
    80005a60:	78f72223          	sw	a5,1924(a4) # 800261e0 <cons+0xa0>
      consputc(BACKSPACE);
    80005a64:	10000513          	li	a0,256
    80005a68:	00000097          	auipc	ra,0x0
    80005a6c:	e84080e7          	jalr	-380(ra) # 800058ec <consputc>
    80005a70:	bded                	j	8000596a <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005a72:	ee048ce3          	beqz	s1,8000596a <consoleintr+0x3c>
    80005a76:	bf21                	j	8000598e <consoleintr+0x60>
      consputc(c);
    80005a78:	4529                	li	a0,10
    80005a7a:	00000097          	auipc	ra,0x0
    80005a7e:	e72080e7          	jalr	-398(ra) # 800058ec <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005a82:	00020797          	auipc	a5,0x20
    80005a86:	6be78793          	addi	a5,a5,1726 # 80026140 <cons>
    80005a8a:	0a07a703          	lw	a4,160(a5)
    80005a8e:	0017069b          	addiw	a3,a4,1
    80005a92:	0006861b          	sext.w	a2,a3
    80005a96:	0ad7a023          	sw	a3,160(a5)
    80005a9a:	07f77713          	andi	a4,a4,127
    80005a9e:	97ba                	add	a5,a5,a4
    80005aa0:	4729                	li	a4,10
    80005aa2:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005aa6:	00020797          	auipc	a5,0x20
    80005aaa:	72c7ab23          	sw	a2,1846(a5) # 800261dc <cons+0x9c>
        wakeup(&cons.r);
    80005aae:	00020517          	auipc	a0,0x20
    80005ab2:	72a50513          	addi	a0,a0,1834 # 800261d8 <cons+0x98>
    80005ab6:	ffffc097          	auipc	ra,0xffffc
    80005aba:	bf0080e7          	jalr	-1040(ra) # 800016a6 <wakeup>
    80005abe:	b575                	j	8000596a <consoleintr+0x3c>

0000000080005ac0 <consoleinit>:

void
consoleinit(void)
{
    80005ac0:	1141                	addi	sp,sp,-16
    80005ac2:	e406                	sd	ra,8(sp)
    80005ac4:	e022                	sd	s0,0(sp)
    80005ac6:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005ac8:	00003597          	auipc	a1,0x3
    80005acc:	e4058593          	addi	a1,a1,-448 # 80008908 <syscall_names+0x3c8>
    80005ad0:	00020517          	auipc	a0,0x20
    80005ad4:	67050513          	addi	a0,a0,1648 # 80026140 <cons>
    80005ad8:	00000097          	auipc	ra,0x0
    80005adc:	580080e7          	jalr	1408(ra) # 80006058 <initlock>

  uartinit();
    80005ae0:	00000097          	auipc	ra,0x0
    80005ae4:	32c080e7          	jalr	812(ra) # 80005e0c <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005ae8:	00014797          	auipc	a5,0x14
    80005aec:	be078793          	addi	a5,a5,-1056 # 800196c8 <devsw>
    80005af0:	00000717          	auipc	a4,0x0
    80005af4:	cea70713          	addi	a4,a4,-790 # 800057da <consoleread>
    80005af8:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005afa:	00000717          	auipc	a4,0x0
    80005afe:	c7c70713          	addi	a4,a4,-900 # 80005776 <consolewrite>
    80005b02:	ef98                	sd	a4,24(a5)
}
    80005b04:	60a2                	ld	ra,8(sp)
    80005b06:	6402                	ld	s0,0(sp)
    80005b08:	0141                	addi	sp,sp,16
    80005b0a:	8082                	ret

0000000080005b0c <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80005b0c:	7179                	addi	sp,sp,-48
    80005b0e:	f406                	sd	ra,40(sp)
    80005b10:	f022                	sd	s0,32(sp)
    80005b12:	ec26                	sd	s1,24(sp)
    80005b14:	e84a                	sd	s2,16(sp)
    80005b16:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80005b18:	c219                	beqz	a2,80005b1e <printint+0x12>
    80005b1a:	08054763          	bltz	a0,80005ba8 <printint+0x9c>
    x = -xx;
  else
    x = xx;
    80005b1e:	2501                	sext.w	a0,a0
    80005b20:	4881                	li	a7,0
    80005b22:	fd040693          	addi	a3,s0,-48

  i = 0;
    80005b26:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005b28:	2581                	sext.w	a1,a1
    80005b2a:	00003617          	auipc	a2,0x3
    80005b2e:	e0e60613          	addi	a2,a2,-498 # 80008938 <digits>
    80005b32:	883a                	mv	a6,a4
    80005b34:	2705                	addiw	a4,a4,1
    80005b36:	02b577bb          	remuw	a5,a0,a1
    80005b3a:	1782                	slli	a5,a5,0x20
    80005b3c:	9381                	srli	a5,a5,0x20
    80005b3e:	97b2                	add	a5,a5,a2
    80005b40:	0007c783          	lbu	a5,0(a5)
    80005b44:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80005b48:	0005079b          	sext.w	a5,a0
    80005b4c:	02b5553b          	divuw	a0,a0,a1
    80005b50:	0685                	addi	a3,a3,1
    80005b52:	feb7f0e3          	bgeu	a5,a1,80005b32 <printint+0x26>

  if(sign)
    80005b56:	00088c63          	beqz	a7,80005b6e <printint+0x62>
    buf[i++] = '-';
    80005b5a:	fe070793          	addi	a5,a4,-32
    80005b5e:	00878733          	add	a4,a5,s0
    80005b62:	02d00793          	li	a5,45
    80005b66:	fef70823          	sb	a5,-16(a4)
    80005b6a:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80005b6e:	02e05763          	blez	a4,80005b9c <printint+0x90>
    80005b72:	fd040793          	addi	a5,s0,-48
    80005b76:	00e784b3          	add	s1,a5,a4
    80005b7a:	fff78913          	addi	s2,a5,-1
    80005b7e:	993a                	add	s2,s2,a4
    80005b80:	377d                	addiw	a4,a4,-1
    80005b82:	1702                	slli	a4,a4,0x20
    80005b84:	9301                	srli	a4,a4,0x20
    80005b86:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80005b8a:	fff4c503          	lbu	a0,-1(s1)
    80005b8e:	00000097          	auipc	ra,0x0
    80005b92:	d5e080e7          	jalr	-674(ra) # 800058ec <consputc>
  while(--i >= 0)
    80005b96:	14fd                	addi	s1,s1,-1
    80005b98:	ff2499e3          	bne	s1,s2,80005b8a <printint+0x7e>
}
    80005b9c:	70a2                	ld	ra,40(sp)
    80005b9e:	7402                	ld	s0,32(sp)
    80005ba0:	64e2                	ld	s1,24(sp)
    80005ba2:	6942                	ld	s2,16(sp)
    80005ba4:	6145                	addi	sp,sp,48
    80005ba6:	8082                	ret
    x = -xx;
    80005ba8:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80005bac:	4885                	li	a7,1
    x = -xx;
    80005bae:	bf95                	j	80005b22 <printint+0x16>

0000000080005bb0 <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80005bb0:	1101                	addi	sp,sp,-32
    80005bb2:	ec06                	sd	ra,24(sp)
    80005bb4:	e822                	sd	s0,16(sp)
    80005bb6:	e426                	sd	s1,8(sp)
    80005bb8:	1000                	addi	s0,sp,32
    80005bba:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005bbc:	00020797          	auipc	a5,0x20
    80005bc0:	6407a223          	sw	zero,1604(a5) # 80026200 <pr+0x18>
  printf("panic: ");
    80005bc4:	00003517          	auipc	a0,0x3
    80005bc8:	d4c50513          	addi	a0,a0,-692 # 80008910 <syscall_names+0x3d0>
    80005bcc:	00000097          	auipc	ra,0x0
    80005bd0:	02e080e7          	jalr	46(ra) # 80005bfa <printf>
  printf(s);
    80005bd4:	8526                	mv	a0,s1
    80005bd6:	00000097          	auipc	ra,0x0
    80005bda:	024080e7          	jalr	36(ra) # 80005bfa <printf>
  printf("\n");
    80005bde:	00002517          	auipc	a0,0x2
    80005be2:	46a50513          	addi	a0,a0,1130 # 80008048 <etext+0x48>
    80005be6:	00000097          	auipc	ra,0x0
    80005bea:	014080e7          	jalr	20(ra) # 80005bfa <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005bee:	4785                	li	a5,1
    80005bf0:	00003717          	auipc	a4,0x3
    80005bf4:	42f72623          	sw	a5,1068(a4) # 8000901c <panicked>
  for(;;)
    80005bf8:	a001                	j	80005bf8 <panic+0x48>

0000000080005bfa <printf>:
{
    80005bfa:	7131                	addi	sp,sp,-192
    80005bfc:	fc86                	sd	ra,120(sp)
    80005bfe:	f8a2                	sd	s0,112(sp)
    80005c00:	f4a6                	sd	s1,104(sp)
    80005c02:	f0ca                	sd	s2,96(sp)
    80005c04:	ecce                	sd	s3,88(sp)
    80005c06:	e8d2                	sd	s4,80(sp)
    80005c08:	e4d6                	sd	s5,72(sp)
    80005c0a:	e0da                	sd	s6,64(sp)
    80005c0c:	fc5e                	sd	s7,56(sp)
    80005c0e:	f862                	sd	s8,48(sp)
    80005c10:	f466                	sd	s9,40(sp)
    80005c12:	f06a                	sd	s10,32(sp)
    80005c14:	ec6e                	sd	s11,24(sp)
    80005c16:	0100                	addi	s0,sp,128
    80005c18:	8a2a                	mv	s4,a0
    80005c1a:	e40c                	sd	a1,8(s0)
    80005c1c:	e810                	sd	a2,16(s0)
    80005c1e:	ec14                	sd	a3,24(s0)
    80005c20:	f018                	sd	a4,32(s0)
    80005c22:	f41c                	sd	a5,40(s0)
    80005c24:	03043823          	sd	a6,48(s0)
    80005c28:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80005c2c:	00020d97          	auipc	s11,0x20
    80005c30:	5d4dad83          	lw	s11,1492(s11) # 80026200 <pr+0x18>
  if(locking)
    80005c34:	020d9b63          	bnez	s11,80005c6a <printf+0x70>
  if (fmt == 0)
    80005c38:	040a0263          	beqz	s4,80005c7c <printf+0x82>
  va_start(ap, fmt);
    80005c3c:	00840793          	addi	a5,s0,8
    80005c40:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005c44:	000a4503          	lbu	a0,0(s4)
    80005c48:	14050f63          	beqz	a0,80005da6 <printf+0x1ac>
    80005c4c:	4981                	li	s3,0
    if(c != '%'){
    80005c4e:	02500a93          	li	s5,37
    switch(c){
    80005c52:	07000b93          	li	s7,112
  consputc('x');
    80005c56:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005c58:	00003b17          	auipc	s6,0x3
    80005c5c:	ce0b0b13          	addi	s6,s6,-800 # 80008938 <digits>
    switch(c){
    80005c60:	07300c93          	li	s9,115
    80005c64:	06400c13          	li	s8,100
    80005c68:	a82d                	j	80005ca2 <printf+0xa8>
    acquire(&pr.lock);
    80005c6a:	00020517          	auipc	a0,0x20
    80005c6e:	57e50513          	addi	a0,a0,1406 # 800261e8 <pr>
    80005c72:	00000097          	auipc	ra,0x0
    80005c76:	476080e7          	jalr	1142(ra) # 800060e8 <acquire>
    80005c7a:	bf7d                	j	80005c38 <printf+0x3e>
    panic("null fmt");
    80005c7c:	00003517          	auipc	a0,0x3
    80005c80:	ca450513          	addi	a0,a0,-860 # 80008920 <syscall_names+0x3e0>
    80005c84:	00000097          	auipc	ra,0x0
    80005c88:	f2c080e7          	jalr	-212(ra) # 80005bb0 <panic>
      consputc(c);
    80005c8c:	00000097          	auipc	ra,0x0
    80005c90:	c60080e7          	jalr	-928(ra) # 800058ec <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005c94:	2985                	addiw	s3,s3,1
    80005c96:	013a07b3          	add	a5,s4,s3
    80005c9a:	0007c503          	lbu	a0,0(a5)
    80005c9e:	10050463          	beqz	a0,80005da6 <printf+0x1ac>
    if(c != '%'){
    80005ca2:	ff5515e3          	bne	a0,s5,80005c8c <printf+0x92>
    c = fmt[++i] & 0xff;
    80005ca6:	2985                	addiw	s3,s3,1
    80005ca8:	013a07b3          	add	a5,s4,s3
    80005cac:	0007c783          	lbu	a5,0(a5)
    80005cb0:	0007849b          	sext.w	s1,a5
    if(c == 0)
    80005cb4:	cbed                	beqz	a5,80005da6 <printf+0x1ac>
    switch(c){
    80005cb6:	05778a63          	beq	a5,s7,80005d0a <printf+0x110>
    80005cba:	02fbf663          	bgeu	s7,a5,80005ce6 <printf+0xec>
    80005cbe:	09978863          	beq	a5,s9,80005d4e <printf+0x154>
    80005cc2:	07800713          	li	a4,120
    80005cc6:	0ce79563          	bne	a5,a4,80005d90 <printf+0x196>
      printint(va_arg(ap, int), 16, 1);
    80005cca:	f8843783          	ld	a5,-120(s0)
    80005cce:	00878713          	addi	a4,a5,8
    80005cd2:	f8e43423          	sd	a4,-120(s0)
    80005cd6:	4605                	li	a2,1
    80005cd8:	85ea                	mv	a1,s10
    80005cda:	4388                	lw	a0,0(a5)
    80005cdc:	00000097          	auipc	ra,0x0
    80005ce0:	e30080e7          	jalr	-464(ra) # 80005b0c <printint>
      break;
    80005ce4:	bf45                	j	80005c94 <printf+0x9a>
    switch(c){
    80005ce6:	09578f63          	beq	a5,s5,80005d84 <printf+0x18a>
    80005cea:	0b879363          	bne	a5,s8,80005d90 <printf+0x196>
      printint(va_arg(ap, int), 10, 1);
    80005cee:	f8843783          	ld	a5,-120(s0)
    80005cf2:	00878713          	addi	a4,a5,8
    80005cf6:	f8e43423          	sd	a4,-120(s0)
    80005cfa:	4605                	li	a2,1
    80005cfc:	45a9                	li	a1,10
    80005cfe:	4388                	lw	a0,0(a5)
    80005d00:	00000097          	auipc	ra,0x0
    80005d04:	e0c080e7          	jalr	-500(ra) # 80005b0c <printint>
      break;
    80005d08:	b771                	j	80005c94 <printf+0x9a>
      printptr(va_arg(ap, uint64));
    80005d0a:	f8843783          	ld	a5,-120(s0)
    80005d0e:	00878713          	addi	a4,a5,8
    80005d12:	f8e43423          	sd	a4,-120(s0)
    80005d16:	0007b903          	ld	s2,0(a5)
  consputc('0');
    80005d1a:	03000513          	li	a0,48
    80005d1e:	00000097          	auipc	ra,0x0
    80005d22:	bce080e7          	jalr	-1074(ra) # 800058ec <consputc>
  consputc('x');
    80005d26:	07800513          	li	a0,120
    80005d2a:	00000097          	auipc	ra,0x0
    80005d2e:	bc2080e7          	jalr	-1086(ra) # 800058ec <consputc>
    80005d32:	84ea                	mv	s1,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005d34:	03c95793          	srli	a5,s2,0x3c
    80005d38:	97da                	add	a5,a5,s6
    80005d3a:	0007c503          	lbu	a0,0(a5)
    80005d3e:	00000097          	auipc	ra,0x0
    80005d42:	bae080e7          	jalr	-1106(ra) # 800058ec <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80005d46:	0912                	slli	s2,s2,0x4
    80005d48:	34fd                	addiw	s1,s1,-1
    80005d4a:	f4ed                	bnez	s1,80005d34 <printf+0x13a>
    80005d4c:	b7a1                	j	80005c94 <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    80005d4e:	f8843783          	ld	a5,-120(s0)
    80005d52:	00878713          	addi	a4,a5,8
    80005d56:	f8e43423          	sd	a4,-120(s0)
    80005d5a:	6384                	ld	s1,0(a5)
    80005d5c:	cc89                	beqz	s1,80005d76 <printf+0x17c>
      for(; *s; s++)
    80005d5e:	0004c503          	lbu	a0,0(s1)
    80005d62:	d90d                	beqz	a0,80005c94 <printf+0x9a>
        consputc(*s);
    80005d64:	00000097          	auipc	ra,0x0
    80005d68:	b88080e7          	jalr	-1144(ra) # 800058ec <consputc>
      for(; *s; s++)
    80005d6c:	0485                	addi	s1,s1,1
    80005d6e:	0004c503          	lbu	a0,0(s1)
    80005d72:	f96d                	bnez	a0,80005d64 <printf+0x16a>
    80005d74:	b705                	j	80005c94 <printf+0x9a>
        s = "(null)";
    80005d76:	00003497          	auipc	s1,0x3
    80005d7a:	ba248493          	addi	s1,s1,-1118 # 80008918 <syscall_names+0x3d8>
      for(; *s; s++)
    80005d7e:	02800513          	li	a0,40
    80005d82:	b7cd                	j	80005d64 <printf+0x16a>
      consputc('%');
    80005d84:	8556                	mv	a0,s5
    80005d86:	00000097          	auipc	ra,0x0
    80005d8a:	b66080e7          	jalr	-1178(ra) # 800058ec <consputc>
      break;
    80005d8e:	b719                	j	80005c94 <printf+0x9a>
      consputc('%');
    80005d90:	8556                	mv	a0,s5
    80005d92:	00000097          	auipc	ra,0x0
    80005d96:	b5a080e7          	jalr	-1190(ra) # 800058ec <consputc>
      consputc(c);
    80005d9a:	8526                	mv	a0,s1
    80005d9c:	00000097          	auipc	ra,0x0
    80005da0:	b50080e7          	jalr	-1200(ra) # 800058ec <consputc>
      break;
    80005da4:	bdc5                	j	80005c94 <printf+0x9a>
  if(locking)
    80005da6:	020d9163          	bnez	s11,80005dc8 <printf+0x1ce>
}
    80005daa:	70e6                	ld	ra,120(sp)
    80005dac:	7446                	ld	s0,112(sp)
    80005dae:	74a6                	ld	s1,104(sp)
    80005db0:	7906                	ld	s2,96(sp)
    80005db2:	69e6                	ld	s3,88(sp)
    80005db4:	6a46                	ld	s4,80(sp)
    80005db6:	6aa6                	ld	s5,72(sp)
    80005db8:	6b06                	ld	s6,64(sp)
    80005dba:	7be2                	ld	s7,56(sp)
    80005dbc:	7c42                	ld	s8,48(sp)
    80005dbe:	7ca2                	ld	s9,40(sp)
    80005dc0:	7d02                	ld	s10,32(sp)
    80005dc2:	6de2                	ld	s11,24(sp)
    80005dc4:	6129                	addi	sp,sp,192
    80005dc6:	8082                	ret
    release(&pr.lock);
    80005dc8:	00020517          	auipc	a0,0x20
    80005dcc:	42050513          	addi	a0,a0,1056 # 800261e8 <pr>
    80005dd0:	00000097          	auipc	ra,0x0
    80005dd4:	3cc080e7          	jalr	972(ra) # 8000619c <release>
}
    80005dd8:	bfc9                	j	80005daa <printf+0x1b0>

0000000080005dda <printfinit>:
    ;
}

void
printfinit(void)
{
    80005dda:	1101                	addi	sp,sp,-32
    80005ddc:	ec06                	sd	ra,24(sp)
    80005dde:	e822                	sd	s0,16(sp)
    80005de0:	e426                	sd	s1,8(sp)
    80005de2:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80005de4:	00020497          	auipc	s1,0x20
    80005de8:	40448493          	addi	s1,s1,1028 # 800261e8 <pr>
    80005dec:	00003597          	auipc	a1,0x3
    80005df0:	b4458593          	addi	a1,a1,-1212 # 80008930 <syscall_names+0x3f0>
    80005df4:	8526                	mv	a0,s1
    80005df6:	00000097          	auipc	ra,0x0
    80005dfa:	262080e7          	jalr	610(ra) # 80006058 <initlock>
  pr.locking = 1;
    80005dfe:	4785                	li	a5,1
    80005e00:	cc9c                	sw	a5,24(s1)
}
    80005e02:	60e2                	ld	ra,24(sp)
    80005e04:	6442                	ld	s0,16(sp)
    80005e06:	64a2                	ld	s1,8(sp)
    80005e08:	6105                	addi	sp,sp,32
    80005e0a:	8082                	ret

0000000080005e0c <uartinit>:

void uartstart();

void
uartinit(void)
{
    80005e0c:	1141                	addi	sp,sp,-16
    80005e0e:	e406                	sd	ra,8(sp)
    80005e10:	e022                	sd	s0,0(sp)
    80005e12:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80005e14:	100007b7          	lui	a5,0x10000
    80005e18:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80005e1c:	f8000713          	li	a4,-128
    80005e20:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80005e24:	470d                	li	a4,3
    80005e26:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80005e2a:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80005e2e:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80005e32:	469d                	li	a3,7
    80005e34:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80005e38:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    80005e3c:	00003597          	auipc	a1,0x3
    80005e40:	b1458593          	addi	a1,a1,-1260 # 80008950 <digits+0x18>
    80005e44:	00020517          	auipc	a0,0x20
    80005e48:	3c450513          	addi	a0,a0,964 # 80026208 <uart_tx_lock>
    80005e4c:	00000097          	auipc	ra,0x0
    80005e50:	20c080e7          	jalr	524(ra) # 80006058 <initlock>
}
    80005e54:	60a2                	ld	ra,8(sp)
    80005e56:	6402                	ld	s0,0(sp)
    80005e58:	0141                	addi	sp,sp,16
    80005e5a:	8082                	ret

0000000080005e5c <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80005e5c:	1101                	addi	sp,sp,-32
    80005e5e:	ec06                	sd	ra,24(sp)
    80005e60:	e822                	sd	s0,16(sp)
    80005e62:	e426                	sd	s1,8(sp)
    80005e64:	1000                	addi	s0,sp,32
    80005e66:	84aa                	mv	s1,a0
  push_off();
    80005e68:	00000097          	auipc	ra,0x0
    80005e6c:	234080e7          	jalr	564(ra) # 8000609c <push_off>

  if(panicked){
    80005e70:	00003797          	auipc	a5,0x3
    80005e74:	1ac7a783          	lw	a5,428(a5) # 8000901c <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80005e78:	10000737          	lui	a4,0x10000
  if(panicked){
    80005e7c:	c391                	beqz	a5,80005e80 <uartputc_sync+0x24>
    for(;;)
    80005e7e:	a001                	j	80005e7e <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80005e80:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    80005e84:	0207f793          	andi	a5,a5,32
    80005e88:	dfe5                	beqz	a5,80005e80 <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    80005e8a:	0ff4f513          	zext.b	a0,s1
    80005e8e:	100007b7          	lui	a5,0x10000
    80005e92:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    80005e96:	00000097          	auipc	ra,0x0
    80005e9a:	2a6080e7          	jalr	678(ra) # 8000613c <pop_off>
}
    80005e9e:	60e2                	ld	ra,24(sp)
    80005ea0:	6442                	ld	s0,16(sp)
    80005ea2:	64a2                	ld	s1,8(sp)
    80005ea4:	6105                	addi	sp,sp,32
    80005ea6:	8082                	ret

0000000080005ea8 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80005ea8:	00003797          	auipc	a5,0x3
    80005eac:	1787b783          	ld	a5,376(a5) # 80009020 <uart_tx_r>
    80005eb0:	00003717          	auipc	a4,0x3
    80005eb4:	17873703          	ld	a4,376(a4) # 80009028 <uart_tx_w>
    80005eb8:	06f70a63          	beq	a4,a5,80005f2c <uartstart+0x84>
{
    80005ebc:	7139                	addi	sp,sp,-64
    80005ebe:	fc06                	sd	ra,56(sp)
    80005ec0:	f822                	sd	s0,48(sp)
    80005ec2:	f426                	sd	s1,40(sp)
    80005ec4:	f04a                	sd	s2,32(sp)
    80005ec6:	ec4e                	sd	s3,24(sp)
    80005ec8:	e852                	sd	s4,16(sp)
    80005eca:	e456                	sd	s5,8(sp)
    80005ecc:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80005ece:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80005ed2:	00020a17          	auipc	s4,0x20
    80005ed6:	336a0a13          	addi	s4,s4,822 # 80026208 <uart_tx_lock>
    uart_tx_r += 1;
    80005eda:	00003497          	auipc	s1,0x3
    80005ede:	14648493          	addi	s1,s1,326 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    80005ee2:	00003997          	auipc	s3,0x3
    80005ee6:	14698993          	addi	s3,s3,326 # 80009028 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80005eea:	00594703          	lbu	a4,5(s2) # 10000005 <_entry-0x6ffffffb>
    80005eee:	02077713          	andi	a4,a4,32
    80005ef2:	c705                	beqz	a4,80005f1a <uartstart+0x72>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80005ef4:	01f7f713          	andi	a4,a5,31
    80005ef8:	9752                	add	a4,a4,s4
    80005efa:	01874a83          	lbu	s5,24(a4)
    uart_tx_r += 1;
    80005efe:	0785                	addi	a5,a5,1
    80005f00:	e09c                	sd	a5,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    80005f02:	8526                	mv	a0,s1
    80005f04:	ffffb097          	auipc	ra,0xffffb
    80005f08:	7a2080e7          	jalr	1954(ra) # 800016a6 <wakeup>
    
    WriteReg(THR, c);
    80005f0c:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    80005f10:	609c                	ld	a5,0(s1)
    80005f12:	0009b703          	ld	a4,0(s3)
    80005f16:	fcf71ae3          	bne	a4,a5,80005eea <uartstart+0x42>
  }
}
    80005f1a:	70e2                	ld	ra,56(sp)
    80005f1c:	7442                	ld	s0,48(sp)
    80005f1e:	74a2                	ld	s1,40(sp)
    80005f20:	7902                	ld	s2,32(sp)
    80005f22:	69e2                	ld	s3,24(sp)
    80005f24:	6a42                	ld	s4,16(sp)
    80005f26:	6aa2                	ld	s5,8(sp)
    80005f28:	6121                	addi	sp,sp,64
    80005f2a:	8082                	ret
    80005f2c:	8082                	ret

0000000080005f2e <uartputc>:
{
    80005f2e:	7179                	addi	sp,sp,-48
    80005f30:	f406                	sd	ra,40(sp)
    80005f32:	f022                	sd	s0,32(sp)
    80005f34:	ec26                	sd	s1,24(sp)
    80005f36:	e84a                	sd	s2,16(sp)
    80005f38:	e44e                	sd	s3,8(sp)
    80005f3a:	e052                	sd	s4,0(sp)
    80005f3c:	1800                	addi	s0,sp,48
    80005f3e:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    80005f40:	00020517          	auipc	a0,0x20
    80005f44:	2c850513          	addi	a0,a0,712 # 80026208 <uart_tx_lock>
    80005f48:	00000097          	auipc	ra,0x0
    80005f4c:	1a0080e7          	jalr	416(ra) # 800060e8 <acquire>
  if(panicked){
    80005f50:	00003797          	auipc	a5,0x3
    80005f54:	0cc7a783          	lw	a5,204(a5) # 8000901c <panicked>
    80005f58:	c391                	beqz	a5,80005f5c <uartputc+0x2e>
    for(;;)
    80005f5a:	a001                	j	80005f5a <uartputc+0x2c>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80005f5c:	00003717          	auipc	a4,0x3
    80005f60:	0cc73703          	ld	a4,204(a4) # 80009028 <uart_tx_w>
    80005f64:	00003797          	auipc	a5,0x3
    80005f68:	0bc7b783          	ld	a5,188(a5) # 80009020 <uart_tx_r>
    80005f6c:	02078793          	addi	a5,a5,32
    80005f70:	02e79b63          	bne	a5,a4,80005fa6 <uartputc+0x78>
      sleep(&uart_tx_r, &uart_tx_lock);
    80005f74:	00020997          	auipc	s3,0x20
    80005f78:	29498993          	addi	s3,s3,660 # 80026208 <uart_tx_lock>
    80005f7c:	00003497          	auipc	s1,0x3
    80005f80:	0a448493          	addi	s1,s1,164 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80005f84:	00003917          	auipc	s2,0x3
    80005f88:	0a490913          	addi	s2,s2,164 # 80009028 <uart_tx_w>
      sleep(&uart_tx_r, &uart_tx_lock);
    80005f8c:	85ce                	mv	a1,s3
    80005f8e:	8526                	mv	a0,s1
    80005f90:	ffffb097          	auipc	ra,0xffffb
    80005f94:	58a080e7          	jalr	1418(ra) # 8000151a <sleep>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80005f98:	00093703          	ld	a4,0(s2)
    80005f9c:	609c                	ld	a5,0(s1)
    80005f9e:	02078793          	addi	a5,a5,32
    80005fa2:	fee785e3          	beq	a5,a4,80005f8c <uartputc+0x5e>
      uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80005fa6:	00020497          	auipc	s1,0x20
    80005faa:	26248493          	addi	s1,s1,610 # 80026208 <uart_tx_lock>
    80005fae:	01f77793          	andi	a5,a4,31
    80005fb2:	97a6                	add	a5,a5,s1
    80005fb4:	01478c23          	sb	s4,24(a5)
      uart_tx_w += 1;
    80005fb8:	0705                	addi	a4,a4,1
    80005fba:	00003797          	auipc	a5,0x3
    80005fbe:	06e7b723          	sd	a4,110(a5) # 80009028 <uart_tx_w>
      uartstart();
    80005fc2:	00000097          	auipc	ra,0x0
    80005fc6:	ee6080e7          	jalr	-282(ra) # 80005ea8 <uartstart>
      release(&uart_tx_lock);
    80005fca:	8526                	mv	a0,s1
    80005fcc:	00000097          	auipc	ra,0x0
    80005fd0:	1d0080e7          	jalr	464(ra) # 8000619c <release>
}
    80005fd4:	70a2                	ld	ra,40(sp)
    80005fd6:	7402                	ld	s0,32(sp)
    80005fd8:	64e2                	ld	s1,24(sp)
    80005fda:	6942                	ld	s2,16(sp)
    80005fdc:	69a2                	ld	s3,8(sp)
    80005fde:	6a02                	ld	s4,0(sp)
    80005fe0:	6145                	addi	sp,sp,48
    80005fe2:	8082                	ret

0000000080005fe4 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    80005fe4:	1141                	addi	sp,sp,-16
    80005fe6:	e422                	sd	s0,8(sp)
    80005fe8:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    80005fea:	100007b7          	lui	a5,0x10000
    80005fee:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    80005ff2:	8b85                	andi	a5,a5,1
    80005ff4:	cb81                	beqz	a5,80006004 <uartgetc+0x20>
    // input data is ready.
    return ReadReg(RHR);
    80005ff6:	100007b7          	lui	a5,0x10000
    80005ffa:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    80005ffe:	6422                	ld	s0,8(sp)
    80006000:	0141                	addi	sp,sp,16
    80006002:	8082                	ret
    return -1;
    80006004:	557d                	li	a0,-1
    80006006:	bfe5                	j	80005ffe <uartgetc+0x1a>

0000000080006008 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from trap.c.
void
uartintr(void)
{
    80006008:	1101                	addi	sp,sp,-32
    8000600a:	ec06                	sd	ra,24(sp)
    8000600c:	e822                	sd	s0,16(sp)
    8000600e:	e426                	sd	s1,8(sp)
    80006010:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    80006012:	54fd                	li	s1,-1
    80006014:	a029                	j	8000601e <uartintr+0x16>
      break;
    consoleintr(c);
    80006016:	00000097          	auipc	ra,0x0
    8000601a:	918080e7          	jalr	-1768(ra) # 8000592e <consoleintr>
    int c = uartgetc();
    8000601e:	00000097          	auipc	ra,0x0
    80006022:	fc6080e7          	jalr	-58(ra) # 80005fe4 <uartgetc>
    if(c == -1)
    80006026:	fe9518e3          	bne	a0,s1,80006016 <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    8000602a:	00020497          	auipc	s1,0x20
    8000602e:	1de48493          	addi	s1,s1,478 # 80026208 <uart_tx_lock>
    80006032:	8526                	mv	a0,s1
    80006034:	00000097          	auipc	ra,0x0
    80006038:	0b4080e7          	jalr	180(ra) # 800060e8 <acquire>
  uartstart();
    8000603c:	00000097          	auipc	ra,0x0
    80006040:	e6c080e7          	jalr	-404(ra) # 80005ea8 <uartstart>
  release(&uart_tx_lock);
    80006044:	8526                	mv	a0,s1
    80006046:	00000097          	auipc	ra,0x0
    8000604a:	156080e7          	jalr	342(ra) # 8000619c <release>
}
    8000604e:	60e2                	ld	ra,24(sp)
    80006050:	6442                	ld	s0,16(sp)
    80006052:	64a2                	ld	s1,8(sp)
    80006054:	6105                	addi	sp,sp,32
    80006056:	8082                	ret

0000000080006058 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80006058:	1141                	addi	sp,sp,-16
    8000605a:	e422                	sd	s0,8(sp)
    8000605c:	0800                	addi	s0,sp,16
  lk->name = name;
    8000605e:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80006060:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80006064:	00053823          	sd	zero,16(a0)
}
    80006068:	6422                	ld	s0,8(sp)
    8000606a:	0141                	addi	sp,sp,16
    8000606c:	8082                	ret

000000008000606e <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    8000606e:	411c                	lw	a5,0(a0)
    80006070:	e399                	bnez	a5,80006076 <holding+0x8>
    80006072:	4501                	li	a0,0
  return r;
}
    80006074:	8082                	ret
{
    80006076:	1101                	addi	sp,sp,-32
    80006078:	ec06                	sd	ra,24(sp)
    8000607a:	e822                	sd	s0,16(sp)
    8000607c:	e426                	sd	s1,8(sp)
    8000607e:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80006080:	6904                	ld	s1,16(a0)
    80006082:	ffffb097          	auipc	ra,0xffffb
    80006086:	da6080e7          	jalr	-602(ra) # 80000e28 <mycpu>
    8000608a:	40a48533          	sub	a0,s1,a0
    8000608e:	00153513          	seqz	a0,a0
}
    80006092:	60e2                	ld	ra,24(sp)
    80006094:	6442                	ld	s0,16(sp)
    80006096:	64a2                	ld	s1,8(sp)
    80006098:	6105                	addi	sp,sp,32
    8000609a:	8082                	ret

000000008000609c <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    8000609c:	1101                	addi	sp,sp,-32
    8000609e:	ec06                	sd	ra,24(sp)
    800060a0:	e822                	sd	s0,16(sp)
    800060a2:	e426                	sd	s1,8(sp)
    800060a4:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800060a6:	100024f3          	csrr	s1,sstatus
    800060aa:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    800060ae:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800060b0:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    800060b4:	ffffb097          	auipc	ra,0xffffb
    800060b8:	d74080e7          	jalr	-652(ra) # 80000e28 <mycpu>
    800060bc:	5d3c                	lw	a5,120(a0)
    800060be:	cf89                	beqz	a5,800060d8 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    800060c0:	ffffb097          	auipc	ra,0xffffb
    800060c4:	d68080e7          	jalr	-664(ra) # 80000e28 <mycpu>
    800060c8:	5d3c                	lw	a5,120(a0)
    800060ca:	2785                	addiw	a5,a5,1
    800060cc:	dd3c                	sw	a5,120(a0)
}
    800060ce:	60e2                	ld	ra,24(sp)
    800060d0:	6442                	ld	s0,16(sp)
    800060d2:	64a2                	ld	s1,8(sp)
    800060d4:	6105                	addi	sp,sp,32
    800060d6:	8082                	ret
    mycpu()->intena = old;
    800060d8:	ffffb097          	auipc	ra,0xffffb
    800060dc:	d50080e7          	jalr	-688(ra) # 80000e28 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    800060e0:	8085                	srli	s1,s1,0x1
    800060e2:	8885                	andi	s1,s1,1
    800060e4:	dd64                	sw	s1,124(a0)
    800060e6:	bfe9                	j	800060c0 <push_off+0x24>

00000000800060e8 <acquire>:
{
    800060e8:	1101                	addi	sp,sp,-32
    800060ea:	ec06                	sd	ra,24(sp)
    800060ec:	e822                	sd	s0,16(sp)
    800060ee:	e426                	sd	s1,8(sp)
    800060f0:	1000                	addi	s0,sp,32
    800060f2:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    800060f4:	00000097          	auipc	ra,0x0
    800060f8:	fa8080e7          	jalr	-88(ra) # 8000609c <push_off>
  if(holding(lk))
    800060fc:	8526                	mv	a0,s1
    800060fe:	00000097          	auipc	ra,0x0
    80006102:	f70080e7          	jalr	-144(ra) # 8000606e <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80006106:	4705                	li	a4,1
  if(holding(lk))
    80006108:	e115                	bnez	a0,8000612c <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    8000610a:	87ba                	mv	a5,a4
    8000610c:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80006110:	2781                	sext.w	a5,a5
    80006112:	ffe5                	bnez	a5,8000610a <acquire+0x22>
  __sync_synchronize();
    80006114:	0ff0000f          	fence
  lk->cpu = mycpu();
    80006118:	ffffb097          	auipc	ra,0xffffb
    8000611c:	d10080e7          	jalr	-752(ra) # 80000e28 <mycpu>
    80006120:	e888                	sd	a0,16(s1)
}
    80006122:	60e2                	ld	ra,24(sp)
    80006124:	6442                	ld	s0,16(sp)
    80006126:	64a2                	ld	s1,8(sp)
    80006128:	6105                	addi	sp,sp,32
    8000612a:	8082                	ret
    panic("acquire");
    8000612c:	00003517          	auipc	a0,0x3
    80006130:	82c50513          	addi	a0,a0,-2004 # 80008958 <digits+0x20>
    80006134:	00000097          	auipc	ra,0x0
    80006138:	a7c080e7          	jalr	-1412(ra) # 80005bb0 <panic>

000000008000613c <pop_off>:

void
pop_off(void)
{
    8000613c:	1141                	addi	sp,sp,-16
    8000613e:	e406                	sd	ra,8(sp)
    80006140:	e022                	sd	s0,0(sp)
    80006142:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80006144:	ffffb097          	auipc	ra,0xffffb
    80006148:	ce4080e7          	jalr	-796(ra) # 80000e28 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000614c:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80006150:	8b89                	andi	a5,a5,2
  if(intr_get())
    80006152:	e78d                	bnez	a5,8000617c <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80006154:	5d3c                	lw	a5,120(a0)
    80006156:	02f05b63          	blez	a5,8000618c <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    8000615a:	37fd                	addiw	a5,a5,-1
    8000615c:	0007871b          	sext.w	a4,a5
    80006160:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80006162:	eb09                	bnez	a4,80006174 <pop_off+0x38>
    80006164:	5d7c                	lw	a5,124(a0)
    80006166:	c799                	beqz	a5,80006174 <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006168:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    8000616c:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80006170:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80006174:	60a2                	ld	ra,8(sp)
    80006176:	6402                	ld	s0,0(sp)
    80006178:	0141                	addi	sp,sp,16
    8000617a:	8082                	ret
    panic("pop_off - interruptible");
    8000617c:	00002517          	auipc	a0,0x2
    80006180:	7e450513          	addi	a0,a0,2020 # 80008960 <digits+0x28>
    80006184:	00000097          	auipc	ra,0x0
    80006188:	a2c080e7          	jalr	-1492(ra) # 80005bb0 <panic>
    panic("pop_off");
    8000618c:	00002517          	auipc	a0,0x2
    80006190:	7ec50513          	addi	a0,a0,2028 # 80008978 <digits+0x40>
    80006194:	00000097          	auipc	ra,0x0
    80006198:	a1c080e7          	jalr	-1508(ra) # 80005bb0 <panic>

000000008000619c <release>:
{
    8000619c:	1101                	addi	sp,sp,-32
    8000619e:	ec06                	sd	ra,24(sp)
    800061a0:	e822                	sd	s0,16(sp)
    800061a2:	e426                	sd	s1,8(sp)
    800061a4:	1000                	addi	s0,sp,32
    800061a6:	84aa                	mv	s1,a0
  if(!holding(lk))
    800061a8:	00000097          	auipc	ra,0x0
    800061ac:	ec6080e7          	jalr	-314(ra) # 8000606e <holding>
    800061b0:	c115                	beqz	a0,800061d4 <release+0x38>
  lk->cpu = 0;
    800061b2:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    800061b6:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    800061ba:	0f50000f          	fence	iorw,ow
    800061be:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    800061c2:	00000097          	auipc	ra,0x0
    800061c6:	f7a080e7          	jalr	-134(ra) # 8000613c <pop_off>
}
    800061ca:	60e2                	ld	ra,24(sp)
    800061cc:	6442                	ld	s0,16(sp)
    800061ce:	64a2                	ld	s1,8(sp)
    800061d0:	6105                	addi	sp,sp,32
    800061d2:	8082                	ret
    panic("release");
    800061d4:	00002517          	auipc	a0,0x2
    800061d8:	7ac50513          	addi	a0,a0,1964 # 80008980 <digits+0x48>
    800061dc:	00000097          	auipc	ra,0x0
    800061e0:	9d4080e7          	jalr	-1580(ra) # 80005bb0 <panic>
	...

0000000080007000 <_trampoline>:
    80007000:	14051573          	csrrw	a0,sscratch,a0
    80007004:	02153423          	sd	ra,40(a0)
    80007008:	02253823          	sd	sp,48(a0)
    8000700c:	02353c23          	sd	gp,56(a0)
    80007010:	04453023          	sd	tp,64(a0)
    80007014:	04553423          	sd	t0,72(a0)
    80007018:	04653823          	sd	t1,80(a0)
    8000701c:	04753c23          	sd	t2,88(a0)
    80007020:	f120                	sd	s0,96(a0)
    80007022:	f524                	sd	s1,104(a0)
    80007024:	fd2c                	sd	a1,120(a0)
    80007026:	e150                	sd	a2,128(a0)
    80007028:	e554                	sd	a3,136(a0)
    8000702a:	e958                	sd	a4,144(a0)
    8000702c:	ed5c                	sd	a5,152(a0)
    8000702e:	0b053023          	sd	a6,160(a0)
    80007032:	0b153423          	sd	a7,168(a0)
    80007036:	0b253823          	sd	s2,176(a0)
    8000703a:	0b353c23          	sd	s3,184(a0)
    8000703e:	0d453023          	sd	s4,192(a0)
    80007042:	0d553423          	sd	s5,200(a0)
    80007046:	0d653823          	sd	s6,208(a0)
    8000704a:	0d753c23          	sd	s7,216(a0)
    8000704e:	0f853023          	sd	s8,224(a0)
    80007052:	0f953423          	sd	s9,232(a0)
    80007056:	0fa53823          	sd	s10,240(a0)
    8000705a:	0fb53c23          	sd	s11,248(a0)
    8000705e:	11c53023          	sd	t3,256(a0)
    80007062:	11d53423          	sd	t4,264(a0)
    80007066:	11e53823          	sd	t5,272(a0)
    8000706a:	11f53c23          	sd	t6,280(a0)
    8000706e:	140022f3          	csrr	t0,sscratch
    80007072:	06553823          	sd	t0,112(a0)
    80007076:	00853103          	ld	sp,8(a0)
    8000707a:	02053203          	ld	tp,32(a0)
    8000707e:	01053283          	ld	t0,16(a0)
    80007082:	00053303          	ld	t1,0(a0)
    80007086:	18031073          	csrw	satp,t1
    8000708a:	12000073          	sfence.vma
    8000708e:	8282                	jr	t0

0000000080007090 <userret>:
    80007090:	18059073          	csrw	satp,a1
    80007094:	12000073          	sfence.vma
    80007098:	07053283          	ld	t0,112(a0)
    8000709c:	14029073          	csrw	sscratch,t0
    800070a0:	02853083          	ld	ra,40(a0)
    800070a4:	03053103          	ld	sp,48(a0)
    800070a8:	03853183          	ld	gp,56(a0)
    800070ac:	04053203          	ld	tp,64(a0)
    800070b0:	04853283          	ld	t0,72(a0)
    800070b4:	05053303          	ld	t1,80(a0)
    800070b8:	05853383          	ld	t2,88(a0)
    800070bc:	7120                	ld	s0,96(a0)
    800070be:	7524                	ld	s1,104(a0)
    800070c0:	7d2c                	ld	a1,120(a0)
    800070c2:	6150                	ld	a2,128(a0)
    800070c4:	6554                	ld	a3,136(a0)
    800070c6:	6958                	ld	a4,144(a0)
    800070c8:	6d5c                	ld	a5,152(a0)
    800070ca:	0a053803          	ld	a6,160(a0)
    800070ce:	0a853883          	ld	a7,168(a0)
    800070d2:	0b053903          	ld	s2,176(a0)
    800070d6:	0b853983          	ld	s3,184(a0)
    800070da:	0c053a03          	ld	s4,192(a0)
    800070de:	0c853a83          	ld	s5,200(a0)
    800070e2:	0d053b03          	ld	s6,208(a0)
    800070e6:	0d853b83          	ld	s7,216(a0)
    800070ea:	0e053c03          	ld	s8,224(a0)
    800070ee:	0e853c83          	ld	s9,232(a0)
    800070f2:	0f053d03          	ld	s10,240(a0)
    800070f6:	0f853d83          	ld	s11,248(a0)
    800070fa:	10053e03          	ld	t3,256(a0)
    800070fe:	10853e83          	ld	t4,264(a0)
    80007102:	11053f03          	ld	t5,272(a0)
    80007106:	11853f83          	ld	t6,280(a0)
    8000710a:	14051573          	csrrw	a0,sscratch,a0
    8000710e:	10200073          	sret
	...

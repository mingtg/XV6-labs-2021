
user/_primes：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000000000000 <func>:
#include "kernel/types.h"
#include "user/user.h"

void func(int *input, int num){
   0:	7139                	addi	sp,sp,-64
   2:	fc06                	sd	ra,56(sp)
   4:	f822                	sd	s0,48(sp)
   6:	f426                	sd	s1,40(sp)
   8:	f04a                	sd	s2,32(sp)
   a:	ec4e                	sd	s3,24(sp)
   c:	0080                	addi	s0,sp,64
   e:	892a                	mv	s2,a0
	if(num == 1){
  10:	4785                	li	a5,1
  12:	06f58663          	beq	a1,a5,7e <func+0x7e>
  16:	84ae                	mv	s1,a1
		printf("prime %d\n", *input);
		return;
	}
	int p[2],i;
	int prime = *input;
  18:	00052983          	lw	s3,0(a0)
	int temp;
	printf("prime %d\n", prime);
  1c:	85ce                	mv	a1,s3
  1e:	00001517          	auipc	a0,0x1
  22:	8ba50513          	addi	a0,a0,-1862 # 8d8 <malloc+0xec>
  26:	00000097          	auipc	ra,0x0
  2a:	70e080e7          	jalr	1806(ra) # 734 <printf>
	pipe(p);
  2e:	fc840513          	addi	a0,s0,-56
  32:	00000097          	auipc	ra,0x0
  36:	398080e7          	jalr	920(ra) # 3ca <pipe>
    if(fork() == 0){
  3a:	00000097          	auipc	ra,0x0
  3e:	378080e7          	jalr	888(ra) # 3b2 <fork>
  42:	c921                	beqz	a0,92 <func+0x92>
            temp = *(input + i);
			write(p[1], (char *)(&temp), 4);
		}
        exit(0);
    }
	close(p[1]);
  44:	fcc42503          	lw	a0,-52(s0)
  48:	00000097          	auipc	ra,0x0
  4c:	39a080e7          	jalr	922(ra) # 3e2 <close>
	if(fork() == 0){
  50:	00000097          	auipc	ra,0x0
  54:	362080e7          	jalr	866(ra) # 3b2 <fork>
  58:	84aa                	mv	s1,a0
  5a:	c93d                	beqz	a0,d0 <func+0xd0>
			}
		}
		func(input - counter, counter);
		exit(0);
    }
	wait(0);
  5c:	4501                	li	a0,0
  5e:	00000097          	auipc	ra,0x0
  62:	364080e7          	jalr	868(ra) # 3c2 <wait>
	wait(0);
  66:	4501                	li	a0,0
  68:	00000097          	auipc	ra,0x0
  6c:	35a080e7          	jalr	858(ra) # 3c2 <wait>
}
  70:	70e2                	ld	ra,56(sp)
  72:	7442                	ld	s0,48(sp)
  74:	74a2                	ld	s1,40(sp)
  76:	7902                	ld	s2,32(sp)
  78:	69e2                	ld	s3,24(sp)
  7a:	6121                	addi	sp,sp,64
  7c:	8082                	ret
		printf("prime %d\n", *input);
  7e:	410c                	lw	a1,0(a0)
  80:	00001517          	auipc	a0,0x1
  84:	85850513          	addi	a0,a0,-1960 # 8d8 <malloc+0xec>
  88:	00000097          	auipc	ra,0x0
  8c:	6ac080e7          	jalr	1708(ra) # 734 <printf>
		return;
  90:	b7c5                	j	70 <func+0x70>
        for(i = 0; i < num; i++){
  92:	02905a63          	blez	s1,c6 <func+0xc6>
  96:	89ca                	mv	s3,s2
  98:	34fd                	addiw	s1,s1,-1
  9a:	02049793          	slli	a5,s1,0x20
  9e:	01e7d493          	srli	s1,a5,0x1e
  a2:	0911                	addi	s2,s2,4
  a4:	94ca                	add	s1,s1,s2
            temp = *(input + i);
  a6:	0009a783          	lw	a5,0(s3)
  aa:	fcf42223          	sw	a5,-60(s0)
			write(p[1], (char *)(&temp), 4);
  ae:	4611                	li	a2,4
  b0:	fc440593          	addi	a1,s0,-60
  b4:	fcc42503          	lw	a0,-52(s0)
  b8:	00000097          	auipc	ra,0x0
  bc:	322080e7          	jalr	802(ra) # 3da <write>
        for(i = 0; i < num; i++){
  c0:	0991                	addi	s3,s3,4
  c2:	fe9992e3          	bne	s3,s1,a6 <func+0xa6>
        exit(0);
  c6:	4501                	li	a0,0
  c8:	00000097          	auipc	ra,0x0
  cc:	2f2080e7          	jalr	754(ra) # 3ba <exit>
		while(read(p[0], buffer, 4) != 0){
  d0:	4611                	li	a2,4
  d2:	fc040593          	addi	a1,s0,-64
  d6:	fc842503          	lw	a0,-56(s0)
  da:	00000097          	auipc	ra,0x0
  de:	2f8080e7          	jalr	760(ra) # 3d2 <read>
  e2:	cd09                	beqz	a0,fc <func+0xfc>
			temp = *((int *)buffer);
  e4:	fc042783          	lw	a5,-64(s0)
  e8:	fcf42223          	sw	a5,-60(s0)
			if(temp % prime != 0){
  ec:	0337e73b          	remw	a4,a5,s3
  f0:	d365                	beqz	a4,d0 <func+0xd0>
				*input = temp;
  f2:	00f92023          	sw	a5,0(s2)
				input += 1;
  f6:	0911                	addi	s2,s2,4
				counter++;
  f8:	2485                	addiw	s1,s1,1
  fa:	bfd9                	j	d0 <func+0xd0>
		func(input - counter, counter);
  fc:	00249513          	slli	a0,s1,0x2
 100:	85a6                	mv	a1,s1
 102:	40a90533          	sub	a0,s2,a0
 106:	00000097          	auipc	ra,0x0
 10a:	efa080e7          	jalr	-262(ra) # 0 <func>
		exit(0);
 10e:	4501                	li	a0,0
 110:	00000097          	auipc	ra,0x0
 114:	2aa080e7          	jalr	682(ra) # 3ba <exit>

0000000000000118 <main>:

int main(){
 118:	7135                	addi	sp,sp,-160
 11a:	ed06                	sd	ra,152(sp)
 11c:	e922                	sd	s0,144(sp)
 11e:	1100                	addi	s0,sp,160
    int input[34];
	int i = 0;
	for(; i < 34; i++){
 120:	f6840793          	addi	a5,s0,-152
 124:	ff040693          	addi	a3,s0,-16
int main(){
 128:	4709                	li	a4,2
		input[i] = i+2;
 12a:	c398                	sw	a4,0(a5)
	for(; i < 34; i++){
 12c:	2705                	addiw	a4,a4,1
 12e:	0791                	addi	a5,a5,4
 130:	fed79de3          	bne	a5,a3,12a <main+0x12>
	}
	func(input, 34);
 134:	02200593          	li	a1,34
 138:	f6840513          	addi	a0,s0,-152
 13c:	00000097          	auipc	ra,0x0
 140:	ec4080e7          	jalr	-316(ra) # 0 <func>
    exit(0);
 144:	4501                	li	a0,0
 146:	00000097          	auipc	ra,0x0
 14a:	274080e7          	jalr	628(ra) # 3ba <exit>

000000000000014e <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 14e:	1141                	addi	sp,sp,-16
 150:	e422                	sd	s0,8(sp)
 152:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 154:	87aa                	mv	a5,a0
 156:	0585                	addi	a1,a1,1
 158:	0785                	addi	a5,a5,1
 15a:	fff5c703          	lbu	a4,-1(a1)
 15e:	fee78fa3          	sb	a4,-1(a5)
 162:	fb75                	bnez	a4,156 <strcpy+0x8>
    ;
  return os;
}
 164:	6422                	ld	s0,8(sp)
 166:	0141                	addi	sp,sp,16
 168:	8082                	ret

000000000000016a <strcmp>:

int
strcmp(const char *p, const char *q)
{
 16a:	1141                	addi	sp,sp,-16
 16c:	e422                	sd	s0,8(sp)
 16e:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 170:	00054783          	lbu	a5,0(a0)
 174:	cb91                	beqz	a5,188 <strcmp+0x1e>
 176:	0005c703          	lbu	a4,0(a1)
 17a:	00f71763          	bne	a4,a5,188 <strcmp+0x1e>
    p++, q++;
 17e:	0505                	addi	a0,a0,1
 180:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 182:	00054783          	lbu	a5,0(a0)
 186:	fbe5                	bnez	a5,176 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 188:	0005c503          	lbu	a0,0(a1)
}
 18c:	40a7853b          	subw	a0,a5,a0
 190:	6422                	ld	s0,8(sp)
 192:	0141                	addi	sp,sp,16
 194:	8082                	ret

0000000000000196 <strlen>:

uint
strlen(const char *s)
{
 196:	1141                	addi	sp,sp,-16
 198:	e422                	sd	s0,8(sp)
 19a:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 19c:	00054783          	lbu	a5,0(a0)
 1a0:	cf91                	beqz	a5,1bc <strlen+0x26>
 1a2:	0505                	addi	a0,a0,1
 1a4:	87aa                	mv	a5,a0
 1a6:	4685                	li	a3,1
 1a8:	9e89                	subw	a3,a3,a0
 1aa:	00f6853b          	addw	a0,a3,a5
 1ae:	0785                	addi	a5,a5,1
 1b0:	fff7c703          	lbu	a4,-1(a5)
 1b4:	fb7d                	bnez	a4,1aa <strlen+0x14>
    ;
  return n;
}
 1b6:	6422                	ld	s0,8(sp)
 1b8:	0141                	addi	sp,sp,16
 1ba:	8082                	ret
  for(n = 0; s[n]; n++)
 1bc:	4501                	li	a0,0
 1be:	bfe5                	j	1b6 <strlen+0x20>

00000000000001c0 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1c0:	1141                	addi	sp,sp,-16
 1c2:	e422                	sd	s0,8(sp)
 1c4:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 1c6:	ca19                	beqz	a2,1dc <memset+0x1c>
 1c8:	87aa                	mv	a5,a0
 1ca:	1602                	slli	a2,a2,0x20
 1cc:	9201                	srli	a2,a2,0x20
 1ce:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 1d2:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 1d6:	0785                	addi	a5,a5,1
 1d8:	fee79de3          	bne	a5,a4,1d2 <memset+0x12>
  }
  return dst;
}
 1dc:	6422                	ld	s0,8(sp)
 1de:	0141                	addi	sp,sp,16
 1e0:	8082                	ret

00000000000001e2 <strchr>:

char*
strchr(const char *s, char c)
{
 1e2:	1141                	addi	sp,sp,-16
 1e4:	e422                	sd	s0,8(sp)
 1e6:	0800                	addi	s0,sp,16
  for(; *s; s++)
 1e8:	00054783          	lbu	a5,0(a0)
 1ec:	cb99                	beqz	a5,202 <strchr+0x20>
    if(*s == c)
 1ee:	00f58763          	beq	a1,a5,1fc <strchr+0x1a>
  for(; *s; s++)
 1f2:	0505                	addi	a0,a0,1
 1f4:	00054783          	lbu	a5,0(a0)
 1f8:	fbfd                	bnez	a5,1ee <strchr+0xc>
      return (char*)s;
  return 0;
 1fa:	4501                	li	a0,0
}
 1fc:	6422                	ld	s0,8(sp)
 1fe:	0141                	addi	sp,sp,16
 200:	8082                	ret
  return 0;
 202:	4501                	li	a0,0
 204:	bfe5                	j	1fc <strchr+0x1a>

0000000000000206 <gets>:

char*
gets(char *buf, int max)
{
 206:	711d                	addi	sp,sp,-96
 208:	ec86                	sd	ra,88(sp)
 20a:	e8a2                	sd	s0,80(sp)
 20c:	e4a6                	sd	s1,72(sp)
 20e:	e0ca                	sd	s2,64(sp)
 210:	fc4e                	sd	s3,56(sp)
 212:	f852                	sd	s4,48(sp)
 214:	f456                	sd	s5,40(sp)
 216:	f05a                	sd	s6,32(sp)
 218:	ec5e                	sd	s7,24(sp)
 21a:	1080                	addi	s0,sp,96
 21c:	8baa                	mv	s7,a0
 21e:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 220:	892a                	mv	s2,a0
 222:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 224:	4aa9                	li	s5,10
 226:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 228:	89a6                	mv	s3,s1
 22a:	2485                	addiw	s1,s1,1
 22c:	0344d863          	bge	s1,s4,25c <gets+0x56>
    cc = read(0, &c, 1);
 230:	4605                	li	a2,1
 232:	faf40593          	addi	a1,s0,-81
 236:	4501                	li	a0,0
 238:	00000097          	auipc	ra,0x0
 23c:	19a080e7          	jalr	410(ra) # 3d2 <read>
    if(cc < 1)
 240:	00a05e63          	blez	a0,25c <gets+0x56>
    buf[i++] = c;
 244:	faf44783          	lbu	a5,-81(s0)
 248:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 24c:	01578763          	beq	a5,s5,25a <gets+0x54>
 250:	0905                	addi	s2,s2,1
 252:	fd679be3          	bne	a5,s6,228 <gets+0x22>
  for(i=0; i+1 < max; ){
 256:	89a6                	mv	s3,s1
 258:	a011                	j	25c <gets+0x56>
 25a:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 25c:	99de                	add	s3,s3,s7
 25e:	00098023          	sb	zero,0(s3)
  return buf;
}
 262:	855e                	mv	a0,s7
 264:	60e6                	ld	ra,88(sp)
 266:	6446                	ld	s0,80(sp)
 268:	64a6                	ld	s1,72(sp)
 26a:	6906                	ld	s2,64(sp)
 26c:	79e2                	ld	s3,56(sp)
 26e:	7a42                	ld	s4,48(sp)
 270:	7aa2                	ld	s5,40(sp)
 272:	7b02                	ld	s6,32(sp)
 274:	6be2                	ld	s7,24(sp)
 276:	6125                	addi	sp,sp,96
 278:	8082                	ret

000000000000027a <stat>:

int
stat(const char *n, struct stat *st)
{
 27a:	1101                	addi	sp,sp,-32
 27c:	ec06                	sd	ra,24(sp)
 27e:	e822                	sd	s0,16(sp)
 280:	e426                	sd	s1,8(sp)
 282:	e04a                	sd	s2,0(sp)
 284:	1000                	addi	s0,sp,32
 286:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 288:	4581                	li	a1,0
 28a:	00000097          	auipc	ra,0x0
 28e:	170080e7          	jalr	368(ra) # 3fa <open>
  if(fd < 0)
 292:	02054563          	bltz	a0,2bc <stat+0x42>
 296:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 298:	85ca                	mv	a1,s2
 29a:	00000097          	auipc	ra,0x0
 29e:	178080e7          	jalr	376(ra) # 412 <fstat>
 2a2:	892a                	mv	s2,a0
  close(fd);
 2a4:	8526                	mv	a0,s1
 2a6:	00000097          	auipc	ra,0x0
 2aa:	13c080e7          	jalr	316(ra) # 3e2 <close>
  return r;
}
 2ae:	854a                	mv	a0,s2
 2b0:	60e2                	ld	ra,24(sp)
 2b2:	6442                	ld	s0,16(sp)
 2b4:	64a2                	ld	s1,8(sp)
 2b6:	6902                	ld	s2,0(sp)
 2b8:	6105                	addi	sp,sp,32
 2ba:	8082                	ret
    return -1;
 2bc:	597d                	li	s2,-1
 2be:	bfc5                	j	2ae <stat+0x34>

00000000000002c0 <atoi>:

int
atoi(const char *s)
{
 2c0:	1141                	addi	sp,sp,-16
 2c2:	e422                	sd	s0,8(sp)
 2c4:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2c6:	00054683          	lbu	a3,0(a0)
 2ca:	fd06879b          	addiw	a5,a3,-48
 2ce:	0ff7f793          	zext.b	a5,a5
 2d2:	4625                	li	a2,9
 2d4:	02f66863          	bltu	a2,a5,304 <atoi+0x44>
 2d8:	872a                	mv	a4,a0
  n = 0;
 2da:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 2dc:	0705                	addi	a4,a4,1
 2de:	0025179b          	slliw	a5,a0,0x2
 2e2:	9fa9                	addw	a5,a5,a0
 2e4:	0017979b          	slliw	a5,a5,0x1
 2e8:	9fb5                	addw	a5,a5,a3
 2ea:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 2ee:	00074683          	lbu	a3,0(a4)
 2f2:	fd06879b          	addiw	a5,a3,-48
 2f6:	0ff7f793          	zext.b	a5,a5
 2fa:	fef671e3          	bgeu	a2,a5,2dc <atoi+0x1c>
  return n;
}
 2fe:	6422                	ld	s0,8(sp)
 300:	0141                	addi	sp,sp,16
 302:	8082                	ret
  n = 0;
 304:	4501                	li	a0,0
 306:	bfe5                	j	2fe <atoi+0x3e>

0000000000000308 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 308:	1141                	addi	sp,sp,-16
 30a:	e422                	sd	s0,8(sp)
 30c:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 30e:	02b57463          	bgeu	a0,a1,336 <memmove+0x2e>
    while(n-- > 0)
 312:	00c05f63          	blez	a2,330 <memmove+0x28>
 316:	1602                	slli	a2,a2,0x20
 318:	9201                	srli	a2,a2,0x20
 31a:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 31e:	872a                	mv	a4,a0
      *dst++ = *src++;
 320:	0585                	addi	a1,a1,1
 322:	0705                	addi	a4,a4,1
 324:	fff5c683          	lbu	a3,-1(a1)
 328:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 32c:	fee79ae3          	bne	a5,a4,320 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 330:	6422                	ld	s0,8(sp)
 332:	0141                	addi	sp,sp,16
 334:	8082                	ret
    dst += n;
 336:	00c50733          	add	a4,a0,a2
    src += n;
 33a:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 33c:	fec05ae3          	blez	a2,330 <memmove+0x28>
 340:	fff6079b          	addiw	a5,a2,-1
 344:	1782                	slli	a5,a5,0x20
 346:	9381                	srli	a5,a5,0x20
 348:	fff7c793          	not	a5,a5
 34c:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 34e:	15fd                	addi	a1,a1,-1
 350:	177d                	addi	a4,a4,-1
 352:	0005c683          	lbu	a3,0(a1)
 356:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 35a:	fee79ae3          	bne	a5,a4,34e <memmove+0x46>
 35e:	bfc9                	j	330 <memmove+0x28>

0000000000000360 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 360:	1141                	addi	sp,sp,-16
 362:	e422                	sd	s0,8(sp)
 364:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 366:	ca05                	beqz	a2,396 <memcmp+0x36>
 368:	fff6069b          	addiw	a3,a2,-1
 36c:	1682                	slli	a3,a3,0x20
 36e:	9281                	srli	a3,a3,0x20
 370:	0685                	addi	a3,a3,1
 372:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 374:	00054783          	lbu	a5,0(a0)
 378:	0005c703          	lbu	a4,0(a1)
 37c:	00e79863          	bne	a5,a4,38c <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 380:	0505                	addi	a0,a0,1
    p2++;
 382:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 384:	fed518e3          	bne	a0,a3,374 <memcmp+0x14>
  }
  return 0;
 388:	4501                	li	a0,0
 38a:	a019                	j	390 <memcmp+0x30>
      return *p1 - *p2;
 38c:	40e7853b          	subw	a0,a5,a4
}
 390:	6422                	ld	s0,8(sp)
 392:	0141                	addi	sp,sp,16
 394:	8082                	ret
  return 0;
 396:	4501                	li	a0,0
 398:	bfe5                	j	390 <memcmp+0x30>

000000000000039a <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 39a:	1141                	addi	sp,sp,-16
 39c:	e406                	sd	ra,8(sp)
 39e:	e022                	sd	s0,0(sp)
 3a0:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 3a2:	00000097          	auipc	ra,0x0
 3a6:	f66080e7          	jalr	-154(ra) # 308 <memmove>
}
 3aa:	60a2                	ld	ra,8(sp)
 3ac:	6402                	ld	s0,0(sp)
 3ae:	0141                	addi	sp,sp,16
 3b0:	8082                	ret

00000000000003b2 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 3b2:	4885                	li	a7,1
 ecall
 3b4:	00000073          	ecall
 ret
 3b8:	8082                	ret

00000000000003ba <exit>:
.global exit
exit:
 li a7, SYS_exit
 3ba:	4889                	li	a7,2
 ecall
 3bc:	00000073          	ecall
 ret
 3c0:	8082                	ret

00000000000003c2 <wait>:
.global wait
wait:
 li a7, SYS_wait
 3c2:	488d                	li	a7,3
 ecall
 3c4:	00000073          	ecall
 ret
 3c8:	8082                	ret

00000000000003ca <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 3ca:	4891                	li	a7,4
 ecall
 3cc:	00000073          	ecall
 ret
 3d0:	8082                	ret

00000000000003d2 <read>:
.global read
read:
 li a7, SYS_read
 3d2:	4895                	li	a7,5
 ecall
 3d4:	00000073          	ecall
 ret
 3d8:	8082                	ret

00000000000003da <write>:
.global write
write:
 li a7, SYS_write
 3da:	48c1                	li	a7,16
 ecall
 3dc:	00000073          	ecall
 ret
 3e0:	8082                	ret

00000000000003e2 <close>:
.global close
close:
 li a7, SYS_close
 3e2:	48d5                	li	a7,21
 ecall
 3e4:	00000073          	ecall
 ret
 3e8:	8082                	ret

00000000000003ea <kill>:
.global kill
kill:
 li a7, SYS_kill
 3ea:	4899                	li	a7,6
 ecall
 3ec:	00000073          	ecall
 ret
 3f0:	8082                	ret

00000000000003f2 <exec>:
.global exec
exec:
 li a7, SYS_exec
 3f2:	489d                	li	a7,7
 ecall
 3f4:	00000073          	ecall
 ret
 3f8:	8082                	ret

00000000000003fa <open>:
.global open
open:
 li a7, SYS_open
 3fa:	48bd                	li	a7,15
 ecall
 3fc:	00000073          	ecall
 ret
 400:	8082                	ret

0000000000000402 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 402:	48c5                	li	a7,17
 ecall
 404:	00000073          	ecall
 ret
 408:	8082                	ret

000000000000040a <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 40a:	48c9                	li	a7,18
 ecall
 40c:	00000073          	ecall
 ret
 410:	8082                	ret

0000000000000412 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 412:	48a1                	li	a7,8
 ecall
 414:	00000073          	ecall
 ret
 418:	8082                	ret

000000000000041a <link>:
.global link
link:
 li a7, SYS_link
 41a:	48cd                	li	a7,19
 ecall
 41c:	00000073          	ecall
 ret
 420:	8082                	ret

0000000000000422 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 422:	48d1                	li	a7,20
 ecall
 424:	00000073          	ecall
 ret
 428:	8082                	ret

000000000000042a <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 42a:	48a5                	li	a7,9
 ecall
 42c:	00000073          	ecall
 ret
 430:	8082                	ret

0000000000000432 <dup>:
.global dup
dup:
 li a7, SYS_dup
 432:	48a9                	li	a7,10
 ecall
 434:	00000073          	ecall
 ret
 438:	8082                	ret

000000000000043a <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 43a:	48ad                	li	a7,11
 ecall
 43c:	00000073          	ecall
 ret
 440:	8082                	ret

0000000000000442 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 442:	48b1                	li	a7,12
 ecall
 444:	00000073          	ecall
 ret
 448:	8082                	ret

000000000000044a <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 44a:	48b5                	li	a7,13
 ecall
 44c:	00000073          	ecall
 ret
 450:	8082                	ret

0000000000000452 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 452:	48b9                	li	a7,14
 ecall
 454:	00000073          	ecall
 ret
 458:	8082                	ret

000000000000045a <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 45a:	1101                	addi	sp,sp,-32
 45c:	ec06                	sd	ra,24(sp)
 45e:	e822                	sd	s0,16(sp)
 460:	1000                	addi	s0,sp,32
 462:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 466:	4605                	li	a2,1
 468:	fef40593          	addi	a1,s0,-17
 46c:	00000097          	auipc	ra,0x0
 470:	f6e080e7          	jalr	-146(ra) # 3da <write>
}
 474:	60e2                	ld	ra,24(sp)
 476:	6442                	ld	s0,16(sp)
 478:	6105                	addi	sp,sp,32
 47a:	8082                	ret

000000000000047c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 47c:	7139                	addi	sp,sp,-64
 47e:	fc06                	sd	ra,56(sp)
 480:	f822                	sd	s0,48(sp)
 482:	f426                	sd	s1,40(sp)
 484:	f04a                	sd	s2,32(sp)
 486:	ec4e                	sd	s3,24(sp)
 488:	0080                	addi	s0,sp,64
 48a:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 48c:	c299                	beqz	a3,492 <printint+0x16>
 48e:	0805c963          	bltz	a1,520 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 492:	2581                	sext.w	a1,a1
  neg = 0;
 494:	4881                	li	a7,0
 496:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 49a:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 49c:	2601                	sext.w	a2,a2
 49e:	00000517          	auipc	a0,0x0
 4a2:	4aa50513          	addi	a0,a0,1194 # 948 <digits>
 4a6:	883a                	mv	a6,a4
 4a8:	2705                	addiw	a4,a4,1
 4aa:	02c5f7bb          	remuw	a5,a1,a2
 4ae:	1782                	slli	a5,a5,0x20
 4b0:	9381                	srli	a5,a5,0x20
 4b2:	97aa                	add	a5,a5,a0
 4b4:	0007c783          	lbu	a5,0(a5)
 4b8:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 4bc:	0005879b          	sext.w	a5,a1
 4c0:	02c5d5bb          	divuw	a1,a1,a2
 4c4:	0685                	addi	a3,a3,1
 4c6:	fec7f0e3          	bgeu	a5,a2,4a6 <printint+0x2a>
  if(neg)
 4ca:	00088c63          	beqz	a7,4e2 <printint+0x66>
    buf[i++] = '-';
 4ce:	fd070793          	addi	a5,a4,-48
 4d2:	00878733          	add	a4,a5,s0
 4d6:	02d00793          	li	a5,45
 4da:	fef70823          	sb	a5,-16(a4)
 4de:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 4e2:	02e05863          	blez	a4,512 <printint+0x96>
 4e6:	fc040793          	addi	a5,s0,-64
 4ea:	00e78933          	add	s2,a5,a4
 4ee:	fff78993          	addi	s3,a5,-1
 4f2:	99ba                	add	s3,s3,a4
 4f4:	377d                	addiw	a4,a4,-1
 4f6:	1702                	slli	a4,a4,0x20
 4f8:	9301                	srli	a4,a4,0x20
 4fa:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 4fe:	fff94583          	lbu	a1,-1(s2)
 502:	8526                	mv	a0,s1
 504:	00000097          	auipc	ra,0x0
 508:	f56080e7          	jalr	-170(ra) # 45a <putc>
  while(--i >= 0)
 50c:	197d                	addi	s2,s2,-1
 50e:	ff3918e3          	bne	s2,s3,4fe <printint+0x82>
}
 512:	70e2                	ld	ra,56(sp)
 514:	7442                	ld	s0,48(sp)
 516:	74a2                	ld	s1,40(sp)
 518:	7902                	ld	s2,32(sp)
 51a:	69e2                	ld	s3,24(sp)
 51c:	6121                	addi	sp,sp,64
 51e:	8082                	ret
    x = -xx;
 520:	40b005bb          	negw	a1,a1
    neg = 1;
 524:	4885                	li	a7,1
    x = -xx;
 526:	bf85                	j	496 <printint+0x1a>

0000000000000528 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 528:	7119                	addi	sp,sp,-128
 52a:	fc86                	sd	ra,120(sp)
 52c:	f8a2                	sd	s0,112(sp)
 52e:	f4a6                	sd	s1,104(sp)
 530:	f0ca                	sd	s2,96(sp)
 532:	ecce                	sd	s3,88(sp)
 534:	e8d2                	sd	s4,80(sp)
 536:	e4d6                	sd	s5,72(sp)
 538:	e0da                	sd	s6,64(sp)
 53a:	fc5e                	sd	s7,56(sp)
 53c:	f862                	sd	s8,48(sp)
 53e:	f466                	sd	s9,40(sp)
 540:	f06a                	sd	s10,32(sp)
 542:	ec6e                	sd	s11,24(sp)
 544:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 546:	0005c903          	lbu	s2,0(a1)
 54a:	18090f63          	beqz	s2,6e8 <vprintf+0x1c0>
 54e:	8aaa                	mv	s5,a0
 550:	8b32                	mv	s6,a2
 552:	00158493          	addi	s1,a1,1
  state = 0;
 556:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 558:	02500a13          	li	s4,37
 55c:	4c55                	li	s8,21
 55e:	00000c97          	auipc	s9,0x0
 562:	392c8c93          	addi	s9,s9,914 # 8f0 <malloc+0x104>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
        s = va_arg(ap, char*);
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 566:	02800d93          	li	s11,40
  putc(fd, 'x');
 56a:	4d41                	li	s10,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 56c:	00000b97          	auipc	s7,0x0
 570:	3dcb8b93          	addi	s7,s7,988 # 948 <digits>
 574:	a839                	j	592 <vprintf+0x6a>
        putc(fd, c);
 576:	85ca                	mv	a1,s2
 578:	8556                	mv	a0,s5
 57a:	00000097          	auipc	ra,0x0
 57e:	ee0080e7          	jalr	-288(ra) # 45a <putc>
 582:	a019                	j	588 <vprintf+0x60>
    } else if(state == '%'){
 584:	01498d63          	beq	s3,s4,59e <vprintf+0x76>
  for(i = 0; fmt[i]; i++){
 588:	0485                	addi	s1,s1,1
 58a:	fff4c903          	lbu	s2,-1(s1)
 58e:	14090d63          	beqz	s2,6e8 <vprintf+0x1c0>
    if(state == 0){
 592:	fe0999e3          	bnez	s3,584 <vprintf+0x5c>
      if(c == '%'){
 596:	ff4910e3          	bne	s2,s4,576 <vprintf+0x4e>
        state = '%';
 59a:	89d2                	mv	s3,s4
 59c:	b7f5                	j	588 <vprintf+0x60>
      if(c == 'd'){
 59e:	11490c63          	beq	s2,s4,6b6 <vprintf+0x18e>
 5a2:	f9d9079b          	addiw	a5,s2,-99
 5a6:	0ff7f793          	zext.b	a5,a5
 5aa:	10fc6e63          	bltu	s8,a5,6c6 <vprintf+0x19e>
 5ae:	f9d9079b          	addiw	a5,s2,-99
 5b2:	0ff7f713          	zext.b	a4,a5
 5b6:	10ec6863          	bltu	s8,a4,6c6 <vprintf+0x19e>
 5ba:	00271793          	slli	a5,a4,0x2
 5be:	97e6                	add	a5,a5,s9
 5c0:	439c                	lw	a5,0(a5)
 5c2:	97e6                	add	a5,a5,s9
 5c4:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 5c6:	008b0913          	addi	s2,s6,8
 5ca:	4685                	li	a3,1
 5cc:	4629                	li	a2,10
 5ce:	000b2583          	lw	a1,0(s6)
 5d2:	8556                	mv	a0,s5
 5d4:	00000097          	auipc	ra,0x0
 5d8:	ea8080e7          	jalr	-344(ra) # 47c <printint>
 5dc:	8b4a                	mv	s6,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 5de:	4981                	li	s3,0
 5e0:	b765                	j	588 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5e2:	008b0913          	addi	s2,s6,8
 5e6:	4681                	li	a3,0
 5e8:	4629                	li	a2,10
 5ea:	000b2583          	lw	a1,0(s6)
 5ee:	8556                	mv	a0,s5
 5f0:	00000097          	auipc	ra,0x0
 5f4:	e8c080e7          	jalr	-372(ra) # 47c <printint>
 5f8:	8b4a                	mv	s6,s2
      state = 0;
 5fa:	4981                	li	s3,0
 5fc:	b771                	j	588 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 5fe:	008b0913          	addi	s2,s6,8
 602:	4681                	li	a3,0
 604:	866a                	mv	a2,s10
 606:	000b2583          	lw	a1,0(s6)
 60a:	8556                	mv	a0,s5
 60c:	00000097          	auipc	ra,0x0
 610:	e70080e7          	jalr	-400(ra) # 47c <printint>
 614:	8b4a                	mv	s6,s2
      state = 0;
 616:	4981                	li	s3,0
 618:	bf85                	j	588 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 61a:	008b0793          	addi	a5,s6,8
 61e:	f8f43423          	sd	a5,-120(s0)
 622:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 626:	03000593          	li	a1,48
 62a:	8556                	mv	a0,s5
 62c:	00000097          	auipc	ra,0x0
 630:	e2e080e7          	jalr	-466(ra) # 45a <putc>
  putc(fd, 'x');
 634:	07800593          	li	a1,120
 638:	8556                	mv	a0,s5
 63a:	00000097          	auipc	ra,0x0
 63e:	e20080e7          	jalr	-480(ra) # 45a <putc>
 642:	896a                	mv	s2,s10
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 644:	03c9d793          	srli	a5,s3,0x3c
 648:	97de                	add	a5,a5,s7
 64a:	0007c583          	lbu	a1,0(a5)
 64e:	8556                	mv	a0,s5
 650:	00000097          	auipc	ra,0x0
 654:	e0a080e7          	jalr	-502(ra) # 45a <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 658:	0992                	slli	s3,s3,0x4
 65a:	397d                	addiw	s2,s2,-1
 65c:	fe0914e3          	bnez	s2,644 <vprintf+0x11c>
        printptr(fd, va_arg(ap, uint64));
 660:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 664:	4981                	li	s3,0
 666:	b70d                	j	588 <vprintf+0x60>
        s = va_arg(ap, char*);
 668:	008b0913          	addi	s2,s6,8
 66c:	000b3983          	ld	s3,0(s6)
        if(s == 0)
 670:	02098163          	beqz	s3,692 <vprintf+0x16a>
        while(*s != 0){
 674:	0009c583          	lbu	a1,0(s3)
 678:	c5ad                	beqz	a1,6e2 <vprintf+0x1ba>
          putc(fd, *s);
 67a:	8556                	mv	a0,s5
 67c:	00000097          	auipc	ra,0x0
 680:	dde080e7          	jalr	-546(ra) # 45a <putc>
          s++;
 684:	0985                	addi	s3,s3,1
        while(*s != 0){
 686:	0009c583          	lbu	a1,0(s3)
 68a:	f9e5                	bnez	a1,67a <vprintf+0x152>
        s = va_arg(ap, char*);
 68c:	8b4a                	mv	s6,s2
      state = 0;
 68e:	4981                	li	s3,0
 690:	bde5                	j	588 <vprintf+0x60>
          s = "(null)";
 692:	00000997          	auipc	s3,0x0
 696:	25698993          	addi	s3,s3,598 # 8e8 <malloc+0xfc>
        while(*s != 0){
 69a:	85ee                	mv	a1,s11
 69c:	bff9                	j	67a <vprintf+0x152>
        putc(fd, va_arg(ap, uint));
 69e:	008b0913          	addi	s2,s6,8
 6a2:	000b4583          	lbu	a1,0(s6)
 6a6:	8556                	mv	a0,s5
 6a8:	00000097          	auipc	ra,0x0
 6ac:	db2080e7          	jalr	-590(ra) # 45a <putc>
 6b0:	8b4a                	mv	s6,s2
      state = 0;
 6b2:	4981                	li	s3,0
 6b4:	bdd1                	j	588 <vprintf+0x60>
        putc(fd, c);
 6b6:	85d2                	mv	a1,s4
 6b8:	8556                	mv	a0,s5
 6ba:	00000097          	auipc	ra,0x0
 6be:	da0080e7          	jalr	-608(ra) # 45a <putc>
      state = 0;
 6c2:	4981                	li	s3,0
 6c4:	b5d1                	j	588 <vprintf+0x60>
        putc(fd, '%');
 6c6:	85d2                	mv	a1,s4
 6c8:	8556                	mv	a0,s5
 6ca:	00000097          	auipc	ra,0x0
 6ce:	d90080e7          	jalr	-624(ra) # 45a <putc>
        putc(fd, c);
 6d2:	85ca                	mv	a1,s2
 6d4:	8556                	mv	a0,s5
 6d6:	00000097          	auipc	ra,0x0
 6da:	d84080e7          	jalr	-636(ra) # 45a <putc>
      state = 0;
 6de:	4981                	li	s3,0
 6e0:	b565                	j	588 <vprintf+0x60>
        s = va_arg(ap, char*);
 6e2:	8b4a                	mv	s6,s2
      state = 0;
 6e4:	4981                	li	s3,0
 6e6:	b54d                	j	588 <vprintf+0x60>
    }
  }
}
 6e8:	70e6                	ld	ra,120(sp)
 6ea:	7446                	ld	s0,112(sp)
 6ec:	74a6                	ld	s1,104(sp)
 6ee:	7906                	ld	s2,96(sp)
 6f0:	69e6                	ld	s3,88(sp)
 6f2:	6a46                	ld	s4,80(sp)
 6f4:	6aa6                	ld	s5,72(sp)
 6f6:	6b06                	ld	s6,64(sp)
 6f8:	7be2                	ld	s7,56(sp)
 6fa:	7c42                	ld	s8,48(sp)
 6fc:	7ca2                	ld	s9,40(sp)
 6fe:	7d02                	ld	s10,32(sp)
 700:	6de2                	ld	s11,24(sp)
 702:	6109                	addi	sp,sp,128
 704:	8082                	ret

0000000000000706 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 706:	715d                	addi	sp,sp,-80
 708:	ec06                	sd	ra,24(sp)
 70a:	e822                	sd	s0,16(sp)
 70c:	1000                	addi	s0,sp,32
 70e:	e010                	sd	a2,0(s0)
 710:	e414                	sd	a3,8(s0)
 712:	e818                	sd	a4,16(s0)
 714:	ec1c                	sd	a5,24(s0)
 716:	03043023          	sd	a6,32(s0)
 71a:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 71e:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 722:	8622                	mv	a2,s0
 724:	00000097          	auipc	ra,0x0
 728:	e04080e7          	jalr	-508(ra) # 528 <vprintf>
}
 72c:	60e2                	ld	ra,24(sp)
 72e:	6442                	ld	s0,16(sp)
 730:	6161                	addi	sp,sp,80
 732:	8082                	ret

0000000000000734 <printf>:

void
printf(const char *fmt, ...)
{
 734:	711d                	addi	sp,sp,-96
 736:	ec06                	sd	ra,24(sp)
 738:	e822                	sd	s0,16(sp)
 73a:	1000                	addi	s0,sp,32
 73c:	e40c                	sd	a1,8(s0)
 73e:	e810                	sd	a2,16(s0)
 740:	ec14                	sd	a3,24(s0)
 742:	f018                	sd	a4,32(s0)
 744:	f41c                	sd	a5,40(s0)
 746:	03043823          	sd	a6,48(s0)
 74a:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 74e:	00840613          	addi	a2,s0,8
 752:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 756:	85aa                	mv	a1,a0
 758:	4505                	li	a0,1
 75a:	00000097          	auipc	ra,0x0
 75e:	dce080e7          	jalr	-562(ra) # 528 <vprintf>
}
 762:	60e2                	ld	ra,24(sp)
 764:	6442                	ld	s0,16(sp)
 766:	6125                	addi	sp,sp,96
 768:	8082                	ret

000000000000076a <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 76a:	1141                	addi	sp,sp,-16
 76c:	e422                	sd	s0,8(sp)
 76e:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 770:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 774:	00000797          	auipc	a5,0x0
 778:	1ec7b783          	ld	a5,492(a5) # 960 <freep>
 77c:	a02d                	j	7a6 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 77e:	4618                	lw	a4,8(a2)
 780:	9f2d                	addw	a4,a4,a1
 782:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 786:	6398                	ld	a4,0(a5)
 788:	6310                	ld	a2,0(a4)
 78a:	a83d                	j	7c8 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 78c:	ff852703          	lw	a4,-8(a0)
 790:	9f31                	addw	a4,a4,a2
 792:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 794:	ff053683          	ld	a3,-16(a0)
 798:	a091                	j	7dc <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 79a:	6398                	ld	a4,0(a5)
 79c:	00e7e463          	bltu	a5,a4,7a4 <free+0x3a>
 7a0:	00e6ea63          	bltu	a3,a4,7b4 <free+0x4a>
{
 7a4:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7a6:	fed7fae3          	bgeu	a5,a3,79a <free+0x30>
 7aa:	6398                	ld	a4,0(a5)
 7ac:	00e6e463          	bltu	a3,a4,7b4 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7b0:	fee7eae3          	bltu	a5,a4,7a4 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 7b4:	ff852583          	lw	a1,-8(a0)
 7b8:	6390                	ld	a2,0(a5)
 7ba:	02059813          	slli	a6,a1,0x20
 7be:	01c85713          	srli	a4,a6,0x1c
 7c2:	9736                	add	a4,a4,a3
 7c4:	fae60de3          	beq	a2,a4,77e <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 7c8:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 7cc:	4790                	lw	a2,8(a5)
 7ce:	02061593          	slli	a1,a2,0x20
 7d2:	01c5d713          	srli	a4,a1,0x1c
 7d6:	973e                	add	a4,a4,a5
 7d8:	fae68ae3          	beq	a3,a4,78c <free+0x22>
    p->s.ptr = bp->s.ptr;
 7dc:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 7de:	00000717          	auipc	a4,0x0
 7e2:	18f73123          	sd	a5,386(a4) # 960 <freep>
}
 7e6:	6422                	ld	s0,8(sp)
 7e8:	0141                	addi	sp,sp,16
 7ea:	8082                	ret

00000000000007ec <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 7ec:	7139                	addi	sp,sp,-64
 7ee:	fc06                	sd	ra,56(sp)
 7f0:	f822                	sd	s0,48(sp)
 7f2:	f426                	sd	s1,40(sp)
 7f4:	f04a                	sd	s2,32(sp)
 7f6:	ec4e                	sd	s3,24(sp)
 7f8:	e852                	sd	s4,16(sp)
 7fa:	e456                	sd	s5,8(sp)
 7fc:	e05a                	sd	s6,0(sp)
 7fe:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 800:	02051493          	slli	s1,a0,0x20
 804:	9081                	srli	s1,s1,0x20
 806:	04bd                	addi	s1,s1,15
 808:	8091                	srli	s1,s1,0x4
 80a:	0014899b          	addiw	s3,s1,1
 80e:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 810:	00000517          	auipc	a0,0x0
 814:	15053503          	ld	a0,336(a0) # 960 <freep>
 818:	c515                	beqz	a0,844 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 81a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 81c:	4798                	lw	a4,8(a5)
 81e:	02977f63          	bgeu	a4,s1,85c <malloc+0x70>
 822:	8a4e                	mv	s4,s3
 824:	0009871b          	sext.w	a4,s3
 828:	6685                	lui	a3,0x1
 82a:	00d77363          	bgeu	a4,a3,830 <malloc+0x44>
 82e:	6a05                	lui	s4,0x1
 830:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 834:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 838:	00000917          	auipc	s2,0x0
 83c:	12890913          	addi	s2,s2,296 # 960 <freep>
  if(p == (char*)-1)
 840:	5afd                	li	s5,-1
 842:	a895                	j	8b6 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 844:	00000797          	auipc	a5,0x0
 848:	12478793          	addi	a5,a5,292 # 968 <base>
 84c:	00000717          	auipc	a4,0x0
 850:	10f73a23          	sd	a5,276(a4) # 960 <freep>
 854:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 856:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 85a:	b7e1                	j	822 <malloc+0x36>
      if(p->s.size == nunits)
 85c:	02e48c63          	beq	s1,a4,894 <malloc+0xa8>
        p->s.size -= nunits;
 860:	4137073b          	subw	a4,a4,s3
 864:	c798                	sw	a4,8(a5)
        p += p->s.size;
 866:	02071693          	slli	a3,a4,0x20
 86a:	01c6d713          	srli	a4,a3,0x1c
 86e:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 870:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 874:	00000717          	auipc	a4,0x0
 878:	0ea73623          	sd	a0,236(a4) # 960 <freep>
      return (void*)(p + 1);
 87c:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 880:	70e2                	ld	ra,56(sp)
 882:	7442                	ld	s0,48(sp)
 884:	74a2                	ld	s1,40(sp)
 886:	7902                	ld	s2,32(sp)
 888:	69e2                	ld	s3,24(sp)
 88a:	6a42                	ld	s4,16(sp)
 88c:	6aa2                	ld	s5,8(sp)
 88e:	6b02                	ld	s6,0(sp)
 890:	6121                	addi	sp,sp,64
 892:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 894:	6398                	ld	a4,0(a5)
 896:	e118                	sd	a4,0(a0)
 898:	bff1                	j	874 <malloc+0x88>
  hp->s.size = nu;
 89a:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 89e:	0541                	addi	a0,a0,16
 8a0:	00000097          	auipc	ra,0x0
 8a4:	eca080e7          	jalr	-310(ra) # 76a <free>
  return freep;
 8a8:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 8ac:	d971                	beqz	a0,880 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8ae:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8b0:	4798                	lw	a4,8(a5)
 8b2:	fa9775e3          	bgeu	a4,s1,85c <malloc+0x70>
    if(p == freep)
 8b6:	00093703          	ld	a4,0(s2)
 8ba:	853e                	mv	a0,a5
 8bc:	fef719e3          	bne	a4,a5,8ae <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 8c0:	8552                	mv	a0,s4
 8c2:	00000097          	auipc	ra,0x0
 8c6:	b80080e7          	jalr	-1152(ra) # 442 <sbrk>
  if(p == (char*)-1)
 8ca:	fd5518e3          	bne	a0,s5,89a <malloc+0xae>
        return 0;
 8ce:	4501                	li	a0,0
 8d0:	bf45                	j	880 <malloc+0x94>


user/_find：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000000000000 <fmt_name>:
#include "user/user.h"

/*
	将路径格式化为文件名
*/
char* fmt_name(char *path){
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	e04a                	sd	s2,0(sp)
   a:	1000                	addi	s0,sp,32
   c:	84aa                	mv	s1,a0
  static char buf[DIRSIZ+1];
  char *p;

  // Find first character after last slash.
  for(p=path+strlen(path); p >= path && *p != '/'; p--);
   e:	00000097          	auipc	ra,0x0
  12:	2e2080e7          	jalr	738(ra) # 2f0 <strlen>
  16:	02051593          	slli	a1,a0,0x20
  1a:	9181                	srli	a1,a1,0x20
  1c:	95a6                	add	a1,a1,s1
  1e:	02f00713          	li	a4,47
  22:	0095e963          	bltu	a1,s1,34 <fmt_name+0x34>
  26:	0005c783          	lbu	a5,0(a1)
  2a:	00e78563          	beq	a5,a4,34 <fmt_name+0x34>
  2e:	15fd                	addi	a1,a1,-1
  30:	fe95fbe3          	bgeu	a1,s1,26 <fmt_name+0x26>
  p++;
  34:	00158493          	addi	s1,a1,1
  memmove(buf, p, strlen(p)+1);
  38:	8526                	mv	a0,s1
  3a:	00000097          	auipc	ra,0x0
  3e:	2b6080e7          	jalr	694(ra) # 2f0 <strlen>
  42:	00001917          	auipc	s2,0x1
  46:	aee90913          	addi	s2,s2,-1298 # b30 <buf.0>
  4a:	0015061b          	addiw	a2,a0,1
  4e:	85a6                	mv	a1,s1
  50:	854a                	mv	a0,s2
  52:	00000097          	auipc	ra,0x0
  56:	410080e7          	jalr	1040(ra) # 462 <memmove>
  return buf;
}
  5a:	854a                	mv	a0,s2
  5c:	60e2                	ld	ra,24(sp)
  5e:	6442                	ld	s0,16(sp)
  60:	64a2                	ld	s1,8(sp)
  62:	6902                	ld	s2,0(sp)
  64:	6105                	addi	sp,sp,32
  66:	8082                	ret

0000000000000068 <eq_print>:
/*
	系统文件名与要查找的文件名，若一致，打印系统文件完整路径
*/
void eq_print(char *fileName, char *findName){
  68:	1101                	addi	sp,sp,-32
  6a:	ec06                	sd	ra,24(sp)
  6c:	e822                	sd	s0,16(sp)
  6e:	e426                	sd	s1,8(sp)
  70:	e04a                	sd	s2,0(sp)
  72:	1000                	addi	s0,sp,32
  74:	892a                	mv	s2,a0
  76:	84ae                	mv	s1,a1
	if(strcmp(fmt_name(fileName), findName) == 0){
  78:	00000097          	auipc	ra,0x0
  7c:	f88080e7          	jalr	-120(ra) # 0 <fmt_name>
  80:	85a6                	mv	a1,s1
  82:	00000097          	auipc	ra,0x0
  86:	242080e7          	jalr	578(ra) # 2c4 <strcmp>
  8a:	c519                	beqz	a0,98 <eq_print+0x30>
		printf("%s\n", fileName);
	}
}
  8c:	60e2                	ld	ra,24(sp)
  8e:	6442                	ld	s0,16(sp)
  90:	64a2                	ld	s1,8(sp)
  92:	6902                	ld	s2,0(sp)
  94:	6105                	addi	sp,sp,32
  96:	8082                	ret
		printf("%s\n", fileName);
  98:	85ca                	mv	a1,s2
  9a:	00001517          	auipc	a0,0x1
  9e:	99650513          	addi	a0,a0,-1642 # a30 <malloc+0xea>
  a2:	00000097          	auipc	ra,0x0
  a6:	7ec080e7          	jalr	2028(ra) # 88e <printf>
}
  aa:	b7cd                	j	8c <eq_print+0x24>

00000000000000ac <find>:
/*
	在某路径中查找某文件
*/
void find(char *path, char *findName){
  ac:	d9010113          	addi	sp,sp,-624
  b0:	26113423          	sd	ra,616(sp)
  b4:	26813023          	sd	s0,608(sp)
  b8:	24913c23          	sd	s1,600(sp)
  bc:	25213823          	sd	s2,592(sp)
  c0:	25313423          	sd	s3,584(sp)
  c4:	25413023          	sd	s4,576(sp)
  c8:	23513c23          	sd	s5,568(sp)
  cc:	23613823          	sd	s6,560(sp)
  d0:	1c80                	addi	s0,sp,624
  d2:	892a                	mv	s2,a0
  d4:	89ae                	mv	s3,a1
	int fd;
	struct stat st;	
	if((fd = open(path, O_RDONLY)) < 0){
  d6:	4581                	li	a1,0
  d8:	00000097          	auipc	ra,0x0
  dc:	47c080e7          	jalr	1148(ra) # 554 <open>
  e0:	06054363          	bltz	a0,146 <find+0x9a>
  e4:	84aa                	mv	s1,a0
		fprintf(2, "find: cannot open %s\n", path);
		return;
	}
	if(fstat(fd, &st) < 0){
  e6:	fa840593          	addi	a1,s0,-88
  ea:	00000097          	auipc	ra,0x0
  ee:	482080e7          	jalr	1154(ra) # 56c <fstat>
  f2:	06054563          	bltz	a0,15c <find+0xb0>
		close(fd);
		return;
	}
	char buf[512], *p;	
	struct dirent de;
	switch(st.type){	
  f6:	fb041783          	lh	a5,-80(s0)
  fa:	0007869b          	sext.w	a3,a5
  fe:	4705                	li	a4,1
 100:	06e68e63          	beq	a3,a4,17c <find+0xd0>
 104:	4709                	li	a4,2
 106:	00e69863          	bne	a3,a4,116 <find+0x6a>
		case T_FILE:
			eq_print(path, findName);			
 10a:	85ce                	mv	a1,s3
 10c:	854a                	mv	a0,s2
 10e:	00000097          	auipc	ra,0x0
 112:	f5a080e7          	jalr	-166(ra) # 68 <eq_print>
				p[strlen(de.name)] = 0;
				find(buf, findName);
			}
			break;
	}
	close(fd);	
 116:	8526                	mv	a0,s1
 118:	00000097          	auipc	ra,0x0
 11c:	424080e7          	jalr	1060(ra) # 53c <close>
}
 120:	26813083          	ld	ra,616(sp)
 124:	26013403          	ld	s0,608(sp)
 128:	25813483          	ld	s1,600(sp)
 12c:	25013903          	ld	s2,592(sp)
 130:	24813983          	ld	s3,584(sp)
 134:	24013a03          	ld	s4,576(sp)
 138:	23813a83          	ld	s5,568(sp)
 13c:	23013b03          	ld	s6,560(sp)
 140:	27010113          	addi	sp,sp,624
 144:	8082                	ret
		fprintf(2, "find: cannot open %s\n", path);
 146:	864a                	mv	a2,s2
 148:	00001597          	auipc	a1,0x1
 14c:	8f058593          	addi	a1,a1,-1808 # a38 <malloc+0xf2>
 150:	4509                	li	a0,2
 152:	00000097          	auipc	ra,0x0
 156:	70e080e7          	jalr	1806(ra) # 860 <fprintf>
		return;
 15a:	b7d9                	j	120 <find+0x74>
		fprintf(2, "find: cannot stat %s\n", path);
 15c:	864a                	mv	a2,s2
 15e:	00001597          	auipc	a1,0x1
 162:	8f258593          	addi	a1,a1,-1806 # a50 <malloc+0x10a>
 166:	4509                	li	a0,2
 168:	00000097          	auipc	ra,0x0
 16c:	6f8080e7          	jalr	1784(ra) # 860 <fprintf>
		close(fd);
 170:	8526                	mv	a0,s1
 172:	00000097          	auipc	ra,0x0
 176:	3ca080e7          	jalr	970(ra) # 53c <close>
		return;
 17a:	b75d                	j	120 <find+0x74>
			if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
 17c:	854a                	mv	a0,s2
 17e:	00000097          	auipc	ra,0x0
 182:	172080e7          	jalr	370(ra) # 2f0 <strlen>
 186:	2541                	addiw	a0,a0,16
 188:	20000793          	li	a5,512
 18c:	00a7fb63          	bgeu	a5,a0,1a2 <find+0xf6>
				printf("find: path too long\n");
 190:	00001517          	auipc	a0,0x1
 194:	8d850513          	addi	a0,a0,-1832 # a68 <malloc+0x122>
 198:	00000097          	auipc	ra,0x0
 19c:	6f6080e7          	jalr	1782(ra) # 88e <printf>
				break;
 1a0:	bf9d                	j	116 <find+0x6a>
			strcpy(buf, path);
 1a2:	85ca                	mv	a1,s2
 1a4:	da840513          	addi	a0,s0,-600
 1a8:	00000097          	auipc	ra,0x0
 1ac:	100080e7          	jalr	256(ra) # 2a8 <strcpy>
			p = buf+strlen(buf);
 1b0:	da840513          	addi	a0,s0,-600
 1b4:	00000097          	auipc	ra,0x0
 1b8:	13c080e7          	jalr	316(ra) # 2f0 <strlen>
 1bc:	1502                	slli	a0,a0,0x20
 1be:	9101                	srli	a0,a0,0x20
 1c0:	da840793          	addi	a5,s0,-600
 1c4:	97aa                	add	a5,a5,a0
			*p++ = '/';
 1c6:	00178a93          	addi	s5,a5,1
 1ca:	02f00713          	li	a4,47
 1ce:	00e78023          	sb	a4,0(a5)
				if(de.inum == 0 || de.inum == 1 || strcmp(de.name, ".")==0 || strcmp(de.name, "..")==0)
 1d2:	4905                	li	s2,1
 1d4:	00001a17          	auipc	s4,0x1
 1d8:	8aca0a13          	addi	s4,s4,-1876 # a80 <malloc+0x13a>
 1dc:	00001b17          	auipc	s6,0x1
 1e0:	8acb0b13          	addi	s6,s6,-1876 # a88 <malloc+0x142>
			while(read(fd, &de, sizeof(de)) == sizeof(de)){
 1e4:	4641                	li	a2,16
 1e6:	d9840593          	addi	a1,s0,-616
 1ea:	8526                	mv	a0,s1
 1ec:	00000097          	auipc	ra,0x0
 1f0:	340080e7          	jalr	832(ra) # 52c <read>
 1f4:	47c1                	li	a5,16
 1f6:	f2f510e3          	bne	a0,a5,116 <find+0x6a>
				if(de.inum == 0 || de.inum == 1 || strcmp(de.name, ".")==0 || strcmp(de.name, "..")==0)
 1fa:	d9845783          	lhu	a5,-616(s0)
 1fe:	fef973e3          	bgeu	s2,a5,1e4 <find+0x138>
 202:	85d2                	mv	a1,s4
 204:	d9a40513          	addi	a0,s0,-614
 208:	00000097          	auipc	ra,0x0
 20c:	0bc080e7          	jalr	188(ra) # 2c4 <strcmp>
 210:	d971                	beqz	a0,1e4 <find+0x138>
 212:	85da                	mv	a1,s6
 214:	d9a40513          	addi	a0,s0,-614
 218:	00000097          	auipc	ra,0x0
 21c:	0ac080e7          	jalr	172(ra) # 2c4 <strcmp>
 220:	d171                	beqz	a0,1e4 <find+0x138>
				memmove(p, de.name, strlen(de.name));
 222:	d9a40513          	addi	a0,s0,-614
 226:	00000097          	auipc	ra,0x0
 22a:	0ca080e7          	jalr	202(ra) # 2f0 <strlen>
 22e:	0005061b          	sext.w	a2,a0
 232:	d9a40593          	addi	a1,s0,-614
 236:	8556                	mv	a0,s5
 238:	00000097          	auipc	ra,0x0
 23c:	22a080e7          	jalr	554(ra) # 462 <memmove>
				p[strlen(de.name)] = 0;
 240:	d9a40513          	addi	a0,s0,-614
 244:	00000097          	auipc	ra,0x0
 248:	0ac080e7          	jalr	172(ra) # 2f0 <strlen>
 24c:	02051793          	slli	a5,a0,0x20
 250:	9381                	srli	a5,a5,0x20
 252:	97d6                	add	a5,a5,s5
 254:	00078023          	sb	zero,0(a5)
				find(buf, findName);
 258:	85ce                	mv	a1,s3
 25a:	da840513          	addi	a0,s0,-600
 25e:	00000097          	auipc	ra,0x0
 262:	e4e080e7          	jalr	-434(ra) # ac <find>
 266:	bfbd                	j	1e4 <find+0x138>

0000000000000268 <main>:

int main(int argc, char *argv[]){
 268:	1141                	addi	sp,sp,-16
 26a:	e406                	sd	ra,8(sp)
 26c:	e022                	sd	s0,0(sp)
 26e:	0800                	addi	s0,sp,16
	if(argc < 3){
 270:	4709                	li	a4,2
 272:	00a74f63          	blt	a4,a0,290 <main+0x28>
		printf("find: find <path> <fileName>\n");
 276:	00001517          	auipc	a0,0x1
 27a:	81a50513          	addi	a0,a0,-2022 # a90 <malloc+0x14a>
 27e:	00000097          	auipc	ra,0x0
 282:	610080e7          	jalr	1552(ra) # 88e <printf>
		exit(0);
 286:	4501                	li	a0,0
 288:	00000097          	auipc	ra,0x0
 28c:	28c080e7          	jalr	652(ra) # 514 <exit>
 290:	87ae                	mv	a5,a1
	}
	find(argv[1], argv[2]);
 292:	698c                	ld	a1,16(a1)
 294:	6788                	ld	a0,8(a5)
 296:	00000097          	auipc	ra,0x0
 29a:	e16080e7          	jalr	-490(ra) # ac <find>
	exit(0);
 29e:	4501                	li	a0,0
 2a0:	00000097          	auipc	ra,0x0
 2a4:	274080e7          	jalr	628(ra) # 514 <exit>

00000000000002a8 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 2a8:	1141                	addi	sp,sp,-16
 2aa:	e422                	sd	s0,8(sp)
 2ac:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 2ae:	87aa                	mv	a5,a0
 2b0:	0585                	addi	a1,a1,1
 2b2:	0785                	addi	a5,a5,1
 2b4:	fff5c703          	lbu	a4,-1(a1)
 2b8:	fee78fa3          	sb	a4,-1(a5)
 2bc:	fb75                	bnez	a4,2b0 <strcpy+0x8>
    ;
  return os;
}
 2be:	6422                	ld	s0,8(sp)
 2c0:	0141                	addi	sp,sp,16
 2c2:	8082                	ret

00000000000002c4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 2c4:	1141                	addi	sp,sp,-16
 2c6:	e422                	sd	s0,8(sp)
 2c8:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 2ca:	00054783          	lbu	a5,0(a0)
 2ce:	cb91                	beqz	a5,2e2 <strcmp+0x1e>
 2d0:	0005c703          	lbu	a4,0(a1)
 2d4:	00f71763          	bne	a4,a5,2e2 <strcmp+0x1e>
    p++, q++;
 2d8:	0505                	addi	a0,a0,1
 2da:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 2dc:	00054783          	lbu	a5,0(a0)
 2e0:	fbe5                	bnez	a5,2d0 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 2e2:	0005c503          	lbu	a0,0(a1)
}
 2e6:	40a7853b          	subw	a0,a5,a0
 2ea:	6422                	ld	s0,8(sp)
 2ec:	0141                	addi	sp,sp,16
 2ee:	8082                	ret

00000000000002f0 <strlen>:

uint
strlen(const char *s)
{
 2f0:	1141                	addi	sp,sp,-16
 2f2:	e422                	sd	s0,8(sp)
 2f4:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 2f6:	00054783          	lbu	a5,0(a0)
 2fa:	cf91                	beqz	a5,316 <strlen+0x26>
 2fc:	0505                	addi	a0,a0,1
 2fe:	87aa                	mv	a5,a0
 300:	4685                	li	a3,1
 302:	9e89                	subw	a3,a3,a0
 304:	00f6853b          	addw	a0,a3,a5
 308:	0785                	addi	a5,a5,1
 30a:	fff7c703          	lbu	a4,-1(a5)
 30e:	fb7d                	bnez	a4,304 <strlen+0x14>
    ;
  return n;
}
 310:	6422                	ld	s0,8(sp)
 312:	0141                	addi	sp,sp,16
 314:	8082                	ret
  for(n = 0; s[n]; n++)
 316:	4501                	li	a0,0
 318:	bfe5                	j	310 <strlen+0x20>

000000000000031a <memset>:

void*
memset(void *dst, int c, uint n)
{
 31a:	1141                	addi	sp,sp,-16
 31c:	e422                	sd	s0,8(sp)
 31e:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 320:	ca19                	beqz	a2,336 <memset+0x1c>
 322:	87aa                	mv	a5,a0
 324:	1602                	slli	a2,a2,0x20
 326:	9201                	srli	a2,a2,0x20
 328:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 32c:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 330:	0785                	addi	a5,a5,1
 332:	fee79de3          	bne	a5,a4,32c <memset+0x12>
  }
  return dst;
}
 336:	6422                	ld	s0,8(sp)
 338:	0141                	addi	sp,sp,16
 33a:	8082                	ret

000000000000033c <strchr>:

char*
strchr(const char *s, char c)
{
 33c:	1141                	addi	sp,sp,-16
 33e:	e422                	sd	s0,8(sp)
 340:	0800                	addi	s0,sp,16
  for(; *s; s++)
 342:	00054783          	lbu	a5,0(a0)
 346:	cb99                	beqz	a5,35c <strchr+0x20>
    if(*s == c)
 348:	00f58763          	beq	a1,a5,356 <strchr+0x1a>
  for(; *s; s++)
 34c:	0505                	addi	a0,a0,1
 34e:	00054783          	lbu	a5,0(a0)
 352:	fbfd                	bnez	a5,348 <strchr+0xc>
      return (char*)s;
  return 0;
 354:	4501                	li	a0,0
}
 356:	6422                	ld	s0,8(sp)
 358:	0141                	addi	sp,sp,16
 35a:	8082                	ret
  return 0;
 35c:	4501                	li	a0,0
 35e:	bfe5                	j	356 <strchr+0x1a>

0000000000000360 <gets>:

char*
gets(char *buf, int max)
{
 360:	711d                	addi	sp,sp,-96
 362:	ec86                	sd	ra,88(sp)
 364:	e8a2                	sd	s0,80(sp)
 366:	e4a6                	sd	s1,72(sp)
 368:	e0ca                	sd	s2,64(sp)
 36a:	fc4e                	sd	s3,56(sp)
 36c:	f852                	sd	s4,48(sp)
 36e:	f456                	sd	s5,40(sp)
 370:	f05a                	sd	s6,32(sp)
 372:	ec5e                	sd	s7,24(sp)
 374:	1080                	addi	s0,sp,96
 376:	8baa                	mv	s7,a0
 378:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 37a:	892a                	mv	s2,a0
 37c:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 37e:	4aa9                	li	s5,10
 380:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 382:	89a6                	mv	s3,s1
 384:	2485                	addiw	s1,s1,1
 386:	0344d863          	bge	s1,s4,3b6 <gets+0x56>
    cc = read(0, &c, 1);
 38a:	4605                	li	a2,1
 38c:	faf40593          	addi	a1,s0,-81
 390:	4501                	li	a0,0
 392:	00000097          	auipc	ra,0x0
 396:	19a080e7          	jalr	410(ra) # 52c <read>
    if(cc < 1)
 39a:	00a05e63          	blez	a0,3b6 <gets+0x56>
    buf[i++] = c;
 39e:	faf44783          	lbu	a5,-81(s0)
 3a2:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 3a6:	01578763          	beq	a5,s5,3b4 <gets+0x54>
 3aa:	0905                	addi	s2,s2,1
 3ac:	fd679be3          	bne	a5,s6,382 <gets+0x22>
  for(i=0; i+1 < max; ){
 3b0:	89a6                	mv	s3,s1
 3b2:	a011                	j	3b6 <gets+0x56>
 3b4:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 3b6:	99de                	add	s3,s3,s7
 3b8:	00098023          	sb	zero,0(s3)
  return buf;
}
 3bc:	855e                	mv	a0,s7
 3be:	60e6                	ld	ra,88(sp)
 3c0:	6446                	ld	s0,80(sp)
 3c2:	64a6                	ld	s1,72(sp)
 3c4:	6906                	ld	s2,64(sp)
 3c6:	79e2                	ld	s3,56(sp)
 3c8:	7a42                	ld	s4,48(sp)
 3ca:	7aa2                	ld	s5,40(sp)
 3cc:	7b02                	ld	s6,32(sp)
 3ce:	6be2                	ld	s7,24(sp)
 3d0:	6125                	addi	sp,sp,96
 3d2:	8082                	ret

00000000000003d4 <stat>:

int
stat(const char *n, struct stat *st)
{
 3d4:	1101                	addi	sp,sp,-32
 3d6:	ec06                	sd	ra,24(sp)
 3d8:	e822                	sd	s0,16(sp)
 3da:	e426                	sd	s1,8(sp)
 3dc:	e04a                	sd	s2,0(sp)
 3de:	1000                	addi	s0,sp,32
 3e0:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 3e2:	4581                	li	a1,0
 3e4:	00000097          	auipc	ra,0x0
 3e8:	170080e7          	jalr	368(ra) # 554 <open>
  if(fd < 0)
 3ec:	02054563          	bltz	a0,416 <stat+0x42>
 3f0:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 3f2:	85ca                	mv	a1,s2
 3f4:	00000097          	auipc	ra,0x0
 3f8:	178080e7          	jalr	376(ra) # 56c <fstat>
 3fc:	892a                	mv	s2,a0
  close(fd);
 3fe:	8526                	mv	a0,s1
 400:	00000097          	auipc	ra,0x0
 404:	13c080e7          	jalr	316(ra) # 53c <close>
  return r;
}
 408:	854a                	mv	a0,s2
 40a:	60e2                	ld	ra,24(sp)
 40c:	6442                	ld	s0,16(sp)
 40e:	64a2                	ld	s1,8(sp)
 410:	6902                	ld	s2,0(sp)
 412:	6105                	addi	sp,sp,32
 414:	8082                	ret
    return -1;
 416:	597d                	li	s2,-1
 418:	bfc5                	j	408 <stat+0x34>

000000000000041a <atoi>:

int
atoi(const char *s)
{
 41a:	1141                	addi	sp,sp,-16
 41c:	e422                	sd	s0,8(sp)
 41e:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 420:	00054683          	lbu	a3,0(a0)
 424:	fd06879b          	addiw	a5,a3,-48
 428:	0ff7f793          	zext.b	a5,a5
 42c:	4625                	li	a2,9
 42e:	02f66863          	bltu	a2,a5,45e <atoi+0x44>
 432:	872a                	mv	a4,a0
  n = 0;
 434:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 436:	0705                	addi	a4,a4,1
 438:	0025179b          	slliw	a5,a0,0x2
 43c:	9fa9                	addw	a5,a5,a0
 43e:	0017979b          	slliw	a5,a5,0x1
 442:	9fb5                	addw	a5,a5,a3
 444:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 448:	00074683          	lbu	a3,0(a4)
 44c:	fd06879b          	addiw	a5,a3,-48
 450:	0ff7f793          	zext.b	a5,a5
 454:	fef671e3          	bgeu	a2,a5,436 <atoi+0x1c>
  return n;
}
 458:	6422                	ld	s0,8(sp)
 45a:	0141                	addi	sp,sp,16
 45c:	8082                	ret
  n = 0;
 45e:	4501                	li	a0,0
 460:	bfe5                	j	458 <atoi+0x3e>

0000000000000462 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 462:	1141                	addi	sp,sp,-16
 464:	e422                	sd	s0,8(sp)
 466:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 468:	02b57463          	bgeu	a0,a1,490 <memmove+0x2e>
    while(n-- > 0)
 46c:	00c05f63          	blez	a2,48a <memmove+0x28>
 470:	1602                	slli	a2,a2,0x20
 472:	9201                	srli	a2,a2,0x20
 474:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 478:	872a                	mv	a4,a0
      *dst++ = *src++;
 47a:	0585                	addi	a1,a1,1
 47c:	0705                	addi	a4,a4,1
 47e:	fff5c683          	lbu	a3,-1(a1)
 482:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 486:	fee79ae3          	bne	a5,a4,47a <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 48a:	6422                	ld	s0,8(sp)
 48c:	0141                	addi	sp,sp,16
 48e:	8082                	ret
    dst += n;
 490:	00c50733          	add	a4,a0,a2
    src += n;
 494:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 496:	fec05ae3          	blez	a2,48a <memmove+0x28>
 49a:	fff6079b          	addiw	a5,a2,-1
 49e:	1782                	slli	a5,a5,0x20
 4a0:	9381                	srli	a5,a5,0x20
 4a2:	fff7c793          	not	a5,a5
 4a6:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 4a8:	15fd                	addi	a1,a1,-1
 4aa:	177d                	addi	a4,a4,-1
 4ac:	0005c683          	lbu	a3,0(a1)
 4b0:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 4b4:	fee79ae3          	bne	a5,a4,4a8 <memmove+0x46>
 4b8:	bfc9                	j	48a <memmove+0x28>

00000000000004ba <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 4ba:	1141                	addi	sp,sp,-16
 4bc:	e422                	sd	s0,8(sp)
 4be:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 4c0:	ca05                	beqz	a2,4f0 <memcmp+0x36>
 4c2:	fff6069b          	addiw	a3,a2,-1
 4c6:	1682                	slli	a3,a3,0x20
 4c8:	9281                	srli	a3,a3,0x20
 4ca:	0685                	addi	a3,a3,1
 4cc:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 4ce:	00054783          	lbu	a5,0(a0)
 4d2:	0005c703          	lbu	a4,0(a1)
 4d6:	00e79863          	bne	a5,a4,4e6 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 4da:	0505                	addi	a0,a0,1
    p2++;
 4dc:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 4de:	fed518e3          	bne	a0,a3,4ce <memcmp+0x14>
  }
  return 0;
 4e2:	4501                	li	a0,0
 4e4:	a019                	j	4ea <memcmp+0x30>
      return *p1 - *p2;
 4e6:	40e7853b          	subw	a0,a5,a4
}
 4ea:	6422                	ld	s0,8(sp)
 4ec:	0141                	addi	sp,sp,16
 4ee:	8082                	ret
  return 0;
 4f0:	4501                	li	a0,0
 4f2:	bfe5                	j	4ea <memcmp+0x30>

00000000000004f4 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 4f4:	1141                	addi	sp,sp,-16
 4f6:	e406                	sd	ra,8(sp)
 4f8:	e022                	sd	s0,0(sp)
 4fa:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 4fc:	00000097          	auipc	ra,0x0
 500:	f66080e7          	jalr	-154(ra) # 462 <memmove>
}
 504:	60a2                	ld	ra,8(sp)
 506:	6402                	ld	s0,0(sp)
 508:	0141                	addi	sp,sp,16
 50a:	8082                	ret

000000000000050c <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 50c:	4885                	li	a7,1
 ecall
 50e:	00000073          	ecall
 ret
 512:	8082                	ret

0000000000000514 <exit>:
.global exit
exit:
 li a7, SYS_exit
 514:	4889                	li	a7,2
 ecall
 516:	00000073          	ecall
 ret
 51a:	8082                	ret

000000000000051c <wait>:
.global wait
wait:
 li a7, SYS_wait
 51c:	488d                	li	a7,3
 ecall
 51e:	00000073          	ecall
 ret
 522:	8082                	ret

0000000000000524 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 524:	4891                	li	a7,4
 ecall
 526:	00000073          	ecall
 ret
 52a:	8082                	ret

000000000000052c <read>:
.global read
read:
 li a7, SYS_read
 52c:	4895                	li	a7,5
 ecall
 52e:	00000073          	ecall
 ret
 532:	8082                	ret

0000000000000534 <write>:
.global write
write:
 li a7, SYS_write
 534:	48c1                	li	a7,16
 ecall
 536:	00000073          	ecall
 ret
 53a:	8082                	ret

000000000000053c <close>:
.global close
close:
 li a7, SYS_close
 53c:	48d5                	li	a7,21
 ecall
 53e:	00000073          	ecall
 ret
 542:	8082                	ret

0000000000000544 <kill>:
.global kill
kill:
 li a7, SYS_kill
 544:	4899                	li	a7,6
 ecall
 546:	00000073          	ecall
 ret
 54a:	8082                	ret

000000000000054c <exec>:
.global exec
exec:
 li a7, SYS_exec
 54c:	489d                	li	a7,7
 ecall
 54e:	00000073          	ecall
 ret
 552:	8082                	ret

0000000000000554 <open>:
.global open
open:
 li a7, SYS_open
 554:	48bd                	li	a7,15
 ecall
 556:	00000073          	ecall
 ret
 55a:	8082                	ret

000000000000055c <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 55c:	48c5                	li	a7,17
 ecall
 55e:	00000073          	ecall
 ret
 562:	8082                	ret

0000000000000564 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 564:	48c9                	li	a7,18
 ecall
 566:	00000073          	ecall
 ret
 56a:	8082                	ret

000000000000056c <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 56c:	48a1                	li	a7,8
 ecall
 56e:	00000073          	ecall
 ret
 572:	8082                	ret

0000000000000574 <link>:
.global link
link:
 li a7, SYS_link
 574:	48cd                	li	a7,19
 ecall
 576:	00000073          	ecall
 ret
 57a:	8082                	ret

000000000000057c <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 57c:	48d1                	li	a7,20
 ecall
 57e:	00000073          	ecall
 ret
 582:	8082                	ret

0000000000000584 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 584:	48a5                	li	a7,9
 ecall
 586:	00000073          	ecall
 ret
 58a:	8082                	ret

000000000000058c <dup>:
.global dup
dup:
 li a7, SYS_dup
 58c:	48a9                	li	a7,10
 ecall
 58e:	00000073          	ecall
 ret
 592:	8082                	ret

0000000000000594 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 594:	48ad                	li	a7,11
 ecall
 596:	00000073          	ecall
 ret
 59a:	8082                	ret

000000000000059c <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 59c:	48b1                	li	a7,12
 ecall
 59e:	00000073          	ecall
 ret
 5a2:	8082                	ret

00000000000005a4 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 5a4:	48b5                	li	a7,13
 ecall
 5a6:	00000073          	ecall
 ret
 5aa:	8082                	ret

00000000000005ac <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 5ac:	48b9                	li	a7,14
 ecall
 5ae:	00000073          	ecall
 ret
 5b2:	8082                	ret

00000000000005b4 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 5b4:	1101                	addi	sp,sp,-32
 5b6:	ec06                	sd	ra,24(sp)
 5b8:	e822                	sd	s0,16(sp)
 5ba:	1000                	addi	s0,sp,32
 5bc:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 5c0:	4605                	li	a2,1
 5c2:	fef40593          	addi	a1,s0,-17
 5c6:	00000097          	auipc	ra,0x0
 5ca:	f6e080e7          	jalr	-146(ra) # 534 <write>
}
 5ce:	60e2                	ld	ra,24(sp)
 5d0:	6442                	ld	s0,16(sp)
 5d2:	6105                	addi	sp,sp,32
 5d4:	8082                	ret

00000000000005d6 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 5d6:	7139                	addi	sp,sp,-64
 5d8:	fc06                	sd	ra,56(sp)
 5da:	f822                	sd	s0,48(sp)
 5dc:	f426                	sd	s1,40(sp)
 5de:	f04a                	sd	s2,32(sp)
 5e0:	ec4e                	sd	s3,24(sp)
 5e2:	0080                	addi	s0,sp,64
 5e4:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 5e6:	c299                	beqz	a3,5ec <printint+0x16>
 5e8:	0805c963          	bltz	a1,67a <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 5ec:	2581                	sext.w	a1,a1
  neg = 0;
 5ee:	4881                	li	a7,0
 5f0:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 5f4:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 5f6:	2601                	sext.w	a2,a2
 5f8:	00000517          	auipc	a0,0x0
 5fc:	51850513          	addi	a0,a0,1304 # b10 <digits>
 600:	883a                	mv	a6,a4
 602:	2705                	addiw	a4,a4,1
 604:	02c5f7bb          	remuw	a5,a1,a2
 608:	1782                	slli	a5,a5,0x20
 60a:	9381                	srli	a5,a5,0x20
 60c:	97aa                	add	a5,a5,a0
 60e:	0007c783          	lbu	a5,0(a5)
 612:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 616:	0005879b          	sext.w	a5,a1
 61a:	02c5d5bb          	divuw	a1,a1,a2
 61e:	0685                	addi	a3,a3,1
 620:	fec7f0e3          	bgeu	a5,a2,600 <printint+0x2a>
  if(neg)
 624:	00088c63          	beqz	a7,63c <printint+0x66>
    buf[i++] = '-';
 628:	fd070793          	addi	a5,a4,-48
 62c:	00878733          	add	a4,a5,s0
 630:	02d00793          	li	a5,45
 634:	fef70823          	sb	a5,-16(a4)
 638:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 63c:	02e05863          	blez	a4,66c <printint+0x96>
 640:	fc040793          	addi	a5,s0,-64
 644:	00e78933          	add	s2,a5,a4
 648:	fff78993          	addi	s3,a5,-1
 64c:	99ba                	add	s3,s3,a4
 64e:	377d                	addiw	a4,a4,-1
 650:	1702                	slli	a4,a4,0x20
 652:	9301                	srli	a4,a4,0x20
 654:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 658:	fff94583          	lbu	a1,-1(s2)
 65c:	8526                	mv	a0,s1
 65e:	00000097          	auipc	ra,0x0
 662:	f56080e7          	jalr	-170(ra) # 5b4 <putc>
  while(--i >= 0)
 666:	197d                	addi	s2,s2,-1
 668:	ff3918e3          	bne	s2,s3,658 <printint+0x82>
}
 66c:	70e2                	ld	ra,56(sp)
 66e:	7442                	ld	s0,48(sp)
 670:	74a2                	ld	s1,40(sp)
 672:	7902                	ld	s2,32(sp)
 674:	69e2                	ld	s3,24(sp)
 676:	6121                	addi	sp,sp,64
 678:	8082                	ret
    x = -xx;
 67a:	40b005bb          	negw	a1,a1
    neg = 1;
 67e:	4885                	li	a7,1
    x = -xx;
 680:	bf85                	j	5f0 <printint+0x1a>

0000000000000682 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 682:	7119                	addi	sp,sp,-128
 684:	fc86                	sd	ra,120(sp)
 686:	f8a2                	sd	s0,112(sp)
 688:	f4a6                	sd	s1,104(sp)
 68a:	f0ca                	sd	s2,96(sp)
 68c:	ecce                	sd	s3,88(sp)
 68e:	e8d2                	sd	s4,80(sp)
 690:	e4d6                	sd	s5,72(sp)
 692:	e0da                	sd	s6,64(sp)
 694:	fc5e                	sd	s7,56(sp)
 696:	f862                	sd	s8,48(sp)
 698:	f466                	sd	s9,40(sp)
 69a:	f06a                	sd	s10,32(sp)
 69c:	ec6e                	sd	s11,24(sp)
 69e:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 6a0:	0005c903          	lbu	s2,0(a1)
 6a4:	18090f63          	beqz	s2,842 <vprintf+0x1c0>
 6a8:	8aaa                	mv	s5,a0
 6aa:	8b32                	mv	s6,a2
 6ac:	00158493          	addi	s1,a1,1
  state = 0;
 6b0:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 6b2:	02500a13          	li	s4,37
 6b6:	4c55                	li	s8,21
 6b8:	00000c97          	auipc	s9,0x0
 6bc:	400c8c93          	addi	s9,s9,1024 # ab8 <malloc+0x172>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
        s = va_arg(ap, char*);
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 6c0:	02800d93          	li	s11,40
  putc(fd, 'x');
 6c4:	4d41                	li	s10,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6c6:	00000b97          	auipc	s7,0x0
 6ca:	44ab8b93          	addi	s7,s7,1098 # b10 <digits>
 6ce:	a839                	j	6ec <vprintf+0x6a>
        putc(fd, c);
 6d0:	85ca                	mv	a1,s2
 6d2:	8556                	mv	a0,s5
 6d4:	00000097          	auipc	ra,0x0
 6d8:	ee0080e7          	jalr	-288(ra) # 5b4 <putc>
 6dc:	a019                	j	6e2 <vprintf+0x60>
    } else if(state == '%'){
 6de:	01498d63          	beq	s3,s4,6f8 <vprintf+0x76>
  for(i = 0; fmt[i]; i++){
 6e2:	0485                	addi	s1,s1,1
 6e4:	fff4c903          	lbu	s2,-1(s1)
 6e8:	14090d63          	beqz	s2,842 <vprintf+0x1c0>
    if(state == 0){
 6ec:	fe0999e3          	bnez	s3,6de <vprintf+0x5c>
      if(c == '%'){
 6f0:	ff4910e3          	bne	s2,s4,6d0 <vprintf+0x4e>
        state = '%';
 6f4:	89d2                	mv	s3,s4
 6f6:	b7f5                	j	6e2 <vprintf+0x60>
      if(c == 'd'){
 6f8:	11490c63          	beq	s2,s4,810 <vprintf+0x18e>
 6fc:	f9d9079b          	addiw	a5,s2,-99
 700:	0ff7f793          	zext.b	a5,a5
 704:	10fc6e63          	bltu	s8,a5,820 <vprintf+0x19e>
 708:	f9d9079b          	addiw	a5,s2,-99
 70c:	0ff7f713          	zext.b	a4,a5
 710:	10ec6863          	bltu	s8,a4,820 <vprintf+0x19e>
 714:	00271793          	slli	a5,a4,0x2
 718:	97e6                	add	a5,a5,s9
 71a:	439c                	lw	a5,0(a5)
 71c:	97e6                	add	a5,a5,s9
 71e:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 720:	008b0913          	addi	s2,s6,8
 724:	4685                	li	a3,1
 726:	4629                	li	a2,10
 728:	000b2583          	lw	a1,0(s6)
 72c:	8556                	mv	a0,s5
 72e:	00000097          	auipc	ra,0x0
 732:	ea8080e7          	jalr	-344(ra) # 5d6 <printint>
 736:	8b4a                	mv	s6,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 738:	4981                	li	s3,0
 73a:	b765                	j	6e2 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 73c:	008b0913          	addi	s2,s6,8
 740:	4681                	li	a3,0
 742:	4629                	li	a2,10
 744:	000b2583          	lw	a1,0(s6)
 748:	8556                	mv	a0,s5
 74a:	00000097          	auipc	ra,0x0
 74e:	e8c080e7          	jalr	-372(ra) # 5d6 <printint>
 752:	8b4a                	mv	s6,s2
      state = 0;
 754:	4981                	li	s3,0
 756:	b771                	j	6e2 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 758:	008b0913          	addi	s2,s6,8
 75c:	4681                	li	a3,0
 75e:	866a                	mv	a2,s10
 760:	000b2583          	lw	a1,0(s6)
 764:	8556                	mv	a0,s5
 766:	00000097          	auipc	ra,0x0
 76a:	e70080e7          	jalr	-400(ra) # 5d6 <printint>
 76e:	8b4a                	mv	s6,s2
      state = 0;
 770:	4981                	li	s3,0
 772:	bf85                	j	6e2 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 774:	008b0793          	addi	a5,s6,8
 778:	f8f43423          	sd	a5,-120(s0)
 77c:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 780:	03000593          	li	a1,48
 784:	8556                	mv	a0,s5
 786:	00000097          	auipc	ra,0x0
 78a:	e2e080e7          	jalr	-466(ra) # 5b4 <putc>
  putc(fd, 'x');
 78e:	07800593          	li	a1,120
 792:	8556                	mv	a0,s5
 794:	00000097          	auipc	ra,0x0
 798:	e20080e7          	jalr	-480(ra) # 5b4 <putc>
 79c:	896a                	mv	s2,s10
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 79e:	03c9d793          	srli	a5,s3,0x3c
 7a2:	97de                	add	a5,a5,s7
 7a4:	0007c583          	lbu	a1,0(a5)
 7a8:	8556                	mv	a0,s5
 7aa:	00000097          	auipc	ra,0x0
 7ae:	e0a080e7          	jalr	-502(ra) # 5b4 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 7b2:	0992                	slli	s3,s3,0x4
 7b4:	397d                	addiw	s2,s2,-1
 7b6:	fe0914e3          	bnez	s2,79e <vprintf+0x11c>
        printptr(fd, va_arg(ap, uint64));
 7ba:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 7be:	4981                	li	s3,0
 7c0:	b70d                	j	6e2 <vprintf+0x60>
        s = va_arg(ap, char*);
 7c2:	008b0913          	addi	s2,s6,8
 7c6:	000b3983          	ld	s3,0(s6)
        if(s == 0)
 7ca:	02098163          	beqz	s3,7ec <vprintf+0x16a>
        while(*s != 0){
 7ce:	0009c583          	lbu	a1,0(s3)
 7d2:	c5ad                	beqz	a1,83c <vprintf+0x1ba>
          putc(fd, *s);
 7d4:	8556                	mv	a0,s5
 7d6:	00000097          	auipc	ra,0x0
 7da:	dde080e7          	jalr	-546(ra) # 5b4 <putc>
          s++;
 7de:	0985                	addi	s3,s3,1
        while(*s != 0){
 7e0:	0009c583          	lbu	a1,0(s3)
 7e4:	f9e5                	bnez	a1,7d4 <vprintf+0x152>
        s = va_arg(ap, char*);
 7e6:	8b4a                	mv	s6,s2
      state = 0;
 7e8:	4981                	li	s3,0
 7ea:	bde5                	j	6e2 <vprintf+0x60>
          s = "(null)";
 7ec:	00000997          	auipc	s3,0x0
 7f0:	2c498993          	addi	s3,s3,708 # ab0 <malloc+0x16a>
        while(*s != 0){
 7f4:	85ee                	mv	a1,s11
 7f6:	bff9                	j	7d4 <vprintf+0x152>
        putc(fd, va_arg(ap, uint));
 7f8:	008b0913          	addi	s2,s6,8
 7fc:	000b4583          	lbu	a1,0(s6)
 800:	8556                	mv	a0,s5
 802:	00000097          	auipc	ra,0x0
 806:	db2080e7          	jalr	-590(ra) # 5b4 <putc>
 80a:	8b4a                	mv	s6,s2
      state = 0;
 80c:	4981                	li	s3,0
 80e:	bdd1                	j	6e2 <vprintf+0x60>
        putc(fd, c);
 810:	85d2                	mv	a1,s4
 812:	8556                	mv	a0,s5
 814:	00000097          	auipc	ra,0x0
 818:	da0080e7          	jalr	-608(ra) # 5b4 <putc>
      state = 0;
 81c:	4981                	li	s3,0
 81e:	b5d1                	j	6e2 <vprintf+0x60>
        putc(fd, '%');
 820:	85d2                	mv	a1,s4
 822:	8556                	mv	a0,s5
 824:	00000097          	auipc	ra,0x0
 828:	d90080e7          	jalr	-624(ra) # 5b4 <putc>
        putc(fd, c);
 82c:	85ca                	mv	a1,s2
 82e:	8556                	mv	a0,s5
 830:	00000097          	auipc	ra,0x0
 834:	d84080e7          	jalr	-636(ra) # 5b4 <putc>
      state = 0;
 838:	4981                	li	s3,0
 83a:	b565                	j	6e2 <vprintf+0x60>
        s = va_arg(ap, char*);
 83c:	8b4a                	mv	s6,s2
      state = 0;
 83e:	4981                	li	s3,0
 840:	b54d                	j	6e2 <vprintf+0x60>
    }
  }
}
 842:	70e6                	ld	ra,120(sp)
 844:	7446                	ld	s0,112(sp)
 846:	74a6                	ld	s1,104(sp)
 848:	7906                	ld	s2,96(sp)
 84a:	69e6                	ld	s3,88(sp)
 84c:	6a46                	ld	s4,80(sp)
 84e:	6aa6                	ld	s5,72(sp)
 850:	6b06                	ld	s6,64(sp)
 852:	7be2                	ld	s7,56(sp)
 854:	7c42                	ld	s8,48(sp)
 856:	7ca2                	ld	s9,40(sp)
 858:	7d02                	ld	s10,32(sp)
 85a:	6de2                	ld	s11,24(sp)
 85c:	6109                	addi	sp,sp,128
 85e:	8082                	ret

0000000000000860 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 860:	715d                	addi	sp,sp,-80
 862:	ec06                	sd	ra,24(sp)
 864:	e822                	sd	s0,16(sp)
 866:	1000                	addi	s0,sp,32
 868:	e010                	sd	a2,0(s0)
 86a:	e414                	sd	a3,8(s0)
 86c:	e818                	sd	a4,16(s0)
 86e:	ec1c                	sd	a5,24(s0)
 870:	03043023          	sd	a6,32(s0)
 874:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 878:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 87c:	8622                	mv	a2,s0
 87e:	00000097          	auipc	ra,0x0
 882:	e04080e7          	jalr	-508(ra) # 682 <vprintf>
}
 886:	60e2                	ld	ra,24(sp)
 888:	6442                	ld	s0,16(sp)
 88a:	6161                	addi	sp,sp,80
 88c:	8082                	ret

000000000000088e <printf>:

void
printf(const char *fmt, ...)
{
 88e:	711d                	addi	sp,sp,-96
 890:	ec06                	sd	ra,24(sp)
 892:	e822                	sd	s0,16(sp)
 894:	1000                	addi	s0,sp,32
 896:	e40c                	sd	a1,8(s0)
 898:	e810                	sd	a2,16(s0)
 89a:	ec14                	sd	a3,24(s0)
 89c:	f018                	sd	a4,32(s0)
 89e:	f41c                	sd	a5,40(s0)
 8a0:	03043823          	sd	a6,48(s0)
 8a4:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 8a8:	00840613          	addi	a2,s0,8
 8ac:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 8b0:	85aa                	mv	a1,a0
 8b2:	4505                	li	a0,1
 8b4:	00000097          	auipc	ra,0x0
 8b8:	dce080e7          	jalr	-562(ra) # 682 <vprintf>
}
 8bc:	60e2                	ld	ra,24(sp)
 8be:	6442                	ld	s0,16(sp)
 8c0:	6125                	addi	sp,sp,96
 8c2:	8082                	ret

00000000000008c4 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 8c4:	1141                	addi	sp,sp,-16
 8c6:	e422                	sd	s0,8(sp)
 8c8:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 8ca:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8ce:	00000797          	auipc	a5,0x0
 8d2:	25a7b783          	ld	a5,602(a5) # b28 <freep>
 8d6:	a02d                	j	900 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 8d8:	4618                	lw	a4,8(a2)
 8da:	9f2d                	addw	a4,a4,a1
 8dc:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 8e0:	6398                	ld	a4,0(a5)
 8e2:	6310                	ld	a2,0(a4)
 8e4:	a83d                	j	922 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 8e6:	ff852703          	lw	a4,-8(a0)
 8ea:	9f31                	addw	a4,a4,a2
 8ec:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 8ee:	ff053683          	ld	a3,-16(a0)
 8f2:	a091                	j	936 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8f4:	6398                	ld	a4,0(a5)
 8f6:	00e7e463          	bltu	a5,a4,8fe <free+0x3a>
 8fa:	00e6ea63          	bltu	a3,a4,90e <free+0x4a>
{
 8fe:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 900:	fed7fae3          	bgeu	a5,a3,8f4 <free+0x30>
 904:	6398                	ld	a4,0(a5)
 906:	00e6e463          	bltu	a3,a4,90e <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 90a:	fee7eae3          	bltu	a5,a4,8fe <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 90e:	ff852583          	lw	a1,-8(a0)
 912:	6390                	ld	a2,0(a5)
 914:	02059813          	slli	a6,a1,0x20
 918:	01c85713          	srli	a4,a6,0x1c
 91c:	9736                	add	a4,a4,a3
 91e:	fae60de3          	beq	a2,a4,8d8 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 922:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 926:	4790                	lw	a2,8(a5)
 928:	02061593          	slli	a1,a2,0x20
 92c:	01c5d713          	srli	a4,a1,0x1c
 930:	973e                	add	a4,a4,a5
 932:	fae68ae3          	beq	a3,a4,8e6 <free+0x22>
    p->s.ptr = bp->s.ptr;
 936:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 938:	00000717          	auipc	a4,0x0
 93c:	1ef73823          	sd	a5,496(a4) # b28 <freep>
}
 940:	6422                	ld	s0,8(sp)
 942:	0141                	addi	sp,sp,16
 944:	8082                	ret

0000000000000946 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 946:	7139                	addi	sp,sp,-64
 948:	fc06                	sd	ra,56(sp)
 94a:	f822                	sd	s0,48(sp)
 94c:	f426                	sd	s1,40(sp)
 94e:	f04a                	sd	s2,32(sp)
 950:	ec4e                	sd	s3,24(sp)
 952:	e852                	sd	s4,16(sp)
 954:	e456                	sd	s5,8(sp)
 956:	e05a                	sd	s6,0(sp)
 958:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 95a:	02051493          	slli	s1,a0,0x20
 95e:	9081                	srli	s1,s1,0x20
 960:	04bd                	addi	s1,s1,15
 962:	8091                	srli	s1,s1,0x4
 964:	0014899b          	addiw	s3,s1,1
 968:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 96a:	00000517          	auipc	a0,0x0
 96e:	1be53503          	ld	a0,446(a0) # b28 <freep>
 972:	c515                	beqz	a0,99e <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 974:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 976:	4798                	lw	a4,8(a5)
 978:	02977f63          	bgeu	a4,s1,9b6 <malloc+0x70>
 97c:	8a4e                	mv	s4,s3
 97e:	0009871b          	sext.w	a4,s3
 982:	6685                	lui	a3,0x1
 984:	00d77363          	bgeu	a4,a3,98a <malloc+0x44>
 988:	6a05                	lui	s4,0x1
 98a:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 98e:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 992:	00000917          	auipc	s2,0x0
 996:	19690913          	addi	s2,s2,406 # b28 <freep>
  if(p == (char*)-1)
 99a:	5afd                	li	s5,-1
 99c:	a895                	j	a10 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 99e:	00000797          	auipc	a5,0x0
 9a2:	1a278793          	addi	a5,a5,418 # b40 <base>
 9a6:	00000717          	auipc	a4,0x0
 9aa:	18f73123          	sd	a5,386(a4) # b28 <freep>
 9ae:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 9b0:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 9b4:	b7e1                	j	97c <malloc+0x36>
      if(p->s.size == nunits)
 9b6:	02e48c63          	beq	s1,a4,9ee <malloc+0xa8>
        p->s.size -= nunits;
 9ba:	4137073b          	subw	a4,a4,s3
 9be:	c798                	sw	a4,8(a5)
        p += p->s.size;
 9c0:	02071693          	slli	a3,a4,0x20
 9c4:	01c6d713          	srli	a4,a3,0x1c
 9c8:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 9ca:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 9ce:	00000717          	auipc	a4,0x0
 9d2:	14a73d23          	sd	a0,346(a4) # b28 <freep>
      return (void*)(p + 1);
 9d6:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 9da:	70e2                	ld	ra,56(sp)
 9dc:	7442                	ld	s0,48(sp)
 9de:	74a2                	ld	s1,40(sp)
 9e0:	7902                	ld	s2,32(sp)
 9e2:	69e2                	ld	s3,24(sp)
 9e4:	6a42                	ld	s4,16(sp)
 9e6:	6aa2                	ld	s5,8(sp)
 9e8:	6b02                	ld	s6,0(sp)
 9ea:	6121                	addi	sp,sp,64
 9ec:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 9ee:	6398                	ld	a4,0(a5)
 9f0:	e118                	sd	a4,0(a0)
 9f2:	bff1                	j	9ce <malloc+0x88>
  hp->s.size = nu;
 9f4:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 9f8:	0541                	addi	a0,a0,16
 9fa:	00000097          	auipc	ra,0x0
 9fe:	eca080e7          	jalr	-310(ra) # 8c4 <free>
  return freep;
 a02:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 a06:	d971                	beqz	a0,9da <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a08:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a0a:	4798                	lw	a4,8(a5)
 a0c:	fa9775e3          	bgeu	a4,s1,9b6 <malloc+0x70>
    if(p == freep)
 a10:	00093703          	ld	a4,0(s2)
 a14:	853e                	mv	a0,a5
 a16:	fef719e3          	bne	a4,a5,a08 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 a1a:	8552                	mv	a0,s4
 a1c:	00000097          	auipc	ra,0x0
 a20:	b80080e7          	jalr	-1152(ra) # 59c <sbrk>
  if(p == (char*)-1)
 a24:	fd5518e3          	bne	a0,s5,9f4 <malloc+0xae>
        return 0;
 a28:	4501                	li	a0,0
 a2a:	bf45                	j	9da <malloc+0x94>

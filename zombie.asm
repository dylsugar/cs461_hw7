
_zombie:     file format elf64-x86-64


Disassembly of section .text:

0000000000001000 <main>:
#include "stat.h"
#include "user.h"

int
main(void)
{
    1000:	f3 0f 1e fa          	endbr64 
    1004:	55                   	push   %rbp
    1005:	48 89 e5             	mov    %rsp,%rbp
  if(fork() > 0)
    1008:	48 b8 6b 13 00 00 00 	movabs $0x136b,%rax
    100f:	00 00 00 
    1012:	ff d0                	callq  *%rax
    1014:	85 c0                	test   %eax,%eax
    1016:	7e 11                	jle    1029 <main+0x29>
    sleep(5);  // Let child exit before parent.
    1018:	bf 05 00 00 00       	mov    $0x5,%edi
    101d:	48 b8 62 14 00 00 00 	movabs $0x1462,%rax
    1024:	00 00 00 
    1027:	ff d0                	callq  *%rax
  exit();
    1029:	48 b8 78 13 00 00 00 	movabs $0x1378,%rax
    1030:	00 00 00 
    1033:	ff d0                	callq  *%rax

0000000000001035 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
    1035:	f3 0f 1e fa          	endbr64 
    1039:	55                   	push   %rbp
    103a:	48 89 e5             	mov    %rsp,%rbp
    103d:	48 83 ec 10          	sub    $0x10,%rsp
    1041:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    1045:	89 75 f4             	mov    %esi,-0xc(%rbp)
    1048:	89 55 f0             	mov    %edx,-0x10(%rbp)
  asm volatile("cld; rep stosb" :
    104b:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
    104f:	8b 55 f0             	mov    -0x10(%rbp),%edx
    1052:	8b 45 f4             	mov    -0xc(%rbp),%eax
    1055:	48 89 ce             	mov    %rcx,%rsi
    1058:	48 89 f7             	mov    %rsi,%rdi
    105b:	89 d1                	mov    %edx,%ecx
    105d:	fc                   	cld    
    105e:	f3 aa                	rep stos %al,%es:(%rdi)
    1060:	89 ca                	mov    %ecx,%edx
    1062:	48 89 fe             	mov    %rdi,%rsi
    1065:	48 89 75 f8          	mov    %rsi,-0x8(%rbp)
    1069:	89 55 f0             	mov    %edx,-0x10(%rbp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
    106c:	90                   	nop
    106d:	c9                   	leaveq 
    106e:	c3                   	retq   

000000000000106f <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
    106f:	f3 0f 1e fa          	endbr64 
    1073:	55                   	push   %rbp
    1074:	48 89 e5             	mov    %rsp,%rbp
    1077:	48 83 ec 20          	sub    $0x20,%rsp
    107b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    107f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  char *os;

  os = s;
    1083:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1087:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  while((*s++ = *t++) != 0)
    108b:	90                   	nop
    108c:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
    1090:	48 8d 42 01          	lea    0x1(%rdx),%rax
    1094:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    1098:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    109c:	48 8d 48 01          	lea    0x1(%rax),%rcx
    10a0:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
    10a4:	0f b6 12             	movzbl (%rdx),%edx
    10a7:	88 10                	mov    %dl,(%rax)
    10a9:	0f b6 00             	movzbl (%rax),%eax
    10ac:	84 c0                	test   %al,%al
    10ae:	75 dc                	jne    108c <strcpy+0x1d>
    ;
  return os;
    10b0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
    10b4:	c9                   	leaveq 
    10b5:	c3                   	retq   

00000000000010b6 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    10b6:	f3 0f 1e fa          	endbr64 
    10ba:	55                   	push   %rbp
    10bb:	48 89 e5             	mov    %rsp,%rbp
    10be:	48 83 ec 10          	sub    $0x10,%rsp
    10c2:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    10c6:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  while(*p && *p == *q)
    10ca:	eb 0a                	jmp    10d6 <strcmp+0x20>
    p++, q++;
    10cc:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
    10d1:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
  while(*p && *p == *q)
    10d6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    10da:	0f b6 00             	movzbl (%rax),%eax
    10dd:	84 c0                	test   %al,%al
    10df:	74 12                	je     10f3 <strcmp+0x3d>
    10e1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    10e5:	0f b6 10             	movzbl (%rax),%edx
    10e8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    10ec:	0f b6 00             	movzbl (%rax),%eax
    10ef:	38 c2                	cmp    %al,%dl
    10f1:	74 d9                	je     10cc <strcmp+0x16>
  return (uchar)*p - (uchar)*q;
    10f3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    10f7:	0f b6 00             	movzbl (%rax),%eax
    10fa:	0f b6 d0             	movzbl %al,%edx
    10fd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1101:	0f b6 00             	movzbl (%rax),%eax
    1104:	0f b6 c0             	movzbl %al,%eax
    1107:	29 c2                	sub    %eax,%edx
    1109:	89 d0                	mov    %edx,%eax
}
    110b:	c9                   	leaveq 
    110c:	c3                   	retq   

000000000000110d <strlen>:

uint
strlen(char *s)
{
    110d:	f3 0f 1e fa          	endbr64 
    1111:	55                   	push   %rbp
    1112:	48 89 e5             	mov    %rsp,%rbp
    1115:	48 83 ec 18          	sub    $0x18,%rsp
    1119:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  int n;

  for(n = 0; s[n]; n++)
    111d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    1124:	eb 04                	jmp    112a <strlen+0x1d>
    1126:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    112a:	8b 45 fc             	mov    -0x4(%rbp),%eax
    112d:	48 63 d0             	movslq %eax,%rdx
    1130:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1134:	48 01 d0             	add    %rdx,%rax
    1137:	0f b6 00             	movzbl (%rax),%eax
    113a:	84 c0                	test   %al,%al
    113c:	75 e8                	jne    1126 <strlen+0x19>
    ;
  return n;
    113e:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
    1141:	c9                   	leaveq 
    1142:	c3                   	retq   

0000000000001143 <memset>:

void*
memset(void *dst, int c, uint n)
{
    1143:	f3 0f 1e fa          	endbr64 
    1147:	55                   	push   %rbp
    1148:	48 89 e5             	mov    %rsp,%rbp
    114b:	48 83 ec 10          	sub    $0x10,%rsp
    114f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    1153:	89 75 f4             	mov    %esi,-0xc(%rbp)
    1156:	89 55 f0             	mov    %edx,-0x10(%rbp)
  stosb(dst, c, n);
    1159:	8b 55 f0             	mov    -0x10(%rbp),%edx
    115c:	8b 4d f4             	mov    -0xc(%rbp),%ecx
    115f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1163:	89 ce                	mov    %ecx,%esi
    1165:	48 89 c7             	mov    %rax,%rdi
    1168:	48 b8 35 10 00 00 00 	movabs $0x1035,%rax
    116f:	00 00 00 
    1172:	ff d0                	callq  *%rax
  return dst;
    1174:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
    1178:	c9                   	leaveq 
    1179:	c3                   	retq   

000000000000117a <strchr>:

char*
strchr(const char *s, char c)
{
    117a:	f3 0f 1e fa          	endbr64 
    117e:	55                   	push   %rbp
    117f:	48 89 e5             	mov    %rsp,%rbp
    1182:	48 83 ec 10          	sub    $0x10,%rsp
    1186:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    118a:	89 f0                	mov    %esi,%eax
    118c:	88 45 f4             	mov    %al,-0xc(%rbp)
  for(; *s; s++)
    118f:	eb 17                	jmp    11a8 <strchr+0x2e>
    if(*s == c)
    1191:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1195:	0f b6 00             	movzbl (%rax),%eax
    1198:	38 45 f4             	cmp    %al,-0xc(%rbp)
    119b:	75 06                	jne    11a3 <strchr+0x29>
      return (char*)s;
    119d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    11a1:	eb 15                	jmp    11b8 <strchr+0x3e>
  for(; *s; s++)
    11a3:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
    11a8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    11ac:	0f b6 00             	movzbl (%rax),%eax
    11af:	84 c0                	test   %al,%al
    11b1:	75 de                	jne    1191 <strchr+0x17>
  return 0;
    11b3:	b8 00 00 00 00       	mov    $0x0,%eax
}
    11b8:	c9                   	leaveq 
    11b9:	c3                   	retq   

00000000000011ba <gets>:

char*
gets(char *buf, int max)
{
    11ba:	f3 0f 1e fa          	endbr64 
    11be:	55                   	push   %rbp
    11bf:	48 89 e5             	mov    %rsp,%rbp
    11c2:	48 83 ec 20          	sub    $0x20,%rsp
    11c6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    11ca:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    11cd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    11d4:	eb 4f                	jmp    1225 <gets+0x6b>
    cc = read(0, &c, 1);
    11d6:	48 8d 45 f7          	lea    -0x9(%rbp),%rax
    11da:	ba 01 00 00 00       	mov    $0x1,%edx
    11df:	48 89 c6             	mov    %rax,%rsi
    11e2:	bf 00 00 00 00       	mov    $0x0,%edi
    11e7:	48 b8 9f 13 00 00 00 	movabs $0x139f,%rax
    11ee:	00 00 00 
    11f1:	ff d0                	callq  *%rax
    11f3:	89 45 f8             	mov    %eax,-0x8(%rbp)
    if(cc < 1)
    11f6:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
    11fa:	7e 36                	jle    1232 <gets+0x78>
      break;
    buf[i++] = c;
    11fc:	8b 45 fc             	mov    -0x4(%rbp),%eax
    11ff:	8d 50 01             	lea    0x1(%rax),%edx
    1202:	89 55 fc             	mov    %edx,-0x4(%rbp)
    1205:	48 63 d0             	movslq %eax,%rdx
    1208:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    120c:	48 01 c2             	add    %rax,%rdx
    120f:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
    1213:	88 02                	mov    %al,(%rdx)
    if(c == '\n' || c == '\r')
    1215:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
    1219:	3c 0a                	cmp    $0xa,%al
    121b:	74 16                	je     1233 <gets+0x79>
    121d:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
    1221:	3c 0d                	cmp    $0xd,%al
    1223:	74 0e                	je     1233 <gets+0x79>
  for(i=0; i+1 < max; ){
    1225:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1228:	83 c0 01             	add    $0x1,%eax
    122b:	39 45 e4             	cmp    %eax,-0x1c(%rbp)
    122e:	7f a6                	jg     11d6 <gets+0x1c>
    1230:	eb 01                	jmp    1233 <gets+0x79>
      break;
    1232:	90                   	nop
      break;
  }
  buf[i] = '\0';
    1233:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1236:	48 63 d0             	movslq %eax,%rdx
    1239:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    123d:	48 01 d0             	add    %rdx,%rax
    1240:	c6 00 00             	movb   $0x0,(%rax)
  return buf;
    1243:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
    1247:	c9                   	leaveq 
    1248:	c3                   	retq   

0000000000001249 <stat>:

int
stat(char *n, struct stat *st)
{
    1249:	f3 0f 1e fa          	endbr64 
    124d:	55                   	push   %rbp
    124e:	48 89 e5             	mov    %rsp,%rbp
    1251:	48 83 ec 20          	sub    $0x20,%rsp
    1255:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    1259:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    125d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1261:	be 00 00 00 00       	mov    $0x0,%esi
    1266:	48 89 c7             	mov    %rax,%rdi
    1269:	48 b8 e0 13 00 00 00 	movabs $0x13e0,%rax
    1270:	00 00 00 
    1273:	ff d0                	callq  *%rax
    1275:	89 45 fc             	mov    %eax,-0x4(%rbp)
  if(fd < 0)
    1278:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
    127c:	79 07                	jns    1285 <stat+0x3c>
    return -1;
    127e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    1283:	eb 2f                	jmp    12b4 <stat+0x6b>
  r = fstat(fd, st);
    1285:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
    1289:	8b 45 fc             	mov    -0x4(%rbp),%eax
    128c:	48 89 d6             	mov    %rdx,%rsi
    128f:	89 c7                	mov    %eax,%edi
    1291:	48 b8 07 14 00 00 00 	movabs $0x1407,%rax
    1298:	00 00 00 
    129b:	ff d0                	callq  *%rax
    129d:	89 45 f8             	mov    %eax,-0x8(%rbp)
  close(fd);
    12a0:	8b 45 fc             	mov    -0x4(%rbp),%eax
    12a3:	89 c7                	mov    %eax,%edi
    12a5:	48 b8 b9 13 00 00 00 	movabs $0x13b9,%rax
    12ac:	00 00 00 
    12af:	ff d0                	callq  *%rax
  return r;
    12b1:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
    12b4:	c9                   	leaveq 
    12b5:	c3                   	retq   

00000000000012b6 <atoi>:

int
atoi(const char *s)
{
    12b6:	f3 0f 1e fa          	endbr64 
    12ba:	55                   	push   %rbp
    12bb:	48 89 e5             	mov    %rsp,%rbp
    12be:	48 83 ec 18          	sub    $0x18,%rsp
    12c2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  int n;

  n = 0;
    12c6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  while('0' <= *s && *s <= '9')
    12cd:	eb 28                	jmp    12f7 <atoi+0x41>
    n = n*10 + *s++ - '0';
    12cf:	8b 55 fc             	mov    -0x4(%rbp),%edx
    12d2:	89 d0                	mov    %edx,%eax
    12d4:	c1 e0 02             	shl    $0x2,%eax
    12d7:	01 d0                	add    %edx,%eax
    12d9:	01 c0                	add    %eax,%eax
    12db:	89 c1                	mov    %eax,%ecx
    12dd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    12e1:	48 8d 50 01          	lea    0x1(%rax),%rdx
    12e5:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
    12e9:	0f b6 00             	movzbl (%rax),%eax
    12ec:	0f be c0             	movsbl %al,%eax
    12ef:	01 c8                	add    %ecx,%eax
    12f1:	83 e8 30             	sub    $0x30,%eax
    12f4:	89 45 fc             	mov    %eax,-0x4(%rbp)
  while('0' <= *s && *s <= '9')
    12f7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    12fb:	0f b6 00             	movzbl (%rax),%eax
    12fe:	3c 2f                	cmp    $0x2f,%al
    1300:	7e 0b                	jle    130d <atoi+0x57>
    1302:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1306:	0f b6 00             	movzbl (%rax),%eax
    1309:	3c 39                	cmp    $0x39,%al
    130b:	7e c2                	jle    12cf <atoi+0x19>
  return n;
    130d:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
    1310:	c9                   	leaveq 
    1311:	c3                   	retq   

0000000000001312 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    1312:	f3 0f 1e fa          	endbr64 
    1316:	55                   	push   %rbp
    1317:	48 89 e5             	mov    %rsp,%rbp
    131a:	48 83 ec 28          	sub    $0x28,%rsp
    131e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    1322:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
    1326:	89 55 dc             	mov    %edx,-0x24(%rbp)
  char *dst, *src;

  dst = vdst;
    1329:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    132d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  src = vsrc;
    1331:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    1335:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  while(n-- > 0)
    1339:	eb 1d                	jmp    1358 <memmove+0x46>
    *dst++ = *src++;
    133b:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
    133f:	48 8d 42 01          	lea    0x1(%rdx),%rax
    1343:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    1347:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    134b:	48 8d 48 01          	lea    0x1(%rax),%rcx
    134f:	48 89 4d f8          	mov    %rcx,-0x8(%rbp)
    1353:	0f b6 12             	movzbl (%rdx),%edx
    1356:	88 10                	mov    %dl,(%rax)
  while(n-- > 0)
    1358:	8b 45 dc             	mov    -0x24(%rbp),%eax
    135b:	8d 50 ff             	lea    -0x1(%rax),%edx
    135e:	89 55 dc             	mov    %edx,-0x24(%rbp)
    1361:	85 c0                	test   %eax,%eax
    1363:	7f d6                	jg     133b <memmove+0x29>
  return vdst;
    1365:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
    1369:	c9                   	leaveq 
    136a:	c3                   	retq   

000000000000136b <fork>:
    mov $SYS_ ## name, %rax; \
    mov %rcx, %r10 ;\
    syscall		  ;\
    ret

SYSCALL(fork)
    136b:	48 c7 c0 01 00 00 00 	mov    $0x1,%rax
    1372:	49 89 ca             	mov    %rcx,%r10
    1375:	0f 05                	syscall 
    1377:	c3                   	retq   

0000000000001378 <exit>:
SYSCALL(exit)
    1378:	48 c7 c0 02 00 00 00 	mov    $0x2,%rax
    137f:	49 89 ca             	mov    %rcx,%r10
    1382:	0f 05                	syscall 
    1384:	c3                   	retq   

0000000000001385 <wait>:
SYSCALL(wait)
    1385:	48 c7 c0 03 00 00 00 	mov    $0x3,%rax
    138c:	49 89 ca             	mov    %rcx,%r10
    138f:	0f 05                	syscall 
    1391:	c3                   	retq   

0000000000001392 <pipe>:
SYSCALL(pipe)
    1392:	48 c7 c0 04 00 00 00 	mov    $0x4,%rax
    1399:	49 89 ca             	mov    %rcx,%r10
    139c:	0f 05                	syscall 
    139e:	c3                   	retq   

000000000000139f <read>:
SYSCALL(read)
    139f:	48 c7 c0 05 00 00 00 	mov    $0x5,%rax
    13a6:	49 89 ca             	mov    %rcx,%r10
    13a9:	0f 05                	syscall 
    13ab:	c3                   	retq   

00000000000013ac <write>:
SYSCALL(write)
    13ac:	48 c7 c0 10 00 00 00 	mov    $0x10,%rax
    13b3:	49 89 ca             	mov    %rcx,%r10
    13b6:	0f 05                	syscall 
    13b8:	c3                   	retq   

00000000000013b9 <close>:
SYSCALL(close)
    13b9:	48 c7 c0 15 00 00 00 	mov    $0x15,%rax
    13c0:	49 89 ca             	mov    %rcx,%r10
    13c3:	0f 05                	syscall 
    13c5:	c3                   	retq   

00000000000013c6 <kill>:
SYSCALL(kill)
    13c6:	48 c7 c0 06 00 00 00 	mov    $0x6,%rax
    13cd:	49 89 ca             	mov    %rcx,%r10
    13d0:	0f 05                	syscall 
    13d2:	c3                   	retq   

00000000000013d3 <exec>:
SYSCALL(exec)
    13d3:	48 c7 c0 07 00 00 00 	mov    $0x7,%rax
    13da:	49 89 ca             	mov    %rcx,%r10
    13dd:	0f 05                	syscall 
    13df:	c3                   	retq   

00000000000013e0 <open>:
SYSCALL(open)
    13e0:	48 c7 c0 0f 00 00 00 	mov    $0xf,%rax
    13e7:	49 89 ca             	mov    %rcx,%r10
    13ea:	0f 05                	syscall 
    13ec:	c3                   	retq   

00000000000013ed <mknod>:
SYSCALL(mknod)
    13ed:	48 c7 c0 11 00 00 00 	mov    $0x11,%rax
    13f4:	49 89 ca             	mov    %rcx,%r10
    13f7:	0f 05                	syscall 
    13f9:	c3                   	retq   

00000000000013fa <unlink>:
SYSCALL(unlink)
    13fa:	48 c7 c0 12 00 00 00 	mov    $0x12,%rax
    1401:	49 89 ca             	mov    %rcx,%r10
    1404:	0f 05                	syscall 
    1406:	c3                   	retq   

0000000000001407 <fstat>:
SYSCALL(fstat)
    1407:	48 c7 c0 08 00 00 00 	mov    $0x8,%rax
    140e:	49 89 ca             	mov    %rcx,%r10
    1411:	0f 05                	syscall 
    1413:	c3                   	retq   

0000000000001414 <link>:
SYSCALL(link)
    1414:	48 c7 c0 13 00 00 00 	mov    $0x13,%rax
    141b:	49 89 ca             	mov    %rcx,%r10
    141e:	0f 05                	syscall 
    1420:	c3                   	retq   

0000000000001421 <mkdir>:
SYSCALL(mkdir)
    1421:	48 c7 c0 14 00 00 00 	mov    $0x14,%rax
    1428:	49 89 ca             	mov    %rcx,%r10
    142b:	0f 05                	syscall 
    142d:	c3                   	retq   

000000000000142e <chdir>:
SYSCALL(chdir)
    142e:	48 c7 c0 09 00 00 00 	mov    $0x9,%rax
    1435:	49 89 ca             	mov    %rcx,%r10
    1438:	0f 05                	syscall 
    143a:	c3                   	retq   

000000000000143b <dup>:
SYSCALL(dup)
    143b:	48 c7 c0 0a 00 00 00 	mov    $0xa,%rax
    1442:	49 89 ca             	mov    %rcx,%r10
    1445:	0f 05                	syscall 
    1447:	c3                   	retq   

0000000000001448 <getpid>:
SYSCALL(getpid)
    1448:	48 c7 c0 0b 00 00 00 	mov    $0xb,%rax
    144f:	49 89 ca             	mov    %rcx,%r10
    1452:	0f 05                	syscall 
    1454:	c3                   	retq   

0000000000001455 <sbrk>:
SYSCALL(sbrk)
    1455:	48 c7 c0 0c 00 00 00 	mov    $0xc,%rax
    145c:	49 89 ca             	mov    %rcx,%r10
    145f:	0f 05                	syscall 
    1461:	c3                   	retq   

0000000000001462 <sleep>:
SYSCALL(sleep)
    1462:	48 c7 c0 0d 00 00 00 	mov    $0xd,%rax
    1469:	49 89 ca             	mov    %rcx,%r10
    146c:	0f 05                	syscall 
    146e:	c3                   	retq   

000000000000146f <uptime>:
SYSCALL(uptime)
    146f:	48 c7 c0 0e 00 00 00 	mov    $0xe,%rax
    1476:	49 89 ca             	mov    %rcx,%r10
    1479:	0f 05                	syscall 
    147b:	c3                   	retq   

000000000000147c <aread>:
SYSCALL(aread)
    147c:	48 c7 c0 16 00 00 00 	mov    $0x16,%rax
    1483:	49 89 ca             	mov    %rcx,%r10
    1486:	0f 05                	syscall 
    1488:	c3                   	retq   

0000000000001489 <putc>:

#include <stdarg.h>

static void
putc(int fd, char c)
{
    1489:	f3 0f 1e fa          	endbr64 
    148d:	55                   	push   %rbp
    148e:	48 89 e5             	mov    %rsp,%rbp
    1491:	48 83 ec 10          	sub    $0x10,%rsp
    1495:	89 7d fc             	mov    %edi,-0x4(%rbp)
    1498:	89 f0                	mov    %esi,%eax
    149a:	88 45 f8             	mov    %al,-0x8(%rbp)
  write(fd, &c, 1);
    149d:	48 8d 4d f8          	lea    -0x8(%rbp),%rcx
    14a1:	8b 45 fc             	mov    -0x4(%rbp),%eax
    14a4:	ba 01 00 00 00       	mov    $0x1,%edx
    14a9:	48 89 ce             	mov    %rcx,%rsi
    14ac:	89 c7                	mov    %eax,%edi
    14ae:	48 b8 ac 13 00 00 00 	movabs $0x13ac,%rax
    14b5:	00 00 00 
    14b8:	ff d0                	callq  *%rax
}
    14ba:	90                   	nop
    14bb:	c9                   	leaveq 
    14bc:	c3                   	retq   

00000000000014bd <print_x64>:

static char digits[] = "0123456789abcdef";

  static void
print_x64(int fd, addr_t x)
{
    14bd:	f3 0f 1e fa          	endbr64 
    14c1:	55                   	push   %rbp
    14c2:	48 89 e5             	mov    %rsp,%rbp
    14c5:	48 83 ec 20          	sub    $0x20,%rsp
    14c9:	89 7d ec             	mov    %edi,-0x14(%rbp)
    14cc:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  int i;
  for (i = 0; i < (sizeof(addr_t) * 2); i++, x <<= 4)
    14d0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    14d7:	eb 35                	jmp    150e <print_x64+0x51>
    putc(fd, digits[x >> (sizeof(addr_t) * 8 - 4)]);
    14d9:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    14dd:	48 c1 e8 3c          	shr    $0x3c,%rax
    14e1:	48 ba c0 20 00 00 00 	movabs $0x20c0,%rdx
    14e8:	00 00 00 
    14eb:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
    14ef:	0f be d0             	movsbl %al,%edx
    14f2:	8b 45 ec             	mov    -0x14(%rbp),%eax
    14f5:	89 d6                	mov    %edx,%esi
    14f7:	89 c7                	mov    %eax,%edi
    14f9:	48 b8 89 14 00 00 00 	movabs $0x1489,%rax
    1500:	00 00 00 
    1503:	ff d0                	callq  *%rax
  for (i = 0; i < (sizeof(addr_t) * 2); i++, x <<= 4)
    1505:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    1509:	48 c1 65 e0 04       	shlq   $0x4,-0x20(%rbp)
    150e:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1511:	83 f8 0f             	cmp    $0xf,%eax
    1514:	76 c3                	jbe    14d9 <print_x64+0x1c>
}
    1516:	90                   	nop
    1517:	90                   	nop
    1518:	c9                   	leaveq 
    1519:	c3                   	retq   

000000000000151a <print_x32>:

  static void
print_x32(int fd, uint x)
{
    151a:	f3 0f 1e fa          	endbr64 
    151e:	55                   	push   %rbp
    151f:	48 89 e5             	mov    %rsp,%rbp
    1522:	48 83 ec 20          	sub    $0x20,%rsp
    1526:	89 7d ec             	mov    %edi,-0x14(%rbp)
    1529:	89 75 e8             	mov    %esi,-0x18(%rbp)
  int i;
  for (i = 0; i < (sizeof(uint) * 2); i++, x <<= 4)
    152c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    1533:	eb 36                	jmp    156b <print_x32+0x51>
    putc(fd, digits[x >> (sizeof(uint) * 8 - 4)]);
    1535:	8b 45 e8             	mov    -0x18(%rbp),%eax
    1538:	c1 e8 1c             	shr    $0x1c,%eax
    153b:	89 c2                	mov    %eax,%edx
    153d:	48 b8 c0 20 00 00 00 	movabs $0x20c0,%rax
    1544:	00 00 00 
    1547:	89 d2                	mov    %edx,%edx
    1549:	0f b6 04 10          	movzbl (%rax,%rdx,1),%eax
    154d:	0f be d0             	movsbl %al,%edx
    1550:	8b 45 ec             	mov    -0x14(%rbp),%eax
    1553:	89 d6                	mov    %edx,%esi
    1555:	89 c7                	mov    %eax,%edi
    1557:	48 b8 89 14 00 00 00 	movabs $0x1489,%rax
    155e:	00 00 00 
    1561:	ff d0                	callq  *%rax
  for (i = 0; i < (sizeof(uint) * 2); i++, x <<= 4)
    1563:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    1567:	c1 65 e8 04          	shll   $0x4,-0x18(%rbp)
    156b:	8b 45 fc             	mov    -0x4(%rbp),%eax
    156e:	83 f8 07             	cmp    $0x7,%eax
    1571:	76 c2                	jbe    1535 <print_x32+0x1b>
}
    1573:	90                   	nop
    1574:	90                   	nop
    1575:	c9                   	leaveq 
    1576:	c3                   	retq   

0000000000001577 <print_d>:

  static void
print_d(int fd, int v)
{
    1577:	f3 0f 1e fa          	endbr64 
    157b:	55                   	push   %rbp
    157c:	48 89 e5             	mov    %rsp,%rbp
    157f:	48 83 ec 30          	sub    $0x30,%rsp
    1583:	89 7d dc             	mov    %edi,-0x24(%rbp)
    1586:	89 75 d8             	mov    %esi,-0x28(%rbp)
  char buf[16];
  int64 x = v;
    1589:	8b 45 d8             	mov    -0x28(%rbp),%eax
    158c:	48 98                	cltq   
    158e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

  if (v < 0)
    1592:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
    1596:	79 04                	jns    159c <print_d+0x25>
    x = -x;
    1598:	48 f7 5d f8          	negq   -0x8(%rbp)

  int i = 0;
    159c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
  do {
    buf[i++] = digits[x % 10];
    15a3:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
    15a7:	48 ba 67 66 66 66 66 	movabs $0x6666666666666667,%rdx
    15ae:	66 66 66 
    15b1:	48 89 c8             	mov    %rcx,%rax
    15b4:	48 f7 ea             	imul   %rdx
    15b7:	48 c1 fa 02          	sar    $0x2,%rdx
    15bb:	48 89 c8             	mov    %rcx,%rax
    15be:	48 c1 f8 3f          	sar    $0x3f,%rax
    15c2:	48 29 c2             	sub    %rax,%rdx
    15c5:	48 89 d0             	mov    %rdx,%rax
    15c8:	48 c1 e0 02          	shl    $0x2,%rax
    15cc:	48 01 d0             	add    %rdx,%rax
    15cf:	48 01 c0             	add    %rax,%rax
    15d2:	48 29 c1             	sub    %rax,%rcx
    15d5:	48 89 ca             	mov    %rcx,%rdx
    15d8:	8b 45 f4             	mov    -0xc(%rbp),%eax
    15db:	8d 48 01             	lea    0x1(%rax),%ecx
    15de:	89 4d f4             	mov    %ecx,-0xc(%rbp)
    15e1:	48 b9 c0 20 00 00 00 	movabs $0x20c0,%rcx
    15e8:	00 00 00 
    15eb:	0f b6 14 11          	movzbl (%rcx,%rdx,1),%edx
    15ef:	48 98                	cltq   
    15f1:	88 54 05 e0          	mov    %dl,-0x20(%rbp,%rax,1)
    x /= 10;
    15f5:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
    15f9:	48 ba 67 66 66 66 66 	movabs $0x6666666666666667,%rdx
    1600:	66 66 66 
    1603:	48 89 c8             	mov    %rcx,%rax
    1606:	48 f7 ea             	imul   %rdx
    1609:	48 c1 fa 02          	sar    $0x2,%rdx
    160d:	48 89 c8             	mov    %rcx,%rax
    1610:	48 c1 f8 3f          	sar    $0x3f,%rax
    1614:	48 29 c2             	sub    %rax,%rdx
    1617:	48 89 d0             	mov    %rdx,%rax
    161a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  } while(x != 0);
    161e:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
    1623:	0f 85 7a ff ff ff    	jne    15a3 <print_d+0x2c>

  if (v < 0)
    1629:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
    162d:	79 32                	jns    1661 <print_d+0xea>
    buf[i++] = '-';
    162f:	8b 45 f4             	mov    -0xc(%rbp),%eax
    1632:	8d 50 01             	lea    0x1(%rax),%edx
    1635:	89 55 f4             	mov    %edx,-0xc(%rbp)
    1638:	48 98                	cltq   
    163a:	c6 44 05 e0 2d       	movb   $0x2d,-0x20(%rbp,%rax,1)

  while (--i >= 0)
    163f:	eb 20                	jmp    1661 <print_d+0xea>
    putc(fd, buf[i]);
    1641:	8b 45 f4             	mov    -0xc(%rbp),%eax
    1644:	48 98                	cltq   
    1646:	0f b6 44 05 e0       	movzbl -0x20(%rbp,%rax,1),%eax
    164b:	0f be d0             	movsbl %al,%edx
    164e:	8b 45 dc             	mov    -0x24(%rbp),%eax
    1651:	89 d6                	mov    %edx,%esi
    1653:	89 c7                	mov    %eax,%edi
    1655:	48 b8 89 14 00 00 00 	movabs $0x1489,%rax
    165c:	00 00 00 
    165f:	ff d0                	callq  *%rax
  while (--i >= 0)
    1661:	83 6d f4 01          	subl   $0x1,-0xc(%rbp)
    1665:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
    1669:	79 d6                	jns    1641 <print_d+0xca>
}
    166b:	90                   	nop
    166c:	90                   	nop
    166d:	c9                   	leaveq 
    166e:	c3                   	retq   

000000000000166f <printf>:
// Print to the given fd. Only understands %d, %x, %p, %s.
  void
printf(int fd, char *fmt, ...)
{
    166f:	f3 0f 1e fa          	endbr64 
    1673:	55                   	push   %rbp
    1674:	48 89 e5             	mov    %rsp,%rbp
    1677:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
    167e:	89 bd 1c ff ff ff    	mov    %edi,-0xe4(%rbp)
    1684:	48 89 b5 10 ff ff ff 	mov    %rsi,-0xf0(%rbp)
    168b:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
    1692:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
    1699:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
    16a0:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
    16a7:	84 c0                	test   %al,%al
    16a9:	74 20                	je     16cb <printf+0x5c>
    16ab:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
    16af:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
    16b3:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
    16b7:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
    16bb:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
    16bf:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
    16c3:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
    16c7:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  va_list ap;
  int i, c;
  char *s;

  va_start(ap, fmt);
    16cb:	c7 85 20 ff ff ff 10 	movl   $0x10,-0xe0(%rbp)
    16d2:	00 00 00 
    16d5:	c7 85 24 ff ff ff 30 	movl   $0x30,-0xdc(%rbp)
    16dc:	00 00 00 
    16df:	48 8d 45 10          	lea    0x10(%rbp),%rax
    16e3:	48 89 85 28 ff ff ff 	mov    %rax,-0xd8(%rbp)
    16ea:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
    16f1:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
    16f8:	c7 85 4c ff ff ff 00 	movl   $0x0,-0xb4(%rbp)
    16ff:	00 00 00 
    1702:	e9 41 03 00 00       	jmpq   1a48 <printf+0x3d9>
    if (c != '%') {
    1707:	83 bd 3c ff ff ff 25 	cmpl   $0x25,-0xc4(%rbp)
    170e:	74 24                	je     1734 <printf+0xc5>
      putc(fd, c);
    1710:	8b 85 3c ff ff ff    	mov    -0xc4(%rbp),%eax
    1716:	0f be d0             	movsbl %al,%edx
    1719:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    171f:	89 d6                	mov    %edx,%esi
    1721:	89 c7                	mov    %eax,%edi
    1723:	48 b8 89 14 00 00 00 	movabs $0x1489,%rax
    172a:	00 00 00 
    172d:	ff d0                	callq  *%rax
      continue;
    172f:	e9 0d 03 00 00       	jmpq   1a41 <printf+0x3d2>
    }
    c = fmt[++i] & 0xff;
    1734:	83 85 4c ff ff ff 01 	addl   $0x1,-0xb4(%rbp)
    173b:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
    1741:	48 63 d0             	movslq %eax,%rdx
    1744:	48 8b 85 10 ff ff ff 	mov    -0xf0(%rbp),%rax
    174b:	48 01 d0             	add    %rdx,%rax
    174e:	0f b6 00             	movzbl (%rax),%eax
    1751:	0f be c0             	movsbl %al,%eax
    1754:	25 ff 00 00 00       	and    $0xff,%eax
    1759:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%rbp)
    if (c == 0)
    175f:	83 bd 3c ff ff ff 00 	cmpl   $0x0,-0xc4(%rbp)
    1766:	0f 84 0f 03 00 00    	je     1a7b <printf+0x40c>
      break;
    switch(c) {
    176c:	83 bd 3c ff ff ff 25 	cmpl   $0x25,-0xc4(%rbp)
    1773:	0f 84 74 02 00 00    	je     19ed <printf+0x37e>
    1779:	83 bd 3c ff ff ff 25 	cmpl   $0x25,-0xc4(%rbp)
    1780:	0f 8c 82 02 00 00    	jl     1a08 <printf+0x399>
    1786:	83 bd 3c ff ff ff 78 	cmpl   $0x78,-0xc4(%rbp)
    178d:	0f 8f 75 02 00 00    	jg     1a08 <printf+0x399>
    1793:	83 bd 3c ff ff ff 63 	cmpl   $0x63,-0xc4(%rbp)
    179a:	0f 8c 68 02 00 00    	jl     1a08 <printf+0x399>
    17a0:	8b 85 3c ff ff ff    	mov    -0xc4(%rbp),%eax
    17a6:	83 e8 63             	sub    $0x63,%eax
    17a9:	83 f8 15             	cmp    $0x15,%eax
    17ac:	0f 87 56 02 00 00    	ja     1a08 <printf+0x399>
    17b2:	89 c0                	mov    %eax,%eax
    17b4:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
    17bb:	00 
    17bc:	48 b8 90 1d 00 00 00 	movabs $0x1d90,%rax
    17c3:	00 00 00 
    17c6:	48 01 d0             	add    %rdx,%rax
    17c9:	48 8b 00             	mov    (%rax),%rax
    17cc:	3e ff e0             	notrack jmpq *%rax
    case 'c':
      putc(fd, va_arg(ap, int));
    17cf:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    17d5:	83 f8 2f             	cmp    $0x2f,%eax
    17d8:	77 23                	ja     17fd <printf+0x18e>
    17da:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    17e1:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    17e7:	89 d2                	mov    %edx,%edx
    17e9:	48 01 d0             	add    %rdx,%rax
    17ec:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    17f2:	83 c2 08             	add    $0x8,%edx
    17f5:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    17fb:	eb 12                	jmp    180f <printf+0x1a0>
    17fd:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    1804:	48 8d 50 08          	lea    0x8(%rax),%rdx
    1808:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    180f:	8b 00                	mov    (%rax),%eax
    1811:	0f be d0             	movsbl %al,%edx
    1814:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    181a:	89 d6                	mov    %edx,%esi
    181c:	89 c7                	mov    %eax,%edi
    181e:	48 b8 89 14 00 00 00 	movabs $0x1489,%rax
    1825:	00 00 00 
    1828:	ff d0                	callq  *%rax
      break;
    182a:	e9 12 02 00 00       	jmpq   1a41 <printf+0x3d2>
    case 'd':
      print_d(fd, va_arg(ap, int));
    182f:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    1835:	83 f8 2f             	cmp    $0x2f,%eax
    1838:	77 23                	ja     185d <printf+0x1ee>
    183a:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    1841:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1847:	89 d2                	mov    %edx,%edx
    1849:	48 01 d0             	add    %rdx,%rax
    184c:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1852:	83 c2 08             	add    $0x8,%edx
    1855:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    185b:	eb 12                	jmp    186f <printf+0x200>
    185d:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    1864:	48 8d 50 08          	lea    0x8(%rax),%rdx
    1868:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    186f:	8b 10                	mov    (%rax),%edx
    1871:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1877:	89 d6                	mov    %edx,%esi
    1879:	89 c7                	mov    %eax,%edi
    187b:	48 b8 77 15 00 00 00 	movabs $0x1577,%rax
    1882:	00 00 00 
    1885:	ff d0                	callq  *%rax
      break;
    1887:	e9 b5 01 00 00       	jmpq   1a41 <printf+0x3d2>
    case 'x':
      print_x32(fd, va_arg(ap, uint));
    188c:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    1892:	83 f8 2f             	cmp    $0x2f,%eax
    1895:	77 23                	ja     18ba <printf+0x24b>
    1897:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    189e:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    18a4:	89 d2                	mov    %edx,%edx
    18a6:	48 01 d0             	add    %rdx,%rax
    18a9:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    18af:	83 c2 08             	add    $0x8,%edx
    18b2:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    18b8:	eb 12                	jmp    18cc <printf+0x25d>
    18ba:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    18c1:	48 8d 50 08          	lea    0x8(%rax),%rdx
    18c5:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    18cc:	8b 10                	mov    (%rax),%edx
    18ce:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    18d4:	89 d6                	mov    %edx,%esi
    18d6:	89 c7                	mov    %eax,%edi
    18d8:	48 b8 1a 15 00 00 00 	movabs $0x151a,%rax
    18df:	00 00 00 
    18e2:	ff d0                	callq  *%rax
      break;
    18e4:	e9 58 01 00 00       	jmpq   1a41 <printf+0x3d2>
    case 'p':
      print_x64(fd, va_arg(ap, addr_t));
    18e9:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    18ef:	83 f8 2f             	cmp    $0x2f,%eax
    18f2:	77 23                	ja     1917 <printf+0x2a8>
    18f4:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    18fb:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1901:	89 d2                	mov    %edx,%edx
    1903:	48 01 d0             	add    %rdx,%rax
    1906:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    190c:	83 c2 08             	add    $0x8,%edx
    190f:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    1915:	eb 12                	jmp    1929 <printf+0x2ba>
    1917:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    191e:	48 8d 50 08          	lea    0x8(%rax),%rdx
    1922:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    1929:	48 8b 10             	mov    (%rax),%rdx
    192c:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1932:	48 89 d6             	mov    %rdx,%rsi
    1935:	89 c7                	mov    %eax,%edi
    1937:	48 b8 bd 14 00 00 00 	movabs $0x14bd,%rax
    193e:	00 00 00 
    1941:	ff d0                	callq  *%rax
      break;
    1943:	e9 f9 00 00 00       	jmpq   1a41 <printf+0x3d2>
    case 's':
      if ((s = va_arg(ap, char*)) == 0)
    1948:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    194e:	83 f8 2f             	cmp    $0x2f,%eax
    1951:	77 23                	ja     1976 <printf+0x307>
    1953:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    195a:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1960:	89 d2                	mov    %edx,%edx
    1962:	48 01 d0             	add    %rdx,%rax
    1965:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    196b:	83 c2 08             	add    $0x8,%edx
    196e:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    1974:	eb 12                	jmp    1988 <printf+0x319>
    1976:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    197d:	48 8d 50 08          	lea    0x8(%rax),%rdx
    1981:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    1988:	48 8b 00             	mov    (%rax),%rax
    198b:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    1992:	48 83 bd 40 ff ff ff 	cmpq   $0x0,-0xc0(%rbp)
    1999:	00 
    199a:	75 41                	jne    19dd <printf+0x36e>
        s = "(null)";
    199c:	48 b8 88 1d 00 00 00 	movabs $0x1d88,%rax
    19a3:	00 00 00 
    19a6:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
      while (*s)
    19ad:	eb 2e                	jmp    19dd <printf+0x36e>
        putc(fd, *(s++));
    19af:	48 8b 85 40 ff ff ff 	mov    -0xc0(%rbp),%rax
    19b6:	48 8d 50 01          	lea    0x1(%rax),%rdx
    19ba:	48 89 95 40 ff ff ff 	mov    %rdx,-0xc0(%rbp)
    19c1:	0f b6 00             	movzbl (%rax),%eax
    19c4:	0f be d0             	movsbl %al,%edx
    19c7:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    19cd:	89 d6                	mov    %edx,%esi
    19cf:	89 c7                	mov    %eax,%edi
    19d1:	48 b8 89 14 00 00 00 	movabs $0x1489,%rax
    19d8:	00 00 00 
    19db:	ff d0                	callq  *%rax
      while (*s)
    19dd:	48 8b 85 40 ff ff ff 	mov    -0xc0(%rbp),%rax
    19e4:	0f b6 00             	movzbl (%rax),%eax
    19e7:	84 c0                	test   %al,%al
    19e9:	75 c4                	jne    19af <printf+0x340>
      break;
    19eb:	eb 54                	jmp    1a41 <printf+0x3d2>
    case '%':
      putc(fd, '%');
    19ed:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    19f3:	be 25 00 00 00       	mov    $0x25,%esi
    19f8:	89 c7                	mov    %eax,%edi
    19fa:	48 b8 89 14 00 00 00 	movabs $0x1489,%rax
    1a01:	00 00 00 
    1a04:	ff d0                	callq  *%rax
      break;
    1a06:	eb 39                	jmp    1a41 <printf+0x3d2>
    default:
      // Print unknown % sequence to draw attention.
      putc(fd, '%');
    1a08:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1a0e:	be 25 00 00 00       	mov    $0x25,%esi
    1a13:	89 c7                	mov    %eax,%edi
    1a15:	48 b8 89 14 00 00 00 	movabs $0x1489,%rax
    1a1c:	00 00 00 
    1a1f:	ff d0                	callq  *%rax
      putc(fd, c);
    1a21:	8b 85 3c ff ff ff    	mov    -0xc4(%rbp),%eax
    1a27:	0f be d0             	movsbl %al,%edx
    1a2a:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1a30:	89 d6                	mov    %edx,%esi
    1a32:	89 c7                	mov    %eax,%edi
    1a34:	48 b8 89 14 00 00 00 	movabs $0x1489,%rax
    1a3b:	00 00 00 
    1a3e:	ff d0                	callq  *%rax
      break;
    1a40:	90                   	nop
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
    1a41:	83 85 4c ff ff ff 01 	addl   $0x1,-0xb4(%rbp)
    1a48:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
    1a4e:	48 63 d0             	movslq %eax,%rdx
    1a51:	48 8b 85 10 ff ff ff 	mov    -0xf0(%rbp),%rax
    1a58:	48 01 d0             	add    %rdx,%rax
    1a5b:	0f b6 00             	movzbl (%rax),%eax
    1a5e:	0f be c0             	movsbl %al,%eax
    1a61:	25 ff 00 00 00       	and    $0xff,%eax
    1a66:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%rbp)
    1a6c:	83 bd 3c ff ff ff 00 	cmpl   $0x0,-0xc4(%rbp)
    1a73:	0f 85 8e fc ff ff    	jne    1707 <printf+0x98>
    }
  }
}
    1a79:	eb 01                	jmp    1a7c <printf+0x40d>
      break;
    1a7b:	90                   	nop
}
    1a7c:	90                   	nop
    1a7d:	c9                   	leaveq 
    1a7e:	c3                   	retq   

0000000000001a7f <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1a7f:	f3 0f 1e fa          	endbr64 
    1a83:	55                   	push   %rbp
    1a84:	48 89 e5             	mov    %rsp,%rbp
    1a87:	48 83 ec 18          	sub    $0x18,%rsp
    1a8b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  Header *bp, *p;

  bp = (Header*)ap - 1;
    1a8f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1a93:	48 83 e8 10          	sub    $0x10,%rax
    1a97:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1a9b:	48 b8 f0 20 00 00 00 	movabs $0x20f0,%rax
    1aa2:	00 00 00 
    1aa5:	48 8b 00             	mov    (%rax),%rax
    1aa8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    1aac:	eb 2f                	jmp    1add <free+0x5e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1aae:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1ab2:	48 8b 00             	mov    (%rax),%rax
    1ab5:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
    1ab9:	72 17                	jb     1ad2 <free+0x53>
    1abb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1abf:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
    1ac3:	77 2f                	ja     1af4 <free+0x75>
    1ac5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1ac9:	48 8b 00             	mov    (%rax),%rax
    1acc:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
    1ad0:	72 22                	jb     1af4 <free+0x75>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1ad2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1ad6:	48 8b 00             	mov    (%rax),%rax
    1ad9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    1add:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1ae1:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
    1ae5:	76 c7                	jbe    1aae <free+0x2f>
    1ae7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1aeb:	48 8b 00             	mov    (%rax),%rax
    1aee:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
    1af2:	73 ba                	jae    1aae <free+0x2f>
      break;
  if(bp + bp->s.size == p->s.ptr){
    1af4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1af8:	8b 40 08             	mov    0x8(%rax),%eax
    1afb:	89 c0                	mov    %eax,%eax
    1afd:	48 c1 e0 04          	shl    $0x4,%rax
    1b01:	48 89 c2             	mov    %rax,%rdx
    1b04:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1b08:	48 01 c2             	add    %rax,%rdx
    1b0b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1b0f:	48 8b 00             	mov    (%rax),%rax
    1b12:	48 39 c2             	cmp    %rax,%rdx
    1b15:	75 2d                	jne    1b44 <free+0xc5>
    bp->s.size += p->s.ptr->s.size;
    1b17:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1b1b:	8b 50 08             	mov    0x8(%rax),%edx
    1b1e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1b22:	48 8b 00             	mov    (%rax),%rax
    1b25:	8b 40 08             	mov    0x8(%rax),%eax
    1b28:	01 c2                	add    %eax,%edx
    1b2a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1b2e:	89 50 08             	mov    %edx,0x8(%rax)
    bp->s.ptr = p->s.ptr->s.ptr;
    1b31:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1b35:	48 8b 00             	mov    (%rax),%rax
    1b38:	48 8b 10             	mov    (%rax),%rdx
    1b3b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1b3f:	48 89 10             	mov    %rdx,(%rax)
    1b42:	eb 0e                	jmp    1b52 <free+0xd3>
  } else
    bp->s.ptr = p->s.ptr;
    1b44:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1b48:	48 8b 10             	mov    (%rax),%rdx
    1b4b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1b4f:	48 89 10             	mov    %rdx,(%rax)
  if(p + p->s.size == bp){
    1b52:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1b56:	8b 40 08             	mov    0x8(%rax),%eax
    1b59:	89 c0                	mov    %eax,%eax
    1b5b:	48 c1 e0 04          	shl    $0x4,%rax
    1b5f:	48 89 c2             	mov    %rax,%rdx
    1b62:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1b66:	48 01 d0             	add    %rdx,%rax
    1b69:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
    1b6d:	75 27                	jne    1b96 <free+0x117>
    p->s.size += bp->s.size;
    1b6f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1b73:	8b 50 08             	mov    0x8(%rax),%edx
    1b76:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1b7a:	8b 40 08             	mov    0x8(%rax),%eax
    1b7d:	01 c2                	add    %eax,%edx
    1b7f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1b83:	89 50 08             	mov    %edx,0x8(%rax)
    p->s.ptr = bp->s.ptr;
    1b86:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1b8a:	48 8b 10             	mov    (%rax),%rdx
    1b8d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1b91:	48 89 10             	mov    %rdx,(%rax)
    1b94:	eb 0b                	jmp    1ba1 <free+0x122>
  } else
    p->s.ptr = bp;
    1b96:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1b9a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
    1b9e:	48 89 10             	mov    %rdx,(%rax)
  freep = p;
    1ba1:	48 ba f0 20 00 00 00 	movabs $0x20f0,%rdx
    1ba8:	00 00 00 
    1bab:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1baf:	48 89 02             	mov    %rax,(%rdx)
}
    1bb2:	90                   	nop
    1bb3:	c9                   	leaveq 
    1bb4:	c3                   	retq   

0000000000001bb5 <morecore>:

static Header*
morecore(uint nu)
{
    1bb5:	f3 0f 1e fa          	endbr64 
    1bb9:	55                   	push   %rbp
    1bba:	48 89 e5             	mov    %rsp,%rbp
    1bbd:	48 83 ec 20          	sub    $0x20,%rsp
    1bc1:	89 7d ec             	mov    %edi,-0x14(%rbp)
  char *p;
  Header *hp;

  if(nu < 4096)
    1bc4:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%rbp)
    1bcb:	77 07                	ja     1bd4 <morecore+0x1f>
    nu = 4096;
    1bcd:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%rbp)
  p = sbrk(nu * sizeof(Header));
    1bd4:	8b 45 ec             	mov    -0x14(%rbp),%eax
    1bd7:	48 c1 e0 04          	shl    $0x4,%rax
    1bdb:	48 89 c7             	mov    %rax,%rdi
    1bde:	48 b8 55 14 00 00 00 	movabs $0x1455,%rax
    1be5:	00 00 00 
    1be8:	ff d0                	callq  *%rax
    1bea:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  if(p == (char*)-1)
    1bee:	48 83 7d f8 ff       	cmpq   $0xffffffffffffffff,-0x8(%rbp)
    1bf3:	75 07                	jne    1bfc <morecore+0x47>
    return 0;
    1bf5:	b8 00 00 00 00       	mov    $0x0,%eax
    1bfa:	eb 36                	jmp    1c32 <morecore+0x7d>
  hp = (Header*)p;
    1bfc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1c00:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  hp->s.size = nu;
    1c04:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1c08:	8b 55 ec             	mov    -0x14(%rbp),%edx
    1c0b:	89 50 08             	mov    %edx,0x8(%rax)
  free((void*)(hp + 1));
    1c0e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1c12:	48 83 c0 10          	add    $0x10,%rax
    1c16:	48 89 c7             	mov    %rax,%rdi
    1c19:	48 b8 7f 1a 00 00 00 	movabs $0x1a7f,%rax
    1c20:	00 00 00 
    1c23:	ff d0                	callq  *%rax
  return freep;
    1c25:	48 b8 f0 20 00 00 00 	movabs $0x20f0,%rax
    1c2c:	00 00 00 
    1c2f:	48 8b 00             	mov    (%rax),%rax
}
    1c32:	c9                   	leaveq 
    1c33:	c3                   	retq   

0000000000001c34 <malloc>:

void*
malloc(uint nbytes)
{
    1c34:	f3 0f 1e fa          	endbr64 
    1c38:	55                   	push   %rbp
    1c39:	48 89 e5             	mov    %rsp,%rbp
    1c3c:	48 83 ec 30          	sub    $0x30,%rsp
    1c40:	89 7d dc             	mov    %edi,-0x24(%rbp)
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1c43:	8b 45 dc             	mov    -0x24(%rbp),%eax
    1c46:	48 83 c0 0f          	add    $0xf,%rax
    1c4a:	48 c1 e8 04          	shr    $0x4,%rax
    1c4e:	83 c0 01             	add    $0x1,%eax
    1c51:	89 45 ec             	mov    %eax,-0x14(%rbp)
  if((prevp = freep) == 0){
    1c54:	48 b8 f0 20 00 00 00 	movabs $0x20f0,%rax
    1c5b:	00 00 00 
    1c5e:	48 8b 00             	mov    (%rax),%rax
    1c61:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    1c65:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
    1c6a:	75 4a                	jne    1cb6 <malloc+0x82>
    base.s.ptr = freep = prevp = &base;
    1c6c:	48 b8 e0 20 00 00 00 	movabs $0x20e0,%rax
    1c73:	00 00 00 
    1c76:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    1c7a:	48 ba f0 20 00 00 00 	movabs $0x20f0,%rdx
    1c81:	00 00 00 
    1c84:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1c88:	48 89 02             	mov    %rax,(%rdx)
    1c8b:	48 b8 f0 20 00 00 00 	movabs $0x20f0,%rax
    1c92:	00 00 00 
    1c95:	48 8b 00             	mov    (%rax),%rax
    1c98:	48 ba e0 20 00 00 00 	movabs $0x20e0,%rdx
    1c9f:	00 00 00 
    1ca2:	48 89 02             	mov    %rax,(%rdx)
    base.s.size = 0;
    1ca5:	48 b8 e0 20 00 00 00 	movabs $0x20e0,%rax
    1cac:	00 00 00 
    1caf:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1cb6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1cba:	48 8b 00             	mov    (%rax),%rax
    1cbd:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    if(p->s.size >= nunits){
    1cc1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1cc5:	8b 40 08             	mov    0x8(%rax),%eax
    1cc8:	39 45 ec             	cmp    %eax,-0x14(%rbp)
    1ccb:	77 65                	ja     1d32 <malloc+0xfe>
      if(p->s.size == nunits)
    1ccd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1cd1:	8b 40 08             	mov    0x8(%rax),%eax
    1cd4:	39 45 ec             	cmp    %eax,-0x14(%rbp)
    1cd7:	75 10                	jne    1ce9 <malloc+0xb5>
        prevp->s.ptr = p->s.ptr;
    1cd9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1cdd:	48 8b 10             	mov    (%rax),%rdx
    1ce0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1ce4:	48 89 10             	mov    %rdx,(%rax)
    1ce7:	eb 2e                	jmp    1d17 <malloc+0xe3>
      else {
        p->s.size -= nunits;
    1ce9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1ced:	8b 40 08             	mov    0x8(%rax),%eax
    1cf0:	2b 45 ec             	sub    -0x14(%rbp),%eax
    1cf3:	89 c2                	mov    %eax,%edx
    1cf5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1cf9:	89 50 08             	mov    %edx,0x8(%rax)
        p += p->s.size;
    1cfc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d00:	8b 40 08             	mov    0x8(%rax),%eax
    1d03:	89 c0                	mov    %eax,%eax
    1d05:	48 c1 e0 04          	shl    $0x4,%rax
    1d09:	48 01 45 f8          	add    %rax,-0x8(%rbp)
        p->s.size = nunits;
    1d0d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d11:	8b 55 ec             	mov    -0x14(%rbp),%edx
    1d14:	89 50 08             	mov    %edx,0x8(%rax)
      }
      freep = prevp;
    1d17:	48 ba f0 20 00 00 00 	movabs $0x20f0,%rdx
    1d1e:	00 00 00 
    1d21:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1d25:	48 89 02             	mov    %rax,(%rdx)
      return (void*)(p + 1);
    1d28:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d2c:	48 83 c0 10          	add    $0x10,%rax
    1d30:	eb 4e                	jmp    1d80 <malloc+0x14c>
    }
    if(p == freep)
    1d32:	48 b8 f0 20 00 00 00 	movabs $0x20f0,%rax
    1d39:	00 00 00 
    1d3c:	48 8b 00             	mov    (%rax),%rax
    1d3f:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
    1d43:	75 23                	jne    1d68 <malloc+0x134>
      if((p = morecore(nunits)) == 0)
    1d45:	8b 45 ec             	mov    -0x14(%rbp),%eax
    1d48:	89 c7                	mov    %eax,%edi
    1d4a:	48 b8 b5 1b 00 00 00 	movabs $0x1bb5,%rax
    1d51:	00 00 00 
    1d54:	ff d0                	callq  *%rax
    1d56:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    1d5a:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
    1d5f:	75 07                	jne    1d68 <malloc+0x134>
        return 0;
    1d61:	b8 00 00 00 00       	mov    $0x0,%eax
    1d66:	eb 18                	jmp    1d80 <malloc+0x14c>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1d68:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d6c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    1d70:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d74:	48 8b 00             	mov    (%rax),%rax
    1d77:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    if(p->s.size >= nunits){
    1d7b:	e9 41 ff ff ff       	jmpq   1cc1 <malloc+0x8d>
  }
}
    1d80:	c9                   	leaveq 
    1d81:	c3                   	retq   

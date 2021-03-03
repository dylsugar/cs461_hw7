
_kill:     file format elf64-x86-64


Disassembly of section .text:

0000000000001000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc, char **argv)
{
    1000:	f3 0f 1e fa          	endbr64 
    1004:	55                   	push   %rbp
    1005:	48 89 e5             	mov    %rsp,%rbp
    1008:	48 83 ec 20          	sub    $0x20,%rsp
    100c:	89 7d ec             	mov    %edi,-0x14(%rbp)
    100f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  int i;

  if(argc < 2){
    1013:	83 7d ec 01          	cmpl   $0x1,-0x14(%rbp)
    1017:	7f 2c                	jg     1045 <main+0x45>
    printf(2, "usage: kill pid...\n");
    1019:	48 be e8 1d 00 00 00 	movabs $0x1de8,%rsi
    1020:	00 00 00 
    1023:	bf 02 00 00 00       	mov    $0x2,%edi
    1028:	b8 00 00 00 00       	mov    $0x0,%eax
    102d:	48 ba d4 16 00 00 00 	movabs $0x16d4,%rdx
    1034:	00 00 00 
    1037:	ff d2                	callq  *%rdx
    exit();
    1039:	48 b8 dd 13 00 00 00 	movabs $0x13dd,%rax
    1040:	00 00 00 
    1043:	ff d0                	callq  *%rax
  }
  for(i=1; i<argc; i++)
    1045:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
    104c:	eb 38                	jmp    1086 <main+0x86>
    kill(atoi(argv[i]));
    104e:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1051:	48 98                	cltq   
    1053:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
    105a:	00 
    105b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    105f:	48 01 d0             	add    %rdx,%rax
    1062:	48 8b 00             	mov    (%rax),%rax
    1065:	48 89 c7             	mov    %rax,%rdi
    1068:	48 b8 1b 13 00 00 00 	movabs $0x131b,%rax
    106f:	00 00 00 
    1072:	ff d0                	callq  *%rax
    1074:	89 c7                	mov    %eax,%edi
    1076:	48 b8 2b 14 00 00 00 	movabs $0x142b,%rax
    107d:	00 00 00 
    1080:	ff d0                	callq  *%rax
  for(i=1; i<argc; i++)
    1082:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    1086:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1089:	3b 45 ec             	cmp    -0x14(%rbp),%eax
    108c:	7c c0                	jl     104e <main+0x4e>
  exit();
    108e:	48 b8 dd 13 00 00 00 	movabs $0x13dd,%rax
    1095:	00 00 00 
    1098:	ff d0                	callq  *%rax

000000000000109a <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
    109a:	f3 0f 1e fa          	endbr64 
    109e:	55                   	push   %rbp
    109f:	48 89 e5             	mov    %rsp,%rbp
    10a2:	48 83 ec 10          	sub    $0x10,%rsp
    10a6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    10aa:	89 75 f4             	mov    %esi,-0xc(%rbp)
    10ad:	89 55 f0             	mov    %edx,-0x10(%rbp)
  asm volatile("cld; rep stosb" :
    10b0:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
    10b4:	8b 55 f0             	mov    -0x10(%rbp),%edx
    10b7:	8b 45 f4             	mov    -0xc(%rbp),%eax
    10ba:	48 89 ce             	mov    %rcx,%rsi
    10bd:	48 89 f7             	mov    %rsi,%rdi
    10c0:	89 d1                	mov    %edx,%ecx
    10c2:	fc                   	cld    
    10c3:	f3 aa                	rep stos %al,%es:(%rdi)
    10c5:	89 ca                	mov    %ecx,%edx
    10c7:	48 89 fe             	mov    %rdi,%rsi
    10ca:	48 89 75 f8          	mov    %rsi,-0x8(%rbp)
    10ce:	89 55 f0             	mov    %edx,-0x10(%rbp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
    10d1:	90                   	nop
    10d2:	c9                   	leaveq 
    10d3:	c3                   	retq   

00000000000010d4 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
    10d4:	f3 0f 1e fa          	endbr64 
    10d8:	55                   	push   %rbp
    10d9:	48 89 e5             	mov    %rsp,%rbp
    10dc:	48 83 ec 20          	sub    $0x20,%rsp
    10e0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    10e4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  char *os;

  os = s;
    10e8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    10ec:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  while((*s++ = *t++) != 0)
    10f0:	90                   	nop
    10f1:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
    10f5:	48 8d 42 01          	lea    0x1(%rdx),%rax
    10f9:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    10fd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1101:	48 8d 48 01          	lea    0x1(%rax),%rcx
    1105:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
    1109:	0f b6 12             	movzbl (%rdx),%edx
    110c:	88 10                	mov    %dl,(%rax)
    110e:	0f b6 00             	movzbl (%rax),%eax
    1111:	84 c0                	test   %al,%al
    1113:	75 dc                	jne    10f1 <strcpy+0x1d>
    ;
  return os;
    1115:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
    1119:	c9                   	leaveq 
    111a:	c3                   	retq   

000000000000111b <strcmp>:

int
strcmp(const char *p, const char *q)
{
    111b:	f3 0f 1e fa          	endbr64 
    111f:	55                   	push   %rbp
    1120:	48 89 e5             	mov    %rsp,%rbp
    1123:	48 83 ec 10          	sub    $0x10,%rsp
    1127:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    112b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  while(*p && *p == *q)
    112f:	eb 0a                	jmp    113b <strcmp+0x20>
    p++, q++;
    1131:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
    1136:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
  while(*p && *p == *q)
    113b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    113f:	0f b6 00             	movzbl (%rax),%eax
    1142:	84 c0                	test   %al,%al
    1144:	74 12                	je     1158 <strcmp+0x3d>
    1146:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    114a:	0f b6 10             	movzbl (%rax),%edx
    114d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1151:	0f b6 00             	movzbl (%rax),%eax
    1154:	38 c2                	cmp    %al,%dl
    1156:	74 d9                	je     1131 <strcmp+0x16>
  return (uchar)*p - (uchar)*q;
    1158:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    115c:	0f b6 00             	movzbl (%rax),%eax
    115f:	0f b6 d0             	movzbl %al,%edx
    1162:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1166:	0f b6 00             	movzbl (%rax),%eax
    1169:	0f b6 c0             	movzbl %al,%eax
    116c:	29 c2                	sub    %eax,%edx
    116e:	89 d0                	mov    %edx,%eax
}
    1170:	c9                   	leaveq 
    1171:	c3                   	retq   

0000000000001172 <strlen>:

uint
strlen(char *s)
{
    1172:	f3 0f 1e fa          	endbr64 
    1176:	55                   	push   %rbp
    1177:	48 89 e5             	mov    %rsp,%rbp
    117a:	48 83 ec 18          	sub    $0x18,%rsp
    117e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  int n;

  for(n = 0; s[n]; n++)
    1182:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    1189:	eb 04                	jmp    118f <strlen+0x1d>
    118b:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    118f:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1192:	48 63 d0             	movslq %eax,%rdx
    1195:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1199:	48 01 d0             	add    %rdx,%rax
    119c:	0f b6 00             	movzbl (%rax),%eax
    119f:	84 c0                	test   %al,%al
    11a1:	75 e8                	jne    118b <strlen+0x19>
    ;
  return n;
    11a3:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
    11a6:	c9                   	leaveq 
    11a7:	c3                   	retq   

00000000000011a8 <memset>:

void*
memset(void *dst, int c, uint n)
{
    11a8:	f3 0f 1e fa          	endbr64 
    11ac:	55                   	push   %rbp
    11ad:	48 89 e5             	mov    %rsp,%rbp
    11b0:	48 83 ec 10          	sub    $0x10,%rsp
    11b4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    11b8:	89 75 f4             	mov    %esi,-0xc(%rbp)
    11bb:	89 55 f0             	mov    %edx,-0x10(%rbp)
  stosb(dst, c, n);
    11be:	8b 55 f0             	mov    -0x10(%rbp),%edx
    11c1:	8b 4d f4             	mov    -0xc(%rbp),%ecx
    11c4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    11c8:	89 ce                	mov    %ecx,%esi
    11ca:	48 89 c7             	mov    %rax,%rdi
    11cd:	48 b8 9a 10 00 00 00 	movabs $0x109a,%rax
    11d4:	00 00 00 
    11d7:	ff d0                	callq  *%rax
  return dst;
    11d9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
    11dd:	c9                   	leaveq 
    11de:	c3                   	retq   

00000000000011df <strchr>:

char*
strchr(const char *s, char c)
{
    11df:	f3 0f 1e fa          	endbr64 
    11e3:	55                   	push   %rbp
    11e4:	48 89 e5             	mov    %rsp,%rbp
    11e7:	48 83 ec 10          	sub    $0x10,%rsp
    11eb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    11ef:	89 f0                	mov    %esi,%eax
    11f1:	88 45 f4             	mov    %al,-0xc(%rbp)
  for(; *s; s++)
    11f4:	eb 17                	jmp    120d <strchr+0x2e>
    if(*s == c)
    11f6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    11fa:	0f b6 00             	movzbl (%rax),%eax
    11fd:	38 45 f4             	cmp    %al,-0xc(%rbp)
    1200:	75 06                	jne    1208 <strchr+0x29>
      return (char*)s;
    1202:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1206:	eb 15                	jmp    121d <strchr+0x3e>
  for(; *s; s++)
    1208:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
    120d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1211:	0f b6 00             	movzbl (%rax),%eax
    1214:	84 c0                	test   %al,%al
    1216:	75 de                	jne    11f6 <strchr+0x17>
  return 0;
    1218:	b8 00 00 00 00       	mov    $0x0,%eax
}
    121d:	c9                   	leaveq 
    121e:	c3                   	retq   

000000000000121f <gets>:

char*
gets(char *buf, int max)
{
    121f:	f3 0f 1e fa          	endbr64 
    1223:	55                   	push   %rbp
    1224:	48 89 e5             	mov    %rsp,%rbp
    1227:	48 83 ec 20          	sub    $0x20,%rsp
    122b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    122f:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    1232:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    1239:	eb 4f                	jmp    128a <gets+0x6b>
    cc = read(0, &c, 1);
    123b:	48 8d 45 f7          	lea    -0x9(%rbp),%rax
    123f:	ba 01 00 00 00       	mov    $0x1,%edx
    1244:	48 89 c6             	mov    %rax,%rsi
    1247:	bf 00 00 00 00       	mov    $0x0,%edi
    124c:	48 b8 04 14 00 00 00 	movabs $0x1404,%rax
    1253:	00 00 00 
    1256:	ff d0                	callq  *%rax
    1258:	89 45 f8             	mov    %eax,-0x8(%rbp)
    if(cc < 1)
    125b:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
    125f:	7e 36                	jle    1297 <gets+0x78>
      break;
    buf[i++] = c;
    1261:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1264:	8d 50 01             	lea    0x1(%rax),%edx
    1267:	89 55 fc             	mov    %edx,-0x4(%rbp)
    126a:	48 63 d0             	movslq %eax,%rdx
    126d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1271:	48 01 c2             	add    %rax,%rdx
    1274:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
    1278:	88 02                	mov    %al,(%rdx)
    if(c == '\n' || c == '\r')
    127a:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
    127e:	3c 0a                	cmp    $0xa,%al
    1280:	74 16                	je     1298 <gets+0x79>
    1282:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
    1286:	3c 0d                	cmp    $0xd,%al
    1288:	74 0e                	je     1298 <gets+0x79>
  for(i=0; i+1 < max; ){
    128a:	8b 45 fc             	mov    -0x4(%rbp),%eax
    128d:	83 c0 01             	add    $0x1,%eax
    1290:	39 45 e4             	cmp    %eax,-0x1c(%rbp)
    1293:	7f a6                	jg     123b <gets+0x1c>
    1295:	eb 01                	jmp    1298 <gets+0x79>
      break;
    1297:	90                   	nop
      break;
  }
  buf[i] = '\0';
    1298:	8b 45 fc             	mov    -0x4(%rbp),%eax
    129b:	48 63 d0             	movslq %eax,%rdx
    129e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    12a2:	48 01 d0             	add    %rdx,%rax
    12a5:	c6 00 00             	movb   $0x0,(%rax)
  return buf;
    12a8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
    12ac:	c9                   	leaveq 
    12ad:	c3                   	retq   

00000000000012ae <stat>:

int
stat(char *n, struct stat *st)
{
    12ae:	f3 0f 1e fa          	endbr64 
    12b2:	55                   	push   %rbp
    12b3:	48 89 e5             	mov    %rsp,%rbp
    12b6:	48 83 ec 20          	sub    $0x20,%rsp
    12ba:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    12be:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    12c2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    12c6:	be 00 00 00 00       	mov    $0x0,%esi
    12cb:	48 89 c7             	mov    %rax,%rdi
    12ce:	48 b8 45 14 00 00 00 	movabs $0x1445,%rax
    12d5:	00 00 00 
    12d8:	ff d0                	callq  *%rax
    12da:	89 45 fc             	mov    %eax,-0x4(%rbp)
  if(fd < 0)
    12dd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
    12e1:	79 07                	jns    12ea <stat+0x3c>
    return -1;
    12e3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    12e8:	eb 2f                	jmp    1319 <stat+0x6b>
  r = fstat(fd, st);
    12ea:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
    12ee:	8b 45 fc             	mov    -0x4(%rbp),%eax
    12f1:	48 89 d6             	mov    %rdx,%rsi
    12f4:	89 c7                	mov    %eax,%edi
    12f6:	48 b8 6c 14 00 00 00 	movabs $0x146c,%rax
    12fd:	00 00 00 
    1300:	ff d0                	callq  *%rax
    1302:	89 45 f8             	mov    %eax,-0x8(%rbp)
  close(fd);
    1305:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1308:	89 c7                	mov    %eax,%edi
    130a:	48 b8 1e 14 00 00 00 	movabs $0x141e,%rax
    1311:	00 00 00 
    1314:	ff d0                	callq  *%rax
  return r;
    1316:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
    1319:	c9                   	leaveq 
    131a:	c3                   	retq   

000000000000131b <atoi>:

int
atoi(const char *s)
{
    131b:	f3 0f 1e fa          	endbr64 
    131f:	55                   	push   %rbp
    1320:	48 89 e5             	mov    %rsp,%rbp
    1323:	48 83 ec 18          	sub    $0x18,%rsp
    1327:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  int n;

  n = 0;
    132b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  while('0' <= *s && *s <= '9')
    1332:	eb 28                	jmp    135c <atoi+0x41>
    n = n*10 + *s++ - '0';
    1334:	8b 55 fc             	mov    -0x4(%rbp),%edx
    1337:	89 d0                	mov    %edx,%eax
    1339:	c1 e0 02             	shl    $0x2,%eax
    133c:	01 d0                	add    %edx,%eax
    133e:	01 c0                	add    %eax,%eax
    1340:	89 c1                	mov    %eax,%ecx
    1342:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1346:	48 8d 50 01          	lea    0x1(%rax),%rdx
    134a:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
    134e:	0f b6 00             	movzbl (%rax),%eax
    1351:	0f be c0             	movsbl %al,%eax
    1354:	01 c8                	add    %ecx,%eax
    1356:	83 e8 30             	sub    $0x30,%eax
    1359:	89 45 fc             	mov    %eax,-0x4(%rbp)
  while('0' <= *s && *s <= '9')
    135c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1360:	0f b6 00             	movzbl (%rax),%eax
    1363:	3c 2f                	cmp    $0x2f,%al
    1365:	7e 0b                	jle    1372 <atoi+0x57>
    1367:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    136b:	0f b6 00             	movzbl (%rax),%eax
    136e:	3c 39                	cmp    $0x39,%al
    1370:	7e c2                	jle    1334 <atoi+0x19>
  return n;
    1372:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
    1375:	c9                   	leaveq 
    1376:	c3                   	retq   

0000000000001377 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    1377:	f3 0f 1e fa          	endbr64 
    137b:	55                   	push   %rbp
    137c:	48 89 e5             	mov    %rsp,%rbp
    137f:	48 83 ec 28          	sub    $0x28,%rsp
    1383:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    1387:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
    138b:	89 55 dc             	mov    %edx,-0x24(%rbp)
  char *dst, *src;

  dst = vdst;
    138e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1392:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  src = vsrc;
    1396:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    139a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  while(n-- > 0)
    139e:	eb 1d                	jmp    13bd <memmove+0x46>
    *dst++ = *src++;
    13a0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
    13a4:	48 8d 42 01          	lea    0x1(%rdx),%rax
    13a8:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    13ac:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    13b0:	48 8d 48 01          	lea    0x1(%rax),%rcx
    13b4:	48 89 4d f8          	mov    %rcx,-0x8(%rbp)
    13b8:	0f b6 12             	movzbl (%rdx),%edx
    13bb:	88 10                	mov    %dl,(%rax)
  while(n-- > 0)
    13bd:	8b 45 dc             	mov    -0x24(%rbp),%eax
    13c0:	8d 50 ff             	lea    -0x1(%rax),%edx
    13c3:	89 55 dc             	mov    %edx,-0x24(%rbp)
    13c6:	85 c0                	test   %eax,%eax
    13c8:	7f d6                	jg     13a0 <memmove+0x29>
  return vdst;
    13ca:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
    13ce:	c9                   	leaveq 
    13cf:	c3                   	retq   

00000000000013d0 <fork>:
    mov $SYS_ ## name, %rax; \
    mov %rcx, %r10 ;\
    syscall		  ;\
    ret

SYSCALL(fork)
    13d0:	48 c7 c0 01 00 00 00 	mov    $0x1,%rax
    13d7:	49 89 ca             	mov    %rcx,%r10
    13da:	0f 05                	syscall 
    13dc:	c3                   	retq   

00000000000013dd <exit>:
SYSCALL(exit)
    13dd:	48 c7 c0 02 00 00 00 	mov    $0x2,%rax
    13e4:	49 89 ca             	mov    %rcx,%r10
    13e7:	0f 05                	syscall 
    13e9:	c3                   	retq   

00000000000013ea <wait>:
SYSCALL(wait)
    13ea:	48 c7 c0 03 00 00 00 	mov    $0x3,%rax
    13f1:	49 89 ca             	mov    %rcx,%r10
    13f4:	0f 05                	syscall 
    13f6:	c3                   	retq   

00000000000013f7 <pipe>:
SYSCALL(pipe)
    13f7:	48 c7 c0 04 00 00 00 	mov    $0x4,%rax
    13fe:	49 89 ca             	mov    %rcx,%r10
    1401:	0f 05                	syscall 
    1403:	c3                   	retq   

0000000000001404 <read>:
SYSCALL(read)
    1404:	48 c7 c0 05 00 00 00 	mov    $0x5,%rax
    140b:	49 89 ca             	mov    %rcx,%r10
    140e:	0f 05                	syscall 
    1410:	c3                   	retq   

0000000000001411 <write>:
SYSCALL(write)
    1411:	48 c7 c0 10 00 00 00 	mov    $0x10,%rax
    1418:	49 89 ca             	mov    %rcx,%r10
    141b:	0f 05                	syscall 
    141d:	c3                   	retq   

000000000000141e <close>:
SYSCALL(close)
    141e:	48 c7 c0 15 00 00 00 	mov    $0x15,%rax
    1425:	49 89 ca             	mov    %rcx,%r10
    1428:	0f 05                	syscall 
    142a:	c3                   	retq   

000000000000142b <kill>:
SYSCALL(kill)
    142b:	48 c7 c0 06 00 00 00 	mov    $0x6,%rax
    1432:	49 89 ca             	mov    %rcx,%r10
    1435:	0f 05                	syscall 
    1437:	c3                   	retq   

0000000000001438 <exec>:
SYSCALL(exec)
    1438:	48 c7 c0 07 00 00 00 	mov    $0x7,%rax
    143f:	49 89 ca             	mov    %rcx,%r10
    1442:	0f 05                	syscall 
    1444:	c3                   	retq   

0000000000001445 <open>:
SYSCALL(open)
    1445:	48 c7 c0 0f 00 00 00 	mov    $0xf,%rax
    144c:	49 89 ca             	mov    %rcx,%r10
    144f:	0f 05                	syscall 
    1451:	c3                   	retq   

0000000000001452 <mknod>:
SYSCALL(mknod)
    1452:	48 c7 c0 11 00 00 00 	mov    $0x11,%rax
    1459:	49 89 ca             	mov    %rcx,%r10
    145c:	0f 05                	syscall 
    145e:	c3                   	retq   

000000000000145f <unlink>:
SYSCALL(unlink)
    145f:	48 c7 c0 12 00 00 00 	mov    $0x12,%rax
    1466:	49 89 ca             	mov    %rcx,%r10
    1469:	0f 05                	syscall 
    146b:	c3                   	retq   

000000000000146c <fstat>:
SYSCALL(fstat)
    146c:	48 c7 c0 08 00 00 00 	mov    $0x8,%rax
    1473:	49 89 ca             	mov    %rcx,%r10
    1476:	0f 05                	syscall 
    1478:	c3                   	retq   

0000000000001479 <link>:
SYSCALL(link)
    1479:	48 c7 c0 13 00 00 00 	mov    $0x13,%rax
    1480:	49 89 ca             	mov    %rcx,%r10
    1483:	0f 05                	syscall 
    1485:	c3                   	retq   

0000000000001486 <mkdir>:
SYSCALL(mkdir)
    1486:	48 c7 c0 14 00 00 00 	mov    $0x14,%rax
    148d:	49 89 ca             	mov    %rcx,%r10
    1490:	0f 05                	syscall 
    1492:	c3                   	retq   

0000000000001493 <chdir>:
SYSCALL(chdir)
    1493:	48 c7 c0 09 00 00 00 	mov    $0x9,%rax
    149a:	49 89 ca             	mov    %rcx,%r10
    149d:	0f 05                	syscall 
    149f:	c3                   	retq   

00000000000014a0 <dup>:
SYSCALL(dup)
    14a0:	48 c7 c0 0a 00 00 00 	mov    $0xa,%rax
    14a7:	49 89 ca             	mov    %rcx,%r10
    14aa:	0f 05                	syscall 
    14ac:	c3                   	retq   

00000000000014ad <getpid>:
SYSCALL(getpid)
    14ad:	48 c7 c0 0b 00 00 00 	mov    $0xb,%rax
    14b4:	49 89 ca             	mov    %rcx,%r10
    14b7:	0f 05                	syscall 
    14b9:	c3                   	retq   

00000000000014ba <sbrk>:
SYSCALL(sbrk)
    14ba:	48 c7 c0 0c 00 00 00 	mov    $0xc,%rax
    14c1:	49 89 ca             	mov    %rcx,%r10
    14c4:	0f 05                	syscall 
    14c6:	c3                   	retq   

00000000000014c7 <sleep>:
SYSCALL(sleep)
    14c7:	48 c7 c0 0d 00 00 00 	mov    $0xd,%rax
    14ce:	49 89 ca             	mov    %rcx,%r10
    14d1:	0f 05                	syscall 
    14d3:	c3                   	retq   

00000000000014d4 <uptime>:
SYSCALL(uptime)
    14d4:	48 c7 c0 0e 00 00 00 	mov    $0xe,%rax
    14db:	49 89 ca             	mov    %rcx,%r10
    14de:	0f 05                	syscall 
    14e0:	c3                   	retq   

00000000000014e1 <aread>:
SYSCALL(aread)
    14e1:	48 c7 c0 16 00 00 00 	mov    $0x16,%rax
    14e8:	49 89 ca             	mov    %rcx,%r10
    14eb:	0f 05                	syscall 
    14ed:	c3                   	retq   

00000000000014ee <putc>:

#include <stdarg.h>

static void
putc(int fd, char c)
{
    14ee:	f3 0f 1e fa          	endbr64 
    14f2:	55                   	push   %rbp
    14f3:	48 89 e5             	mov    %rsp,%rbp
    14f6:	48 83 ec 10          	sub    $0x10,%rsp
    14fa:	89 7d fc             	mov    %edi,-0x4(%rbp)
    14fd:	89 f0                	mov    %esi,%eax
    14ff:	88 45 f8             	mov    %al,-0x8(%rbp)
  write(fd, &c, 1);
    1502:	48 8d 4d f8          	lea    -0x8(%rbp),%rcx
    1506:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1509:	ba 01 00 00 00       	mov    $0x1,%edx
    150e:	48 89 ce             	mov    %rcx,%rsi
    1511:	89 c7                	mov    %eax,%edi
    1513:	48 b8 11 14 00 00 00 	movabs $0x1411,%rax
    151a:	00 00 00 
    151d:	ff d0                	callq  *%rax
}
    151f:	90                   	nop
    1520:	c9                   	leaveq 
    1521:	c3                   	retq   

0000000000001522 <print_x64>:

static char digits[] = "0123456789abcdef";

  static void
print_x64(int fd, addr_t x)
{
    1522:	f3 0f 1e fa          	endbr64 
    1526:	55                   	push   %rbp
    1527:	48 89 e5             	mov    %rsp,%rbp
    152a:	48 83 ec 20          	sub    $0x20,%rsp
    152e:	89 7d ec             	mov    %edi,-0x14(%rbp)
    1531:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  int i;
  for (i = 0; i < (sizeof(addr_t) * 2); i++, x <<= 4)
    1535:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    153c:	eb 35                	jmp    1573 <print_x64+0x51>
    putc(fd, digits[x >> (sizeof(addr_t) * 8 - 4)]);
    153e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    1542:	48 c1 e8 3c          	shr    $0x3c,%rax
    1546:	48 ba 30 21 00 00 00 	movabs $0x2130,%rdx
    154d:	00 00 00 
    1550:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
    1554:	0f be d0             	movsbl %al,%edx
    1557:	8b 45 ec             	mov    -0x14(%rbp),%eax
    155a:	89 d6                	mov    %edx,%esi
    155c:	89 c7                	mov    %eax,%edi
    155e:	48 b8 ee 14 00 00 00 	movabs $0x14ee,%rax
    1565:	00 00 00 
    1568:	ff d0                	callq  *%rax
  for (i = 0; i < (sizeof(addr_t) * 2); i++, x <<= 4)
    156a:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    156e:	48 c1 65 e0 04       	shlq   $0x4,-0x20(%rbp)
    1573:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1576:	83 f8 0f             	cmp    $0xf,%eax
    1579:	76 c3                	jbe    153e <print_x64+0x1c>
}
    157b:	90                   	nop
    157c:	90                   	nop
    157d:	c9                   	leaveq 
    157e:	c3                   	retq   

000000000000157f <print_x32>:

  static void
print_x32(int fd, uint x)
{
    157f:	f3 0f 1e fa          	endbr64 
    1583:	55                   	push   %rbp
    1584:	48 89 e5             	mov    %rsp,%rbp
    1587:	48 83 ec 20          	sub    $0x20,%rsp
    158b:	89 7d ec             	mov    %edi,-0x14(%rbp)
    158e:	89 75 e8             	mov    %esi,-0x18(%rbp)
  int i;
  for (i = 0; i < (sizeof(uint) * 2); i++, x <<= 4)
    1591:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    1598:	eb 36                	jmp    15d0 <print_x32+0x51>
    putc(fd, digits[x >> (sizeof(uint) * 8 - 4)]);
    159a:	8b 45 e8             	mov    -0x18(%rbp),%eax
    159d:	c1 e8 1c             	shr    $0x1c,%eax
    15a0:	89 c2                	mov    %eax,%edx
    15a2:	48 b8 30 21 00 00 00 	movabs $0x2130,%rax
    15a9:	00 00 00 
    15ac:	89 d2                	mov    %edx,%edx
    15ae:	0f b6 04 10          	movzbl (%rax,%rdx,1),%eax
    15b2:	0f be d0             	movsbl %al,%edx
    15b5:	8b 45 ec             	mov    -0x14(%rbp),%eax
    15b8:	89 d6                	mov    %edx,%esi
    15ba:	89 c7                	mov    %eax,%edi
    15bc:	48 b8 ee 14 00 00 00 	movabs $0x14ee,%rax
    15c3:	00 00 00 
    15c6:	ff d0                	callq  *%rax
  for (i = 0; i < (sizeof(uint) * 2); i++, x <<= 4)
    15c8:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    15cc:	c1 65 e8 04          	shll   $0x4,-0x18(%rbp)
    15d0:	8b 45 fc             	mov    -0x4(%rbp),%eax
    15d3:	83 f8 07             	cmp    $0x7,%eax
    15d6:	76 c2                	jbe    159a <print_x32+0x1b>
}
    15d8:	90                   	nop
    15d9:	90                   	nop
    15da:	c9                   	leaveq 
    15db:	c3                   	retq   

00000000000015dc <print_d>:

  static void
print_d(int fd, int v)
{
    15dc:	f3 0f 1e fa          	endbr64 
    15e0:	55                   	push   %rbp
    15e1:	48 89 e5             	mov    %rsp,%rbp
    15e4:	48 83 ec 30          	sub    $0x30,%rsp
    15e8:	89 7d dc             	mov    %edi,-0x24(%rbp)
    15eb:	89 75 d8             	mov    %esi,-0x28(%rbp)
  char buf[16];
  int64 x = v;
    15ee:	8b 45 d8             	mov    -0x28(%rbp),%eax
    15f1:	48 98                	cltq   
    15f3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

  if (v < 0)
    15f7:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
    15fb:	79 04                	jns    1601 <print_d+0x25>
    x = -x;
    15fd:	48 f7 5d f8          	negq   -0x8(%rbp)

  int i = 0;
    1601:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
  do {
    buf[i++] = digits[x % 10];
    1608:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
    160c:	48 ba 67 66 66 66 66 	movabs $0x6666666666666667,%rdx
    1613:	66 66 66 
    1616:	48 89 c8             	mov    %rcx,%rax
    1619:	48 f7 ea             	imul   %rdx
    161c:	48 c1 fa 02          	sar    $0x2,%rdx
    1620:	48 89 c8             	mov    %rcx,%rax
    1623:	48 c1 f8 3f          	sar    $0x3f,%rax
    1627:	48 29 c2             	sub    %rax,%rdx
    162a:	48 89 d0             	mov    %rdx,%rax
    162d:	48 c1 e0 02          	shl    $0x2,%rax
    1631:	48 01 d0             	add    %rdx,%rax
    1634:	48 01 c0             	add    %rax,%rax
    1637:	48 29 c1             	sub    %rax,%rcx
    163a:	48 89 ca             	mov    %rcx,%rdx
    163d:	8b 45 f4             	mov    -0xc(%rbp),%eax
    1640:	8d 48 01             	lea    0x1(%rax),%ecx
    1643:	89 4d f4             	mov    %ecx,-0xc(%rbp)
    1646:	48 b9 30 21 00 00 00 	movabs $0x2130,%rcx
    164d:	00 00 00 
    1650:	0f b6 14 11          	movzbl (%rcx,%rdx,1),%edx
    1654:	48 98                	cltq   
    1656:	88 54 05 e0          	mov    %dl,-0x20(%rbp,%rax,1)
    x /= 10;
    165a:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
    165e:	48 ba 67 66 66 66 66 	movabs $0x6666666666666667,%rdx
    1665:	66 66 66 
    1668:	48 89 c8             	mov    %rcx,%rax
    166b:	48 f7 ea             	imul   %rdx
    166e:	48 c1 fa 02          	sar    $0x2,%rdx
    1672:	48 89 c8             	mov    %rcx,%rax
    1675:	48 c1 f8 3f          	sar    $0x3f,%rax
    1679:	48 29 c2             	sub    %rax,%rdx
    167c:	48 89 d0             	mov    %rdx,%rax
    167f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  } while(x != 0);
    1683:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
    1688:	0f 85 7a ff ff ff    	jne    1608 <print_d+0x2c>

  if (v < 0)
    168e:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
    1692:	79 32                	jns    16c6 <print_d+0xea>
    buf[i++] = '-';
    1694:	8b 45 f4             	mov    -0xc(%rbp),%eax
    1697:	8d 50 01             	lea    0x1(%rax),%edx
    169a:	89 55 f4             	mov    %edx,-0xc(%rbp)
    169d:	48 98                	cltq   
    169f:	c6 44 05 e0 2d       	movb   $0x2d,-0x20(%rbp,%rax,1)

  while (--i >= 0)
    16a4:	eb 20                	jmp    16c6 <print_d+0xea>
    putc(fd, buf[i]);
    16a6:	8b 45 f4             	mov    -0xc(%rbp),%eax
    16a9:	48 98                	cltq   
    16ab:	0f b6 44 05 e0       	movzbl -0x20(%rbp,%rax,1),%eax
    16b0:	0f be d0             	movsbl %al,%edx
    16b3:	8b 45 dc             	mov    -0x24(%rbp),%eax
    16b6:	89 d6                	mov    %edx,%esi
    16b8:	89 c7                	mov    %eax,%edi
    16ba:	48 b8 ee 14 00 00 00 	movabs $0x14ee,%rax
    16c1:	00 00 00 
    16c4:	ff d0                	callq  *%rax
  while (--i >= 0)
    16c6:	83 6d f4 01          	subl   $0x1,-0xc(%rbp)
    16ca:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
    16ce:	79 d6                	jns    16a6 <print_d+0xca>
}
    16d0:	90                   	nop
    16d1:	90                   	nop
    16d2:	c9                   	leaveq 
    16d3:	c3                   	retq   

00000000000016d4 <printf>:
// Print to the given fd. Only understands %d, %x, %p, %s.
  void
printf(int fd, char *fmt, ...)
{
    16d4:	f3 0f 1e fa          	endbr64 
    16d8:	55                   	push   %rbp
    16d9:	48 89 e5             	mov    %rsp,%rbp
    16dc:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
    16e3:	89 bd 1c ff ff ff    	mov    %edi,-0xe4(%rbp)
    16e9:	48 89 b5 10 ff ff ff 	mov    %rsi,-0xf0(%rbp)
    16f0:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
    16f7:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
    16fe:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
    1705:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
    170c:	84 c0                	test   %al,%al
    170e:	74 20                	je     1730 <printf+0x5c>
    1710:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
    1714:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
    1718:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
    171c:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
    1720:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
    1724:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
    1728:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
    172c:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  va_list ap;
  int i, c;
  char *s;

  va_start(ap, fmt);
    1730:	c7 85 20 ff ff ff 10 	movl   $0x10,-0xe0(%rbp)
    1737:	00 00 00 
    173a:	c7 85 24 ff ff ff 30 	movl   $0x30,-0xdc(%rbp)
    1741:	00 00 00 
    1744:	48 8d 45 10          	lea    0x10(%rbp),%rax
    1748:	48 89 85 28 ff ff ff 	mov    %rax,-0xd8(%rbp)
    174f:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
    1756:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
    175d:	c7 85 4c ff ff ff 00 	movl   $0x0,-0xb4(%rbp)
    1764:	00 00 00 
    1767:	e9 41 03 00 00       	jmpq   1aad <printf+0x3d9>
    if (c != '%') {
    176c:	83 bd 3c ff ff ff 25 	cmpl   $0x25,-0xc4(%rbp)
    1773:	74 24                	je     1799 <printf+0xc5>
      putc(fd, c);
    1775:	8b 85 3c ff ff ff    	mov    -0xc4(%rbp),%eax
    177b:	0f be d0             	movsbl %al,%edx
    177e:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1784:	89 d6                	mov    %edx,%esi
    1786:	89 c7                	mov    %eax,%edi
    1788:	48 b8 ee 14 00 00 00 	movabs $0x14ee,%rax
    178f:	00 00 00 
    1792:	ff d0                	callq  *%rax
      continue;
    1794:	e9 0d 03 00 00       	jmpq   1aa6 <printf+0x3d2>
    }
    c = fmt[++i] & 0xff;
    1799:	83 85 4c ff ff ff 01 	addl   $0x1,-0xb4(%rbp)
    17a0:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
    17a6:	48 63 d0             	movslq %eax,%rdx
    17a9:	48 8b 85 10 ff ff ff 	mov    -0xf0(%rbp),%rax
    17b0:	48 01 d0             	add    %rdx,%rax
    17b3:	0f b6 00             	movzbl (%rax),%eax
    17b6:	0f be c0             	movsbl %al,%eax
    17b9:	25 ff 00 00 00       	and    $0xff,%eax
    17be:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%rbp)
    if (c == 0)
    17c4:	83 bd 3c ff ff ff 00 	cmpl   $0x0,-0xc4(%rbp)
    17cb:	0f 84 0f 03 00 00    	je     1ae0 <printf+0x40c>
      break;
    switch(c) {
    17d1:	83 bd 3c ff ff ff 25 	cmpl   $0x25,-0xc4(%rbp)
    17d8:	0f 84 74 02 00 00    	je     1a52 <printf+0x37e>
    17de:	83 bd 3c ff ff ff 25 	cmpl   $0x25,-0xc4(%rbp)
    17e5:	0f 8c 82 02 00 00    	jl     1a6d <printf+0x399>
    17eb:	83 bd 3c ff ff ff 78 	cmpl   $0x78,-0xc4(%rbp)
    17f2:	0f 8f 75 02 00 00    	jg     1a6d <printf+0x399>
    17f8:	83 bd 3c ff ff ff 63 	cmpl   $0x63,-0xc4(%rbp)
    17ff:	0f 8c 68 02 00 00    	jl     1a6d <printf+0x399>
    1805:	8b 85 3c ff ff ff    	mov    -0xc4(%rbp),%eax
    180b:	83 e8 63             	sub    $0x63,%eax
    180e:	83 f8 15             	cmp    $0x15,%eax
    1811:	0f 87 56 02 00 00    	ja     1a6d <printf+0x399>
    1817:	89 c0                	mov    %eax,%eax
    1819:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
    1820:	00 
    1821:	48 b8 08 1e 00 00 00 	movabs $0x1e08,%rax
    1828:	00 00 00 
    182b:	48 01 d0             	add    %rdx,%rax
    182e:	48 8b 00             	mov    (%rax),%rax
    1831:	3e ff e0             	notrack jmpq *%rax
    case 'c':
      putc(fd, va_arg(ap, int));
    1834:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    183a:	83 f8 2f             	cmp    $0x2f,%eax
    183d:	77 23                	ja     1862 <printf+0x18e>
    183f:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    1846:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    184c:	89 d2                	mov    %edx,%edx
    184e:	48 01 d0             	add    %rdx,%rax
    1851:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1857:	83 c2 08             	add    $0x8,%edx
    185a:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    1860:	eb 12                	jmp    1874 <printf+0x1a0>
    1862:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    1869:	48 8d 50 08          	lea    0x8(%rax),%rdx
    186d:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    1874:	8b 00                	mov    (%rax),%eax
    1876:	0f be d0             	movsbl %al,%edx
    1879:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    187f:	89 d6                	mov    %edx,%esi
    1881:	89 c7                	mov    %eax,%edi
    1883:	48 b8 ee 14 00 00 00 	movabs $0x14ee,%rax
    188a:	00 00 00 
    188d:	ff d0                	callq  *%rax
      break;
    188f:	e9 12 02 00 00       	jmpq   1aa6 <printf+0x3d2>
    case 'd':
      print_d(fd, va_arg(ap, int));
    1894:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    189a:	83 f8 2f             	cmp    $0x2f,%eax
    189d:	77 23                	ja     18c2 <printf+0x1ee>
    189f:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    18a6:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    18ac:	89 d2                	mov    %edx,%edx
    18ae:	48 01 d0             	add    %rdx,%rax
    18b1:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    18b7:	83 c2 08             	add    $0x8,%edx
    18ba:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    18c0:	eb 12                	jmp    18d4 <printf+0x200>
    18c2:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    18c9:	48 8d 50 08          	lea    0x8(%rax),%rdx
    18cd:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    18d4:	8b 10                	mov    (%rax),%edx
    18d6:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    18dc:	89 d6                	mov    %edx,%esi
    18de:	89 c7                	mov    %eax,%edi
    18e0:	48 b8 dc 15 00 00 00 	movabs $0x15dc,%rax
    18e7:	00 00 00 
    18ea:	ff d0                	callq  *%rax
      break;
    18ec:	e9 b5 01 00 00       	jmpq   1aa6 <printf+0x3d2>
    case 'x':
      print_x32(fd, va_arg(ap, uint));
    18f1:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    18f7:	83 f8 2f             	cmp    $0x2f,%eax
    18fa:	77 23                	ja     191f <printf+0x24b>
    18fc:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    1903:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1909:	89 d2                	mov    %edx,%edx
    190b:	48 01 d0             	add    %rdx,%rax
    190e:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1914:	83 c2 08             	add    $0x8,%edx
    1917:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    191d:	eb 12                	jmp    1931 <printf+0x25d>
    191f:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    1926:	48 8d 50 08          	lea    0x8(%rax),%rdx
    192a:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    1931:	8b 10                	mov    (%rax),%edx
    1933:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1939:	89 d6                	mov    %edx,%esi
    193b:	89 c7                	mov    %eax,%edi
    193d:	48 b8 7f 15 00 00 00 	movabs $0x157f,%rax
    1944:	00 00 00 
    1947:	ff d0                	callq  *%rax
      break;
    1949:	e9 58 01 00 00       	jmpq   1aa6 <printf+0x3d2>
    case 'p':
      print_x64(fd, va_arg(ap, addr_t));
    194e:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    1954:	83 f8 2f             	cmp    $0x2f,%eax
    1957:	77 23                	ja     197c <printf+0x2a8>
    1959:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    1960:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1966:	89 d2                	mov    %edx,%edx
    1968:	48 01 d0             	add    %rdx,%rax
    196b:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1971:	83 c2 08             	add    $0x8,%edx
    1974:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    197a:	eb 12                	jmp    198e <printf+0x2ba>
    197c:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    1983:	48 8d 50 08          	lea    0x8(%rax),%rdx
    1987:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    198e:	48 8b 10             	mov    (%rax),%rdx
    1991:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1997:	48 89 d6             	mov    %rdx,%rsi
    199a:	89 c7                	mov    %eax,%edi
    199c:	48 b8 22 15 00 00 00 	movabs $0x1522,%rax
    19a3:	00 00 00 
    19a6:	ff d0                	callq  *%rax
      break;
    19a8:	e9 f9 00 00 00       	jmpq   1aa6 <printf+0x3d2>
    case 's':
      if ((s = va_arg(ap, char*)) == 0)
    19ad:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    19b3:	83 f8 2f             	cmp    $0x2f,%eax
    19b6:	77 23                	ja     19db <printf+0x307>
    19b8:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    19bf:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    19c5:	89 d2                	mov    %edx,%edx
    19c7:	48 01 d0             	add    %rdx,%rax
    19ca:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    19d0:	83 c2 08             	add    $0x8,%edx
    19d3:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    19d9:	eb 12                	jmp    19ed <printf+0x319>
    19db:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    19e2:	48 8d 50 08          	lea    0x8(%rax),%rdx
    19e6:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    19ed:	48 8b 00             	mov    (%rax),%rax
    19f0:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    19f7:	48 83 bd 40 ff ff ff 	cmpq   $0x0,-0xc0(%rbp)
    19fe:	00 
    19ff:	75 41                	jne    1a42 <printf+0x36e>
        s = "(null)";
    1a01:	48 b8 00 1e 00 00 00 	movabs $0x1e00,%rax
    1a08:	00 00 00 
    1a0b:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
      while (*s)
    1a12:	eb 2e                	jmp    1a42 <printf+0x36e>
        putc(fd, *(s++));
    1a14:	48 8b 85 40 ff ff ff 	mov    -0xc0(%rbp),%rax
    1a1b:	48 8d 50 01          	lea    0x1(%rax),%rdx
    1a1f:	48 89 95 40 ff ff ff 	mov    %rdx,-0xc0(%rbp)
    1a26:	0f b6 00             	movzbl (%rax),%eax
    1a29:	0f be d0             	movsbl %al,%edx
    1a2c:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1a32:	89 d6                	mov    %edx,%esi
    1a34:	89 c7                	mov    %eax,%edi
    1a36:	48 b8 ee 14 00 00 00 	movabs $0x14ee,%rax
    1a3d:	00 00 00 
    1a40:	ff d0                	callq  *%rax
      while (*s)
    1a42:	48 8b 85 40 ff ff ff 	mov    -0xc0(%rbp),%rax
    1a49:	0f b6 00             	movzbl (%rax),%eax
    1a4c:	84 c0                	test   %al,%al
    1a4e:	75 c4                	jne    1a14 <printf+0x340>
      break;
    1a50:	eb 54                	jmp    1aa6 <printf+0x3d2>
    case '%':
      putc(fd, '%');
    1a52:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1a58:	be 25 00 00 00       	mov    $0x25,%esi
    1a5d:	89 c7                	mov    %eax,%edi
    1a5f:	48 b8 ee 14 00 00 00 	movabs $0x14ee,%rax
    1a66:	00 00 00 
    1a69:	ff d0                	callq  *%rax
      break;
    1a6b:	eb 39                	jmp    1aa6 <printf+0x3d2>
    default:
      // Print unknown % sequence to draw attention.
      putc(fd, '%');
    1a6d:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1a73:	be 25 00 00 00       	mov    $0x25,%esi
    1a78:	89 c7                	mov    %eax,%edi
    1a7a:	48 b8 ee 14 00 00 00 	movabs $0x14ee,%rax
    1a81:	00 00 00 
    1a84:	ff d0                	callq  *%rax
      putc(fd, c);
    1a86:	8b 85 3c ff ff ff    	mov    -0xc4(%rbp),%eax
    1a8c:	0f be d0             	movsbl %al,%edx
    1a8f:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1a95:	89 d6                	mov    %edx,%esi
    1a97:	89 c7                	mov    %eax,%edi
    1a99:	48 b8 ee 14 00 00 00 	movabs $0x14ee,%rax
    1aa0:	00 00 00 
    1aa3:	ff d0                	callq  *%rax
      break;
    1aa5:	90                   	nop
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
    1aa6:	83 85 4c ff ff ff 01 	addl   $0x1,-0xb4(%rbp)
    1aad:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
    1ab3:	48 63 d0             	movslq %eax,%rdx
    1ab6:	48 8b 85 10 ff ff ff 	mov    -0xf0(%rbp),%rax
    1abd:	48 01 d0             	add    %rdx,%rax
    1ac0:	0f b6 00             	movzbl (%rax),%eax
    1ac3:	0f be c0             	movsbl %al,%eax
    1ac6:	25 ff 00 00 00       	and    $0xff,%eax
    1acb:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%rbp)
    1ad1:	83 bd 3c ff ff ff 00 	cmpl   $0x0,-0xc4(%rbp)
    1ad8:	0f 85 8e fc ff ff    	jne    176c <printf+0x98>
    }
  }
}
    1ade:	eb 01                	jmp    1ae1 <printf+0x40d>
      break;
    1ae0:	90                   	nop
}
    1ae1:	90                   	nop
    1ae2:	c9                   	leaveq 
    1ae3:	c3                   	retq   

0000000000001ae4 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1ae4:	f3 0f 1e fa          	endbr64 
    1ae8:	55                   	push   %rbp
    1ae9:	48 89 e5             	mov    %rsp,%rbp
    1aec:	48 83 ec 18          	sub    $0x18,%rsp
    1af0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  Header *bp, *p;

  bp = (Header*)ap - 1;
    1af4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1af8:	48 83 e8 10          	sub    $0x10,%rax
    1afc:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1b00:	48 b8 60 21 00 00 00 	movabs $0x2160,%rax
    1b07:	00 00 00 
    1b0a:	48 8b 00             	mov    (%rax),%rax
    1b0d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    1b11:	eb 2f                	jmp    1b42 <free+0x5e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1b13:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1b17:	48 8b 00             	mov    (%rax),%rax
    1b1a:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
    1b1e:	72 17                	jb     1b37 <free+0x53>
    1b20:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1b24:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
    1b28:	77 2f                	ja     1b59 <free+0x75>
    1b2a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1b2e:	48 8b 00             	mov    (%rax),%rax
    1b31:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
    1b35:	72 22                	jb     1b59 <free+0x75>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1b37:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1b3b:	48 8b 00             	mov    (%rax),%rax
    1b3e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    1b42:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1b46:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
    1b4a:	76 c7                	jbe    1b13 <free+0x2f>
    1b4c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1b50:	48 8b 00             	mov    (%rax),%rax
    1b53:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
    1b57:	73 ba                	jae    1b13 <free+0x2f>
      break;
  if(bp + bp->s.size == p->s.ptr){
    1b59:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1b5d:	8b 40 08             	mov    0x8(%rax),%eax
    1b60:	89 c0                	mov    %eax,%eax
    1b62:	48 c1 e0 04          	shl    $0x4,%rax
    1b66:	48 89 c2             	mov    %rax,%rdx
    1b69:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1b6d:	48 01 c2             	add    %rax,%rdx
    1b70:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1b74:	48 8b 00             	mov    (%rax),%rax
    1b77:	48 39 c2             	cmp    %rax,%rdx
    1b7a:	75 2d                	jne    1ba9 <free+0xc5>
    bp->s.size += p->s.ptr->s.size;
    1b7c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1b80:	8b 50 08             	mov    0x8(%rax),%edx
    1b83:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1b87:	48 8b 00             	mov    (%rax),%rax
    1b8a:	8b 40 08             	mov    0x8(%rax),%eax
    1b8d:	01 c2                	add    %eax,%edx
    1b8f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1b93:	89 50 08             	mov    %edx,0x8(%rax)
    bp->s.ptr = p->s.ptr->s.ptr;
    1b96:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1b9a:	48 8b 00             	mov    (%rax),%rax
    1b9d:	48 8b 10             	mov    (%rax),%rdx
    1ba0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1ba4:	48 89 10             	mov    %rdx,(%rax)
    1ba7:	eb 0e                	jmp    1bb7 <free+0xd3>
  } else
    bp->s.ptr = p->s.ptr;
    1ba9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1bad:	48 8b 10             	mov    (%rax),%rdx
    1bb0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1bb4:	48 89 10             	mov    %rdx,(%rax)
  if(p + p->s.size == bp){
    1bb7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1bbb:	8b 40 08             	mov    0x8(%rax),%eax
    1bbe:	89 c0                	mov    %eax,%eax
    1bc0:	48 c1 e0 04          	shl    $0x4,%rax
    1bc4:	48 89 c2             	mov    %rax,%rdx
    1bc7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1bcb:	48 01 d0             	add    %rdx,%rax
    1bce:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
    1bd2:	75 27                	jne    1bfb <free+0x117>
    p->s.size += bp->s.size;
    1bd4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1bd8:	8b 50 08             	mov    0x8(%rax),%edx
    1bdb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1bdf:	8b 40 08             	mov    0x8(%rax),%eax
    1be2:	01 c2                	add    %eax,%edx
    1be4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1be8:	89 50 08             	mov    %edx,0x8(%rax)
    p->s.ptr = bp->s.ptr;
    1beb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1bef:	48 8b 10             	mov    (%rax),%rdx
    1bf2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1bf6:	48 89 10             	mov    %rdx,(%rax)
    1bf9:	eb 0b                	jmp    1c06 <free+0x122>
  } else
    p->s.ptr = bp;
    1bfb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1bff:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
    1c03:	48 89 10             	mov    %rdx,(%rax)
  freep = p;
    1c06:	48 ba 60 21 00 00 00 	movabs $0x2160,%rdx
    1c0d:	00 00 00 
    1c10:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1c14:	48 89 02             	mov    %rax,(%rdx)
}
    1c17:	90                   	nop
    1c18:	c9                   	leaveq 
    1c19:	c3                   	retq   

0000000000001c1a <morecore>:

static Header*
morecore(uint nu)
{
    1c1a:	f3 0f 1e fa          	endbr64 
    1c1e:	55                   	push   %rbp
    1c1f:	48 89 e5             	mov    %rsp,%rbp
    1c22:	48 83 ec 20          	sub    $0x20,%rsp
    1c26:	89 7d ec             	mov    %edi,-0x14(%rbp)
  char *p;
  Header *hp;

  if(nu < 4096)
    1c29:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%rbp)
    1c30:	77 07                	ja     1c39 <morecore+0x1f>
    nu = 4096;
    1c32:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%rbp)
  p = sbrk(nu * sizeof(Header));
    1c39:	8b 45 ec             	mov    -0x14(%rbp),%eax
    1c3c:	48 c1 e0 04          	shl    $0x4,%rax
    1c40:	48 89 c7             	mov    %rax,%rdi
    1c43:	48 b8 ba 14 00 00 00 	movabs $0x14ba,%rax
    1c4a:	00 00 00 
    1c4d:	ff d0                	callq  *%rax
    1c4f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  if(p == (char*)-1)
    1c53:	48 83 7d f8 ff       	cmpq   $0xffffffffffffffff,-0x8(%rbp)
    1c58:	75 07                	jne    1c61 <morecore+0x47>
    return 0;
    1c5a:	b8 00 00 00 00       	mov    $0x0,%eax
    1c5f:	eb 36                	jmp    1c97 <morecore+0x7d>
  hp = (Header*)p;
    1c61:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1c65:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  hp->s.size = nu;
    1c69:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1c6d:	8b 55 ec             	mov    -0x14(%rbp),%edx
    1c70:	89 50 08             	mov    %edx,0x8(%rax)
  free((void*)(hp + 1));
    1c73:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1c77:	48 83 c0 10          	add    $0x10,%rax
    1c7b:	48 89 c7             	mov    %rax,%rdi
    1c7e:	48 b8 e4 1a 00 00 00 	movabs $0x1ae4,%rax
    1c85:	00 00 00 
    1c88:	ff d0                	callq  *%rax
  return freep;
    1c8a:	48 b8 60 21 00 00 00 	movabs $0x2160,%rax
    1c91:	00 00 00 
    1c94:	48 8b 00             	mov    (%rax),%rax
}
    1c97:	c9                   	leaveq 
    1c98:	c3                   	retq   

0000000000001c99 <malloc>:

void*
malloc(uint nbytes)
{
    1c99:	f3 0f 1e fa          	endbr64 
    1c9d:	55                   	push   %rbp
    1c9e:	48 89 e5             	mov    %rsp,%rbp
    1ca1:	48 83 ec 30          	sub    $0x30,%rsp
    1ca5:	89 7d dc             	mov    %edi,-0x24(%rbp)
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1ca8:	8b 45 dc             	mov    -0x24(%rbp),%eax
    1cab:	48 83 c0 0f          	add    $0xf,%rax
    1caf:	48 c1 e8 04          	shr    $0x4,%rax
    1cb3:	83 c0 01             	add    $0x1,%eax
    1cb6:	89 45 ec             	mov    %eax,-0x14(%rbp)
  if((prevp = freep) == 0){
    1cb9:	48 b8 60 21 00 00 00 	movabs $0x2160,%rax
    1cc0:	00 00 00 
    1cc3:	48 8b 00             	mov    (%rax),%rax
    1cc6:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    1cca:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
    1ccf:	75 4a                	jne    1d1b <malloc+0x82>
    base.s.ptr = freep = prevp = &base;
    1cd1:	48 b8 50 21 00 00 00 	movabs $0x2150,%rax
    1cd8:	00 00 00 
    1cdb:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    1cdf:	48 ba 60 21 00 00 00 	movabs $0x2160,%rdx
    1ce6:	00 00 00 
    1ce9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1ced:	48 89 02             	mov    %rax,(%rdx)
    1cf0:	48 b8 60 21 00 00 00 	movabs $0x2160,%rax
    1cf7:	00 00 00 
    1cfa:	48 8b 00             	mov    (%rax),%rax
    1cfd:	48 ba 50 21 00 00 00 	movabs $0x2150,%rdx
    1d04:	00 00 00 
    1d07:	48 89 02             	mov    %rax,(%rdx)
    base.s.size = 0;
    1d0a:	48 b8 50 21 00 00 00 	movabs $0x2150,%rax
    1d11:	00 00 00 
    1d14:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1d1b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1d1f:	48 8b 00             	mov    (%rax),%rax
    1d22:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    if(p->s.size >= nunits){
    1d26:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d2a:	8b 40 08             	mov    0x8(%rax),%eax
    1d2d:	39 45 ec             	cmp    %eax,-0x14(%rbp)
    1d30:	77 65                	ja     1d97 <malloc+0xfe>
      if(p->s.size == nunits)
    1d32:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d36:	8b 40 08             	mov    0x8(%rax),%eax
    1d39:	39 45 ec             	cmp    %eax,-0x14(%rbp)
    1d3c:	75 10                	jne    1d4e <malloc+0xb5>
        prevp->s.ptr = p->s.ptr;
    1d3e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d42:	48 8b 10             	mov    (%rax),%rdx
    1d45:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1d49:	48 89 10             	mov    %rdx,(%rax)
    1d4c:	eb 2e                	jmp    1d7c <malloc+0xe3>
      else {
        p->s.size -= nunits;
    1d4e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d52:	8b 40 08             	mov    0x8(%rax),%eax
    1d55:	2b 45 ec             	sub    -0x14(%rbp),%eax
    1d58:	89 c2                	mov    %eax,%edx
    1d5a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d5e:	89 50 08             	mov    %edx,0x8(%rax)
        p += p->s.size;
    1d61:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d65:	8b 40 08             	mov    0x8(%rax),%eax
    1d68:	89 c0                	mov    %eax,%eax
    1d6a:	48 c1 e0 04          	shl    $0x4,%rax
    1d6e:	48 01 45 f8          	add    %rax,-0x8(%rbp)
        p->s.size = nunits;
    1d72:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d76:	8b 55 ec             	mov    -0x14(%rbp),%edx
    1d79:	89 50 08             	mov    %edx,0x8(%rax)
      }
      freep = prevp;
    1d7c:	48 ba 60 21 00 00 00 	movabs $0x2160,%rdx
    1d83:	00 00 00 
    1d86:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1d8a:	48 89 02             	mov    %rax,(%rdx)
      return (void*)(p + 1);
    1d8d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d91:	48 83 c0 10          	add    $0x10,%rax
    1d95:	eb 4e                	jmp    1de5 <malloc+0x14c>
    }
    if(p == freep)
    1d97:	48 b8 60 21 00 00 00 	movabs $0x2160,%rax
    1d9e:	00 00 00 
    1da1:	48 8b 00             	mov    (%rax),%rax
    1da4:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
    1da8:	75 23                	jne    1dcd <malloc+0x134>
      if((p = morecore(nunits)) == 0)
    1daa:	8b 45 ec             	mov    -0x14(%rbp),%eax
    1dad:	89 c7                	mov    %eax,%edi
    1daf:	48 b8 1a 1c 00 00 00 	movabs $0x1c1a,%rax
    1db6:	00 00 00 
    1db9:	ff d0                	callq  *%rax
    1dbb:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    1dbf:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
    1dc4:	75 07                	jne    1dcd <malloc+0x134>
        return 0;
    1dc6:	b8 00 00 00 00       	mov    $0x0,%eax
    1dcb:	eb 18                	jmp    1de5 <malloc+0x14c>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1dcd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1dd1:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    1dd5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1dd9:	48 8b 00             	mov    (%rax),%rax
    1ddc:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    if(p->s.size >= nunits){
    1de0:	e9 41 ff ff ff       	jmpq   1d26 <malloc+0x8d>
  }
}
    1de5:	c9                   	leaveq 
    1de6:	c3                   	retq   


_stressfs:     file format elf64-x86-64


Disassembly of section .text:

0000000000001000 <main>:
#include "fs.h"
#include "fcntl.h"

int
main(int argc, char *argv[])
{
    1000:	f3 0f 1e fa          	endbr64 
    1004:	55                   	push   %rbp
    1005:	48 89 e5             	mov    %rsp,%rbp
    1008:	48 81 ec 30 02 00 00 	sub    $0x230,%rsp
    100f:	89 bd dc fd ff ff    	mov    %edi,-0x224(%rbp)
    1015:	48 89 b5 d0 fd ff ff 	mov    %rsi,-0x230(%rbp)
  int fd, i;
  char path[] = "stressfs0";
    101c:	48 b8 73 74 72 65 73 	movabs $0x7366737365727473,%rax
    1023:	73 66 73 
    1026:	48 89 45 ee          	mov    %rax,-0x12(%rbp)
    102a:	66 c7 45 f6 30 00    	movw   $0x30,-0xa(%rbp)
  char data[512];

  printf(1, "stressfs starting\n");
    1030:	48 be 10 1f 00 00 00 	movabs $0x1f10,%rsi
    1037:	00 00 00 
    103a:	bf 01 00 00 00       	mov    $0x1,%edi
    103f:	b8 00 00 00 00       	mov    $0x0,%eax
    1044:	48 ba f9 17 00 00 00 	movabs $0x17f9,%rdx
    104b:	00 00 00 
    104e:	ff d2                	callq  *%rdx
  memset(data, 'a', sizeof(data));
    1050:	48 8d 85 e0 fd ff ff 	lea    -0x220(%rbp),%rax
    1057:	ba 00 02 00 00       	mov    $0x200,%edx
    105c:	be 61 00 00 00       	mov    $0x61,%esi
    1061:	48 89 c7             	mov    %rax,%rdi
    1064:	48 b8 cd 12 00 00 00 	movabs $0x12cd,%rax
    106b:	00 00 00 
    106e:	ff d0                	callq  *%rax

  for(i = 0; i < 4; i++)
    1070:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    1077:	eb 14                	jmp    108d <main+0x8d>
    if(fork() > 0)
    1079:	48 b8 f5 14 00 00 00 	movabs $0x14f5,%rax
    1080:	00 00 00 
    1083:	ff d0                	callq  *%rax
    1085:	85 c0                	test   %eax,%eax
    1087:	7f 0c                	jg     1095 <main+0x95>
  for(i = 0; i < 4; i++)
    1089:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    108d:	83 7d fc 03          	cmpl   $0x3,-0x4(%rbp)
    1091:	7e e6                	jle    1079 <main+0x79>
    1093:	eb 01                	jmp    1096 <main+0x96>
      break;
    1095:	90                   	nop

  printf(1, "write %d\n", i);
    1096:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1099:	89 c2                	mov    %eax,%edx
    109b:	48 be 23 1f 00 00 00 	movabs $0x1f23,%rsi
    10a2:	00 00 00 
    10a5:	bf 01 00 00 00       	mov    $0x1,%edi
    10aa:	b8 00 00 00 00       	mov    $0x0,%eax
    10af:	48 b9 f9 17 00 00 00 	movabs $0x17f9,%rcx
    10b6:	00 00 00 
    10b9:	ff d1                	callq  *%rcx

  path[8] += i;
    10bb:	0f b6 45 f6          	movzbl -0xa(%rbp),%eax
    10bf:	89 c2                	mov    %eax,%edx
    10c1:	8b 45 fc             	mov    -0x4(%rbp),%eax
    10c4:	01 d0                	add    %edx,%eax
    10c6:	88 45 f6             	mov    %al,-0xa(%rbp)
  fd = open(path, O_CREATE | O_RDWR);
    10c9:	48 8d 45 ee          	lea    -0x12(%rbp),%rax
    10cd:	be 02 02 00 00       	mov    $0x202,%esi
    10d2:	48 89 c7             	mov    %rax,%rdi
    10d5:	48 b8 6a 15 00 00 00 	movabs $0x156a,%rax
    10dc:	00 00 00 
    10df:	ff d0                	callq  *%rax
    10e1:	89 45 f8             	mov    %eax,-0x8(%rbp)
  for(i = 0; i < 20; i++)
    10e4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    10eb:	eb 24                	jmp    1111 <main+0x111>
//    printf(fd, "%d\n", i);
    write(fd, data, sizeof(data));
    10ed:	48 8d 8d e0 fd ff ff 	lea    -0x220(%rbp),%rcx
    10f4:	8b 45 f8             	mov    -0x8(%rbp),%eax
    10f7:	ba 00 02 00 00       	mov    $0x200,%edx
    10fc:	48 89 ce             	mov    %rcx,%rsi
    10ff:	89 c7                	mov    %eax,%edi
    1101:	48 b8 36 15 00 00 00 	movabs $0x1536,%rax
    1108:	00 00 00 
    110b:	ff d0                	callq  *%rax
  for(i = 0; i < 20; i++)
    110d:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    1111:	83 7d fc 13          	cmpl   $0x13,-0x4(%rbp)
    1115:	7e d6                	jle    10ed <main+0xed>
  close(fd);
    1117:	8b 45 f8             	mov    -0x8(%rbp),%eax
    111a:	89 c7                	mov    %eax,%edi
    111c:	48 b8 43 15 00 00 00 	movabs $0x1543,%rax
    1123:	00 00 00 
    1126:	ff d0                	callq  *%rax

  printf(1, "read\n");
    1128:	48 be 2d 1f 00 00 00 	movabs $0x1f2d,%rsi
    112f:	00 00 00 
    1132:	bf 01 00 00 00       	mov    $0x1,%edi
    1137:	b8 00 00 00 00       	mov    $0x0,%eax
    113c:	48 ba f9 17 00 00 00 	movabs $0x17f9,%rdx
    1143:	00 00 00 
    1146:	ff d2                	callq  *%rdx

  fd = open(path, O_RDONLY);
    1148:	48 8d 45 ee          	lea    -0x12(%rbp),%rax
    114c:	be 00 00 00 00       	mov    $0x0,%esi
    1151:	48 89 c7             	mov    %rax,%rdi
    1154:	48 b8 6a 15 00 00 00 	movabs $0x156a,%rax
    115b:	00 00 00 
    115e:	ff d0                	callq  *%rax
    1160:	89 45 f8             	mov    %eax,-0x8(%rbp)
  for (i = 0; i < 20; i++)
    1163:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    116a:	eb 24                	jmp    1190 <main+0x190>
    read(fd, data, sizeof(data));
    116c:	48 8d 8d e0 fd ff ff 	lea    -0x220(%rbp),%rcx
    1173:	8b 45 f8             	mov    -0x8(%rbp),%eax
    1176:	ba 00 02 00 00       	mov    $0x200,%edx
    117b:	48 89 ce             	mov    %rcx,%rsi
    117e:	89 c7                	mov    %eax,%edi
    1180:	48 b8 29 15 00 00 00 	movabs $0x1529,%rax
    1187:	00 00 00 
    118a:	ff d0                	callq  *%rax
  for (i = 0; i < 20; i++)
    118c:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    1190:	83 7d fc 13          	cmpl   $0x13,-0x4(%rbp)
    1194:	7e d6                	jle    116c <main+0x16c>
  close(fd);
    1196:	8b 45 f8             	mov    -0x8(%rbp),%eax
    1199:	89 c7                	mov    %eax,%edi
    119b:	48 b8 43 15 00 00 00 	movabs $0x1543,%rax
    11a2:	00 00 00 
    11a5:	ff d0                	callq  *%rax

  wait();
    11a7:	48 b8 0f 15 00 00 00 	movabs $0x150f,%rax
    11ae:	00 00 00 
    11b1:	ff d0                	callq  *%rax

  exit();
    11b3:	48 b8 02 15 00 00 00 	movabs $0x1502,%rax
    11ba:	00 00 00 
    11bd:	ff d0                	callq  *%rax

00000000000011bf <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
    11bf:	f3 0f 1e fa          	endbr64 
    11c3:	55                   	push   %rbp
    11c4:	48 89 e5             	mov    %rsp,%rbp
    11c7:	48 83 ec 10          	sub    $0x10,%rsp
    11cb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    11cf:	89 75 f4             	mov    %esi,-0xc(%rbp)
    11d2:	89 55 f0             	mov    %edx,-0x10(%rbp)
  asm volatile("cld; rep stosb" :
    11d5:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
    11d9:	8b 55 f0             	mov    -0x10(%rbp),%edx
    11dc:	8b 45 f4             	mov    -0xc(%rbp),%eax
    11df:	48 89 ce             	mov    %rcx,%rsi
    11e2:	48 89 f7             	mov    %rsi,%rdi
    11e5:	89 d1                	mov    %edx,%ecx
    11e7:	fc                   	cld    
    11e8:	f3 aa                	rep stos %al,%es:(%rdi)
    11ea:	89 ca                	mov    %ecx,%edx
    11ec:	48 89 fe             	mov    %rdi,%rsi
    11ef:	48 89 75 f8          	mov    %rsi,-0x8(%rbp)
    11f3:	89 55 f0             	mov    %edx,-0x10(%rbp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
    11f6:	90                   	nop
    11f7:	c9                   	leaveq 
    11f8:	c3                   	retq   

00000000000011f9 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
    11f9:	f3 0f 1e fa          	endbr64 
    11fd:	55                   	push   %rbp
    11fe:	48 89 e5             	mov    %rsp,%rbp
    1201:	48 83 ec 20          	sub    $0x20,%rsp
    1205:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    1209:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  char *os;

  os = s;
    120d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1211:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  while((*s++ = *t++) != 0)
    1215:	90                   	nop
    1216:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
    121a:	48 8d 42 01          	lea    0x1(%rdx),%rax
    121e:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    1222:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1226:	48 8d 48 01          	lea    0x1(%rax),%rcx
    122a:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
    122e:	0f b6 12             	movzbl (%rdx),%edx
    1231:	88 10                	mov    %dl,(%rax)
    1233:	0f b6 00             	movzbl (%rax),%eax
    1236:	84 c0                	test   %al,%al
    1238:	75 dc                	jne    1216 <strcpy+0x1d>
    ;
  return os;
    123a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
    123e:	c9                   	leaveq 
    123f:	c3                   	retq   

0000000000001240 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    1240:	f3 0f 1e fa          	endbr64 
    1244:	55                   	push   %rbp
    1245:	48 89 e5             	mov    %rsp,%rbp
    1248:	48 83 ec 10          	sub    $0x10,%rsp
    124c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    1250:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  while(*p && *p == *q)
    1254:	eb 0a                	jmp    1260 <strcmp+0x20>
    p++, q++;
    1256:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
    125b:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
  while(*p && *p == *q)
    1260:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1264:	0f b6 00             	movzbl (%rax),%eax
    1267:	84 c0                	test   %al,%al
    1269:	74 12                	je     127d <strcmp+0x3d>
    126b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    126f:	0f b6 10             	movzbl (%rax),%edx
    1272:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1276:	0f b6 00             	movzbl (%rax),%eax
    1279:	38 c2                	cmp    %al,%dl
    127b:	74 d9                	je     1256 <strcmp+0x16>
  return (uchar)*p - (uchar)*q;
    127d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1281:	0f b6 00             	movzbl (%rax),%eax
    1284:	0f b6 d0             	movzbl %al,%edx
    1287:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    128b:	0f b6 00             	movzbl (%rax),%eax
    128e:	0f b6 c0             	movzbl %al,%eax
    1291:	29 c2                	sub    %eax,%edx
    1293:	89 d0                	mov    %edx,%eax
}
    1295:	c9                   	leaveq 
    1296:	c3                   	retq   

0000000000001297 <strlen>:

uint
strlen(char *s)
{
    1297:	f3 0f 1e fa          	endbr64 
    129b:	55                   	push   %rbp
    129c:	48 89 e5             	mov    %rsp,%rbp
    129f:	48 83 ec 18          	sub    $0x18,%rsp
    12a3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  int n;

  for(n = 0; s[n]; n++)
    12a7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    12ae:	eb 04                	jmp    12b4 <strlen+0x1d>
    12b0:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    12b4:	8b 45 fc             	mov    -0x4(%rbp),%eax
    12b7:	48 63 d0             	movslq %eax,%rdx
    12ba:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    12be:	48 01 d0             	add    %rdx,%rax
    12c1:	0f b6 00             	movzbl (%rax),%eax
    12c4:	84 c0                	test   %al,%al
    12c6:	75 e8                	jne    12b0 <strlen+0x19>
    ;
  return n;
    12c8:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
    12cb:	c9                   	leaveq 
    12cc:	c3                   	retq   

00000000000012cd <memset>:

void*
memset(void *dst, int c, uint n)
{
    12cd:	f3 0f 1e fa          	endbr64 
    12d1:	55                   	push   %rbp
    12d2:	48 89 e5             	mov    %rsp,%rbp
    12d5:	48 83 ec 10          	sub    $0x10,%rsp
    12d9:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    12dd:	89 75 f4             	mov    %esi,-0xc(%rbp)
    12e0:	89 55 f0             	mov    %edx,-0x10(%rbp)
  stosb(dst, c, n);
    12e3:	8b 55 f0             	mov    -0x10(%rbp),%edx
    12e6:	8b 4d f4             	mov    -0xc(%rbp),%ecx
    12e9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    12ed:	89 ce                	mov    %ecx,%esi
    12ef:	48 89 c7             	mov    %rax,%rdi
    12f2:	48 b8 bf 11 00 00 00 	movabs $0x11bf,%rax
    12f9:	00 00 00 
    12fc:	ff d0                	callq  *%rax
  return dst;
    12fe:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
    1302:	c9                   	leaveq 
    1303:	c3                   	retq   

0000000000001304 <strchr>:

char*
strchr(const char *s, char c)
{
    1304:	f3 0f 1e fa          	endbr64 
    1308:	55                   	push   %rbp
    1309:	48 89 e5             	mov    %rsp,%rbp
    130c:	48 83 ec 10          	sub    $0x10,%rsp
    1310:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    1314:	89 f0                	mov    %esi,%eax
    1316:	88 45 f4             	mov    %al,-0xc(%rbp)
  for(; *s; s++)
    1319:	eb 17                	jmp    1332 <strchr+0x2e>
    if(*s == c)
    131b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    131f:	0f b6 00             	movzbl (%rax),%eax
    1322:	38 45 f4             	cmp    %al,-0xc(%rbp)
    1325:	75 06                	jne    132d <strchr+0x29>
      return (char*)s;
    1327:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    132b:	eb 15                	jmp    1342 <strchr+0x3e>
  for(; *s; s++)
    132d:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
    1332:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1336:	0f b6 00             	movzbl (%rax),%eax
    1339:	84 c0                	test   %al,%al
    133b:	75 de                	jne    131b <strchr+0x17>
  return 0;
    133d:	b8 00 00 00 00       	mov    $0x0,%eax
}
    1342:	c9                   	leaveq 
    1343:	c3                   	retq   

0000000000001344 <gets>:

char*
gets(char *buf, int max)
{
    1344:	f3 0f 1e fa          	endbr64 
    1348:	55                   	push   %rbp
    1349:	48 89 e5             	mov    %rsp,%rbp
    134c:	48 83 ec 20          	sub    $0x20,%rsp
    1350:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    1354:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    1357:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    135e:	eb 4f                	jmp    13af <gets+0x6b>
    cc = read(0, &c, 1);
    1360:	48 8d 45 f7          	lea    -0x9(%rbp),%rax
    1364:	ba 01 00 00 00       	mov    $0x1,%edx
    1369:	48 89 c6             	mov    %rax,%rsi
    136c:	bf 00 00 00 00       	mov    $0x0,%edi
    1371:	48 b8 29 15 00 00 00 	movabs $0x1529,%rax
    1378:	00 00 00 
    137b:	ff d0                	callq  *%rax
    137d:	89 45 f8             	mov    %eax,-0x8(%rbp)
    if(cc < 1)
    1380:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
    1384:	7e 36                	jle    13bc <gets+0x78>
      break;
    buf[i++] = c;
    1386:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1389:	8d 50 01             	lea    0x1(%rax),%edx
    138c:	89 55 fc             	mov    %edx,-0x4(%rbp)
    138f:	48 63 d0             	movslq %eax,%rdx
    1392:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1396:	48 01 c2             	add    %rax,%rdx
    1399:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
    139d:	88 02                	mov    %al,(%rdx)
    if(c == '\n' || c == '\r')
    139f:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
    13a3:	3c 0a                	cmp    $0xa,%al
    13a5:	74 16                	je     13bd <gets+0x79>
    13a7:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
    13ab:	3c 0d                	cmp    $0xd,%al
    13ad:	74 0e                	je     13bd <gets+0x79>
  for(i=0; i+1 < max; ){
    13af:	8b 45 fc             	mov    -0x4(%rbp),%eax
    13b2:	83 c0 01             	add    $0x1,%eax
    13b5:	39 45 e4             	cmp    %eax,-0x1c(%rbp)
    13b8:	7f a6                	jg     1360 <gets+0x1c>
    13ba:	eb 01                	jmp    13bd <gets+0x79>
      break;
    13bc:	90                   	nop
      break;
  }
  buf[i] = '\0';
    13bd:	8b 45 fc             	mov    -0x4(%rbp),%eax
    13c0:	48 63 d0             	movslq %eax,%rdx
    13c3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    13c7:	48 01 d0             	add    %rdx,%rax
    13ca:	c6 00 00             	movb   $0x0,(%rax)
  return buf;
    13cd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
    13d1:	c9                   	leaveq 
    13d2:	c3                   	retq   

00000000000013d3 <stat>:

int
stat(char *n, struct stat *st)
{
    13d3:	f3 0f 1e fa          	endbr64 
    13d7:	55                   	push   %rbp
    13d8:	48 89 e5             	mov    %rsp,%rbp
    13db:	48 83 ec 20          	sub    $0x20,%rsp
    13df:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    13e3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    13e7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    13eb:	be 00 00 00 00       	mov    $0x0,%esi
    13f0:	48 89 c7             	mov    %rax,%rdi
    13f3:	48 b8 6a 15 00 00 00 	movabs $0x156a,%rax
    13fa:	00 00 00 
    13fd:	ff d0                	callq  *%rax
    13ff:	89 45 fc             	mov    %eax,-0x4(%rbp)
  if(fd < 0)
    1402:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
    1406:	79 07                	jns    140f <stat+0x3c>
    return -1;
    1408:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    140d:	eb 2f                	jmp    143e <stat+0x6b>
  r = fstat(fd, st);
    140f:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
    1413:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1416:	48 89 d6             	mov    %rdx,%rsi
    1419:	89 c7                	mov    %eax,%edi
    141b:	48 b8 91 15 00 00 00 	movabs $0x1591,%rax
    1422:	00 00 00 
    1425:	ff d0                	callq  *%rax
    1427:	89 45 f8             	mov    %eax,-0x8(%rbp)
  close(fd);
    142a:	8b 45 fc             	mov    -0x4(%rbp),%eax
    142d:	89 c7                	mov    %eax,%edi
    142f:	48 b8 43 15 00 00 00 	movabs $0x1543,%rax
    1436:	00 00 00 
    1439:	ff d0                	callq  *%rax
  return r;
    143b:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
    143e:	c9                   	leaveq 
    143f:	c3                   	retq   

0000000000001440 <atoi>:

int
atoi(const char *s)
{
    1440:	f3 0f 1e fa          	endbr64 
    1444:	55                   	push   %rbp
    1445:	48 89 e5             	mov    %rsp,%rbp
    1448:	48 83 ec 18          	sub    $0x18,%rsp
    144c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  int n;

  n = 0;
    1450:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  while('0' <= *s && *s <= '9')
    1457:	eb 28                	jmp    1481 <atoi+0x41>
    n = n*10 + *s++ - '0';
    1459:	8b 55 fc             	mov    -0x4(%rbp),%edx
    145c:	89 d0                	mov    %edx,%eax
    145e:	c1 e0 02             	shl    $0x2,%eax
    1461:	01 d0                	add    %edx,%eax
    1463:	01 c0                	add    %eax,%eax
    1465:	89 c1                	mov    %eax,%ecx
    1467:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    146b:	48 8d 50 01          	lea    0x1(%rax),%rdx
    146f:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
    1473:	0f b6 00             	movzbl (%rax),%eax
    1476:	0f be c0             	movsbl %al,%eax
    1479:	01 c8                	add    %ecx,%eax
    147b:	83 e8 30             	sub    $0x30,%eax
    147e:	89 45 fc             	mov    %eax,-0x4(%rbp)
  while('0' <= *s && *s <= '9')
    1481:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1485:	0f b6 00             	movzbl (%rax),%eax
    1488:	3c 2f                	cmp    $0x2f,%al
    148a:	7e 0b                	jle    1497 <atoi+0x57>
    148c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1490:	0f b6 00             	movzbl (%rax),%eax
    1493:	3c 39                	cmp    $0x39,%al
    1495:	7e c2                	jle    1459 <atoi+0x19>
  return n;
    1497:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
    149a:	c9                   	leaveq 
    149b:	c3                   	retq   

000000000000149c <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    149c:	f3 0f 1e fa          	endbr64 
    14a0:	55                   	push   %rbp
    14a1:	48 89 e5             	mov    %rsp,%rbp
    14a4:	48 83 ec 28          	sub    $0x28,%rsp
    14a8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    14ac:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
    14b0:	89 55 dc             	mov    %edx,-0x24(%rbp)
  char *dst, *src;

  dst = vdst;
    14b3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    14b7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  src = vsrc;
    14bb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    14bf:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  while(n-- > 0)
    14c3:	eb 1d                	jmp    14e2 <memmove+0x46>
    *dst++ = *src++;
    14c5:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
    14c9:	48 8d 42 01          	lea    0x1(%rdx),%rax
    14cd:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    14d1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    14d5:	48 8d 48 01          	lea    0x1(%rax),%rcx
    14d9:	48 89 4d f8          	mov    %rcx,-0x8(%rbp)
    14dd:	0f b6 12             	movzbl (%rdx),%edx
    14e0:	88 10                	mov    %dl,(%rax)
  while(n-- > 0)
    14e2:	8b 45 dc             	mov    -0x24(%rbp),%eax
    14e5:	8d 50 ff             	lea    -0x1(%rax),%edx
    14e8:	89 55 dc             	mov    %edx,-0x24(%rbp)
    14eb:	85 c0                	test   %eax,%eax
    14ed:	7f d6                	jg     14c5 <memmove+0x29>
  return vdst;
    14ef:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
    14f3:	c9                   	leaveq 
    14f4:	c3                   	retq   

00000000000014f5 <fork>:
    mov $SYS_ ## name, %rax; \
    mov %rcx, %r10 ;\
    syscall		  ;\
    ret

SYSCALL(fork)
    14f5:	48 c7 c0 01 00 00 00 	mov    $0x1,%rax
    14fc:	49 89 ca             	mov    %rcx,%r10
    14ff:	0f 05                	syscall 
    1501:	c3                   	retq   

0000000000001502 <exit>:
SYSCALL(exit)
    1502:	48 c7 c0 02 00 00 00 	mov    $0x2,%rax
    1509:	49 89 ca             	mov    %rcx,%r10
    150c:	0f 05                	syscall 
    150e:	c3                   	retq   

000000000000150f <wait>:
SYSCALL(wait)
    150f:	48 c7 c0 03 00 00 00 	mov    $0x3,%rax
    1516:	49 89 ca             	mov    %rcx,%r10
    1519:	0f 05                	syscall 
    151b:	c3                   	retq   

000000000000151c <pipe>:
SYSCALL(pipe)
    151c:	48 c7 c0 04 00 00 00 	mov    $0x4,%rax
    1523:	49 89 ca             	mov    %rcx,%r10
    1526:	0f 05                	syscall 
    1528:	c3                   	retq   

0000000000001529 <read>:
SYSCALL(read)
    1529:	48 c7 c0 05 00 00 00 	mov    $0x5,%rax
    1530:	49 89 ca             	mov    %rcx,%r10
    1533:	0f 05                	syscall 
    1535:	c3                   	retq   

0000000000001536 <write>:
SYSCALL(write)
    1536:	48 c7 c0 10 00 00 00 	mov    $0x10,%rax
    153d:	49 89 ca             	mov    %rcx,%r10
    1540:	0f 05                	syscall 
    1542:	c3                   	retq   

0000000000001543 <close>:
SYSCALL(close)
    1543:	48 c7 c0 15 00 00 00 	mov    $0x15,%rax
    154a:	49 89 ca             	mov    %rcx,%r10
    154d:	0f 05                	syscall 
    154f:	c3                   	retq   

0000000000001550 <kill>:
SYSCALL(kill)
    1550:	48 c7 c0 06 00 00 00 	mov    $0x6,%rax
    1557:	49 89 ca             	mov    %rcx,%r10
    155a:	0f 05                	syscall 
    155c:	c3                   	retq   

000000000000155d <exec>:
SYSCALL(exec)
    155d:	48 c7 c0 07 00 00 00 	mov    $0x7,%rax
    1564:	49 89 ca             	mov    %rcx,%r10
    1567:	0f 05                	syscall 
    1569:	c3                   	retq   

000000000000156a <open>:
SYSCALL(open)
    156a:	48 c7 c0 0f 00 00 00 	mov    $0xf,%rax
    1571:	49 89 ca             	mov    %rcx,%r10
    1574:	0f 05                	syscall 
    1576:	c3                   	retq   

0000000000001577 <mknod>:
SYSCALL(mknod)
    1577:	48 c7 c0 11 00 00 00 	mov    $0x11,%rax
    157e:	49 89 ca             	mov    %rcx,%r10
    1581:	0f 05                	syscall 
    1583:	c3                   	retq   

0000000000001584 <unlink>:
SYSCALL(unlink)
    1584:	48 c7 c0 12 00 00 00 	mov    $0x12,%rax
    158b:	49 89 ca             	mov    %rcx,%r10
    158e:	0f 05                	syscall 
    1590:	c3                   	retq   

0000000000001591 <fstat>:
SYSCALL(fstat)
    1591:	48 c7 c0 08 00 00 00 	mov    $0x8,%rax
    1598:	49 89 ca             	mov    %rcx,%r10
    159b:	0f 05                	syscall 
    159d:	c3                   	retq   

000000000000159e <link>:
SYSCALL(link)
    159e:	48 c7 c0 13 00 00 00 	mov    $0x13,%rax
    15a5:	49 89 ca             	mov    %rcx,%r10
    15a8:	0f 05                	syscall 
    15aa:	c3                   	retq   

00000000000015ab <mkdir>:
SYSCALL(mkdir)
    15ab:	48 c7 c0 14 00 00 00 	mov    $0x14,%rax
    15b2:	49 89 ca             	mov    %rcx,%r10
    15b5:	0f 05                	syscall 
    15b7:	c3                   	retq   

00000000000015b8 <chdir>:
SYSCALL(chdir)
    15b8:	48 c7 c0 09 00 00 00 	mov    $0x9,%rax
    15bf:	49 89 ca             	mov    %rcx,%r10
    15c2:	0f 05                	syscall 
    15c4:	c3                   	retq   

00000000000015c5 <dup>:
SYSCALL(dup)
    15c5:	48 c7 c0 0a 00 00 00 	mov    $0xa,%rax
    15cc:	49 89 ca             	mov    %rcx,%r10
    15cf:	0f 05                	syscall 
    15d1:	c3                   	retq   

00000000000015d2 <getpid>:
SYSCALL(getpid)
    15d2:	48 c7 c0 0b 00 00 00 	mov    $0xb,%rax
    15d9:	49 89 ca             	mov    %rcx,%r10
    15dc:	0f 05                	syscall 
    15de:	c3                   	retq   

00000000000015df <sbrk>:
SYSCALL(sbrk)
    15df:	48 c7 c0 0c 00 00 00 	mov    $0xc,%rax
    15e6:	49 89 ca             	mov    %rcx,%r10
    15e9:	0f 05                	syscall 
    15eb:	c3                   	retq   

00000000000015ec <sleep>:
SYSCALL(sleep)
    15ec:	48 c7 c0 0d 00 00 00 	mov    $0xd,%rax
    15f3:	49 89 ca             	mov    %rcx,%r10
    15f6:	0f 05                	syscall 
    15f8:	c3                   	retq   

00000000000015f9 <uptime>:
SYSCALL(uptime)
    15f9:	48 c7 c0 0e 00 00 00 	mov    $0xe,%rax
    1600:	49 89 ca             	mov    %rcx,%r10
    1603:	0f 05                	syscall 
    1605:	c3                   	retq   

0000000000001606 <aread>:
SYSCALL(aread)
    1606:	48 c7 c0 16 00 00 00 	mov    $0x16,%rax
    160d:	49 89 ca             	mov    %rcx,%r10
    1610:	0f 05                	syscall 
    1612:	c3                   	retq   

0000000000001613 <putc>:

#include <stdarg.h>

static void
putc(int fd, char c)
{
    1613:	f3 0f 1e fa          	endbr64 
    1617:	55                   	push   %rbp
    1618:	48 89 e5             	mov    %rsp,%rbp
    161b:	48 83 ec 10          	sub    $0x10,%rsp
    161f:	89 7d fc             	mov    %edi,-0x4(%rbp)
    1622:	89 f0                	mov    %esi,%eax
    1624:	88 45 f8             	mov    %al,-0x8(%rbp)
  write(fd, &c, 1);
    1627:	48 8d 4d f8          	lea    -0x8(%rbp),%rcx
    162b:	8b 45 fc             	mov    -0x4(%rbp),%eax
    162e:	ba 01 00 00 00       	mov    $0x1,%edx
    1633:	48 89 ce             	mov    %rcx,%rsi
    1636:	89 c7                	mov    %eax,%edi
    1638:	48 b8 36 15 00 00 00 	movabs $0x1536,%rax
    163f:	00 00 00 
    1642:	ff d0                	callq  *%rax
}
    1644:	90                   	nop
    1645:	c9                   	leaveq 
    1646:	c3                   	retq   

0000000000001647 <print_x64>:

static char digits[] = "0123456789abcdef";

  static void
print_x64(int fd, addr_t x)
{
    1647:	f3 0f 1e fa          	endbr64 
    164b:	55                   	push   %rbp
    164c:	48 89 e5             	mov    %rsp,%rbp
    164f:	48 83 ec 20          	sub    $0x20,%rsp
    1653:	89 7d ec             	mov    %edi,-0x14(%rbp)
    1656:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  int i;
  for (i = 0; i < (sizeof(addr_t) * 2); i++, x <<= 4)
    165a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    1661:	eb 35                	jmp    1698 <print_x64+0x51>
    putc(fd, digits[x >> (sizeof(addr_t) * 8 - 4)]);
    1663:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    1667:	48 c1 e8 3c          	shr    $0x3c,%rax
    166b:	48 ba 70 22 00 00 00 	movabs $0x2270,%rdx
    1672:	00 00 00 
    1675:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
    1679:	0f be d0             	movsbl %al,%edx
    167c:	8b 45 ec             	mov    -0x14(%rbp),%eax
    167f:	89 d6                	mov    %edx,%esi
    1681:	89 c7                	mov    %eax,%edi
    1683:	48 b8 13 16 00 00 00 	movabs $0x1613,%rax
    168a:	00 00 00 
    168d:	ff d0                	callq  *%rax
  for (i = 0; i < (sizeof(addr_t) * 2); i++, x <<= 4)
    168f:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    1693:	48 c1 65 e0 04       	shlq   $0x4,-0x20(%rbp)
    1698:	8b 45 fc             	mov    -0x4(%rbp),%eax
    169b:	83 f8 0f             	cmp    $0xf,%eax
    169e:	76 c3                	jbe    1663 <print_x64+0x1c>
}
    16a0:	90                   	nop
    16a1:	90                   	nop
    16a2:	c9                   	leaveq 
    16a3:	c3                   	retq   

00000000000016a4 <print_x32>:

  static void
print_x32(int fd, uint x)
{
    16a4:	f3 0f 1e fa          	endbr64 
    16a8:	55                   	push   %rbp
    16a9:	48 89 e5             	mov    %rsp,%rbp
    16ac:	48 83 ec 20          	sub    $0x20,%rsp
    16b0:	89 7d ec             	mov    %edi,-0x14(%rbp)
    16b3:	89 75 e8             	mov    %esi,-0x18(%rbp)
  int i;
  for (i = 0; i < (sizeof(uint) * 2); i++, x <<= 4)
    16b6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    16bd:	eb 36                	jmp    16f5 <print_x32+0x51>
    putc(fd, digits[x >> (sizeof(uint) * 8 - 4)]);
    16bf:	8b 45 e8             	mov    -0x18(%rbp),%eax
    16c2:	c1 e8 1c             	shr    $0x1c,%eax
    16c5:	89 c2                	mov    %eax,%edx
    16c7:	48 b8 70 22 00 00 00 	movabs $0x2270,%rax
    16ce:	00 00 00 
    16d1:	89 d2                	mov    %edx,%edx
    16d3:	0f b6 04 10          	movzbl (%rax,%rdx,1),%eax
    16d7:	0f be d0             	movsbl %al,%edx
    16da:	8b 45 ec             	mov    -0x14(%rbp),%eax
    16dd:	89 d6                	mov    %edx,%esi
    16df:	89 c7                	mov    %eax,%edi
    16e1:	48 b8 13 16 00 00 00 	movabs $0x1613,%rax
    16e8:	00 00 00 
    16eb:	ff d0                	callq  *%rax
  for (i = 0; i < (sizeof(uint) * 2); i++, x <<= 4)
    16ed:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    16f1:	c1 65 e8 04          	shll   $0x4,-0x18(%rbp)
    16f5:	8b 45 fc             	mov    -0x4(%rbp),%eax
    16f8:	83 f8 07             	cmp    $0x7,%eax
    16fb:	76 c2                	jbe    16bf <print_x32+0x1b>
}
    16fd:	90                   	nop
    16fe:	90                   	nop
    16ff:	c9                   	leaveq 
    1700:	c3                   	retq   

0000000000001701 <print_d>:

  static void
print_d(int fd, int v)
{
    1701:	f3 0f 1e fa          	endbr64 
    1705:	55                   	push   %rbp
    1706:	48 89 e5             	mov    %rsp,%rbp
    1709:	48 83 ec 30          	sub    $0x30,%rsp
    170d:	89 7d dc             	mov    %edi,-0x24(%rbp)
    1710:	89 75 d8             	mov    %esi,-0x28(%rbp)
  char buf[16];
  int64 x = v;
    1713:	8b 45 d8             	mov    -0x28(%rbp),%eax
    1716:	48 98                	cltq   
    1718:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

  if (v < 0)
    171c:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
    1720:	79 04                	jns    1726 <print_d+0x25>
    x = -x;
    1722:	48 f7 5d f8          	negq   -0x8(%rbp)

  int i = 0;
    1726:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
  do {
    buf[i++] = digits[x % 10];
    172d:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
    1731:	48 ba 67 66 66 66 66 	movabs $0x6666666666666667,%rdx
    1738:	66 66 66 
    173b:	48 89 c8             	mov    %rcx,%rax
    173e:	48 f7 ea             	imul   %rdx
    1741:	48 c1 fa 02          	sar    $0x2,%rdx
    1745:	48 89 c8             	mov    %rcx,%rax
    1748:	48 c1 f8 3f          	sar    $0x3f,%rax
    174c:	48 29 c2             	sub    %rax,%rdx
    174f:	48 89 d0             	mov    %rdx,%rax
    1752:	48 c1 e0 02          	shl    $0x2,%rax
    1756:	48 01 d0             	add    %rdx,%rax
    1759:	48 01 c0             	add    %rax,%rax
    175c:	48 29 c1             	sub    %rax,%rcx
    175f:	48 89 ca             	mov    %rcx,%rdx
    1762:	8b 45 f4             	mov    -0xc(%rbp),%eax
    1765:	8d 48 01             	lea    0x1(%rax),%ecx
    1768:	89 4d f4             	mov    %ecx,-0xc(%rbp)
    176b:	48 b9 70 22 00 00 00 	movabs $0x2270,%rcx
    1772:	00 00 00 
    1775:	0f b6 14 11          	movzbl (%rcx,%rdx,1),%edx
    1779:	48 98                	cltq   
    177b:	88 54 05 e0          	mov    %dl,-0x20(%rbp,%rax,1)
    x /= 10;
    177f:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
    1783:	48 ba 67 66 66 66 66 	movabs $0x6666666666666667,%rdx
    178a:	66 66 66 
    178d:	48 89 c8             	mov    %rcx,%rax
    1790:	48 f7 ea             	imul   %rdx
    1793:	48 c1 fa 02          	sar    $0x2,%rdx
    1797:	48 89 c8             	mov    %rcx,%rax
    179a:	48 c1 f8 3f          	sar    $0x3f,%rax
    179e:	48 29 c2             	sub    %rax,%rdx
    17a1:	48 89 d0             	mov    %rdx,%rax
    17a4:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  } while(x != 0);
    17a8:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
    17ad:	0f 85 7a ff ff ff    	jne    172d <print_d+0x2c>

  if (v < 0)
    17b3:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
    17b7:	79 32                	jns    17eb <print_d+0xea>
    buf[i++] = '-';
    17b9:	8b 45 f4             	mov    -0xc(%rbp),%eax
    17bc:	8d 50 01             	lea    0x1(%rax),%edx
    17bf:	89 55 f4             	mov    %edx,-0xc(%rbp)
    17c2:	48 98                	cltq   
    17c4:	c6 44 05 e0 2d       	movb   $0x2d,-0x20(%rbp,%rax,1)

  while (--i >= 0)
    17c9:	eb 20                	jmp    17eb <print_d+0xea>
    putc(fd, buf[i]);
    17cb:	8b 45 f4             	mov    -0xc(%rbp),%eax
    17ce:	48 98                	cltq   
    17d0:	0f b6 44 05 e0       	movzbl -0x20(%rbp,%rax,1),%eax
    17d5:	0f be d0             	movsbl %al,%edx
    17d8:	8b 45 dc             	mov    -0x24(%rbp),%eax
    17db:	89 d6                	mov    %edx,%esi
    17dd:	89 c7                	mov    %eax,%edi
    17df:	48 b8 13 16 00 00 00 	movabs $0x1613,%rax
    17e6:	00 00 00 
    17e9:	ff d0                	callq  *%rax
  while (--i >= 0)
    17eb:	83 6d f4 01          	subl   $0x1,-0xc(%rbp)
    17ef:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
    17f3:	79 d6                	jns    17cb <print_d+0xca>
}
    17f5:	90                   	nop
    17f6:	90                   	nop
    17f7:	c9                   	leaveq 
    17f8:	c3                   	retq   

00000000000017f9 <printf>:
// Print to the given fd. Only understands %d, %x, %p, %s.
  void
printf(int fd, char *fmt, ...)
{
    17f9:	f3 0f 1e fa          	endbr64 
    17fd:	55                   	push   %rbp
    17fe:	48 89 e5             	mov    %rsp,%rbp
    1801:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
    1808:	89 bd 1c ff ff ff    	mov    %edi,-0xe4(%rbp)
    180e:	48 89 b5 10 ff ff ff 	mov    %rsi,-0xf0(%rbp)
    1815:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
    181c:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
    1823:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
    182a:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
    1831:	84 c0                	test   %al,%al
    1833:	74 20                	je     1855 <printf+0x5c>
    1835:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
    1839:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
    183d:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
    1841:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
    1845:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
    1849:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
    184d:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
    1851:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  va_list ap;
  int i, c;
  char *s;

  va_start(ap, fmt);
    1855:	c7 85 20 ff ff ff 10 	movl   $0x10,-0xe0(%rbp)
    185c:	00 00 00 
    185f:	c7 85 24 ff ff ff 30 	movl   $0x30,-0xdc(%rbp)
    1866:	00 00 00 
    1869:	48 8d 45 10          	lea    0x10(%rbp),%rax
    186d:	48 89 85 28 ff ff ff 	mov    %rax,-0xd8(%rbp)
    1874:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
    187b:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
    1882:	c7 85 4c ff ff ff 00 	movl   $0x0,-0xb4(%rbp)
    1889:	00 00 00 
    188c:	e9 41 03 00 00       	jmpq   1bd2 <printf+0x3d9>
    if (c != '%') {
    1891:	83 bd 3c ff ff ff 25 	cmpl   $0x25,-0xc4(%rbp)
    1898:	74 24                	je     18be <printf+0xc5>
      putc(fd, c);
    189a:	8b 85 3c ff ff ff    	mov    -0xc4(%rbp),%eax
    18a0:	0f be d0             	movsbl %al,%edx
    18a3:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    18a9:	89 d6                	mov    %edx,%esi
    18ab:	89 c7                	mov    %eax,%edi
    18ad:	48 b8 13 16 00 00 00 	movabs $0x1613,%rax
    18b4:	00 00 00 
    18b7:	ff d0                	callq  *%rax
      continue;
    18b9:	e9 0d 03 00 00       	jmpq   1bcb <printf+0x3d2>
    }
    c = fmt[++i] & 0xff;
    18be:	83 85 4c ff ff ff 01 	addl   $0x1,-0xb4(%rbp)
    18c5:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
    18cb:	48 63 d0             	movslq %eax,%rdx
    18ce:	48 8b 85 10 ff ff ff 	mov    -0xf0(%rbp),%rax
    18d5:	48 01 d0             	add    %rdx,%rax
    18d8:	0f b6 00             	movzbl (%rax),%eax
    18db:	0f be c0             	movsbl %al,%eax
    18de:	25 ff 00 00 00       	and    $0xff,%eax
    18e3:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%rbp)
    if (c == 0)
    18e9:	83 bd 3c ff ff ff 00 	cmpl   $0x0,-0xc4(%rbp)
    18f0:	0f 84 0f 03 00 00    	je     1c05 <printf+0x40c>
      break;
    switch(c) {
    18f6:	83 bd 3c ff ff ff 25 	cmpl   $0x25,-0xc4(%rbp)
    18fd:	0f 84 74 02 00 00    	je     1b77 <printf+0x37e>
    1903:	83 bd 3c ff ff ff 25 	cmpl   $0x25,-0xc4(%rbp)
    190a:	0f 8c 82 02 00 00    	jl     1b92 <printf+0x399>
    1910:	83 bd 3c ff ff ff 78 	cmpl   $0x78,-0xc4(%rbp)
    1917:	0f 8f 75 02 00 00    	jg     1b92 <printf+0x399>
    191d:	83 bd 3c ff ff ff 63 	cmpl   $0x63,-0xc4(%rbp)
    1924:	0f 8c 68 02 00 00    	jl     1b92 <printf+0x399>
    192a:	8b 85 3c ff ff ff    	mov    -0xc4(%rbp),%eax
    1930:	83 e8 63             	sub    $0x63,%eax
    1933:	83 f8 15             	cmp    $0x15,%eax
    1936:	0f 87 56 02 00 00    	ja     1b92 <printf+0x399>
    193c:	89 c0                	mov    %eax,%eax
    193e:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
    1945:	00 
    1946:	48 b8 40 1f 00 00 00 	movabs $0x1f40,%rax
    194d:	00 00 00 
    1950:	48 01 d0             	add    %rdx,%rax
    1953:	48 8b 00             	mov    (%rax),%rax
    1956:	3e ff e0             	notrack jmpq *%rax
    case 'c':
      putc(fd, va_arg(ap, int));
    1959:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    195f:	83 f8 2f             	cmp    $0x2f,%eax
    1962:	77 23                	ja     1987 <printf+0x18e>
    1964:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    196b:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1971:	89 d2                	mov    %edx,%edx
    1973:	48 01 d0             	add    %rdx,%rax
    1976:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    197c:	83 c2 08             	add    $0x8,%edx
    197f:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    1985:	eb 12                	jmp    1999 <printf+0x1a0>
    1987:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    198e:	48 8d 50 08          	lea    0x8(%rax),%rdx
    1992:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    1999:	8b 00                	mov    (%rax),%eax
    199b:	0f be d0             	movsbl %al,%edx
    199e:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    19a4:	89 d6                	mov    %edx,%esi
    19a6:	89 c7                	mov    %eax,%edi
    19a8:	48 b8 13 16 00 00 00 	movabs $0x1613,%rax
    19af:	00 00 00 
    19b2:	ff d0                	callq  *%rax
      break;
    19b4:	e9 12 02 00 00       	jmpq   1bcb <printf+0x3d2>
    case 'd':
      print_d(fd, va_arg(ap, int));
    19b9:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    19bf:	83 f8 2f             	cmp    $0x2f,%eax
    19c2:	77 23                	ja     19e7 <printf+0x1ee>
    19c4:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    19cb:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    19d1:	89 d2                	mov    %edx,%edx
    19d3:	48 01 d0             	add    %rdx,%rax
    19d6:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    19dc:	83 c2 08             	add    $0x8,%edx
    19df:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    19e5:	eb 12                	jmp    19f9 <printf+0x200>
    19e7:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    19ee:	48 8d 50 08          	lea    0x8(%rax),%rdx
    19f2:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    19f9:	8b 10                	mov    (%rax),%edx
    19fb:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1a01:	89 d6                	mov    %edx,%esi
    1a03:	89 c7                	mov    %eax,%edi
    1a05:	48 b8 01 17 00 00 00 	movabs $0x1701,%rax
    1a0c:	00 00 00 
    1a0f:	ff d0                	callq  *%rax
      break;
    1a11:	e9 b5 01 00 00       	jmpq   1bcb <printf+0x3d2>
    case 'x':
      print_x32(fd, va_arg(ap, uint));
    1a16:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    1a1c:	83 f8 2f             	cmp    $0x2f,%eax
    1a1f:	77 23                	ja     1a44 <printf+0x24b>
    1a21:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    1a28:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1a2e:	89 d2                	mov    %edx,%edx
    1a30:	48 01 d0             	add    %rdx,%rax
    1a33:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1a39:	83 c2 08             	add    $0x8,%edx
    1a3c:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    1a42:	eb 12                	jmp    1a56 <printf+0x25d>
    1a44:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    1a4b:	48 8d 50 08          	lea    0x8(%rax),%rdx
    1a4f:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    1a56:	8b 10                	mov    (%rax),%edx
    1a58:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1a5e:	89 d6                	mov    %edx,%esi
    1a60:	89 c7                	mov    %eax,%edi
    1a62:	48 b8 a4 16 00 00 00 	movabs $0x16a4,%rax
    1a69:	00 00 00 
    1a6c:	ff d0                	callq  *%rax
      break;
    1a6e:	e9 58 01 00 00       	jmpq   1bcb <printf+0x3d2>
    case 'p':
      print_x64(fd, va_arg(ap, addr_t));
    1a73:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    1a79:	83 f8 2f             	cmp    $0x2f,%eax
    1a7c:	77 23                	ja     1aa1 <printf+0x2a8>
    1a7e:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    1a85:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1a8b:	89 d2                	mov    %edx,%edx
    1a8d:	48 01 d0             	add    %rdx,%rax
    1a90:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1a96:	83 c2 08             	add    $0x8,%edx
    1a99:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    1a9f:	eb 12                	jmp    1ab3 <printf+0x2ba>
    1aa1:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    1aa8:	48 8d 50 08          	lea    0x8(%rax),%rdx
    1aac:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    1ab3:	48 8b 10             	mov    (%rax),%rdx
    1ab6:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1abc:	48 89 d6             	mov    %rdx,%rsi
    1abf:	89 c7                	mov    %eax,%edi
    1ac1:	48 b8 47 16 00 00 00 	movabs $0x1647,%rax
    1ac8:	00 00 00 
    1acb:	ff d0                	callq  *%rax
      break;
    1acd:	e9 f9 00 00 00       	jmpq   1bcb <printf+0x3d2>
    case 's':
      if ((s = va_arg(ap, char*)) == 0)
    1ad2:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    1ad8:	83 f8 2f             	cmp    $0x2f,%eax
    1adb:	77 23                	ja     1b00 <printf+0x307>
    1add:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    1ae4:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1aea:	89 d2                	mov    %edx,%edx
    1aec:	48 01 d0             	add    %rdx,%rax
    1aef:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1af5:	83 c2 08             	add    $0x8,%edx
    1af8:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    1afe:	eb 12                	jmp    1b12 <printf+0x319>
    1b00:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    1b07:	48 8d 50 08          	lea    0x8(%rax),%rdx
    1b0b:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    1b12:	48 8b 00             	mov    (%rax),%rax
    1b15:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    1b1c:	48 83 bd 40 ff ff ff 	cmpq   $0x0,-0xc0(%rbp)
    1b23:	00 
    1b24:	75 41                	jne    1b67 <printf+0x36e>
        s = "(null)";
    1b26:	48 b8 38 1f 00 00 00 	movabs $0x1f38,%rax
    1b2d:	00 00 00 
    1b30:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
      while (*s)
    1b37:	eb 2e                	jmp    1b67 <printf+0x36e>
        putc(fd, *(s++));
    1b39:	48 8b 85 40 ff ff ff 	mov    -0xc0(%rbp),%rax
    1b40:	48 8d 50 01          	lea    0x1(%rax),%rdx
    1b44:	48 89 95 40 ff ff ff 	mov    %rdx,-0xc0(%rbp)
    1b4b:	0f b6 00             	movzbl (%rax),%eax
    1b4e:	0f be d0             	movsbl %al,%edx
    1b51:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1b57:	89 d6                	mov    %edx,%esi
    1b59:	89 c7                	mov    %eax,%edi
    1b5b:	48 b8 13 16 00 00 00 	movabs $0x1613,%rax
    1b62:	00 00 00 
    1b65:	ff d0                	callq  *%rax
      while (*s)
    1b67:	48 8b 85 40 ff ff ff 	mov    -0xc0(%rbp),%rax
    1b6e:	0f b6 00             	movzbl (%rax),%eax
    1b71:	84 c0                	test   %al,%al
    1b73:	75 c4                	jne    1b39 <printf+0x340>
      break;
    1b75:	eb 54                	jmp    1bcb <printf+0x3d2>
    case '%':
      putc(fd, '%');
    1b77:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1b7d:	be 25 00 00 00       	mov    $0x25,%esi
    1b82:	89 c7                	mov    %eax,%edi
    1b84:	48 b8 13 16 00 00 00 	movabs $0x1613,%rax
    1b8b:	00 00 00 
    1b8e:	ff d0                	callq  *%rax
      break;
    1b90:	eb 39                	jmp    1bcb <printf+0x3d2>
    default:
      // Print unknown % sequence to draw attention.
      putc(fd, '%');
    1b92:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1b98:	be 25 00 00 00       	mov    $0x25,%esi
    1b9d:	89 c7                	mov    %eax,%edi
    1b9f:	48 b8 13 16 00 00 00 	movabs $0x1613,%rax
    1ba6:	00 00 00 
    1ba9:	ff d0                	callq  *%rax
      putc(fd, c);
    1bab:	8b 85 3c ff ff ff    	mov    -0xc4(%rbp),%eax
    1bb1:	0f be d0             	movsbl %al,%edx
    1bb4:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1bba:	89 d6                	mov    %edx,%esi
    1bbc:	89 c7                	mov    %eax,%edi
    1bbe:	48 b8 13 16 00 00 00 	movabs $0x1613,%rax
    1bc5:	00 00 00 
    1bc8:	ff d0                	callq  *%rax
      break;
    1bca:	90                   	nop
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
    1bcb:	83 85 4c ff ff ff 01 	addl   $0x1,-0xb4(%rbp)
    1bd2:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
    1bd8:	48 63 d0             	movslq %eax,%rdx
    1bdb:	48 8b 85 10 ff ff ff 	mov    -0xf0(%rbp),%rax
    1be2:	48 01 d0             	add    %rdx,%rax
    1be5:	0f b6 00             	movzbl (%rax),%eax
    1be8:	0f be c0             	movsbl %al,%eax
    1beb:	25 ff 00 00 00       	and    $0xff,%eax
    1bf0:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%rbp)
    1bf6:	83 bd 3c ff ff ff 00 	cmpl   $0x0,-0xc4(%rbp)
    1bfd:	0f 85 8e fc ff ff    	jne    1891 <printf+0x98>
    }
  }
}
    1c03:	eb 01                	jmp    1c06 <printf+0x40d>
      break;
    1c05:	90                   	nop
}
    1c06:	90                   	nop
    1c07:	c9                   	leaveq 
    1c08:	c3                   	retq   

0000000000001c09 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1c09:	f3 0f 1e fa          	endbr64 
    1c0d:	55                   	push   %rbp
    1c0e:	48 89 e5             	mov    %rsp,%rbp
    1c11:	48 83 ec 18          	sub    $0x18,%rsp
    1c15:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  Header *bp, *p;

  bp = (Header*)ap - 1;
    1c19:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1c1d:	48 83 e8 10          	sub    $0x10,%rax
    1c21:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1c25:	48 b8 a0 22 00 00 00 	movabs $0x22a0,%rax
    1c2c:	00 00 00 
    1c2f:	48 8b 00             	mov    (%rax),%rax
    1c32:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    1c36:	eb 2f                	jmp    1c67 <free+0x5e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1c38:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1c3c:	48 8b 00             	mov    (%rax),%rax
    1c3f:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
    1c43:	72 17                	jb     1c5c <free+0x53>
    1c45:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1c49:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
    1c4d:	77 2f                	ja     1c7e <free+0x75>
    1c4f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1c53:	48 8b 00             	mov    (%rax),%rax
    1c56:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
    1c5a:	72 22                	jb     1c7e <free+0x75>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1c5c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1c60:	48 8b 00             	mov    (%rax),%rax
    1c63:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    1c67:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1c6b:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
    1c6f:	76 c7                	jbe    1c38 <free+0x2f>
    1c71:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1c75:	48 8b 00             	mov    (%rax),%rax
    1c78:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
    1c7c:	73 ba                	jae    1c38 <free+0x2f>
      break;
  if(bp + bp->s.size == p->s.ptr){
    1c7e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1c82:	8b 40 08             	mov    0x8(%rax),%eax
    1c85:	89 c0                	mov    %eax,%eax
    1c87:	48 c1 e0 04          	shl    $0x4,%rax
    1c8b:	48 89 c2             	mov    %rax,%rdx
    1c8e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1c92:	48 01 c2             	add    %rax,%rdx
    1c95:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1c99:	48 8b 00             	mov    (%rax),%rax
    1c9c:	48 39 c2             	cmp    %rax,%rdx
    1c9f:	75 2d                	jne    1cce <free+0xc5>
    bp->s.size += p->s.ptr->s.size;
    1ca1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1ca5:	8b 50 08             	mov    0x8(%rax),%edx
    1ca8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1cac:	48 8b 00             	mov    (%rax),%rax
    1caf:	8b 40 08             	mov    0x8(%rax),%eax
    1cb2:	01 c2                	add    %eax,%edx
    1cb4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1cb8:	89 50 08             	mov    %edx,0x8(%rax)
    bp->s.ptr = p->s.ptr->s.ptr;
    1cbb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1cbf:	48 8b 00             	mov    (%rax),%rax
    1cc2:	48 8b 10             	mov    (%rax),%rdx
    1cc5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1cc9:	48 89 10             	mov    %rdx,(%rax)
    1ccc:	eb 0e                	jmp    1cdc <free+0xd3>
  } else
    bp->s.ptr = p->s.ptr;
    1cce:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1cd2:	48 8b 10             	mov    (%rax),%rdx
    1cd5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1cd9:	48 89 10             	mov    %rdx,(%rax)
  if(p + p->s.size == bp){
    1cdc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1ce0:	8b 40 08             	mov    0x8(%rax),%eax
    1ce3:	89 c0                	mov    %eax,%eax
    1ce5:	48 c1 e0 04          	shl    $0x4,%rax
    1ce9:	48 89 c2             	mov    %rax,%rdx
    1cec:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1cf0:	48 01 d0             	add    %rdx,%rax
    1cf3:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
    1cf7:	75 27                	jne    1d20 <free+0x117>
    p->s.size += bp->s.size;
    1cf9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1cfd:	8b 50 08             	mov    0x8(%rax),%edx
    1d00:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1d04:	8b 40 08             	mov    0x8(%rax),%eax
    1d07:	01 c2                	add    %eax,%edx
    1d09:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d0d:	89 50 08             	mov    %edx,0x8(%rax)
    p->s.ptr = bp->s.ptr;
    1d10:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1d14:	48 8b 10             	mov    (%rax),%rdx
    1d17:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d1b:	48 89 10             	mov    %rdx,(%rax)
    1d1e:	eb 0b                	jmp    1d2b <free+0x122>
  } else
    p->s.ptr = bp;
    1d20:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d24:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
    1d28:	48 89 10             	mov    %rdx,(%rax)
  freep = p;
    1d2b:	48 ba a0 22 00 00 00 	movabs $0x22a0,%rdx
    1d32:	00 00 00 
    1d35:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d39:	48 89 02             	mov    %rax,(%rdx)
}
    1d3c:	90                   	nop
    1d3d:	c9                   	leaveq 
    1d3e:	c3                   	retq   

0000000000001d3f <morecore>:

static Header*
morecore(uint nu)
{
    1d3f:	f3 0f 1e fa          	endbr64 
    1d43:	55                   	push   %rbp
    1d44:	48 89 e5             	mov    %rsp,%rbp
    1d47:	48 83 ec 20          	sub    $0x20,%rsp
    1d4b:	89 7d ec             	mov    %edi,-0x14(%rbp)
  char *p;
  Header *hp;

  if(nu < 4096)
    1d4e:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%rbp)
    1d55:	77 07                	ja     1d5e <morecore+0x1f>
    nu = 4096;
    1d57:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%rbp)
  p = sbrk(nu * sizeof(Header));
    1d5e:	8b 45 ec             	mov    -0x14(%rbp),%eax
    1d61:	48 c1 e0 04          	shl    $0x4,%rax
    1d65:	48 89 c7             	mov    %rax,%rdi
    1d68:	48 b8 df 15 00 00 00 	movabs $0x15df,%rax
    1d6f:	00 00 00 
    1d72:	ff d0                	callq  *%rax
    1d74:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  if(p == (char*)-1)
    1d78:	48 83 7d f8 ff       	cmpq   $0xffffffffffffffff,-0x8(%rbp)
    1d7d:	75 07                	jne    1d86 <morecore+0x47>
    return 0;
    1d7f:	b8 00 00 00 00       	mov    $0x0,%eax
    1d84:	eb 36                	jmp    1dbc <morecore+0x7d>
  hp = (Header*)p;
    1d86:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1d8a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  hp->s.size = nu;
    1d8e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1d92:	8b 55 ec             	mov    -0x14(%rbp),%edx
    1d95:	89 50 08             	mov    %edx,0x8(%rax)
  free((void*)(hp + 1));
    1d98:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1d9c:	48 83 c0 10          	add    $0x10,%rax
    1da0:	48 89 c7             	mov    %rax,%rdi
    1da3:	48 b8 09 1c 00 00 00 	movabs $0x1c09,%rax
    1daa:	00 00 00 
    1dad:	ff d0                	callq  *%rax
  return freep;
    1daf:	48 b8 a0 22 00 00 00 	movabs $0x22a0,%rax
    1db6:	00 00 00 
    1db9:	48 8b 00             	mov    (%rax),%rax
}
    1dbc:	c9                   	leaveq 
    1dbd:	c3                   	retq   

0000000000001dbe <malloc>:

void*
malloc(uint nbytes)
{
    1dbe:	f3 0f 1e fa          	endbr64 
    1dc2:	55                   	push   %rbp
    1dc3:	48 89 e5             	mov    %rsp,%rbp
    1dc6:	48 83 ec 30          	sub    $0x30,%rsp
    1dca:	89 7d dc             	mov    %edi,-0x24(%rbp)
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1dcd:	8b 45 dc             	mov    -0x24(%rbp),%eax
    1dd0:	48 83 c0 0f          	add    $0xf,%rax
    1dd4:	48 c1 e8 04          	shr    $0x4,%rax
    1dd8:	83 c0 01             	add    $0x1,%eax
    1ddb:	89 45 ec             	mov    %eax,-0x14(%rbp)
  if((prevp = freep) == 0){
    1dde:	48 b8 a0 22 00 00 00 	movabs $0x22a0,%rax
    1de5:	00 00 00 
    1de8:	48 8b 00             	mov    (%rax),%rax
    1deb:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    1def:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
    1df4:	75 4a                	jne    1e40 <malloc+0x82>
    base.s.ptr = freep = prevp = &base;
    1df6:	48 b8 90 22 00 00 00 	movabs $0x2290,%rax
    1dfd:	00 00 00 
    1e00:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    1e04:	48 ba a0 22 00 00 00 	movabs $0x22a0,%rdx
    1e0b:	00 00 00 
    1e0e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1e12:	48 89 02             	mov    %rax,(%rdx)
    1e15:	48 b8 a0 22 00 00 00 	movabs $0x22a0,%rax
    1e1c:	00 00 00 
    1e1f:	48 8b 00             	mov    (%rax),%rax
    1e22:	48 ba 90 22 00 00 00 	movabs $0x2290,%rdx
    1e29:	00 00 00 
    1e2c:	48 89 02             	mov    %rax,(%rdx)
    base.s.size = 0;
    1e2f:	48 b8 90 22 00 00 00 	movabs $0x2290,%rax
    1e36:	00 00 00 
    1e39:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1e40:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1e44:	48 8b 00             	mov    (%rax),%rax
    1e47:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    if(p->s.size >= nunits){
    1e4b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1e4f:	8b 40 08             	mov    0x8(%rax),%eax
    1e52:	39 45 ec             	cmp    %eax,-0x14(%rbp)
    1e55:	77 65                	ja     1ebc <malloc+0xfe>
      if(p->s.size == nunits)
    1e57:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1e5b:	8b 40 08             	mov    0x8(%rax),%eax
    1e5e:	39 45 ec             	cmp    %eax,-0x14(%rbp)
    1e61:	75 10                	jne    1e73 <malloc+0xb5>
        prevp->s.ptr = p->s.ptr;
    1e63:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1e67:	48 8b 10             	mov    (%rax),%rdx
    1e6a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1e6e:	48 89 10             	mov    %rdx,(%rax)
    1e71:	eb 2e                	jmp    1ea1 <malloc+0xe3>
      else {
        p->s.size -= nunits;
    1e73:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1e77:	8b 40 08             	mov    0x8(%rax),%eax
    1e7a:	2b 45 ec             	sub    -0x14(%rbp),%eax
    1e7d:	89 c2                	mov    %eax,%edx
    1e7f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1e83:	89 50 08             	mov    %edx,0x8(%rax)
        p += p->s.size;
    1e86:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1e8a:	8b 40 08             	mov    0x8(%rax),%eax
    1e8d:	89 c0                	mov    %eax,%eax
    1e8f:	48 c1 e0 04          	shl    $0x4,%rax
    1e93:	48 01 45 f8          	add    %rax,-0x8(%rbp)
        p->s.size = nunits;
    1e97:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1e9b:	8b 55 ec             	mov    -0x14(%rbp),%edx
    1e9e:	89 50 08             	mov    %edx,0x8(%rax)
      }
      freep = prevp;
    1ea1:	48 ba a0 22 00 00 00 	movabs $0x22a0,%rdx
    1ea8:	00 00 00 
    1eab:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1eaf:	48 89 02             	mov    %rax,(%rdx)
      return (void*)(p + 1);
    1eb2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1eb6:	48 83 c0 10          	add    $0x10,%rax
    1eba:	eb 4e                	jmp    1f0a <malloc+0x14c>
    }
    if(p == freep)
    1ebc:	48 b8 a0 22 00 00 00 	movabs $0x22a0,%rax
    1ec3:	00 00 00 
    1ec6:	48 8b 00             	mov    (%rax),%rax
    1ec9:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
    1ecd:	75 23                	jne    1ef2 <malloc+0x134>
      if((p = morecore(nunits)) == 0)
    1ecf:	8b 45 ec             	mov    -0x14(%rbp),%eax
    1ed2:	89 c7                	mov    %eax,%edi
    1ed4:	48 b8 3f 1d 00 00 00 	movabs $0x1d3f,%rax
    1edb:	00 00 00 
    1ede:	ff d0                	callq  *%rax
    1ee0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    1ee4:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
    1ee9:	75 07                	jne    1ef2 <malloc+0x134>
        return 0;
    1eeb:	b8 00 00 00 00       	mov    $0x0,%eax
    1ef0:	eb 18                	jmp    1f0a <malloc+0x14c>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1ef2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1ef6:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    1efa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1efe:	48 8b 00             	mov    (%rax),%rax
    1f01:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    if(p->s.size >= nunits){
    1f05:	e9 41 ff ff ff       	jmpq   1e4b <malloc+0x8d>
  }
}
    1f0a:	c9                   	leaveq 
    1f0b:	c3                   	retq   

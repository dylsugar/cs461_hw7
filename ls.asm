
_ls:     file format elf64-x86-64


Disassembly of section .text:

0000000000001000 <fmtname>:
#include "user.h"
#include "fs.h"

char*
fmtname(char *path)
{
    1000:	f3 0f 1e fa          	endbr64 
    1004:	55                   	push   %rbp
    1005:	48 89 e5             	mov    %rsp,%rbp
    1008:	53                   	push   %rbx
    1009:	48 83 ec 28          	sub    $0x28,%rsp
    100d:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  static char buf[DIRSIZ+1];
  char *p;

  // Find first character after last slash.
  for(p=path+strlen(path); p >= path && *p != '/'; p--)
    1011:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
    1015:	48 89 c7             	mov    %rax,%rdi
    1018:	48 b8 7a 15 00 00 00 	movabs $0x157a,%rax
    101f:	00 00 00 
    1022:	ff d0                	callq  *%rax
    1024:	89 c2                	mov    %eax,%edx
    1026:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
    102a:	48 01 d0             	add    %rdx,%rax
    102d:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
    1031:	eb 05                	jmp    1038 <fmtname+0x38>
    1033:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
    1038:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    103c:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
    1040:	72 0b                	jb     104d <fmtname+0x4d>
    1042:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1046:	0f b6 00             	movzbl (%rax),%eax
    1049:	3c 2f                	cmp    $0x2f,%al
    104b:	75 e6                	jne    1033 <fmtname+0x33>
    ;
  p++;
    104d:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)

  // Return blank-padded name.
  if(strlen(p) >= DIRSIZ)
    1052:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1056:	48 89 c7             	mov    %rax,%rdi
    1059:	48 b8 7a 15 00 00 00 	movabs $0x157a,%rax
    1060:	00 00 00 
    1063:	ff d0                	callq  *%rax
    1065:	83 f8 0d             	cmp    $0xd,%eax
    1068:	76 09                	jbe    1073 <fmtname+0x73>
    return p;
    106a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    106e:	e9 90 00 00 00       	jmpq   1103 <fmtname+0x103>
  memmove(buf, p, strlen(p));
    1073:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1077:	48 89 c7             	mov    %rax,%rdi
    107a:	48 b8 7a 15 00 00 00 	movabs $0x157a,%rax
    1081:	00 00 00 
    1084:	ff d0                	callq  *%rax
    1086:	89 c2                	mov    %eax,%edx
    1088:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    108c:	48 89 c6             	mov    %rax,%rsi
    108f:	48 bf e0 25 00 00 00 	movabs $0x25e0,%rdi
    1096:	00 00 00 
    1099:	48 b8 7f 17 00 00 00 	movabs $0x177f,%rax
    10a0:	00 00 00 
    10a3:	ff d0                	callq  *%rax
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
    10a5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    10a9:	48 89 c7             	mov    %rax,%rdi
    10ac:	48 b8 7a 15 00 00 00 	movabs $0x157a,%rax
    10b3:	00 00 00 
    10b6:	ff d0                	callq  *%rax
    10b8:	ba 0e 00 00 00       	mov    $0xe,%edx
    10bd:	89 d3                	mov    %edx,%ebx
    10bf:	29 c3                	sub    %eax,%ebx
    10c1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    10c5:	48 89 c7             	mov    %rax,%rdi
    10c8:	48 b8 7a 15 00 00 00 	movabs $0x157a,%rax
    10cf:	00 00 00 
    10d2:	ff d0                	callq  *%rax
    10d4:	89 c2                	mov    %eax,%edx
    10d6:	48 b8 e0 25 00 00 00 	movabs $0x25e0,%rax
    10dd:	00 00 00 
    10e0:	48 01 d0             	add    %rdx,%rax
    10e3:	89 da                	mov    %ebx,%edx
    10e5:	be 20 00 00 00       	mov    $0x20,%esi
    10ea:	48 89 c7             	mov    %rax,%rdi
    10ed:	48 b8 b0 15 00 00 00 	movabs $0x15b0,%rax
    10f4:	00 00 00 
    10f7:	ff d0                	callq  *%rax
  return buf;
    10f9:	48 b8 e0 25 00 00 00 	movabs $0x25e0,%rax
    1100:	00 00 00 
}
    1103:	48 83 c4 28          	add    $0x28,%rsp
    1107:	5b                   	pop    %rbx
    1108:	5d                   	pop    %rbp
    1109:	c3                   	retq   

000000000000110a <ls>:

void
ls(char *path)
{
    110a:	f3 0f 1e fa          	endbr64 
    110e:	55                   	push   %rbp
    110f:	48 89 e5             	mov    %rsp,%rbp
    1112:	41 55                	push   %r13
    1114:	41 54                	push   %r12
    1116:	53                   	push   %rbx
    1117:	48 81 ec 58 02 00 00 	sub    $0x258,%rsp
    111e:	48 89 bd 98 fd ff ff 	mov    %rdi,-0x268(%rbp)
  char buf[512], *p;
  int fd;
  struct dirent de;
  struct stat st;

  if((fd = open(path, 0)) < 0){
    1125:	48 8b 85 98 fd ff ff 	mov    -0x268(%rbp),%rax
    112c:	be 00 00 00 00       	mov    $0x0,%esi
    1131:	48 89 c7             	mov    %rax,%rdi
    1134:	48 b8 4d 18 00 00 00 	movabs $0x184d,%rax
    113b:	00 00 00 
    113e:	ff d0                	callq  *%rax
    1140:	89 45 dc             	mov    %eax,-0x24(%rbp)
    1143:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
    1147:	79 2f                	jns    1178 <ls+0x6e>
    printf(2, "ls: cannot open %s\n", path);
    1149:	48 8b 85 98 fd ff ff 	mov    -0x268(%rbp),%rax
    1150:	48 89 c2             	mov    %rax,%rdx
    1153:	48 be f0 21 00 00 00 	movabs $0x21f0,%rsi
    115a:	00 00 00 
    115d:	bf 02 00 00 00       	mov    $0x2,%edi
    1162:	b8 00 00 00 00       	mov    $0x0,%eax
    1167:	48 b9 dc 1a 00 00 00 	movabs $0x1adc,%rcx
    116e:	00 00 00 
    1171:	ff d1                	callq  *%rcx
    return;
    1173:	e9 9a 02 00 00       	jmpq   1412 <ls+0x308>
  }

  if(fstat(fd, &st) < 0){
    1178:	48 8d 95 a0 fd ff ff 	lea    -0x260(%rbp),%rdx
    117f:	8b 45 dc             	mov    -0x24(%rbp),%eax
    1182:	48 89 d6             	mov    %rdx,%rsi
    1185:	89 c7                	mov    %eax,%edi
    1187:	48 b8 74 18 00 00 00 	movabs $0x1874,%rax
    118e:	00 00 00 
    1191:	ff d0                	callq  *%rax
    1193:	85 c0                	test   %eax,%eax
    1195:	79 40                	jns    11d7 <ls+0xcd>
    printf(2, "ls: cannot stat %s\n", path);
    1197:	48 8b 85 98 fd ff ff 	mov    -0x268(%rbp),%rax
    119e:	48 89 c2             	mov    %rax,%rdx
    11a1:	48 be 04 22 00 00 00 	movabs $0x2204,%rsi
    11a8:	00 00 00 
    11ab:	bf 02 00 00 00       	mov    $0x2,%edi
    11b0:	b8 00 00 00 00       	mov    $0x0,%eax
    11b5:	48 b9 dc 1a 00 00 00 	movabs $0x1adc,%rcx
    11bc:	00 00 00 
    11bf:	ff d1                	callq  *%rcx
    close(fd);
    11c1:	8b 45 dc             	mov    -0x24(%rbp),%eax
    11c4:	89 c7                	mov    %eax,%edi
    11c6:	48 b8 26 18 00 00 00 	movabs $0x1826,%rax
    11cd:	00 00 00 
    11d0:	ff d0                	callq  *%rax
    return;
    11d2:	e9 3b 02 00 00       	jmpq   1412 <ls+0x308>
  }

  switch(st.type){
    11d7:	0f b7 85 a0 fd ff ff 	movzwl -0x260(%rbp),%eax
    11de:	98                   	cwtl   
    11df:	83 f8 01             	cmp    $0x1,%eax
    11e2:	74 68                	je     124c <ls+0x142>
    11e4:	83 f8 02             	cmp    $0x2,%eax
    11e7:	0f 85 14 02 00 00    	jne    1401 <ls+0x2f7>
  case T_FILE:
    printf(1, "%s %d %d %d\n", fmtname(path), st.type, st.ino, st.size);
    11ed:	44 8b ad b0 fd ff ff 	mov    -0x250(%rbp),%r13d
    11f4:	44 8b a5 a8 fd ff ff 	mov    -0x258(%rbp),%r12d
    11fb:	0f b7 85 a0 fd ff ff 	movzwl -0x260(%rbp),%eax
    1202:	0f bf d8             	movswl %ax,%ebx
    1205:	48 8b 85 98 fd ff ff 	mov    -0x268(%rbp),%rax
    120c:	48 89 c7             	mov    %rax,%rdi
    120f:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    1216:	00 00 00 
    1219:	ff d0                	callq  *%rax
    121b:	45 89 e9             	mov    %r13d,%r9d
    121e:	45 89 e0             	mov    %r12d,%r8d
    1221:	89 d9                	mov    %ebx,%ecx
    1223:	48 89 c2             	mov    %rax,%rdx
    1226:	48 be 18 22 00 00 00 	movabs $0x2218,%rsi
    122d:	00 00 00 
    1230:	bf 01 00 00 00       	mov    $0x1,%edi
    1235:	b8 00 00 00 00       	mov    $0x0,%eax
    123a:	49 ba dc 1a 00 00 00 	movabs $0x1adc,%r10
    1241:	00 00 00 
    1244:	41 ff d2             	callq  *%r10
    break;
    1247:	e9 b5 01 00 00       	jmpq   1401 <ls+0x2f7>

  case T_DIR:
    if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
    124c:	48 8b 85 98 fd ff ff 	mov    -0x268(%rbp),%rax
    1253:	48 89 c7             	mov    %rax,%rdi
    1256:	48 b8 7a 15 00 00 00 	movabs $0x157a,%rax
    125d:	00 00 00 
    1260:	ff d0                	callq  *%rax
    1262:	83 c0 10             	add    $0x10,%eax
    1265:	3d 00 02 00 00       	cmp    $0x200,%eax
    126a:	76 25                	jbe    1291 <ls+0x187>
      printf(1, "ls: path too long\n");
    126c:	48 be 25 22 00 00 00 	movabs $0x2225,%rsi
    1273:	00 00 00 
    1276:	bf 01 00 00 00       	mov    $0x1,%edi
    127b:	b8 00 00 00 00       	mov    $0x0,%eax
    1280:	48 ba dc 1a 00 00 00 	movabs $0x1adc,%rdx
    1287:	00 00 00 
    128a:	ff d2                	callq  *%rdx
      break;
    128c:	e9 70 01 00 00       	jmpq   1401 <ls+0x2f7>
    }
    strcpy(buf, path);
    1291:	48 8b 95 98 fd ff ff 	mov    -0x268(%rbp),%rdx
    1298:	48 8d 85 d0 fd ff ff 	lea    -0x230(%rbp),%rax
    129f:	48 89 d6             	mov    %rdx,%rsi
    12a2:	48 89 c7             	mov    %rax,%rdi
    12a5:	48 b8 dc 14 00 00 00 	movabs $0x14dc,%rax
    12ac:	00 00 00 
    12af:	ff d0                	callq  *%rax
    p = buf+strlen(buf);
    12b1:	48 8d 85 d0 fd ff ff 	lea    -0x230(%rbp),%rax
    12b8:	48 89 c7             	mov    %rax,%rdi
    12bb:	48 b8 7a 15 00 00 00 	movabs $0x157a,%rax
    12c2:	00 00 00 
    12c5:	ff d0                	callq  *%rax
    12c7:	89 c2                	mov    %eax,%edx
    12c9:	48 8d 85 d0 fd ff ff 	lea    -0x230(%rbp),%rax
    12d0:	48 01 d0             	add    %rdx,%rax
    12d3:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
    *p++ = '/';
    12d7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
    12db:	48 8d 50 01          	lea    0x1(%rax),%rdx
    12df:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
    12e3:	c6 00 2f             	movb   $0x2f,(%rax)
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
    12e6:	e9 ec 00 00 00       	jmpq   13d7 <ls+0x2cd>
      if(de.inum == 0)
    12eb:	0f b7 85 c0 fd ff ff 	movzwl -0x240(%rbp),%eax
    12f2:	66 85 c0             	test   %ax,%ax
    12f5:	75 05                	jne    12fc <ls+0x1f2>
        continue;
    12f7:	e9 db 00 00 00       	jmpq   13d7 <ls+0x2cd>
      memmove(p, de.name, DIRSIZ);
    12fc:	48 8d 85 c0 fd ff ff 	lea    -0x240(%rbp),%rax
    1303:	48 8d 48 02          	lea    0x2(%rax),%rcx
    1307:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
    130b:	ba 0e 00 00 00       	mov    $0xe,%edx
    1310:	48 89 ce             	mov    %rcx,%rsi
    1313:	48 89 c7             	mov    %rax,%rdi
    1316:	48 b8 7f 17 00 00 00 	movabs $0x177f,%rax
    131d:	00 00 00 
    1320:	ff d0                	callq  *%rax
      p[DIRSIZ] = 0;
    1322:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
    1326:	48 83 c0 0e          	add    $0xe,%rax
    132a:	c6 00 00             	movb   $0x0,(%rax)
      if(stat(buf, &st) < 0){
    132d:	48 8d 95 a0 fd ff ff 	lea    -0x260(%rbp),%rdx
    1334:	48 8d 85 d0 fd ff ff 	lea    -0x230(%rbp),%rax
    133b:	48 89 d6             	mov    %rdx,%rsi
    133e:	48 89 c7             	mov    %rax,%rdi
    1341:	48 b8 b6 16 00 00 00 	movabs $0x16b6,%rax
    1348:	00 00 00 
    134b:	ff d0                	callq  *%rax
    134d:	85 c0                	test   %eax,%eax
    134f:	79 2c                	jns    137d <ls+0x273>
        printf(1, "ls: cannot stat %s\n", buf);
    1351:	48 8d 85 d0 fd ff ff 	lea    -0x230(%rbp),%rax
    1358:	48 89 c2             	mov    %rax,%rdx
    135b:	48 be 04 22 00 00 00 	movabs $0x2204,%rsi
    1362:	00 00 00 
    1365:	bf 01 00 00 00       	mov    $0x1,%edi
    136a:	b8 00 00 00 00       	mov    $0x0,%eax
    136f:	48 b9 dc 1a 00 00 00 	movabs $0x1adc,%rcx
    1376:	00 00 00 
    1379:	ff d1                	callq  *%rcx
        continue;
    137b:	eb 5a                	jmp    13d7 <ls+0x2cd>
      }
      printf(1, "%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
    137d:	44 8b ad b0 fd ff ff 	mov    -0x250(%rbp),%r13d
    1384:	44 8b a5 a8 fd ff ff 	mov    -0x258(%rbp),%r12d
    138b:	0f b7 85 a0 fd ff ff 	movzwl -0x260(%rbp),%eax
    1392:	0f bf d8             	movswl %ax,%ebx
    1395:	48 8d 85 d0 fd ff ff 	lea    -0x230(%rbp),%rax
    139c:	48 89 c7             	mov    %rax,%rdi
    139f:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    13a6:	00 00 00 
    13a9:	ff d0                	callq  *%rax
    13ab:	45 89 e9             	mov    %r13d,%r9d
    13ae:	45 89 e0             	mov    %r12d,%r8d
    13b1:	89 d9                	mov    %ebx,%ecx
    13b3:	48 89 c2             	mov    %rax,%rdx
    13b6:	48 be 18 22 00 00 00 	movabs $0x2218,%rsi
    13bd:	00 00 00 
    13c0:	bf 01 00 00 00       	mov    $0x1,%edi
    13c5:	b8 00 00 00 00       	mov    $0x0,%eax
    13ca:	49 ba dc 1a 00 00 00 	movabs $0x1adc,%r10
    13d1:	00 00 00 
    13d4:	41 ff d2             	callq  *%r10
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
    13d7:	48 8d 8d c0 fd ff ff 	lea    -0x240(%rbp),%rcx
    13de:	8b 45 dc             	mov    -0x24(%rbp),%eax
    13e1:	ba 10 00 00 00       	mov    $0x10,%edx
    13e6:	48 89 ce             	mov    %rcx,%rsi
    13e9:	89 c7                	mov    %eax,%edi
    13eb:	48 b8 0c 18 00 00 00 	movabs $0x180c,%rax
    13f2:	00 00 00 
    13f5:	ff d0                	callq  *%rax
    13f7:	83 f8 10             	cmp    $0x10,%eax
    13fa:	0f 84 eb fe ff ff    	je     12eb <ls+0x1e1>
    }
    break;
    1400:	90                   	nop
  }
  close(fd);
    1401:	8b 45 dc             	mov    -0x24(%rbp),%eax
    1404:	89 c7                	mov    %eax,%edi
    1406:	48 b8 26 18 00 00 00 	movabs $0x1826,%rax
    140d:	00 00 00 
    1410:	ff d0                	callq  *%rax
}
    1412:	48 81 c4 58 02 00 00 	add    $0x258,%rsp
    1419:	5b                   	pop    %rbx
    141a:	41 5c                	pop    %r12
    141c:	41 5d                	pop    %r13
    141e:	5d                   	pop    %rbp
    141f:	c3                   	retq   

0000000000001420 <main>:

int
main(int argc, char *argv[])
{
    1420:	f3 0f 1e fa          	endbr64 
    1424:	55                   	push   %rbp
    1425:	48 89 e5             	mov    %rsp,%rbp
    1428:	48 83 ec 20          	sub    $0x20,%rsp
    142c:	89 7d ec             	mov    %edi,-0x14(%rbp)
    142f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  int i;

  if(argc < 2){
    1433:	83 7d ec 01          	cmpl   $0x1,-0x14(%rbp)
    1437:	7f 22                	jg     145b <main+0x3b>
    ls(".");
    1439:	48 bf 38 22 00 00 00 	movabs $0x2238,%rdi
    1440:	00 00 00 
    1443:	48 b8 0a 11 00 00 00 	movabs $0x110a,%rax
    144a:	00 00 00 
    144d:	ff d0                	callq  *%rax
    exit();
    144f:	48 b8 e5 17 00 00 00 	movabs $0x17e5,%rax
    1456:	00 00 00 
    1459:	ff d0                	callq  *%rax
  }
  for(i=1; i<argc; i++)
    145b:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
    1462:	eb 2a                	jmp    148e <main+0x6e>
    ls(argv[i]);
    1464:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1467:	48 98                	cltq   
    1469:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
    1470:	00 
    1471:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    1475:	48 01 d0             	add    %rdx,%rax
    1478:	48 8b 00             	mov    (%rax),%rax
    147b:	48 89 c7             	mov    %rax,%rdi
    147e:	48 b8 0a 11 00 00 00 	movabs $0x110a,%rax
    1485:	00 00 00 
    1488:	ff d0                	callq  *%rax
  for(i=1; i<argc; i++)
    148a:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    148e:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1491:	3b 45 ec             	cmp    -0x14(%rbp),%eax
    1494:	7c ce                	jl     1464 <main+0x44>
  exit();
    1496:	48 b8 e5 17 00 00 00 	movabs $0x17e5,%rax
    149d:	00 00 00 
    14a0:	ff d0                	callq  *%rax

00000000000014a2 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
    14a2:	f3 0f 1e fa          	endbr64 
    14a6:	55                   	push   %rbp
    14a7:	48 89 e5             	mov    %rsp,%rbp
    14aa:	48 83 ec 10          	sub    $0x10,%rsp
    14ae:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    14b2:	89 75 f4             	mov    %esi,-0xc(%rbp)
    14b5:	89 55 f0             	mov    %edx,-0x10(%rbp)
  asm volatile("cld; rep stosb" :
    14b8:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
    14bc:	8b 55 f0             	mov    -0x10(%rbp),%edx
    14bf:	8b 45 f4             	mov    -0xc(%rbp),%eax
    14c2:	48 89 ce             	mov    %rcx,%rsi
    14c5:	48 89 f7             	mov    %rsi,%rdi
    14c8:	89 d1                	mov    %edx,%ecx
    14ca:	fc                   	cld    
    14cb:	f3 aa                	rep stos %al,%es:(%rdi)
    14cd:	89 ca                	mov    %ecx,%edx
    14cf:	48 89 fe             	mov    %rdi,%rsi
    14d2:	48 89 75 f8          	mov    %rsi,-0x8(%rbp)
    14d6:	89 55 f0             	mov    %edx,-0x10(%rbp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
    14d9:	90                   	nop
    14da:	c9                   	leaveq 
    14db:	c3                   	retq   

00000000000014dc <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
    14dc:	f3 0f 1e fa          	endbr64 
    14e0:	55                   	push   %rbp
    14e1:	48 89 e5             	mov    %rsp,%rbp
    14e4:	48 83 ec 20          	sub    $0x20,%rsp
    14e8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    14ec:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  char *os;

  os = s;
    14f0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    14f4:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  while((*s++ = *t++) != 0)
    14f8:	90                   	nop
    14f9:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
    14fd:	48 8d 42 01          	lea    0x1(%rdx),%rax
    1501:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    1505:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1509:	48 8d 48 01          	lea    0x1(%rax),%rcx
    150d:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
    1511:	0f b6 12             	movzbl (%rdx),%edx
    1514:	88 10                	mov    %dl,(%rax)
    1516:	0f b6 00             	movzbl (%rax),%eax
    1519:	84 c0                	test   %al,%al
    151b:	75 dc                	jne    14f9 <strcpy+0x1d>
    ;
  return os;
    151d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
    1521:	c9                   	leaveq 
    1522:	c3                   	retq   

0000000000001523 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    1523:	f3 0f 1e fa          	endbr64 
    1527:	55                   	push   %rbp
    1528:	48 89 e5             	mov    %rsp,%rbp
    152b:	48 83 ec 10          	sub    $0x10,%rsp
    152f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    1533:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  while(*p && *p == *q)
    1537:	eb 0a                	jmp    1543 <strcmp+0x20>
    p++, q++;
    1539:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
    153e:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
  while(*p && *p == *q)
    1543:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1547:	0f b6 00             	movzbl (%rax),%eax
    154a:	84 c0                	test   %al,%al
    154c:	74 12                	je     1560 <strcmp+0x3d>
    154e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1552:	0f b6 10             	movzbl (%rax),%edx
    1555:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1559:	0f b6 00             	movzbl (%rax),%eax
    155c:	38 c2                	cmp    %al,%dl
    155e:	74 d9                	je     1539 <strcmp+0x16>
  return (uchar)*p - (uchar)*q;
    1560:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1564:	0f b6 00             	movzbl (%rax),%eax
    1567:	0f b6 d0             	movzbl %al,%edx
    156a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    156e:	0f b6 00             	movzbl (%rax),%eax
    1571:	0f b6 c0             	movzbl %al,%eax
    1574:	29 c2                	sub    %eax,%edx
    1576:	89 d0                	mov    %edx,%eax
}
    1578:	c9                   	leaveq 
    1579:	c3                   	retq   

000000000000157a <strlen>:

uint
strlen(char *s)
{
    157a:	f3 0f 1e fa          	endbr64 
    157e:	55                   	push   %rbp
    157f:	48 89 e5             	mov    %rsp,%rbp
    1582:	48 83 ec 18          	sub    $0x18,%rsp
    1586:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  int n;

  for(n = 0; s[n]; n++)
    158a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    1591:	eb 04                	jmp    1597 <strlen+0x1d>
    1593:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    1597:	8b 45 fc             	mov    -0x4(%rbp),%eax
    159a:	48 63 d0             	movslq %eax,%rdx
    159d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    15a1:	48 01 d0             	add    %rdx,%rax
    15a4:	0f b6 00             	movzbl (%rax),%eax
    15a7:	84 c0                	test   %al,%al
    15a9:	75 e8                	jne    1593 <strlen+0x19>
    ;
  return n;
    15ab:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
    15ae:	c9                   	leaveq 
    15af:	c3                   	retq   

00000000000015b0 <memset>:

void*
memset(void *dst, int c, uint n)
{
    15b0:	f3 0f 1e fa          	endbr64 
    15b4:	55                   	push   %rbp
    15b5:	48 89 e5             	mov    %rsp,%rbp
    15b8:	48 83 ec 10          	sub    $0x10,%rsp
    15bc:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    15c0:	89 75 f4             	mov    %esi,-0xc(%rbp)
    15c3:	89 55 f0             	mov    %edx,-0x10(%rbp)
  stosb(dst, c, n);
    15c6:	8b 55 f0             	mov    -0x10(%rbp),%edx
    15c9:	8b 4d f4             	mov    -0xc(%rbp),%ecx
    15cc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    15d0:	89 ce                	mov    %ecx,%esi
    15d2:	48 89 c7             	mov    %rax,%rdi
    15d5:	48 b8 a2 14 00 00 00 	movabs $0x14a2,%rax
    15dc:	00 00 00 
    15df:	ff d0                	callq  *%rax
  return dst;
    15e1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
    15e5:	c9                   	leaveq 
    15e6:	c3                   	retq   

00000000000015e7 <strchr>:

char*
strchr(const char *s, char c)
{
    15e7:	f3 0f 1e fa          	endbr64 
    15eb:	55                   	push   %rbp
    15ec:	48 89 e5             	mov    %rsp,%rbp
    15ef:	48 83 ec 10          	sub    $0x10,%rsp
    15f3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    15f7:	89 f0                	mov    %esi,%eax
    15f9:	88 45 f4             	mov    %al,-0xc(%rbp)
  for(; *s; s++)
    15fc:	eb 17                	jmp    1615 <strchr+0x2e>
    if(*s == c)
    15fe:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1602:	0f b6 00             	movzbl (%rax),%eax
    1605:	38 45 f4             	cmp    %al,-0xc(%rbp)
    1608:	75 06                	jne    1610 <strchr+0x29>
      return (char*)s;
    160a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    160e:	eb 15                	jmp    1625 <strchr+0x3e>
  for(; *s; s++)
    1610:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
    1615:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1619:	0f b6 00             	movzbl (%rax),%eax
    161c:	84 c0                	test   %al,%al
    161e:	75 de                	jne    15fe <strchr+0x17>
  return 0;
    1620:	b8 00 00 00 00       	mov    $0x0,%eax
}
    1625:	c9                   	leaveq 
    1626:	c3                   	retq   

0000000000001627 <gets>:

char*
gets(char *buf, int max)
{
    1627:	f3 0f 1e fa          	endbr64 
    162b:	55                   	push   %rbp
    162c:	48 89 e5             	mov    %rsp,%rbp
    162f:	48 83 ec 20          	sub    $0x20,%rsp
    1633:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    1637:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    163a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    1641:	eb 4f                	jmp    1692 <gets+0x6b>
    cc = read(0, &c, 1);
    1643:	48 8d 45 f7          	lea    -0x9(%rbp),%rax
    1647:	ba 01 00 00 00       	mov    $0x1,%edx
    164c:	48 89 c6             	mov    %rax,%rsi
    164f:	bf 00 00 00 00       	mov    $0x0,%edi
    1654:	48 b8 0c 18 00 00 00 	movabs $0x180c,%rax
    165b:	00 00 00 
    165e:	ff d0                	callq  *%rax
    1660:	89 45 f8             	mov    %eax,-0x8(%rbp)
    if(cc < 1)
    1663:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
    1667:	7e 36                	jle    169f <gets+0x78>
      break;
    buf[i++] = c;
    1669:	8b 45 fc             	mov    -0x4(%rbp),%eax
    166c:	8d 50 01             	lea    0x1(%rax),%edx
    166f:	89 55 fc             	mov    %edx,-0x4(%rbp)
    1672:	48 63 d0             	movslq %eax,%rdx
    1675:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1679:	48 01 c2             	add    %rax,%rdx
    167c:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
    1680:	88 02                	mov    %al,(%rdx)
    if(c == '\n' || c == '\r')
    1682:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
    1686:	3c 0a                	cmp    $0xa,%al
    1688:	74 16                	je     16a0 <gets+0x79>
    168a:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
    168e:	3c 0d                	cmp    $0xd,%al
    1690:	74 0e                	je     16a0 <gets+0x79>
  for(i=0; i+1 < max; ){
    1692:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1695:	83 c0 01             	add    $0x1,%eax
    1698:	39 45 e4             	cmp    %eax,-0x1c(%rbp)
    169b:	7f a6                	jg     1643 <gets+0x1c>
    169d:	eb 01                	jmp    16a0 <gets+0x79>
      break;
    169f:	90                   	nop
      break;
  }
  buf[i] = '\0';
    16a0:	8b 45 fc             	mov    -0x4(%rbp),%eax
    16a3:	48 63 d0             	movslq %eax,%rdx
    16a6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    16aa:	48 01 d0             	add    %rdx,%rax
    16ad:	c6 00 00             	movb   $0x0,(%rax)
  return buf;
    16b0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
    16b4:	c9                   	leaveq 
    16b5:	c3                   	retq   

00000000000016b6 <stat>:

int
stat(char *n, struct stat *st)
{
    16b6:	f3 0f 1e fa          	endbr64 
    16ba:	55                   	push   %rbp
    16bb:	48 89 e5             	mov    %rsp,%rbp
    16be:	48 83 ec 20          	sub    $0x20,%rsp
    16c2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    16c6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    16ca:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    16ce:	be 00 00 00 00       	mov    $0x0,%esi
    16d3:	48 89 c7             	mov    %rax,%rdi
    16d6:	48 b8 4d 18 00 00 00 	movabs $0x184d,%rax
    16dd:	00 00 00 
    16e0:	ff d0                	callq  *%rax
    16e2:	89 45 fc             	mov    %eax,-0x4(%rbp)
  if(fd < 0)
    16e5:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
    16e9:	79 07                	jns    16f2 <stat+0x3c>
    return -1;
    16eb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    16f0:	eb 2f                	jmp    1721 <stat+0x6b>
  r = fstat(fd, st);
    16f2:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
    16f6:	8b 45 fc             	mov    -0x4(%rbp),%eax
    16f9:	48 89 d6             	mov    %rdx,%rsi
    16fc:	89 c7                	mov    %eax,%edi
    16fe:	48 b8 74 18 00 00 00 	movabs $0x1874,%rax
    1705:	00 00 00 
    1708:	ff d0                	callq  *%rax
    170a:	89 45 f8             	mov    %eax,-0x8(%rbp)
  close(fd);
    170d:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1710:	89 c7                	mov    %eax,%edi
    1712:	48 b8 26 18 00 00 00 	movabs $0x1826,%rax
    1719:	00 00 00 
    171c:	ff d0                	callq  *%rax
  return r;
    171e:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
    1721:	c9                   	leaveq 
    1722:	c3                   	retq   

0000000000001723 <atoi>:

int
atoi(const char *s)
{
    1723:	f3 0f 1e fa          	endbr64 
    1727:	55                   	push   %rbp
    1728:	48 89 e5             	mov    %rsp,%rbp
    172b:	48 83 ec 18          	sub    $0x18,%rsp
    172f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  int n;

  n = 0;
    1733:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  while('0' <= *s && *s <= '9')
    173a:	eb 28                	jmp    1764 <atoi+0x41>
    n = n*10 + *s++ - '0';
    173c:	8b 55 fc             	mov    -0x4(%rbp),%edx
    173f:	89 d0                	mov    %edx,%eax
    1741:	c1 e0 02             	shl    $0x2,%eax
    1744:	01 d0                	add    %edx,%eax
    1746:	01 c0                	add    %eax,%eax
    1748:	89 c1                	mov    %eax,%ecx
    174a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    174e:	48 8d 50 01          	lea    0x1(%rax),%rdx
    1752:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
    1756:	0f b6 00             	movzbl (%rax),%eax
    1759:	0f be c0             	movsbl %al,%eax
    175c:	01 c8                	add    %ecx,%eax
    175e:	83 e8 30             	sub    $0x30,%eax
    1761:	89 45 fc             	mov    %eax,-0x4(%rbp)
  while('0' <= *s && *s <= '9')
    1764:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1768:	0f b6 00             	movzbl (%rax),%eax
    176b:	3c 2f                	cmp    $0x2f,%al
    176d:	7e 0b                	jle    177a <atoi+0x57>
    176f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1773:	0f b6 00             	movzbl (%rax),%eax
    1776:	3c 39                	cmp    $0x39,%al
    1778:	7e c2                	jle    173c <atoi+0x19>
  return n;
    177a:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
    177d:	c9                   	leaveq 
    177e:	c3                   	retq   

000000000000177f <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    177f:	f3 0f 1e fa          	endbr64 
    1783:	55                   	push   %rbp
    1784:	48 89 e5             	mov    %rsp,%rbp
    1787:	48 83 ec 28          	sub    $0x28,%rsp
    178b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    178f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
    1793:	89 55 dc             	mov    %edx,-0x24(%rbp)
  char *dst, *src;

  dst = vdst;
    1796:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    179a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  src = vsrc;
    179e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    17a2:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  while(n-- > 0)
    17a6:	eb 1d                	jmp    17c5 <memmove+0x46>
    *dst++ = *src++;
    17a8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
    17ac:	48 8d 42 01          	lea    0x1(%rdx),%rax
    17b0:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    17b4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    17b8:	48 8d 48 01          	lea    0x1(%rax),%rcx
    17bc:	48 89 4d f8          	mov    %rcx,-0x8(%rbp)
    17c0:	0f b6 12             	movzbl (%rdx),%edx
    17c3:	88 10                	mov    %dl,(%rax)
  while(n-- > 0)
    17c5:	8b 45 dc             	mov    -0x24(%rbp),%eax
    17c8:	8d 50 ff             	lea    -0x1(%rax),%edx
    17cb:	89 55 dc             	mov    %edx,-0x24(%rbp)
    17ce:	85 c0                	test   %eax,%eax
    17d0:	7f d6                	jg     17a8 <memmove+0x29>
  return vdst;
    17d2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
    17d6:	c9                   	leaveq 
    17d7:	c3                   	retq   

00000000000017d8 <fork>:
    mov $SYS_ ## name, %rax; \
    mov %rcx, %r10 ;\
    syscall		  ;\
    ret

SYSCALL(fork)
    17d8:	48 c7 c0 01 00 00 00 	mov    $0x1,%rax
    17df:	49 89 ca             	mov    %rcx,%r10
    17e2:	0f 05                	syscall 
    17e4:	c3                   	retq   

00000000000017e5 <exit>:
SYSCALL(exit)
    17e5:	48 c7 c0 02 00 00 00 	mov    $0x2,%rax
    17ec:	49 89 ca             	mov    %rcx,%r10
    17ef:	0f 05                	syscall 
    17f1:	c3                   	retq   

00000000000017f2 <wait>:
SYSCALL(wait)
    17f2:	48 c7 c0 03 00 00 00 	mov    $0x3,%rax
    17f9:	49 89 ca             	mov    %rcx,%r10
    17fc:	0f 05                	syscall 
    17fe:	c3                   	retq   

00000000000017ff <pipe>:
SYSCALL(pipe)
    17ff:	48 c7 c0 04 00 00 00 	mov    $0x4,%rax
    1806:	49 89 ca             	mov    %rcx,%r10
    1809:	0f 05                	syscall 
    180b:	c3                   	retq   

000000000000180c <read>:
SYSCALL(read)
    180c:	48 c7 c0 05 00 00 00 	mov    $0x5,%rax
    1813:	49 89 ca             	mov    %rcx,%r10
    1816:	0f 05                	syscall 
    1818:	c3                   	retq   

0000000000001819 <write>:
SYSCALL(write)
    1819:	48 c7 c0 10 00 00 00 	mov    $0x10,%rax
    1820:	49 89 ca             	mov    %rcx,%r10
    1823:	0f 05                	syscall 
    1825:	c3                   	retq   

0000000000001826 <close>:
SYSCALL(close)
    1826:	48 c7 c0 15 00 00 00 	mov    $0x15,%rax
    182d:	49 89 ca             	mov    %rcx,%r10
    1830:	0f 05                	syscall 
    1832:	c3                   	retq   

0000000000001833 <kill>:
SYSCALL(kill)
    1833:	48 c7 c0 06 00 00 00 	mov    $0x6,%rax
    183a:	49 89 ca             	mov    %rcx,%r10
    183d:	0f 05                	syscall 
    183f:	c3                   	retq   

0000000000001840 <exec>:
SYSCALL(exec)
    1840:	48 c7 c0 07 00 00 00 	mov    $0x7,%rax
    1847:	49 89 ca             	mov    %rcx,%r10
    184a:	0f 05                	syscall 
    184c:	c3                   	retq   

000000000000184d <open>:
SYSCALL(open)
    184d:	48 c7 c0 0f 00 00 00 	mov    $0xf,%rax
    1854:	49 89 ca             	mov    %rcx,%r10
    1857:	0f 05                	syscall 
    1859:	c3                   	retq   

000000000000185a <mknod>:
SYSCALL(mknod)
    185a:	48 c7 c0 11 00 00 00 	mov    $0x11,%rax
    1861:	49 89 ca             	mov    %rcx,%r10
    1864:	0f 05                	syscall 
    1866:	c3                   	retq   

0000000000001867 <unlink>:
SYSCALL(unlink)
    1867:	48 c7 c0 12 00 00 00 	mov    $0x12,%rax
    186e:	49 89 ca             	mov    %rcx,%r10
    1871:	0f 05                	syscall 
    1873:	c3                   	retq   

0000000000001874 <fstat>:
SYSCALL(fstat)
    1874:	48 c7 c0 08 00 00 00 	mov    $0x8,%rax
    187b:	49 89 ca             	mov    %rcx,%r10
    187e:	0f 05                	syscall 
    1880:	c3                   	retq   

0000000000001881 <link>:
SYSCALL(link)
    1881:	48 c7 c0 13 00 00 00 	mov    $0x13,%rax
    1888:	49 89 ca             	mov    %rcx,%r10
    188b:	0f 05                	syscall 
    188d:	c3                   	retq   

000000000000188e <mkdir>:
SYSCALL(mkdir)
    188e:	48 c7 c0 14 00 00 00 	mov    $0x14,%rax
    1895:	49 89 ca             	mov    %rcx,%r10
    1898:	0f 05                	syscall 
    189a:	c3                   	retq   

000000000000189b <chdir>:
SYSCALL(chdir)
    189b:	48 c7 c0 09 00 00 00 	mov    $0x9,%rax
    18a2:	49 89 ca             	mov    %rcx,%r10
    18a5:	0f 05                	syscall 
    18a7:	c3                   	retq   

00000000000018a8 <dup>:
SYSCALL(dup)
    18a8:	48 c7 c0 0a 00 00 00 	mov    $0xa,%rax
    18af:	49 89 ca             	mov    %rcx,%r10
    18b2:	0f 05                	syscall 
    18b4:	c3                   	retq   

00000000000018b5 <getpid>:
SYSCALL(getpid)
    18b5:	48 c7 c0 0b 00 00 00 	mov    $0xb,%rax
    18bc:	49 89 ca             	mov    %rcx,%r10
    18bf:	0f 05                	syscall 
    18c1:	c3                   	retq   

00000000000018c2 <sbrk>:
SYSCALL(sbrk)
    18c2:	48 c7 c0 0c 00 00 00 	mov    $0xc,%rax
    18c9:	49 89 ca             	mov    %rcx,%r10
    18cc:	0f 05                	syscall 
    18ce:	c3                   	retq   

00000000000018cf <sleep>:
SYSCALL(sleep)
    18cf:	48 c7 c0 0d 00 00 00 	mov    $0xd,%rax
    18d6:	49 89 ca             	mov    %rcx,%r10
    18d9:	0f 05                	syscall 
    18db:	c3                   	retq   

00000000000018dc <uptime>:
SYSCALL(uptime)
    18dc:	48 c7 c0 0e 00 00 00 	mov    $0xe,%rax
    18e3:	49 89 ca             	mov    %rcx,%r10
    18e6:	0f 05                	syscall 
    18e8:	c3                   	retq   

00000000000018e9 <aread>:
SYSCALL(aread)
    18e9:	48 c7 c0 16 00 00 00 	mov    $0x16,%rax
    18f0:	49 89 ca             	mov    %rcx,%r10
    18f3:	0f 05                	syscall 
    18f5:	c3                   	retq   

00000000000018f6 <putc>:

#include <stdarg.h>

static void
putc(int fd, char c)
{
    18f6:	f3 0f 1e fa          	endbr64 
    18fa:	55                   	push   %rbp
    18fb:	48 89 e5             	mov    %rsp,%rbp
    18fe:	48 83 ec 10          	sub    $0x10,%rsp
    1902:	89 7d fc             	mov    %edi,-0x4(%rbp)
    1905:	89 f0                	mov    %esi,%eax
    1907:	88 45 f8             	mov    %al,-0x8(%rbp)
  write(fd, &c, 1);
    190a:	48 8d 4d f8          	lea    -0x8(%rbp),%rcx
    190e:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1911:	ba 01 00 00 00       	mov    $0x1,%edx
    1916:	48 89 ce             	mov    %rcx,%rsi
    1919:	89 c7                	mov    %eax,%edi
    191b:	48 b8 19 18 00 00 00 	movabs $0x1819,%rax
    1922:	00 00 00 
    1925:	ff d0                	callq  *%rax
}
    1927:	90                   	nop
    1928:	c9                   	leaveq 
    1929:	c3                   	retq   

000000000000192a <print_x64>:

static char digits[] = "0123456789abcdef";

  static void
print_x64(int fd, addr_t x)
{
    192a:	f3 0f 1e fa          	endbr64 
    192e:	55                   	push   %rbp
    192f:	48 89 e5             	mov    %rsp,%rbp
    1932:	48 83 ec 20          	sub    $0x20,%rsp
    1936:	89 7d ec             	mov    %edi,-0x14(%rbp)
    1939:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  int i;
  for (i = 0; i < (sizeof(addr_t) * 2); i++, x <<= 4)
    193d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    1944:	eb 35                	jmp    197b <print_x64+0x51>
    putc(fd, digits[x >> (sizeof(addr_t) * 8 - 4)]);
    1946:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    194a:	48 c1 e8 3c          	shr    $0x3c,%rax
    194e:	48 ba c0 25 00 00 00 	movabs $0x25c0,%rdx
    1955:	00 00 00 
    1958:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
    195c:	0f be d0             	movsbl %al,%edx
    195f:	8b 45 ec             	mov    -0x14(%rbp),%eax
    1962:	89 d6                	mov    %edx,%esi
    1964:	89 c7                	mov    %eax,%edi
    1966:	48 b8 f6 18 00 00 00 	movabs $0x18f6,%rax
    196d:	00 00 00 
    1970:	ff d0                	callq  *%rax
  for (i = 0; i < (sizeof(addr_t) * 2); i++, x <<= 4)
    1972:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    1976:	48 c1 65 e0 04       	shlq   $0x4,-0x20(%rbp)
    197b:	8b 45 fc             	mov    -0x4(%rbp),%eax
    197e:	83 f8 0f             	cmp    $0xf,%eax
    1981:	76 c3                	jbe    1946 <print_x64+0x1c>
}
    1983:	90                   	nop
    1984:	90                   	nop
    1985:	c9                   	leaveq 
    1986:	c3                   	retq   

0000000000001987 <print_x32>:

  static void
print_x32(int fd, uint x)
{
    1987:	f3 0f 1e fa          	endbr64 
    198b:	55                   	push   %rbp
    198c:	48 89 e5             	mov    %rsp,%rbp
    198f:	48 83 ec 20          	sub    $0x20,%rsp
    1993:	89 7d ec             	mov    %edi,-0x14(%rbp)
    1996:	89 75 e8             	mov    %esi,-0x18(%rbp)
  int i;
  for (i = 0; i < (sizeof(uint) * 2); i++, x <<= 4)
    1999:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    19a0:	eb 36                	jmp    19d8 <print_x32+0x51>
    putc(fd, digits[x >> (sizeof(uint) * 8 - 4)]);
    19a2:	8b 45 e8             	mov    -0x18(%rbp),%eax
    19a5:	c1 e8 1c             	shr    $0x1c,%eax
    19a8:	89 c2                	mov    %eax,%edx
    19aa:	48 b8 c0 25 00 00 00 	movabs $0x25c0,%rax
    19b1:	00 00 00 
    19b4:	89 d2                	mov    %edx,%edx
    19b6:	0f b6 04 10          	movzbl (%rax,%rdx,1),%eax
    19ba:	0f be d0             	movsbl %al,%edx
    19bd:	8b 45 ec             	mov    -0x14(%rbp),%eax
    19c0:	89 d6                	mov    %edx,%esi
    19c2:	89 c7                	mov    %eax,%edi
    19c4:	48 b8 f6 18 00 00 00 	movabs $0x18f6,%rax
    19cb:	00 00 00 
    19ce:	ff d0                	callq  *%rax
  for (i = 0; i < (sizeof(uint) * 2); i++, x <<= 4)
    19d0:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    19d4:	c1 65 e8 04          	shll   $0x4,-0x18(%rbp)
    19d8:	8b 45 fc             	mov    -0x4(%rbp),%eax
    19db:	83 f8 07             	cmp    $0x7,%eax
    19de:	76 c2                	jbe    19a2 <print_x32+0x1b>
}
    19e0:	90                   	nop
    19e1:	90                   	nop
    19e2:	c9                   	leaveq 
    19e3:	c3                   	retq   

00000000000019e4 <print_d>:

  static void
print_d(int fd, int v)
{
    19e4:	f3 0f 1e fa          	endbr64 
    19e8:	55                   	push   %rbp
    19e9:	48 89 e5             	mov    %rsp,%rbp
    19ec:	48 83 ec 30          	sub    $0x30,%rsp
    19f0:	89 7d dc             	mov    %edi,-0x24(%rbp)
    19f3:	89 75 d8             	mov    %esi,-0x28(%rbp)
  char buf[16];
  int64 x = v;
    19f6:	8b 45 d8             	mov    -0x28(%rbp),%eax
    19f9:	48 98                	cltq   
    19fb:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

  if (v < 0)
    19ff:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
    1a03:	79 04                	jns    1a09 <print_d+0x25>
    x = -x;
    1a05:	48 f7 5d f8          	negq   -0x8(%rbp)

  int i = 0;
    1a09:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
  do {
    buf[i++] = digits[x % 10];
    1a10:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
    1a14:	48 ba 67 66 66 66 66 	movabs $0x6666666666666667,%rdx
    1a1b:	66 66 66 
    1a1e:	48 89 c8             	mov    %rcx,%rax
    1a21:	48 f7 ea             	imul   %rdx
    1a24:	48 c1 fa 02          	sar    $0x2,%rdx
    1a28:	48 89 c8             	mov    %rcx,%rax
    1a2b:	48 c1 f8 3f          	sar    $0x3f,%rax
    1a2f:	48 29 c2             	sub    %rax,%rdx
    1a32:	48 89 d0             	mov    %rdx,%rax
    1a35:	48 c1 e0 02          	shl    $0x2,%rax
    1a39:	48 01 d0             	add    %rdx,%rax
    1a3c:	48 01 c0             	add    %rax,%rax
    1a3f:	48 29 c1             	sub    %rax,%rcx
    1a42:	48 89 ca             	mov    %rcx,%rdx
    1a45:	8b 45 f4             	mov    -0xc(%rbp),%eax
    1a48:	8d 48 01             	lea    0x1(%rax),%ecx
    1a4b:	89 4d f4             	mov    %ecx,-0xc(%rbp)
    1a4e:	48 b9 c0 25 00 00 00 	movabs $0x25c0,%rcx
    1a55:	00 00 00 
    1a58:	0f b6 14 11          	movzbl (%rcx,%rdx,1),%edx
    1a5c:	48 98                	cltq   
    1a5e:	88 54 05 e0          	mov    %dl,-0x20(%rbp,%rax,1)
    x /= 10;
    1a62:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
    1a66:	48 ba 67 66 66 66 66 	movabs $0x6666666666666667,%rdx
    1a6d:	66 66 66 
    1a70:	48 89 c8             	mov    %rcx,%rax
    1a73:	48 f7 ea             	imul   %rdx
    1a76:	48 c1 fa 02          	sar    $0x2,%rdx
    1a7a:	48 89 c8             	mov    %rcx,%rax
    1a7d:	48 c1 f8 3f          	sar    $0x3f,%rax
    1a81:	48 29 c2             	sub    %rax,%rdx
    1a84:	48 89 d0             	mov    %rdx,%rax
    1a87:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  } while(x != 0);
    1a8b:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
    1a90:	0f 85 7a ff ff ff    	jne    1a10 <print_d+0x2c>

  if (v < 0)
    1a96:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
    1a9a:	79 32                	jns    1ace <print_d+0xea>
    buf[i++] = '-';
    1a9c:	8b 45 f4             	mov    -0xc(%rbp),%eax
    1a9f:	8d 50 01             	lea    0x1(%rax),%edx
    1aa2:	89 55 f4             	mov    %edx,-0xc(%rbp)
    1aa5:	48 98                	cltq   
    1aa7:	c6 44 05 e0 2d       	movb   $0x2d,-0x20(%rbp,%rax,1)

  while (--i >= 0)
    1aac:	eb 20                	jmp    1ace <print_d+0xea>
    putc(fd, buf[i]);
    1aae:	8b 45 f4             	mov    -0xc(%rbp),%eax
    1ab1:	48 98                	cltq   
    1ab3:	0f b6 44 05 e0       	movzbl -0x20(%rbp,%rax,1),%eax
    1ab8:	0f be d0             	movsbl %al,%edx
    1abb:	8b 45 dc             	mov    -0x24(%rbp),%eax
    1abe:	89 d6                	mov    %edx,%esi
    1ac0:	89 c7                	mov    %eax,%edi
    1ac2:	48 b8 f6 18 00 00 00 	movabs $0x18f6,%rax
    1ac9:	00 00 00 
    1acc:	ff d0                	callq  *%rax
  while (--i >= 0)
    1ace:	83 6d f4 01          	subl   $0x1,-0xc(%rbp)
    1ad2:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
    1ad6:	79 d6                	jns    1aae <print_d+0xca>
}
    1ad8:	90                   	nop
    1ad9:	90                   	nop
    1ada:	c9                   	leaveq 
    1adb:	c3                   	retq   

0000000000001adc <printf>:
// Print to the given fd. Only understands %d, %x, %p, %s.
  void
printf(int fd, char *fmt, ...)
{
    1adc:	f3 0f 1e fa          	endbr64 
    1ae0:	55                   	push   %rbp
    1ae1:	48 89 e5             	mov    %rsp,%rbp
    1ae4:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
    1aeb:	89 bd 1c ff ff ff    	mov    %edi,-0xe4(%rbp)
    1af1:	48 89 b5 10 ff ff ff 	mov    %rsi,-0xf0(%rbp)
    1af8:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
    1aff:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
    1b06:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
    1b0d:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
    1b14:	84 c0                	test   %al,%al
    1b16:	74 20                	je     1b38 <printf+0x5c>
    1b18:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
    1b1c:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
    1b20:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
    1b24:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
    1b28:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
    1b2c:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
    1b30:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
    1b34:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  va_list ap;
  int i, c;
  char *s;

  va_start(ap, fmt);
    1b38:	c7 85 20 ff ff ff 10 	movl   $0x10,-0xe0(%rbp)
    1b3f:	00 00 00 
    1b42:	c7 85 24 ff ff ff 30 	movl   $0x30,-0xdc(%rbp)
    1b49:	00 00 00 
    1b4c:	48 8d 45 10          	lea    0x10(%rbp),%rax
    1b50:	48 89 85 28 ff ff ff 	mov    %rax,-0xd8(%rbp)
    1b57:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
    1b5e:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
    1b65:	c7 85 4c ff ff ff 00 	movl   $0x0,-0xb4(%rbp)
    1b6c:	00 00 00 
    1b6f:	e9 41 03 00 00       	jmpq   1eb5 <printf+0x3d9>
    if (c != '%') {
    1b74:	83 bd 3c ff ff ff 25 	cmpl   $0x25,-0xc4(%rbp)
    1b7b:	74 24                	je     1ba1 <printf+0xc5>
      putc(fd, c);
    1b7d:	8b 85 3c ff ff ff    	mov    -0xc4(%rbp),%eax
    1b83:	0f be d0             	movsbl %al,%edx
    1b86:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1b8c:	89 d6                	mov    %edx,%esi
    1b8e:	89 c7                	mov    %eax,%edi
    1b90:	48 b8 f6 18 00 00 00 	movabs $0x18f6,%rax
    1b97:	00 00 00 
    1b9a:	ff d0                	callq  *%rax
      continue;
    1b9c:	e9 0d 03 00 00       	jmpq   1eae <printf+0x3d2>
    }
    c = fmt[++i] & 0xff;
    1ba1:	83 85 4c ff ff ff 01 	addl   $0x1,-0xb4(%rbp)
    1ba8:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
    1bae:	48 63 d0             	movslq %eax,%rdx
    1bb1:	48 8b 85 10 ff ff ff 	mov    -0xf0(%rbp),%rax
    1bb8:	48 01 d0             	add    %rdx,%rax
    1bbb:	0f b6 00             	movzbl (%rax),%eax
    1bbe:	0f be c0             	movsbl %al,%eax
    1bc1:	25 ff 00 00 00       	and    $0xff,%eax
    1bc6:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%rbp)
    if (c == 0)
    1bcc:	83 bd 3c ff ff ff 00 	cmpl   $0x0,-0xc4(%rbp)
    1bd3:	0f 84 0f 03 00 00    	je     1ee8 <printf+0x40c>
      break;
    switch(c) {
    1bd9:	83 bd 3c ff ff ff 25 	cmpl   $0x25,-0xc4(%rbp)
    1be0:	0f 84 74 02 00 00    	je     1e5a <printf+0x37e>
    1be6:	83 bd 3c ff ff ff 25 	cmpl   $0x25,-0xc4(%rbp)
    1bed:	0f 8c 82 02 00 00    	jl     1e75 <printf+0x399>
    1bf3:	83 bd 3c ff ff ff 78 	cmpl   $0x78,-0xc4(%rbp)
    1bfa:	0f 8f 75 02 00 00    	jg     1e75 <printf+0x399>
    1c00:	83 bd 3c ff ff ff 63 	cmpl   $0x63,-0xc4(%rbp)
    1c07:	0f 8c 68 02 00 00    	jl     1e75 <printf+0x399>
    1c0d:	8b 85 3c ff ff ff    	mov    -0xc4(%rbp),%eax
    1c13:	83 e8 63             	sub    $0x63,%eax
    1c16:	83 f8 15             	cmp    $0x15,%eax
    1c19:	0f 87 56 02 00 00    	ja     1e75 <printf+0x399>
    1c1f:	89 c0                	mov    %eax,%eax
    1c21:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
    1c28:	00 
    1c29:	48 b8 48 22 00 00 00 	movabs $0x2248,%rax
    1c30:	00 00 00 
    1c33:	48 01 d0             	add    %rdx,%rax
    1c36:	48 8b 00             	mov    (%rax),%rax
    1c39:	3e ff e0             	notrack jmpq *%rax
    case 'c':
      putc(fd, va_arg(ap, int));
    1c3c:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    1c42:	83 f8 2f             	cmp    $0x2f,%eax
    1c45:	77 23                	ja     1c6a <printf+0x18e>
    1c47:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    1c4e:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1c54:	89 d2                	mov    %edx,%edx
    1c56:	48 01 d0             	add    %rdx,%rax
    1c59:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1c5f:	83 c2 08             	add    $0x8,%edx
    1c62:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    1c68:	eb 12                	jmp    1c7c <printf+0x1a0>
    1c6a:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    1c71:	48 8d 50 08          	lea    0x8(%rax),%rdx
    1c75:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    1c7c:	8b 00                	mov    (%rax),%eax
    1c7e:	0f be d0             	movsbl %al,%edx
    1c81:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1c87:	89 d6                	mov    %edx,%esi
    1c89:	89 c7                	mov    %eax,%edi
    1c8b:	48 b8 f6 18 00 00 00 	movabs $0x18f6,%rax
    1c92:	00 00 00 
    1c95:	ff d0                	callq  *%rax
      break;
    1c97:	e9 12 02 00 00       	jmpq   1eae <printf+0x3d2>
    case 'd':
      print_d(fd, va_arg(ap, int));
    1c9c:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    1ca2:	83 f8 2f             	cmp    $0x2f,%eax
    1ca5:	77 23                	ja     1cca <printf+0x1ee>
    1ca7:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    1cae:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1cb4:	89 d2                	mov    %edx,%edx
    1cb6:	48 01 d0             	add    %rdx,%rax
    1cb9:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1cbf:	83 c2 08             	add    $0x8,%edx
    1cc2:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    1cc8:	eb 12                	jmp    1cdc <printf+0x200>
    1cca:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    1cd1:	48 8d 50 08          	lea    0x8(%rax),%rdx
    1cd5:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    1cdc:	8b 10                	mov    (%rax),%edx
    1cde:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1ce4:	89 d6                	mov    %edx,%esi
    1ce6:	89 c7                	mov    %eax,%edi
    1ce8:	48 b8 e4 19 00 00 00 	movabs $0x19e4,%rax
    1cef:	00 00 00 
    1cf2:	ff d0                	callq  *%rax
      break;
    1cf4:	e9 b5 01 00 00       	jmpq   1eae <printf+0x3d2>
    case 'x':
      print_x32(fd, va_arg(ap, uint));
    1cf9:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    1cff:	83 f8 2f             	cmp    $0x2f,%eax
    1d02:	77 23                	ja     1d27 <printf+0x24b>
    1d04:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    1d0b:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1d11:	89 d2                	mov    %edx,%edx
    1d13:	48 01 d0             	add    %rdx,%rax
    1d16:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1d1c:	83 c2 08             	add    $0x8,%edx
    1d1f:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    1d25:	eb 12                	jmp    1d39 <printf+0x25d>
    1d27:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    1d2e:	48 8d 50 08          	lea    0x8(%rax),%rdx
    1d32:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    1d39:	8b 10                	mov    (%rax),%edx
    1d3b:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1d41:	89 d6                	mov    %edx,%esi
    1d43:	89 c7                	mov    %eax,%edi
    1d45:	48 b8 87 19 00 00 00 	movabs $0x1987,%rax
    1d4c:	00 00 00 
    1d4f:	ff d0                	callq  *%rax
      break;
    1d51:	e9 58 01 00 00       	jmpq   1eae <printf+0x3d2>
    case 'p':
      print_x64(fd, va_arg(ap, addr_t));
    1d56:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    1d5c:	83 f8 2f             	cmp    $0x2f,%eax
    1d5f:	77 23                	ja     1d84 <printf+0x2a8>
    1d61:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    1d68:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1d6e:	89 d2                	mov    %edx,%edx
    1d70:	48 01 d0             	add    %rdx,%rax
    1d73:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1d79:	83 c2 08             	add    $0x8,%edx
    1d7c:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    1d82:	eb 12                	jmp    1d96 <printf+0x2ba>
    1d84:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    1d8b:	48 8d 50 08          	lea    0x8(%rax),%rdx
    1d8f:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    1d96:	48 8b 10             	mov    (%rax),%rdx
    1d99:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1d9f:	48 89 d6             	mov    %rdx,%rsi
    1da2:	89 c7                	mov    %eax,%edi
    1da4:	48 b8 2a 19 00 00 00 	movabs $0x192a,%rax
    1dab:	00 00 00 
    1dae:	ff d0                	callq  *%rax
      break;
    1db0:	e9 f9 00 00 00       	jmpq   1eae <printf+0x3d2>
    case 's':
      if ((s = va_arg(ap, char*)) == 0)
    1db5:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    1dbb:	83 f8 2f             	cmp    $0x2f,%eax
    1dbe:	77 23                	ja     1de3 <printf+0x307>
    1dc0:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    1dc7:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1dcd:	89 d2                	mov    %edx,%edx
    1dcf:	48 01 d0             	add    %rdx,%rax
    1dd2:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1dd8:	83 c2 08             	add    $0x8,%edx
    1ddb:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    1de1:	eb 12                	jmp    1df5 <printf+0x319>
    1de3:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    1dea:	48 8d 50 08          	lea    0x8(%rax),%rdx
    1dee:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    1df5:	48 8b 00             	mov    (%rax),%rax
    1df8:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    1dff:	48 83 bd 40 ff ff ff 	cmpq   $0x0,-0xc0(%rbp)
    1e06:	00 
    1e07:	75 41                	jne    1e4a <printf+0x36e>
        s = "(null)";
    1e09:	48 b8 40 22 00 00 00 	movabs $0x2240,%rax
    1e10:	00 00 00 
    1e13:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
      while (*s)
    1e1a:	eb 2e                	jmp    1e4a <printf+0x36e>
        putc(fd, *(s++));
    1e1c:	48 8b 85 40 ff ff ff 	mov    -0xc0(%rbp),%rax
    1e23:	48 8d 50 01          	lea    0x1(%rax),%rdx
    1e27:	48 89 95 40 ff ff ff 	mov    %rdx,-0xc0(%rbp)
    1e2e:	0f b6 00             	movzbl (%rax),%eax
    1e31:	0f be d0             	movsbl %al,%edx
    1e34:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1e3a:	89 d6                	mov    %edx,%esi
    1e3c:	89 c7                	mov    %eax,%edi
    1e3e:	48 b8 f6 18 00 00 00 	movabs $0x18f6,%rax
    1e45:	00 00 00 
    1e48:	ff d0                	callq  *%rax
      while (*s)
    1e4a:	48 8b 85 40 ff ff ff 	mov    -0xc0(%rbp),%rax
    1e51:	0f b6 00             	movzbl (%rax),%eax
    1e54:	84 c0                	test   %al,%al
    1e56:	75 c4                	jne    1e1c <printf+0x340>
      break;
    1e58:	eb 54                	jmp    1eae <printf+0x3d2>
    case '%':
      putc(fd, '%');
    1e5a:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1e60:	be 25 00 00 00       	mov    $0x25,%esi
    1e65:	89 c7                	mov    %eax,%edi
    1e67:	48 b8 f6 18 00 00 00 	movabs $0x18f6,%rax
    1e6e:	00 00 00 
    1e71:	ff d0                	callq  *%rax
      break;
    1e73:	eb 39                	jmp    1eae <printf+0x3d2>
    default:
      // Print unknown % sequence to draw attention.
      putc(fd, '%');
    1e75:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1e7b:	be 25 00 00 00       	mov    $0x25,%esi
    1e80:	89 c7                	mov    %eax,%edi
    1e82:	48 b8 f6 18 00 00 00 	movabs $0x18f6,%rax
    1e89:	00 00 00 
    1e8c:	ff d0                	callq  *%rax
      putc(fd, c);
    1e8e:	8b 85 3c ff ff ff    	mov    -0xc4(%rbp),%eax
    1e94:	0f be d0             	movsbl %al,%edx
    1e97:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1e9d:	89 d6                	mov    %edx,%esi
    1e9f:	89 c7                	mov    %eax,%edi
    1ea1:	48 b8 f6 18 00 00 00 	movabs $0x18f6,%rax
    1ea8:	00 00 00 
    1eab:	ff d0                	callq  *%rax
      break;
    1ead:	90                   	nop
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
    1eae:	83 85 4c ff ff ff 01 	addl   $0x1,-0xb4(%rbp)
    1eb5:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
    1ebb:	48 63 d0             	movslq %eax,%rdx
    1ebe:	48 8b 85 10 ff ff ff 	mov    -0xf0(%rbp),%rax
    1ec5:	48 01 d0             	add    %rdx,%rax
    1ec8:	0f b6 00             	movzbl (%rax),%eax
    1ecb:	0f be c0             	movsbl %al,%eax
    1ece:	25 ff 00 00 00       	and    $0xff,%eax
    1ed3:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%rbp)
    1ed9:	83 bd 3c ff ff ff 00 	cmpl   $0x0,-0xc4(%rbp)
    1ee0:	0f 85 8e fc ff ff    	jne    1b74 <printf+0x98>
    }
  }
}
    1ee6:	eb 01                	jmp    1ee9 <printf+0x40d>
      break;
    1ee8:	90                   	nop
}
    1ee9:	90                   	nop
    1eea:	c9                   	leaveq 
    1eeb:	c3                   	retq   

0000000000001eec <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1eec:	f3 0f 1e fa          	endbr64 
    1ef0:	55                   	push   %rbp
    1ef1:	48 89 e5             	mov    %rsp,%rbp
    1ef4:	48 83 ec 18          	sub    $0x18,%rsp
    1ef8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  Header *bp, *p;

  bp = (Header*)ap - 1;
    1efc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1f00:	48 83 e8 10          	sub    $0x10,%rax
    1f04:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1f08:	48 b8 00 26 00 00 00 	movabs $0x2600,%rax
    1f0f:	00 00 00 
    1f12:	48 8b 00             	mov    (%rax),%rax
    1f15:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    1f19:	eb 2f                	jmp    1f4a <free+0x5e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1f1b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1f1f:	48 8b 00             	mov    (%rax),%rax
    1f22:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
    1f26:	72 17                	jb     1f3f <free+0x53>
    1f28:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1f2c:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
    1f30:	77 2f                	ja     1f61 <free+0x75>
    1f32:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1f36:	48 8b 00             	mov    (%rax),%rax
    1f39:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
    1f3d:	72 22                	jb     1f61 <free+0x75>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1f3f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1f43:	48 8b 00             	mov    (%rax),%rax
    1f46:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    1f4a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1f4e:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
    1f52:	76 c7                	jbe    1f1b <free+0x2f>
    1f54:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1f58:	48 8b 00             	mov    (%rax),%rax
    1f5b:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
    1f5f:	73 ba                	jae    1f1b <free+0x2f>
      break;
  if(bp + bp->s.size == p->s.ptr){
    1f61:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1f65:	8b 40 08             	mov    0x8(%rax),%eax
    1f68:	89 c0                	mov    %eax,%eax
    1f6a:	48 c1 e0 04          	shl    $0x4,%rax
    1f6e:	48 89 c2             	mov    %rax,%rdx
    1f71:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1f75:	48 01 c2             	add    %rax,%rdx
    1f78:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1f7c:	48 8b 00             	mov    (%rax),%rax
    1f7f:	48 39 c2             	cmp    %rax,%rdx
    1f82:	75 2d                	jne    1fb1 <free+0xc5>
    bp->s.size += p->s.ptr->s.size;
    1f84:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1f88:	8b 50 08             	mov    0x8(%rax),%edx
    1f8b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1f8f:	48 8b 00             	mov    (%rax),%rax
    1f92:	8b 40 08             	mov    0x8(%rax),%eax
    1f95:	01 c2                	add    %eax,%edx
    1f97:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1f9b:	89 50 08             	mov    %edx,0x8(%rax)
    bp->s.ptr = p->s.ptr->s.ptr;
    1f9e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1fa2:	48 8b 00             	mov    (%rax),%rax
    1fa5:	48 8b 10             	mov    (%rax),%rdx
    1fa8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1fac:	48 89 10             	mov    %rdx,(%rax)
    1faf:	eb 0e                	jmp    1fbf <free+0xd3>
  } else
    bp->s.ptr = p->s.ptr;
    1fb1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1fb5:	48 8b 10             	mov    (%rax),%rdx
    1fb8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1fbc:	48 89 10             	mov    %rdx,(%rax)
  if(p + p->s.size == bp){
    1fbf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1fc3:	8b 40 08             	mov    0x8(%rax),%eax
    1fc6:	89 c0                	mov    %eax,%eax
    1fc8:	48 c1 e0 04          	shl    $0x4,%rax
    1fcc:	48 89 c2             	mov    %rax,%rdx
    1fcf:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1fd3:	48 01 d0             	add    %rdx,%rax
    1fd6:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
    1fda:	75 27                	jne    2003 <free+0x117>
    p->s.size += bp->s.size;
    1fdc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1fe0:	8b 50 08             	mov    0x8(%rax),%edx
    1fe3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1fe7:	8b 40 08             	mov    0x8(%rax),%eax
    1fea:	01 c2                	add    %eax,%edx
    1fec:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1ff0:	89 50 08             	mov    %edx,0x8(%rax)
    p->s.ptr = bp->s.ptr;
    1ff3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1ff7:	48 8b 10             	mov    (%rax),%rdx
    1ffa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1ffe:	48 89 10             	mov    %rdx,(%rax)
    2001:	eb 0b                	jmp    200e <free+0x122>
  } else
    p->s.ptr = bp;
    2003:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    2007:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
    200b:	48 89 10             	mov    %rdx,(%rax)
  freep = p;
    200e:	48 ba 00 26 00 00 00 	movabs $0x2600,%rdx
    2015:	00 00 00 
    2018:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    201c:	48 89 02             	mov    %rax,(%rdx)
}
    201f:	90                   	nop
    2020:	c9                   	leaveq 
    2021:	c3                   	retq   

0000000000002022 <morecore>:

static Header*
morecore(uint nu)
{
    2022:	f3 0f 1e fa          	endbr64 
    2026:	55                   	push   %rbp
    2027:	48 89 e5             	mov    %rsp,%rbp
    202a:	48 83 ec 20          	sub    $0x20,%rsp
    202e:	89 7d ec             	mov    %edi,-0x14(%rbp)
  char *p;
  Header *hp;

  if(nu < 4096)
    2031:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%rbp)
    2038:	77 07                	ja     2041 <morecore+0x1f>
    nu = 4096;
    203a:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%rbp)
  p = sbrk(nu * sizeof(Header));
    2041:	8b 45 ec             	mov    -0x14(%rbp),%eax
    2044:	48 c1 e0 04          	shl    $0x4,%rax
    2048:	48 89 c7             	mov    %rax,%rdi
    204b:	48 b8 c2 18 00 00 00 	movabs $0x18c2,%rax
    2052:	00 00 00 
    2055:	ff d0                	callq  *%rax
    2057:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  if(p == (char*)-1)
    205b:	48 83 7d f8 ff       	cmpq   $0xffffffffffffffff,-0x8(%rbp)
    2060:	75 07                	jne    2069 <morecore+0x47>
    return 0;
    2062:	b8 00 00 00 00       	mov    $0x0,%eax
    2067:	eb 36                	jmp    209f <morecore+0x7d>
  hp = (Header*)p;
    2069:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    206d:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  hp->s.size = nu;
    2071:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    2075:	8b 55 ec             	mov    -0x14(%rbp),%edx
    2078:	89 50 08             	mov    %edx,0x8(%rax)
  free((void*)(hp + 1));
    207b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    207f:	48 83 c0 10          	add    $0x10,%rax
    2083:	48 89 c7             	mov    %rax,%rdi
    2086:	48 b8 ec 1e 00 00 00 	movabs $0x1eec,%rax
    208d:	00 00 00 
    2090:	ff d0                	callq  *%rax
  return freep;
    2092:	48 b8 00 26 00 00 00 	movabs $0x2600,%rax
    2099:	00 00 00 
    209c:	48 8b 00             	mov    (%rax),%rax
}
    209f:	c9                   	leaveq 
    20a0:	c3                   	retq   

00000000000020a1 <malloc>:

void*
malloc(uint nbytes)
{
    20a1:	f3 0f 1e fa          	endbr64 
    20a5:	55                   	push   %rbp
    20a6:	48 89 e5             	mov    %rsp,%rbp
    20a9:	48 83 ec 30          	sub    $0x30,%rsp
    20ad:	89 7d dc             	mov    %edi,-0x24(%rbp)
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    20b0:	8b 45 dc             	mov    -0x24(%rbp),%eax
    20b3:	48 83 c0 0f          	add    $0xf,%rax
    20b7:	48 c1 e8 04          	shr    $0x4,%rax
    20bb:	83 c0 01             	add    $0x1,%eax
    20be:	89 45 ec             	mov    %eax,-0x14(%rbp)
  if((prevp = freep) == 0){
    20c1:	48 b8 00 26 00 00 00 	movabs $0x2600,%rax
    20c8:	00 00 00 
    20cb:	48 8b 00             	mov    (%rax),%rax
    20ce:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    20d2:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
    20d7:	75 4a                	jne    2123 <malloc+0x82>
    base.s.ptr = freep = prevp = &base;
    20d9:	48 b8 f0 25 00 00 00 	movabs $0x25f0,%rax
    20e0:	00 00 00 
    20e3:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    20e7:	48 ba 00 26 00 00 00 	movabs $0x2600,%rdx
    20ee:	00 00 00 
    20f1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    20f5:	48 89 02             	mov    %rax,(%rdx)
    20f8:	48 b8 00 26 00 00 00 	movabs $0x2600,%rax
    20ff:	00 00 00 
    2102:	48 8b 00             	mov    (%rax),%rax
    2105:	48 ba f0 25 00 00 00 	movabs $0x25f0,%rdx
    210c:	00 00 00 
    210f:	48 89 02             	mov    %rax,(%rdx)
    base.s.size = 0;
    2112:	48 b8 f0 25 00 00 00 	movabs $0x25f0,%rax
    2119:	00 00 00 
    211c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    2123:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    2127:	48 8b 00             	mov    (%rax),%rax
    212a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    if(p->s.size >= nunits){
    212e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    2132:	8b 40 08             	mov    0x8(%rax),%eax
    2135:	39 45 ec             	cmp    %eax,-0x14(%rbp)
    2138:	77 65                	ja     219f <malloc+0xfe>
      if(p->s.size == nunits)
    213a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    213e:	8b 40 08             	mov    0x8(%rax),%eax
    2141:	39 45 ec             	cmp    %eax,-0x14(%rbp)
    2144:	75 10                	jne    2156 <malloc+0xb5>
        prevp->s.ptr = p->s.ptr;
    2146:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    214a:	48 8b 10             	mov    (%rax),%rdx
    214d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    2151:	48 89 10             	mov    %rdx,(%rax)
    2154:	eb 2e                	jmp    2184 <malloc+0xe3>
      else {
        p->s.size -= nunits;
    2156:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    215a:	8b 40 08             	mov    0x8(%rax),%eax
    215d:	2b 45 ec             	sub    -0x14(%rbp),%eax
    2160:	89 c2                	mov    %eax,%edx
    2162:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    2166:	89 50 08             	mov    %edx,0x8(%rax)
        p += p->s.size;
    2169:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    216d:	8b 40 08             	mov    0x8(%rax),%eax
    2170:	89 c0                	mov    %eax,%eax
    2172:	48 c1 e0 04          	shl    $0x4,%rax
    2176:	48 01 45 f8          	add    %rax,-0x8(%rbp)
        p->s.size = nunits;
    217a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    217e:	8b 55 ec             	mov    -0x14(%rbp),%edx
    2181:	89 50 08             	mov    %edx,0x8(%rax)
      }
      freep = prevp;
    2184:	48 ba 00 26 00 00 00 	movabs $0x2600,%rdx
    218b:	00 00 00 
    218e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    2192:	48 89 02             	mov    %rax,(%rdx)
      return (void*)(p + 1);
    2195:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    2199:	48 83 c0 10          	add    $0x10,%rax
    219d:	eb 4e                	jmp    21ed <malloc+0x14c>
    }
    if(p == freep)
    219f:	48 b8 00 26 00 00 00 	movabs $0x2600,%rax
    21a6:	00 00 00 
    21a9:	48 8b 00             	mov    (%rax),%rax
    21ac:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
    21b0:	75 23                	jne    21d5 <malloc+0x134>
      if((p = morecore(nunits)) == 0)
    21b2:	8b 45 ec             	mov    -0x14(%rbp),%eax
    21b5:	89 c7                	mov    %eax,%edi
    21b7:	48 b8 22 20 00 00 00 	movabs $0x2022,%rax
    21be:	00 00 00 
    21c1:	ff d0                	callq  *%rax
    21c3:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    21c7:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
    21cc:	75 07                	jne    21d5 <malloc+0x134>
        return 0;
    21ce:	b8 00 00 00 00       	mov    $0x0,%eax
    21d3:	eb 18                	jmp    21ed <malloc+0x14c>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    21d5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    21d9:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    21dd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    21e1:	48 8b 00             	mov    (%rax),%rax
    21e4:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    if(p->s.size >= nunits){
    21e8:	e9 41 ff ff ff       	jmpq   212e <malloc+0x8d>
  }
}
    21ed:	c9                   	leaveq 
    21ee:	c3                   	retq   

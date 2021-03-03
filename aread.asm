
_aread:     file format elf64-x86-64


Disassembly of section .text:

0000000000001000 <print_16B>:
#include "user.h"
#include "fs.h"

  static void
print_16B(char * buf)
{
    1000:	f3 0f 1e fa          	endbr64 
    1004:	55                   	push   %rbp
    1005:	48 89 e5             	mov    %rsp,%rbp
    1008:	48 83 ec 20          	sub    $0x20,%rsp
    100c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  for (int i = 0; i < 16; i++) {
    1010:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    1017:	eb 39                	jmp    1052 <print_16B+0x52>
    printf(1, " %d", buf[i]);
    1019:	8b 45 fc             	mov    -0x4(%rbp),%eax
    101c:	48 63 d0             	movslq %eax,%rdx
    101f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1023:	48 01 d0             	add    %rdx,%rax
    1026:	0f b6 00             	movzbl (%rax),%eax
    1029:	0f be c0             	movsbl %al,%eax
    102c:	89 c2                	mov    %eax,%edx
    102e:	48 be f8 24 00 00 00 	movabs $0x24f8,%rsi
    1035:	00 00 00 
    1038:	bf 01 00 00 00       	mov    $0x1,%edi
    103d:	b8 00 00 00 00       	mov    $0x0,%eax
    1042:	48 b9 e4 1d 00 00 00 	movabs $0x1de4,%rcx
    1049:	00 00 00 
    104c:	ff d1                	callq  *%rcx
  for (int i = 0; i < 16; i++) {
    104e:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    1052:	83 7d fc 0f          	cmpl   $0xf,-0x4(%rbp)
    1056:	7e c1                	jle    1019 <print_16B+0x19>
  }
}
    1058:	90                   	nop
    1059:	90                   	nop
    105a:	c9                   	leaveq 
    105b:	c3                   	retq   

000000000000105c <memmatch>:

  static int
memmatch(char * p1, char * p2, int size)
{
    105c:	f3 0f 1e fa          	endbr64 
    1060:	55                   	push   %rbp
    1061:	48 89 e5             	mov    %rsp,%rbp
    1064:	48 83 ec 28          	sub    $0x28,%rsp
    1068:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    106c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
    1070:	89 55 dc             	mov    %edx,-0x24(%rbp)
  for (int i = 0; i < size; i++) {
    1073:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    107a:	eb 2d                	jmp    10a9 <memmatch+0x4d>
    if (p1[i] != p2[i]) {
    107c:	8b 45 fc             	mov    -0x4(%rbp),%eax
    107f:	48 63 d0             	movslq %eax,%rdx
    1082:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1086:	48 01 d0             	add    %rdx,%rax
    1089:	0f b6 10             	movzbl (%rax),%edx
    108c:	8b 45 fc             	mov    -0x4(%rbp),%eax
    108f:	48 63 c8             	movslq %eax,%rcx
    1092:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    1096:	48 01 c8             	add    %rcx,%rax
    1099:	0f b6 00             	movzbl (%rax),%eax
    109c:	38 c2                	cmp    %al,%dl
    109e:	74 05                	je     10a5 <memmatch+0x49>
      return i;
    10a0:	8b 45 fc             	mov    -0x4(%rbp),%eax
    10a3:	eb 0f                	jmp    10b4 <memmatch+0x58>
  for (int i = 0; i < size; i++) {
    10a5:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    10a9:	8b 45 fc             	mov    -0x4(%rbp),%eax
    10ac:	3b 45 dc             	cmp    -0x24(%rbp),%eax
    10af:	7c cb                	jl     107c <memmatch+0x20>
    }
  }
  return size;
    10b1:	8b 45 dc             	mov    -0x24(%rbp),%eax
}
    10b4:	c9                   	leaveq 
    10b5:	c3                   	retq   

00000000000010b6 <main>:

int main(int argc, char ** argv)
{
    10b6:	f3 0f 1e fa          	endbr64 
    10ba:	55                   	push   %rbp
    10bb:	48 89 e5             	mov    %rsp,%rbp
    10be:	48 81 ec 00 01 00 00 	sub    $0x100,%rsp
    10c5:	89 bd 0c ff ff ff    	mov    %edi,-0xf4(%rbp)
    10cb:	48 89 b5 00 ff ff ff 	mov    %rsi,-0x100(%rbp)
  char * files[2] = {"ls", "README"};
    10d2:	48 b8 fc 24 00 00 00 	movabs $0x24fc,%rax
    10d9:	00 00 00 
    10dc:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
    10e0:	48 b8 ff 24 00 00 00 	movabs $0x24ff,%rax
    10e7:	00 00 00 
    10ea:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
  int fds[2];
  for (int i = 0; i < 2; i++) {
    10ee:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    10f5:	eb 72                	jmp    1169 <main+0xb3>
    fds[i] = open(files[i], 0);
    10f7:	8b 45 fc             	mov    -0x4(%rbp),%eax
    10fa:	48 98                	cltq   
    10fc:	48 8b 44 c5 c0       	mov    -0x40(%rbp,%rax,8),%rax
    1101:	be 00 00 00 00       	mov    $0x0,%esi
    1106:	48 89 c7             	mov    %rax,%rdi
    1109:	48 b8 55 1b 00 00 00 	movabs $0x1b55,%rax
    1110:	00 00 00 
    1113:	ff d0                	callq  *%rax
    1115:	8b 55 fc             	mov    -0x4(%rbp),%edx
    1118:	48 63 d2             	movslq %edx,%rdx
    111b:	89 44 95 b8          	mov    %eax,-0x48(%rbp,%rdx,4)
    if (fds[i] < 0) {
    111f:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1122:	48 98                	cltq   
    1124:	8b 44 85 b8          	mov    -0x48(%rbp,%rax,4),%eax
    1128:	85 c0                	test   %eax,%eax
    112a:	79 39                	jns    1165 <main+0xaf>
      printf(1, "open %s failed\n", files[i]);
    112c:	8b 45 fc             	mov    -0x4(%rbp),%eax
    112f:	48 98                	cltq   
    1131:	48 8b 44 c5 c0       	mov    -0x40(%rbp,%rax,8),%rax
    1136:	48 89 c2             	mov    %rax,%rdx
    1139:	48 be 06 25 00 00 00 	movabs $0x2506,%rsi
    1140:	00 00 00 
    1143:	bf 01 00 00 00       	mov    $0x1,%edi
    1148:	b8 00 00 00 00       	mov    $0x0,%eax
    114d:	48 b9 e4 1d 00 00 00 	movabs $0x1de4,%rcx
    1154:	00 00 00 
    1157:	ff d1                	callq  *%rcx
      exit();
    1159:	48 b8 ed 1a 00 00 00 	movabs $0x1aed,%rax
    1160:	00 00 00 
    1163:	ff d0                	callq  *%rax
  for (int i = 0; i < 2; i++) {
    1165:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    1169:	83 7d fc 01          	cmpl   $0x1,-0x4(%rbp)
    116d:	7e 88                	jle    10f7 <main+0x41>
    }
  }
  // allocate four buffers, two for each file
  char buf1[2][16] = {};
    116f:	48 c7 45 90 00 00 00 	movq   $0x0,-0x70(%rbp)
    1176:	00 
    1177:	48 c7 45 98 00 00 00 	movq   $0x0,-0x68(%rbp)
    117e:	00 
    117f:	48 c7 45 a0 00 00 00 	movq   $0x0,-0x60(%rbp)
    1186:	00 
    1187:	48 c7 45 a8 00 00 00 	movq   $0x0,-0x58(%rbp)
    118e:	00 
  for (int i = 0; i < 2; i++) {
    118f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
    1196:	eb 35                	jmp    11cd <main+0x117>
    read(fds[i], buf1[i], 16);
    1198:	48 8d 45 90          	lea    -0x70(%rbp),%rax
    119c:	8b 55 f8             	mov    -0x8(%rbp),%edx
    119f:	48 63 d2             	movslq %edx,%rdx
    11a2:	48 c1 e2 04          	shl    $0x4,%rdx
    11a6:	48 8d 0c 10          	lea    (%rax,%rdx,1),%rcx
    11aa:	8b 45 f8             	mov    -0x8(%rbp),%eax
    11ad:	48 98                	cltq   
    11af:	8b 44 85 b8          	mov    -0x48(%rbp,%rax,4),%eax
    11b3:	ba 10 00 00 00       	mov    $0x10,%edx
    11b8:	48 89 ce             	mov    %rcx,%rsi
    11bb:	89 c7                	mov    %eax,%edi
    11bd:	48 b8 14 1b 00 00 00 	movabs $0x1b14,%rax
    11c4:	00 00 00 
    11c7:	ff d0                	callq  *%rax
  for (int i = 0; i < 2; i++) {
    11c9:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
    11cd:	83 7d f8 01          	cmpl   $0x1,-0x8(%rbp)
    11d1:	7e c5                	jle    1198 <main+0xe2>
  }

  char buf2[2][16] = {};
    11d3:	48 c7 85 70 ff ff ff 	movq   $0x0,-0x90(%rbp)
    11da:	00 00 00 00 
    11de:	48 c7 85 78 ff ff ff 	movq   $0x0,-0x88(%rbp)
    11e5:	00 00 00 00 
    11e9:	48 c7 45 80 00 00 00 	movq   $0x0,-0x80(%rbp)
    11f0:	00 
    11f1:	48 c7 45 88 00 00 00 	movq   $0x0,-0x78(%rbp)
    11f8:	00 
  volatile int status[2][2];
  int expect[2][2]; // aread will tell us how many bytes (>= 0) to expect

  // issue requests
  for (int i = 0; i < 2; i++) {
    11f9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
    1200:	e9 3a 01 00 00       	jmpq   133f <main+0x289>
    expect[i][0] = aread(fds[i], buf2[i], 0, 8, &status[i][0]);
    1205:	48 8d 85 60 ff ff ff 	lea    -0xa0(%rbp),%rax
    120c:	8b 55 f4             	mov    -0xc(%rbp),%edx
    120f:	48 63 d2             	movslq %edx,%rdx
    1212:	48 c1 e2 03          	shl    $0x3,%rdx
    1216:	48 8d 0c 10          	lea    (%rax,%rdx,1),%rcx
    121a:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
    1221:	8b 55 f4             	mov    -0xc(%rbp),%edx
    1224:	48 63 d2             	movslq %edx,%rdx
    1227:	48 c1 e2 04          	shl    $0x4,%rdx
    122b:	48 8d 34 10          	lea    (%rax,%rdx,1),%rsi
    122f:	8b 45 f4             	mov    -0xc(%rbp),%eax
    1232:	48 98                	cltq   
    1234:	8b 44 85 b8          	mov    -0x48(%rbp,%rax,4),%eax
    1238:	49 89 c8             	mov    %rcx,%r8
    123b:	b9 08 00 00 00       	mov    $0x8,%ecx
    1240:	ba 00 00 00 00       	mov    $0x0,%edx
    1245:	89 c7                	mov    %eax,%edi
    1247:	48 b8 f1 1b 00 00 00 	movabs $0x1bf1,%rax
    124e:	00 00 00 
    1251:	ff d0                	callq  *%rax
    1253:	8b 55 f4             	mov    -0xc(%rbp),%edx
    1256:	48 63 d2             	movslq %edx,%rdx
    1259:	89 84 d5 50 ff ff ff 	mov    %eax,-0xb0(%rbp,%rdx,8)
    expect[i][1] = aread(fds[i], buf2[i]+8, 8, 8, &status[i][1]);
    1260:	48 8d 85 60 ff ff ff 	lea    -0xa0(%rbp),%rax
    1267:	8b 55 f4             	mov    -0xc(%rbp),%edx
    126a:	48 63 d2             	movslq %edx,%rdx
    126d:	48 c1 e2 03          	shl    $0x3,%rdx
    1271:	48 83 c2 04          	add    $0x4,%rdx
    1275:	48 8d 0c 10          	lea    (%rax,%rdx,1),%rcx
    1279:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
    1280:	8b 55 f4             	mov    -0xc(%rbp),%edx
    1283:	48 63 d2             	movslq %edx,%rdx
    1286:	48 c1 e2 04          	shl    $0x4,%rdx
    128a:	48 01 d0             	add    %rdx,%rax
    128d:	48 8d 70 08          	lea    0x8(%rax),%rsi
    1291:	8b 45 f4             	mov    -0xc(%rbp),%eax
    1294:	48 98                	cltq   
    1296:	8b 44 85 b8          	mov    -0x48(%rbp,%rax,4),%eax
    129a:	49 89 c8             	mov    %rcx,%r8
    129d:	b9 08 00 00 00       	mov    $0x8,%ecx
    12a2:	ba 08 00 00 00       	mov    $0x8,%edx
    12a7:	89 c7                	mov    %eax,%edi
    12a9:	48 b8 f1 1b 00 00 00 	movabs $0x1bf1,%rax
    12b0:	00 00 00 
    12b3:	ff d0                	callq  *%rax
    12b5:	8b 55 f4             	mov    -0xc(%rbp),%edx
    12b8:	48 63 d2             	movslq %edx,%rdx
    12bb:	89 84 d5 54 ff ff ff 	mov    %eax,-0xac(%rbp,%rdx,8)
    if (expect[i][0] != 8 || expect[i][1] != 8) {
    12c2:	8b 45 f4             	mov    -0xc(%rbp),%eax
    12c5:	48 98                	cltq   
    12c7:	8b 84 c5 50 ff ff ff 	mov    -0xb0(%rbp,%rax,8),%eax
    12ce:	83 f8 08             	cmp    $0x8,%eax
    12d1:	75 11                	jne    12e4 <main+0x22e>
    12d3:	8b 45 f4             	mov    -0xc(%rbp),%eax
    12d6:	48 98                	cltq   
    12d8:	8b 84 c5 54 ff ff ff 	mov    -0xac(%rbp,%rax,8),%eax
    12df:	83 f8 08             	cmp    $0x8,%eax
    12e2:	74 57                	je     133b <main+0x285>
      printf(1, "error: aread on file %s returned %d %d\n", files[i], expect[i][0], expect[i][1]);
    12e4:	8b 45 f4             	mov    -0xc(%rbp),%eax
    12e7:	48 98                	cltq   
    12e9:	8b 8c c5 54 ff ff ff 	mov    -0xac(%rbp,%rax,8),%ecx
    12f0:	8b 45 f4             	mov    -0xc(%rbp),%eax
    12f3:	48 98                	cltq   
    12f5:	8b 94 c5 50 ff ff ff 	mov    -0xb0(%rbp,%rax,8),%edx
    12fc:	8b 45 f4             	mov    -0xc(%rbp),%eax
    12ff:	48 98                	cltq   
    1301:	48 8b 44 c5 c0       	mov    -0x40(%rbp,%rax,8),%rax
    1306:	41 89 c8             	mov    %ecx,%r8d
    1309:	89 d1                	mov    %edx,%ecx
    130b:	48 89 c2             	mov    %rax,%rdx
    130e:	48 be 18 25 00 00 00 	movabs $0x2518,%rsi
    1315:	00 00 00 
    1318:	bf 01 00 00 00       	mov    $0x1,%edi
    131d:	b8 00 00 00 00       	mov    $0x0,%eax
    1322:	49 b9 e4 1d 00 00 00 	movabs $0x1de4,%r9
    1329:	00 00 00 
    132c:	41 ff d1             	callq  *%r9
      exit(); // this can actually cause kernel panic!! How to fix it?
    132f:	48 b8 ed 1a 00 00 00 	movabs $0x1aed,%rax
    1336:	00 00 00 
    1339:	ff d0                	callq  *%rax
  for (int i = 0; i < 2; i++) {
    133b:	83 45 f4 01          	addl   $0x1,-0xc(%rbp)
    133f:	83 7d f4 01          	cmpl   $0x1,-0xc(%rbp)
    1343:	0f 8e bc fe ff ff    	jle    1205 <main+0x14f>
    }
  }
  // wait for completions
  int wt[2][2];
  while (status[0][0] != expect[0][0])
    1349:	eb 0f                	jmp    135a <main+0x2a4>
    //printf(1,"%d",wt[0][0]);
    wt[0][0]++;
    134b:	8b 85 40 ff ff ff    	mov    -0xc0(%rbp),%eax
    1351:	83 c0 01             	add    $0x1,%eax
    1354:	89 85 40 ff ff ff    	mov    %eax,-0xc0(%rbp)
  while (status[0][0] != expect[0][0])
    135a:	8b 95 60 ff ff ff    	mov    -0xa0(%rbp),%edx
    1360:	8b 85 50 ff ff ff    	mov    -0xb0(%rbp),%eax
    1366:	39 c2                	cmp    %eax,%edx
    1368:	75 e1                	jne    134b <main+0x295>
  while (status[0][1] != expect[0][1])
    136a:	eb 0f                	jmp    137b <main+0x2c5>
    wt[0][1]++;
    136c:	8b 85 44 ff ff ff    	mov    -0xbc(%rbp),%eax
    1372:	83 c0 01             	add    $0x1,%eax
    1375:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%rbp)
  while (status[0][1] != expect[0][1])
    137b:	8b 95 64 ff ff ff    	mov    -0x9c(%rbp),%edx
    1381:	8b 85 54 ff ff ff    	mov    -0xac(%rbp),%eax
    1387:	39 c2                	cmp    %eax,%edx
    1389:	75 e1                	jne    136c <main+0x2b6>
  while (status[1][0] != expect[1][0])
    138b:	eb 0f                	jmp    139c <main+0x2e6>
    wt[1][0]++;
    138d:	8b 85 48 ff ff ff    	mov    -0xb8(%rbp),%eax
    1393:	83 c0 01             	add    $0x1,%eax
    1396:	89 85 48 ff ff ff    	mov    %eax,-0xb8(%rbp)
  while (status[1][0] != expect[1][0])
    139c:	8b 95 68 ff ff ff    	mov    -0x98(%rbp),%edx
    13a2:	8b 85 58 ff ff ff    	mov    -0xa8(%rbp),%eax
    13a8:	39 c2                	cmp    %eax,%edx
    13aa:	75 e1                	jne    138d <main+0x2d7>
  while (status[1][1] != expect[1][1])
    13ac:	eb 0f                	jmp    13bd <main+0x307>
    wt[1][1]++;
    13ae:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
    13b4:	83 c0 01             	add    $0x1,%eax
    13b7:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%rbp)
  while (status[1][1] != expect[1][1])
    13bd:	8b 95 6c ff ff ff    	mov    -0x94(%rbp),%edx
    13c3:	8b 85 5c ff ff ff    	mov    -0xa4(%rbp),%eax
    13c9:	39 c2                	cmp    %eax,%edx
    13cb:	75 e1                	jne    13ae <main+0x2f8>

  // print results
  printf(1, "wait times: %d %d %d %d\n", wt[0][0], wt[0][1], wt[1][0], wt[1][1]);
    13cd:	8b b5 4c ff ff ff    	mov    -0xb4(%rbp),%esi
    13d3:	8b 8d 48 ff ff ff    	mov    -0xb8(%rbp),%ecx
    13d9:	8b 95 44 ff ff ff    	mov    -0xbc(%rbp),%edx
    13df:	8b 85 40 ff ff ff    	mov    -0xc0(%rbp),%eax
    13e5:	41 89 f1             	mov    %esi,%r9d
    13e8:	41 89 c8             	mov    %ecx,%r8d
    13eb:	89 d1                	mov    %edx,%ecx
    13ed:	89 c2                	mov    %eax,%edx
    13ef:	48 be 40 25 00 00 00 	movabs $0x2540,%rsi
    13f6:	00 00 00 
    13f9:	bf 01 00 00 00       	mov    $0x1,%edi
    13fe:	b8 00 00 00 00       	mov    $0x0,%eax
    1403:	49 ba e4 1d 00 00 00 	movabs $0x1de4,%r10
    140a:	00 00 00 
    140d:	41 ff d2             	callq  *%r10
  printf(1, "file 1:  read: "); print_16B(buf1[0]); printf(1, "\n");
    1410:	48 be 59 25 00 00 00 	movabs $0x2559,%rsi
    1417:	00 00 00 
    141a:	bf 01 00 00 00       	mov    $0x1,%edi
    141f:	b8 00 00 00 00       	mov    $0x0,%eax
    1424:	48 ba e4 1d 00 00 00 	movabs $0x1de4,%rdx
    142b:	00 00 00 
    142e:	ff d2                	callq  *%rdx
    1430:	48 8d 45 90          	lea    -0x70(%rbp),%rax
    1434:	48 89 c7             	mov    %rax,%rdi
    1437:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    143e:	00 00 00 
    1441:	ff d0                	callq  *%rax
    1443:	48 be 69 25 00 00 00 	movabs $0x2569,%rsi
    144a:	00 00 00 
    144d:	bf 01 00 00 00       	mov    $0x1,%edi
    1452:	b8 00 00 00 00       	mov    $0x0,%eax
    1457:	48 ba e4 1d 00 00 00 	movabs $0x1de4,%rdx
    145e:	00 00 00 
    1461:	ff d2                	callq  *%rdx
  printf(1, "file 1: aread: "); print_16B(buf2[0]); printf(1, "\n");
    1463:	48 be 6b 25 00 00 00 	movabs $0x256b,%rsi
    146a:	00 00 00 
    146d:	bf 01 00 00 00       	mov    $0x1,%edi
    1472:	b8 00 00 00 00       	mov    $0x0,%eax
    1477:	48 ba e4 1d 00 00 00 	movabs $0x1de4,%rdx
    147e:	00 00 00 
    1481:	ff d2                	callq  *%rdx
    1483:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
    148a:	48 89 c7             	mov    %rax,%rdi
    148d:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    1494:	00 00 00 
    1497:	ff d0                	callq  *%rax
    1499:	48 be 69 25 00 00 00 	movabs $0x2569,%rsi
    14a0:	00 00 00 
    14a3:	bf 01 00 00 00       	mov    $0x1,%edi
    14a8:	b8 00 00 00 00       	mov    $0x0,%eax
    14ad:	48 ba e4 1d 00 00 00 	movabs $0x1de4,%rdx
    14b4:	00 00 00 
    14b7:	ff d2                	callq  *%rdx
  printf(1, "file 2:  read: "); print_16B(buf1[1]); printf(1, "\n");
    14b9:	48 be 7b 25 00 00 00 	movabs $0x257b,%rsi
    14c0:	00 00 00 
    14c3:	bf 01 00 00 00       	mov    $0x1,%edi
    14c8:	b8 00 00 00 00       	mov    $0x0,%eax
    14cd:	48 ba e4 1d 00 00 00 	movabs $0x1de4,%rdx
    14d4:	00 00 00 
    14d7:	ff d2                	callq  *%rdx
    14d9:	48 8d 45 90          	lea    -0x70(%rbp),%rax
    14dd:	48 83 c0 10          	add    $0x10,%rax
    14e1:	48 89 c7             	mov    %rax,%rdi
    14e4:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    14eb:	00 00 00 
    14ee:	ff d0                	callq  *%rax
    14f0:	48 be 69 25 00 00 00 	movabs $0x2569,%rsi
    14f7:	00 00 00 
    14fa:	bf 01 00 00 00       	mov    $0x1,%edi
    14ff:	b8 00 00 00 00       	mov    $0x0,%eax
    1504:	48 ba e4 1d 00 00 00 	movabs $0x1de4,%rdx
    150b:	00 00 00 
    150e:	ff d2                	callq  *%rdx
  printf(1, "file 2: aread: "); print_16B(buf2[1]); printf(1, "\n");
    1510:	48 be 8b 25 00 00 00 	movabs $0x258b,%rsi
    1517:	00 00 00 
    151a:	bf 01 00 00 00       	mov    $0x1,%edi
    151f:	b8 00 00 00 00       	mov    $0x0,%eax
    1524:	48 ba e4 1d 00 00 00 	movabs $0x1de4,%rdx
    152b:	00 00 00 
    152e:	ff d2                	callq  *%rdx
    1530:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
    1537:	48 83 c0 10          	add    $0x10,%rax
    153b:	48 89 c7             	mov    %rax,%rdi
    153e:	48 b8 00 10 00 00 00 	movabs $0x1000,%rax
    1545:	00 00 00 
    1548:	ff d0                	callq  *%rax
    154a:	48 be 69 25 00 00 00 	movabs $0x2569,%rsi
    1551:	00 00 00 
    1554:	bf 01 00 00 00       	mov    $0x1,%edi
    1559:	b8 00 00 00 00       	mov    $0x0,%eax
    155e:	48 ba e4 1d 00 00 00 	movabs $0x1de4,%rdx
    1565:	00 00 00 
    1568:	ff d2                	callq  *%rdx
  close(fds[0]);
    156a:	8b 45 b8             	mov    -0x48(%rbp),%eax
    156d:	89 c7                	mov    %eax,%edi
    156f:	48 b8 2e 1b 00 00 00 	movabs $0x1b2e,%rax
    1576:	00 00 00 
    1579:	ff d0                	callq  *%rax
  close(fds[1]);
    157b:	8b 45 bc             	mov    -0x44(%rbp),%eax
    157e:	89 c7                	mov    %eax,%edi
    1580:	48 b8 2e 1b 00 00 00 	movabs $0x1b2e,%rax
    1587:	00 00 00 
    158a:	ff d0                	callq  *%rax

  // test with a very large file
  int fd = open("usertests", 0);
    158c:	be 00 00 00 00       	mov    $0x0,%esi
    1591:	48 bf 9b 25 00 00 00 	movabs $0x259b,%rdi
    1598:	00 00 00 
    159b:	48 b8 55 1b 00 00 00 	movabs $0x1b55,%rax
    15a2:	00 00 00 
    15a5:	ff d0                	callq  *%rax
    15a7:	89 45 ec             	mov    %eax,-0x14(%rbp)
  if (fd < 0) {
    15aa:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
    15ae:	79 2c                	jns    15dc <main+0x526>
    printf(1, "open usertests failed\n");
    15b0:	48 be a5 25 00 00 00 	movabs $0x25a5,%rsi
    15b7:	00 00 00 
    15ba:	bf 01 00 00 00       	mov    $0x1,%edi
    15bf:	b8 00 00 00 00       	mov    $0x0,%eax
    15c4:	48 ba e4 1d 00 00 00 	movabs $0x1de4,%rdx
    15cb:	00 00 00 
    15ce:	ff d2                	callq  *%rdx
    exit();
    15d0:	48 b8 ed 1a 00 00 00 	movabs $0x1aed,%rax
    15d7:	00 00 00 
    15da:	ff d0                	callq  *%rax
  }
  struct stat st;
  fstat(fd, &st);
    15dc:	48 8d 95 20 ff ff ff 	lea    -0xe0(%rbp),%rdx
    15e3:	8b 45 ec             	mov    -0x14(%rbp),%eax
    15e6:	48 89 d6             	mov    %rdx,%rsi
    15e9:	89 c7                	mov    %eax,%edi
    15eb:	48 b8 7c 1b 00 00 00 	movabs $0x1b7c,%rax
    15f2:	00 00 00 
    15f5:	ff d0                	callq  *%rax
  const uint size = st.size;
    15f7:	8b 85 30 ff ff ff    	mov    -0xd0(%rbp),%eax
    15fd:	89 45 e8             	mov    %eax,-0x18(%rbp)
  char * large1 = malloc(size);
    1600:	8b 45 e8             	mov    -0x18(%rbp),%eax
    1603:	89 c7                	mov    %eax,%edi
    1605:	48 b8 a9 23 00 00 00 	movabs $0x23a9,%rax
    160c:	00 00 00 
    160f:	ff d0                	callq  *%rax
    1611:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  char * large2 = malloc(size);
    1615:	8b 45 e8             	mov    -0x18(%rbp),%eax
    1618:	89 c7                	mov    %eax,%edi
    161a:	48 b8 a9 23 00 00 00 	movabs $0x23a9,%rax
    1621:	00 00 00 
    1624:	ff d0                	callq  *%rax
    1626:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  memset(large1, 0, size);
    162a:	8b 55 e8             	mov    -0x18(%rbp),%edx
    162d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    1631:	be 00 00 00 00       	mov    $0x0,%esi
    1636:	48 89 c7             	mov    %rax,%rdi
    1639:	48 b8 b8 18 00 00 00 	movabs $0x18b8,%rax
    1640:	00 00 00 
    1643:	ff d0                	callq  *%rax
  memset(large2, 1, size);
    1645:	8b 55 e8             	mov    -0x18(%rbp),%edx
    1648:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
    164c:	be 01 00 00 00       	mov    $0x1,%esi
    1651:	48 89 c7             	mov    %rax,%rdi
    1654:	48 b8 b8 18 00 00 00 	movabs $0x18b8,%rax
    165b:	00 00 00 
    165e:	ff d0                	callq  *%rax
  read(fd, large1, size);
    1660:	8b 55 e8             	mov    -0x18(%rbp),%edx
    1663:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
    1667:	8b 45 ec             	mov    -0x14(%rbp),%eax
    166a:	48 89 ce             	mov    %rcx,%rsi
    166d:	89 c7                	mov    %eax,%edi
    166f:	48 b8 14 1b 00 00 00 	movabs $0x1b14,%rax
    1676:	00 00 00 
    1679:	ff d0                	callq  *%rax
  volatile int slarge = 0;
    167b:	c7 85 1c ff ff ff 00 	movl   $0x0,-0xe4(%rbp)
    1682:	00 00 00 
  int exp = aread(fd, large2, 0, size, &slarge);
    1685:	8b 55 e8             	mov    -0x18(%rbp),%edx
    1688:	48 8d 8d 1c ff ff ff 	lea    -0xe4(%rbp),%rcx
    168f:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
    1693:	8b 45 ec             	mov    -0x14(%rbp),%eax
    1696:	49 89 c8             	mov    %rcx,%r8
    1699:	89 d1                	mov    %edx,%ecx
    169b:	ba 00 00 00 00       	mov    $0x0,%edx
    16a0:	89 c7                	mov    %eax,%edi
    16a2:	48 b8 f1 1b 00 00 00 	movabs $0x1bf1,%rax
    16a9:	00 00 00 
    16ac:	ff d0                	callq  *%rax
    16ae:	89 45 d4             	mov    %eax,-0x2c(%rbp)
  if (exp != size) {
    16b1:	8b 45 e8             	mov    -0x18(%rbp),%eax
    16b4:	39 45 d4             	cmp    %eax,-0x2c(%rbp)
    16b7:	74 37                	je     16f0 <main+0x63a>
    printf(1, "error: expecting %d, should be %d\n", exp, size);
    16b9:	8b 55 e8             	mov    -0x18(%rbp),%edx
    16bc:	8b 45 d4             	mov    -0x2c(%rbp),%eax
    16bf:	89 d1                	mov    %edx,%ecx
    16c1:	89 c2                	mov    %eax,%edx
    16c3:	48 be c0 25 00 00 00 	movabs $0x25c0,%rsi
    16ca:	00 00 00 
    16cd:	bf 01 00 00 00       	mov    $0x1,%edi
    16d2:	b8 00 00 00 00       	mov    $0x0,%eax
    16d7:	49 b8 e4 1d 00 00 00 	movabs $0x1de4,%r8
    16de:	00 00 00 
    16e1:	41 ff d0             	callq  *%r8
    exit();
    16e4:	48 b8 ed 1a 00 00 00 	movabs $0x1aed,%rax
    16eb:	00 00 00 
    16ee:	ff d0                	callq  *%rax
  }
  int wlarge = 0;
    16f0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%rbp)
  while (slarge != size)
    16f7:	eb 04                	jmp    16fd <main+0x647>
    wlarge++;
    16f9:	83 45 f0 01          	addl   $0x1,-0x10(%rbp)
  while (slarge != size)
    16fd:	8b 95 1c ff ff ff    	mov    -0xe4(%rbp),%edx
    1703:	8b 45 e8             	mov    -0x18(%rbp),%eax
    1706:	39 c2                	cmp    %eax,%edx
    1708:	75 ef                	jne    16f9 <main+0x643>
  printf(1, "large file: wait time: %d\n", wlarge);
    170a:	8b 45 f0             	mov    -0x10(%rbp),%eax
    170d:	89 c2                	mov    %eax,%edx
    170f:	48 be e3 25 00 00 00 	movabs $0x25e3,%rsi
    1716:	00 00 00 
    1719:	bf 01 00 00 00       	mov    $0x1,%edi
    171e:	b8 00 00 00 00       	mov    $0x0,%eax
    1723:	48 b9 e4 1d 00 00 00 	movabs $0x1de4,%rcx
    172a:	00 00 00 
    172d:	ff d1                	callq  *%rcx
  int r = memmatch(large1, large2, size);
    172f:	8b 55 e8             	mov    -0x18(%rbp),%edx
    1732:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
    1736:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    173a:	48 89 ce             	mov    %rcx,%rsi
    173d:	48 89 c7             	mov    %rax,%rdi
    1740:	48 b8 5c 10 00 00 00 	movabs $0x105c,%rax
    1747:	00 00 00 
    174a:	ff d0                	callq  *%rax
    174c:	89 45 d0             	mov    %eax,-0x30(%rbp)
  if (r < size) {
    174f:	8b 45 d0             	mov    -0x30(%rbp),%eax
    1752:	39 45 e8             	cmp    %eax,-0x18(%rbp)
    1755:	76 27                	jbe    177e <main+0x6c8>
    printf(1, "read: error: data mismatch at [%d]\n", r);
    1757:	8b 45 d0             	mov    -0x30(%rbp),%eax
    175a:	89 c2                	mov    %eax,%edx
    175c:	48 be 00 26 00 00 00 	movabs $0x2600,%rsi
    1763:	00 00 00 
    1766:	bf 01 00 00 00       	mov    $0x1,%edi
    176b:	b8 00 00 00 00       	mov    $0x0,%eax
    1770:	48 b9 e4 1d 00 00 00 	movabs $0x1de4,%rcx
    1777:	00 00 00 
    177a:	ff d1                	callq  *%rcx
    177c:	eb 20                	jmp    179e <main+0x6e8>
  } else {
    printf(1, "read: OK!\n");
    177e:	48 be 24 26 00 00 00 	movabs $0x2624,%rsi
    1785:	00 00 00 
    1788:	bf 01 00 00 00       	mov    $0x1,%edi
    178d:	b8 00 00 00 00       	mov    $0x0,%eax
    1792:	48 ba e4 1d 00 00 00 	movabs $0x1de4,%rdx
    1799:	00 00 00 
    179c:	ff d2                	callq  *%rdx
  }
  exit();
    179e:	48 b8 ed 1a 00 00 00 	movabs $0x1aed,%rax
    17a5:	00 00 00 
    17a8:	ff d0                	callq  *%rax

00000000000017aa <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
    17aa:	f3 0f 1e fa          	endbr64 
    17ae:	55                   	push   %rbp
    17af:	48 89 e5             	mov    %rsp,%rbp
    17b2:	48 83 ec 10          	sub    $0x10,%rsp
    17b6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    17ba:	89 75 f4             	mov    %esi,-0xc(%rbp)
    17bd:	89 55 f0             	mov    %edx,-0x10(%rbp)
  asm volatile("cld; rep stosb" :
    17c0:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
    17c4:	8b 55 f0             	mov    -0x10(%rbp),%edx
    17c7:	8b 45 f4             	mov    -0xc(%rbp),%eax
    17ca:	48 89 ce             	mov    %rcx,%rsi
    17cd:	48 89 f7             	mov    %rsi,%rdi
    17d0:	89 d1                	mov    %edx,%ecx
    17d2:	fc                   	cld    
    17d3:	f3 aa                	rep stos %al,%es:(%rdi)
    17d5:	89 ca                	mov    %ecx,%edx
    17d7:	48 89 fe             	mov    %rdi,%rsi
    17da:	48 89 75 f8          	mov    %rsi,-0x8(%rbp)
    17de:	89 55 f0             	mov    %edx,-0x10(%rbp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
    17e1:	90                   	nop
    17e2:	c9                   	leaveq 
    17e3:	c3                   	retq   

00000000000017e4 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
    17e4:	f3 0f 1e fa          	endbr64 
    17e8:	55                   	push   %rbp
    17e9:	48 89 e5             	mov    %rsp,%rbp
    17ec:	48 83 ec 20          	sub    $0x20,%rsp
    17f0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    17f4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  char *os;

  os = s;
    17f8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    17fc:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  while((*s++ = *t++) != 0)
    1800:	90                   	nop
    1801:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
    1805:	48 8d 42 01          	lea    0x1(%rdx),%rax
    1809:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    180d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1811:	48 8d 48 01          	lea    0x1(%rax),%rcx
    1815:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
    1819:	0f b6 12             	movzbl (%rdx),%edx
    181c:	88 10                	mov    %dl,(%rax)
    181e:	0f b6 00             	movzbl (%rax),%eax
    1821:	84 c0                	test   %al,%al
    1823:	75 dc                	jne    1801 <strcpy+0x1d>
    ;
  return os;
    1825:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
    1829:	c9                   	leaveq 
    182a:	c3                   	retq   

000000000000182b <strcmp>:

int
strcmp(const char *p, const char *q)
{
    182b:	f3 0f 1e fa          	endbr64 
    182f:	55                   	push   %rbp
    1830:	48 89 e5             	mov    %rsp,%rbp
    1833:	48 83 ec 10          	sub    $0x10,%rsp
    1837:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    183b:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
  while(*p && *p == *q)
    183f:	eb 0a                	jmp    184b <strcmp+0x20>
    p++, q++;
    1841:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
    1846:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
  while(*p && *p == *q)
    184b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    184f:	0f b6 00             	movzbl (%rax),%eax
    1852:	84 c0                	test   %al,%al
    1854:	74 12                	je     1868 <strcmp+0x3d>
    1856:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    185a:	0f b6 10             	movzbl (%rax),%edx
    185d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1861:	0f b6 00             	movzbl (%rax),%eax
    1864:	38 c2                	cmp    %al,%dl
    1866:	74 d9                	je     1841 <strcmp+0x16>
  return (uchar)*p - (uchar)*q;
    1868:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    186c:	0f b6 00             	movzbl (%rax),%eax
    186f:	0f b6 d0             	movzbl %al,%edx
    1872:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    1876:	0f b6 00             	movzbl (%rax),%eax
    1879:	0f b6 c0             	movzbl %al,%eax
    187c:	29 c2                	sub    %eax,%edx
    187e:	89 d0                	mov    %edx,%eax
}
    1880:	c9                   	leaveq 
    1881:	c3                   	retq   

0000000000001882 <strlen>:

uint
strlen(char *s)
{
    1882:	f3 0f 1e fa          	endbr64 
    1886:	55                   	push   %rbp
    1887:	48 89 e5             	mov    %rsp,%rbp
    188a:	48 83 ec 18          	sub    $0x18,%rsp
    188e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  int n;

  for(n = 0; s[n]; n++)
    1892:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    1899:	eb 04                	jmp    189f <strlen+0x1d>
    189b:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    189f:	8b 45 fc             	mov    -0x4(%rbp),%eax
    18a2:	48 63 d0             	movslq %eax,%rdx
    18a5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    18a9:	48 01 d0             	add    %rdx,%rax
    18ac:	0f b6 00             	movzbl (%rax),%eax
    18af:	84 c0                	test   %al,%al
    18b1:	75 e8                	jne    189b <strlen+0x19>
    ;
  return n;
    18b3:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
    18b6:	c9                   	leaveq 
    18b7:	c3                   	retq   

00000000000018b8 <memset>:

void*
memset(void *dst, int c, uint n)
{
    18b8:	f3 0f 1e fa          	endbr64 
    18bc:	55                   	push   %rbp
    18bd:	48 89 e5             	mov    %rsp,%rbp
    18c0:	48 83 ec 10          	sub    $0x10,%rsp
    18c4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    18c8:	89 75 f4             	mov    %esi,-0xc(%rbp)
    18cb:	89 55 f0             	mov    %edx,-0x10(%rbp)
  stosb(dst, c, n);
    18ce:	8b 55 f0             	mov    -0x10(%rbp),%edx
    18d1:	8b 4d f4             	mov    -0xc(%rbp),%ecx
    18d4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    18d8:	89 ce                	mov    %ecx,%esi
    18da:	48 89 c7             	mov    %rax,%rdi
    18dd:	48 b8 aa 17 00 00 00 	movabs $0x17aa,%rax
    18e4:	00 00 00 
    18e7:	ff d0                	callq  *%rax
  return dst;
    18e9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
    18ed:	c9                   	leaveq 
    18ee:	c3                   	retq   

00000000000018ef <strchr>:

char*
strchr(const char *s, char c)
{
    18ef:	f3 0f 1e fa          	endbr64 
    18f3:	55                   	push   %rbp
    18f4:	48 89 e5             	mov    %rsp,%rbp
    18f7:	48 83 ec 10          	sub    $0x10,%rsp
    18fb:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    18ff:	89 f0                	mov    %esi,%eax
    1901:	88 45 f4             	mov    %al,-0xc(%rbp)
  for(; *s; s++)
    1904:	eb 17                	jmp    191d <strchr+0x2e>
    if(*s == c)
    1906:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    190a:	0f b6 00             	movzbl (%rax),%eax
    190d:	38 45 f4             	cmp    %al,-0xc(%rbp)
    1910:	75 06                	jne    1918 <strchr+0x29>
      return (char*)s;
    1912:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1916:	eb 15                	jmp    192d <strchr+0x3e>
  for(; *s; s++)
    1918:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
    191d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1921:	0f b6 00             	movzbl (%rax),%eax
    1924:	84 c0                	test   %al,%al
    1926:	75 de                	jne    1906 <strchr+0x17>
  return 0;
    1928:	b8 00 00 00 00       	mov    $0x0,%eax
}
    192d:	c9                   	leaveq 
    192e:	c3                   	retq   

000000000000192f <gets>:

char*
gets(char *buf, int max)
{
    192f:	f3 0f 1e fa          	endbr64 
    1933:	55                   	push   %rbp
    1934:	48 89 e5             	mov    %rsp,%rbp
    1937:	48 83 ec 20          	sub    $0x20,%rsp
    193b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    193f:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    1942:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    1949:	eb 4f                	jmp    199a <gets+0x6b>
    cc = read(0, &c, 1);
    194b:	48 8d 45 f7          	lea    -0x9(%rbp),%rax
    194f:	ba 01 00 00 00       	mov    $0x1,%edx
    1954:	48 89 c6             	mov    %rax,%rsi
    1957:	bf 00 00 00 00       	mov    $0x0,%edi
    195c:	48 b8 14 1b 00 00 00 	movabs $0x1b14,%rax
    1963:	00 00 00 
    1966:	ff d0                	callq  *%rax
    1968:	89 45 f8             	mov    %eax,-0x8(%rbp)
    if(cc < 1)
    196b:	83 7d f8 00          	cmpl   $0x0,-0x8(%rbp)
    196f:	7e 36                	jle    19a7 <gets+0x78>
      break;
    buf[i++] = c;
    1971:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1974:	8d 50 01             	lea    0x1(%rax),%edx
    1977:	89 55 fc             	mov    %edx,-0x4(%rbp)
    197a:	48 63 d0             	movslq %eax,%rdx
    197d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1981:	48 01 c2             	add    %rax,%rdx
    1984:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
    1988:	88 02                	mov    %al,(%rdx)
    if(c == '\n' || c == '\r')
    198a:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
    198e:	3c 0a                	cmp    $0xa,%al
    1990:	74 16                	je     19a8 <gets+0x79>
    1992:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
    1996:	3c 0d                	cmp    $0xd,%al
    1998:	74 0e                	je     19a8 <gets+0x79>
  for(i=0; i+1 < max; ){
    199a:	8b 45 fc             	mov    -0x4(%rbp),%eax
    199d:	83 c0 01             	add    $0x1,%eax
    19a0:	39 45 e4             	cmp    %eax,-0x1c(%rbp)
    19a3:	7f a6                	jg     194b <gets+0x1c>
    19a5:	eb 01                	jmp    19a8 <gets+0x79>
      break;
    19a7:	90                   	nop
      break;
  }
  buf[i] = '\0';
    19a8:	8b 45 fc             	mov    -0x4(%rbp),%eax
    19ab:	48 63 d0             	movslq %eax,%rdx
    19ae:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    19b2:	48 01 d0             	add    %rdx,%rax
    19b5:	c6 00 00             	movb   $0x0,(%rax)
  return buf;
    19b8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
    19bc:	c9                   	leaveq 
    19bd:	c3                   	retq   

00000000000019be <stat>:

int
stat(char *n, struct stat *st)
{
    19be:	f3 0f 1e fa          	endbr64 
    19c2:	55                   	push   %rbp
    19c3:	48 89 e5             	mov    %rsp,%rbp
    19c6:	48 83 ec 20          	sub    $0x20,%rsp
    19ca:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    19ce:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    19d2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    19d6:	be 00 00 00 00       	mov    $0x0,%esi
    19db:	48 89 c7             	mov    %rax,%rdi
    19de:	48 b8 55 1b 00 00 00 	movabs $0x1b55,%rax
    19e5:	00 00 00 
    19e8:	ff d0                	callq  *%rax
    19ea:	89 45 fc             	mov    %eax,-0x4(%rbp)
  if(fd < 0)
    19ed:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
    19f1:	79 07                	jns    19fa <stat+0x3c>
    return -1;
    19f3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    19f8:	eb 2f                	jmp    1a29 <stat+0x6b>
  r = fstat(fd, st);
    19fa:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
    19fe:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1a01:	48 89 d6             	mov    %rdx,%rsi
    1a04:	89 c7                	mov    %eax,%edi
    1a06:	48 b8 7c 1b 00 00 00 	movabs $0x1b7c,%rax
    1a0d:	00 00 00 
    1a10:	ff d0                	callq  *%rax
    1a12:	89 45 f8             	mov    %eax,-0x8(%rbp)
  close(fd);
    1a15:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1a18:	89 c7                	mov    %eax,%edi
    1a1a:	48 b8 2e 1b 00 00 00 	movabs $0x1b2e,%rax
    1a21:	00 00 00 
    1a24:	ff d0                	callq  *%rax
  return r;
    1a26:	8b 45 f8             	mov    -0x8(%rbp),%eax
}
    1a29:	c9                   	leaveq 
    1a2a:	c3                   	retq   

0000000000001a2b <atoi>:

int
atoi(const char *s)
{
    1a2b:	f3 0f 1e fa          	endbr64 
    1a2f:	55                   	push   %rbp
    1a30:	48 89 e5             	mov    %rsp,%rbp
    1a33:	48 83 ec 18          	sub    $0x18,%rsp
    1a37:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  int n;

  n = 0;
    1a3b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  while('0' <= *s && *s <= '9')
    1a42:	eb 28                	jmp    1a6c <atoi+0x41>
    n = n*10 + *s++ - '0';
    1a44:	8b 55 fc             	mov    -0x4(%rbp),%edx
    1a47:	89 d0                	mov    %edx,%eax
    1a49:	c1 e0 02             	shl    $0x2,%eax
    1a4c:	01 d0                	add    %edx,%eax
    1a4e:	01 c0                	add    %eax,%eax
    1a50:	89 c1                	mov    %eax,%ecx
    1a52:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1a56:	48 8d 50 01          	lea    0x1(%rax),%rdx
    1a5a:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
    1a5e:	0f b6 00             	movzbl (%rax),%eax
    1a61:	0f be c0             	movsbl %al,%eax
    1a64:	01 c8                	add    %ecx,%eax
    1a66:	83 e8 30             	sub    $0x30,%eax
    1a69:	89 45 fc             	mov    %eax,-0x4(%rbp)
  while('0' <= *s && *s <= '9')
    1a6c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1a70:	0f b6 00             	movzbl (%rax),%eax
    1a73:	3c 2f                	cmp    $0x2f,%al
    1a75:	7e 0b                	jle    1a82 <atoi+0x57>
    1a77:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1a7b:	0f b6 00             	movzbl (%rax),%eax
    1a7e:	3c 39                	cmp    $0x39,%al
    1a80:	7e c2                	jle    1a44 <atoi+0x19>
  return n;
    1a82:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
    1a85:	c9                   	leaveq 
    1a86:	c3                   	retq   

0000000000001a87 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    1a87:	f3 0f 1e fa          	endbr64 
    1a8b:	55                   	push   %rbp
    1a8c:	48 89 e5             	mov    %rsp,%rbp
    1a8f:	48 83 ec 28          	sub    $0x28,%rsp
    1a93:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    1a97:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
    1a9b:	89 55 dc             	mov    %edx,-0x24(%rbp)
  char *dst, *src;

  dst = vdst;
    1a9e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1aa2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  src = vsrc;
    1aa6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    1aaa:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  while(n-- > 0)
    1aae:	eb 1d                	jmp    1acd <memmove+0x46>
    *dst++ = *src++;
    1ab0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
    1ab4:	48 8d 42 01          	lea    0x1(%rdx),%rax
    1ab8:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    1abc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    1ac0:	48 8d 48 01          	lea    0x1(%rax),%rcx
    1ac4:	48 89 4d f8          	mov    %rcx,-0x8(%rbp)
    1ac8:	0f b6 12             	movzbl (%rdx),%edx
    1acb:	88 10                	mov    %dl,(%rax)
  while(n-- > 0)
    1acd:	8b 45 dc             	mov    -0x24(%rbp),%eax
    1ad0:	8d 50 ff             	lea    -0x1(%rax),%edx
    1ad3:	89 55 dc             	mov    %edx,-0x24(%rbp)
    1ad6:	85 c0                	test   %eax,%eax
    1ad8:	7f d6                	jg     1ab0 <memmove+0x29>
  return vdst;
    1ada:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
    1ade:	c9                   	leaveq 
    1adf:	c3                   	retq   

0000000000001ae0 <fork>:
    mov $SYS_ ## name, %rax; \
    mov %rcx, %r10 ;\
    syscall		  ;\
    ret

SYSCALL(fork)
    1ae0:	48 c7 c0 01 00 00 00 	mov    $0x1,%rax
    1ae7:	49 89 ca             	mov    %rcx,%r10
    1aea:	0f 05                	syscall 
    1aec:	c3                   	retq   

0000000000001aed <exit>:
SYSCALL(exit)
    1aed:	48 c7 c0 02 00 00 00 	mov    $0x2,%rax
    1af4:	49 89 ca             	mov    %rcx,%r10
    1af7:	0f 05                	syscall 
    1af9:	c3                   	retq   

0000000000001afa <wait>:
SYSCALL(wait)
    1afa:	48 c7 c0 03 00 00 00 	mov    $0x3,%rax
    1b01:	49 89 ca             	mov    %rcx,%r10
    1b04:	0f 05                	syscall 
    1b06:	c3                   	retq   

0000000000001b07 <pipe>:
SYSCALL(pipe)
    1b07:	48 c7 c0 04 00 00 00 	mov    $0x4,%rax
    1b0e:	49 89 ca             	mov    %rcx,%r10
    1b11:	0f 05                	syscall 
    1b13:	c3                   	retq   

0000000000001b14 <read>:
SYSCALL(read)
    1b14:	48 c7 c0 05 00 00 00 	mov    $0x5,%rax
    1b1b:	49 89 ca             	mov    %rcx,%r10
    1b1e:	0f 05                	syscall 
    1b20:	c3                   	retq   

0000000000001b21 <write>:
SYSCALL(write)
    1b21:	48 c7 c0 10 00 00 00 	mov    $0x10,%rax
    1b28:	49 89 ca             	mov    %rcx,%r10
    1b2b:	0f 05                	syscall 
    1b2d:	c3                   	retq   

0000000000001b2e <close>:
SYSCALL(close)
    1b2e:	48 c7 c0 15 00 00 00 	mov    $0x15,%rax
    1b35:	49 89 ca             	mov    %rcx,%r10
    1b38:	0f 05                	syscall 
    1b3a:	c3                   	retq   

0000000000001b3b <kill>:
SYSCALL(kill)
    1b3b:	48 c7 c0 06 00 00 00 	mov    $0x6,%rax
    1b42:	49 89 ca             	mov    %rcx,%r10
    1b45:	0f 05                	syscall 
    1b47:	c3                   	retq   

0000000000001b48 <exec>:
SYSCALL(exec)
    1b48:	48 c7 c0 07 00 00 00 	mov    $0x7,%rax
    1b4f:	49 89 ca             	mov    %rcx,%r10
    1b52:	0f 05                	syscall 
    1b54:	c3                   	retq   

0000000000001b55 <open>:
SYSCALL(open)
    1b55:	48 c7 c0 0f 00 00 00 	mov    $0xf,%rax
    1b5c:	49 89 ca             	mov    %rcx,%r10
    1b5f:	0f 05                	syscall 
    1b61:	c3                   	retq   

0000000000001b62 <mknod>:
SYSCALL(mknod)
    1b62:	48 c7 c0 11 00 00 00 	mov    $0x11,%rax
    1b69:	49 89 ca             	mov    %rcx,%r10
    1b6c:	0f 05                	syscall 
    1b6e:	c3                   	retq   

0000000000001b6f <unlink>:
SYSCALL(unlink)
    1b6f:	48 c7 c0 12 00 00 00 	mov    $0x12,%rax
    1b76:	49 89 ca             	mov    %rcx,%r10
    1b79:	0f 05                	syscall 
    1b7b:	c3                   	retq   

0000000000001b7c <fstat>:
SYSCALL(fstat)
    1b7c:	48 c7 c0 08 00 00 00 	mov    $0x8,%rax
    1b83:	49 89 ca             	mov    %rcx,%r10
    1b86:	0f 05                	syscall 
    1b88:	c3                   	retq   

0000000000001b89 <link>:
SYSCALL(link)
    1b89:	48 c7 c0 13 00 00 00 	mov    $0x13,%rax
    1b90:	49 89 ca             	mov    %rcx,%r10
    1b93:	0f 05                	syscall 
    1b95:	c3                   	retq   

0000000000001b96 <mkdir>:
SYSCALL(mkdir)
    1b96:	48 c7 c0 14 00 00 00 	mov    $0x14,%rax
    1b9d:	49 89 ca             	mov    %rcx,%r10
    1ba0:	0f 05                	syscall 
    1ba2:	c3                   	retq   

0000000000001ba3 <chdir>:
SYSCALL(chdir)
    1ba3:	48 c7 c0 09 00 00 00 	mov    $0x9,%rax
    1baa:	49 89 ca             	mov    %rcx,%r10
    1bad:	0f 05                	syscall 
    1baf:	c3                   	retq   

0000000000001bb0 <dup>:
SYSCALL(dup)
    1bb0:	48 c7 c0 0a 00 00 00 	mov    $0xa,%rax
    1bb7:	49 89 ca             	mov    %rcx,%r10
    1bba:	0f 05                	syscall 
    1bbc:	c3                   	retq   

0000000000001bbd <getpid>:
SYSCALL(getpid)
    1bbd:	48 c7 c0 0b 00 00 00 	mov    $0xb,%rax
    1bc4:	49 89 ca             	mov    %rcx,%r10
    1bc7:	0f 05                	syscall 
    1bc9:	c3                   	retq   

0000000000001bca <sbrk>:
SYSCALL(sbrk)
    1bca:	48 c7 c0 0c 00 00 00 	mov    $0xc,%rax
    1bd1:	49 89 ca             	mov    %rcx,%r10
    1bd4:	0f 05                	syscall 
    1bd6:	c3                   	retq   

0000000000001bd7 <sleep>:
SYSCALL(sleep)
    1bd7:	48 c7 c0 0d 00 00 00 	mov    $0xd,%rax
    1bde:	49 89 ca             	mov    %rcx,%r10
    1be1:	0f 05                	syscall 
    1be3:	c3                   	retq   

0000000000001be4 <uptime>:
SYSCALL(uptime)
    1be4:	48 c7 c0 0e 00 00 00 	mov    $0xe,%rax
    1beb:	49 89 ca             	mov    %rcx,%r10
    1bee:	0f 05                	syscall 
    1bf0:	c3                   	retq   

0000000000001bf1 <aread>:
SYSCALL(aread)
    1bf1:	48 c7 c0 16 00 00 00 	mov    $0x16,%rax
    1bf8:	49 89 ca             	mov    %rcx,%r10
    1bfb:	0f 05                	syscall 
    1bfd:	c3                   	retq   

0000000000001bfe <putc>:

#include <stdarg.h>

static void
putc(int fd, char c)
{
    1bfe:	f3 0f 1e fa          	endbr64 
    1c02:	55                   	push   %rbp
    1c03:	48 89 e5             	mov    %rsp,%rbp
    1c06:	48 83 ec 10          	sub    $0x10,%rsp
    1c0a:	89 7d fc             	mov    %edi,-0x4(%rbp)
    1c0d:	89 f0                	mov    %esi,%eax
    1c0f:	88 45 f8             	mov    %al,-0x8(%rbp)
  write(fd, &c, 1);
    1c12:	48 8d 4d f8          	lea    -0x8(%rbp),%rcx
    1c16:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1c19:	ba 01 00 00 00       	mov    $0x1,%edx
    1c1e:	48 89 ce             	mov    %rcx,%rsi
    1c21:	89 c7                	mov    %eax,%edi
    1c23:	48 b8 21 1b 00 00 00 	movabs $0x1b21,%rax
    1c2a:	00 00 00 
    1c2d:	ff d0                	callq  *%rax
}
    1c2f:	90                   	nop
    1c30:	c9                   	leaveq 
    1c31:	c3                   	retq   

0000000000001c32 <print_x64>:

static char digits[] = "0123456789abcdef";

  static void
print_x64(int fd, addr_t x)
{
    1c32:	f3 0f 1e fa          	endbr64 
    1c36:	55                   	push   %rbp
    1c37:	48 89 e5             	mov    %rsp,%rbp
    1c3a:	48 83 ec 20          	sub    $0x20,%rsp
    1c3e:	89 7d ec             	mov    %edi,-0x14(%rbp)
    1c41:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  int i;
  for (i = 0; i < (sizeof(addr_t) * 2); i++, x <<= 4)
    1c45:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    1c4c:	eb 35                	jmp    1c83 <print_x64+0x51>
    putc(fd, digits[x >> (sizeof(addr_t) * 8 - 4)]);
    1c4e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    1c52:	48 c1 e8 3c          	shr    $0x3c,%rax
    1c56:	48 ba a0 29 00 00 00 	movabs $0x29a0,%rdx
    1c5d:	00 00 00 
    1c60:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
    1c64:	0f be d0             	movsbl %al,%edx
    1c67:	8b 45 ec             	mov    -0x14(%rbp),%eax
    1c6a:	89 d6                	mov    %edx,%esi
    1c6c:	89 c7                	mov    %eax,%edi
    1c6e:	48 b8 fe 1b 00 00 00 	movabs $0x1bfe,%rax
    1c75:	00 00 00 
    1c78:	ff d0                	callq  *%rax
  for (i = 0; i < (sizeof(addr_t) * 2); i++, x <<= 4)
    1c7a:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    1c7e:	48 c1 65 e0 04       	shlq   $0x4,-0x20(%rbp)
    1c83:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1c86:	83 f8 0f             	cmp    $0xf,%eax
    1c89:	76 c3                	jbe    1c4e <print_x64+0x1c>
}
    1c8b:	90                   	nop
    1c8c:	90                   	nop
    1c8d:	c9                   	leaveq 
    1c8e:	c3                   	retq   

0000000000001c8f <print_x32>:

  static void
print_x32(int fd, uint x)
{
    1c8f:	f3 0f 1e fa          	endbr64 
    1c93:	55                   	push   %rbp
    1c94:	48 89 e5             	mov    %rsp,%rbp
    1c97:	48 83 ec 20          	sub    $0x20,%rsp
    1c9b:	89 7d ec             	mov    %edi,-0x14(%rbp)
    1c9e:	89 75 e8             	mov    %esi,-0x18(%rbp)
  int i;
  for (i = 0; i < (sizeof(uint) * 2); i++, x <<= 4)
    1ca1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
    1ca8:	eb 36                	jmp    1ce0 <print_x32+0x51>
    putc(fd, digits[x >> (sizeof(uint) * 8 - 4)]);
    1caa:	8b 45 e8             	mov    -0x18(%rbp),%eax
    1cad:	c1 e8 1c             	shr    $0x1c,%eax
    1cb0:	89 c2                	mov    %eax,%edx
    1cb2:	48 b8 a0 29 00 00 00 	movabs $0x29a0,%rax
    1cb9:	00 00 00 
    1cbc:	89 d2                	mov    %edx,%edx
    1cbe:	0f b6 04 10          	movzbl (%rax,%rdx,1),%eax
    1cc2:	0f be d0             	movsbl %al,%edx
    1cc5:	8b 45 ec             	mov    -0x14(%rbp),%eax
    1cc8:	89 d6                	mov    %edx,%esi
    1cca:	89 c7                	mov    %eax,%edi
    1ccc:	48 b8 fe 1b 00 00 00 	movabs $0x1bfe,%rax
    1cd3:	00 00 00 
    1cd6:	ff d0                	callq  *%rax
  for (i = 0; i < (sizeof(uint) * 2); i++, x <<= 4)
    1cd8:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
    1cdc:	c1 65 e8 04          	shll   $0x4,-0x18(%rbp)
    1ce0:	8b 45 fc             	mov    -0x4(%rbp),%eax
    1ce3:	83 f8 07             	cmp    $0x7,%eax
    1ce6:	76 c2                	jbe    1caa <print_x32+0x1b>
}
    1ce8:	90                   	nop
    1ce9:	90                   	nop
    1cea:	c9                   	leaveq 
    1ceb:	c3                   	retq   

0000000000001cec <print_d>:

  static void
print_d(int fd, int v)
{
    1cec:	f3 0f 1e fa          	endbr64 
    1cf0:	55                   	push   %rbp
    1cf1:	48 89 e5             	mov    %rsp,%rbp
    1cf4:	48 83 ec 30          	sub    $0x30,%rsp
    1cf8:	89 7d dc             	mov    %edi,-0x24(%rbp)
    1cfb:	89 75 d8             	mov    %esi,-0x28(%rbp)
  char buf[16];
  int64 x = v;
    1cfe:	8b 45 d8             	mov    -0x28(%rbp),%eax
    1d01:	48 98                	cltq   
    1d03:	48 89 45 f8          	mov    %rax,-0x8(%rbp)

  if (v < 0)
    1d07:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
    1d0b:	79 04                	jns    1d11 <print_d+0x25>
    x = -x;
    1d0d:	48 f7 5d f8          	negq   -0x8(%rbp)

  int i = 0;
    1d11:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
  do {
    buf[i++] = digits[x % 10];
    1d18:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
    1d1c:	48 ba 67 66 66 66 66 	movabs $0x6666666666666667,%rdx
    1d23:	66 66 66 
    1d26:	48 89 c8             	mov    %rcx,%rax
    1d29:	48 f7 ea             	imul   %rdx
    1d2c:	48 c1 fa 02          	sar    $0x2,%rdx
    1d30:	48 89 c8             	mov    %rcx,%rax
    1d33:	48 c1 f8 3f          	sar    $0x3f,%rax
    1d37:	48 29 c2             	sub    %rax,%rdx
    1d3a:	48 89 d0             	mov    %rdx,%rax
    1d3d:	48 c1 e0 02          	shl    $0x2,%rax
    1d41:	48 01 d0             	add    %rdx,%rax
    1d44:	48 01 c0             	add    %rax,%rax
    1d47:	48 29 c1             	sub    %rax,%rcx
    1d4a:	48 89 ca             	mov    %rcx,%rdx
    1d4d:	8b 45 f4             	mov    -0xc(%rbp),%eax
    1d50:	8d 48 01             	lea    0x1(%rax),%ecx
    1d53:	89 4d f4             	mov    %ecx,-0xc(%rbp)
    1d56:	48 b9 a0 29 00 00 00 	movabs $0x29a0,%rcx
    1d5d:	00 00 00 
    1d60:	0f b6 14 11          	movzbl (%rcx,%rdx,1),%edx
    1d64:	48 98                	cltq   
    1d66:	88 54 05 e0          	mov    %dl,-0x20(%rbp,%rax,1)
    x /= 10;
    1d6a:	48 8b 4d f8          	mov    -0x8(%rbp),%rcx
    1d6e:	48 ba 67 66 66 66 66 	movabs $0x6666666666666667,%rdx
    1d75:	66 66 66 
    1d78:	48 89 c8             	mov    %rcx,%rax
    1d7b:	48 f7 ea             	imul   %rdx
    1d7e:	48 c1 fa 02          	sar    $0x2,%rdx
    1d82:	48 89 c8             	mov    %rcx,%rax
    1d85:	48 c1 f8 3f          	sar    $0x3f,%rax
    1d89:	48 29 c2             	sub    %rax,%rdx
    1d8c:	48 89 d0             	mov    %rdx,%rax
    1d8f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  } while(x != 0);
    1d93:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
    1d98:	0f 85 7a ff ff ff    	jne    1d18 <print_d+0x2c>

  if (v < 0)
    1d9e:	83 7d d8 00          	cmpl   $0x0,-0x28(%rbp)
    1da2:	79 32                	jns    1dd6 <print_d+0xea>
    buf[i++] = '-';
    1da4:	8b 45 f4             	mov    -0xc(%rbp),%eax
    1da7:	8d 50 01             	lea    0x1(%rax),%edx
    1daa:	89 55 f4             	mov    %edx,-0xc(%rbp)
    1dad:	48 98                	cltq   
    1daf:	c6 44 05 e0 2d       	movb   $0x2d,-0x20(%rbp,%rax,1)

  while (--i >= 0)
    1db4:	eb 20                	jmp    1dd6 <print_d+0xea>
    putc(fd, buf[i]);
    1db6:	8b 45 f4             	mov    -0xc(%rbp),%eax
    1db9:	48 98                	cltq   
    1dbb:	0f b6 44 05 e0       	movzbl -0x20(%rbp,%rax,1),%eax
    1dc0:	0f be d0             	movsbl %al,%edx
    1dc3:	8b 45 dc             	mov    -0x24(%rbp),%eax
    1dc6:	89 d6                	mov    %edx,%esi
    1dc8:	89 c7                	mov    %eax,%edi
    1dca:	48 b8 fe 1b 00 00 00 	movabs $0x1bfe,%rax
    1dd1:	00 00 00 
    1dd4:	ff d0                	callq  *%rax
  while (--i >= 0)
    1dd6:	83 6d f4 01          	subl   $0x1,-0xc(%rbp)
    1dda:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
    1dde:	79 d6                	jns    1db6 <print_d+0xca>
}
    1de0:	90                   	nop
    1de1:	90                   	nop
    1de2:	c9                   	leaveq 
    1de3:	c3                   	retq   

0000000000001de4 <printf>:
// Print to the given fd. Only understands %d, %x, %p, %s.
  void
printf(int fd, char *fmt, ...)
{
    1de4:	f3 0f 1e fa          	endbr64 
    1de8:	55                   	push   %rbp
    1de9:	48 89 e5             	mov    %rsp,%rbp
    1dec:	48 81 ec f0 00 00 00 	sub    $0xf0,%rsp
    1df3:	89 bd 1c ff ff ff    	mov    %edi,-0xe4(%rbp)
    1df9:	48 89 b5 10 ff ff ff 	mov    %rsi,-0xf0(%rbp)
    1e00:	48 89 95 60 ff ff ff 	mov    %rdx,-0xa0(%rbp)
    1e07:	48 89 8d 68 ff ff ff 	mov    %rcx,-0x98(%rbp)
    1e0e:	4c 89 85 70 ff ff ff 	mov    %r8,-0x90(%rbp)
    1e15:	4c 89 8d 78 ff ff ff 	mov    %r9,-0x88(%rbp)
    1e1c:	84 c0                	test   %al,%al
    1e1e:	74 20                	je     1e40 <printf+0x5c>
    1e20:	0f 29 45 80          	movaps %xmm0,-0x80(%rbp)
    1e24:	0f 29 4d 90          	movaps %xmm1,-0x70(%rbp)
    1e28:	0f 29 55 a0          	movaps %xmm2,-0x60(%rbp)
    1e2c:	0f 29 5d b0          	movaps %xmm3,-0x50(%rbp)
    1e30:	0f 29 65 c0          	movaps %xmm4,-0x40(%rbp)
    1e34:	0f 29 6d d0          	movaps %xmm5,-0x30(%rbp)
    1e38:	0f 29 75 e0          	movaps %xmm6,-0x20(%rbp)
    1e3c:	0f 29 7d f0          	movaps %xmm7,-0x10(%rbp)
  va_list ap;
  int i, c;
  char *s;

  va_start(ap, fmt);
    1e40:	c7 85 20 ff ff ff 10 	movl   $0x10,-0xe0(%rbp)
    1e47:	00 00 00 
    1e4a:	c7 85 24 ff ff ff 30 	movl   $0x30,-0xdc(%rbp)
    1e51:	00 00 00 
    1e54:	48 8d 45 10          	lea    0x10(%rbp),%rax
    1e58:	48 89 85 28 ff ff ff 	mov    %rax,-0xd8(%rbp)
    1e5f:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
    1e66:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
    1e6d:	c7 85 4c ff ff ff 00 	movl   $0x0,-0xb4(%rbp)
    1e74:	00 00 00 
    1e77:	e9 41 03 00 00       	jmpq   21bd <printf+0x3d9>
    if (c != '%') {
    1e7c:	83 bd 3c ff ff ff 25 	cmpl   $0x25,-0xc4(%rbp)
    1e83:	74 24                	je     1ea9 <printf+0xc5>
      putc(fd, c);
    1e85:	8b 85 3c ff ff ff    	mov    -0xc4(%rbp),%eax
    1e8b:	0f be d0             	movsbl %al,%edx
    1e8e:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1e94:	89 d6                	mov    %edx,%esi
    1e96:	89 c7                	mov    %eax,%edi
    1e98:	48 b8 fe 1b 00 00 00 	movabs $0x1bfe,%rax
    1e9f:	00 00 00 
    1ea2:	ff d0                	callq  *%rax
      continue;
    1ea4:	e9 0d 03 00 00       	jmpq   21b6 <printf+0x3d2>
    }
    c = fmt[++i] & 0xff;
    1ea9:	83 85 4c ff ff ff 01 	addl   $0x1,-0xb4(%rbp)
    1eb0:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
    1eb6:	48 63 d0             	movslq %eax,%rdx
    1eb9:	48 8b 85 10 ff ff ff 	mov    -0xf0(%rbp),%rax
    1ec0:	48 01 d0             	add    %rdx,%rax
    1ec3:	0f b6 00             	movzbl (%rax),%eax
    1ec6:	0f be c0             	movsbl %al,%eax
    1ec9:	25 ff 00 00 00       	and    $0xff,%eax
    1ece:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%rbp)
    if (c == 0)
    1ed4:	83 bd 3c ff ff ff 00 	cmpl   $0x0,-0xc4(%rbp)
    1edb:	0f 84 0f 03 00 00    	je     21f0 <printf+0x40c>
      break;
    switch(c) {
    1ee1:	83 bd 3c ff ff ff 25 	cmpl   $0x25,-0xc4(%rbp)
    1ee8:	0f 84 74 02 00 00    	je     2162 <printf+0x37e>
    1eee:	83 bd 3c ff ff ff 25 	cmpl   $0x25,-0xc4(%rbp)
    1ef5:	0f 8c 82 02 00 00    	jl     217d <printf+0x399>
    1efb:	83 bd 3c ff ff ff 78 	cmpl   $0x78,-0xc4(%rbp)
    1f02:	0f 8f 75 02 00 00    	jg     217d <printf+0x399>
    1f08:	83 bd 3c ff ff ff 63 	cmpl   $0x63,-0xc4(%rbp)
    1f0f:	0f 8c 68 02 00 00    	jl     217d <printf+0x399>
    1f15:	8b 85 3c ff ff ff    	mov    -0xc4(%rbp),%eax
    1f1b:	83 e8 63             	sub    $0x63,%eax
    1f1e:	83 f8 15             	cmp    $0x15,%eax
    1f21:	0f 87 56 02 00 00    	ja     217d <printf+0x399>
    1f27:	89 c0                	mov    %eax,%eax
    1f29:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
    1f30:	00 
    1f31:	48 b8 38 26 00 00 00 	movabs $0x2638,%rax
    1f38:	00 00 00 
    1f3b:	48 01 d0             	add    %rdx,%rax
    1f3e:	48 8b 00             	mov    (%rax),%rax
    1f41:	3e ff e0             	notrack jmpq *%rax
    case 'c':
      putc(fd, va_arg(ap, int));
    1f44:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    1f4a:	83 f8 2f             	cmp    $0x2f,%eax
    1f4d:	77 23                	ja     1f72 <printf+0x18e>
    1f4f:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    1f56:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1f5c:	89 d2                	mov    %edx,%edx
    1f5e:	48 01 d0             	add    %rdx,%rax
    1f61:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1f67:	83 c2 08             	add    $0x8,%edx
    1f6a:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    1f70:	eb 12                	jmp    1f84 <printf+0x1a0>
    1f72:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    1f79:	48 8d 50 08          	lea    0x8(%rax),%rdx
    1f7d:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    1f84:	8b 00                	mov    (%rax),%eax
    1f86:	0f be d0             	movsbl %al,%edx
    1f89:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1f8f:	89 d6                	mov    %edx,%esi
    1f91:	89 c7                	mov    %eax,%edi
    1f93:	48 b8 fe 1b 00 00 00 	movabs $0x1bfe,%rax
    1f9a:	00 00 00 
    1f9d:	ff d0                	callq  *%rax
      break;
    1f9f:	e9 12 02 00 00       	jmpq   21b6 <printf+0x3d2>
    case 'd':
      print_d(fd, va_arg(ap, int));
    1fa4:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    1faa:	83 f8 2f             	cmp    $0x2f,%eax
    1fad:	77 23                	ja     1fd2 <printf+0x1ee>
    1faf:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    1fb6:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1fbc:	89 d2                	mov    %edx,%edx
    1fbe:	48 01 d0             	add    %rdx,%rax
    1fc1:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    1fc7:	83 c2 08             	add    $0x8,%edx
    1fca:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    1fd0:	eb 12                	jmp    1fe4 <printf+0x200>
    1fd2:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    1fd9:	48 8d 50 08          	lea    0x8(%rax),%rdx
    1fdd:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    1fe4:	8b 10                	mov    (%rax),%edx
    1fe6:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    1fec:	89 d6                	mov    %edx,%esi
    1fee:	89 c7                	mov    %eax,%edi
    1ff0:	48 b8 ec 1c 00 00 00 	movabs $0x1cec,%rax
    1ff7:	00 00 00 
    1ffa:	ff d0                	callq  *%rax
      break;
    1ffc:	e9 b5 01 00 00       	jmpq   21b6 <printf+0x3d2>
    case 'x':
      print_x32(fd, va_arg(ap, uint));
    2001:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    2007:	83 f8 2f             	cmp    $0x2f,%eax
    200a:	77 23                	ja     202f <printf+0x24b>
    200c:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    2013:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    2019:	89 d2                	mov    %edx,%edx
    201b:	48 01 d0             	add    %rdx,%rax
    201e:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    2024:	83 c2 08             	add    $0x8,%edx
    2027:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    202d:	eb 12                	jmp    2041 <printf+0x25d>
    202f:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    2036:	48 8d 50 08          	lea    0x8(%rax),%rdx
    203a:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    2041:	8b 10                	mov    (%rax),%edx
    2043:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    2049:	89 d6                	mov    %edx,%esi
    204b:	89 c7                	mov    %eax,%edi
    204d:	48 b8 8f 1c 00 00 00 	movabs $0x1c8f,%rax
    2054:	00 00 00 
    2057:	ff d0                	callq  *%rax
      break;
    2059:	e9 58 01 00 00       	jmpq   21b6 <printf+0x3d2>
    case 'p':
      print_x64(fd, va_arg(ap, addr_t));
    205e:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    2064:	83 f8 2f             	cmp    $0x2f,%eax
    2067:	77 23                	ja     208c <printf+0x2a8>
    2069:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    2070:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    2076:	89 d2                	mov    %edx,%edx
    2078:	48 01 d0             	add    %rdx,%rax
    207b:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    2081:	83 c2 08             	add    $0x8,%edx
    2084:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    208a:	eb 12                	jmp    209e <printf+0x2ba>
    208c:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    2093:	48 8d 50 08          	lea    0x8(%rax),%rdx
    2097:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    209e:	48 8b 10             	mov    (%rax),%rdx
    20a1:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    20a7:	48 89 d6             	mov    %rdx,%rsi
    20aa:	89 c7                	mov    %eax,%edi
    20ac:	48 b8 32 1c 00 00 00 	movabs $0x1c32,%rax
    20b3:	00 00 00 
    20b6:	ff d0                	callq  *%rax
      break;
    20b8:	e9 f9 00 00 00       	jmpq   21b6 <printf+0x3d2>
    case 's':
      if ((s = va_arg(ap, char*)) == 0)
    20bd:	8b 85 20 ff ff ff    	mov    -0xe0(%rbp),%eax
    20c3:	83 f8 2f             	cmp    $0x2f,%eax
    20c6:	77 23                	ja     20eb <printf+0x307>
    20c8:	48 8b 85 30 ff ff ff 	mov    -0xd0(%rbp),%rax
    20cf:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    20d5:	89 d2                	mov    %edx,%edx
    20d7:	48 01 d0             	add    %rdx,%rax
    20da:	8b 95 20 ff ff ff    	mov    -0xe0(%rbp),%edx
    20e0:	83 c2 08             	add    $0x8,%edx
    20e3:	89 95 20 ff ff ff    	mov    %edx,-0xe0(%rbp)
    20e9:	eb 12                	jmp    20fd <printf+0x319>
    20eb:	48 8b 85 28 ff ff ff 	mov    -0xd8(%rbp),%rax
    20f2:	48 8d 50 08          	lea    0x8(%rax),%rdx
    20f6:	48 89 95 28 ff ff ff 	mov    %rdx,-0xd8(%rbp)
    20fd:	48 8b 00             	mov    (%rax),%rax
    2100:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
    2107:	48 83 bd 40 ff ff ff 	cmpq   $0x0,-0xc0(%rbp)
    210e:	00 
    210f:	75 41                	jne    2152 <printf+0x36e>
        s = "(null)";
    2111:	48 b8 30 26 00 00 00 	movabs $0x2630,%rax
    2118:	00 00 00 
    211b:	48 89 85 40 ff ff ff 	mov    %rax,-0xc0(%rbp)
      while (*s)
    2122:	eb 2e                	jmp    2152 <printf+0x36e>
        putc(fd, *(s++));
    2124:	48 8b 85 40 ff ff ff 	mov    -0xc0(%rbp),%rax
    212b:	48 8d 50 01          	lea    0x1(%rax),%rdx
    212f:	48 89 95 40 ff ff ff 	mov    %rdx,-0xc0(%rbp)
    2136:	0f b6 00             	movzbl (%rax),%eax
    2139:	0f be d0             	movsbl %al,%edx
    213c:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    2142:	89 d6                	mov    %edx,%esi
    2144:	89 c7                	mov    %eax,%edi
    2146:	48 b8 fe 1b 00 00 00 	movabs $0x1bfe,%rax
    214d:	00 00 00 
    2150:	ff d0                	callq  *%rax
      while (*s)
    2152:	48 8b 85 40 ff ff ff 	mov    -0xc0(%rbp),%rax
    2159:	0f b6 00             	movzbl (%rax),%eax
    215c:	84 c0                	test   %al,%al
    215e:	75 c4                	jne    2124 <printf+0x340>
      break;
    2160:	eb 54                	jmp    21b6 <printf+0x3d2>
    case '%':
      putc(fd, '%');
    2162:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    2168:	be 25 00 00 00       	mov    $0x25,%esi
    216d:	89 c7                	mov    %eax,%edi
    216f:	48 b8 fe 1b 00 00 00 	movabs $0x1bfe,%rax
    2176:	00 00 00 
    2179:	ff d0                	callq  *%rax
      break;
    217b:	eb 39                	jmp    21b6 <printf+0x3d2>
    default:
      // Print unknown % sequence to draw attention.
      putc(fd, '%');
    217d:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    2183:	be 25 00 00 00       	mov    $0x25,%esi
    2188:	89 c7                	mov    %eax,%edi
    218a:	48 b8 fe 1b 00 00 00 	movabs $0x1bfe,%rax
    2191:	00 00 00 
    2194:	ff d0                	callq  *%rax
      putc(fd, c);
    2196:	8b 85 3c ff ff ff    	mov    -0xc4(%rbp),%eax
    219c:	0f be d0             	movsbl %al,%edx
    219f:	8b 85 1c ff ff ff    	mov    -0xe4(%rbp),%eax
    21a5:	89 d6                	mov    %edx,%esi
    21a7:	89 c7                	mov    %eax,%edi
    21a9:	48 b8 fe 1b 00 00 00 	movabs $0x1bfe,%rax
    21b0:	00 00 00 
    21b3:	ff d0                	callq  *%rax
      break;
    21b5:	90                   	nop
  for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
    21b6:	83 85 4c ff ff ff 01 	addl   $0x1,-0xb4(%rbp)
    21bd:	8b 85 4c ff ff ff    	mov    -0xb4(%rbp),%eax
    21c3:	48 63 d0             	movslq %eax,%rdx
    21c6:	48 8b 85 10 ff ff ff 	mov    -0xf0(%rbp),%rax
    21cd:	48 01 d0             	add    %rdx,%rax
    21d0:	0f b6 00             	movzbl (%rax),%eax
    21d3:	0f be c0             	movsbl %al,%eax
    21d6:	25 ff 00 00 00       	and    $0xff,%eax
    21db:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%rbp)
    21e1:	83 bd 3c ff ff ff 00 	cmpl   $0x0,-0xc4(%rbp)
    21e8:	0f 85 8e fc ff ff    	jne    1e7c <printf+0x98>
    }
  }
}
    21ee:	eb 01                	jmp    21f1 <printf+0x40d>
      break;
    21f0:	90                   	nop
}
    21f1:	90                   	nop
    21f2:	c9                   	leaveq 
    21f3:	c3                   	retq   

00000000000021f4 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    21f4:	f3 0f 1e fa          	endbr64 
    21f8:	55                   	push   %rbp
    21f9:	48 89 e5             	mov    %rsp,%rbp
    21fc:	48 83 ec 18          	sub    $0x18,%rsp
    2200:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  Header *bp, *p;

  bp = (Header*)ap - 1;
    2204:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    2208:	48 83 e8 10          	sub    $0x10,%rax
    220c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    2210:	48 b8 d0 29 00 00 00 	movabs $0x29d0,%rax
    2217:	00 00 00 
    221a:	48 8b 00             	mov    (%rax),%rax
    221d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    2221:	eb 2f                	jmp    2252 <free+0x5e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    2223:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    2227:	48 8b 00             	mov    (%rax),%rax
    222a:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
    222e:	72 17                	jb     2247 <free+0x53>
    2230:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    2234:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
    2238:	77 2f                	ja     2269 <free+0x75>
    223a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    223e:	48 8b 00             	mov    (%rax),%rax
    2241:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
    2245:	72 22                	jb     2269 <free+0x75>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    2247:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    224b:	48 8b 00             	mov    (%rax),%rax
    224e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    2252:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    2256:	48 3b 45 f8          	cmp    -0x8(%rbp),%rax
    225a:	76 c7                	jbe    2223 <free+0x2f>
    225c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    2260:	48 8b 00             	mov    (%rax),%rax
    2263:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
    2267:	73 ba                	jae    2223 <free+0x2f>
      break;
  if(bp + bp->s.size == p->s.ptr){
    2269:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    226d:	8b 40 08             	mov    0x8(%rax),%eax
    2270:	89 c0                	mov    %eax,%eax
    2272:	48 c1 e0 04          	shl    $0x4,%rax
    2276:	48 89 c2             	mov    %rax,%rdx
    2279:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    227d:	48 01 c2             	add    %rax,%rdx
    2280:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    2284:	48 8b 00             	mov    (%rax),%rax
    2287:	48 39 c2             	cmp    %rax,%rdx
    228a:	75 2d                	jne    22b9 <free+0xc5>
    bp->s.size += p->s.ptr->s.size;
    228c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    2290:	8b 50 08             	mov    0x8(%rax),%edx
    2293:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    2297:	48 8b 00             	mov    (%rax),%rax
    229a:	8b 40 08             	mov    0x8(%rax),%eax
    229d:	01 c2                	add    %eax,%edx
    229f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    22a3:	89 50 08             	mov    %edx,0x8(%rax)
    bp->s.ptr = p->s.ptr->s.ptr;
    22a6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    22aa:	48 8b 00             	mov    (%rax),%rax
    22ad:	48 8b 10             	mov    (%rax),%rdx
    22b0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    22b4:	48 89 10             	mov    %rdx,(%rax)
    22b7:	eb 0e                	jmp    22c7 <free+0xd3>
  } else
    bp->s.ptr = p->s.ptr;
    22b9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    22bd:	48 8b 10             	mov    (%rax),%rdx
    22c0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    22c4:	48 89 10             	mov    %rdx,(%rax)
  if(p + p->s.size == bp){
    22c7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    22cb:	8b 40 08             	mov    0x8(%rax),%eax
    22ce:	89 c0                	mov    %eax,%eax
    22d0:	48 c1 e0 04          	shl    $0x4,%rax
    22d4:	48 89 c2             	mov    %rax,%rdx
    22d7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    22db:	48 01 d0             	add    %rdx,%rax
    22de:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
    22e2:	75 27                	jne    230b <free+0x117>
    p->s.size += bp->s.size;
    22e4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    22e8:	8b 50 08             	mov    0x8(%rax),%edx
    22eb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    22ef:	8b 40 08             	mov    0x8(%rax),%eax
    22f2:	01 c2                	add    %eax,%edx
    22f4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    22f8:	89 50 08             	mov    %edx,0x8(%rax)
    p->s.ptr = bp->s.ptr;
    22fb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    22ff:	48 8b 10             	mov    (%rax),%rdx
    2302:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    2306:	48 89 10             	mov    %rdx,(%rax)
    2309:	eb 0b                	jmp    2316 <free+0x122>
  } else
    p->s.ptr = bp;
    230b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    230f:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
    2313:	48 89 10             	mov    %rdx,(%rax)
  freep = p;
    2316:	48 ba d0 29 00 00 00 	movabs $0x29d0,%rdx
    231d:	00 00 00 
    2320:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    2324:	48 89 02             	mov    %rax,(%rdx)
}
    2327:	90                   	nop
    2328:	c9                   	leaveq 
    2329:	c3                   	retq   

000000000000232a <morecore>:

static Header*
morecore(uint nu)
{
    232a:	f3 0f 1e fa          	endbr64 
    232e:	55                   	push   %rbp
    232f:	48 89 e5             	mov    %rsp,%rbp
    2332:	48 83 ec 20          	sub    $0x20,%rsp
    2336:	89 7d ec             	mov    %edi,-0x14(%rbp)
  char *p;
  Header *hp;

  if(nu < 4096)
    2339:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%rbp)
    2340:	77 07                	ja     2349 <morecore+0x1f>
    nu = 4096;
    2342:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%rbp)
  p = sbrk(nu * sizeof(Header));
    2349:	8b 45 ec             	mov    -0x14(%rbp),%eax
    234c:	48 c1 e0 04          	shl    $0x4,%rax
    2350:	48 89 c7             	mov    %rax,%rdi
    2353:	48 b8 ca 1b 00 00 00 	movabs $0x1bca,%rax
    235a:	00 00 00 
    235d:	ff d0                	callq  *%rax
    235f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  if(p == (char*)-1)
    2363:	48 83 7d f8 ff       	cmpq   $0xffffffffffffffff,-0x8(%rbp)
    2368:	75 07                	jne    2371 <morecore+0x47>
    return 0;
    236a:	b8 00 00 00 00       	mov    $0x0,%eax
    236f:	eb 36                	jmp    23a7 <morecore+0x7d>
  hp = (Header*)p;
    2371:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    2375:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  hp->s.size = nu;
    2379:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    237d:	8b 55 ec             	mov    -0x14(%rbp),%edx
    2380:	89 50 08             	mov    %edx,0x8(%rax)
  free((void*)(hp + 1));
    2383:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    2387:	48 83 c0 10          	add    $0x10,%rax
    238b:	48 89 c7             	mov    %rax,%rdi
    238e:	48 b8 f4 21 00 00 00 	movabs $0x21f4,%rax
    2395:	00 00 00 
    2398:	ff d0                	callq  *%rax
  return freep;
    239a:	48 b8 d0 29 00 00 00 	movabs $0x29d0,%rax
    23a1:	00 00 00 
    23a4:	48 8b 00             	mov    (%rax),%rax
}
    23a7:	c9                   	leaveq 
    23a8:	c3                   	retq   

00000000000023a9 <malloc>:

void*
malloc(uint nbytes)
{
    23a9:	f3 0f 1e fa          	endbr64 
    23ad:	55                   	push   %rbp
    23ae:	48 89 e5             	mov    %rsp,%rbp
    23b1:	48 83 ec 30          	sub    $0x30,%rsp
    23b5:	89 7d dc             	mov    %edi,-0x24(%rbp)
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    23b8:	8b 45 dc             	mov    -0x24(%rbp),%eax
    23bb:	48 83 c0 0f          	add    $0xf,%rax
    23bf:	48 c1 e8 04          	shr    $0x4,%rax
    23c3:	83 c0 01             	add    $0x1,%eax
    23c6:	89 45 ec             	mov    %eax,-0x14(%rbp)
  if((prevp = freep) == 0){
    23c9:	48 b8 d0 29 00 00 00 	movabs $0x29d0,%rax
    23d0:	00 00 00 
    23d3:	48 8b 00             	mov    (%rax),%rax
    23d6:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    23da:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
    23df:	75 4a                	jne    242b <malloc+0x82>
    base.s.ptr = freep = prevp = &base;
    23e1:	48 b8 c0 29 00 00 00 	movabs $0x29c0,%rax
    23e8:	00 00 00 
    23eb:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    23ef:	48 ba d0 29 00 00 00 	movabs $0x29d0,%rdx
    23f6:	00 00 00 
    23f9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    23fd:	48 89 02             	mov    %rax,(%rdx)
    2400:	48 b8 d0 29 00 00 00 	movabs $0x29d0,%rax
    2407:	00 00 00 
    240a:	48 8b 00             	mov    (%rax),%rax
    240d:	48 ba c0 29 00 00 00 	movabs $0x29c0,%rdx
    2414:	00 00 00 
    2417:	48 89 02             	mov    %rax,(%rdx)
    base.s.size = 0;
    241a:	48 b8 c0 29 00 00 00 	movabs $0x29c0,%rax
    2421:	00 00 00 
    2424:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%rax)
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    242b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    242f:	48 8b 00             	mov    (%rax),%rax
    2432:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    if(p->s.size >= nunits){
    2436:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    243a:	8b 40 08             	mov    0x8(%rax),%eax
    243d:	39 45 ec             	cmp    %eax,-0x14(%rbp)
    2440:	77 65                	ja     24a7 <malloc+0xfe>
      if(p->s.size == nunits)
    2442:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    2446:	8b 40 08             	mov    0x8(%rax),%eax
    2449:	39 45 ec             	cmp    %eax,-0x14(%rbp)
    244c:	75 10                	jne    245e <malloc+0xb5>
        prevp->s.ptr = p->s.ptr;
    244e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    2452:	48 8b 10             	mov    (%rax),%rdx
    2455:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    2459:	48 89 10             	mov    %rdx,(%rax)
    245c:	eb 2e                	jmp    248c <malloc+0xe3>
      else {
        p->s.size -= nunits;
    245e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    2462:	8b 40 08             	mov    0x8(%rax),%eax
    2465:	2b 45 ec             	sub    -0x14(%rbp),%eax
    2468:	89 c2                	mov    %eax,%edx
    246a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    246e:	89 50 08             	mov    %edx,0x8(%rax)
        p += p->s.size;
    2471:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    2475:	8b 40 08             	mov    0x8(%rax),%eax
    2478:	89 c0                	mov    %eax,%eax
    247a:	48 c1 e0 04          	shl    $0x4,%rax
    247e:	48 01 45 f8          	add    %rax,-0x8(%rbp)
        p->s.size = nunits;
    2482:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    2486:	8b 55 ec             	mov    -0x14(%rbp),%edx
    2489:	89 50 08             	mov    %edx,0x8(%rax)
      }
      freep = prevp;
    248c:	48 ba d0 29 00 00 00 	movabs $0x29d0,%rdx
    2493:	00 00 00 
    2496:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
    249a:	48 89 02             	mov    %rax,(%rdx)
      return (void*)(p + 1);
    249d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    24a1:	48 83 c0 10          	add    $0x10,%rax
    24a5:	eb 4e                	jmp    24f5 <malloc+0x14c>
    }
    if(p == freep)
    24a7:	48 b8 d0 29 00 00 00 	movabs $0x29d0,%rax
    24ae:	00 00 00 
    24b1:	48 8b 00             	mov    (%rax),%rax
    24b4:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
    24b8:	75 23                	jne    24dd <malloc+0x134>
      if((p = morecore(nunits)) == 0)
    24ba:	8b 45 ec             	mov    -0x14(%rbp),%eax
    24bd:	89 c7                	mov    %eax,%edi
    24bf:	48 b8 2a 23 00 00 00 	movabs $0x232a,%rax
    24c6:	00 00 00 
    24c9:	ff d0                	callq  *%rax
    24cb:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    24cf:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
    24d4:	75 07                	jne    24dd <malloc+0x134>
        return 0;
    24d6:	b8 00 00 00 00       	mov    $0x0,%eax
    24db:	eb 18                	jmp    24f5 <malloc+0x14c>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    24dd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    24e1:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    24e5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    24e9:	48 8b 00             	mov    (%rax),%rax
    24ec:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    if(p->s.size >= nunits){
    24f0:	e9 41 ff ff ff       	jmpq   2436 <malloc+0x8d>
  }
}
    24f5:	c9                   	leaveq 
    24f6:	c3                   	retq   

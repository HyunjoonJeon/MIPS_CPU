
7-ctests/find_positiveeq/find_positiveeq.mips.elf:     file format elf32-tradlittlemips


Disassembly of section .text:

bfc00000 <findpostiveeq>:
bfc00000:	27bdffb8 	addiu	sp,sp,-72
bfc00004:	afbe0044 	sw	s8,68(sp)
bfc00008:	03a0f025 	move	s8,sp
bfc0000c:	afc00008 	sw	zero,8(s8)
bfc00010:	1000000e 	b	bfc0004c <findpostiveeq+0x4c>
bfc00014:	00000000 	nop
bfc00018:	8fc20008 	lw	v0,8(s8)
bfc0001c:	00000000 	nop
bfc00020:	2443fffb 	addiu	v1,v0,-5
bfc00024:	8fc20008 	lw	v0,8(s8)
bfc00028:	00000000 	nop
bfc0002c:	00021080 	sll	v0,v0,0x2
bfc00030:	27c40008 	addiu	a0,s8,8
bfc00034:	00821021 	addu	v0,a0,v0
bfc00038:	ac43000c 	sw	v1,12(v0)
bfc0003c:	8fc20008 	lw	v0,8(s8)
bfc00040:	00000000 	nop
bfc00044:	24420001 	addiu	v0,v0,1
bfc00048:	afc20008 	sw	v0,8(s8)
bfc0004c:	8fc20008 	lw	v0,8(s8)
bfc00050:	00000000 	nop
bfc00054:	2842000a 	slti	v0,v0,10
bfc00058:	1440ffef 	bnez	v0,bfc00018 <findpostiveeq+0x18>
bfc0005c:	00000000 	nop
bfc00060:	afc0000c 	sw	zero,12(s8)
bfc00064:	afc00010 	sw	zero,16(s8)
bfc00068:	10000012 	b	bfc000b4 <findpostiveeq+0xb4>
bfc0006c:	00000000 	nop
bfc00070:	8fc20010 	lw	v0,16(s8)
bfc00074:	00000000 	nop
bfc00078:	00021080 	sll	v0,v0,0x2
bfc0007c:	27c30008 	addiu	v1,s8,8
bfc00080:	00621021 	addu	v0,v1,v0
bfc00084:	8c42000c 	lw	v0,12(v0)
bfc00088:	00000000 	nop
bfc0008c:	04400005 	bltz	v0,bfc000a4 <findpostiveeq+0xa4>
bfc00090:	00000000 	nop
bfc00094:	8fc2000c 	lw	v0,12(s8)
bfc00098:	00000000 	nop
bfc0009c:	24420001 	addiu	v0,v0,1
bfc000a0:	afc2000c 	sw	v0,12(s8)
bfc000a4:	8fc20010 	lw	v0,16(s8)
bfc000a8:	00000000 	nop
bfc000ac:	24420001 	addiu	v0,v0,1
bfc000b0:	afc20010 	sw	v0,16(s8)
bfc000b4:	8fc20010 	lw	v0,16(s8)
bfc000b8:	00000000 	nop
bfc000bc:	2842000a 	slti	v0,v0,10
bfc000c0:	1440ffeb 	bnez	v0,bfc00070 <findpostiveeq+0x70>
bfc000c4:	00000000 	nop
bfc000c8:	8fc2000c 	lw	v0,12(s8)
bfc000cc:	03c0e825 	move	sp,s8
bfc000d0:	8fbe0044 	lw	s8,68(sp)
bfc000d4:	27bd0048 	addiu	sp,sp,72
bfc000d8:	03e00008 	jr	ra
bfc000dc:	00000000 	nop

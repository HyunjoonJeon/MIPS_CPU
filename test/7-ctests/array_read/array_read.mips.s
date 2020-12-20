
7-ctests/array_read/array_read.mips.elf:     file format elf32-tradlittlemips


Disassembly of section .text:

bfc00000 <arrayread>:
bfc00000:	27bdffb8 	addiu	sp,sp,-72
bfc00004:	afbe0044 	sw	s8,68(sp)
bfc00008:	03a0f025 	move	s8,sp
bfc0000c:	afc00008 	sw	zero,8(s8)
bfc00010:	1000000d 	b	bfc00048 <arrayread+0x48>
bfc00014:	00000000 	nop
bfc00018:	8fc20008 	lw	v0,8(s8)
bfc0001c:	00000000 	nop
bfc00020:	00021080 	sll	v0,v0,0x2
bfc00024:	27c30008 	addiu	v1,s8,8
bfc00028:	00621021 	addu	v0,v1,v0
bfc0002c:	8fc30008 	lw	v1,8(s8)
bfc00030:	00000000 	nop
bfc00034:	ac43000c 	sw	v1,12(v0)
bfc00038:	8fc20008 	lw	v0,8(s8)
bfc0003c:	00000000 	nop
bfc00040:	24420001 	addiu	v0,v0,1
bfc00044:	afc20008 	sw	v0,8(s8)
bfc00048:	8fc20008 	lw	v0,8(s8)
bfc0004c:	00000000 	nop
bfc00050:	2842000a 	slti	v0,v0,10
bfc00054:	1440fff0 	bnez	v0,bfc00018 <arrayread+0x18>
bfc00058:	00000000 	nop
bfc0005c:	afc0000c 	sw	zero,12(s8)
bfc00060:	afc00010 	sw	zero,16(s8)
bfc00064:	10000015 	b	bfc000bc <arrayread+0xbc>
bfc00068:	00000000 	nop
bfc0006c:	8fc20010 	lw	v0,16(s8)
bfc00070:	00000000 	nop
bfc00074:	00021080 	sll	v0,v0,0x2
bfc00078:	27c30008 	addiu	v1,s8,8
bfc0007c:	00621021 	addu	v0,v1,v0
bfc00080:	8c42000c 	lw	v0,12(v0)
bfc00084:	8fc30010 	lw	v1,16(s8)
bfc00088:	00000000 	nop
bfc0008c:	10620004 	beq	v1,v0,bfc000a0 <arrayread+0xa0>
bfc00090:	00000000 	nop
bfc00094:	24020001 	li	v0,1
bfc00098:	1000000e 	b	bfc000d4 <arrayread+0xd4>
bfc0009c:	00000000 	nop
bfc000a0:	8fc20010 	lw	v0,16(s8)
bfc000a4:	00000000 	nop
bfc000a8:	afc2000c 	sw	v0,12(s8)
bfc000ac:	8fc20010 	lw	v0,16(s8)
bfc000b0:	00000000 	nop
bfc000b4:	24420001 	addiu	v0,v0,1
bfc000b8:	afc20010 	sw	v0,16(s8)
bfc000bc:	8fc20010 	lw	v0,16(s8)
bfc000c0:	00000000 	nop
bfc000c4:	2842000a 	slti	v0,v0,10
bfc000c8:	1440ffe8 	bnez	v0,bfc0006c <arrayread+0x6c>
bfc000cc:	00000000 	nop
bfc000d0:	8fc2000c 	lw	v0,12(s8)
bfc000d4:	03c0e825 	move	sp,s8
bfc000d8:	8fbe0044 	lw	s8,68(sp)
bfc000dc:	27bd0048 	addiu	sp,sp,72
bfc000e0:	03e00008 	jr	ra
bfc000e4:	00000000 	nop
	...


7-ctests/factorial/factorial.mips.elf:     file format elf32-tradlittlemips


Disassembly of section .text:

bfc00000 <fact>:
bfc00000:	27bdffe0 	addiu	sp,sp,-32
bfc00004:	afbe001c 	sw	s8,28(sp)
bfc00008:	03a0f025 	move	s8,sp
bfc0000c:	24020005 	li	v0,5
bfc00010:	afc20010 	sw	v0,16(s8)
bfc00014:	24020001 	li	v0,1
bfc00018:	afc20008 	sw	v0,8(s8)
bfc0001c:	afc0000c 	sw	zero,12(s8)
bfc00020:	1000000b 	b	bfc00050 <fact+0x50>
bfc00024:	00000000 	nop
bfc00028:	8fc30008 	lw	v1,8(s8)
bfc0002c:	8fc2000c 	lw	v0,12(s8)
bfc00030:	00000000 	nop
bfc00034:	00620018 	mult	v1,v0
bfc00038:	00001012 	mflo	v0
bfc0003c:	afc20008 	sw	v0,8(s8)
bfc00040:	8fc2000c 	lw	v0,12(s8)
bfc00044:	00000000 	nop
bfc00048:	24420001 	addiu	v0,v0,1
bfc0004c:	afc2000c 	sw	v0,12(s8)
bfc00050:	8fc3000c 	lw	v1,12(s8)
bfc00054:	8fc20010 	lw	v0,16(s8)
bfc00058:	00000000 	nop
bfc0005c:	0043102a 	slt	v0,v0,v1
bfc00060:	1040fff1 	beqz	v0,bfc00028 <fact+0x28>
bfc00064:	00000000 	nop
bfc00068:	8fc20008 	lw	v0,8(s8)
bfc0006c:	03c0e825 	move	sp,s8
bfc00070:	8fbe001c 	lw	s8,28(sp)
bfc00074:	27bd0020 	addiu	sp,sp,32
bfc00078:	03e00008 	jr	ra
bfc0007c:	00000000 	nop

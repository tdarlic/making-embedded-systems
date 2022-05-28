printf@plt:
 add	ip, pc, #0, 12
 add	ip, ip, #126976	; 0x1f000
 ldr	pc, [ip, #3120]!	; 0xc30
memcpy@plt:
 add	ip, pc, #0, 12
 add	ip, ip, #126976	; 0x1f000
 ldr	pc, [ip, #3112]!	; 0xc28
time@plt:
 add	ip, pc, #0, 12
 add	ip, ip, #126976	; 0x1f000
 ldr	pc, [ip, #3104]!	; 0xc20
puts@plt:
 add	ip, pc, #0, 12
 add	ip, ip, #126976	; 0x1f000
 ldr	pc, [ip, #3096]!	; 0xc18
srand@plt:
 add	ip, pc, #0, 12
 add	ip, ip, #126976	; 0x1f000
 ldr	pc, [ip, #3080]!	; 0xc08
rand@plt:
 add	ip, pc, #0, 12
 add	ip, ip, #126976	; 0x1f000
 ldr	pc, [ip, #3072]!	; 0xc00
abort@plt:
 add	ip, pc, #0, 12
 add	ip, ip, #126976	; 0x1f000
 ldr	pc, [ip, #3064]!	; 0xbf8
call_weak_fn:
 ldr	r3, [pc, #20]	; 10488 <call_weak_fn+0x1c>
 ldr	r2, [pc, #20]	; 1048c <call_weak_fn+0x20>
 add	r3, pc, r3
 ldr	r2, [r3, r2]
 cmp	r2, #0
 bxeq	lr
 b	10408 <__gmon_start__@plt>
 .word	0x0001fb84
 .word	0x00000030
countOnesA:
 push	{r4, lr}
 sub	sp, #256	; 0x100
 mov	r4, r0
 mov.w	r2, #256	; 0x100
 movw	r1, #2228	; 0x8b4
 movt	r1, #1
 mov	r0, sp
 blx	103e4 <memcpy@plt>
 lsrs	r2, r4, #24
 uxtb	r3, r4
 ldrb.w	r0, [sp, r2]
 ldrb.w	r3, [sp, r3]
 add	r0, r3
 ubfx	r3, r4, #16, #8
 ldrb.w	r3, [sp, r3]
 add	r0, r3
 ubfx	r4, r4, #8, #8
 ldrb.w	r3, [sp, r4]
 add	r0, r3
 uxtb	r0, r0
 add	sp, #256	; 0x100
 pop	{r4, pc}
countOnesB:
 mov	r3, r0
 cbz	r0, 1053a <countOnesB+0xe>
 movs	r0, #0
 subs	r2, r3, #1
 adds	r0, #1
 ands	r3, r2
 bne.n	10532 <countOnesB+0x6>
 uxtb	r0, r0
 bx	lr
countOnesC:
 movw	r3, #46811	; 0xb6db
 movt	r3, #56173	; 0xdb6d
 and.w	r3, r3, r0, lsr #1
 movw	r2, #37449	; 0x9249
 movt	r2, #18724	; 0x4924
 and.w	r2, r2, r0, lsr #2
 add	r3, r2
 subs	r0, r0, r3
 add.w	r0, r0, r0, lsr #3
 movw	r3, #29127	; 0x71c7
 movt	r3, #50972	; 0xc71c
 ands	r0, r3
 movw	r3, #16645	; 0x4105
 movt	r3, #1040	; 0x410
 umull	r2, r3, r3, r0
 subs	r2, r0, r3
 add.w	r3, r3, r2, lsr #1
 lsrs	r3, r3, #5
 rsb	r3, r3, r3, lsl #6
 subs	r0, r0, r3
 uxtb	r0, r0
 bx	lr
countOnesD:
 and.w	r3, r0, #1431655765	; 0x55555555
 lsrs	r0, r0, #1
 and.w	r0, r0, #1431655765	; 0x55555555
 add	r3, r0
 and.w	r2, r3, #858993459	; 0x33333333
 lsrs	r3, r3, #2
 and.w	r3, r3, #858993459	; 0x33333333
 add	r2, r3
 and.w	r3, r2, #252645135	; 0xf0f0f0f
 lsrs	r2, r2, #4
 and.w	r2, r2, #252645135	; 0xf0f0f0f
 add	r3, r2
 and.w	r0, r3, #16711935	; 0xff00ff
 lsrs	r3, r3, #8
 and.w	r3, r3, #16711935	; 0xff00ff
 add	r0, r3
 add.w	r0, r0, r0, lsr #16
 uxtb	r0, r0
 bx	lr
countOnesE:
 lsrs	r3, r0, #1
 and.w	r3, r3, #1431655765	; 0x55555555
 subs	r3, r0, r3
 lsrs	r0, r3, #2
 and.w	r0, r0, #858993459	; 0x33333333
 and.w	r3, r3, #858993459	; 0x33333333
 add	r0, r3
 add.w	r0, r0, r0, lsr #4
 and.w	r0, r0, #252645135	; 0xf0f0f0f
 add.w	r0, r0, r0, lsr #8
 add.w	r0, r0, r0, lsr #16
 uxtb	r0, r0
 bx	lr
countOnesF:
 mov	r2, r0
 movs	r3, #32
 movs	r0, #0
 tst.w	r2, #1
 itt	ne
 addne	r0, #1
 uxtbne	r0, r0
 lsrs	r2, r2, #1
 subs	r3, #1
 ands.w	r3, r3, #255	; 0xff
 bne.n	105ec <countOnesF+0x6>
 bx	lr
main:
 stmdb	sp!, {r4, r5, r6, r7, r8, r9, lr}
 sub.w	sp, sp, #3997696	; 0x3d0000
 subw	sp, sp, #2308	; 0x904
 cmp	r0, #1
 beq.n	106ce <main+0xcc>
 mov.w	r3, #2863311530	; 0xaaaaaaaa
 str	r3, [sp, #0]
 movw	r0, #2012	; 0x7dc
 movt	r0, #1
 blx	103fc <puts@plt>
 movs	r6, #1
 mov	r5, sp
 add.w	r6, r5, r6, lsl #2
 movw	r9, #2036	; 0x7f4
 movt	r9, #1
 movw	r8, #2084	; 0x824
 movt	r8, #1
 movw	r7, #2108	; 0x83c
 movt	r7, #1
 ldr.w	r4, [r5], #4
 mov	r1, r4
 mov	r0, r9
 blx	103d8 <printf@plt>
 mov	r0, r4
 bl	104ec <countOnesA>
 mov	r1, r0
 mov	r0, r8
 blx	103d8 <printf@plt>
 mov	r0, r4
 bl	1052c <countOnesB>
 mov	r1, r0
 mov	r0, r7
 blx	103d8 <printf@plt>
 mov	r0, r4
 bl	1053e <countOnesC>
 mov	r1, r0
 movw	r0, #2132	; 0x854
 movt	r0, #1
 blx	103d8 <printf@plt>
 mov	r0, r4
 bl	10586 <countOnesD>
 mov	r1, r0
 movw	r0, #2156	; 0x86c
 movt	r0, #1
 blx	103d8 <printf@plt>
 mov	r0, r4
 bl	105be <countOnesE>
 mov	r1, r0
 movw	r0, #2180	; 0x884
 movt	r0, #1
 blx	103d8 <printf@plt>
 mov	r0, r4
 bl	105e6 <countOnesF>
 mov	r1, r0
 movw	r0, #2204	; 0x89c
 movt	r0, #1
 blx	103d8 <printf@plt>
 cmp	r6, r5
 bne.n	10644 <main+0x42>
 movs	r0, #0
 add.w	sp, sp, #3997696	; 0x3d0000
 addw	sp, sp, #2308	; 0x904
 ldmia.w	sp!, {r4, r5, r6, r7, r8, r9, pc}
 movw	r1, #16960	; 0x4240
 movt	r1, #15
 movw	r0, #1976	; 0x7b8
 movt	r0, #1
 blx	103d8 <printf@plt>
 movs	r0, #0
 blx	103f0 <time@plt>
 blx	10414 <srand@plt>
 add.w	r3, sp, #2304	; 0x900
 sub.w	r4, sp, #4
 movw	r5, #65532	; 0xfffc
 movt	r5, #60	; 0x3c
 add	r5, r3
 blx	10420 <rand@plt>
 cmp.w	r0, #4294967295	; 0xffffffff
 it	cs
 addcs	r0, #1
 str.w	r0, [r4, #4]!
 cmp	r4, r5
 bne.n	106fe <main+0xfc>
 movw	r6, #16960	; 0x4240
 movt	r6, #15
 b.n	10626 <main+0x24>

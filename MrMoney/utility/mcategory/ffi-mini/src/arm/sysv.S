/* -----------------------------------------------------------------------
   sysv.S - Copyright (c) 1998, 2008, 2011 Red Hat, Inc.
	    Copyright (c) 2011 Plausible Labs Cooperative, Inc.
   
   ARM Foreign Function Interface 

   Permission is hereby granted, free of charge, to any person obtaining
   a copy of this software and associated documentation files (the
   ``Software''), to deal in the Software without restriction, including
   without limitation the rights to use, copy, modify, merge, publish,
   distribute, sublicense, and/or sell copies of the Software, and to
   permit persons to whom the Software is furnished to do so, subject to
   the following conditions:

   The above copyright notice and this permission notice shall be included
   in all copies or substantial portions of the Software.

   THE SOFTWARE IS PROVIDED ``AS IS'', WITHOUT WARRANTY OF ANY KIND,
   EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
   MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
   NONINFRINGEMENT.  IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
   HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
   WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
   OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
   DEALINGS IN THE SOFTWARE.
   ----------------------------------------------------------------------- */

#ifdef __arm__

#define LIBFFI_ASM	
#include "fficonfig_mini.h"
#include "ffi_mini.h"
#ifdef HAVE_MACHINE_ASM_H
#include <machine/asm.h>
#else
#ifdef __USER_LABEL_PREFIX__
#define CONCAT1(a, b) CONCAT2(a, b)
#define CONCAT2(a, b) a ## b

/* Use the right prefix for global labels.  */
#define CNAME(x) CONCAT1 (__USER_LABEL_PREFIX__, x)
#else
#define CNAME(x) x
#endif
#ifdef __APPLE__
#define ENTRY(x) .globl _##x; _##x:
#else
#define ENTRY(x) .globl CNAME(x); .type CNAME(x),%function; CNAME(x):
#endif /* __APPLE__ */
#endif

#ifdef __ELF__
#define LSYM(x) .x
#else
#define LSYM(x) x
#endif

/* Use the SOFTFP return value ABI on Mac OS X, as per the iOS ABI
  Function Call Guide */
#ifdef __APPLE__
#define __SOFTFP__
#endif

/* We need a better way of testing for this, but for now, this is all 
   we can do.  */
@ This selects the minimum architecture level required.
#define __ARM_ARCH__ 3

#if defined(__ARM_ARCH_4__) || defined(__ARM_ARCH_4T__)
# undef __ARM_ARCH__
# define __ARM_ARCH__ 4
#endif
        
#if defined(__ARM_ARCH_5__) || defined(__ARM_ARCH_5T__) \
	|| defined(__ARM_ARCH_5E__) || defined(__ARM_ARCH_5TE__) \
	|| defined(__ARM_ARCH_5TEJ__)
# undef __ARM_ARCH__
# define __ARM_ARCH__ 5
#endif

#if defined(__ARM_ARCH_6__) || defined(__ARM_ARCH_6J__) \
        || defined(__ARM_ARCH_6K__) || defined(__ARM_ARCH_6Z__) \
        || defined(__ARM_ARCH_6ZK__) || defined(__ARM_ARCH_6T2__) \
	|| defined(__ARM_ARCH_6M__)
# undef __ARM_ARCH__
# define __ARM_ARCH__ 6
#endif

#if defined(__ARM_ARCH_7__) || defined(__ARM_ARCH_7A__) \
        || defined(__ARM_ARCH_7R__) || defined(__ARM_ARCH_7M__) \
	|| defined(__ARM_ARCH_7EM__)
# undef __ARM_ARCH__
# define __ARM_ARCH__ 7
#endif

#if __ARM_ARCH__ >= 5
# define call_reg(x)	blx	x
#elif defined (__ARM_ARCH_4T__)
# define call_reg(x)	mov	lr, pc ; bx	x
# if defined(__thumb__) || defined(__THUMB_INTERWORK__)
#  define __INTERWORKING__
# endif
#else
# define call_reg(x)	mov	lr, pc ; mov	pc, x
#endif

/* Conditionally compile unwinder directives.  */
#ifdef __ARM_EABI__
#define UNWIND
#else
#define UNWIND @
#endif	

.syntax unified

#if defined(__thumb__) && !defined(__THUMB_INTERWORK__)
#define ARM_FUNC_START(name) \
	.text; \
	.align 2; \
	.thumb; \
	.thumb_func; \
	ENTRY(name); \
	bx pc; \
	nop; \
	.arm; \
	UNWIND .fnstart; \
_L__##name:
#else
#define ARM_FUNC_START(name) \
	.text; \
	.align 2; \
	.arm; \
	ENTRY(name); \
	UNWIND .fnstart
#endif

.macro	RETLDM	regs=, cond=, dirn=ia
#if defined (__INTERWORKING__)
	.ifc "\regs",""
	ldr\cond	lr, [sp], #4
	.else
	ldm\cond\dirn	sp!, {\regs, lr}
	.endif
	bx\cond	lr
#else
	.ifc "\regs",""
	ldr\cond	pc, [sp], #4
	.else
	ldm\cond\dirn	sp!, {\regs, pc}
	.endif
#endif
.endm

	@ r0:   ffi_mini_prep_args
	@ r1:   &ecif
	@ r2:   cif->bytes
	@ r3:   fig->flags
	@ sp+0: ecif.rvalue

	@ This assumes we are using gas.
ARM_FUNC_START(ffi_mini_call_SYSV)
	@ Save registers
        stmfd	sp!, {r0-r3, fp, lr}
	UNWIND .save	{r0-r3, fp, lr}
	mov	fp, sp

	UNWIND .setfp	fp, sp

	@ Make room for all of the new args.
	sub	sp, fp, r2

	@ Place all of the ffi_mini_prep_args in position
	mov	r0, sp
	@     r1 already set

	@ Call ffi_mini_prep_args(stack, &ecif)
	bl	CNAME(ffi_mini_prep_args_SYSV)

	@ move first 4 parameters in registers
	ldmia	sp, {r0-r3}

	@ and adjust stack
	sub	lr, fp, sp	@ cif->bytes == fp - sp
	ldr	ip, [fp]	@ load fn() in advance
	cmp	lr, #16
	movhs	lr, #16
	add	sp, sp, lr

	@ call (fn) (...)
	call_reg(ip)
	
	@ Remove the space we pushed for the args
	mov	sp, fp

	@ Load r2 with the pointer to storage for the return value
	ldr	r2, [sp, #24]

	@ Load r3 with the return type code 
	ldr	r3, [sp, #12]

	@ If the return value pointer is NULL, assume no return value.
	cmp	r2, #0
	beq	LSYM(Lepilogue)

@ return INT
	cmp	r3, #FFIM_TYPE_INT
#if defined(__SOFTFP__) || defined(__ARM_EABI__)
	cmpne	r3, #FFIM_TYPE_FLOAT
#endif
	streq	r0, [r2]
	beq	LSYM(Lepilogue)

	@ return INT64
	cmp	r3, #FFIM_TYPE_SINT64
#if defined(__SOFTFP__) || defined(__ARM_EABI__)
	cmpne	r3, #FFIM_TYPE_DOUBLE
#endif
	stmiaeq	r2, {r0, r1}

#if !defined(__SOFTFP__) && !defined(__ARM_EABI__)
	beq	LSYM(Lepilogue)

@ return FLOAT
	cmp	r3, #FFIM_TYPE_FLOAT
	stfeqs	f0, [r2]
	beq	LSYM(Lepilogue)

@ return DOUBLE or LONGDOUBLE
	cmp	r3, #FFIM_TYPE_DOUBLE
	stfeqd	f0, [r2]
#endif

LSYM(Lepilogue):
#if defined (__INTERWORKING__)
	ldmia   sp!, {r0-r3,fp, lr}
	bx	lr
#else
	ldmia   sp!, {r0-r3,fp, pc}
#endif

.ffi_mini_call_SYSV_end:
	UNWIND .fnend
#ifdef __ELF__
        .size    CNAME(ffi_mini_call_SYSV),.ffi_mini_call_SYSV_end-CNAME(ffi_mini_call_SYSV)
#endif


/* Below is the VFP hard-float ABI call implementation.
   Add VFP FPU directive here. This is only compiled into the library
   under EABI.  */
#ifdef __ARM_EABI__
	.fpu	vfp

	@ r0:   fn
	@ r1:   &ecif
	@ r2:   cif->bytes
	@ r3:   fig->flags
	@ sp+0: ecif.rvalue

ARM_FUNC_START(ffi_mini_call_VFP)
	@ Save registers
        stmfd	sp!, {r0-r3, fp, lr}
	UNWIND .save	{r0-r3, fp, lr}
	mov	fp, sp
	UNWIND .setfp	fp, sp

	@ Make room for all of the new args.
	sub	sp, sp, r2

	@ Make room for loading VFP args
	sub	sp, sp, #64

	@ Place all of the ffi_mini_prep_args in position
	mov	r0, sp
	@     r1 already set
	sub	r2, fp, #64   @ VFP scratch space

	@ Call ffi_mini_prep_args(stack, &ecif, vfp_space)
	bl	CNAME(ffi_mini_prep_args_VFP)

	@ Load VFP register args if needed
	cmp	r0, #0
	mov	ip, fp
	beq	LSYM(Lbase_args)

	@ Load only d0 if possible
	cmp	r0, #3
	sub	ip, fp, #64
	flddle	d0, [ip]
	fldmiadgt	ip, {d0-d7}

LSYM(Lbase_args):
	@ move first 4 parameters in registers
	ldmia	sp, {r0-r3}

	@ and adjust stack
	sub	lr, ip, sp	@ cif->bytes == (fp - 64) - sp
	ldr	ip, [fp]	@ load fn() in advance
        cmp	lr, #16
	movhs	lr, #16
        add	sp, sp, lr

	@ call (fn) (...)
	call_reg(ip)

	@ Remove the space we pushed for the args
	mov	sp, fp

	@ Load r2 with the pointer to storage for
	@ the return value
	ldr	r2, [sp, #24]

	@ Load r3 with the return type code 
	ldr	r3, [sp, #12]

	@ If the return value pointer is NULL,
	@ assume no return value.
	cmp	r2, #0
	beq	LSYM(Lepilogue_vfp)

	cmp	r3, #FFIM_TYPE_INT
	streq	r0, [r2]
	beq	LSYM(Lepilogue_vfp)

	cmp	r3, #FFIM_TYPE_SINT64
	stmeqia	r2, {r0, r1}
	beq	LSYM(Lepilogue_vfp)

	cmp	r3, #FFIM_TYPE_FLOAT
	fstseq	s0, [r2]
	beq	LSYM(Lepilogue_vfp)
	
	cmp	r3, #FFIM_TYPE_DOUBLE
	fstdeq	d0, [r2]
	beq	LSYM(Lepilogue_vfp)

	cmp	r3, #FFIM_TYPE_STRUCT_VFP_FLOAT
	cmpne	r3, #FFIM_TYPE_STRUCT_VFP_DOUBLE
	fstmiadeq	r2, {d0-d3}

LSYM(Lepilogue_vfp):
	RETLDM	"r0-r3,fp"

.ffi_mini_call_VFP_end:
	UNWIND .fnend
        .size    CNAME(ffi_mini_call_VFP),.ffi_mini_call_VFP_end-CNAME(ffi_mini_call_VFP)

#endif /* defined (__ARM_EABI__) */

#endif /* defined (__arm__) */

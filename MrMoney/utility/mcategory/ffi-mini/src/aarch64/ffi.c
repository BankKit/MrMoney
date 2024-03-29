/* Copyright (c) 2009, 2010, 2011, 2012 ARM Ltd.

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
``Software''), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED ``AS IS'', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.  */

#include "ffi_mini.h"
#include "ffi_common_mini.h"

#include <stdlib.h>
#include <stdio.h>

#ifdef __arm64__

/* Stack alignment requirement in bytes */
#if defined (__APPLE__)
#define AARCH64_STACK_ALIGN 1
#else
#define AARCH64_STACK_ALIGN 16
#endif

#define N_X_ARG_REG 8
#define N_V_ARG_REG 8

#define AARCH64_FFI_WITH_V (1 << AARCH64_FFI_WITH_V_BIT)

union _d
{
  UINT64 d;
  UINT32 s[2];
};

struct call_context
{
  UINT64 x [AARCH64_N_XREG];
  struct
  {
    union _d d[2];
  } v [AARCH64_N_VREG];
};

static void *
get_x_addr (struct call_context *context, unsigned n)
{
  return &context->x[n];
}

static void *
get_s_addr (struct call_context *context, unsigned n)
{
#if defined __AARCH64EB__
  return &context->v[n].d[1].s[1];
#else
  return &context->v[n].d[0].s[0];
#endif
}

static void *
get_d_addr (struct call_context *context, unsigned n)
{
#if defined __AARCH64EB__
  return &context->v[n].d[1];
#else
  return &context->v[n].d[0];
#endif
}

static void *
get_v_addr (struct call_context *context, unsigned n)
{
  return &context->v[n];
}

/* Return the memory location at which a basic type would reside
   were it to have been stored in register n.  */

static void *
get_basic_type_addr (unsigned short type, struct call_context *context,
		     unsigned n)
{
  switch (type)
    {
    case FFIM_TYPE_FLOAT:
      return get_s_addr (context, n);
    case FFIM_TYPE_DOUBLE:
      return get_d_addr (context, n);
#if FFIM_TYPE_DOUBLE != FFIM_TYPE_LONGDOUBLE
    case FFIM_TYPE_LONGDOUBLE:
      return get_v_addr (context, n);
#endif
    case FFIM_TYPE_UINT8:
    case FFIM_TYPE_SINT8:
    case FFIM_TYPE_UINT16:
    case FFIM_TYPE_SINT16:
    case FFIM_TYPE_UINT32:
    case FFIM_TYPE_SINT32:
    case FFIM_TYPE_INT:
    case FFIM_TYPE_POINTER:
    case FFIM_TYPE_UINT64:
    case FFIM_TYPE_SINT64:
      return get_x_addr (context, n);
    case FFIM_TYPE_VOID:
      return NULL;
    default:
      FFI_ASSERT (0);
      return NULL;
    }
}

/* Return the alignment width for each of the basic types.  */

static size_t
get_basic_type_alignment (unsigned short type)
{
  switch (type)
    {
    case FFIM_TYPE_FLOAT:
    case FFIM_TYPE_DOUBLE:
      return sizeof (UINT64);
#if FFIM_TYPE_DOUBLE != FFIM_TYPE_LONGDOUBLE
    case FFIM_TYPE_LONGDOUBLE:
      return sizeof (long double);
#endif
    case FFIM_TYPE_UINT8:
    case FFIM_TYPE_SINT8:
#if defined (__APPLE__)
	  return sizeof (UINT8);
#endif
    case FFIM_TYPE_UINT16:
    case FFIM_TYPE_SINT16:
#if defined (__APPLE__)
	  return sizeof (UINT16);
#endif
    case FFIM_TYPE_UINT32:
    case FFIM_TYPE_INT:
    case FFIM_TYPE_SINT32:
#if defined (__APPLE__)
	  return sizeof (UINT32);
#endif
    case FFIM_TYPE_POINTER:
    case FFIM_TYPE_UINT64:
    case FFIM_TYPE_SINT64:
      return sizeof (UINT64);

    default:
      FFI_ASSERT (0);
      return 0;
    }
}

/* Return the size in bytes for each of the basic types.  */

static size_t
get_basic_type_size (unsigned short type)
{
  switch (type)
    {
    case FFIM_TYPE_FLOAT:
      return sizeof (UINT32);
    case FFIM_TYPE_DOUBLE:
      return sizeof (UINT64);
#if FFIM_TYPE_DOUBLE != FFIM_TYPE_LONGDOUBLE
    case FFIM_TYPE_LONGDOUBLE:
      return sizeof (long double);
#endif
    case FFIM_TYPE_UINT8:
      return sizeof (UINT8);
    case FFIM_TYPE_SINT8:
      return sizeof (SINT8);
    case FFIM_TYPE_UINT16:
      return sizeof (UINT16);
    case FFIM_TYPE_SINT16:
      return sizeof (SINT16);
    case FFIM_TYPE_UINT32:
      return sizeof (UINT32);
    case FFIM_TYPE_INT:
    case FFIM_TYPE_SINT32:
      return sizeof (SINT32);
    case FFIM_TYPE_POINTER:
    case FFIM_TYPE_UINT64:
      return sizeof (UINT64);
    case FFIM_TYPE_SINT64:
      return sizeof (SINT64);

    default:
      FFI_ASSERT (0);
      return 0;
    }
}

extern void
ffi_mini_call_SYSV (unsigned (*)(struct call_context *context, unsigned char *,
			    extended_cif *),
               struct call_context *context,
               extended_cif *,
               size_t,
               void (*fn)(void));

/* Test for an FFI floating point representation.  */

static unsigned
is_floating_type (unsigned short type)
{
  return (type == FFIM_TYPE_FLOAT || type == FFIM_TYPE_DOUBLE
	  || type == FFIM_TYPE_LONGDOUBLE);
}

/* Test for a homogeneous structure.  */

static unsigned short
get_homogeneous_type (ffim_type *ty)
{
  if (ty->type == FFIM_TYPE_STRUCT && ty->elements)
    {
      unsigned i;
      unsigned short candidate_type
	= get_homogeneous_type (ty->elements[0]);
      for (i =1; ty->elements[i]; i++)
	{
	  unsigned short iteration_type = 0;
	  /* If we have a nested struct, we must find its homogeneous type.
	     If that fits with our candidate type, we are still
	     homogeneous.  */
	  if (ty->elements[i]->type == FFIM_TYPE_STRUCT
	      && ty->elements[i]->elements)
	    {
	      iteration_type = get_homogeneous_type (ty->elements[i]);
	    }
	  else
	    {
	      iteration_type = ty->elements[i]->type;
	    }

	  /* If we are not homogeneous, return FFIM_TYPE_STRUCT.  */
	  if (candidate_type != iteration_type)
	    return FFIM_TYPE_STRUCT;
	}
      return candidate_type;
    }

  /* Base case, we have no more levels of nesting, so we
     are a basic type, and so, trivially homogeneous in that type.  */
  return ty->type;
}

/* Determine the number of elements within a STRUCT.

   Note, we must handle nested structs.

   If ty is not a STRUCT this function will return 0.  */

static unsigned
element_count (ffim_type *ty)
{
  if (ty->type == FFIM_TYPE_STRUCT && ty->elements)
    {
      unsigned n;
      unsigned elems = 0;
      for (n = 0; ty->elements[n]; n++)
	{
	  if (ty->elements[n]->type == FFIM_TYPE_STRUCT
	      && ty->elements[n]->elements)
	    elems += element_count (ty->elements[n]);
	  else
	    elems++;
	}
      return elems;
    }
  return 0;
}

/* Test for a homogeneous floating point aggregate.

   A homogeneous floating point aggregate is a homogeneous aggregate of
   a half- single- or double- precision floating point type with one
   to four elements.  Note that this includes nested structs of the
   basic type.  */

static int
is_hfa (ffim_type *ty)
{
  if (ty->type == FFIM_TYPE_STRUCT
      && ty->elements[0]
      && is_floating_type (get_homogeneous_type (ty)))
    {
      unsigned n = element_count (ty);
      return n >= 1 && n <= 4;
    }
  return 0;
}

/* Test if an ffim_type is a candidate for passing in a register.

   This test does not check that sufficient registers of the
   appropriate class are actually available, merely that IFF
   sufficient registers are available then the argument will be passed
   in register(s).

   Note that an ffim_type that is deemed to be a register candidate
   will always be returned in registers.

   Returns 1 if a register candidate else 0.  */

static int
is_register_candidate (ffim_type *ty)
{
  switch (ty->type)
    {
    case FFIM_TYPE_VOID:
    case FFIM_TYPE_FLOAT:
    case FFIM_TYPE_DOUBLE:
#if FFIM_TYPE_DOUBLE != FFIM_TYPE_LONGDOUBLE
    case FFIM_TYPE_LONGDOUBLE:
#endif
    case FFIM_TYPE_UINT8:
    case FFIM_TYPE_UINT16:
    case FFIM_TYPE_UINT32:
    case FFIM_TYPE_UINT64:
    case FFIM_TYPE_POINTER:
    case FFIM_TYPE_SINT8:
    case FFIM_TYPE_SINT16:
    case FFIM_TYPE_SINT32:
    case FFIM_TYPE_INT:
    case FFIM_TYPE_SINT64:
      return 1;

    case FFIM_TYPE_STRUCT:
      if (is_hfa (ty))
        {
          return 1;
        }
      else if (ty->size > 16)
        {
          /* Too large. Will be replaced with a pointer to memory. The
             pointer MAY be passed in a register, but the value will
             not. This test specifically fails since the argument will
             never be passed by value in registers. */
          return 0;
        }
      else
        {
          /* Might be passed in registers depending on the number of
             registers required. */
          return (ty->size + 7) / 8 < N_X_ARG_REG;
        }
      break;

    default:
      FFI_ASSERT (0);
      break;
    }

  return 0;
}

/* Test if an ffim_type argument or result is a candidate for a vector
   register.  */

static int
is_v_register_candidate (ffim_type *ty)
{
  return is_floating_type (ty->type)
	   || (ty->type == FFIM_TYPE_STRUCT && is_hfa (ty));
}

/* Representation of the procedure call argument marshalling
   state.

   The terse state variable names match the names used in the AARCH64
   PCS. */

struct arg_state
{
  unsigned ngrn;                /* Next general-purpose register number. */
  unsigned nsrn;                /* Next vector register number. */
  size_t nsaa;                  /* Next stack offset. */
};

/* Initialize a procedure call argument marshalling state.  */
static void
arg_init (struct arg_state *state, size_t call_frame_size)
{
  state->ngrn = 0;
  state->nsrn = 0;
  state->nsaa = 0;
}

/* Return the number of available consecutive core argument
   registers.  */

static unsigned
available_x (struct arg_state *state)
{
  return N_X_ARG_REG - state->ngrn;
}

/* Return the number of available consecutive vector argument
   registers.  */

static unsigned
available_v (struct arg_state *state)
{
  return N_V_ARG_REG - state->nsrn;
}

static void *
allocate_to_x (struct call_context *context, struct arg_state *state)
{
  FFI_ASSERT (state->ngrn < N_X_ARG_REG);
  return get_x_addr (context, (state->ngrn)++);
}

static void *
allocate_to_d (struct call_context *context, struct arg_state *state)
{
  FFI_ASSERT (state->nsrn < N_V_ARG_REG);
  return get_d_addr (context, (state->nsrn)++);
}

static void *
allocate_to_v (struct call_context *context, struct arg_state *state)
{
  FFI_ASSERT (state->nsrn < N_V_ARG_REG);
  return get_v_addr (context, (state->nsrn)++);
}

/* Allocate an aligned slot on the stack and return a pointer to it.  */
static void *
allocate_to_stack (struct arg_state *state, void *stack, size_t alignment,
		   size_t size)
{
  void *allocation;

  /* Round up the NSAA to the larger of 8 or the natural
     alignment of the argument's type.  */
  state->nsaa = ALIGN (state->nsaa, alignment);
  state->nsaa = ALIGN (state->nsaa, alignment);
#if !defined (__APPLE__)
  state->nsaa = ALIGN (state->nsaa, 8);
#endif

  allocation = stack + state->nsaa;

  state->nsaa += size;
  return allocation;
}

static void
copy_basic_type (void *dest, void *source, unsigned short type)
{
  /* This is necessary to ensure that basic types are copied
     sign extended to 64-bits as libffi expects.  */
  switch (type)
    {
    case FFIM_TYPE_FLOAT:
      *(float *) dest = *(float *) source;
      break;
    case FFIM_TYPE_DOUBLE:
      *(double *) dest = *(double *) source;
      break;
#if FFIM_TYPE_DOUBLE != FFIM_TYPE_LONGDOUBLE
    case FFIM_TYPE_LONGDOUBLE:
      *(long double *) dest = *(long double *) source;
      break;
#endif
    case FFIM_TYPE_UINT8:
      *(ffim_arg *) dest = *(UINT8 *) source;
      break;
    case FFIM_TYPE_SINT8:
      *(ffim_sarg *) dest = *(SINT8 *) source;
      break;
    case FFIM_TYPE_UINT16:
      *(ffim_arg *) dest = *(UINT16 *) source;
      break;
    case FFIM_TYPE_SINT16:
      *(ffim_sarg *) dest = *(SINT16 *) source;
      break;
    case FFIM_TYPE_UINT32:
      *(ffim_arg *) dest = *(UINT32 *) source;
      break;
    case FFIM_TYPE_INT:
    case FFIM_TYPE_SINT32:
      *(ffim_sarg *) dest = *(SINT32 *) source;
      break;
    case FFIM_TYPE_POINTER:
    case FFIM_TYPE_UINT64:
      *(ffim_arg *) dest = *(UINT64 *) source;
      break;
    case FFIM_TYPE_SINT64:
      *(ffim_sarg *) dest = *(SINT64 *) source;
      break;

    case FFIM_TYPE_VOID:
      break;
    default:
      FFI_ASSERT (0);
    }
}

static void
copy_hfa_to_reg_or_stack (void *memory,
			  ffim_type *ty,
			  struct call_context *context,
			  unsigned char *stack,
			  struct arg_state *state)
{
  unsigned elems = element_count (ty);
  if (available_v (state) < elems)
    {
      /* There are insufficient V registers. Further V register allocations
	 are prevented, the NSAA is adjusted (by allocate_to_stack ())
	 and the argument is copied to memory at the adjusted NSAA.  */
      state->nsrn = N_V_ARG_REG;
      memcpy (allocate_to_stack (state, stack, ty->alignment, ty->size),
	      memory,
	      ty->size);
    }
  else
    {
      int i;
      unsigned short type = get_homogeneous_type (ty);
      for (i = 0; i < elems; i++)
	{
	  void *reg = allocate_to_v (context, state);
	  copy_basic_type (reg, memory, type);
	  memory += get_basic_type_size (type);
	}
    }
}

/* Either allocate an appropriate register for the argument type, or if
   none are available, allocate a stack slot and return a pointer
   to the allocated space.  */

static void *
allocate_to_register_or_stack (struct call_context *context,
			       unsigned char *stack,
			       struct arg_state *state,
			       unsigned short type)
{
  size_t alignment = get_basic_type_alignment (type);
  size_t size = alignment;
  switch (type)
    {
    case FFIM_TYPE_FLOAT:
      /* This is the only case for which the allocated stack size
	 should not match the alignment of the type.  */
      size = sizeof (UINT32);
      /* Fall through.  */
    case FFIM_TYPE_DOUBLE:
      if (state->nsrn < N_V_ARG_REG)
	return allocate_to_d (context, state);
      state->nsrn = N_V_ARG_REG;
      break;
#if FFIM_TYPE_DOUBLE != FFIM_TYPE_LONGDOUBLE
    case FFIM_TYPE_LONGDOUBLE:
      if (state->nsrn < N_V_ARG_REG)
	return allocate_to_v (context, state);
      state->nsrn = N_V_ARG_REG;
      break;
#endif
    case FFIM_TYPE_UINT8:
    case FFIM_TYPE_SINT8:
    case FFIM_TYPE_UINT16:
    case FFIM_TYPE_SINT16:
    case FFIM_TYPE_UINT32:
    case FFIM_TYPE_SINT32:
    case FFIM_TYPE_INT:
    case FFIM_TYPE_POINTER:
    case FFIM_TYPE_UINT64:
    case FFIM_TYPE_SINT64:
      if (state->ngrn < N_X_ARG_REG)
	return allocate_to_x (context, state);
      state->ngrn = N_X_ARG_REG;
      break;
    default:
      FFI_ASSERT (0);
    }

    return allocate_to_stack (state, stack, alignment, size);
}

/* Copy a value to an appropriate register, or if none are
   available, to the stack.  */

static void
copy_to_register_or_stack (struct call_context *context,
			   unsigned char *stack,
			   struct arg_state *state,
			   void *value,
			   unsigned short type)
{
  copy_basic_type (
	  allocate_to_register_or_stack (context, stack, state, type),
	  value,
	  type);
}

/* Marshall the arguments from FFI representation to procedure call
   context and stack.  */

static unsigned
aarch64_prep_args (struct call_context *context, unsigned char *stack,
		   extended_cif *ecif)
{
  int i;
  struct arg_state state;

  arg_init (&state, ALIGN(ecif->cif->bytes, 16));

  for (i = 0; i < ecif->cif->nargs; i++)
    {
      ffim_type *ty = ecif->cif->arg_types[i];
      switch (ty->type)
	{
	case FFIM_TYPE_VOID:
	  FFI_ASSERT (0);
	  break;

	/* If the argument is a basic type the argument is allocated to an
	   appropriate register, or if none are available, to the stack.  */
	case FFIM_TYPE_FLOAT:
	case FFIM_TYPE_DOUBLE:
#if FFIM_TYPE_DOUBLE != FFIM_TYPE_LONGDOUBLE
	case FFIM_TYPE_LONGDOUBLE:
#endif
	case FFIM_TYPE_UINT8:
	case FFIM_TYPE_SINT8:
	case FFIM_TYPE_UINT16:
	case FFIM_TYPE_SINT16:
	case FFIM_TYPE_UINT32:
	case FFIM_TYPE_INT:
	case FFIM_TYPE_SINT32:
	case FFIM_TYPE_POINTER:
	case FFIM_TYPE_UINT64:
	case FFIM_TYPE_SINT64:
	  copy_to_register_or_stack (context, stack, &state,
				     ecif->avalue[i], ty->type);
	  break;

	case FFIM_TYPE_STRUCT:
	  if (is_hfa (ty))
	    {
	      copy_hfa_to_reg_or_stack (ecif->avalue[i], ty, context,
					stack, &state);
	    }
	  else if (ty->size > 16)
	    {
	      /* If the argument is a composite type that is larger than 16
		 bytes, then the argument has been copied to memory, and
		 the argument is replaced by a pointer to the copy.  */

	      copy_to_register_or_stack (context, stack, &state,
					 &(ecif->avalue[i]), FFIM_TYPE_POINTER);
	    }
	  else if (available_x (&state) >= (ty->size + 7) / 8)
	    {
	      /* If the argument is a composite type and the size in
		 double-words is not more than the number of available
		 X registers, then the argument is copied into consecutive
		 X registers.  */
	      int j;
	      for (j = 0; j < (ty->size + 7) / 8; j++)
		{
		  memcpy (allocate_to_x (context, &state),
			  &(((UINT64 *) ecif->avalue[i])[j]),
			  sizeof (UINT64));
		}
	    }
	  else
	    {
	      /* Otherwise, there are insufficient X registers. Further X
		 register allocations are prevented, the NSAA is adjusted
		 (by allocate_to_stack ()) and the argument is copied to
		 memory at the adjusted NSAA.  */
	      state.ngrn = N_X_ARG_REG;

	      memcpy (allocate_to_stack (&state, stack, ty->alignment,
					 ty->size), ecif->avalue + i, ty->size);
	    }
	  break;

	default:
	  FFI_ASSERT (0);
	  break;
	}
    }

  return ecif->cif->aarch64_flags;
}

ffim_status
ffi_mini_prep_cif_machdep (ffim_cif *cif)
{
  /* Round the stack up to a multiple of the stack alignment requirement. */
  cif->bytes =
    (cif->bytes + (AARCH64_STACK_ALIGN - 1)) & ~ (AARCH64_STACK_ALIGN - 1);

  /* Initialize our flags. We are interested if this CIF will touch a
     vector register, if so we will enable context save and load to
     those registers, otherwise not. This is intended to be friendly
     to lazy float context switching in the kernel.  */
  cif->aarch64_flags = 0;

  if (is_v_register_candidate (cif->rtype))
    {
      cif->aarch64_flags |= AARCH64_FFI_WITH_V;
    }
  else
    {
      int i;
      for (i = 0; i < cif->nargs; i++)
        if (is_v_register_candidate (cif->arg_types[i]))
          {
            cif->aarch64_flags |= AARCH64_FFI_WITH_V;
            break;
          }
    }

  return FFIM_OK;
}

/* Call a function with the provided arguments and capture the return
   value.  */
void
ffi_mini_call (ffim_cif *cif, void (*fn)(void), void *rvalue, void **avalue)
{
  extended_cif ecif;

  ecif.cif = cif;
  ecif.avalue = avalue;
  ecif.rvalue = rvalue;

  switch (cif->abi)
    {
    case FFIM_SYSV:
      {
        struct call_context context;
	size_t stack_bytes;

	/* Figure out the total amount of stack space we need, the
	   above call frame space needs to be 16 bytes aligned to
	   ensure correct alignment of the first object inserted in
	   that space hence the ALIGN applied to cif->bytes.*/
	stack_bytes = ALIGN(cif->bytes, 16);

	memset (&context, 0, sizeof (context));
        if (is_register_candidate (cif->rtype))
          {
            ffi_mini_call_SYSV (aarch64_prep_args, &context, &ecif, stack_bytes, fn);
            switch (cif->rtype->type)
              {
              case FFIM_TYPE_VOID:
              case FFIM_TYPE_FLOAT:
              case FFIM_TYPE_DOUBLE:
#if FFIM_TYPE_DOUBLE != FFIM_TYPE_LONGDOUBLE
              case FFIM_TYPE_LONGDOUBLE:
#endif
              case FFIM_TYPE_UINT8:
              case FFIM_TYPE_SINT8:
              case FFIM_TYPE_UINT16:
              case FFIM_TYPE_SINT16:
              case FFIM_TYPE_UINT32:
              case FFIM_TYPE_SINT32:
              case FFIM_TYPE_POINTER:
              case FFIM_TYPE_UINT64:
              case FFIM_TYPE_INT:
              case FFIM_TYPE_SINT64:
		{
		  void *addr = get_basic_type_addr (cif->rtype->type,
						    &context, 0);
		  copy_basic_type (rvalue, addr, cif->rtype->type);
		  break;
		}

              case FFIM_TYPE_STRUCT:
                if (is_hfa (cif->rtype))
		  {
		    int j;
		    unsigned short type = get_homogeneous_type (cif->rtype);
		    unsigned elems = element_count (cif->rtype);
		    for (j = 0; j < elems; j++)
		      {
			void *reg = get_basic_type_addr (type, &context, j);
			copy_basic_type (rvalue, reg, type);
			rvalue += get_basic_type_size (type);
		      }
		  }
                else if ((cif->rtype->size + 7) / 8 < N_X_ARG_REG)
                  {
                    size_t size = ALIGN (cif->rtype->size, sizeof (UINT64));
                    memcpy (rvalue, get_x_addr (&context, 0), size);
                  }
                else
                  {
                    FFI_ASSERT (0);
                  }
                break;

              default:
                FFI_ASSERT (0);
                break;
              }
          }
        else
          {
            memcpy (get_x_addr (&context, 8), &rvalue, sizeof (UINT64));
            ffi_mini_call_SYSV (aarch64_prep_args, &context, &ecif,
			   stack_bytes, fn);
          }
        break;
      }

    default:
      FFI_ASSERT (0);
      break;
    }
}

#endif

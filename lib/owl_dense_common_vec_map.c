/*
 * OWL - an OCaml numerical library for scientific computing
 * Copyright (c) 2016-2017 Liang Wang <liang.wang@cl.cam.ac.uk>
 */

#include "owl_macros.h"

#ifndef NUMBER
#define NUMBER double
void __dumb_fun_vec_map() {};  // define a dumb to avoid warnings
#endif /* NUMBER */


// function to perform in-place mapping of elements in x
#ifdef FUN3

CAMLprim value FUN3(value vN, value vX)
{
  CAMLparam2(vN, vX);
  int N = Long_val(vN);

  struct caml_ba_array *big_X = Caml_ba_array_val(vX);
  CAMLunused int dim_X = *big_X->dim;
  NUMBER *X_data = ((NUMBER *) big_X->data);

  NUMBER *start_x, *stop_x;

  caml_enter_blocking_section();  /* Allow other threads */

  start_x = X_data;
  stop_x = start_x + N;

  int r = 0;

  while (start_x != stop_x) {
    NUMBER x = *start_x;
    *start_x = (MAPFN(x));
    start_x += 1;
  };

  caml_leave_blocking_section();  /* Disallow other threads */

  CAMLreturn(Val_int(r));
}

#endif /* FUN3 */


// function to perform mapping of elements from x to y
#ifdef FUN4

CAMLprim value FUN4(value vN, value vX, value vY)
{
  CAMLparam3(vN, vX, vY);
  int N = Long_val(vN);

  struct caml_ba_array *big_X = Caml_ba_array_val(vX);
  CAMLunused int dim_X = *big_X->dim;
  NUMBER *X_data = ((NUMBER *) big_X->data);

  struct caml_ba_array *big_Y = Caml_ba_array_val(vY);
  CAMLunused int dim_Y = *big_Y->dim;
  NUMBER1 *Y_data = ((NUMBER1 *) big_Y->data);

  NUMBER *start_x, *stop_x;
  NUMBER1 *start_y;

  caml_enter_blocking_section();  /* Allow other threads */

  start_x = X_data;
  stop_x = start_x + N;
  start_y = Y_data;

  int r = 1;

  while (start_x != stop_x) {
    NUMBER x = *start_x;
    *start_y = (MAPFN(x));

    start_x += 1;
    start_y += 1;
  };

  caml_leave_blocking_section();  /* Disallow other threads */

  CAMLreturn(Val_int(r));
}

#endif /* FUN4 */


// function to perform mapping of elements from x to y with regards to scalar values
#ifdef FUN12

CAMLprim value FUN12(value vN, value vA, value vB, value vX)
{
  CAMLparam1(vX);
  int i, N = Long_val(vN);
  INIT;

  struct caml_ba_array *big_X = Caml_ba_array_val(vX);
  CAMLunused int dim_X = *big_X->dim;
  NUMBER *X_data = ((NUMBER *) big_X->data);

  caml_enter_blocking_section();  /* Allow other threads */

  for (i = 1; i <= N; i++) {
    MAPFN(*X_data);
    X_data++;
  }

  caml_leave_blocking_section();  /* Disallow other threads */

  CAMLreturn(Val_unit);
}

#endif /* FUN12 */


// function to calculate logspace function
#ifdef FUN13

CAMLprim value FUN13(value vN, value vBase, value vA, value vB, value vX)
{
  CAMLparam1(vX);
  int i, N = Long_val(vN);
  INIT;

  struct caml_ba_array *big_X = Caml_ba_array_val(vX);
  CAMLunused int dim_X = *big_X->dim;
  NUMBER *X_data = ((NUMBER *) big_X->data);

  caml_enter_blocking_section();  /* Allow other threads */

  if (base == 2.0)
    for (i = 1; i <= N; i++) {
      MAPFN(X_data);
      X_data++;
    }
  else if (base == 10.0)
    for (i = 1; i <= N; i++) {
      MAPFN1(X_data);
      X_data++;
    }
  else if (base == 2.7182818284590452353602874713526625L)
    for (i = 1; i <= N; i++) {
      MAPFN2(X_data);
      X_data++;
    }
  else {
    for (i = 1; i <= N; i++) {
      MAPFN3(X_data);
      X_data++;
    }
  }

  caml_leave_blocking_section();  /* Disallow other threads */

  CAMLreturn(Val_unit);
}

#endif /* FUN13 */


#undef NUMBER
#undef NUMBER1
#undef MAPFN
#undef MAPFN1
#undef MAPFN2
#undef MAPFN3
#undef INIT
#undef FUN3
#undef FUN4
#undef FUN12
#undef FUN13
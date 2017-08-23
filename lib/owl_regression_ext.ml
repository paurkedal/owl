(*
 * OWL - an OCaml numerical library for scientific computing
 * Copyright (c) 2016-2017 Liang Wang <liang.wang@cl.cam.ac.uk>
 *)

open Owl_types


module Make
  (M : MatrixSig)
  (A : NdarraySig with type elt = M.elt and type arr = M.arr)
  = struct

  include Owl_optimise_ext.Make (M) (A)

  let ols x y =
    let m = M.col_num x in
    let n = M.col_num y in
    let p = ref (Mat (M.uniform m n)) in

    let forward x =
      p := make_reverse !p (tag ());
      let pred = Maths.(x *@ !p) in
      pred, [| [|!p|] |]
    in

    let backward y =
      reverse_prop (F 1.) y;
      let pri_v = [| [|primal !p|] |] in
      let adj_v = [| [|adjval !p|] |] in
      pri_v, adj_v
    in

    let update us = p := us.(0).(0) in
    let save _ = () in

    let params = Params.config
      ~batch:(Batch.Full) ~learning_rate:(Learning_Rate.Adagrad 1.)
      ~gradient:(Gradient.GD) ~loss:(Loss.Quadratic) 1000.
    in
    let _ = minimise params forward backward update save (Mat x) (Mat y) in
    !p |> primal' |> unpack_mat


  let ridge ?(i=true) ?(a=0.001) x y =
    let m = M.col_num x in
    let n = M.col_num y in
    let p = ref (Mat (M.uniform m n)) in

    let forward x =
      p := make_reverse !p (tag ());
      let pred = Maths.(x *@ !p) in
      pred, [| [|!p|] |]
    in

    let backward y =
      reverse_prop (F 1.) y;
      let pri_v = [| [|primal !p|] |] in
      let adj_v = [| [|adjval !p|] |] in
      pri_v, adj_v
    in

    let update us = p := us.(0).(0) in
    let save _ = () in

    let params = Params.config
      ~batch:(Batch.Full) ~learning_rate:(Learning_Rate.Adagrad 1.)
      ~gradient:(Gradient.GD) ~loss:(Loss.Quadratic) ~regularisation:(Regularisation.L2norm a)
      1000.
    in
    let _ = minimise params forward backward update save (Mat x) (Mat y) in
    !p |> primal' |> unpack_mat


  let lasso ?(i=true) ?(a=0.001) x y =
    let m = M.col_num x in
    let n = M.col_num y in
    let p = ref (Mat (M.uniform m n)) in

    let forward x =
      p := make_reverse !p (tag ());
      let pred = Maths.(x *@ !p) in
      pred, [| [|!p|] |]
    in

    let backward y =
      reverse_prop (F 1.) y;
      let pri_v = [| [|primal !p|] |] in
      let adj_v = [| [|adjval !p|] |] in
      pri_v, adj_v
    in

    let update us = p := us.(0).(0) in
    let save _ = () in

    let params = Params.config
      ~batch:(Batch.Full) ~learning_rate:(Learning_Rate.Adagrad 1.)
      ~gradient:(Gradient.GD) ~loss:(Loss.Quadratic) ~regularisation:(Regularisation.L1norm a)
      1000.
    in
    let _ = minimise params forward backward update save (Mat x) (Mat y) in
    !p |> primal' |> unpack_mat


  let svm ?(i=true) ?(a=0.001) x y =
    let m = M.col_num x in
    let n = M.col_num y in
    let p = ref (Mat (M.uniform m n)) in

    let forward x =
      p := make_reverse !p (tag ());
      let pred = Maths.(x *@ !p) in
      pred, [| [|!p|] |]
    in

    let backward y =
      reverse_prop (F 1.) y;
      let pri_v = [| [|primal !p|] |] in
      let adj_v = [| [|adjval !p|] |] in
      pri_v, adj_v
    in

    let update us = p := us.(0).(0) in
    let save _ = () in

    let params = Params.config
      ~batch:(Batch.Full) ~learning_rate:(Learning_Rate.Adagrad 1.)
      ~gradient:(Gradient.GD) ~loss:(Loss.Hinge) ~regularisation:(Regularisation.L2norm a)
      1000.
    in
    let _ = minimise params forward backward update save (Mat x) (Mat y) in
    !p |> primal' |> unpack_mat


  let logistic ?(i=true) x y =
    let m = M.col_num x in
    let n = M.col_num y in
    let p = ref (Mat (M.uniform m n)) in

    let forward x =
      p := make_reverse !p (tag ());
      let pred = Maths.(x *@ !p) in
      pred, [| [|!p|] |]
    in

    let backward y =
      reverse_prop (F 1.) y;
      let pri_v = [| [|primal !p|] |] in
      let adj_v = [| [|adjval !p|] |] in
      pri_v, adj_v
    in

    let update us = p := us.(0).(0) in
    let save _ = () in

    let params = Params.config
      ~batch:(Batch.Full) ~learning_rate:(Learning_Rate.Adagrad 1.)
      ~gradient:(Gradient.GD) ~loss:(Loss.Cross_entropy) 1000.
    in
    let _ = minimise params forward backward update save (Mat x) (Mat y) in
    !p |> primal' |> unpack_mat


end

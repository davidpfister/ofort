  module m
    implicit none
    type :: labeled_matrix(dp, n1, n2)
       integer, kind :: dp
       integer, len :: n1, n2
       real(kind=dp) :: x(n1,n2)
    end type
  end module
  program main
    use m
    use iso_fortran_env, only: real64
    type(labeled_matrix(real64,2,3)) :: a
    print *, a%x(1,2)
  end program

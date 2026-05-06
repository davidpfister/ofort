  module m
    implicit none

    type :: labeled_matrix(dp, n1, n2)
       integer, kind :: dp
       integer, len :: n1, n2
       real(kind=dp) :: x(n1,n2)
       character(len=20) :: row_labels(n1)
       character(len=12) :: column_labels(n2)
    end type

  contains
  end module

  program main
    use m
    use iso_fortran_env, only: real64
    type(labeled_matrix(real64,2,3)) :: a

    a%x = 0.0_real64
    a%x(1,2) = 5.0_real64
    print *, size(a%x,1), size(a%x,2), a%x(1,2)
  end program

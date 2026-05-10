module m
  type t
    real :: x
  contains
    procedure :: lt
    generic :: operator(.USERDEFINELESSTHANOPERATOR.) => lt
  end type
contains
  logical function lt(a,b)
    class(t), intent(in) :: a
    real, intent(in) :: b
    lt = a%x < b
  end function
end module
program p
  use m
  type(t) :: a = t(0.5)
  real :: x = 0.7
  if (a.USERDEFINELESSTHANOPERATOR.x) print *, 'pass'
end program

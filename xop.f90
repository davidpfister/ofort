module xpublic_operator_power_mod
implicit none
private
public :: t, operator(**)

type :: t
   real :: x = 0.0
end type t

interface operator(**)
   module procedure power_t_i
end interface operator(**)

contains

elemental function power_t_i(a, n) result(b)
! return a**n
type(t), intent(in) :: a
integer, intent(in) :: n
type(t) :: b
b%x = a%x**n
end function power_t_i

end module xpublic_operator_power_mod

program main
use xpublic_operator_power_mod
implicit none
type(t) :: a, b

a%x = 2.0
b = a**3
print *, b%x
end program main

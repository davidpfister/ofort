module point_mod
use, intrinsic :: iso_fortran_env, only: real64
implicit none

integer, parameter :: dp = real64

type :: point
   real(kind=dp) :: x
   real(kind=dp) :: y
contains
   procedure :: norm => point_norm
   procedure :: scale => point_scale
end type point

contains

real(kind=dp) function point_norm(self) result(y)
! Return the Euclidean norm of a point.
class(point), intent(in) :: self

y = sqrt(self%x**2 + self%y**2)

end function point_norm

subroutine point_scale(self, factor)
! Scale a point by a scalar factor.
class(point), intent(inout) :: self
real(kind=dp), intent(in) :: factor

self%x = factor * self%x
self%y = factor * self%y

end subroutine point_scale

end module point_mod

program test_point_type_bound
use point_mod, only: dp, point
implicit none

type(point) :: p

p%x = 3.0_dp
p%y = 4.0_dp

print *, "initial point:"
print *, "x =", p%x
print *, "y =", p%y
print *, "norm =", p%norm()

call p%scale(2.0_dp)

print *
print *, "after scaling by 2:"
print *, "x =", p%x
print *, "y =", p%y
print *, "norm =", p%norm()

end program test_point_type_bound

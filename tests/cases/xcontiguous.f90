module contiguous_mod
   implicit none

contains

   subroutine scale_contiguous(x, factor)
      ! Scale a contiguous rank-1 array section in place.
      real, contiguous, intent(inout) :: x(:)
      real, intent(in) :: factor

      x = factor*x
   end subroutine scale_contiguous

   subroutine print_array(label, x)
      ! Print a rank-1 real array.
      character(len=*), intent(in) :: label
      real, intent(in) :: x(:)

      print '(a,*(1x,f6.1))', trim(label), x
   end subroutine print_array

end module contiguous_mod

program test_contiguous
   use contiguous_mod, only: scale_contiguous, print_array
   implicit none

   integer, parameter :: n = 8
   integer :: i
   real :: a(n)

   a = [(real(i), i = 1, n)]

   call print_array("initial a:       ", a)

   call scale_contiguous(a, 10.0)
   call print_array("after whole a:   ", a)

   call scale_contiguous(a(3:6), -1.0)
   call print_array("after a(3:6):    ", a)

   ! This is not allowed, because a(1:n:2) is not contiguous.
   ! Uncommenting this line should give a compile-time error with many compilers:
   !
   ! call scale_contiguous(a(1:n:2), 100.0)

end program test_contiguous

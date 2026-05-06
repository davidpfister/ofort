module import_interface_mod
   implicit none

   integer, parameter :: dp = kind(1.0d0)

   abstract interface
      function real_func(x) result(y)
         ! Define the interface for a real(kind=dp) scalar function.
         import :: dp
         real(kind=dp), intent(in) :: x
         real(kind=dp) :: y
      end function real_func
   end interface

contains

   function square(x) result(y)
      ! Return x squared.
      real(kind=dp), intent(in) :: x
      real(kind=dp) :: y

      y = x*x
   end function square

   function cube(x) result(y)
      ! Return x cubed.
      real(kind=dp), intent(in) :: x
      real(kind=dp) :: y

      y = x*x*x
   end function cube

   subroutine print_values(f, xmin, xmax, n)
      ! Print values of a procedure argument on an evenly spaced grid.
      procedure(real_func) :: f
      real(kind=dp), intent(in) :: xmin, xmax
      integer, intent(in) :: n
      integer :: i
      real(kind=dp) :: x, dx

      if (n < 2) error stop "n must be at least 2"

      dx = (xmax - xmin)/real(n - 1, kind=dp)

      do i = 1, n
         x = xmin + real(i - 1, kind=dp)*dx
         print "('x = ',f6.2,'  f(x) = ',f8.3)", x, f(x)
      end do
   end subroutine print_values

end module import_interface_mod

program ximport_interface
   ! Demonstrate import in an abstract interface.
   use import_interface_mod, only: dp, square, cube, print_values
   implicit none

   integer, parameter :: n = 5

   print *, "square:"
   call print_values(square, 1.0_dp, 5.0_dp, n)

   print *
   print *, "cube:"
   call print_values(cube, 1.0_dp, 5.0_dp, n)

end program ximport_interface

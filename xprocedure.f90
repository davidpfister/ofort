module procedure_mod
   implicit none

   abstract interface
      function real_func(x) result(y)
         real, intent(in) :: x
         real :: y
      end function real_func
   end interface

contains

   function square(x) result(y)
      ! Return x squared.
      real, intent(in) :: x
      real :: y

      y = x*x
   end function square

   function cube(x) result(y)
      ! Return x cubed.
      real, intent(in) :: x
      real :: y

      y = x*x*x
   end function cube

   subroutine print_values(f, xmin, xmax, n)
      ! Print values of a procedure argument on an evenly spaced grid.
      procedure(real_func) :: f
      real, intent(in) :: xmin, xmax
      integer, intent(in) :: n
      integer :: i
      real :: x, dx

      if (n < 2) error stop "n must be at least 2"

      dx = (xmax - xmin)/real(n - 1)

      do i = 1, n
         x = xmin + real(i - 1)*dx
         print "('x = ',f6.2,'  f(x) = ',f8.3)", x, f(x)
      end do
   end subroutine print_values

end module procedure_mod

program xprocedure
   ! Demonstrate passing module procedures as procedure dummy arguments.
   use procedure_mod, only: square, cube, print_values
   implicit none

   integer, parameter :: n = 5

   print *, "square:"
   call print_values(square, 1.0, 5.0, n)

   print *
   print *, "cube:"
   call print_values(cube, 1.0, 5.0, n)

end program xprocedure

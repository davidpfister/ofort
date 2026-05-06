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
    real, intent(in) :: x
    real :: y
    y = x*x
  end function square

  function cube(x) result(y)
    real, intent(in) :: x
    real :: y
    y = x*x*x
  end function cube

  subroutine print_values(f, xmin, xmax, n)
    procedure(real_func) :: f
    real, intent(in) :: xmin, xmax
    integer, intent(in) :: n
    integer :: i
    real :: x, dx

    dx = (xmax - xmin)/real(n - 1)
    do i = 1, n
      x = xmin + real(i - 1)*dx
      print "('x = ',f6.2,'  f(x) = ',f8.3)", x, f(x)
    end do
  end subroutine print_values
end module procedure_mod

program xprocedure
  use procedure_mod, only: square, cube, print_values
  implicit none
  print *, "square:"
  call print_values(square, 1.0, 3.0, 3)
  print *
  print *, "cube:"
  call print_values(cube, 1.0, 3.0, 3)
end program xprocedure

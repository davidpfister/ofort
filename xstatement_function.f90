program test_statement_function
   implicit none

   real :: x
   real :: y
   real :: square
   real :: cube
   real :: line

   ! statement functions
   square(x) = x*x
   cube(x) = x*x*x
   line(x) = 2.0*x + 1.0

   x = 3.0
   y = -2.0

   print *, "x = ", x
   print *, "square(x) = ", square(x)
   print *, "cube(x) = ", cube(x)
   print *, "line(x) = ", line(x)

   print *
   print *, "y = ", y
   print *, "square(y) = ", square(y)
   print *, "cube(y) = ", cube(y)
   print *, "line(y) = ", line(y)

end program test_statement_function

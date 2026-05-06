program xreduce
   ! Demonstrate the Fortran 2023 reduce intrinsic with user-defined operations.
   implicit none

   integer, parameter :: n = 5
   integer :: x(n), sum_x, prod_x, max_x

   x = [1, 2, 3, 4, 5]

   sum_x  = reduce(x, add_int)
   prod_x = reduce(x, multiply_int)
   max_x  = reduce(x, max_int)

   print "('x       =',*(1x,i0))", x
   print "('sum     = ',i0)", sum_x
   print "('product = ',i0)", prod_x
   print "('maximum = ',i0)", max_x

contains

   pure function add_int(a, b) result(c)
      ! Return a + b.
      integer, intent(in) :: a, b
      integer :: c

      c = a + b
   end function add_int

   pure function multiply_int(a, b) result(c)
      ! Return a*b.
      integer, intent(in) :: a, b
      integer :: c

      c = a*b
   end function multiply_int

   pure function max_int(a, b) result(c)
      ! Return max(a,b).
      integer, intent(in) :: a, b
      integer :: c

      c = max(a, b)
   end function max_int

end program xreduce

program xdata
   ! Demonstrate the data statement for initializing scalars, arrays, and implied-do lists.
   implicit none

   integer, parameter :: n = 5, nrow = 2, ncol = 3
   integer :: i, j, count, x(n), a(nrow, ncol)
   real :: scale
   character(len=8) :: name
   logical :: debug

   data count /10/
   data scale /2.5/
   data name /"example"/
   data debug /.true./

   data x /1, 1, 2, 3, 5/

   data ((a(i,j), i = 1, nrow), j = 1, ncol) / &
      11, 12, &
      21, 22, &
      31, 32/

   print "('count = ',i0)", count
   print "('scale = ',f5.2)", scale
   print "('name  = ',a)", trim(name)
   print "('debug = ',l1)", debug

   print *
   print "('x =',*(1x,i0))", x

   print *
   print "('a:')"
   do i = 1, nrow
      print "(*(1x,i0))", a(i,:)
   end do

end program xdata

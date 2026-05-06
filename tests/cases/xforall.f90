program xforall_not_do
   ! Demonstrate that forall assignments use old RHS values, unlike a similar do loop.
   implicit none

   integer, parameter :: n = 8
   integer :: i
   integer :: a_forall(n), a_do(n)

   a_forall = [(i, i = 1, n)]
   a_do     = [(i, i = 1, n)]

   print "('initial:       ',*(1x,i0))", a_forall

   forall (i = 2:n)
      a_forall(i) = a_forall(i - 1)
   end forall

   do i = 2, n
      a_do(i) = a_do(i - 1)
   end do

   print "('after forall:  ',*(1x,i0))", a_forall
   print "('after do loop: ',*(1x,i0))", a_do

end program xforall_not_do

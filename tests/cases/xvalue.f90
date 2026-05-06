module value_mod
   implicit none

contains

   subroutine add_one(i)
      ! Increment a local copy of i because i has the value attribute.
      integer, value :: i

      i = i + 1
      print "('inside subroutine, i = ',i0)", i
   end subroutine add_one

end module value_mod

program xvalue
   ! Demonstrate that a value dummy argument receives a local copy.
   use value_mod, only: add_one
   implicit none

   integer :: n

   n = 10

   print "('before call, n = ',i0)", n
   call add_one(n)
   print "('after call,  n = ',i0)", n

end program xvalue
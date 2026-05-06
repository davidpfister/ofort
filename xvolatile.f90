program wait_for_flag
   implicit none

   integer, volatile :: done
   integer :: i

   done = 0

   do i = 1, 1000000
      if (done /= 0) exit

      if (i == 100000) then
         done = 1
      end if
   end do

   if (done /= 0) then
      print *, "done flag was seen"
   else
      print *, "done flag was not set"
   end if

end program wait_for_flag

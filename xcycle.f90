implicit none
real :: x
x = 0.0
do
   call random_number(x)
   if (x > 0.9) exit
   if (x > 0.5) then
      print*,"big", x
      cycle
   end if
   print*,"small", x
end do
print*,"very big",x
end

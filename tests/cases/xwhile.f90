implicit none
real :: x
x = 0.0
do while (x < 0.9)
   call random_number(x)
   print*,x
end do
print*,"big",x
end

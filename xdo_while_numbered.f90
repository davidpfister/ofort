implicit none
integer :: i
i = 1
do 10 while (i**2 < 10)
   print*,i
   i = i + 1
10 continue
end

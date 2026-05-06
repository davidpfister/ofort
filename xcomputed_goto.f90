program xcomputed_goto
implicit none

integer :: choice
integer :: i

print *, "computed goto example"

do choice = 0, 5
   print *
   print *, "choice =", choice

   goto (100, 200, 300, 400), choice

   print *, "choice was outside 1:4, so no branch was taken"
   cycle

100 continue
   print *, "branch 100: choice = 1"
   cycle

200 continue
   print *, "branch 200: choice = 2"
   cycle

300 continue
   print *, "branch 300: choice = 3"
   cycle

400 continue
   print *, "branch 400: choice = 4"
end do

print *
print *, "computed goto inside another loop"

do i = 0, 5
   print *, "i =", i

   goto (500, 600, 700), i

   print *, "  i is outside 1:3"
   cycle

500 continue
   print *, "  branch 500: i = 1"
   cycle

600 continue
   print *, "  branch 600: i = 2"
   cycle

700 continue
   print *, "  branch 700: i = 3"
   cycle
end do

print *
print *, "done"

end program xcomputed_goto

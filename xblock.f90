program test_block
implicit none
integer :: x
x = 10
block
   integer :: y
   y = 20
   print *, x, y
end block
print *, x
end program test_block

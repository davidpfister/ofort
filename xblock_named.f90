program test_block_named
implicit none
integer :: x
x = 3
outer: block
   integer :: y
   y = 4
   print *, x + y
end block outer
print *, x
end program test_block_named

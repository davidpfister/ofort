program main
implicit none
integer :: a(3), i, n
n = 3
a = 1
forall (i=2:3)
  a(i) = a(i-1)
do i = 2, n
  a(i) = a(i) + 1
end do
print *, a
end program main
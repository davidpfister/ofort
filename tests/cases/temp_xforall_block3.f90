program main
implicit none
integer :: i
integer :: a(3)
a = 1
forall (i=2:3)
    a(i) = a(i-1)
end forall
print *, a
end program main
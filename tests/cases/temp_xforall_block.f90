program main
implicit none
integer :: i, n
integer :: a_forall(8)
integer :: vals(8)
vals = [1,2,3,4,5,6,7,8]
a_forall = vals
n = 8
forall (i=2:n)
    a_forall(i) = a_forall(i-1)
end forall
print *, a_forall
do i = 2, n
    a_forall(i) = a_forall(i-1)
end do
print *, a_forall
end program main
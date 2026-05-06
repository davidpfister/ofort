program main
implicit none
integer :: i, n
integer :: a_forall(8)
forall (i=1:8) a_forall(i) = i
n = 8
print *, 'initial:        1 2 3 4 5 6 7 8'
forall (i = 2:n) a_forall(i) = a_forall(i-1)
print *, 'after forall:'
print *, a_forall

DO i = 2, n
    a_forall(i) = a_forall(i-1)
end do
print *, 'after do loop:'
print *, a_forall
end program main
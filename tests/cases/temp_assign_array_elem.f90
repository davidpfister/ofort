implicit none
real, allocatable :: x(:)
integer :: i
allocate(x(5))
do i=1,5
 x(i)=i
end do
print *, x
end

implicit none
integer :: u, ios, n, i
real, allocatable :: x(:)
open(newunit=u,file="numbers.txt",status="old",action="read",iostat=ios)
read(u,*,iostat=ios) n
allocate(x(n))
do i=1,n
 read(u,*,iostat=ios) x(i)
end do
print *, n, x
end

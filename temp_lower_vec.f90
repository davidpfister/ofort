program main
implicit none
integer :: v2(-2:2,3:7)
integer :: i,j
print *, lbound(v2), ubound(v2), size(v2)
do j=3,7
 do i=-2,2
  v2(i,j)=100*i+j
 end do
end do
print *, v2([2,-1,1],[7,3,6])
end program main

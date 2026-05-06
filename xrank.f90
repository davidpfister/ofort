program main
implicit none
real, allocatable :: x0, x1(:), x2(:,:)
print*,rank(x0), rank(x1), rank(x2)
end program main
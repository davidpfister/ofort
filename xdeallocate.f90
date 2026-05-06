program main
implicit none
real, allocatable :: x(:), y(:)
allocate (x(3), y(4))
print*,allocated(x), allocated(y)
deallocate (x, y)
print*,allocated(x), allocated(y)
end program main
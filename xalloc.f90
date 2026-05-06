implicit none
real, allocatable :: x(:), y(:)
allocate (x(3), y(4))
call random_number(x)
call random_number(y)
print "(*(f8.4))", x
print "(*(f8.4))", y
end

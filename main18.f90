implicit none
integer, parameter :: n = 1000
real :: x(n)
call random_number(x)
print*,minval(x), maxval(x), sum(x)/n, sum(x**2)/n
end

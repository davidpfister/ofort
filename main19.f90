integer, parameter :: n = 10**6
real :: x(n)
call random_number(x)
print*,sum(x)/n
n = 10**7
end

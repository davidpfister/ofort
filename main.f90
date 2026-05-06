implicit none
integer, parameter :: n = 10**6
integer, parameter :: dp = kind(1.0d0)
real(kind=dp) :: x(n)
call random_number(x)

program main
implicit none
integer, parameter :: dp = kind(1.0d0), n = 3
integer :: i, j
real(kind=dp) :: x(n,n) = 0.0_dp
forall (i=1:n, j=1:n, i/=j) x(i,j) = 1.0_dp/(i-j)
print "(3f9.3)", transpose(x)
print*
forall (i=1:n, j=1:n, i/=j)
   x(i,j) = 10.0_dp/(i-j)
end forall
print "(3f9.3)", transpose(x)
end program main

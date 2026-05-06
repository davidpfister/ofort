program xaint
implicit none
integer, parameter :: dp = kind(1.0d0)

real(kind=dp) :: x

print *, "aint(x) truncates x toward zero and returns a real value."
print *

x =  3.7_dp
print *, "x =", x, " aint(x) =", aint(x)

x = -3.7_dp
print *, "x =", x, " aint(x) =", aint(x)

x =  3.0_dp
print *, "x =", x, " aint(x) =", aint(x)

x = -3.0_dp
print *, "x =", x, " aint(x) =", aint(x)

x =  0.9_dp
print *, "x =", x, " aint(x) =", aint(x)

x = -0.9_dp
print *, "x =", x, " aint(x) =", aint(x)

end program xaint

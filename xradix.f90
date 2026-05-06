program xradix
implicit none

integer, parameter :: n_int = 4
integer, parameter :: n_real = 4

integer :: i
integer :: ia(n_int)
real :: ra(n_real)

ia = [0, 1, -1, 100]
ra = [0.0, 1.0, -1.0, 100.0]

print *, "radix(x) returns the base of the model representation."
print *

print *, "integer examples:"
do i = 1, n_int
   print *, "ia(i) =", ia(i), " radix(ia(i)) =", radix(ia(i))
end do
print *

print *, "integer kind examples:"
print *, "radix(0)   =", radix(0)
print *, "radix(0_1) =", radix(0_1)
print *, "radix(0_2) =", radix(0_2)
print *, "radix(0_4) =", radix(0_4)
print *, "radix(0_8) =", radix(0_8)
print *

print *, "real examples:"
do i = 1, n_real
   print *, "ra(i) =", ra(i), " radix(ra(i)) =", radix(ra(i))
end do
print *

print *, "real kind examples:"
print *, "radix(1.0)   =", radix(1.0)
print *, "radix(1.0_4) =", radix(1.0_4)
print *, "radix(1.0_8) =", radix(1.0_8)

end program xradix

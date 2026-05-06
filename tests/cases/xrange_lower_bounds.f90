integer, parameter :: n = 6
logical, dimension(1:n) :: data
integer, dimension(0:4) :: a
data = .true.
data(1:n/2) = .false.
data(n/2+1:n) = .true.
a(0:4) = (/0, 1, 2, 3, 4/)
if (any(data(1:3))) print *, 101
if (.not. all(data(4:6))) print *, 102
if (sum(a(0:4)) /= 10) print *, 103
print *, 'pass'
end

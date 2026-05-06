integer, dimension(:), allocatable :: a(:)
integer, dimension(2) :: b(2)

allocate(a(2))
a = [1, 2]
b = [3, 4]

if (size(a) /= 2) print *, 101
if (sum(a) /= 3) print *, 102
if (sum(b) /= 7) print *, 103
print *, 'pass'
end

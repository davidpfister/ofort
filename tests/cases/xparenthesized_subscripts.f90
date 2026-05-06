integer :: a(2,2)
integer :: n1, n2
n1 = 2
n2 = 1
a = 0
a((n1),(n2)) = 7
if (a(2,1) /= 7) print *, 101
print *, 'pass'
end

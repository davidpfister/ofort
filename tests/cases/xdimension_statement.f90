integer, allocatable :: a1, a2
dimension :: a2(:)
allocate(a1, a2(2))
a1 = 3
a2 = 4
print *, a1, a2
end

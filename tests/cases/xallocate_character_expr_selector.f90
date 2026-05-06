character(:), allocatable :: real1, real2

allocate(character(len=3+2) :: real1)
allocate(character((3+2),1) :: real2)

real1(:) = "abcde"
real2(:) = "fghij"

if (len(real1) /= 5) print *, 101
if (len(real2) /= 5) print *, 102
if (real1 /= "abcde") print *, 103
if (real2 /= "fghij") print *, 104
print *, 'pass'
end

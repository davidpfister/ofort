character(kind=1,len=:), allocatable :: i
character(kind=1,len=0), allocatable :: j
character(:,1_8), allocatable :: k
character, pointer :: a1, a2, a3, a4, a5

allocate(character(kind=1,len=2) :: i)
allocate(character(0,1) :: j)
allocate(character(len(i)) :: k)
allocate(character(kind=1) :: a1)
allocate(character(len=1) :: a2)
allocate(character :: a3)
allocate(character*1 :: a4)
allocate(character(1,kind=1) :: a5)

i = "12"
j = ""
k = "xy"
a1 = "a"
a2 = "b"
a3 = "c"
a4 = "d"
a5 = "e"

if (i /= 1_"12") print *, 101
if (j /= "") print *, 102
if (len(k) /= 2) print *, 103
if (len(a1) /= 1) print *, 104
if (len(a2) /= 1) print *, 105
if (len(a3) /= 1) print *, 106
if (len(a4) /= 1) print *, 107
if (len(a5) /= 1) print *, 108
print *, 'pass'
end

type point
  integer :: i = 7
end type

type(point), pointer :: p
type(point), pointer :: a(:)

allocate(point :: p)
allocate(point :: a(2))
p%i = 3
a(2)%i = 4
print *, p%i, a(1)%i, a(2)%i
end

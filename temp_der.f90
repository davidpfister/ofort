type inner
  integer, allocatable :: p(:)
end type
type(inner), allocatable :: a(:)
allocate(a(2))
allocate(a(1)%p(2))
print *, a(1)%p
end

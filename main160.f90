type inner
  integer, allocatable :: p(:)
end type
type(inner), allocatable :: a(:)
allocate(a(2))
.info a
end

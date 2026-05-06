type t
  integer :: i
end type
type(t) :: x
x%i = 4
associate(complex => x%i)
  if (complex /= 4) print *, 101
end associate
print *, 'pass'
end

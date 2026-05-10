type sillytype
  real, pointer :: num(:)
end type
type(sillytype) :: data
allocate(data%num(2))
call random_number(data%num(:))
deallocate(data%num)
print *, 'pass'
end

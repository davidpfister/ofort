type ty
  integer :: x
end type
type(ty) :: t(1)
t = [ty :: ty(7)]
print *, t(1)%x
end

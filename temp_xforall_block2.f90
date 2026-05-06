program main
implicit none
integer :: i
integer :: a_forall(3)
i=1
a_forall = 0
if (.false.) then
  a_forall = a_forall
end if
forall (i=2:3)
  a_forall(i) = a_forall(i-1)
end forall
print *, a_forall
end program main
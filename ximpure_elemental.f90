module m
implicit none
contains
impure elemental subroutine sub(x)
real, intent(in) :: x
print*,x,sqrt(x)
end subroutine sub

impure elemental subroutine add(x,y)
real, intent(in) :: x,y
print*,x," + ", y, " = ", x+y
end subroutine add
end module m

program main
use m, only: sub, add
implicit none
real, dimension(3, 4) :: x, y
call sub([0.0, 1.0, 2.0, 4.0])
call add(10.0, [50.0, 60.0])
call add([10.0, 20.0], [50.0, 60.0])
call random_number(x)
call random_number(y)
call add(x,y)
end program main

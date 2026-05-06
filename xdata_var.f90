module sub_mod
integer, parameter :: N = 100
integer, parameter :: S = 5

contains
!
subroutine ini(data)
integer  :: data
integer, save :: val = 0
data = val + S
val  = val + N - 2 * S
end subroutine ini
end module sub_mod

program main
use sub_mod
implicit none
integer :: i
call ini(i)
print*,i
call ini(i)
print*,i
end program main

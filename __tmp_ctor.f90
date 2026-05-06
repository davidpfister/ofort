module m
implicit none
type string_t
  character(len=:), allocatable :: s
end type
contains
subroutine test
  type(string_t) :: x
  x = string_t('a')
  print '(a)', x%s
end subroutine
end module
program p
use m
call test
end

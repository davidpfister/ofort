module m
implicit none
type string_t
  character(len=:), allocatable :: s
end type
interface operator(//)
  module procedure cat
end interface
contains
function cat(a,b) result(c)
type(string_t), intent(in) :: a,b
type(string_t) :: c
c = string_t(a%s // b%s)
end function
subroutine test
  type(string_t) :: x
  x = cat(string_t('a'), string_t('b'))
  print '(a)', x%s
  x = string_t('a') // string_t('b')
  print '(a)', x%s
end subroutine
end module
program p
use m
call test
end

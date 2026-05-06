module xtype_bound_keyword_optional_mod
implicit none

type :: t
contains
   procedure :: show
end type t

contains

subroutine show(self, flag, fmt, label)
class(t), intent(in) :: self
logical, intent(in), optional :: flag
character(len=*), intent(in), optional :: fmt, label
logical :: flag_
character(len=64) :: fmt_

flag_ = .false.
if (present(flag)) flag_ = flag
fmt_ = '(A)'
if (present(fmt)) fmt_ = fmt

if (present(label)) print *, trim(label)
if (flag_) then
   write(*,fmt_) 'true'
else
   write(*,fmt_) 'false'
end if
end subroutine show

end module xtype_bound_keyword_optional_mod

program xtype_bound_keyword_optional
use xtype_bound_keyword_optional_mod, only: t
implicit none
type(t) :: obj

call obj%show(fmt='(A)', label='keyword optional args')
print *, 'ok if the line above says false, not corrupted output'
end program xtype_bound_keyword_optional

module m
interface operator(.inc.)
  module procedure inc
end interface
contains
integer function inc(i)
  integer :: i
  inc = i + 1
end function
end module
use m
print *, .inc. 4
end

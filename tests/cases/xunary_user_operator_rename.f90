module m
interface operator(.add.)
  integer function fun(a)
    integer,intent(in):: a
  end function
end interface
end module
use m, only: operator(.plus.) => operator(.add.)
print *, .plus. 2
end
integer function fun(a)
integer,intent(in):: a
fun=a+1
end function

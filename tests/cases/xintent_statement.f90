subroutine s(i)
integer :: i
intent(in) :: i
print *, i
end
call s(7)
end

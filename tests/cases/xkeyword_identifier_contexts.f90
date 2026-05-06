subroutine s1
integer type(2)
type(2) = 2
if (type(2) /= 2) print *, 101
end

subroutine s2
pointer if
allocate(if)
if = 3
if (if /= 3) print *, 201
end

call s1
call s2
print *, 'pass'
end

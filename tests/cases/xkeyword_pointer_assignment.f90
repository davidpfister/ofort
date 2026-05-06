integer, target :: ii
integer, pointer :: if
ii = 11
if => ii
if (if /= 11) print *, 101
print *, 'pass'
end

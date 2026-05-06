program xread_skip_header
implicit none
integer :: u, value

open(newunit=u, file='xread_skip_header.dat', status='replace', action='write')
write(u,'(A)') 'header'
write(u,'(I0)') 42
close(u)

open(newunit=u, file='xread_skip_header.dat', status='old', action='read')
read(u,'(A)')
read(u,*) value
close(u)

if (value == 42) then
   print *, 'ok'
else
   print *, 'FAIL: value =', value
end if
end program xread_skip_header

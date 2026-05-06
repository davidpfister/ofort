program xadvance_no
implicit none
integer :: u, ios
character(len=80) :: line1, line2, extra

open(newunit=u, file='xadvance_no.out', status='replace', action='write')
write(u,'(A)', advance='no') 'a'
write(u,'(",",A)', advance='no') 'b'
write(u,*)
write(u,'(I0)', advance='no') 12
write(u,'(",",F4.1)', advance='no') 3.5
write(u,*)
close(u)

open(newunit=u, file='xadvance_no.out', status='old', action='read')
read(u,'(A)', iostat=ios) line1
if (ios /= 0) line1 = ''
read(u,'(A)', iostat=ios) line2
if (ios /= 0) line2 = ''
read(u,'(A)', iostat=ios) extra
close(u)

if (trim(line1) == 'a,b' .and. trim(line2) == '12, 3.5' .and. ios /= 0) then
   print *, 'ok'
else
   print *, 'FAIL: expected records:'
   print *, '  a,b'
   print *, '  12, 3.5'
   print *, 'got first records:'
   print *, '  ', trim(line1)
   print *, '  ', trim(line2)
end if
end program xadvance_no

program xdate_format_read
implicit none
character(len=10) :: s
integer :: year, month, day

s = "2002-07-30"
read(s, "(i4,1x,i2,1x,i2)") year, month, day

if (year == 2002 .and. month == 7 .and. day == 30) then
   print *, "ok"
else
   print *, "FAIL:", year, month, day
end if
end program xdate_format_read

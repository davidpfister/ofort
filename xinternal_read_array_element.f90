program xinternal_read_array_element
implicit none
integer, parameter :: dp = kind(1.0d0)
real(dp), allocatable :: a(:,:)
character(len=32) :: s

allocate(a(2,2))
a = 0.0_dp
s = '59.341808'
read(s, *) a(1,1)
s = '37.468731'
read(s, *) a(1,2)

if (abs(a(1,1) - 59.341808_dp) < 1.0e-10_dp .and. &
    abs(a(1,2) - 37.468731_dp) < 1.0e-10_dp) then
   print *, 'ok'
else
   print *, 'FAIL:', a(1,1), a(1,2)
end if
end program xinternal_read_array_element

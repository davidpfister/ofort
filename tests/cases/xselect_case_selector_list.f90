integer :: i
integer :: hits
hits = 0
do i = 1, 5
  select case (i)
  case (2:3,5)
    hits = hits + 1
  case default
    hits = hits
  end select
end do
select case (4)
case (1)
  print *, 'bad'
case (2,3:5,6,8:10)
  print *, hits
end select
end

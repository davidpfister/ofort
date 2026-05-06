implicit none
integer :: i, v(3)
character (len=10) :: s
s = "10 20 30"
read (s, *) (v(i), i=1,3)
print*,v
end
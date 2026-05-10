integer :: a(5), b(5)
logical :: m(5)
a = [1,2,3,4,5]
b = [10,20,30,40,50]
m = [.true., .false., .true., .false., .true.]
where(m) a = b
print *, a
where(m)
  b = 1
elsewhere
  b = 2
endwhere
print *, b
end

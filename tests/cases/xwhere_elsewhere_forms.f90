integer :: a(4)
logical :: m(4), n(4)
a = [1,2,3,4]
m = [.true., .false., .true., .false.]
n = [.false., .true., .false., .true.]
where(m)
  a = 10
else where
  a = 20
end where
print *, a
where(m)
  a = 1
elsewhere(n)
  a = 2
end where
print *, a
end

program p
real :: a(3,2), b(3,2)
a=reshape([1,2,3,4,5,6],[3,2])
b=0
b(1,:)=a(1,:)
print *, b
end program


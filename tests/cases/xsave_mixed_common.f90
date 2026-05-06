call sub()
print *, 'pass'
end
subroutine sub()
save i,j,/myblock/,k
common /myblock/ x1,x2
i = 1
j = 2
k = 3
end

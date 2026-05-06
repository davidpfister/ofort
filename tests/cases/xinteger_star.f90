implicit none
integer*4 a,b
integer*8 c,d
integer*16 e,f
a = 10
b = 20
c = 30
d = 40
print "(*(1x,i0))", a,b,c,d,kind(a),kind(b),kind(c),kind(d)
print "(*(1x,i0))", huge(a),huge(b),huge(c),huge(d),huge(e),huge(f)
end
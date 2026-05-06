implicit none
integer(1) a1,b1
integer(2) a2,b2
integer(4) a,b
integer(8) c,d
integer(16) e,f
a = 10
b = 20
c = 30
d = 40
e = 50
f = 60
print "(*(1x,i0))", a,b,c,d,e,f,kind(a),kind(b),kind(c),kind(d),kind(e),kind(f)
print "(*(1x,i0))", huge(a1),huge(b1),huge(a2),huge(b2),huge(a),huge(b),huge(c),huge(d),huge(e),huge(f)
end
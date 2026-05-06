implicit real(4)(a), real(8)(b), complex(4)(c), complex(8)(d), logical(kind=4)(l)
aa = 1.0
bb = 2.0
cc = (3.0, 4.0)
dd = (5.0, 6.0)
ll = .true.
if (.not. ll) print *, 101
print *, 'pass'
end

implicit none
integer, allocatable :: v(:), w(:)
allocate (v(3), source=10)
allocate (w, mold=v)
print*,v
print*,size(w)
end

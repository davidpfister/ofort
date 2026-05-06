subroutine init_a(a00,n)
real, dimension(1:n) :: a00
a00 = 0
end subroutine init_a

program main
implicit none
real :: a(2)
call init_a(a,size(a))
print*,a
end program main


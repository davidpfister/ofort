subroutine init_a(a00,a01,a02,a03,a04,a05,a06,a07,a08,a09,n)
real(8),dimension(1:n) :: a00,a01,a02,a03,a04,a05,a06,a07,a08,a09
a00 = 0
a09 = 0
end subroutine
program main
integer,parameter :: n=5
real(8),dimension(1:n) :: a00,a01,a02,a03,a04,a05,a06,a07,a08,a09
call init_a(a00,a01,a02,a03,a04,a05,a06,a07,a08,a09,n)
print *, 'ok'
end program

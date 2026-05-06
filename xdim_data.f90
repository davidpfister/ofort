MODULE module1
  IMPLICIT NONE
    integer,parameter :: num=8
    REAL(num), DIMENSION(2,3) :: data
    REAL(num), DIMENSION(2,3) :: x_data=reshape([1,2,3,4,5,6],[2,3])
end module module1

program main
use module1
implicit none
print "(*(f6.1))", data
print "(*(f6.1))", x_data
end program main



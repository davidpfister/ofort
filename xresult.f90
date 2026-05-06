program main
  integer, parameter :: n = 50
  real(8) :: a(n), rslt(n)
  integer :: i

   do i = 1, n
      a(i) = i+1
      rslt(i) = 0
   enddo

  do i = 1, n-1,1
     rslt(i) = log(a(n-i))
  enddo
  write(6,99) rslt

  do i = 1, n-1,2
     rslt(i) = log(a(n-i))
  enddo
  write(6,99) rslt

99 format(5f10.5)
end program main

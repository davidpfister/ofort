program t
  implicit none
  integer, parameter :: n = 8
  integer :: i
  forall (i = 2:n)
    i = i + 1
  end forall
  do i = 2, n
  end do
end program t

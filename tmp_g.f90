program t
  implicit none
  integer, parameter :: n = 8
  integer :: i
  forall (i = 2:n)
    i = i + 1
  end forall
end program t

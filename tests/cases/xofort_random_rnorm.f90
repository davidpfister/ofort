program main
  use ofort_random_mod, only: normal => rnorm
  implicit none
  double precision :: x
  double precision, allocatable :: y(:)
  x = normal()
  y = normal(3)
  if (x == x) print *, size(y)
end program main

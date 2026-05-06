program hello
  use, intrinsic :: iso_fortran_env, only: wp => real64
  implicit none
  real(wp) :: x = 0.0_wp
  print*,wp, kind(x)
end program hello

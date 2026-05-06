program hello
  use, intrinsic :: iso_fortran_env, only: wp => real64, compiler_version
  implicit none

  real(wp) :: x = 0.0_wp
  real(wp) :: h = 1.0e-50_wp

  print *, "Compiler version:", compiler_version()

  associate (r => f(cmplx(x, h, kind=wp)))
    print *, "kind(r):", kind(r)
    print *, "storage_size(r):", storage_size(r)
    print *, "r = ", r
    print *, 1.0_wp / h * r%im  ! the correct result should be 1.0
    print *, 1.0_wp / h * aimag(r)  ! the correct result should be 1.0
  end associate

contains

  complex(wp) function f(x)
    complex(wp), intent(in) :: x
    f = sin(x)
  end function f

end program hello

program demo_eval
  use ofort_binding, only: ofort_interpreter
  implicit none
  type(ofort_interpreter) :: interp
  integer :: rc
  real(8) :: y

  call interp%create()
  rc = interp%execute("integer :: n = 2; print*,n**5")
  call check()
  write (*, '(a)', advance='no') interp%output()

  call interp%reset()
  call interp%set_trace_assign(.true.)
  rc = interp%execute("integer :: x; x = 7 * 8")
  call check()
  write (*, '(a)', advance='no') interp%warnings()

  call interp%reset()
  rc = interp%execute("real function f(x); real :: x; f = x*x + 1; end")
  call check()
  y = interp%call_real1("f", 3.0d0)
  write (*, '(g0)') y
  call interp%destroy()
  
  contains
  subroutine check()
  if (rc /= 0) then
     write (*, '(a)') trim(interp%error())
     stop 1
  end if
  end subroutine check
end program demo_eval

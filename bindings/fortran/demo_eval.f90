program demo_eval
  use ofort_binding, only: ofort_interpreter
  implicit none
  type(ofort_interpreter) :: interp
  integer :: rc

  call interp%create()
  rc = interp%execute("integer :: n = 2; print*,n**5")
  call check()
  write (*, '(a)', advance='no') interp%output()

  call interp%reset()
  call interp%set_trace_assign(.true.)
  rc = interp%execute("integer :: x; x = 7 * 8")
  call check()
  write (*, '(a)', advance='no') interp%warnings()
  call interp%destroy()
  
  contains
  subroutine check()
  if (rc /= 0) then
     write (*, '(a)') trim(interp%error())
     stop 1
  end if
  end subroutine check
end program demo_eval

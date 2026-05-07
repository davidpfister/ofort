program demo_eval
  use ofort_binding
  implicit none
  type(ofort_interpreter) :: interp
  integer :: rc

  call interp%create()
  rc = interp%execute("integer :: n = 2; print*,n**5")
  if (rc /= 0) then
     write (*, '(a)') trim(interp%error())
     stop 1
  end if
  write (*, '(a)', advance='no') interp%output()

  call interp%reset()
  call interp%set_trace_assign(.true.)
  rc = interp%execute("integer :: x; x = 7 * 6")
  if (rc /= 0) then
     write (*, '(a)') trim(interp%error())
     stop 1
  end if
  write (*, '(a)', advance='no') interp%warnings()
  call interp%destroy()
end program demo_eval

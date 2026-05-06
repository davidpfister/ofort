program xinquire_case
  implicit none
  integer :: u, ios, recl, size, pos
  logical :: exists, opened, named
  character(len=64) :: name
  character(len=16) :: access, action, read_str, write_str, rw_str, stream

  inquire(file="xinquire_case.tmp", exist=exists)
  print '(a,l1)', "before = ", exists

  open(newunit=u, file="xinquire_case.tmp", status="replace", action="readwrite", &
       access="stream", position="rewind", iostat=ios)
  write(u, '(a)') "abc"

  inquire(unit=u, opened=opened, named=named, name=name, access=access, &
       action=action, read=read_str, write=write_str, readwrite=rw_str, &
       stream=stream, size=size, pos=pos, iostat=ios)
  print '(a,l1,1x,l1)', "open = ", opened, named
  print '(a,a)', "name = ", trim(name)
  print '(a,a,1x,a,1x,a,1x,a,1x,a)', "modes = ", trim(access), trim(action), &
       trim(read_str), trim(write_str), trim(rw_str)
  print '(a,a)', "stream = ", trim(stream)
  print '(a,i0,1x,i0)', "size pos = ", size, pos

  inquire(iolength=recl) 123, 3.5, "abc"
  print '(a,i0)', "iolength = ", recl

  close(u, status="delete")
  inquire(file="xinquire_case.tmp", exist=exists)
  print '(a,l1)', "after = ", exists
end program xinquire_case

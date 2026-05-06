program test_formatted_stream_io
   implicit none

   integer, parameter :: unit = 10
   integer, parameter :: line_len = 40
   character(len=*), parameter :: filename = "stream_formatted.txt"

   integer :: ios
   integer :: pos1, pos2, pos3
   integer :: id
   real :: x
   character(len=20) :: name
   character(len=line_len) :: rec
   character(len=100) :: line

   open(unit, file=filename, access="stream", form="formatted", &
      status="replace", action="readwrite", iostat=ios)
   if (ios /= 0) error stop "could not open stream file"

   write(unit, '(a,a)', advance="no") "formatted stream i/o example", new_line("a")
   write(unit, '(a,a)', advance="no") "----------------------------", new_line("a")

   inquire(unit, pos=pos1)
   write(rec, '(i4,1x,a20,1x,f8.3)') 1, "alpha", 10.25
   write(unit, '(a,a)', advance="no") rec, new_line("a")

   inquire(unit, pos=pos2)
   write(rec, '(i4,1x,a20,1x,f8.3)') 2, "beta", 20.50
   write(unit, '(a,a)', advance="no") rec, new_line("a")

   inquire(unit, pos=pos3)
   write(rec, '(i4,1x,a20,1x,f8.3)') 3, "gamma", 30.75
   write(unit, '(a,a)', advance="no") rec, new_line("a")

   write(unit, '(a,a)', advance="no") "end", new_line("a")

   write(*, '(a,i0)') "position of record 1: ", pos1
   write(*, '(a,i0)') "position of record 2: ", pos2
   write(*, '(a,i0)') "position of record 3: ", pos3

   rewind(unit)

   write(*, *)
   write(*, '(a)') "read the file sequentially as text lines:"
   do
      read(unit, '(a)', iostat=ios) line
      if (ios /= 0) exit
      write(*, '(a)') trim(line)
   end do

   write(*, *)
   write(*, '(a)') "read selected stream positions using pos=:"

   read(unit, '(a)', pos=pos2, iostat=ios) line
   if (ios /= 0) error stop "error reading line at pos2"

   read(line, '(i4,1x,a20,1x,f8.3)', iostat=ios) id, name, x
   if (ios /= 0) error stop "error parsing line at pos2"

   write(*, '(a,i0,3a,f8.3)') "pos2 gives: id = ", id, ", name = ", trim(name), ", x = ", x

   read(unit, '(a)', pos=pos3, iostat=ios) line
   if (ios /= 0) error stop "error reading line at pos3"

   read(line, '(i4,1x,a20,1x,f8.3)', iostat=ios) id, name, x
   if (ios /= 0) error stop "error parsing line at pos3"

   write(*, '(a,i0,3a,f8.3)') "pos3 gives: id = ", id, ", name = ", trim(name), ", x = ", x

   close(unit)

end program test_formatted_stream_io

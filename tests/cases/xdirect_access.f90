program test_direct_access_file
   implicit none

   integer, parameter :: unit = 10
   integer, parameter :: reclen = 20
   integer, parameter :: nrec = 5

   character(len=reclen) :: rec
   character(len=*), parameter :: filename = "direct_test.dat"
   integer :: i
   integer :: ios

   open(unit, file=filename, access="direct", form="formatted", recl=reclen, &
      status="replace", action="readwrite", iostat=ios)
   if (ios /= 0) error stop "could not open direct access file"

   do i = 1, nrec
      write(rec, '("record ",i0)') i
      write(unit, '(a)', rec=i, iostat=ios) rec
      if (ios /= 0) error stop "error writing direct access record"
   end do

   write(*, '(a)') "read records in nonsequential order:"

   read(unit, '(a)', rec=3, iostat=ios) rec
   if (ios /= 0) error stop "error reading record 3"
   write(*, '(a,i0,a,a)') "rec = ", 3, ": ", trim(rec)

   read(unit, '(a)', rec=1, iostat=ios) rec
   if (ios /= 0) error stop "error reading record 1"
   write(*, '(a,i0,a,a)') "rec = ", 1, ": ", trim(rec)

   read(unit, '(a)', rec=5, iostat=ios) rec
   if (ios /= 0) error stop "error reading record 5"
   write(*, '(a,i0,a,a)') "rec = ", 5, ": ", trim(rec)

   close(unit)

end program test_direct_access_file

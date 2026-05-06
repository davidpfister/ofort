program demo_goto
implicit none

call write_sample_input("numbers.txt")
call process_file("numbers.txt", "squares.txt")

contains

subroutine write_sample_input(filename)
character(len=*), intent(in) :: filename
integer :: unit

open(newunit=unit, file=filename, status="replace", action="write")
write(unit, *) 5
write(unit, *) 1.0
write(unit, *) 2.0
write(unit, *) 3.0
write(unit, *) 4.0
write(unit, *) 5.0
close(unit)
end subroutine write_sample_input

subroutine process_file(input_file, output_file)
character(len=*), intent(in) :: input_file, output_file
integer :: unit_in, unit_out, ios, n, i, ierr
real, allocatable :: x(:), y(:)
logical :: in_open, out_open

ierr = 0
in_open = .false.
out_open = .false.

open(newunit=unit_in, file=input_file, status="old", action="read", iostat=ios)
if (ios /= 0) then
   write(*, '(a)') "error: could not open input file"
   ierr = 1
   goto 900
end if
in_open = .true.

open(newunit=unit_out, file=output_file, status="replace", action="write", iostat=ios)
if (ios /= 0) then
   write(*, '(a)') "error: could not open output file"
   ierr = 1
   goto 900
end if
out_open = .true.

read(unit_in, *, iostat=ios) n
if (ios /= 0 .or. n <= 0) then
   write(*, '(a)') "error: invalid array size in input file"
   ierr = 1
   goto 900
end if

allocate(x(n), stat=ios)
if (ios /= 0) then
   write(*, '(a)') "error: allocation failed for x"
   ierr = 1
   goto 900
end if

allocate(y(n), stat=ios)
if (ios /= 0) then
   write(*, '(a)') "error: allocation failed for y"
   ierr = 1
   goto 900
end if

do i = 1, n
   read(unit_in, *, iostat=ios) x(i)
   if (ios /= 0) then
      write(*, '(a,i0)') "error: failed reading value ", i
      ierr = 1
      goto 900
   end if
end do

y = x**2

write(unit_out, '(a)') " i        x         x^2"
do i = 1, n
   write(unit_out, '(i3,2f10.3)') i, x(i), y(i)
end do

write(*, '(a)') "wrote output to squares.txt"

900 continue

if (allocated(y)) deallocate(y)
if (allocated(x)) deallocate(x)
if (out_open) close(unit_out)
if (in_open) close(unit_in)

if (ierr /= 0) error stop "processing failed"

end subroutine process_file

end program demo_goto

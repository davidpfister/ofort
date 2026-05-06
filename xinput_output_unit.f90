program test_input_output_unit
   use, intrinsic :: iso_fortran_env, only: input_unit, output_unit
   implicit none

   character(len=100) :: name
   integer :: age
   integer :: ios

   write(output_unit, '(a)', advance="no") "Enter your name: "
   read(input_unit, '(a)', iostat=ios) name
   if (ios /= 0) error stop "error reading name"

   write(output_unit, '(a)', advance="no") "Enter your age: "
   read(input_unit, *, iostat=ios) age
   if (ios /= 0) error stop "error reading age"

   write(output_unit, *)
   write(output_unit, '(a)') "Input summary"
   write(output_unit, '(a)') "-------------"
   write(output_unit, '(a,a)') "name: ", trim(name)
   write(output_unit, '(a,i0)') "age:  ", age

end program test_input_output_unit

module string_type_separate_compilation_23
   implicit none
   private

   public :: string_type
   public :: operator(//)

   type :: string_type
      sequence
      private
      character(len=:), allocatable :: raw
   end type string_type

   interface operator(//)
      module procedure :: concat_string_string
   end interface operator(//)

contains

   elemental function concat_string_string(lhs, rhs) result(string)
      ! Concatenate two string_type values.
      type(string_type), intent(in) :: lhs
      type(string_type), intent(in) :: rhs
      type(string_type) :: string

      if (allocated(lhs%raw) .and. allocated(rhs%raw)) then
         string%raw = lhs%raw // rhs%raw
      else if (allocated(lhs%raw)) then
         string%raw = lhs%raw
      else if (allocated(rhs%raw)) then
         string%raw = rhs%raw
      end if

   end function concat_string_string

end module string_type_separate_compilation_23


module ansi_separate_compilation_23
   implicit none
   private

   public :: ansi_code
   public :: operator(//)

   type :: ansi_code
      private
      integer(1) :: style = -1
      integer(1) :: bg = -1
      integer(1) :: fg = -1
   end type ansi_code

   interface operator(//)
      pure module function concat_left(lval, code) result(str)
         character(len=*), intent(in) :: lval
         type(ansi_code), intent(in) :: code
         character(len=:), allocatable :: str
      end function concat_left
   end interface operator(//)

end module ansi_separate_compilation_23


submodule (ansi_separate_compilation_23) ansi_separate_compilation_23_impl
   implicit none

contains

   module procedure concat_left
      ! Concatenate a character string with an ANSI code.
      str = lval
   end procedure concat_left

end submodule ansi_separate_compilation_23_impl


program test_separate_compilation_23
   ! Test the public features exposed by the two modules.
   use string_type_separate_compilation_23, only: string_type, operator(//)
   use ansi_separate_compilation_23, only: ansi_code, operator(//)
   implicit none

   integer, parameter :: n = 3

   type(string_type) :: s0, s1, s2
   type(string_type) :: sa(n), sb(n), sc(n)

   type(ansi_code) :: code
   character(len=:), allocatable :: text

   integer :: i

   print *, "testing string_type scalar concatenation"

   s2 = s0 // s1

   print *, "scalar string_type concatenation completed"

   print *
   print *, "testing string_type elemental array concatenation"

   sc = sa // sb

   print *, "array string_type concatenation completed"
   print *, "size(sc) = ", size(sc)

   print *
   print *, "testing ansi_code concatenation with character lhs"

   text = "hello" // code

   print *, "allocated(text) = ", allocated(text)
   print *, "len(text)      = ", len(text)
   print *, "text           = ", text

   print *
   print *, "testing ansi_code concatenation in an array loop"

   do i = 1, n
      text = "item " // code
      print *, i, allocated(text), len(text)
   end do

   print *
   print *, "tests completed"

end program test_separate_compilation_23

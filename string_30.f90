module stdlib_string_type
   implicit none
   private

   public :: string_type
   public :: string
   public :: char
   public :: operator(//)

   type :: string_type
      private
      character(len=:), allocatable :: raw
   end type string_type

   interface string
      module procedure :: new_string
   end interface string

   interface char
      module procedure :: char_string
   end interface char

   interface operator(//)
      module procedure :: concat_string_string
      module procedure :: concat_string_char
      module procedure :: concat_char_string
   end interface operator(//)

contains

   function new_string(raw) result(str)
      ! Construct a string_type value from a character value.
      character(len=*), intent(in) :: raw
      type(string_type) :: str

      str%raw = raw
   end function new_string

   function char_string(str) result(raw)
      ! Return the raw character value stored in a string_type value.
      type(string_type), intent(in) :: str
      character(len=:), allocatable :: raw

      if (allocated(str%raw)) then
         raw = str%raw
      else
         raw = ""
      end if
   end function char_string

   function concat_string_string(lhs, rhs) result(str)
      ! Concatenate two string_type values.
      type(string_type), intent(in) :: lhs, rhs
      type(string_type) :: str

      str%raw = char(lhs) // char(rhs)
   end function concat_string_string

   function concat_string_char(lhs, rhs) result(str)
      ! Concatenate a string_type value and a character value.
      type(string_type), intent(in) :: lhs
      character(len=*), intent(in) :: rhs
      type(string_type) :: str

      str%raw = char(lhs) // rhs
   end function concat_string_char

   function concat_char_string(lhs, rhs) result(str)
      ! Concatenate a character value and a string_type value.
      character(len=*), intent(in) :: lhs
      type(string_type), intent(in) :: rhs
      type(string_type) :: str

      str%raw = lhs // char(rhs)
   end function concat_char_string

end module stdlib_string_type

module stdlib_ansi
   use stdlib_string_type, only: string_type, string, operator(//)
   implicit none
   private

   public :: ansi_code
   public :: ansi
   public :: to_string
   public :: operator(//)
   public :: concat_left_str, concat_right_str

   type :: ansi_code
      private
      integer(1) :: style = -1_1
      integer(1) :: bg = -1_1
      integer(1) :: fg = -1_1
   end type ansi_code

   interface ansi
      module procedure :: new_ansi_code
   end interface ansi

   interface to_string
      module procedure :: to_string_ansi_code
   end interface to_string

   interface operator(//)
      module procedure :: concat_left_str
      module procedure :: concat_right_str
   end interface operator(//)

contains

   function new_ansi_code(style, fg, bg) result(code)
      ! Construct an ansi_code value from optional style, foreground, and background codes.
      integer(1), intent(in), optional :: style, fg, bg
      type(ansi_code) :: code

      if (present(style)) code%style = style
      if (present(fg)) code%fg = fg
      if (present(bg)) code%bg = bg
   end function new_ansi_code

   function to_string_ansi_code(code) result(str)
      ! Convert an ansi_code value to a simple printable character string.
      type(ansi_code), intent(in) :: code
      character(len=:), allocatable :: str
      character(len=80) :: buf

      write(buf, '("<ansi style=",i0,", fg=",i0,", bg=",i0,">")') &
         code%style, code%fg, code%bg
      str = trim(buf)
   end function to_string_ansi_code

   function concat_left_str(lval, code) result(str)
      ! Concatenate a string_type value on the left with an ansi_code on the right.
      type(string_type), intent(in) :: lval
      type(ansi_code), intent(in) :: code
      type(string_type) :: str

      str = lval // to_string(code)
   end function concat_left_str

   function concat_right_str(code, rval) result(str)
      ! Concatenate an ansi_code on the left with a string_type value on the right.
      type(ansi_code), intent(in) :: code
      type(string_type), intent(in) :: rval
      type(string_type) :: str

      str = string(to_string(code)) // rval
   end function concat_right_str

end module stdlib_ansi

program xtest_stdlib_ansi
   ! Test string_type and ansi_code concatenation overloads.
   use stdlib_string_type, only: string_type, string, char, operator(//)
   use stdlib_ansi, only: ansi_code, ansi, operator(//)
   implicit none

   type(string_type) :: hello, world, s1, s2, s3
   type(ansi_code) :: red

   hello = string("hello")
   world = string("world")
   red = ansi(style=1_1, fg=31_1)

   s1 = hello // ", " // world
   s2 = s1 // red
   s3 = red // s1

   print "('s1 = ',a)", char(s1)
   print "('s2 = ',a)", char(s2)
   print "('s3 = ',a)", char(s3)

end program xtest_stdlib_ansi

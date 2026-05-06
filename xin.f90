module in_operator_mod
   implicit none
   private
   public :: operator(.in.)

   interface operator(.in.)
      module procedure char_in_array
      module procedure int_in_array
   end interface operator(.in.)

contains

   logical function char_in_array(x, a)
      ! checks whether a character value is in a character array
      character(len=*), intent(in) :: x
      character(len=*), intent(in) :: a(:)

      char_in_array = any(x == a)
   end function char_in_array

   logical function int_in_array(x, a)
      ! checks whether an integer value is in an integer array
      integer, intent(in) :: x
      integer, intent(in) :: a(:)

      int_in_array = any(x == a)
   end function int_in_array

end module in_operator_mod

program test_in_operator
   use in_operator_mod, only: operator(.in.)
   implicit none

   integer, parameter :: n_int = 5
   integer, parameter :: n_char = 4
   integer :: nums(n_int)
   character(len=10) :: names(n_char)
   character(len=10) :: word

   nums = [2, 4, 6, 8, 10]
   names = [character(len=10) :: "red", "green", "blue", "yellow"]

   print *, 4 .in. nums
   print *, 5 .in. nums

   word = "green"
   print *, word .in. names

   word = "black"
   print *, word .in. names

end program test_in_operator

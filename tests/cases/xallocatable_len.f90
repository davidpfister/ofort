program xalloc_char
   ! Demonstrate allocatable-length character strings and automatic reallocation.
   implicit none

   character(len=:), allocatable :: s, t
   character(len=:), allocatable :: words(:)
   integer :: i

   s = "Fortran"
   t = "allocatable character"

   print "('s = [',a,'], len = ',i0)", s, len(s)
   print "('t = [',a,'], len = ',i0)", t, len(t)

   s = s // " " // t
   print "('after concatenation:')"
   print "('s = [',a,'], len = ',i0)", s, len(s)

   allocate(character(len=6) :: words(3))
   words = ["alpha ", "beta  ", "gamma "]

   print *
   print "('words array with fixed element length after allocation:')"
   do i = 1, size(words)
      print "('words(',i0,') = [',a,'], len = ',i0)", i, words(i), len(words(i))
   end do

   deallocate(words)
   allocate(character(len=12) :: words(3))
   words = ["red         ", "green       ", "blue        "]

   print *
   print "('same allocatable array reallocated with longer element length:')"
   do i = 1, size(words)
      print "('words(',i0,') = [',a,'], len = ',i0)", i, words(i), len(words(i))
   end do

   t = repeat("*", len(s))
   print *
   print "('separator with same length as s:')"
   print "(a)", t
end program xalloc_char

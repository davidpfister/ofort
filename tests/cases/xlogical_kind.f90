program xlogical_decl
   implicit none

   integer, parameter :: lk1 = kind(.true.)
   integer, parameter :: lk2 = selected_int_kind(2)
   integer, parameter :: lk4 = selected_int_kind(4)

   logical :: a
   logical b

   logical(kind=lk1) :: c
   logical(lk1) :: d

   logical(kind=1) :: e
   logical(1) :: f

   logical(kind=2) :: g
   logical(2) :: h

   logical(kind=4) :: i
   logical(4) :: j

   logical(kind=8) :: k
   logical(8) :: l

   logical(kind=lk2) :: m
   logical(lk2) :: n

   logical(kind=lk4) :: o
   logical(lk4) :: p

   logical, dimension(3) :: arr1
   logical(kind=lk1), dimension(3) :: arr2
   logical(lk1), dimension(3) :: arr3

   logical :: scalar_result
   logical(kind=lk1) :: kind_result

   a = .true.
   b = .false.

   c = .true._lk1
   d = .false._lk1

   e = .true._1
   f = .false._1

   g = .true._2
   h = .false._2

   i = .true._4
   j = .false._4

   k = .true._8
   l = .false._8

   m = .true._lk2
   n = .false._lk2

   o = .true._lk4
   p = .false._lk4

   arr1 = [.true., .false., a]
   arr2 = [.true._lk1, .false._lk1, c]
   arr3 = [.false._lk1, .true._lk1, d]

   scalar_result = a .and. .not. b
   kind_result = c .or. d

   print *, "default logical:"
   print *, kind(a), a
   print *, kind(b), b

   print *, "logical(kind=lk1), logical(lk1):"
   print *, kind(c), c
   print *, kind(d), d

   print *, "logical(kind=1), logical(1):"
   print *, kind(e), e
   print *, kind(f), f

   print *, "logical(kind=2), logical(2):"
   print *, kind(g), g
   print *, kind(h), h

   print *, "logical(kind=4), logical(4):"
   print *, kind(i), i
   print *, kind(j), j

   print *, "logical(kind=8), logical(8):"
   print *, kind(k), k
   print *, kind(l), l

   print *, "logical(kind=lk2), logical(lk2):"
   print *, kind(m), m
   print *, kind(n), n

   print *, "logical(kind=lk4), logical(lk4):"
   print *, kind(o), o
   print *, kind(p), p

   print *, "logical arrays:"
   print *, kind(arr1), arr1
   print *, kind(arr2), arr2
   print *, kind(arr3), arr3

   print *, "logical expressions:"
   print *, kind(scalar_result), scalar_result
   print *, kind(kind_result), kind_result

end program xlogical_decl

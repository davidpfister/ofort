program xassociate
   implicit none

   integer, parameter :: dp = kind(1.0d0)
   integer, parameter :: n = 5
   integer, parameter :: nr = 2, nc = 3
   integer :: i
   integer :: a(n)
   real(kind=dp) :: x(n)
   real(kind=dp) :: mat(nr,nc)
   character(len=20) :: s
   type point
      real(kind=dp) :: x
      real(kind=dp) :: y
   end type point
   type(point) :: p

   a = [(10*i, i = 1, n)]
   x = [1.0_dp, 2.0_dp, 3.0_dp, 4.0_dp, 5.0_dp]
   mat = reshape([1.0_dp, 2.0_dp, 3.0_dp, 4.0_dp, 5.0_dp, 6.0_dp], [nr,nc])
   s = "abcdef"
   p = point(3.0_dp, 4.0_dp)

   print *, "case 1: scalar variable association"
   associate (y => a(2))
      print *, y
      y = 99
   end associate
   print *, a

   print *, "case 2: array section association"
   associate (v => a(2:4))
      print *, v
      v = v + 1
   end associate
   print *, a

   print *, "case 3: expression association"
   associate (z => x + 10.0_dp)
      print *, z
      ! z = 0.0_dp   ! invalid: z is associated with an expression
   end associate

   print *, "case 4: nested associate"
   associate (u => x(1:3))
      associate (avg => sum(u) / real(size(u), kind=dp))
         print *, avg
      end associate
   end associate

   print *, "case 5: derived type component association"
   associate (px => p%x, py => p%y)
      print *, px, py
      px = px + 1.0_dp
      py = py + 2.0_dp
   end associate
   print *, p%x, p%y

   print *, "case 6: character substring association"
   associate (sub => s(2:4))
      print *, sub
      sub = "XYZ"
   end associate
   print *, trim(s)

   print *, "case 7: matrix column association"
   associate (col => mat(:,2))
      print *, col
      col = -col
   end associate
   print *, mat

   print *, "case 8: matrix row expression association"
   associate (row_sum => sum(mat, dim=2))
      print *, row_sum
   end associate

   print *, "case 9: multiple associations"
   associate (first => a(1), last => a(n), total => sum(a))
      print *, first, last, total
      first = -1
      last = -5
   end associate
   print *, a

   print *, "case 10: associate in do loop"
   do i = 1, n
      associate (elem => a(i))
         elem = elem + i
      end associate
   end do
   print *, a

end program xassociate

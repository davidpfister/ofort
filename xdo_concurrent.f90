program xdo_concurrent
   implicit none

   integer, parameter :: n = 10
   integer, parameter :: m = 4
   integer :: i, j
   integer :: a(n), b(n), c(n)
   integer :: mat(n,m), row_sum(n)
   logical :: mask(n)

   a = [(i, i = 1, n)]
   b = [(10*i, i = 1, n)]
   c = 0
   mat = 0
   row_sum = 0
   mask = [(mod(i, 2) == 0, i = 1, n)]

   print *, "basic do concurrent"
   do concurrent (i = 1:n)
      c(i) = a(i) + b(i)
   end do
   print *, c

   print *, "do concurrent with stride"
   do concurrent (i = 1:n:2)
      c(i) = -c(i)
   end do
   print *, c

   print *, "do concurrent with mask"
   do concurrent (i = 1:n, mask(i))
      c(i) = 1000 + i
   end do
   print *, c

   print *, "nested concurrent indices"
   do concurrent (i = 1:n, j = 1:m)
      mat(i,j) = 100*i + j
   end do

   do i = 1, n
      print *, mat(i,:)
   end do

   print *, "row sums computed independently"
   do concurrent (i = 1:n)
      row_sum(i) = sum(mat(i,:))
   end do
   print *, row_sum

   print *, "local block variables inside do concurrent"
   do concurrent (i = 1:n)
      block
         integer :: t
         t = a(i)*a(i)
         c(i) = t + b(i)
      end block
   end do
   print *, c

   print *, "locality spec if compiler supports Fortran 2018"
   call test_locality(a, b)

contains

   subroutine test_locality(x, y)
      integer, intent(in) :: x(:), y(:)

      integer :: z(size(x))
      integer :: i, tmp

      z = 0
      tmp = -999

      do concurrent (i = 1:size(x)) local(tmp)
         tmp = x(i) - y(i)
         z(i) = tmp*tmp
      end do

      print *, z
      print *, "tmp after loop =", tmp
   end subroutine test_locality

end program xdo_concurrent

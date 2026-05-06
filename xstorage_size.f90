program xstorage_size
   ! Demonstrate storage_size for integers, reals, logicals, characters, arrays, and derived types.
   implicit none

   integer, parameter :: dp = kind(1.0d0)
   integer, parameter :: n = 4
   integer :: i
   real :: x
   real(kind=dp) :: xd
   logical :: flag
   character(len=10) :: word
   integer :: ivec(n)

   type :: point
      real(kind=dp) :: x, y
      integer :: label
   end type point

   type(point) :: p

   i = 123
   x = 1.25
   xd = 1.25_dp
   flag = .true.
   word = "fortran"
   ivec = [1, 2, 3, 4]
   p = point(1.0_dp, 2.0_dp, 7)

   print "('storage_size(i)       = ',i0,' bits')", storage_size(i)
   print "('storage_size(x)       = ',i0,' bits')", storage_size(x)
   print "('storage_size(xd)      = ',i0,' bits')", storage_size(xd)
   print "('storage_size(flag)    = ',i0,' bits')", storage_size(flag)
   print "('storage_size(word)    = ',i0,' bits')", storage_size(word)
   print "('storage_size(ivec)    = ',i0,' bits per element')", storage_size(ivec)
   print "('storage_size(p)       = ',i0,' bits')", storage_size(p)

   print *
   print "('size(ivec)            = ',i0)", size(ivec)
   print "('total bits in ivec    = ',i0)", size(ivec)*storage_size(ivec)

end program xstorage_size

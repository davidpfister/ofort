program test_bessel_intrinsics
   implicit none

   integer, parameter :: dp = kind(1.0d0)
   integer, parameter :: nx = 6
   integer, parameter :: nmax = 5

   real(kind=dp) :: xvals(nx)
   real(kind=dp) :: x
   real(kind=dp) :: left, right
   integer :: i, n

   xvals = [0.0_dp, 0.5_dp, 1.0_dp, 2.0_dp, 5.0_dp, 10.0_dp]

   print '(a)', "Bessel functions of the first kind: bessel_j0, bessel_j1"
   print '(a)', "x              j0(x)              j1(x)"
   print '(a)', "---------------------------------------------"

   do i = 1, nx
      x = xvals(i)
      print '(f8.3,2es20.10)', x, bessel_j0(x), bessel_j1(x)
   end do

   print *
   print '(a)', "Bessel functions of the second kind: bessel_y0, bessel_y1"
   print '(a)', "x              y0(x)              y1(x)"
   print '(a)', "---------------------------------------------"

   do i = 1, nx
      x = xvals(i)

      if (x <= 0.0_dp) then
         print '(f8.3,2a20)', x, "undefined", "undefined"
      else
         print '(f8.3,2es20.10)', x, bessel_y0(x), bessel_y1(x)
      end if
   end do

   print *
   print '(a)', "Bessel functions of integer order: bessel_jn(n,x), bessel_yn(n,x)"
   print '(a)', "n      x              jn(n,x)           yn(n,x)"
   print '(a)', "------------------------------------------------------"

   x = 2.5_dp
   do n = 0, nmax
      print '(i2,f12.3,2es20.10)', n, x, bessel_jn(n, x), bessel_yn(n, x)
   end do

   print *
   print '(a)', "Array form bessel_jn(n1,n2,x): orders 0 through nmax"
   print '(a)', "bessel_jn(0,nmax,2.5) = "
   print '(6es16.8)', bessel_jn(0, nmax, x)

   print *
   print '(a)', "Array form bessel_yn(n1,n2,x): orders 0 through nmax"
   print '(a)', "bessel_yn(0,nmax,2.5) = "
   print '(6es16.8)', bessel_yn(0, nmax, x)

   print *
   print '(a)', "Recurrence check for J_n:"
   print '(a)', "J_{n+1}(x) = 2*n/x*J_n(x) - J_{n-1}(x)"
   print '(a)', "n      left side        right side       difference"
   print '(a)', "------------------------------------------------------"

   x = 3.0_dp
   do n = 1, nmax
      left = bessel_jn(n + 1, x)
      right = 2.0_dp * real(n, kind=dp) / x * bessel_jn(n, x) - bessel_jn(n - 1, x)

      print '(i2,3es18.8)', n, left, right, left - right
   end do

   print *
   print '(a)', "Recurrence check for Y_n:"
   print '(a)', "Y_{n+1}(x) = 2*n/x*Y_n(x) - Y_{n-1}(x)"
   print '(a)', "n      left side        right side       difference"
   print '(a)', "------------------------------------------------------"

   x = 3.0_dp
   do n = 1, nmax
      left = bessel_yn(n + 1, x)
      right = 2.0_dp * real(n, kind=dp) / x * bessel_yn(n, x) - bessel_yn(n - 1, x)

      print '(i2,3es18.8)', n, left, right, left - right
   end do

end program test_bessel_intrinsics

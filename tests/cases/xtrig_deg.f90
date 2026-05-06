program test_d_trig_functions
   implicit none

   integer, parameter :: dp = kind(1.0d0)
   integer, parameter :: n_angle = 7
   integer, parameter :: n_value = 5
   integer, parameter :: n_pair = 4

   real(kind=dp) :: angles(n_angle)
   real(kind=dp) :: values(n_value)
   real(kind=dp) :: y(n_pair), x(n_pair)
   integer :: i

   angles = [-180.0_dp, -90.0_dp, -45.0_dp, 0.0_dp, 30.0_dp, 60.0_dp, 90.0_dp]
   values = [-1.0_dp, -0.5_dp, 0.0_dp, 0.5_dp, 1.0_dp]

   y = [0.0_dp, 1.0_dp, 1.0_dp, -1.0_dp]
   x = [1.0_dp, 0.0_dp, 1.0_dp, -1.0_dp]

   print '(a)', "degree trig functions: sind, cosd, tand"
   print '(a)', " angle        sind(angle)        cosd(angle)        tand(angle)"
   do i = 1, n_angle
      print '(f8.2,3f18.8)', angles(i), sind(angles(i)), cosd(angles(i)), tand(angles(i))
   end do

   print *
   print '(a)', "inverse degree trig functions: asind, acosd, atand"
   print '(a)', " value        asind(value)       acosd(value)       atand(value)"
   do i = 1, n_value
      print '(f8.2,3f18.8)', values(i), asind(values(i)), acosd(values(i)), atand(values(i))
   end do

   print *
   print '(a)', "two-argument inverse tangent in degrees: atan2d(y,x)"
   print '(a)', " y            x             atan2d(y,x)"
   do i = 1, n_pair
      print '(2f12.4,f18.8)', y(i), x(i), atan2d(y(i), x(i))
   end do

   print *
   print '(a)', "identity checks"
   print '(a)', " angle        asind(sind(angle)) acosd(cosd(angle)) atand(tand(angle))"
   do i = 1, n_angle
      print '(f8.2,3f18.8)', angles(i), &
         asind(sind(angles(i))), acosd(cosd(angles(i))), atand(tand(angles(i)))
   end do

end program test_d_trig_functions

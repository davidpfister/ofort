module mean_mod
   implicit none

   integer, parameter :: dp = kind(1.0d0)

contains

   function mean(x) result(y)
      ! Return the mean of a rank-1, rank-2, or rank-3 real array.
      real(kind=dp), intent(in) :: x(..)
      real(kind=dp) :: y

      select rank (x)
      rank (1)
         y = sum(x) / real(size(x), kind=dp)
      rank (2)
         y = sum(x) / real(size(x), kind=dp)
      rank (3)
         y = sum(x) / real(size(x), kind=dp)
      rank default
         error stop "mean only supports rank-1, rank-2, and rank-3 arrays"
      end select
   end function mean

end module mean_mod

program xselect_rank_mean
   ! Demonstrate a mean function using select rank for 1D, 2D, and 3D arrays.
   use mean_mod, only: dp, mean
   implicit none

   integer, parameter :: n1 = 5, nrow = 2, ncol = 3, nlev = 2
   real(kind=dp) :: x1(n1), x2(nrow, ncol), x3(nrow, ncol, nlev)

   x1 = [1.0_dp, 2.0_dp, 3.0_dp, 4.0_dp, 5.0_dp]

   x2 = reshape([1.0_dp, 2.0_dp, 3.0_dp, 4.0_dp, 5.0_dp, 6.0_dp], &
                shape(x2))

   x3 = reshape([1.0_dp, 2.0_dp, 3.0_dp, 4.0_dp, 5.0_dp, 6.0_dp, &
                 7.0_dp, 8.0_dp, 9.0_dp, 10.0_dp, 11.0_dp, 12.0_dp], &
                shape(x3))

   print "('mean(x1) = ',f8.3)", mean(x1)
   print "('mean(x2) = ',f8.3)", mean(x2)
   print "('mean(x3) = ',f8.3)", mean(x3)

end program xselect_rank_mean

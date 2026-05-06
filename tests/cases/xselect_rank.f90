module mean_mod
  implicit none
  integer, parameter :: dp = kind(1.0d0)
contains
  function mean(x) result(y)
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
      error stop "unsupported rank"
    end select
  end function mean
end module mean_mod

program xselect_rank_mean
  use mean_mod, only: dp, mean
  implicit none
  real(kind=dp) :: x1(5), x2(2,3), x3(2,3,2)

  x1 = [1.0_dp, 2.0_dp, 3.0_dp, 4.0_dp, 5.0_dp]
  x2 = reshape([1.0_dp, 2.0_dp, 3.0_dp, 4.0_dp, 5.0_dp, 6.0_dp], shape(x2))
  x3 = reshape([1.0_dp, 2.0_dp, 3.0_dp, 4.0_dp, 5.0_dp, 6.0_dp, &
                7.0_dp, 8.0_dp, 9.0_dp, 10.0_dp, 11.0_dp, 12.0_dp], shape(x3))

  print "('mean(x1) = ',f8.3)", mean(x1)
  print "('mean(x2) = ',f8.3)", mean(x2)
  print "('mean(x3) = ',f8.3)", mean(x3)
end program xselect_rank_mean

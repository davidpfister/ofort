module ofort_statistics_mod
  use iso_c_binding, only: c_double, c_int
  implicit none
  private
  public :: mean, variance, sd, cov, cor

  interface
    function c_ofort_stats_mean_r8(x, n) bind(c, name="ofort_stats_mean_r8") result(y)
      import :: c_double, c_int
      real(c_double), intent(in) :: x(*)
      integer(c_int), value :: n
      real(c_double) :: y
    end function

    function c_ofort_stats_variance_r8(x, n) bind(c, name="ofort_stats_variance_r8") result(y)
      import :: c_double, c_int
      real(c_double), intent(in) :: x(*)
      integer(c_int), value :: n
      real(c_double) :: y
    end function

    function c_ofort_stats_sd_r8(x, n) bind(c, name="ofort_stats_sd_r8") result(y)
      import :: c_double, c_int
      real(c_double), intent(in) :: x(*)
      integer(c_int), value :: n
      real(c_double) :: y
    end function

    function c_ofort_stats_cov_r8(x, y, n) bind(c, name="ofort_stats_cov_r8") result(z)
      import :: c_double, c_int
      real(c_double), intent(in) :: x(*), y(*)
      integer(c_int), value :: n
      real(c_double) :: z
    end function

    function c_ofort_stats_cor_r8(x, y, n) bind(c, name="ofort_stats_cor_r8") result(z)
      import :: c_double, c_int
      real(c_double), intent(in) :: x(*), y(*)
      integer(c_int), value :: n
      real(c_double) :: z
    end function
  end interface

contains

  function mean(x) result(y)
    real(c_double), intent(in) :: x(:)
    real(c_double) :: y
    y = c_ofort_stats_mean_r8(x, int(size(x), c_int))
  end function

  function variance(x) result(y)
    real(c_double), intent(in) :: x(:)
    real(c_double) :: y
    y = c_ofort_stats_variance_r8(x, int(size(x), c_int))
  end function

  function sd(x) result(y)
    real(c_double), intent(in) :: x(:)
    real(c_double) :: y
    y = c_ofort_stats_sd_r8(x, int(size(x), c_int))
  end function

  function cov(x, y) result(z)
    real(c_double), intent(in) :: x(:), y(:)
    real(c_double) :: z
    if (size(x) /= size(y)) error stop "cov requires arrays of the same size"
    z = c_ofort_stats_cov_r8(x, y, int(size(x), c_int))
  end function

  function cor(x, y) result(z)
    real(c_double), intent(in) :: x(:), y(:)
    real(c_double) :: z
    if (size(x) /= size(y)) error stop "cor requires arrays of the same size"
    z = c_ofort_stats_cor_r8(x, y, int(size(x), c_int))
  end function

end module ofort_statistics_mod

module ofort_stats_mod
  use ofort_statistics_mod
end module ofort_stats_mod

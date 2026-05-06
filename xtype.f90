module year_month_mod
implicit none
private
public :: year_month, make_year_month, print_year_month

type :: year_month
   integer :: year
   integer :: month
end type year_month

contains

function make_year_month(year, month) result(ym)
   ! Creates a year-month value after checking the month.
   integer, intent(in) :: year
   integer, intent(in) :: month
   type(year_month) :: ym

   if (month < 1 .or. month > 12) error stop "month must be between 1 and 12"

   ym%year = year
   ym%month = month
end function make_year_month

subroutine print_year_month(ym)
   ! Prints a year-month value as yyyy-mm.
   type(year_month), intent(in) :: ym

   write (*,'(i4.4,"-",i2.2)') ym%year, ym%month
end subroutine print_year_month

end module year_month_mod

program xyear_month
use year_month_mod, only: year_month, make_year_month, print_year_month
implicit none

type(year_month) :: ym0
type(year_month) :: ym1

ym0 = make_year_month(2026, 5)
ym1%year = 2027
ym1%month = 12

print *, "ym0 = "
call print_year_month(ym0)

print *, "ym1 = "
call print_year_month(ym1)

end program xyear_month

! ---- begin date.f90 ----
module date_mod
implicit none
private
public :: date, valid, date_from_iso, date_from_basic, &
   operator(+), operator(-), operator(==), operator(/=), &
   operator(<), operator(<=), operator(>), operator(>=)

type :: date
   integer :: year = 0
   integer :: month = 0
   integer :: day = 0
contains
   procedure :: to_str ! return date as yyyy-mm-dd
end type date

interface operator(+)
   module procedure add_days_right
   module procedure add_days_left
end interface

interface operator(-)
   module procedure subtract_days
   module procedure difference_days
end interface

interface operator(==)
   module procedure eq_date
end interface

interface operator(/=)
   module procedure ne_date
end interface

interface operator(<)
   module procedure lt_date
end interface

interface operator(<=)
   module procedure le_date
end interface

interface operator(>)
   module procedure gt_date
end interface

interface operator(>=)
   module procedure ge_date
end interface

contains

pure elemental function to_str(this) result(s) ! return date as yyyy-mm-dd
class(date), intent(in) :: this
character(len=10) :: s
s = zero_pad_4(this%year) // '-' // zero_pad_2(this%month) // '-' // zero_pad_2(this%day)
end function to_str

pure elemental logical function valid(x) ! return true if the date is valid
type(date), intent(in) :: x
valid = .false.
if (x%month < 1 .or. x%month > 12) return
if (x%day < 1) return
if (x%day > days_in_month(x%year, x%month)) return
valid = .true.
end function valid

pure elemental integer function days_in_month(year, month) ! return number of days in a year-month pair
integer, intent(in) :: year, month
select case (month)
case (1,3,5,7,8,10,12)
   days_in_month = 31
case (4,6,9,11)
   days_in_month = 30
case (2)
   if ((mod(year,4) == 0 .and. mod(year,100) /= 0) .or. mod(year,400) == 0) then
      days_in_month = 29
   else
      days_in_month = 28
   end if
case default
   days_in_month = 0
end select
end function days_in_month

pure function date_from_iso(s) result(x) ! convert yyyy-mm-dd to a date
character(len=*), intent(in) :: s
type(date) :: x
character(len=len(s)) :: t
integer :: y, m, d
logical :: ok1, ok2, ok3

x = date(0,0,0)
t = adjustl(s)
if (len_trim(t) /= 10) return
if (t(5:5) /= '-' .or. t(8:8) /= '-') return
call parse_uint(t(1:4), y, ok1)
call parse_uint(t(6:7), m, ok2)
call parse_uint(t(9:10), d, ok3)
if (.not. (ok1 .and. ok2 .and. ok3)) return
x = date(y,m,d)
end function date_from_iso

pure function date_from_basic(s) result(x) ! convert yyyymmdd to a date
character(len=*), intent(in) :: s
type(date) :: x
character(len=len(s)) :: t
integer :: y, m, d
logical :: ok1, ok2, ok3

x = date(0,0,0)
t = adjustl(s)
if (len_trim(t) /= 8) return
call parse_uint(t(1:4), y, ok1)
call parse_uint(t(5:6), m, ok2)
call parse_uint(t(7:8), d, ok3)
if (.not. (ok1 .and. ok2 .and. ok3)) return
x = date(y,m,d)
end function date_from_basic

pure elemental type(date) function add_days_right(x, n) ! return date plus integer number of days
type(date), intent(in) :: x
integer, intent(in) :: n
if (.not. valid(x)) then
   add_days_right = date(0,0,0)
else
   add_days_right = from_day_number(day_number(x) + n)
end if
end function add_days_right

pure elemental type(date) function add_days_left(n, x) ! return integer number of days plus date
integer, intent(in) :: n
type(date), intent(in) :: x
add_days_left = add_days_right(x, n)
end function add_days_left

pure elemental type(date) function subtract_days(x, n) ! return date minus integer number of days
type(date), intent(in) :: x
integer, intent(in) :: n
subtract_days = add_days_right(x, -n)
end function subtract_days

pure elemental integer function difference_days(x, y) ! return number of days between two dates
type(date), intent(in) :: x, y
if (.not. valid(x) .or. .not. valid(y)) then
   difference_days = 0
else
   difference_days = day_number(x) - day_number(y)
end if
end function difference_days

pure elemental logical function eq_date(x, y) ! return true if two dates are equal
type(date), intent(in) :: x, y
eq_date = x%year == y%year .and. x%month == y%month .and. x%day == y%day
end function eq_date

pure elemental logical function ne_date(x, y) ! return true if two dates are not equal
type(date), intent(in) :: x, y
ne_date = .not. eq_date(x, y)
end function ne_date

pure elemental logical function lt_date(x, y) ! return true if left date is earlier than right date
type(date), intent(in) :: x, y
lt_date = x%year < y%year .or. (x%year == y%year .and. (x%month < y%month .or. (x%month == y%month .and. x%day < y%day)))
end function lt_date

pure elemental logical function le_date(x, y) ! return true if left date is earlier than or equal to right date
type(date), intent(in) :: x, y
le_date = lt_date(x, y) .or. eq_date(x, y)
end function le_date

pure elemental logical function gt_date(x, y) ! return true if left date is later than right date
type(date), intent(in) :: x, y
gt_date = .not. le_date(x, y)
end function gt_date

pure elemental logical function ge_date(x, y) ! return true if left date is later than or equal to right date
type(date), intent(in) :: x, y
ge_date = .not. lt_date(x, y)
end function ge_date

pure elemental integer function day_number(x) ! return day count used for arithmetic
type(date), intent(in) :: x
integer :: y, m, d, era, yoe, doy, doe, mp
y = x%year
m = x%month
d = x%day
if (m <= 2) y = y - 1
era = floor_div(y, 400)
yoe = y - era*400
if (m > 2) then
   mp = m - 3
else
   mp = m + 9
end if
doy = (153*mp + 2)/5 + d - 1
doe = yoe*365 + yoe/4 - yoe/100 + doy
day_number = era*146097 + doe - 719468
end function day_number

pure elemental type(date) function from_day_number(z) ! convert internal day count to a date
integer, intent(in) :: z
integer :: zz, era, doe, yoe, y, doy, mp, m, d
zz = z + 719468
era = floor_div(zz, 146097)
doe = zz - era*146097
yoe = (doe - doe/1460 + doe/36524 - doe/146096)/365
y = yoe + era*400
doy = doe - (365*yoe + yoe/4 - yoe/100)
mp = (5*doy + 2)/153
d = doy - (153*mp + 2)/5 + 1
if (mp < 10) then
   m = mp + 3
else
   m = mp - 9
end if
if (m <= 2) y = y + 1
from_day_number = date(y,m,d)
end function from_day_number

pure elemental integer function floor_div(a, b) ! return floor(a/b) for positive b
integer, intent(in) :: a, b
floor_div = a / b
if (mod(a, b) < 0) floor_div = floor_div - 1
end function floor_div

pure elemental function zero_pad_2(n) result(s) ! return a 2-character zero-padded integer string
integer, intent(in) :: n
character(len=2) :: s
if (n < 0 .or. n > 99) then
   s = '**'
   return
end if
s(1:1) = achar(iachar('0') + n/10)
s(2:2) = achar(iachar('0') + mod(n,10))
end function zero_pad_2

pure elemental function zero_pad_4(n) result(s) ! return a 4-character zero-padded integer string
integer, intent(in) :: n
character(len=4) :: s
integer :: m
if (n < 0 .or. n > 9999) then
   s = '****'
   return
end if
m = n
s(4:4) = achar(iachar('0') + mod(m,10))
m = m / 10
s(3:3) = achar(iachar('0') + mod(m,10))
m = m / 10
s(2:2) = achar(iachar('0') + mod(m,10))
m = m / 10
s(1:1) = achar(iachar('0') + mod(m,10))
end function zero_pad_4

pure subroutine parse_uint(s, n, ok) ! parse a nonnegative integer from a string
character(len=*), intent(in) :: s
integer, intent(out) :: n
logical, intent(out) :: ok
integer :: i, m, digit
character(len=len(s)) :: t
n = 0
ok = .false.
t = adjustl(s)
m = len_trim(t)
if (m <= 0) return
do i = 1, m
   if (t(i:i) < '0' .or. t(i:i) > '9') return
   digit = iachar(t(i:i)) - iachar('0')
   n = 10*n + digit
end do
ok = .true.
end subroutine parse_uint

end module date_mod
! ---- end date.f90 ----

! ---- begin kind.f90 ----
module kind_mod
    use iso_fortran_env, only: int64
    implicit none
    public :: dp, long_int
    integer, parameter :: dp = kind(1.0d0), long_int=int64
end module kind_mod
! ---- end kind.f90 ----

! ---- begin constants.f90 ----
module constants_mod
    use kind_mod
    implicit none
    public

    real(dp), parameter :: pi = 3.14159265358979323846_dp
    real(dp), parameter :: catalan = 0.91596559417721901505_dp

end module constants_mod
! ---- end constants.f90 ----

! ---- begin pca_jacobi.f90 ----
module pca_jacobi_mod
use kind_mod, only: dp
implicit none
private
public :: principal_components_cov, jacobi_eigen_sym

contains

subroutine principal_components_cov(covmat, evals, evecs, var_explained, tol, max_sweeps)
! compute principal components of a symmetric covariance matrix
real(kind=dp), intent(in) :: covmat(:,:)
real(kind=dp), allocatable, intent(out) :: evals(:)
real(kind=dp), allocatable, intent(out) :: evecs(:,:)
real(kind=dp), allocatable, intent(out), optional :: var_explained(:)
real(kind=dp), intent(in), optional :: tol
integer, intent(in), optional :: max_sweeps
real(kind=dp) :: total_var
integer :: n

n = size(covmat, 1)
if (size(covmat, 2) /= n) then
   error stop "principal_components_cov: covmat must be square"
end if
if (n <= 0) then
   error stop "principal_components_cov: covmat must have positive size"
end if
if (maxval(abs(covmat - transpose(covmat))) > 100.0_dp*epsilon(1.0_dp)) then
   error stop "principal_components_cov: covmat must be symmetric"
end if

call jacobi_eigen_sym(covmat, evals, evecs, tol, max_sweeps)

if (present(var_explained)) then
   allocate(var_explained(n))
   total_var = sum(evals)
   if (total_var > 0.0_dp) then
      var_explained = evals / total_var
   else
      var_explained = 0.0_dp
   end if
end if
end subroutine principal_components_cov

subroutine jacobi_eigen_sym(a_in, evals, evecs, tol, max_sweeps)
! compute eigenpairs of a real symmetric matrix by Jacobi rotations
real(kind=dp), intent(in) :: a_in(:,:)
real(kind=dp), allocatable, intent(out) :: evals(:)
real(kind=dp), allocatable, intent(out) :: evecs(:,:)
real(kind=dp), intent(in), optional :: tol
integer, intent(in), optional :: max_sweeps
real(kind=dp), allocatable :: a(:,:), v(:,:), tmp(:)
real(kind=dp) :: tol_, app, aqq, apq, c, s, tau, t, offmax
real(kind=dp) :: aip, aiq, vip, viq
integer :: n, i, j, p, q, sweep, max_sweeps_
logical :: converged

n = size(a_in, 1)
if (size(a_in, 2) /= n) then
   error stop "jacobi_eigen_sym: matrix must be square"
end if
if (maxval(abs(a_in - transpose(a_in))) > 100.0_dp*epsilon(1.0_dp)) then
   error stop "jacobi_eigen_sym: matrix must be symmetric"
end if

allocate(a(n,n), v(n,n), evals(n), evecs(n,n), tmp(n))
a = a_in
v = 0.0_dp
do i = 1, n
   v(i,i) = 1.0_dp
end do

tol_ = sqrt(epsilon(1.0_dp))
if (present(tol)) tol_ = tol
max_sweeps_ = max(20*n*n, 50)
if (present(max_sweeps)) max_sweeps_ = max_sweeps

converged = .false.
do sweep = 1, max_sweeps_
   offmax = 0.0_dp
   p = 1
   q = 1
   do j = 2, n
      do i = 1, j - 1
         if (abs(a(i,j)) > offmax) then
            offmax = abs(a(i,j))
            p = i
            q = j
         end if
      end do
   end do

   if (offmax <= tol_) then
      converged = .true.
      exit
   end if

   app = a(p,p)
   aqq = a(q,q)
   apq = a(p,q)

   if (apq /= 0.0_dp) then
      tau = (aqq - app) / (2.0_dp*apq)
      if (tau >= 0.0_dp) then
         t = 1.0_dp / (tau + sqrt(1.0_dp + tau*tau))
      else
         t = -1.0_dp / (-tau + sqrt(1.0_dp + tau*tau))
      end if
      c = 1.0_dp / sqrt(1.0_dp + t*t)
      s = t*c
   else
      c = 1.0_dp
      s = 0.0_dp
   end if

   do i = 1, n
      if (i /= p .and. i /= q) then
         aip = a(i,p)
         aiq = a(i,q)
         a(i,p) = c*aip - s*aiq
         a(p,i) = a(i,p)
         a(i,q) = s*aip + c*aiq
         a(q,i) = a(i,q)
      end if
   end do

   a(p,p) = c*c*app - 2.0_dp*s*c*apq + s*s*aqq
   a(q,q) = s*s*app + 2.0_dp*s*c*apq + c*c*aqq
   a(p,q) = 0.0_dp
   a(q,p) = 0.0_dp

   do i = 1, n
      vip = v(i,p)
      viq = v(i,q)
      v(i,p) = c*vip - s*viq
      v(i,q) = s*vip + c*viq
   end do
end do

if (.not. converged) then
   error stop "jacobi_eigen_sym: no convergence"
end if

do i = 1, n
   evals(i) = a(i,i)
end do
evecs = v
call sort_eigenpairs_desc(evals, evecs)
end subroutine jacobi_eigen_sym

subroutine sort_eigenpairs_desc(evals, evecs)
! sort eigenvalues descending and permute eigenvectors to match
real(kind=dp), intent(in out) :: evals(:)
real(kind=dp), intent(in out) :: evecs(:,:)
real(kind=dp) :: x
real(kind=dp), allocatable :: vtmp(:)
integer :: i, j, k, n

n = size(evals)
allocate(vtmp(size(evecs,1)))
do i = 1, n - 1
   k = i
   do j = i + 1, n
      if (evals(j) > evals(k)) k = j
   end do
   if (k /= i) then
      x = evals(i)
      evals(i) = evals(k)
      evals(k) = x
      vtmp = evecs(:,i)
      evecs(:,i) = evecs(:,k)
      evecs(:,k) = vtmp
   end if
end do
end subroutine sort_eigenpairs_desc

end module pca_jacobi_mod
! ---- end pca_jacobi.f90 ----

! ---- begin util.f90 ----
module util_mod
use iso_fortran_env, only: output_unit
use kind_mod, only: dp, long_int
implicit none
private
public :: default, assert_equal, write_merge, split_string, display, &
   print_time_elapsed, print_wall_time, read_words_line, str, print_table, exe_name, &
   join, seq, cbind, sort_int, set_segment_values, next_combination, n_choose_k, &
   cumul_sum, print_square_matrix, read_matrix
interface default
   module procedure default_int, default_real, default_logical, &
      default_character
end interface default
interface seq
   module procedure seq_stride, seq_unit_stride
end interface seq
interface cbind
   module procedure cbind_vec_vec, cbind_mat_vec, cbind_mat_mat
end interface cbind
interface display
   module procedure display_matrix, display_vector
end interface display
contains

    !> Creates a time series by mapping segments to values defined by changepoints.
    pure function set_segment_values(n, changepoints, values) result(series)
        integer, intent(in) :: n                   ! Length of the time series
        integer, intent(in) :: changepoints(:)     ! Changepoint indices
        real(kind=dp), intent(in) :: values(:)     ! Values per segment
        real(kind=dp) :: series(n)                 ! Resulting time series
        integer :: i, k, j, n_segments

        n_segments = size(values)
        do i = 1, n
            k = n_segments
            do j = 1, n_segments - 1
                if (i <= changepoints(j)) then
                    k = j
                    exit
                end if
            end do
            series(i) = values(k)
        end do
    end function set_segment_values

pure subroutine sort_int(arr)
    ! Sorts an integer array in ascending order using a simple bubble sort
    integer, intent(in out) :: arr(:)
    integer :: n, i, j, temp
    n = size(arr)
    do i = 1, n - 1
        do j = i + 1, n
            if (arr(i) > arr(j)) then
                temp = arr(i)
                arr(i) = arr(j)
                arr(j) = temp
            end if
        end do
    end do
end subroutine sort_int

elemental function default_int(x, xopt) result(y)
integer, intent(in) :: x
integer, intent(in), optional :: xopt
integer             :: y
if (present(xopt)) then
   y = xopt
else
   y = x
end if
end function default_int

elemental function default_real(x, xopt) result(y)
real(kind=dp), intent(in) :: x
real(kind=dp), intent(in), optional :: xopt
real(kind=dp)             :: y
if (present(xopt)) then
   y = xopt
else
   y = x
end if
end function default_real

elemental function default_logical(x, xopt) result(y)
logical, intent(in) :: x
logical, intent(in), optional :: xopt
logical             :: y
if (present(xopt)) then
   y = xopt
else
   y = x
end if
end function default_logical

elemental function default_character(x, xopt) result(y)
character (len=*), intent(in) :: x
character (len=*), intent(in), optional :: xopt
character (len=100) :: y
if (present(xopt)) then
   y = xopt
else
   y = x
end if
end function default_character

subroutine assert_equal(k, kreq, msg)
integer, intent(in) :: k, kreq
character (len=*), intent(in) :: msg
if (k /= kreq) then
   print "(a, i0, a, i0)", msg // " = ", k, ", must equal ", kreq
   stop
end if
end subroutine assert_equal

subroutine write_merge(tf, x, y, outu, fmt)
logical, intent(in) :: tf
character (len=*), intent(in) :: x, y
integer, intent(in), optional :: outu
character (len=*), intent(in), optional :: fmt
integer :: outu_
character (len=100) :: fmt_
outu_ = default(output_unit, outu)
if (present(fmt)) then
   fmt_ = fmt
else
   fmt_ = "(a)"
end if
if (tf) then
   write (outu_, fmt_) x
else
   write (outu_, fmt_) y
end if
end subroutine write_merge

pure subroutine split_string(str, delim, tokens)
character(len=*), intent(in)           :: str
character(len=*), intent(in)           :: delim
character(:), allocatable, intent(out) :: tokens(:)
integer :: start, pos, i, count, n

n = len_trim(str)
if (n == 0) then
   allocate(character(len=0) :: tokens(1))
   tokens(1) = ""
   return
end if

count = 0
start = 1
do
   pos = index(str(start:), delim)
   if (pos == 0) then
      count = count + 1
      exit
   else
      count = count + 1
      start = start + pos
   end if
end do

allocate(character(len=n) :: tokens(count))

start = 1
i = 1
do
   pos = index(str(start:), delim)
   if (pos == 0) then
      tokens(i) = adjustl(str(start:))
      exit
   else
      tokens(i) = adjustl(str(start:start+pos-2))
      start = start + pos
      i = i + 1
   end if
end do
end subroutine split_string

subroutine display_matrix(x, outu, fmt_r, fmt_header, fmt_trailer, &
   title)
real(kind=dp)    , intent(in)           :: x(:,:)
integer          , intent(in), optional :: outu
character (len=*), intent(in), optional :: fmt_r, fmt_header, &
                                           fmt_trailer, title
integer                                 :: i, outu_
character (len=100)                     :: fmt_r_
outu_  = default(output_unit, outu)
fmt_r_ = default("(*(1x,f10.4))", fmt_r)
if (present(fmt_header)) write(outu_, fmt_header)
if (present(title)) write (outu_, "(a)") title
do i=1,size(x,1)
   write(outu_,fmt_r_) x(i,:)
end do
if (present(fmt_trailer)) write(outu_, fmt_trailer)
end subroutine display_matrix

subroutine display_vector(x, outu, fmt_r, fmt_header, title)
real(kind=dp)    , intent(in)           :: x(:)
integer          , intent(in), optional :: outu
character (len=*), intent(in), optional :: fmt_r, fmt_header, title
integer                                 :: i, outu_
character (len=100)                     :: fmt_r_
outu_  = default(output_unit, outu)
fmt_r_ = default("(*(1x,f10.4))", fmt_r)
if (present(fmt_header)) write(outu_, fmt_header)
if (present(title)) write (outu_, "(a)") title
do i=1,size(x)
   write(outu_,fmt_r_) x(i)
end do
end subroutine display_vector

subroutine print_time_elapsed(old_time, outu)
real(kind=dp), intent(in) :: old_time
real(kind=dp)             :: tt
integer      , intent(in), optional :: outu
integer                             :: outu_
character (len=100) :: fmt_time_
outu_ = default(output_unit, outu)
call cpu_time(tt)
fmt_time_= "('cpu time elapsed (s): ', f0.4)"
write (outu_, fmt_time_) tt - old_time
end subroutine print_time_elapsed

subroutine print_wall_time(t_start, outu)
   integer(kind=long_int), intent(in) :: t_start
   integer(kind=long_int) :: t_end, t_rate
   integer      , intent(in), optional :: outu
   integer                             :: outu_
   outu_ = default(output_unit, outu)
   call system_clock(t_end, t_rate)
   write (outu_, "(/,'wall time elapsed (s): ', f10.4)") real(t_end - t_start, kind=dp) / real(t_rate, kind=dp)
end subroutine print_wall_time


subroutine read_words_line(iu,words)
integer          , intent(in)               :: iu
character (len=*), intent(out), allocatable :: words(:)
integer :: ierr, nwords
character (len=10000) :: text
read (iu,"(a)") text
read (text, *) nwords
allocate (words(nwords))
read (text, *, iostat=ierr) nwords, words
if (ierr /= 0) then
   print*,"could not read ", nwords, " words from '" // trim(text) // "'"
   error stop
end if
end subroutine read_words_line

pure function str(i) result(text)
integer, intent(in) :: i
character (len=20) :: text
write (text,"(i0)") i
end function str

subroutine print_table(x, row_names, col_names, outu, &
   fmt_col_names, fmt_row, fmt_header, fmt_trailer)
real(kind=dp)    , intent(in) :: x(:,:) 
character (len=*), intent(in) :: row_names(:), col_names(:)
integer          , intent(in), optional :: outu 
character (len=*), intent(in), optional :: fmt_col_names, fmt_row, &
   fmt_header, fmt_trailer
integer                       :: i, n1, n2, outu_
character (len=*), parameter  :: msg="in print_table, "
character (len=100) :: fmt_col_names_, fmt_row_
n1 = size(x, 1)
n2 = size(x, 2)
call assert_equal(size(row_names), n1, msg // "size(row_names)")
call assert_equal(size(col_names), n2, msg // "size(col_names)")
fmt_col_names_ = default("(*(a12,:,1x))", fmt_col_names)
fmt_row_ = default("(a12, *(1x,f12.6))", fmt_row)
outu_ = default(output_unit, outu)
if (present(fmt_header)) write (outu_, fmt_header)
write (outu_, fmt_col_names_) "", (trim(col_names(i)), i=1,n2)
do i=1,n1
   write (outu_, fmt_row_) trim(row_names(i)), x(i,:)
end do
if (present(fmt_trailer)) write (outu_, fmt_trailer)
end subroutine print_table

function exe_name() result(xname)
character (len=1000) :: xname
call get_command_argument(0,xname)
xname = trim(xname)
end function exe_name

pure function join(words,sep) result(str)
character (len=*), intent(in)                                   :: words(:),sep
character (len=(size(words)-1)*len(sep) + sum(len_trim(words))) :: str
integer                                                         :: i,nw
nw  = size(words)
str = ""
if (nw < 1) then
   return
else
   str = words(1)
end if
do i=2,nw
   str = trim(str) // sep // words(i) 
end do
end function join

pure function seq_stride(first, last, stride) result(vec)
integer, intent(in) :: first, last, stride
integer, allocatable :: vec(:)
integer :: i, n, idiff
idiff = last - first
n = max(0, 1 + idiff/stride)
allocate (vec(n))
do i=1, n
   vec(i) = first + (i - 1) * stride
end do
end function seq_stride

pure function seq_unit_stride(first, last) result(vec)
integer, intent(in) :: first, last
integer, allocatable :: vec(:)
integer :: i, n
n = max(0, last - first + 1)
allocate (vec(n))
do i=1, n
   vec(i) = first + i - 1
end do
end function seq_unit_stride

pure function cbind_vec_vec(x,y) result(xy)
real(kind=dp), intent(in) :: x(:), y(:)
real(kind=dp), allocatable :: xy(:,:)
integer :: n
n = size(x,1)
if (size(y) /= n) error stop "mismatched sizes in cbind"
xy = reshape([x, y], [n, 2])
end function cbind_vec_vec

pure function cbind_mat_vec(x,y) result(xy)
real(kind=dp), intent(in) :: x(:,:), y(:)
real(kind=dp), allocatable :: xy(:,:)
integer :: n1, n2
n1 = size(x,1)
if (size(y) /= n1) error stop "mismatched sizes in cbind"
n2 = size(x,2)
allocate (xy(n1, n2+1))
xy(:,:n2)  = x
xy(:,n2+1) = y 
end function cbind_mat_vec

pure function cbind_mat_mat(x,y) result(xy)
real(kind=dp), intent(in) :: x(:,:), y(:,:)
real(kind=dp), allocatable :: xy(:,:)
integer :: n1, n2
n1 = size(x,1)
if (size(y,1) /= n1) error stop "mismatched sizes in cbind"
n2 = size(x,2)
allocate (xy(n1, n2+size(y,2)))
xy(:,:n2)  = x
xy(:,n2+1:) = y 
end function cbind_mat_mat

pure subroutine next_combination(combo, n)
    !> Advance combo(:) to the next k-combination of {1..n} in lexicographic order.
    !> If combo is already the last combination it is left unchanged.
    integer, intent(in out) :: combo(:)
    integer, intent(in)     :: n
    integer :: k, i, j
    k = size(combo)
    i = k
    do while (i >= 1 .and. combo(i) == n - k + i)
        i = i - 1
    end do
    if (i < 1) return
    combo(i) = combo(i) + 1
    combo(i+1:k) = [(combo(i) + j, j = 1, k - i)]
end subroutine next_combination

pure function n_choose_k(n, k) result(c)
    !> Return the binomial coefficient C(n, k).
    integer, intent(in) :: n, k
    integer :: c, i
    if (k < 0 .or. k > n) then
        c = 0
        return
    end if
    c = 1
    do i = 1, min(k, n - k)
        c = c * (n - i + 1) / i
    end do
end function n_choose_k

function cumul_sum(x) result(xcumul)
real(kind=dp), intent(in) :: x(:)
real(kind=dp)             :: xcumul(size(x))
integer                   :: i, n
n = size(x)
if (n < 1) return
xcumul(1) = x(1)
do i=2,n
   xcumul(i) = xcumul(i-1) + x(i)
end do
end function cumul_sum

subroutine print_square_matrix(x, labels, title, outu)
    !> Print a labeled matrix with an optional title.
    !> Row and column labels are taken from labels(:); x must be square.
    real(kind=dp), intent(in)    :: x(:,:)
    character(len=*), intent(in) :: labels(:)
    character(len=*), intent(in), optional :: title
    integer, intent(in), optional :: outu
    integer :: i, outu_
    outu_ = default(output_unit, outu)
    if (present(title)) write (outu_, "(/,a)") title
    write (outu_, "(12x,*(a11))") (trim(labels(i)), i=1,size(labels))
    do i = 1, size(x, 1)
        write (outu_, "(a12,*(1x,f10.4))") trim(labels(i)), x(i,:)
    end do
end subroutine print_square_matrix

subroutine read_matrix(filename, x, nrow_max, ncol_max)
    !> Read a matrix from a text file.
    !> Format: first line "# nrow ncol ..." (nrow and ncol are the first two integers),
    !> followed by any number of additional comment lines beginning with '#',
    !> followed by nrow rows each containing ncol whitespace-separated reals.
    !> If nrow_max is present, at most nrow_max rows are read.
    !> If ncol_max is present, at most ncol_max columns are read.
    character(len=*), intent(in) :: filename
    real(kind=dp), allocatable, intent(out) :: x(:,:)
    integer, intent(in), optional :: nrow_max, ncol_max
    integer :: unit, ios, i, nrow, ncol, nrow_rd, ncol_rd
    real(kind=dp), allocatable :: row_buf(:)
    character(len=1024) :: line
    open(newunit=unit, file=filename, status='old', action='read', iostat=ios)
    if (ios /= 0) then
        print "(a)", "read_matrix: cannot open '" // trim(filename) // "'"
        error stop
    end if
    read(unit, '(a)') line          ! first line: # nrow ncol ...
    read(line(2:), *, iostat=ios) nrow, ncol
    if (ios /= 0) then
        print "(a)", "read_matrix: cannot parse nrow/ncol from: " // trim(line)
        error stop
    end if
    do                               ! skip remaining comment lines
        read(unit, '(a)', iostat=ios) line
        if (ios /= 0) exit
        if (line(1:1) /= '#') then
            backspace(unit)
            exit
        end if
    end do
    nrow_rd = nrow;  if (present(nrow_max)) nrow_rd = min(nrow_rd, nrow_max)
    ncol_rd = ncol;  if (present(ncol_max)) ncol_rd = min(ncol_rd, ncol_max)
    allocate(x(nrow_rd, ncol_rd))
    if (ncol_rd < ncol) then
        allocate(row_buf(ncol))
        do i = 1, nrow_rd
            read(unit, *, iostat=ios) row_buf
            if (ios /= 0) then
                print "(a,i0)", "read_matrix: error reading row ", i
                error stop
            end if
            x(i, :) = row_buf(1:ncol_rd)
        end do
    else
        do i = 1, nrow_rd
            read(unit, *, iostat=ios) x(i, :)
            if (ios /= 0) then
                print "(a,i0)", "read_matrix: error reading row ", i
                error stop
            end if
        end do
    end if
    close(unit)
end subroutine read_matrix

end module util_mod
! ---- end util.f90 ----

! ---- begin basic_stats.f90 ----
module basic_stats_mod
use iso_fortran_env, only: output_unit
use kind_mod, only: dp
use util_mod, only: default, print_table
use, intrinsic :: ieee_arithmetic, only: ieee_is_nan, ieee_value, ieee_quiet_nan
implicit none
private
public :: mean, variance, sd, mean_and_sd, kurtosis, basic_stats, &
   print_basic_stats, basic_stats_names, correl, acf, nbasic_stats, &
   stat, stats, corr_mat, rms, moving_sum, moving_average, moving_sd, moving_rms, &
   weighted_sd, &
   print_corr_mat, skew, cov, cov_mat, print_cov_mat, print_acf_mat, &
   print_acf, col_stats_ignore_nan, standardize_returns, biased_cov_sd
integer, parameter :: nbasic_stats = 6
character (len=*), parameter :: basic_stats_names(nbasic_stats) = &
   [character(len=4) :: "mean", "sd", "skew", "kurt", "min", "max"]
real(kind=dp), parameter :: bad_value = -huge(1.0d0)
interface stats
   module procedure stats_many_vec, stats_many_mat
end interface stats
interface print_acf
   module procedure print_acf_vec, print_acf_mat
end interface print_acf   
interface print_basic_stats
   module procedure print_basic_stats_vec, print_basic_stats_mat
end interface print_basic_stats
interface acf
   module procedure acf_vec, acf_mat
end interface acf
contains

pure function stats_many_vec(funcs, x) result(y)
! return statistics on x(:)
character (len=*), intent(in) :: funcs(:)
real(kind=dp), intent(in) :: x(:)
real(kind=dp) :: y(size(funcs))
integer :: i
do i=1,size(funcs)
   y(i) = stat(funcs(i), x)
end do
end function stats_many_vec

pure function stats_many_mat(funcs, x) result(y)
! return a matrix of statistics on each column of x(:,:)
character (len=*), intent(in) :: funcs(:)
real(kind=dp), intent(in) :: x(:,:)
real(kind=dp) :: y(size(funcs), size(x,2))
integer :: i
do i=1,size(x,2)
   y(:,i) = stats_many_vec(funcs, x(:,i))
end do
end function stats_many_mat

pure function stat(func, x) result(y)
! return a statistic on x(:)
character (len=*), intent(in) :: func
real(kind=dp), intent(in) :: x(:)
real(kind=dp)             :: y
select case(func)
   case ("mean")    ; y = mean(x)
   case ("sd")      ; y = sd(x)
   case ("variance"); y = variance(x)
   case ("skew")    ; y = skew(x)
   case ("kurt")    ; y = kurtosis(x)
   case ("min")     ; y = minval(x)
   case ("max")     ; y = maxval(x)
   case ("first")
      if (size(x) > 0) then
         y = x(1)
      else
         y = bad_value
      end if 
   case ("last")
      if (size(x) > 0) then
         y = x(size(x))
      else
         y = bad_value
      end if 
   case default ; y = -huge(x)
end select
end function stat

pure function mean(x) result(xmean)
! return the mean of x(:)
real(kind=dp), intent(in) :: x(:)
real(kind=dp) :: xmean
xmean = sum(x)/max(1,size(x))
end function mean

pure function sd(x) result(xsd)
! return the standard deviation of x(:)
real(kind=dp), intent(in) :: x(:)
real(kind=dp) :: xsd
real(kind=dp) :: m, var
integer :: n
n = size(x)
m = sum(x) / n
var = sum((x - m)**2) / (n-1)
xsd = sqrt(max(0.0_dp, var))
end function sd

pure function rms(x) result(xrms)
! return the root-mean-square of x(:)
real(kind=dp), intent(in) :: x(:)
real(kind=dp) :: xrms
xrms = sqrt(sum(x**2)/size(x))
end function rms

pure function mean_and_sd(x) result(res)
! return the mean and standard deviation of x(:)
real(kind=dp), intent(in) :: x(:)
real(kind=dp)             :: res(2)
real(kind=dp)             :: var
integer :: n
n = size(x)
res(1) = sum(x) / n
var = sum((x - res(1))**2) / (n-1)
res(2) = sqrt(max(0.0_dp, var))
end function mean_and_sd

pure function variance(x) result(var)
! return the variance of x(:)
real(kind=dp), intent(in) :: x(:)
real(kind=dp) :: var, m
integer :: n
n = size(x)
m = sum(x) / n
var = sum((x - m)**2) / (n-1)
end function variance

pure function skew(x) result(skew_val)
! return the skewness of x
real(kind=dp), intent(in) :: x(:)
real(kind=dp) :: skew_val
real(kind=dp) :: mean_x, sd_x
integer :: n
n = size(x)
mean_x = mean(x)
sd_x = sd(x)
skew_val = sum(((x - mean_x) / sd_x)**3) / n
end function skew

pure function kurtosis(x) result(kurtosis_val)
! return the kurtosis of x
real(kind=dp), intent(in) :: x(:)
real(kind=dp) :: kurtosis_val
real(kind=dp) :: mean_x, sd_x
integer :: n
n = size(x)
mean_x = mean(x)
sd_x = sd(x)
kurtosis_val = sum(((x - mean_x) / sd_x)**4) / n - 3.0_dp
end function kurtosis

pure function basic_stats(x) result(stats)
real(kind=dp), intent(in) :: x(:)
real(kind=dp)             :: stats(nbasic_stats)
stats = [mean(x), sd(x), skew(x), kurtosis(x), minval(x), maxval(x)]
end function basic_stats

subroutine print_basic_stats_vec(x, outu, fmt_header, fmt_trailer, &
   title, fmt_r, fmt_stats_names)
! print stats on a 1-D array
real(kind=dp), intent(in) :: x(:)
integer, intent(in), optional :: outu
character (len=*), intent(in), optional :: fmt_header, fmt_trailer, &
   title, fmt_r, fmt_stats_names
character (len=100) :: fmt_r_, fmt_stats_names_
integer :: i, outu_
if (present(fmt_stats_names)) then
   fmt_stats_names_ = fmt_stats_names
else
   fmt_stats_names_ = "(*(a10))"
end if
if (present(fmt_r)) then
   fmt_r_ = fmt_r
else
   fmt_r_ = "(*(f10.4))"
end if
outu_ = default(output_unit, outu)
if (present(fmt_header)) write (outu_, fmt_header)
if (present(title)) write (outu_, "(a)") title
write (outu_, fmt_stats_names_) (trim(basic_stats_names(i)), i=1,nbasic_stats)
write (outu_, fmt_r_) basic_stats(x)
if (present(fmt_trailer)) write (outu_, fmt_trailer)
end subroutine print_basic_stats_vec

subroutine print_basic_stats_mat(x, labels, outu, &
   fmt_header, fmt_trailer, title, fmt_cr, fmt_stats_names)
! print stats on a 2-D array
real(kind=dp), intent(in) :: x(:,:)
character (len=*), intent(in) :: labels(:)
integer, intent(in), optional :: outu
character (len=*), intent(in), optional :: fmt_header, fmt_trailer, &
   title, fmt_cr, fmt_stats_names
character (len=100) :: fmt_cr_, fmt_stats_names_
integer :: i, outu_
if (present(fmt_stats_names)) then
   fmt_stats_names_ = fmt_stats_names
else
   fmt_stats_names_ = "(*(a10))"
end if
if (present(fmt_cr)) then
   fmt_cr_ = fmt_cr
else
   fmt_cr_ = "(*(f10.4))"
end if
outu_ = default(output_unit, outu)
if (present(fmt_header)) write (outu_, fmt_header)
if (present(title)) write (outu_, "(a)") title
write (outu_, fmt_stats_names_) "", (trim(basic_stats_names(i)), i=1,nbasic_stats)
do i=1,size(x, 2)
   write (outu_, fmt_cr_) trim(labels(i)), basic_stats(x(:,i))
end do
if (present(fmt_trailer)) write (outu_, fmt_trailer)
end subroutine print_basic_stats_mat

pure function correl(x, y) result(corr_xy)
! Returns the linear Pearson correlation of x(:) and y(:)
! Returns a correlation < -1.0_dp to signal an error
real(kind=dp), intent(in) :: x(:), y(:)
real(kind=dp) :: corr_xy
real(kind=dp) :: x_mean, y_mean, cov_xy, var_x, var_y
integer :: n
n = size(x)
if (n /= size(y) .or. n == 0) then
   corr_xy = -2.0_dp
   return
end if
x_mean = sum(x) / n
y_mean = sum(y) / n
cov_xy = sum((x - x_mean) * (y - y_mean))
var_x  = sum((x - x_mean)**2)
var_y  = sum((y - y_mean)**2)
if (var_x <= 0.0_dp .or. var_y <= 0.0_dp) then
   corr_xy = -3.0_dp
else
   corr_xy = cov_xy / sqrt(var_x * var_y)
end if
end function correl

pure function cov(x, y) result(cov_xy)
! Returns the covariance of two 1D arrays
real(kind=dp), intent(in) :: x(:), y(:)
real(kind=dp) :: cov_xy
real(kind=dp) :: x_mean, y_mean
integer :: n
n = size(x)
if (n /= size(y) .or. n == 0) then
   error stop "x and y must have same size > 0 in cov"
end if
x_mean = sum(x) / n
y_mean = sum(y) / n
cov_xy = sum((x - x_mean) * (y - y_mean))
end function cov

pure function acf_vec(x, nacf) result(xacf)
! return the autocorrelations at lags 1 through nacf
real(kind=dp), intent(in) :: x(:)         ! Input array
integer, intent(in) :: nacf               ! Number of autocorrelations to compute
real(kind=dp) :: xacf(nacf)               ! Output array for autocorrelations
real(kind=dp) :: denom
real(kind=dp), allocatable :: xdm(:)      ! Demeaned version of x
integer :: n, lag
n = size(x)
xdm = x - mean(x)                          ! Compute demeaned x
denom = sum(xdm**2)
! Compute autocorrelation for each lag from 1 to nacf
do lag = 1, nacf
   xacf(lag) = sum(xdm(1:n-lag) * xdm(lag+1:n)) / denom
end do
end function acf_vec

pure function acf_mat(x, nacf) result(xacf)
! return the autocorrelations at lags 1 through nacf
real(kind=dp), intent(in) :: x(:,:)       ! Input array
integer, intent(in) :: nacf               ! Number of autocorrelations to compute
real(kind=dp) :: xacf(nacf,size(x,2))     ! Output array for autocorrelations
integer :: icol
do icol=1,size(x,2)
   xacf(:,icol) = acf(x(:,icol), nacf)
end do
end function acf_mat

subroutine print_acf_vec(x, nacf, label, outu, fmt_header, &
   fmt_trailer, title, fmt_acf, fmt_label)
! print the autocorrelations at lags 1 through nacf of x(:)
real(kind=dp), intent(in) :: x(:)       ! Input array
integer, intent(in) :: nacf             ! Number of autocorrelations to compute
character (len=*), intent(in), optional :: title, label, &
   fmt_header, fmt_trailer, fmt_acf, fmt_label
character (len=100) :: fmt_acf_, fmt_label_
integer, intent(in), optional :: outu
real(kind=dp) :: xacf(nacf)     
integer :: iacf, outu_
outu_ = default(output_unit, outu)
fmt_label_ = default("(6x,a8)", fmt_label)
if (present(fmt_header)) write (outu_, fmt_header)
if (present(title)) write (outu_, "(a)") title
if (present(label)) write (outu_,fmt_label_) label
fmt_acf_ = default("('ACF_', i2.2, f8.4)", fmt_acf)
xacf = acf_vec(x, nacf)
do iacf=1,nacf
   write (outu_, fmt_acf_) iacf, xacf(iacf)
end do
if (present(fmt_trailer)) write (outu_, fmt_trailer)
end subroutine print_acf_vec

subroutine print_acf_mat(x, nacf, labels, outu, fmt_header, &
   fmt_trailer, title, fmt_acf, fmt_labels)
! print the autocorrelations at lags 1 t hrough nacf of the columns of x(:,:)
real(kind=dp), intent(in) :: x(:,:)       ! Input array
integer, intent(in) :: nacf               ! Number of autocorrelations to compute
character (len=*), intent(in), optional :: title, labels(:), &
   fmt_header, fmt_trailer, fmt_acf, fmt_labels
integer, intent(in), optional :: outu
real(kind=dp) :: xacf(nacf,size(x,2))
integer :: iacf, icol, outu_
character (len=100) :: fmt_acf_, fmt_labels_
outu_ = default(output_unit, outu)
fmt_labels_ = default("(6x,*(a8))", fmt_labels)
if (present(fmt_header)) then
   write (outu_, fmt_header)
end if
if (present(title)) write (outu_, "(a)") title
if (present(labels)) write (outu_, fmt_labels_) &
   (trim(labels(icol)), icol=1,size(labels))
xacf = acf_mat(x, nacf)
fmt_acf_ = default("('ACF_', i2.2, *(f8.4))", fmt_acf)
do iacf=1,nacf
   write (outu_, fmt_acf_) iacf, xacf(iacf,:)
end do
if (present(fmt_trailer)) write (outu_, fmt_trailer)
end subroutine print_acf_mat

subroutine print_corr_mat(x, col_names, outu, fmt_col_names, fmt_row, &
   fmt_header, fmt_trailer)
! print the correlation matrix of the columns of x(:,:)
real(kind=dp), intent(in) :: x(:,:)
character (len=*), intent(in) :: col_names(:)
integer          , intent(in), optional :: outu ! output unit
character (len=*), intent(in), optional :: fmt_header, fmt_trailer, &
   fmt_col_names, fmt_row
character (len=100) :: fmt_col_names_, fmt_row_
fmt_col_names_ = default("(*(a8,:,1x))", fmt_col_names)
fmt_row_ = default("(a8, *(1x,f8.4))", fmt_row)
call print_table(corr_mat(x), row_names=col_names, col_names=col_names, &
   fmt_header=fmt_header, fmt_trailer=fmt_trailer, outu=outu, &
   fmt_col_names=fmt_col_names_, fmt_row=fmt_row_)
end subroutine print_corr_mat

subroutine print_cov_mat(x, col_names, outu, fmt_col_names, fmt_row, &
   fmt_header, fmt_trailer)
! print the covariance matrix of the columns of x(:,:)
real(kind=dp), intent(in) :: x(:,:)
character (len=*), intent(in) :: col_names(:)
integer          , intent(in), optional :: outu ! output unit
character (len=*), intent(in), optional :: fmt_header, fmt_trailer, &
   fmt_col_names, fmt_row
character (len=100) :: fmt_col_names_, fmt_row_
fmt_col_names_ = default("(*(a8,:,1x))", fmt_col_names)
fmt_row_ = default("(a8, *(1x,f8.4))", fmt_row)
call print_table(cov_mat(x), row_names=col_names, col_names=col_names, &
   fmt_header=fmt_header, fmt_trailer=fmt_trailer, outu=outu, &
   fmt_col_names=fmt_col_names_, fmt_row=fmt_row_)
end subroutine print_cov_mat

pure function corr_mat(x) result(cor)
    ! return the correlation matrix of the columns of x(:,:)
    real(kind=dp), intent(in) :: x(:,:)
    real(kind=dp)             :: cor(size(x,2), size(x,2))
    real(kind=dp)             :: mean_vec(size(x,2)), std_vec(size(x,2))
    real(kind=dp)             :: centered_x(size(x,1), size(x,2))
    integer                   :: n, p

    n = size(x, 1)  ! Number of rows
    p = size(x, 2)  ! Number of columns

    ! Compute the mean of each column
    mean_vec = sum(x, dim=1) / n

    ! Center the matrix by subtracting the mean of each column
    centered_x = x - spread(mean_vec, dim=1, ncopies=n)

    ! Compute the standard deviation of each column
    std_vec = sqrt(sum(centered_x**2, dim=1) / (n - 1))

    cor = matmul(transpose(centered_x), centered_x) / (n - 1)
    cor = cor / spread(std_vec, dim=1, ncopies=p)
    cor = cor / spread(std_vec, dim=2, ncopies=p)
end function corr_mat

pure function cov_mat(x) result(xcov)
    ! return the covariance matrix of the columns of x(:,:)
    real(kind=dp), intent(in) :: x(:,:)
    real(kind=dp)             :: xcov(size(x,2), size(x,2))
    real(kind=dp)             :: mean_vec(size(x,2)), std_vec(size(x,2))
    real(kind=dp)             :: centered_x(size(x,1), size(x,2))
    integer                   :: n, p

    n = size(x, 1)  ! Number of rows
    p = size(x, 2)  ! Number of columns

    ! Compute the mean of each column
    mean_vec = sum(x, dim=1) / n

    ! Center the matrix by subtracting the mean of each column
    centered_x = x - spread(mean_vec, dim=1, ncopies=n)

    ! Compute the standard deviation of each column
    std_vec = sqrt(sum(centered_x**2, dim=1) / (n - 1))
    xcov = matmul(transpose(centered_x), centered_x) / (n - 1)
end function cov_mat

pure function moving_sum(x, k) result(xsum)
! return a moving sum of x(:) with k terms, using fewer terms for i < k
real(kind=dp), intent(in) :: x(:)
integer      , intent(in) :: k
real(kind=dp)             :: xsum(size(x))
integer                   :: i, n
n = size(x)
if (n < 1) return
if (k < 1) then
   xsum = 0.0_dp
   return
end if
xsum(1) = x(1)
do i=2,min(k, n)
   xsum(i) = xsum(i-1) + x(i)
end do
do i=k+1, n
   xsum(i) = xsum(i-1) + x(i) - x(i-k)
end do
end function moving_sum

pure function moving_average(x, k) result(xma)
! return a moving average of x(:) with k terms, using fewer terms for i < k
real(kind=dp), intent(in) :: x(:)
integer      , intent(in) :: k
real(kind=dp)             :: xma(size(x))
integer                   :: i, n
real(kind=dp)             :: xsum(size(x))
n = size(x)
if (k < 1) then
   xma = 0.0_dp
   return
end if
xsum = moving_sum(x, k)
do i=1,min(k, n)
   xma(i) = xsum(i)/i
end do
do i=k+1,n
   xma(i) = xsum(i)/k
end do
end function moving_average

pure subroutine col_stats_ignore_nan(x, n, mean_x, sd_x, min_x, max_x) ! compute basic stats ignoring nan values
real(kind=dp), intent(in) :: x(:)
integer, intent(out) :: n
real(kind=dp), intent(out) :: mean_x, sd_x, min_x, max_x
real(kind=dp) :: s1, s2, xi, nan
integer :: i

nan = ieee_value(0.0_dp, ieee_quiet_nan)
n = 0
s1 = 0.0_dp
s2 = 0.0_dp
min_x = nan
max_x = nan

do i = 1, size(x)
   xi = x(i)
   if (ieee_is_nan(xi)) cycle
   n = n + 1
   s1 = s1 + xi
   s2 = s2 + xi*xi
   if (n == 1) then
      min_x = xi
      max_x = xi
   else
      if (xi < min_x) min_x = xi
      if (xi > max_x) max_x = xi
   end if
end do

if (n == 0) then
   mean_x = nan
   sd_x = nan
   min_x = nan
   max_x = nan
else if (n == 1) then
   mean_x = s1
   sd_x = nan
else
   mean_x = s1/n
   sd_x = sqrt(max(0.0_dp, (s2 - n*mean_x*mean_x)/(n - 1)))
end if
end subroutine col_stats_ignore_nan

pure function moving_sd(x, k) result(xsd)
! return a moving standard deviation of x(:) with k terms
real(kind=dp), intent(in) :: x(:)
integer      , intent(in) :: k
real(kind=dp)             :: xsd(size(x))
integer                   :: i, n
real(kind=dp)             :: xsum(size(x)), xsum2(size(x))
real(kind=dp)             :: m, v
n = size(x)
xsd = ieee_value(0.0_dp, ieee_quiet_nan)
if (k < 2 .or. n < k) return
xsum = moving_sum(x, k)
xsum2 = moving_sum(x**2, k)
do i=k, n
   m = xsum(i)/k
   v = (xsum2(i) - k*m**2)/(k-1)
   xsd(i) = sqrt(max(0.0_dp, v))
end do
end function moving_sd

pure function moving_rms(x, k) result(xrms)
! return a moving root-mean-square of x(:) with window k, assuming zero mean
real(kind=dp), intent(in) :: x(:)  ! input time series
integer      , intent(in) :: k     ! window length
real(kind=dp)             :: xrms(size(x))
integer                   :: i, n
real(kind=dp)             :: xsum2(size(x))
n = size(x)
xrms = ieee_value(0.0_dp, ieee_quiet_nan)
if (k < 1 .or. n < k) return
xsum2 = moving_sum(x**2, k)
do i = k, n
   xrms(i) = sqrt(xsum2(i)/k)
end do
end function moving_rms

pure function weighted_sd(x, w) result(xsd)
! return the weighted standard deviation of x(:) with weights w(:)
real(kind=dp), intent(in) :: x(:), w(:)
real(kind=dp)             :: xsd
real(kind=dp)             :: w_sum, xw_mean, var
integer                   :: n
n = size(x)
if (n < 2 .or. size(w) /= n) then
   xsd = ieee_value(0.0_dp, ieee_quiet_nan)
   return
end if
w_sum = sum(w)
if (w_sum <= 0.0_dp) then
   xsd = ieee_value(0.0_dp, ieee_quiet_nan)
   return
end if
xw_mean = sum(w * x) / w_sum
var = sum(w * (x - xw_mean)**2) / w_sum
xsd = sqrt(max(0.0_dp, var))
end function weighted_sd

function standardize_returns(R, use_ewma, ewma_lambda) result(R_std)
    !> Standardise a returns matrix R(n, p) column-by-column.
    !> use_ewma=.true.:  EWMA (RiskMetrics) normalisation with decay ewma_lambda.
    !> use_ewma=.false.: global normalisation (subtract mean, divide by full-sample sd).
    real(kind=dp), intent(in) :: R(:,:)
    logical, intent(in)       :: use_ewma
    real(kind=dp), intent(in) :: ewma_lambda
    real(kind=dp), allocatable :: R_std(:,:)
    real(kind=dp), allocatable :: glob_mean(:), glob_sd(:)
    real(kind=dp) :: var_t, sig_t
    integer :: n, p, a, i

    n = size(R, 1)
    p = size(R, 2)
    allocate(R_std(n, p), glob_mean(p), glob_sd(p))

    do a = 1, p
        glob_mean(a) = sum(R(:, a)) / n
        glob_sd(a)   = sqrt(sum((R(:, a) - glob_mean(a))**2) / n)
    end do

    if (use_ewma) then
        print "('normalisation: EWMA (lambda=',f0.2,')')", ewma_lambda
        do a = 1, p
            var_t = max(glob_sd(a)**2, tiny(1.0_dp))
            do i = 1, n
                sig_t      = sqrt(var_t)
                R_std(i,a) = (R(i,a) - glob_mean(a)) / sig_t
                var_t      = ewma_lambda * var_t + &
                             (1.0_dp - ewma_lambda) * (R(i,a) - glob_mean(a))**2
                var_t      = max(var_t, tiny(1.0_dp))
            end do
        end do
    else
        print "('normalisation: global (constant sigma)')"
        do a = 1, p
            if (glob_sd(a) > 0.0_dp) then
                R_std(:, a) = (R(:, a) - glob_mean(a)) / glob_sd(a)
            else
                R_std(:, a) = 0.0_dp
            end if
        end do
    end if
end function standardize_returns

pure subroutine biased_cov_sd(R, S, sd_vec)
    !> Compute the biased sample covariance matrix S and standard deviations sd_vec
    !! of the columns of R.  Divides by n (not n-1).
    real(kind=dp), intent(in)  :: R(:,:)
    real(kind=dp), intent(out) :: S(:,:), sd_vec(:)
    real(kind=dp) :: mu(size(R,2))
    integer :: a, b, m, p
    m = size(R, 1)
    p = size(R, 2)
    do a = 1, p
        mu(a) = sum(R(:, a)) / m
    end do
    do a = 1, p
        do b = a, p
            S(a,b) = sum((R(:,a) - mu(a)) * (R(:,b) - mu(b))) / m
            S(b,a) = S(a,b)
        end do
    end do
    do a = 1, p
        sd_vec(a) = sqrt(max(S(a,a), 0.0_dp))
    end do
end subroutine biased_cov_sd

end module basic_stats_mod
! ---- end basic_stats.f90 ----

! ---- begin changepoint.f90 ----
module changepoint_mod
    use kind_mod, only: dp
    use util_mod, only: sort_int
    implicit none
    private
    public :: log_likelihood_corr, cost_matrix, cost_matrix_slow, mean_shift_cost_matrix, &
              multivar_cost_matrix, solve_changepoints, segment_ends
    public :: solve_continuous_pwl_sse, fit_continuous_pwl_given_cps

    type :: quad_state
        integer :: nquad = 0
        real(kind=dp), allocatable :: a(:), b(:), c(:)
        integer, allocatable :: parent_t(:), parent_q(:)
    end type quad_state

contains

    !> Computes the negative log-likelihood of bivariate normal data segment.
    pure function log_likelihood_corr(x, y, min_len) result(ll)
        real(kind=dp), intent(in) :: x(:), y(:)
        integer, intent(in), optional :: min_len
        real(kind=dp) :: ll, r, ma, mb, va, vb
        integer :: n, min_len_

        min_len_ = 50
        if (present(min_len)) min_len_ = min_len

        n = size(x)
        if (n < min_len_) then
            ll = -1.0e20_dp
            return
        end if
        ma = sum(x)/n
        mb = sum(y)/n
        va = sum((x-ma)**2) / n
        vb = sum((y-mb)**2) / n
        r = sum((x-ma)*(y-mb)) / (sqrt(max(1e-20_dp, va * vb)) * n)

        ll = -0.5_dp * n * log(max(1.0e-10_dp, 1.0_dp - min(r**2, 1.0_dp - 1.0e-10_dp)))
    end function log_likelihood_corr

    !> Constructs a cost matrix for all possible segments using negative log-likelihood (O(N^2)).
    function cost_matrix(x, y, min_seg_len) result(cost)
        real(kind=dp), intent(in) :: x(:), y(:)
        integer, intent(in), optional :: min_seg_len
        real(kind=dp) :: cost(size(x), size(x))
        real(kind=dp) :: sx(size(x)), sy(size(x)), sxx(size(x)), syy(size(x)), sxy(size(x))
        integer :: n, i, j, min_len

        min_len = 50
        if (present(min_seg_len)) min_len = min_seg_len

        n = size(x)

        sx(1) = x(1); sy(1) = y(1); sxx(1) = x(1)**2; syy(1) = y(1)**2; sxy(1) = x(1)*y(1)
        do i = 2, n
            sx(i) = sx(i-1) + x(i)
            sy(i) = sy(i-1) + y(i)
            sxx(i) = sxx(i-1) + x(i)**2
            syy(i) = syy(i-1) + y(i)**2
            sxy(i) = sxy(i-1) + x(i)*y(i)
        end do

        do i = 1, n
            do j = i, n
                if (j - i + 1 < min_len) then
                    cost(i, j) = 1.0e20_dp
                else
                    call fast_ll(i, j, sx, sy, sxx, syy, sxy, cost(i, j))
                end if
            end do
        end do
        do i = 2, n
            do j = 1, i - 1
                cost(i, j) = 1.0e20_dp
            end do
        end do
    end function cost_matrix

    subroutine fast_ll(i, j, sx, sy, sxx, syy, sxy, cost_val)
        integer, intent(in) :: i, j
        real(kind=dp), intent(in) :: sx(:), sy(:), sxx(:), syy(:), sxy(:)
        real(kind=dp), intent(out) :: cost_val
        real(kind=dp) :: n, r, ma, mb, va, vb, sx_s, sy_s, sxx_s, syy_s, sxy_s

        n = real(j - i + 1, dp)
        if (i == 1) then
            sx_s = sx(j); sy_s = sy(j); sxx_s = sxx(j); syy_s = syy(j); sxy_s = sxy(j)
        else
            sx_s = sx(j) - sx(i-1)
            sy_s = sy(j) - sy(i-1)
            sxx_s = sxx(j) - sxx(i-1)
            syy_s = syy(j) - syy(i-1)
            sxy_s = sxy(j) - sxy(i-1)
        end if
        ma = sx_s / n
        mb = sy_s / n
        va = (sxx_s - n * ma**2) / n
        vb = (syy_s - n * mb**2) / n
        r = (sxy_s - n * ma * mb) / (sqrt(max(1e-20_dp, va * vb)) * n)

        cost_val = 0.5_dp * n * log(max(1.0e-10_dp, 1.0_dp - min(r**2, 1.0_dp - 1.0e-10_dp)))
    end subroutine fast_ll

    !> Cost matrix for a 1-D series z using the profile normal mean-shift log-likelihood.
    !! cost(i,j) = (j-i+1)/2 * log(max(sample_variance(z(i:j)), eps))
    !! Use z = x*y for covariance changepoints; z = x*x for variance changepoints.
    function mean_shift_cost_matrix(z, min_seg_len) result(cost)
        real(kind=dp), intent(in) :: z(:)
        integer, intent(in), optional :: min_seg_len
        real(kind=dp) :: cost(size(z), size(z))
        real(kind=dp) :: sz(size(z)), szz(size(z))
        real(kind=dp) :: m, sz_s, szz_s, s2
        integer :: n, i, j, min_len

        min_len = 50
        if (present(min_seg_len)) min_len = min_seg_len

        n = size(z)

        sz(1) = z(1);  szz(1) = z(1)**2
        do i = 2, n
            sz(i)  = sz(i-1)  + z(i)
            szz(i) = szz(i-1) + z(i)**2
        end do

        do i = 1, n
            do j = i, n
                if (j - i + 1 < min_len) then
                    cost(i, j) = 1.0e20_dp
                else
                    m     = real(j - i + 1, dp)
                    sz_s  = sz(j)  - merge(sz(i-1),  0.0_dp, i > 1)
                    szz_s = szz(j) - merge(szz(i-1), 0.0_dp, i > 1)
                    s2    = szz_s / m - (sz_s / m)**2
                    cost(i, j) = 0.5_dp * m * log(max(s2, 1.0e-20_dp))
                end if
            end do
            do j = 1, i - 1
                cost(i, j) = 1.0e20_dp
            end do
        end do
    end function mean_shift_cost_matrix

    !> Log-determinant of a symmetric positive-definite matrix via Cholesky.
    !! Returns -1e30 if the matrix is not positive definite.
    pure function log_det_chol(A) result(ld)
        real(kind=dp), intent(in) :: A(:,:)
        real(kind=dp) :: ld
        integer :: p, i, j
        real(kind=dp) :: s, L(size(A,1), size(A,1))
        p = size(A, 1)
        L = 0.0_dp
        do j = 1, p
            s = A(j,j) - sum(L(j, 1:j-1)**2)
            if (s <= 0.0_dp) then
                ld = -1.0e30_dp
                return
            end if
            L(j,j) = sqrt(s)
            do i = j+1, p
                L(i,j) = (A(i,j) - sum(L(i,1:j-1)*L(j,1:j-1))) / L(j,j)
            end do
        end do
        ld = 2.0_dp * sum([(log(L(i,i)), i=1,p)])
    end function log_det_chol

    !> Joint covariance-matrix changepoint cost matrix.
    !! cost(i,j) = m/2 * log|Sigma_hat(i:j)|  where Sigma_hat is the biased sample
    !! covariance matrix of the p-column return matrix R over rows i..j.
    !! Uses O(n*p^2) prefix sums; each cell costs O(p^2) to assemble + O(p^3) Cholesky.
    function multivar_cost_matrix(R, min_seg_len) result(cost)
        real(kind=dp), intent(in) :: R(:,:)      ! n × p
        integer, intent(in), optional :: min_seg_len
        real(kind=dp) :: cost(size(R,1), size(R,1))
        real(kind=dp), allocatable :: SR(:,:), SP(:,:,:)
        real(kind=dp) :: S(size(R,2), size(R,2)), sr_s(size(R,2)), m_r, ld
        integer :: n, p, i, j, a, b, min_len

        n = size(R, 1);  p = size(R, 2)
        min_len = 50
        if (present(min_seg_len)) min_len = min_seg_len

        allocate(SR(0:n, p), SP(0:n, p, p))
        cost = 1.0e20_dp

        SR(0,:) = 0.0_dp;  SP(0,:,:) = 0.0_dp
        do i = 1, n
            SR(i,:) = SR(i-1,:) + R(i,:)
            do a = 1, p
                SP(i,a,:) = SP(i-1,a,:) + R(i,a) * R(i,:)
            end do
        end do

        do j = min_len, n
            do i = 1, j - min_len + 1
                m_r  = real(j - i + 1, dp)
                sr_s = SR(j,:) - SR(i-1,:)
                do a = 1, p
                    do b = a, p
                        S(a,b) = (SP(j,a,b) - SP(i-1,a,b)) / m_r &
                               - (sr_s(a)/m_r) * (sr_s(b)/m_r)
                        S(b,a) = S(a,b)
                    end do
                end do
                ld = log_det_chol(S)
                if (ld > -1.0e19_dp) cost(i,j) = 0.5_dp * m_r * ld
            end do
        end do
    end function multivar_cost_matrix

    !> Constructs a cost matrix for all possible segments using negative log-likelihood (slow O(N^3) version).
    pure function cost_matrix_slow(x, y) result(cost)
        real(kind=dp), intent(in) :: x(:), y(:)
        real(kind=dp) :: cost(size(x), size(x))
        integer :: n, i, j
        n = size(x)
        do i = 1, n
            do j = i, n
                cost(i, j) = -log_likelihood_corr(x(i:j), y(i:j))
            end do
        end do
    end function cost_matrix_slow

    subroutine solve_changepoints(max_m, cost, dp_table, parent)
        !> Solves the changepoint problem using dynamic programming to minimize total cost.
        integer, intent(in) :: max_m
        real(kind=dp), intent(in) :: cost(:, :)
        real(kind=dp), intent(out) :: dp_table(size(cost, 1), max_m)
        integer, intent(out) :: parent(size(cost, 1), max_m)
        integer :: i, m, k, n

        n = size(cost, 1)

        dp_table = 1.0e20_dp
        parent = 0
        do i = 1, n
            dp_table(i, 1) = cost(1, i)
        end do

        do m = 2, max_m
            do i = m, n
                do k = m-1, i-1
                    if (dp_table(k, m-1) + cost(k+1, i) < dp_table(i, m)) then
                        dp_table(i, m) = dp_table(k, m-1) + cost(k+1, i)
                        parent(i, m) = k
                    end if
                end do
            end do
        end do
    end subroutine solve_changepoints

    !> Solve the exact continuous piecewise linear least-squares problem for y.
    !!
    !! The fitted curve is continuous and piecewise linear, with observations 1:n.
    !! For m segments there are m-1 internal changepoints. Segment 1 fits y(1:t1).
    !! Later segments fit y(t_prev+1:t_curr), so each observation is used exactly once.
    !!
    !! The dynamic programming state for each (m,t) is represented as a lower envelope
    !! of quadratics in the endpoint value at time t. This gives an exact optimizer for
    !! the least-squares continuous PWL objective, not the greedy knot-insertion heuristic.
    subroutine solve_continuous_pwl_sse(y, max_m, min_seg_len, sse, cp_store, n_models_fitted)
        real(kind=dp), intent(in) :: y(:)
        integer, intent(in) :: max_m
        integer, intent(in), optional :: min_seg_len
        real(kind=dp), intent(out) :: sse(max_m)
        integer, intent(out) :: cp_store(max(1, max_m - 1), max_m)
        integer, intent(out) :: n_models_fitted

        type(quad_state), allocatable :: states(:, :)
        real(kind=dp), allocatable :: sy(:), siy(:), syy(:)
        real(kind=dp), allocatable :: raw_a(:), raw_b(:), raw_c(:)
        integer, allocatable :: raw_pt(:), raw_pq(:), keep(:)
        integer :: n, min_len, max_m_eff, m, t, s, j, nraw, nkeep, best_q
        real(kind=dp) :: a0, b0, c0, qa, qb, qc, qd, qe, qf
        real(kind=dp) :: best_cost, denom, lin

        min_len = 50
        if (present(min_seg_len)) min_len = min_seg_len

        n = size(y)
        if (max_m < 1) error stop 'solve_continuous_pwl_sse: max_m must be positive'
        if (n < min_len) error stop 'solve_continuous_pwl_sse: size(y) < min_seg_len'

        max_m_eff = min(max_m, n / min_len)
        sse = huge(1.0_dp)
        cp_store = 0
        n_models_fitted = 0

        call build_prefix_sums(y, sy, siy, syy)
        allocate(states(max_m_eff, n))

        do t = min_len, n
            call first_segment_quadratic(t, sy, siy, syy, qa, qb, qc)
            call set_state_single(states(1, t), qa, qb, qc)
        end do

        do m = 2, max_m_eff
            do t = m * min_len, n
                nraw = 0
                do s = (m - 1) * min_len, t - min_len
                    nraw = nraw + states(m - 1, s)%nquad
                end do
                if (nraw == 0) cycle

                allocate(raw_a(nraw), raw_b(nraw), raw_c(nraw), raw_pt(nraw), raw_pq(nraw))
                nraw = 0
                do s = (m - 1) * min_len, t - min_len
                    if (states(m - 1, s)%nquad == 0) cycle
                    call later_segment_coefficients(s, t, sy, siy, syy, qa, qb, qc, qd, qe, qf)
                    do j = 1, states(m - 1, s)%nquad
                        a0 = states(m - 1, s)%a(j)
                        b0 = states(m - 1, s)%b(j)
                        c0 = states(m - 1, s)%c(j)
                        denom = a0 + qa
                        lin = b0 + qd
                        nraw = nraw + 1
                        raw_a(nraw) = qc - (qb * qb) / denom
                        raw_b(nraw) = qe - qb * lin / denom
                        raw_c(nraw) = c0 + qf - 0.25_dp * lin * lin / denom
                        raw_pt(nraw) = s
                        raw_pq(nraw) = j
                    end do
                end do

                call keep_lower_envelope(raw_a, raw_b, raw_c, keep, nkeep)
                call set_state_subset(states(m, t), raw_a, raw_b, raw_c, raw_pt, raw_pq, keep, nkeep)
                deallocate(raw_a, raw_b, raw_c, raw_pt, raw_pq, keep)
            end do
        end do

        do m = 1, max_m_eff
            if (states(m, n)%nquad == 0) cycle
            call best_terminal_quadratic(states(m, n)%a, states(m, n)%b, states(m, n)%c, best_q, best_cost)
            sse(m) = best_cost
            call backtrack_pwl_cps(states, m, n, best_q, cp_store(1:m-1, m))
            n_models_fitted = m
        end do

        deallocate(states, sy, siy, syy)
    end subroutine solve_continuous_pwl_sse

    !> Fit a continuous piecewise linear regression to y for a fixed changepoint set.
    subroutine fit_continuous_pwl_given_cps(y, cps, fitted, rss)
        real(kind=dp), intent(in) :: y(:)
        integer, intent(in) :: cps(:)
        real(kind=dp), intent(out) :: fitted(:)
        real(kind=dp), intent(out), optional :: rss

        integer :: n, p, i, k
        real(kind=dp), allocatable :: xtx(:, :), xty(:), beta(:)
        real(kind=dp) :: t

        n = size(y)
        if (size(fitted) /= n) error stop 'fit_continuous_pwl_given_cps: size(fitted) /= size(y)'

        p = size(cps) + 2
        allocate(xtx(p, p), xty(p), beta(p))
        xtx = 0.0_dp
        xty = 0.0_dp

        do i = 1, n
            t = real(i, dp)
            call accumulate_normal_equations(t, y(i), cps, xtx, xty)
        end do

        call solve_linear_system(xtx, xty, beta)

        do i = 1, n
            t = real(i, dp)
            fitted(i) = beta(1) + beta(2) * t
            do k = 1, size(cps)
                fitted(i) = fitted(i) + beta(k + 2) * max(0.0_dp, t - real(cps(k), dp))
            end do
        end do

        if (present(rss)) rss = sum((y - fitted)**2)

        deallocate(xtx, xty, beta)
    end subroutine fit_continuous_pwl_given_cps

    subroutine build_prefix_sums(y, sy, siy, syy)
        real(kind=dp), intent(in) :: y(:)
        real(kind=dp), allocatable, intent(out) :: sy(:), siy(:), syy(:)
        integer :: n, i

        n = size(y)
        allocate(sy(0:n), siy(0:n), syy(0:n))
        sy = 0.0_dp
        siy = 0.0_dp
        syy = 0.0_dp
        do i = 1, n
            sy(i) = sy(i-1) + y(i)
            siy(i) = siy(i-1) + real(i, dp) * y(i)
            syy(i) = syy(i-1) + y(i) * y(i)
        end do
    end subroutine build_prefix_sums

    subroutine first_segment_quadratic(t, sy, siy, syy, a, b, c)
        integer, intent(in) :: t
        real(kind=dp), intent(in) :: sy(0:), siy(0:), syy(0:)
        real(kind=dp), intent(out) :: a, b, c
        real(kind=dp) :: qa, qb, qc, qd, qe, qf, d, sumy, sumiy, sumjy, ya, yb, denom

        d = real(t - 1, dp)
        sumy = sy(t)
        sumiy = siy(t)
        sumjy = sumiy - sumy

        qa = (d + 1.0_dp) * (2.0_dp * d + 1.0_dp) / (6.0_dp * d)
        qb = (d * d - 1.0_dp) / (6.0_dp * d)
        qc = qa
        ya = sumy - sumjy / d
        yb = sumjy / d
        qd = -2.0_dp * ya
        qe = -2.0_dp * yb
        qf = syy(t)

        denom = qa
        a = qc - (qb * qb) / denom
        b = qe - qb * qd / denom
        c = qf - 0.25_dp * qd * qd / denom
    end subroutine first_segment_quadratic

    subroutine later_segment_coefficients(s, t, sy, siy, syy, a, b, c, dcoef, ecoef, fcoef)
        integer, intent(in) :: s, t
        real(kind=dp), intent(in) :: sy(0:), siy(0:), syy(0:)
        real(kind=dp), intent(out) :: a, b, c, dcoef, ecoef, fcoef
        real(kind=dp) :: len, sumy, sumiy, sumjy, ya, yb

        len = real(t - s, dp)
        sumy = sy(t) - sy(s)
        sumiy = siy(t) - siy(s)
        sumjy = sumiy - real(s, dp) * sumy

        a = (len - 1.0_dp) * (2.0_dp * len - 1.0_dp) / (6.0_dp * len)
        b = (len * len - 1.0_dp) / (6.0_dp * len)
        c = (len + 1.0_dp) * (2.0_dp * len + 1.0_dp) / (6.0_dp * len)
        ya = sumy - sumjy / len
        yb = sumjy / len
        dcoef = -2.0_dp * ya
        ecoef = -2.0_dp * yb
        fcoef = syy(t) - syy(s)
    end subroutine later_segment_coefficients

    subroutine set_state_single(state, a, b, c)
        type(quad_state), intent(inout) :: state
        real(kind=dp), intent(in) :: a, b, c

        state%nquad = 1
        allocate(state%a(1), state%b(1), state%c(1), state%parent_t(1), state%parent_q(1))
        state%a(1) = a
        state%b(1) = b
        state%c(1) = c
        state%parent_t(1) = 0
        state%parent_q(1) = 0
    end subroutine set_state_single

    subroutine set_state_subset(state, a, b, c, parent_t, parent_q, keep, nkeep)
        type(quad_state), intent(inout) :: state
        real(kind=dp), intent(in) :: a(:), b(:), c(:)
        integer, intent(in) :: parent_t(:), parent_q(:), keep(:), nkeep
        integer :: i, idx

        state%nquad = nkeep
        allocate(state%a(nkeep), state%b(nkeep), state%c(nkeep), state%parent_t(nkeep), state%parent_q(nkeep))
        do i = 1, nkeep
            idx = keep(i)
            state%a(i) = a(idx)
            state%b(i) = b(idx)
            state%c(i) = c(idx)
            state%parent_t(i) = parent_t(idx)
            state%parent_q(i) = parent_q(idx)
        end do
    end subroutine set_state_subset

    subroutine best_terminal_quadratic(a, b, c, best_q, best_cost)
        real(kind=dp), intent(in) :: a(:), b(:), c(:)
        integer, intent(out) :: best_q
        real(kind=dp), intent(out) :: best_cost
        integer :: j
        real(kind=dp) :: val

        best_q = 1
        best_cost = c(1) - 0.25_dp * b(1) * b(1) / a(1)
        do j = 2, size(a)
            val = c(j) - 0.25_dp * b(j) * b(j) / a(j)
            if (val < best_cost) then
                best_cost = val
                best_q = j
            end if
        end do
    end subroutine best_terminal_quadratic

    subroutine backtrack_pwl_cps(states, m, t, q, cps)
        type(quad_state), intent(in) :: states(:, :)
        integer, intent(in) :: m, t, q
        integer, intent(out) :: cps(:)
        integer :: seg, cur_t, cur_q

        if (size(cps) /= max(0, m - 1)) error stop 'backtrack_pwl_cps: invalid cps size'

        cur_t = t
        cur_q = q
        do seg = m, 2, -1
            cps(seg - 1) = states(seg, cur_t)%parent_t(cur_q)
            cur_q = states(seg, cur_t)%parent_q(cur_q)
            cur_t = cps(seg - 1)
        end do
    end subroutine backtrack_pwl_cps

    subroutine keep_lower_envelope(a, b, c, keep, nkeep)
        real(kind=dp), intent(in) :: a(:), b(:), c(:)
        integer, allocatable, intent(out) :: keep(:)
        integer, intent(out) :: nkeep

        integer :: k, i, j, nroot, nuniq, idx, nsurvive
        real(kind=dp), allocatable :: roots(:), roots_u(:), aa_s(:), bb_s(:), cc_s(:)
        logical, allocatable :: active(:), survive(:)
        real(kind=dp) :: aa, bb, cc, disc, r1, r2, x, delta

        k = size(a)
        if (k == 0) then
            allocate(keep(0))
            nkeep = 0
            return
        end if

        allocate(survive(k))
        survive = .true.
        do i = 1, k
            do j = 1, k
                if (i == j) cycle
                if (quadratic_dominated(a(i), b(i), c(i), a(j), b(j), c(j))) then
                    survive(i) = .false.
                    exit
                end if
            end do
        end do

        nsurvive = count(survive)
        allocate(aa_s(nsurvive), bb_s(nsurvive), cc_s(nsurvive), keep(nsurvive))
        idx = 0
        do i = 1, k
            if (survive(i)) then
                idx = idx + 1
                aa_s(idx) = a(i)
                bb_s(idx) = b(i)
                cc_s(idx) = c(i)
                keep(idx) = i
            end if
        end do
        deallocate(survive)

        allocate(active(nsurvive))
        active = .false.
        allocate(roots(max(1, nsurvive * (nsurvive - 1))))
        nroot = 0

        do i = 1, nsurvive - 1
            do j = i + 1, nsurvive
                aa = aa_s(i) - aa_s(j)
                bb = bb_s(i) - bb_s(j)
                cc = cc_s(i) - cc_s(j)
                if (abs(aa) <= 1.0e-12_dp) then
                    if (abs(bb) > 1.0e-12_dp) then
                        nroot = nroot + 1
                        roots(nroot) = -cc / bb
                    end if
                else
                    disc = bb * bb - 4.0_dp * aa * cc
                    if (disc >= -1.0e-10_dp) then
                        disc = max(disc, 0.0_dp)
                        r1 = (-bb - sqrt(disc)) / (2.0_dp * aa)
                        r2 = (-bb + sqrt(disc)) / (2.0_dp * aa)
                        nroot = nroot + 1
                        roots(nroot) = r1
                        if (abs(r2 - r1) > 1.0e-10_dp) then
                            nroot = nroot + 1
                            roots(nroot) = r2
                        end if
                    end if
                end if
            end do
        end do

        if (nroot > 0) then
            call sort_real(roots(1:nroot))
            allocate(roots_u(nroot))
            nuniq = 1
            roots_u(1) = roots(1)
            do i = 2, nroot
                if (abs(roots(i) - roots_u(nuniq)) > 1.0e-8_dp) then
                    nuniq = nuniq + 1
                    roots_u(nuniq) = roots(i)
                end if
            end do

            do i = 1, nuniq
                call mark_minimizers(roots_u(i), aa_s, bb_s, cc_s, active)
            end do

            delta = abs(roots_u(1)) + 1.0_dp
            call mark_minimizers(roots_u(1) - delta, aa_s, bb_s, cc_s, active)
            do i = 1, nuniq - 1
                x = 0.5_dp * (roots_u(i) + roots_u(i + 1))
                call mark_minimizers(x, aa_s, bb_s, cc_s, active)
            end do
            delta = abs(roots_u(nuniq)) + 1.0_dp
            call mark_minimizers(roots_u(nuniq) + delta, aa_s, bb_s, cc_s, active)
            deallocate(roots_u)
        else
            call mark_minimizers(0.0_dp, aa_s, bb_s, cc_s, active)
        end if

        nkeep = count(active)
        if (nkeep == 0) then
            call mark_minimizers(0.0_dp, aa_s, bb_s, cc_s, active)
            nkeep = count(active)
        end if

        keep(1:nkeep) = pack(keep, active)
        if (nkeep < size(keep)) keep = keep(1:nkeep)

        deallocate(active, roots, aa_s, bb_s, cc_s)
    end subroutine keep_lower_envelope

    logical pure function quadratic_dominated(a1, b1, c1, a2, b2, c2)
        real(kind=dp), intent(in) :: a1, b1, c1, a2, b2, c2
        real(kind=dp) :: aa, bb, cc, disc

        aa = a1 - a2
        bb = b1 - b2
        cc = c1 - c2
        if (aa < -1.0e-12_dp) then
            quadratic_dominated = .false.
        else if (abs(aa) <= 1.0e-12_dp) then
            if (abs(bb) <= 1.0e-12_dp) then
                quadratic_dominated = (cc >= -1.0e-12_dp)
            else
                quadratic_dominated = .false.
            end if
        else
            disc = bb * bb - 4.0_dp * aa * cc
            quadratic_dominated = (disc <= 1.0e-10_dp)
        end if
    end function quadratic_dominated

    subroutine mark_minimizers(x, a, b, c, active)
        real(kind=dp), intent(in) :: x
        real(kind=dp), intent(in) :: a(:), b(:), c(:)
        logical, intent(inout) :: active(:)
        integer :: i
        real(kind=dp) :: minv, v, tol

        minv = a(1) * x * x + b(1) * x + c(1)
        do i = 2, size(a)
            v = a(i) * x * x + b(i) * x + c(i)
            if (v < minv) minv = v
        end do
        tol = 1.0e-8_dp * max(1.0_dp, abs(minv))
        do i = 1, size(a)
            v = a(i) * x * x + b(i) * x + c(i)
            if (v <= minv + tol) active(i) = .true.
        end do
    end subroutine mark_minimizers

    subroutine sort_real(x)
        real(kind=dp), intent(inout) :: x(:)
        integer :: i, j
        real(kind=dp) :: tmp

        do i = 2, size(x)
            tmp = x(i)
            j = i - 1
            do while (j >= 1 .and. x(j) > tmp)
                x(j + 1) = x(j)
                j = j - 1
            end do
            x(j + 1) = tmp
        end do
    end subroutine sort_real

    subroutine accumulate_normal_equations(t, yval, cps, xtx, xty)
        real(kind=dp), intent(in) :: t, yval
        integer, intent(in) :: cps(:)
        real(kind=dp), intent(inout) :: xtx(:, :), xty(:)

        integer :: p, i, j
        real(kind=dp), allocatable :: x(:)

        p = size(cps) + 2
        allocate(x(p))
        x(1) = 1.0_dp
        x(2) = t
        do i = 1, size(cps)
            x(i + 2) = max(0.0_dp, t - real(cps(i), dp))
        end do

        do i = 1, p
            xty(i) = xty(i) + x(i) * yval
            do j = 1, p
                xtx(i, j) = xtx(i, j) + x(i) * x(j)
            end do
        end do

        deallocate(x)
    end subroutine accumulate_normal_equations

    subroutine solve_linear_system(a, b, x)
        real(kind=dp), intent(in) :: a(:, :), b(:)
        real(kind=dp), intent(out) :: x(:)

        integer :: n, i, k, ipiv
        real(kind=dp), allocatable :: aa(:, :), bb(:), rowtmp(:)
        real(kind=dp) :: piv, factor, best

        n = size(b)
        allocate(aa(n, n), bb(n), rowtmp(n))
        aa = a
        bb = b

        do k = 1, n - 1
            ipiv = k
            best = abs(aa(k, k))
            do i = k + 1, n
                if (abs(aa(i, k)) > best) then
                    best = abs(aa(i, k))
                    ipiv = i
                end if
            end do
            if (best <= 1.0e-12_dp) error stop 'solve_linear_system: singular matrix'

            if (ipiv /= k) then
                rowtmp = aa(k, :)
                aa(k, :) = aa(ipiv, :)
                aa(ipiv, :) = rowtmp
                piv = bb(k)
                bb(k) = bb(ipiv)
                bb(ipiv) = piv
            end if

            do i = k + 1, n
                factor = aa(i, k) / aa(k, k)
                aa(i, k:n) = aa(i, k:n) - factor * aa(k, k:n)
                bb(i) = bb(i) - factor * bb(k)
            end do
        end do
        if (abs(aa(n, n)) <= 1.0e-12_dp) error stop 'solve_linear_system: singular matrix'

        x(n) = bb(n) / aa(n, n)
        do i = n - 1, 1, -1
            x(i) = (bb(i) - sum(aa(i, i+1:n) * x(i+1:n))) / aa(i, i)
        end do

        deallocate(aa, bb, rowtmp)
    end subroutine solve_linear_system

    pure function segment_ends(parent, ms) result(seg_ends)
        !> Backtrack through the DP parent table to recover the ms segment end-points,
        !! then sort into ascending order.
        integer, intent(in) :: parent(:,:)
        integer, intent(in) :: ms
        integer :: seg_ends(ms)
        integer :: n, k, cp_idx
        n            = size(parent, 1)
        cp_idx       = n
        seg_ends(ms) = n
        do k = ms, 2, -1
            seg_ends(k-1) = parent(cp_idx, k)
            cp_idx        = seg_ends(k-1)
        end do
        if (ms > 1) call sort_int(seg_ends(1:ms-1))
    end function segment_ends

end module changepoint_mod
! ---- end changepoint.f90 ----

! ---- begin df_index_date_ops_mod.f90 ----
module df_index_date_ops_mod
use date_mod, only: date, operator(>=), operator(<=), operator(==), &
   operator(<), operator(>)
use util_mod, only: default
implicit none
private
public :: findloc_index, argsort_index, union_index, intersect_index, &
   is_sorted_index_array, is_unique_index_array, bsearch_exact_index, &
   bsearch_ffill_index, bsearch_bfill_index
contains

pure integer function findloc_index(a, x) result(pos)
! return first location of x in a, or 0 if not found
type(date), intent(in) :: a(:)
type(date), intent(in) :: x
integer :: i
pos = 0
do i = 1, size(a)
   if (a(i) == x) then
      pos = i
      return
   end if
end do
end function findloc_index

subroutine argsort_index(a, perm, ascending)
! return permutation perm such that a(perm) is sorted
 type(date), intent(in) :: a(:)
 integer, allocatable, intent(out) :: perm(:)
 logical, intent(in), optional :: ascending
 logical :: asc
 integer :: n, width, i, left, mid, right, p, q, k
 integer, allocatable :: tmp(:)
 asc = default(.true., ascending)
 n = size(a)
 allocate(perm(n), tmp(n))
 perm = [(i, i=1,n)]
 width = 1
 do while (width < n)
    i = 1
    do while (i <= n)
       left = i
       mid = min(i + width - 1, n)
       right = min(i + 2*width - 1, n)
       p = left
       q = mid + 1
       k = left
       do while (p <= mid .and. q <= right)
          if (asc) then
             if (a(perm(p)) <= a(perm(q))) then
                tmp(k) = perm(p)
                p = p + 1
             else
                tmp(k) = perm(q)
                q = q + 1
             end if
          else
             if (a(perm(p)) >= a(perm(q))) then
                tmp(k) = perm(p)
                p = p + 1
             else
                tmp(k) = perm(q)
                q = q + 1
             end if
          end if
          k = k + 1
       end do
       do while (p <= mid)
          tmp(k) = perm(p)
          p = p + 1
          k = k + 1
       end do
       do while (q <= right)
          tmp(k) = perm(q)
          q = q + 1
          k = k + 1
       end do
       perm(left:right) = tmp(left:right)
       i = i + 2*width
    end do
    width = 2*width
 end do
 deallocate(tmp)
end subroutine argsort_index

pure logical function is_sorted_index_array(a, ascending) result(is_sorted)
! return true if a is sorted
 type(date), intent(in) :: a(:)
 logical, intent(in), optional :: ascending
 logical :: asc
 integer :: i
 asc = default(.true., ascending)
 is_sorted = .true.
 if (size(a) <= 1) return
 if (asc) then
    do i = 2, size(a)
       if (a(i) < a(i-1)) then
          is_sorted = .false.
          return
       end if
    end do
 else
    do i = 2, size(a)
       if (a(i) > a(i-1)) then
          is_sorted = .false.
          return
       end if
    end do
 end if
end function is_sorted_index_array

logical function is_unique_index_array(a) result(is_unique)
! return true if a has no duplicates
 type(date), intent(in) :: a(:)
 integer :: i, n
 integer, allocatable :: perm(:)
 type(date), allocatable :: tmp(:)
 n = size(a)
 is_unique = .true.
 if (n <= 1) return
 allocate(tmp(n))
 tmp = a
 call argsort_index(tmp, perm, ascending=.true.)
 tmp = tmp(perm)
 do i = 2, n
    if (tmp(i) == tmp(i-1)) then
       is_unique = .false.
       exit
    end if
 end do
 deallocate(tmp, perm)
end function is_unique_index_array

function union_index(a, b) result(c)
! return union of a and b preserving first appearance order
 type(date), intent(in) :: a(:), b(:)
 type(date), allocatable :: c(:)
 type(date), allocatable :: tmp(:)
 integer :: n, i
 allocate(tmp(size(a) + size(b)))
 n = 0
 do i = 1, size(a)
    n = n + 1
    tmp(n) = a(i)
 end do
 do i = 1, size(b)
    if (.not. any(tmp(1:n) == b(i))) then
       n = n + 1
       tmp(n) = b(i)
    end if
 end do
 allocate(c(n))
 c = tmp(1:n)
end function union_index

function intersect_index(a, b) result(c)
! return intersection of a and b preserving order from a
 type(date), intent(in) :: a(:), b(:)
 type(date), allocatable :: c(:)
 type(date), allocatable :: tmp(:)
 integer :: n, i
 allocate(tmp(size(a)))
 n = 0
 do i = 1, size(a)
    if (any(b == a(i))) then
      n = n + 1
      tmp(n) = a(i)
    end if
 end do
 allocate(c(n))
 c = tmp(1:n)
end function intersect_index

pure integer function bsearch_exact_index(a, x) result(pos)
! return exact match position in sorted ascending array
 type(date), intent(in) :: a(:)
 type(date), intent(in) :: x
 integer :: lo, hi, mid
 pos = 0
 lo = 1
 hi = size(a)
 do while (lo <= hi)
    mid = (lo + hi)/2
    if (a(mid) == x) then
       pos = mid
       return
    else if (a(mid) < x) then
       lo = mid + 1
    else
       hi = mid - 1
    end if
 end do
end function bsearch_exact_index

pure integer function bsearch_ffill_index(a, x) result(pos)
! return rightmost a(pos) <= x in sorted ascending array
 type(date), intent(in) :: a(:)
 type(date), intent(in) :: x
 integer :: lo, hi, mid
 pos = 0
 lo = 1
 hi = size(a)
 do while (lo <= hi)
    mid = (lo + hi)/2
    if (a(mid) <= x) then
       pos = mid
       lo = mid + 1
    else
       hi = mid - 1
    end if
 end do
end function bsearch_ffill_index

pure integer function bsearch_bfill_index(a, x) result(pos)
! return leftmost a(pos) >= x in sorted ascending array
 type(date), intent(in) :: a(:)
 type(date), intent(in) :: x
 integer :: lo, hi, mid
 pos = 0
 lo = 1
 hi = size(a)
 do while (lo <= hi)
    mid = (lo + hi)/2
    if (a(mid) >= x) then
       pos = mid
       hi = mid - 1
    else
       lo = mid + 1
    end if
 end do
end function bsearch_bfill_index

end module df_index_date_ops_mod
! ---- end df_index_date_ops_mod.f90 ----

! ---- begin random.f90 ----
module random_mod
    use kind_mod
    use constants_mod
    implicit none
    private
    public :: rnorm, rt, rnig, rvg, rgh, rlogistic, rsech, rlaplace, rged, rcauchy, dp

    interface rnorm
        module procedure rnorm_s
        module procedure rnorm_v
    end interface

    interface rt
        module procedure rt_s
        module procedure rt_v
    end interface

    interface rnig
        module procedure rnig_s
        module procedure rnig_v
    end interface

    interface rvg
        module procedure rvg_s
        module procedure rvg_v
    end interface

    interface rgh
        module procedure rgh_s
        module procedure rgh_v
    end interface

    interface rlogistic
        module procedure rlogistic_s
        module procedure rlogistic_v
    end interface

    interface rsech
        module procedure rsech_s
        module procedure rsech_v
    end interface

    interface rlaplace
        module procedure rlaplace_s
        module procedure rlaplace_v
    end interface

    interface rged
        module procedure rged_s
        module procedure rged_v
    end interface

    interface rcauchy
        module procedure rcauchy_s
        module procedure rcauchy_v
    end interface

contains

    function rlogistic_s(mu, s) result(res)
        ! Generates a random sample from a logistic distribution with location mu and scale s.
        real(dp), intent(in)  :: mu, s
        real(dp) :: res, u
        call random_number(u)
        res = mu + s * log(u / (1.0_dp - u))
    end function rlogistic_s

    function rlogistic_v(n, mu, s) result(res)
        ! Generates a vector of n random samples from a logistic distribution.
        integer, intent(in) :: n
        real(dp), intent(in) :: mu, s
        real(dp), dimension(n) :: res
        integer :: i
        do i = 1, n
            res(i) = rlogistic_s(mu, s)
        end do
    end function rlogistic_v

    function rsech_s(mu, s) result(res)
        ! Generates a random sample from a hyperbolic secant distribution with location mu and scale s.
        real(dp), intent(in)  :: mu, s
        real(dp) :: res, u
        call random_number(u)
        res = mu + s * (2.0_dp / pi) * log(tan(pi * u / 2.0_dp))
    end function rsech_s

    function rsech_v(n, mu, s) result(res)
        ! Generates a vector of n random samples from a hyperbolic secant distribution.
        integer, intent(in) :: n
        real(dp), intent(in) :: mu, s
        real(dp), dimension(n) :: res
        integer :: i
        do i = 1, n
            res(i) = rsech_s(mu, s)
        end do
    end function rsech_v

    function rlaplace_s(mu, b) result(res)
        ! Generates a random sample from a Laplace distribution with location mu and scale b.
        real(dp), intent(in)  :: mu, b
        real(dp) :: res, u
        call random_number(u)
        res = mu - b * sign(1.0_dp, u - 0.5_dp) * log(1.0_dp - 2.0_dp * abs(u - 0.5_dp))
    end function rlaplace_s

    function rlaplace_v(n, mu, b) result(res)
        ! Generates a vector of n random samples from a Laplace distribution.
        integer, intent(in) :: n
        real(dp), intent(in) :: mu, b
        real(dp), dimension(n) :: res
        integer :: i
        do i = 1, n
            res(i) = rlaplace_s(mu, b)
        end do
    end function rlaplace_v

    function rged_s(mu, s, beta) result(res)
        ! Generates a random sample from a Generalized Error Distribution with location mu, scale s, and shape beta.
        real(dp), intent(in)  :: mu, s, beta
        real(dp) :: res, u
        call random_number(u)
        res = mu + s * sign(1.0_dp, u - 0.5_dp) * rgamma(1.0_dp / beta, 1.0_dp)**(1.0_dp/beta)
    end function rged_s

    function rged_v(n, mu, s, beta) result(res)
        ! Generates a vector of n random samples from a Generalized Error Distribution.
        integer, intent(in) :: n
        real(dp), intent(in) :: mu, s, beta
        real(dp), dimension(n) :: res
        integer :: i
        do i = 1, n
            res(i) = rged_s(mu, s, beta)
        end do
    end function rged_v

    function rcauchy_s(x0, gamma) result(res)
        ! Generates a random sample from a Cauchy distribution with location x0 and scale gamma.
        real(dp), intent(in)  :: x0, gamma
        real(dp) :: res, u
        call random_number(u)
        res = x0 + gamma * tan(pi * (u - 0.5_dp))
    end function rcauchy_s

    function rcauchy_v(n, x0, gamma) result(res)
        ! Generates a vector of n random samples from a Cauchy distribution.
        integer, intent(in) :: n
        real(dp), intent(in) :: x0, gamma
        real(dp), dimension(n) :: res
        integer :: i
        do i = 1, n
            res(i) = rcauchy_s(x0, gamma)
        end do
    end function rcauchy_v

    function rnorm_s(mu, sigma) result(res)
        ! Generates a random sample from a Normal distribution with location mu and standard deviation sigma.
        real(dp), intent(in), optional :: mu, sigma
        real(dp) :: res
        real(dp) :: u1, u2, lmu, lsigma
        lmu = 0.0_dp; if (present(mu)) lmu = mu
        lsigma = 1.0_dp; if (present(sigma)) lsigma = sigma
        call random_number(u1)
        call random_number(u2)
        res = lmu + lsigma * sqrt(-2.0_dp * log(u1)) * cos(2.0_dp * pi * u2)
    end function rnorm_s

    function rnorm_v(n, mu, sigma) result(res)
        ! Generates a vector of n random samples from a Normal distribution.
        integer, intent(in) :: n
        real(dp), intent(in), optional :: mu, sigma
        real(dp), dimension(n) :: res
        integer :: i
        do i = 1, n
            res(i) = rnorm_s(mu, sigma)
        end do
    end function rnorm_v

    function rnig_s(alpha, delta) result(res)
        ! Generates a random sample from a symmetric Normal Inverse Gaussian distribution.
        real(dp), intent(in) :: alpha, delta
        real(dp) :: res, w
        ! NIG is a mixture of Normal with IG(delta/gamma, delta^2) where gamma = sqrt(alpha^2 - beta^2)
        ! For symmetric NIG, beta=0, so gamma = alpha.
        w = rig_s(delta/alpha, delta**2)
        res = rnorm_s(0.0_dp, sqrt(w))
    end function rnig_s

    function rnig_v(n, alpha, delta) result(res)
        ! Generates a vector of n random samples from a symmetric Normal Inverse Gaussian distribution.
        integer, intent(in) :: n
        real(dp), intent(in) :: alpha, delta
        real(dp), dimension(n) :: res
        integer :: i
        do i = 1, n
            res(i) = rnig_s(alpha, delta)
        end do
    end function rnig_v

    function rvg_s(lambda, alpha) result(res)
        ! Generates a random sample from a symmetric Variance-Gamma distribution.
        real(dp), intent(in) :: lambda, alpha
        real(dp) :: res, w
        ! Symmetric VG is a mixture of Normal with Gamma(lambda, 2/alpha^2)
        w = rgamma(lambda, 2.0_dp / alpha**2)
        res = rnorm_s(0.0_dp, sqrt(w))
    end function rvg_s

    function rvg_v(n, lambda, alpha) result(res)
        ! Generates a vector of n random samples from a symmetric Variance-Gamma distribution.
        integer, intent(in) :: n
        real(dp), intent(in) :: lambda, alpha
        real(dp), dimension(n) :: res
        integer :: i
        do i = 1, n
            res(i) = rvg_s(lambda, alpha)
        end do
    end function rvg_v

    function rgh_s(lambda, alpha, delta) result(res)
        ! Generates a random sample from a symmetric Generalized Hyperbolic distribution.
        real(dp), intent(in) :: lambda, alpha, delta
        real(dp) :: res, w
        ! Symmetric GH is a mixture of Normal with GIG(lambda, delta, alpha)
        w = rgig_s(lambda, delta, alpha)
        res = rnorm_s(0.0_dp, sqrt(w))
    end function rgh_s

    function rgh_v(n, lambda, alpha, delta) result(res)
        ! Generates a vector of n random samples from a symmetric Generalized Hyperbolic distribution.
        integer, intent(in) :: n
        real(dp), intent(in) :: lambda, alpha, delta
        real(dp), dimension(n) :: res
        integer :: i
        do i = 1, n
            res(i) = rgh_s(lambda, alpha, delta)
        end do
    end function rgh_v

    function rig_s(mu, lambda) result(res)
        ! Generates a random sample from an Inverse Gaussian distribution.
        real(dp), intent(in) :: mu, lambda
        real(dp) :: res, v, y, x, u
        v = rnorm_s(0.0_dp, 1.0_dp)
        y = v**2
        x = mu + (mu**2 * y) / (2.0_dp * lambda) - &
            (mu / (2.0_dp * lambda)) * sqrt(4.0_dp * mu * lambda * y + mu**2 * y**2)
        call random_number(u)
        if (u <= mu / (mu + x)) then
            res = x
        else
            res = mu**2 / x
        end if
    end function rig_s

    function rgig_s(lambda, delta, alpha) result(res)
        ! Generates a random sample from a Generalized Inverse Gaussian distribution (simplified implementation).
        real(dp), intent(in) :: lambda, delta, alpha
        real(dp) :: res
        ! Simplified GIG generator for testing (Dagpunar, 1989 or similar)
        ! For this task, we will use a simple rejection or mixture if needed.
        ! Note: Implementing a full robust GIG generator is complex.
        ! For alpha*delta > 1 and symmetric cases, we can approximate or use IG for lambda=-0.5.
        if (abs(lambda + 0.5_dp) < 1e-7_dp) then
            res = rig_s(delta/alpha, delta**2)
        else
            ! Fallback for test: use Gamma if delta is small, IG if alpha is large
            ! Real implementation would use Devroye (2014)
            res = rgamma(max(lambda, 0.1_dp), 2.0_dp / alpha**2) + rig_s(delta/alpha, delta**2)
        end if
    end function rgig_s

    function rt_s(df) result(res)
        ! Generates a random sample from a Student's t-distribution with df degrees of freedom.
        real(dp), intent(in) :: df
        real(dp) :: res
        real(dp) :: z, v
        z = rnorm_s(0.0_dp, 1.0_dp)
        v = rchisq(df)
        res = z / sqrt(v / df)
    end function rt_s

    function rt_v(n, df) result(res)
        ! Generates a vector of n random samples from a Student's t-distribution.
        integer, intent(in) :: n
        real(dp), intent(in) :: df
        real(dp), dimension(n) :: res
        integer :: i
        do i = 1, n
            res(i) = rt_s(df)
        end do
    end function rt_v

    function rchisq(df) result(res)
        ! Generates a random sample from a Chi-squared distribution with df degrees of freedom.
        real(dp), intent(in) :: df
        real(dp) :: res
        res = rgamma(df/2.0_dp, 2.0_dp)
    end function rchisq

    recursive function rgamma(a, b) result(res)
        ! Generates a random sample from a Gamma distribution with shape a and scale b.
        real(dp), intent(in) :: a, b
        real(dp) :: res
        real(dp) :: d, c, x, v, u
        if (a >= 1.0_dp) then
            d = a - 1.0_dp/3.0_dp
            c = 1.0_dp / sqrt(9.0_dp * d)
            do
                do
                    x = rnorm_s(0.0_dp, 1.0_dp)
                    v = 1.0_dp + c * x
                    if (v > 0.0_dp) exit
                end do
                v = v**3
                call random_number(u)
                if (u < 1.0_dp - 0.0331_dp * x**4) then
                    res = d * v * b
                    return
                end if
                if (log(u) < 0.5_dp * x**2 + d * (1.0_dp - v + log(v))) then
                    res = d * v * b
                    return
                end if
            end do
        else
            call random_number(u)
            res = rgamma(a + 1.0_dp, b) * (u**(1.0_dp/a))
        end if
    end function rgamma

end module random_mod
! ---- end random.f90 ----

! ---- begin dataframe_index_date.f90 ----
module dataframe_index_date_mod
use kind_mod, only: dp
use util_mod, only: default, split_string, seq, cbind
use iso_fortran_env, only: output_unit
use date_mod
use df_index_date_ops_mod, only: findloc_index, argsort_index, union_index, &
   intersect_index, is_sorted_index_array, is_unique_index_array, &
   bsearch_exact_index, bsearch_ffill_index, bsearch_bfill_index
use, intrinsic :: ieee_arithmetic, only: ieee_value, ieee_quiet_nan, ieee_is_nan
implicit none
private
public :: DataFrame_index_date, nrow, ncol, print_summary, random, operator(*), &
   operator(/), operator(+), operator(-), display, allocate_df, &
   operator(**), shape, subset_stride
integer, parameter :: nlen_columns = 100, nrows_print = 10 ! number of rows to print by default.
logical, save :: blank_line_before_display = .true.
interface display
   module procedure display_data
end interface display
interface operator (*)
   module procedure mult_x_df, mult_df_x, mult_n_df, mult_df_n
   module procedure mult_df_df
end interface
interface operator (/)
   module procedure div_df_x, div_df_n, div_x_df, div_n_df
   module procedure div_df_df
end interface
interface operator (+)
   module procedure add_x_df, add_df_x, add_n_df, add_df_n
   module procedure add_df_df
end interface
interface operator (-)
   module procedure subtract_x_df, subtract_df_x, &
      subtract_n_df, subtract_df_n, subtract_df_df
end interface
interface operator (**)
   module procedure power_df_n, power_df_x
end interface

type :: DataFrame_index_date
   type(date), allocatable      :: index(:)
   character(len=nlen_columns), allocatable :: columns(:)
   real(kind=dp), allocatable    :: values(:,:)
   contains
      procedure :: read_csv, display=>display_data, write_csv, irow, icol, &
         loc, append_col, append_cols, set_col, col_pos, row_pos, &
         sort_index, is_sorted_index, is_unique_index, at, iat, &
         set_at, set_iat, has_col, has_idx, drop_cols, drop_rows, &
         rename_cols, where_cols, filter_cols, where, filter, iloc, &
         slct, add, subtract, multiply, divide, reindex, shift, &
         pct_change, log_change, resample, keep_rows
end type DataFrame_index_date

contains

function resample(self) result(df_new)
! return a dataframe with rows sampled with replacement, keeping the original index
class(DataFrame_index_date), intent(in) :: self
type(DataFrame_index_date) :: df_new
integer :: i, n
real(kind=dp) :: u
integer, allocatable :: indices(:)

n = nrow(self)
allocate(indices(n))
do i = 1, n
    call random_number(u)
    indices(i) = int(u * n) + 1
end do

df_new = DataFrame_index_date(index=self%index, columns=self%columns, values=self%values(indices, :))
end function resample

function keep_rows(self, n, latest) result(df_new)
! Return a dataframe with at most n rows.
! If latest=.true.  (default), keep the last  n rows.
! If latest=.false.,            keep the first n rows.
! If n >= nrow(self) or n <= 0 the full dataframe is returned unchanged.
class(DataFrame_index_date), intent(in) :: self
integer, intent(in) :: n
logical, intent(in), optional :: latest
type(DataFrame_index_date) :: df_new
integer :: total, i0, i
logical :: from_end
integer, allocatable :: rows(:)

from_end = .true.
if (present(latest)) from_end = latest

total = nrow(self)
if (n <= 0 .or. n >= total) then
   df_new = self%iloc()
   return
end if

if (from_end) then
   i0 = total - n + 1                        ! first row to keep
else
   i0 = 1
end if
rows = [(i0 + i - 1, i = 1, n)]
df_new = self%iloc(rows=rows)
end function keep_rows

pure function shape(df) result(ishape)
! return a 2-element array with the number of rows and columns of the dataframe
type(DataFrame_index_date), intent(in) :: df
integer                     :: ishape(2)
ishape = [nrow(df), ncol(df)]
end function shape

pure function icol(df, ivec) result(df_new)
! returns a dataframe with the subset of columns in ivec(:)
class(DataFrame_index_date), intent(in) :: df
integer, intent(in) :: ivec(:)
type(DataFrame_index_date) :: df_new
df_new = DataFrame_index_date(index=df%index, columns=df%columns(ivec), values=df%values(:, ivec))
end function icol

pure function loc(df, rows, columns) result(df_new)
! return a subset of a dataframe with the specified rows (index values) and columns
class(DataFrame_index_date), intent(in) :: df
type(date), intent(in), optional :: rows(:)
character (len=*), intent(in), optional :: columns(:)
type(DataFrame_index_date) :: df_new
type(date), allocatable :: rows_(:)
character (len=nlen_columns), allocatable :: columns_(:)
integer :: i
integer, allocatable :: jrow(:), jcol(:)
if (present(rows)) then
   rows_ = rows
   allocate (jrow(size(rows)))
   do i=1,size(rows)
      jrow(i) = findloc_index(df%index, rows(i))
   end do
else
   rows_ = df%index
   jrow = seq(1, nrow(df))
end if
if (present(columns)) then
   columns_ = columns
   allocate(jcol(size(columns)))
   do i=1,size(columns)
      jcol(i) = findloc(df%columns, columns(i), dim=1)
   end do
else
   columns_ = df%columns
   jcol = seq(1, ncol(df))
end if
df_new = DataFrame_index_date(index=rows_, columns=columns_, values=df%values(jrow, jcol))
end function loc

pure function row_pos(self, idx, assume_sorted, ascending) result(irow)
! return the row position (1..nrow) for index value idx
! if assume_sorted is true, use binary search assuming index is sorted
class(DataFrame_index_date), intent(in) :: self
type(date), intent(in) :: idx
logical, intent(in), optional :: assume_sorted, ascending
integer :: irow
logical :: do_sorted, asc
integer :: lo, hi, mid

do_sorted = default(.false., assume_sorted)
asc = default(.true., ascending)

if (.not. allocated(self%index)) error stop "in row_pos, index is not allocated"

if (do_sorted) then
   ! binary search for first occurrence (like findloc) in a sorted index
   lo = 1
   hi = size(self%index)
   irow = 0
   do while (lo <= hi)
      mid = (lo + hi) / 2
      if (asc) then
         if (self%index(mid) < idx) then
            lo = mid + 1
         else
            if (self%index(mid) == idx) irow = mid
            hi = mid - 1
         end if
      else
         if (self%index(mid) > idx) then
            lo = mid + 1
         else
            if (self%index(mid) == idx) irow = mid
            hi = mid - 1
         end if
      end if
   end do
else
   irow = findloc_index(self%index, idx)
end if

if (irow == 0) error stop "in row_pos, index not found"
end function row_pos

function is_sorted_index(self, ascending) result(is_sorted)
! return true if index is sorted (nondecreasing if ascending, nonincreasing otherwise)
class(DataFrame_index_date), intent(in) :: self
logical, intent(in), optional :: ascending
logical :: is_sorted
logical :: asc
integer :: i, n

asc = default(.true., ascending)

if (.not. allocated(self%index)) then
   is_sorted = .true.
   return
end if

n = size(self%index)
is_sorted = .true.
if (n <= 1) return

if (asc) then
   do i=2,n
      if (self%index(i) < self%index(i-1)) then
         is_sorted = .false.
         exit
      end if
   end do
else
   do i=2,n
      if (self%index(i) > self%index(i-1)) then
         is_sorted = .false.
         exit
      end if
   end do
end if
end function is_sorted_index

function is_unique_index(self) result(is_unique)
! return true if index has no duplicates
class(DataFrame_index_date), intent(in) :: self
logical :: is_unique

if (.not. allocated(self%index)) then
   is_unique = .true.
   return
end if

is_unique = is_unique_index_array(self%index)
end function is_unique_index

subroutine sort_index(self, ascending)
! sort rows by index, permuting values accordingly
class(DataFrame_index_date), intent(inout) :: self
logical, intent(in), optional :: ascending
logical :: asc
integer :: n
integer, allocatable :: perm(:)
real(kind=dp), allocatable :: vtmp(:,:)

asc = default(.true., ascending)

if (.not. allocated(self%index)) return
if (.not. allocated(self%values)) return

n = size(self%index)
if (n <= 1) return

call argsort_index(self%index, perm, ascending=asc)

! reorder index
self%index = self%index(perm)

! reorder values
allocate(vtmp(n, size(self%values,2)))
vtmp = self%values(perm, :)
self%values = vtmp
deallocate(vtmp, perm)
end subroutine sort_index


pure function col_pos(self, column) result(jcol)
! return the column position (1..ncol) for column name
class(DataFrame_index_date), intent(in) :: self
character(len=*), intent(in) :: column
integer :: jcol
jcol = findloc(self%columns, column, dim=1)
if (jcol == 0) error stop "in col_pos, column not found: " // trim(column)
end function col_pos

pure function iat(self, i, j) result(x)
! return a scalar element by 1-based row/column positions
class(DataFrame_index_date), intent(in) :: self
integer, intent(in) :: i, j
real(kind=dp) :: x
if (i < 1 .or. i > nrow(self)) error stop "in iat, row position out of range"
if (j < 1 .or. j > ncol(self)) error stop "in iat, column position out of range"
x = self%values(i, j)
end function iat

pure function at(self, idx, column) result(x)
! return a scalar element by index value and column name
class(DataFrame_index_date), intent(in) :: self
type(date), intent(in) :: idx
character(len=*), intent(in) :: column
real(kind=dp) :: x
integer :: i, j
i = self%row_pos(idx)
j = self%col_pos(column)
x = self%values(i, j)
end function at

pure subroutine set_iat(self, i, j, x)
! set a scalar element by 1-based row/column positions
class(DataFrame_index_date), intent(in out) :: self
integer, intent(in) :: i, j
real(kind=dp), intent(in) :: x
if (i < 1 .or. i > nrow(self)) error stop "in set_iat, row position out of range"
if (j < 1 .or. j > ncol(self)) error stop "in set_iat, column position out of range"
self%values(i, j) = x
end subroutine set_iat

pure subroutine set_at(self, idx, column, x)
! set a scalar element by index value and column name
class(DataFrame_index_date), intent(in out) :: self
type(date), intent(in) :: idx
character(len=*), intent(in) :: column
real(kind=dp), intent(in) :: x
integer :: i, j
i = self%row_pos(idx)
j = self%col_pos(column)
self%values(i, j) = x
end subroutine set_at

logical function has_col(self, name)
! return .true. if dataframe has a column with the given name
class(DataFrame_index_date), intent(in) :: self
character(len=*), intent(in) :: name
integer :: j
character(len=nlen_columns) :: key
key = trim(name)
j = findloc(self%columns, key, dim=1)
has_col = (j > 0)
end function has_col

logical function has_idx(self, idx)
! return .true. if dataframe has a row with the given index value
class(DataFrame_index_date), intent(in) :: self
type(date), intent(in) :: idx
integer :: i
i = findloc_index(self%index, idx)
has_idx = (i > 0)
end function has_idx

function drop_cols(self, names, missing) result(df_new)
! drop columns by name
class(DataFrame_index_date), intent(in) :: self
character(len=*), intent(in) :: names(:)
character(len=*), intent(in), optional :: missing
type(DataFrame_index_date) :: df_new
logical, allocatable :: keep(:)
integer, allocatable :: ivec_keep(:)
integer :: k, j, n
character(len=100) :: miss
character(len=nlen_columns) :: key

miss = trim(default("error", missing))
miss = str_lower(miss)

n = ncol(self)
allocate(keep(n))
keep = .true.

do k = 1, size(names)
   key = trim(names(k))
   j = findloc(self%columns, key, dim=1)
   if (j <= 0) then
      if (miss == "ignore") cycle
      error stop "drop_cols: column not found: "//trim(names(k))
   end if
   keep(j) = .false.
end do

ivec_keep = pack(seq(1, n), keep)
df_new = self%icol(ivec_keep)
end function drop_cols

function drop_rows(self, idx, missing) result(df_new)
! drop rows by index value
class(DataFrame_index_date), intent(in) :: self
type(date), intent(in) :: idx(:)
character(len=*), intent(in), optional :: missing
type(DataFrame_index_date) :: df_new
logical, allocatable :: keep(:)
integer, allocatable :: ivec_keep(:)
integer :: k, i, n
character(len=100) :: miss

miss = trim(default("error", missing))
miss = str_lower(miss)

n = nrow(self)
allocate(keep(n))
keep = .true.

do k = 1, size(idx)
   i = findloc_index(self%index, idx(k))
   if (i <= 0) then
      if (miss == "ignore") cycle
      error stop "drop_rows: index not found"
   end if
   keep(i) = .false.
end do

ivec_keep = pack(seq(1, n), keep)
df_new = self%irow(ivec_keep)
end function drop_rows

subroutine rename_cols(self, old, new, missing)
! rename columns: replace each old(i) with new(i)
class(DataFrame_index_date), intent(in out) :: self
character(len=*), intent(in) :: old(:), new(:)
character(len=*), intent(in), optional :: missing
integer :: k, j
character(len=100) :: miss
character(len=nlen_columns) :: key

if (size(old) /= size(new)) error stop "rename_cols: size(old) /= size(new)"

miss = trim(default("error", missing))
miss = str_lower(miss)

do k = 1, size(old)
   key = trim(old(k))
   j = findloc(self%columns, key, dim=1)
   if (j <= 0) then
      if (miss == "ignore") cycle
      error stop "rename_cols: column not found: "//trim(old(k))
   end if
   self%columns(j) = trim(new(k))
end do
end subroutine rename_cols



function where_cols(self, mask_cols) result(df_new)
! keep columns where mask_cols(j) is .true.
class(DataFrame_index_date), intent(in) :: self
logical, intent(in) :: mask_cols(:)
type(DataFrame_index_date) :: df_new
integer, allocatable :: j_keep(:)
if (size(mask_cols) /= ncol(self)) error stop "where_cols: size(mask_cols) /= ncol(self)"
j_keep = pack(seq(1, ncol(self)), mask_cols)
df_new = self%icol(j_keep)
end function where_cols

function filter_cols(self, mask_cols, drop) result(df_new)
! filter columns by mask; if drop=.true. then drop columns where mask is .true.
class(DataFrame_index_date), intent(in) :: self
logical, intent(in) :: mask_cols(:)
logical, intent(in), optional :: drop
type(DataFrame_index_date) :: df_new
logical :: drop_
logical, allocatable :: keep(:)
drop_ = default(.false., drop)
if (size(mask_cols) /= ncol(self)) error stop "filter_cols: size(mask_cols) /= ncol(self)"
allocate(keep(size(mask_cols)))
if (drop_) then
   keep = .not. mask_cols
else
   keep = mask_cols
end if
df_new = self%where_cols(keep)
end function filter_cols

function where(self, mask_rows, mask_cols) result(df_new)
! keep rows and columns where masks are .true.
class(DataFrame_index_date), intent(in) :: self
logical, intent(in) :: mask_rows(:)
logical, intent(in) :: mask_cols(:)
type(DataFrame_index_date) :: df_new
integer, allocatable :: i_keep(:), j_keep(:)
if (size(mask_rows) /= nrow(self)) error stop "where: size(mask_rows) /= nrow(self)"
if (size(mask_cols) /= ncol(self)) error stop "where: size(mask_cols) /= ncol(self)"
i_keep = pack(seq(1, nrow(self)), mask_rows)
j_keep = pack(seq(1, ncol(self)), mask_cols)
df_new = DataFrame_index_date(index=self%index(i_keep), columns=self%columns(j_keep), values=self%values(i_keep, j_keep))
end function where

function filter(self, mask_rows, mask_cols, drop_rows, drop_cols) result(df_new)
! filter rows and columns by masks; if drop_rows/drop_cols are .true. then drop where mask is .true.
class(DataFrame_index_date), intent(in) :: self
logical, intent(in) :: mask_rows(:)
logical, intent(in) :: mask_cols(:)
logical, intent(in), optional :: drop_rows, drop_cols
type(DataFrame_index_date) :: df_new
logical :: drop_r, drop_c
logical, allocatable :: keep_rows(:), keep_cols(:)

if (size(mask_rows) /= nrow(self)) error stop "filter: size(mask_rows) /= nrow(self)"
if (size(mask_cols) /= ncol(self)) error stop "filter: size(mask_cols) /= ncol(self)"

drop_r = default(.false., drop_rows)
drop_c = default(.false., drop_cols)

allocate(keep_rows(size(mask_rows)))
allocate(keep_cols(size(mask_cols)))

if (drop_r) then
   keep_rows = .not. mask_rows
else
   keep_rows = mask_rows
end if

if (drop_c) then
   keep_cols = .not. mask_cols
else
   keep_cols = mask_cols
end if

df_new = self%where(keep_rows, keep_cols)
end function filter

function iloc(self, rows, cols) result(df_new)
! positional selection by row/column positions (1-based)
class(DataFrame_index_date), intent(in) :: self
integer, intent(in), optional :: rows(:)
integer, intent(in), optional :: cols(:)
type(DataFrame_index_date) :: df_new
if (present(rows) .and. present(cols)) then
   df_new = self%slct(irows=rows, icols=cols)
else if (present(rows)) then
   df_new = self%slct(irows=rows)
else if (present(cols)) then
   df_new = self%slct(icols=cols)
else
   df_new = self%slct()
end if
end function iloc

function slct(self, rows, columns, irows, icols) result(df_new)
! select a sub-dataframe using label- or position-based selectors on each axis.
! rules:
!  - at most one of rows/irows may be present
!  - at most one of columns/icols may be present
class(DataFrame_index_date), intent(in) :: self
type(date), intent(in), optional :: rows(:)
character(len=*), intent(in), optional :: columns(:)
integer, intent(in), optional :: irows(:)
integer, intent(in), optional :: icols(:)
type(DataFrame_index_date) :: df_new
integer, allocatable :: i_keep(:), j_keep(:)
integer :: k

if (present(rows) .and. present(irows)) error stop "select: both rows and irows are present"
if (present(columns) .and. present(icols)) error stop "select: both columns and icols are present"

if (present(rows)) then
   allocate(i_keep(size(rows)))
   do k = 1, size(rows)
      i_keep(k) = self%row_pos(rows(k))
   end do
else if (present(irows)) then
   i_keep = irows
   do k = 1, size(i_keep)
      if (i_keep(k) < 1 .or. i_keep(k) > nrow(self)) error stop "select: row position out of range"
   end do
else
   i_keep = seq(1, nrow(self))
end if

if (present(columns)) then
   allocate(j_keep(size(columns)))
   do k = 1, size(columns)
      j_keep(k) = self%col_pos(columns(k))
   end do
else if (present(icols)) then
   j_keep = icols
   do k = 1, size(j_keep)
      if (j_keep(k) < 1 .or. j_keep(k) > ncol(self)) error stop "select: column position out of range"
   end do
else
   j_keep = seq(1, ncol(self))
end if

df_new = DataFrame_index_date(index=self%index(i_keep), columns=self%columns(j_keep), values=self%values(i_keep, j_keep))
end function slct
pure function str_lower(str) result(out)
! return str converted to lowercase (ASCII)
character(len=*), intent(in) :: str
character(len=len(str))      :: out
integer :: i, c
out = str
do i = 1, len(str)
   c = iachar(out(i:i))
   if (c >= iachar('A') .and. c <= iachar('Z')) out(i:i) = achar(c + 32)
end do
end function str_lower

pure function irow(df, ivec) result(df_new)
! returns a dataframe with the subset of columns in ivec(:)
class(DataFrame_index_date), intent(in) :: df
integer, intent(in) :: ivec(:)
type(DataFrame_index_date) :: df_new
df_new = DataFrame_index_date(index=df%index(ivec), columns=df%columns, values=df%values(ivec, :))
end function irow

pure subroutine set_col(df, column, values)
! append a column with specified values to DataFrame df if column is not in df,
! and set the values of that column if it is already present
class(DataFrame_index_date), intent(in out) :: df
character (len=*), intent(in) :: column
real(kind=dp), intent(in) :: values(:)
integer :: jcol
if (size(values) /= nrow(df)) error stop "in set_col, size(values) /= nrow(df)"
jcol = findloc(df%columns, column, dim=1)
if (jcol == 0) then
   call append_col(df, column, values)
else
   df%values(:,jcol) = values
end if
end subroutine set_col

pure subroutine append_col(df, column, values)
! append a column with specified values to DataFrame df
class(DataFrame_index_date), intent(in out) :: df
character (len=*), intent(in) :: column
real(kind=dp), intent(in) :: values(:)
character (len=nlen_columns) :: column_
if (size(values) /= nrow(df)) error stop "in append_col, size(values) /= nrow(df)"
column_ = column
df%columns = [df%columns, column_]
df%values  = cbind(df%values, values)
end subroutine append_col

pure subroutine append_cols(df, columns, values)
! append a column with specified values to DataFrame df
class(DataFrame_index_date), intent(in out) :: df
character (len=*), intent(in) :: columns(:)
real(kind=dp), intent(in) :: values(:,:)
character (len=nlen_columns), allocatable :: columns_(:)
if (size(values, 1) /= nrow(df)) error stop "in append_cols, size(values) /= nrow(df)"
if (size(values, 2) /= size(columns)) error stop "in append_cols, size(values, 2) /= size(columns)"
columns_ = columns
df%columns = [df%columns, columns_]
df%values  = cbind(df%values, values)
end subroutine append_cols

subroutine allocate_df(df, n1, n2, default_indices, default_columns)
type(DataFrame_index_date), intent(out) :: df
integer        , intent(in)  :: n1, n2
logical        , intent(in), optional :: default_indices, default_columns
integer :: i
allocate (df%index(n1), df%columns(n2), df%values(n1, n2))
if (default(.true., default_indices)) then
   do i=1,n1
      df%index(i) = date(2000,1,1) + (i - 1)
   end do
end if
if (default(.true., default_columns)) then
   do i=1,n2
      write (df%columns(i), "('x',i0)") i
   end do
end if
end subroutine allocate_df

elemental function nrow(df) result(num_rows)
! return the # of rows
type(DataFrame_index_date), intent(in) :: df
integer                     :: num_rows
if (allocated(df%values)) then
   num_rows = size(df%values, 1)
else
   num_rows = -1
end if
end function nrow

elemental function ncol(df) result(num_col)
! return the # of columns
type(DataFrame_index_date), intent(in) :: df
integer                     :: num_col
if (allocated(df%values)) then
   num_col = size(df%values, 2)
else
   num_col = -1
end if
end function ncol

!------------------------------------------------------------------
! read_csv:
!
! Reads from a CSV file with the following format:
!
!      ,Col1,Col2,...
!      index1,val11,val12,...
!      index2,val21,val22,...
!
! The header row begins with an empty token (before the first comma).
!------------------------------------------------------------------
subroutine read_csv(self, filename, max_col, max_rows)
class(DataFrame_index_date), intent(inout) :: self
character(len=*), intent(in)    :: filename
integer, intent(in), optional :: max_col, max_rows
integer :: io, unit, i, j, nrows, ncols
character(len=1024) :: line
character(:), allocatable :: tokens(:)
type(date) :: idx

if (allocated(self%index)) deallocate(self%index)
if (allocated(self%columns)) deallocate(self%columns)
if (allocated(self%values)) deallocate(self%values)

open(newunit=unit, file=filename, status="old", action="read", iostat=io)
if (io /= 0) error stop "Error opening " // trim(filename) // " in read_csv"

read(unit, "(A)", iostat=io) line
if (io /= 0) error stop "Error reading header line in read_csv"

call split_string(line, ",", tokens)
ncols = size(tokens) - 1
if (present(max_col)) ncols = min(ncols, max_col)
if (ncols <= 0) error stop "No columns detected in header in read_csv"

allocate(self%columns(ncols))
do i = 1, ncols
   self%columns(i) = tokens(i+1)
end do

nrows = 0
do
   if (present(max_rows)) then
      if (nrows >= max_rows) exit
   end if
   read(unit, "(A)", iostat=io) line
   if (io /= 0 .or. trim(line) == "") exit
   nrows = nrows + 1
end do
if (nrows == 0) error stop "No data lines detected in read_csv"

rewind(unit)
read(unit, "(A)")

allocate(self%index(nrows), self%values(nrows, ncols))
do i = 1, nrows
   read(unit, "(A)", iostat=io) line
   if (io /= 0) error stop "Error reading data row in read_csv"
   if (trim(line) == "") exit
   call split_string(line, ",", tokens)
   idx = date_from_iso(trim(tokens(1)))
   if (.not. valid(idx)) idx = date_from_basic(trim(tokens(1)))
   if (.not. valid(idx)) error stop "Invalid date in first column in read_csv"
   self%index(i) = idx
   do j = 1, ncols
      read(tokens(j+1), *) self%values(i,j)
   end do
end do

close(unit)
end subroutine read_csv

!------------------------------------------------------------------
! display_data:
!
! Prints the DataFrame to the screen in a CSV-like format.
! If the DataFrame has more than nrows_print observations, by default only
! the first nrows_print/2 and the last (nrows_print - nrows_print/2) rows are
! printed with an indication of omitted rows.
!
! An optional logical argument "print_all" may be provided. If it is present
! and set to .true., then all rows are printed.
!------------------------------------------------------------------
impure elemental subroutine display_data(self, print_all, fmt_ir, fmt_header, fmt_trailer, title)
class(DataFrame_index_date), intent(in) :: self
logical, intent(in), optional :: print_all
character (len=*), intent(in), optional :: fmt_ir, fmt_header, fmt_trailer, title
integer :: total, i, n_top, n_bottom
logical :: print_all_
character (len=100) :: fmt_ir_, fmt_header_
fmt_ir_ = default("(*(1x,f10.4))", fmt_ir)
fmt_header_ = default("(a10,*(1x,a10))", fmt_header)
print_all_ = default(.false., print_all)
total = size(self%index)
if (blank_line_before_display) write(*,*)
if (present(title)) write(*,"(a)") title
write(*,fmt_header_) "index", (trim(self%columns(i)), i=1,size(self%columns))

if (print_all_) then
   do i = 1, total
      write(*,"(a10)", advance="no") self%index(i)%to_str()
      write(*,fmt_ir_) self%values(i,:)
   end do
else
   if (total <= nrows_print) then
      do i = 1, total
         write(*,"(a10)", advance="no") self%index(i)%to_str()
         write(*,fmt_ir_) self%values(i,:)
      end do
   else
      n_top = nrows_print / 2
      n_bottom = nrows_print - n_top
      do i = 1, n_top
         write(*,"(a10)", advance="no") self%index(i)%to_str()
         write(*,fmt_ir_) self%values(i,:)
      end do
      write(*,*) "   ... (", total - nrows_print, " rows omitted) ..."
      do i = total - n_bottom + 1, total
         write(*,"(a10)", advance="no") self%index(i)%to_str()
         write(*,fmt_ir_) self%values(i,:)
      end do
   end if
end if
if (present(fmt_trailer)) write(*,fmt_trailer)
end subroutine display_data

!------------------------------------------------------------------
! write_csv:
!
! Writes the DataFrame to a CSV file in the same format as read_csv.
!------------------------------------------------------------------
subroutine write_csv(self, filename)
class(DataFrame_index_date), intent(in) :: self
character(len=*), intent(in) :: filename
integer :: i, j, unit, io

open(newunit=unit, file=filename, status="replace", action="write", iostat=io)
if (io /= 0) error stop "Error opening " // trim(filename) // " in write_csv"

write(unit,"(A)", advance="no") ""
do j = 1, size(self%columns)
   write(unit,'(",", A)', advance='no') trim(self%columns(j))
end do
write(unit,*)

do i = 1, size(self%index)
   write(unit,'(A)', advance='no') trim(self%index(i)%to_str())
   do j = 1, size(self%columns)
      write(unit,'(",", G0.12)', advance='no') self%values(i,j)
   end do
   write(unit,*)
end do
close(unit)
end subroutine write_csv

subroutine print_summary(self, outu, fmt_header, fmt_trailer)
type(DataFrame_index_date), intent(in) :: self
integer, intent(in), optional :: outu
character (len=*), intent(in), optional :: fmt_header, fmt_trailer
integer :: outu_, nr, nc
outu_ = default(output_unit, outu)
if (present(fmt_header)) write (outu_, fmt_header)
nr = nrow(self)
nc = ncol(self)
write(outu_, "('#rows, columns:', 2(1x,i0))") nr, nc
if (nr > 0) write(outu_, "('first, last indices:', 2(1x,a))") trim(self%index(1)%to_str()), trim(self%index(nr)%to_str())
if (nc > 0) write(outu_, "('first, last columns:', 2(1x,a))") trim(self%columns(1)), trim(self%columns(nc))
if (present(fmt_trailer)) write (outu_, fmt_trailer)
end subroutine print_summary

subroutine alloc(self, nr, nc)
type(DataFrame_index_date), intent(out) :: self
integer        , intent(in)  :: nr, nc
allocate (self%index(nr), self%values(nr, nc))
allocate (self%columns(nc))
end subroutine alloc

subroutine random(self, nr, nc)
type(DataFrame_index_date), intent(out) :: self
integer, intent(in) :: nr, nc
integer :: i
call alloc(self, nr, nc)
call random_number(self%values)
do i=1,nr
   self%index(i) = date(2000,1,1) + (i - 1)
end do
do i=1,nc
   write (self%columns(i), "('C',i0)") i
end do
end subroutine random

function mult_x_df(x, df) result(res)
! return x * df
real(kind=dp)  , intent(in) :: x
type(DataFrame_index_date), intent(in) :: df
type(DataFrame_index_date)             :: res
res = df
if (allocated(res%values)) res%values = x*res%values
end function mult_x_df

function mult_df_x(df, x) result(res)
! return df * x
type(DataFrame_index_date), intent(in) :: df
real(kind=dp)  , intent(in) :: x
type(DataFrame_index_date)             :: res
res = df
if (allocated(res%values)) res%values = x*res%values
end function mult_df_x

function add_x_df(x, df) result(res)
! return x * df
real(kind=dp)  , intent(in) :: x
type(DataFrame_index_date), intent(in) :: df
type(DataFrame_index_date)             :: res
res = df
if (allocated(res%values)) res%values = x + res%values
end function add_x_df

function add_df_x(df, x) result(res)
! return df * x
type(DataFrame_index_date), intent(in) :: df
real(kind=dp)  , intent(in) :: x
type(DataFrame_index_date)             :: res
res = df
if (allocated(res%values)) res%values = res%values + x
end function add_df_x

function subtract_x_df(x, df) result(res)
! return x - df
real(kind=dp)  , intent(in) :: x
type(DataFrame_index_date), intent(in) :: df
type(DataFrame_index_date)             :: res
res = df
if (allocated(res%values)) res%values = x - res%values
end function subtract_x_df

function subtract_df_x(df, x) result(res)
! return df - x
type(DataFrame_index_date), intent(in) :: df
real(kind=dp)  , intent(in) :: x
type(DataFrame_index_date)             :: res
res = df
if (allocated(res%values)) res%values = res%values - x
end function subtract_df_x

function div_df_x(df, x) result(res)
! return df / x
real(kind=dp)  , intent(in) :: x
type(DataFrame_index_date), intent(in) :: df
type(DataFrame_index_date)             :: res
res = df
if (allocated(res%values)) res%values = res%values/x
end function div_df_x

function div_x_df(x, df) result(res)
! return df / x
real(kind=dp)  , intent(in) :: x
type(DataFrame_index_date), intent(in) :: df
type(DataFrame_index_date)             :: res
res = df
if (allocated(res%values)) res%values = x/res%values
end function div_x_df

function div_n_df(n, df) result(res)
! return n / x
integer        , intent(in) :: n
type(DataFrame_index_date), intent(in) :: df
type(DataFrame_index_date)             :: res
res = df
if (allocated(res%values)) res%values = n/res%values
end function div_n_df

function mult_n_df(n, df) result(res)
! return n * df
integer        , intent(in) :: n
type(DataFrame_index_date), intent(in) :: df
type(DataFrame_index_date)             :: res
res = df
if (allocated(res%values)) res%values = n*res%values
end function mult_n_df

function mult_df_n(df, n) result(res)
! return df * n
type(DataFrame_index_date), intent(in) :: df
integer        , intent(in) :: n
type(DataFrame_index_date)             :: res
res = df
if (allocated(res%values)) res%values = n*res%values
end function mult_df_n

function add_n_df(n, df) result(res)
! return n * df
integer        , intent(in) :: n
type(DataFrame_index_date), intent(in) :: df
type(DataFrame_index_date)             :: res
res = df
if (allocated(res%values)) res%values = n + res%values
end function add_n_df

function add_df_n(df, n) result(res)
! return df * n
type(DataFrame_index_date), intent(in) :: df
integer        , intent(in) :: n
type(DataFrame_index_date)             :: res
res = df
if (allocated(res%values)) res%values = res%values + n
end function add_df_n

function subtract_n_df(n, df) result(res)
! return n - df
integer        , intent(in) :: n
type(DataFrame_index_date), intent(in) :: df
type(DataFrame_index_date)             :: res
res = df
if (allocated(res%values)) res%values = n - res%values
end function subtract_n_df

function subtract_df_n(df, n) result(res)
! return df - n
type(DataFrame_index_date), intent(in) :: df
integer        , intent(in) :: n
type(DataFrame_index_date)             :: res
res = df
if (allocated(res%values)) res%values = res%values - n
end function subtract_df_n

function div_df_n(df, n) result(res)
! return df / n
integer        , intent(in) :: n
type(DataFrame_index_date), intent(in) :: df
type(DataFrame_index_date)             :: res
res = df
if (allocated(res%values)) res%values = res%values/n
end function div_df_n

subroutine require_unique_labels(df, who)
! error stop if df has duplicate index or duplicate column names
type(DataFrame_index_date), intent(in) :: df
character(len=*), intent(in) :: who
character(len=200) :: msg
integer :: i, j

do i = 1, nrow(df) - 1
   do j = i + 1, nrow(df)
      if (df%index(i) == df%index(j)) then
         write(msg, "(a, a)") trim(who), ": duplicate index"
         error stop msg
      end if
   end do
end do

do i = 1, ncol(df) - 1
   do j = i + 1, ncol(df)
      if (trim(df%columns(i)) == trim(df%columns(j))) then
         write(msg, "(a, a)") trim(who), ": duplicate columns"
         error stop msg
      end if
   end do
end do
end subroutine require_unique_labels

integer function find_col_trim(cols, name) result(pos)
! return position of name in cols using trim() equality, or 0 if not found
character(len=*), intent(in) :: cols(:)
character(len=*), intent(in) :: name
integer :: j
pos = 0
do j = 1, size(cols)
   if (trim(cols(j)) == trim(name)) then
      pos = j
      return
   end if
end do
end function find_col_trim

function union_cols(a, b) result(c)
character(len=nlen_columns), intent(in) :: a(:), b(:)
character(len=nlen_columns), allocatable :: c(:)
character(len=nlen_columns), allocatable :: tmp(:)
integer :: n, i
allocate(tmp(size(a) + size(b)))
n = 0
do i = 1, size(a)
   n = n + 1
   tmp(n) = a(i)
end do
do i = 1, size(b)
   if (find_col_trim(tmp(1:n), b(i)) == 0) then
      n = n + 1
      tmp(n) = b(i)
   end if
end do
allocate(c(n))
c = tmp(1:n)
end function union_cols

function intersect_cols(a, b) result(c)
character(len=nlen_columns), intent(in) :: a(:), b(:)
character(len=nlen_columns), allocatable :: c(:)
character(len=nlen_columns), allocatable :: tmp(:)
integer :: n, i
allocate(tmp(size(a)))
n = 0
do i = 1, size(a)
   if (find_col_trim(b, a(i)) /= 0) then
      n = n + 1
      tmp(n) = a(i)
   end if
end do
allocate(c(n))
c = tmp(1:n)
end function intersect_cols

function aligned_binary(self, other, op, how, fill_value) result(res)
! pandas-like aligned arithmetic on union/intersection of index and columns
class(DataFrame_index_date), intent(in) :: self
type(DataFrame_index_date), intent(in)  :: other
character(len=*), intent(in) :: op
character(len=*), intent(in), optional :: how
real(kind=dp), intent(in), optional :: fill_value
type(DataFrame_index_date) :: res

character(len=20) :: how0
type(date), allocatable :: idx_out(:)
character(len=nlen_columns), allocatable :: col_out(:)
real(kind=dp), allocatable :: a(:,:), b(:,:)
real(kind=dp) :: fill
logical :: do_fill
integer :: i, j, ii, jj, n1, n2
real(kind=dp) :: x

call require_unique_labels(self, "aligned_binary self")
call require_unique_labels(other, "aligned_binary other")

how0 = trim(default("outer", how))
select case (how0)
case ("outer")
   idx_out = union_index(self%index, other%index)
   col_out = union_cols(self%columns, other%columns)
case ("inner")
   idx_out = intersect_index(self%index, other%index)
   col_out = intersect_cols(self%columns, other%columns)
case ("left")
   idx_out = self%index
   col_out = self%columns
case ("right")
   idx_out = other%index
   col_out = other%columns
case default
   error stop "aligned_binary: how must be outer/inner/left/right"
end select

n1 = size(idx_out)
n2 = size(col_out)

do_fill = present(fill_value)
if (do_fill) then
   fill = fill_value
else
   fill = ieee_value(0.0_dp, ieee_quiet_nan)
end if

allocate(a(n1, n2), b(n1, n2))
a = fill
b = fill

! place self values into aligned array
do i = 1, nrow(self)
   ii = findloc_index(idx_out, self%index(i))
   if (ii <= 0) cycle
   do j = 1, ncol(self)
      jj = find_col_trim(col_out, self%columns(j))
      if (jj <= 0) cycle
      x = self%values(i, j)
      if (do_fill) then
         if (ieee_is_nan(x)) x = fill
      end if
      a(ii, jj) = x
   end do
end do

! place other values into aligned array
do i = 1, nrow(other)
   ii = findloc_index(idx_out, other%index(i))
   if (ii <= 0) cycle
   do j = 1, ncol(other)
      jj = find_col_trim(col_out, other%columns(j))
      if (jj <= 0) cycle
      x = other%values(i, j)
      if (do_fill) then
         if (ieee_is_nan(x)) x = fill
      end if
      b(ii, jj) = x
   end do
end do

allocate(res%index(n1), res%columns(n2), res%values(n1, n2))
res%index = idx_out
res%columns = col_out

select case (trim(op))
case ("+")
   res%values = a + b
case ("-")
   res%values = a - b
case ("*")
   res%values = a * b
case ("/")
   res%values = a / b
case default
   error stop "aligned_binary: invalid op"
end select
end function aligned_binary

function add(self, other, how, fill_value) result(res)
class(DataFrame_index_date), intent(in) :: self
type(DataFrame_index_date), intent(in) :: other
character(len=*), intent(in), optional :: how
real(kind=dp), intent(in), optional :: fill_value
type(DataFrame_index_date) :: res
res = aligned_binary(self, other, "+", how, fill_value)
end function add

function subtract(self, other, how, fill_value) result(res)
class(DataFrame_index_date), intent(in) :: self
type(DataFrame_index_date), intent(in) :: other
character(len=*), intent(in), optional :: how
real(kind=dp), intent(in), optional :: fill_value
type(DataFrame_index_date) :: res
res = aligned_binary(self, other, "-", how, fill_value)
end function subtract

function multiply(self, other, how, fill_value) result(res)
class(DataFrame_index_date), intent(in) :: self
type(DataFrame_index_date), intent(in) :: other
character(len=*), intent(in), optional :: how
real(kind=dp), intent(in), optional :: fill_value
type(DataFrame_index_date) :: res
res = aligned_binary(self, other, "*", how, fill_value)
end function multiply

function divide(self, other, how, fill_value) result(res)
class(DataFrame_index_date), intent(in) :: self
type(DataFrame_index_date), intent(in) :: other
character(len=*), intent(in), optional :: how
real(kind=dp), intent(in), optional :: fill_value
type(DataFrame_index_date) :: res
res = aligned_binary(self, other, "/", how, fill_value)
end function divide


pure function shift(self, periods, fill_value) result(df_new)
! shift the values by 'periods' rows (positive periods shifts down).
class(DataFrame_index_date), intent(in) :: self
integer, intent(in), optional :: periods
real(kind=dp), intent(in), optional :: fill_value
type(DataFrame_index_date) :: df_new
integer :: p, k, nr, nc
real(kind=dp) :: fill

p = default(1, periods)
fill = default(ieee_value(0.0_dp, ieee_quiet_nan), fill_value)

df_new = self
nr = nrow(self)
nc = ncol(self)
if (nr <= 0 .or. nc <= 0) return

df_new%values = fill
if (p == 0) then
   df_new%values = self%values
else if (p > 0) then
   if (p < nr) df_new%values(p+1:nr,:) = self%values(1:nr-p,:)
else
   k = -p
   if (k < nr) df_new%values(1:nr-k,:) = self%values(k+1:nr,:)
end if
end function shift

pure function pct_change(self, periods, dropna) result(df_new)
! percent change (simple return) over 'periods' rows.
! If dropna=.true., the first 'periods' NaN rows are dropped from the result.
class(DataFrame_index_date), intent(in) :: self
integer, intent(in), optional :: periods
logical, intent(in), optional :: dropna
type(DataFrame_index_date) :: df_new
type(DataFrame_index_date) :: lag
integer :: p, nr, nc
logical :: drop

p    = default(1, periods)
drop = .false.
if (present(dropna)) drop = dropna
lag  = self%shift(p)  ! default fill is NaN

nr = nrow(self)
nc = ncol(self)
df_new%columns = self%columns
if (drop) then
   df_new%index = self%index(p+1:nr)
   allocate(df_new%values(nr - p, nc))
   if (nr > p .and. nc > 0) &
      df_new%values = self%values(p+1:nr,:) / lag%values(p+1:nr,:) - 1.0_dp
else
   df_new%index = self%index
   allocate(df_new%values(nr, nc))
   if (nr == 0 .or. nc == 0) return
   df_new%values = self%values/lag%values - 1.0_dp
end if
end function pct_change

pure function log_change(self, periods, dropna) result(df_new)
! log change (log return) over 'periods' rows: ln(x(t)/x(t-periods)).
! If dropna=.true., the first 'periods' NaN rows are dropped from the result.
class(DataFrame_index_date), intent(in) :: self
integer, intent(in), optional :: periods
logical, intent(in), optional :: dropna
type(DataFrame_index_date) :: df_new
type(DataFrame_index_date) :: lag
integer :: p, nr, nc, nr_out, i0
real(kind=dp), allocatable :: ratio(:,:)
real(kind=dp) :: nan
logical :: drop

p    = default(1, periods)
drop = .false.
if (present(dropna)) drop = dropna
lag  = self%shift(p)  ! default fill is NaN

nr     = nrow(self)
nc     = ncol(self)
nan    = ieee_value(0.0_dp, ieee_quiet_nan)
df_new%columns = self%columns
if (drop) then
   i0    = p + 1
   nr_out = nr - p
   df_new%index = self%index(i0:nr)
   allocate(df_new%values(nr_out, nc))
   df_new%values = nan
   if (nr_out > 0 .and. nc > 0) then
      allocate(ratio(nr_out, nc))
      ratio = self%values(i0:nr,:) / lag%values(i0:nr,:)
      where (ratio > 0.0_dp .and. .not. ieee_is_nan(ratio))
         df_new%values = log(ratio)
      end where
   end if
else
   df_new%index = self%index
   allocate(df_new%values(nr, nc))
   df_new%values = nan
   if (nr == 0 .or. nc == 0) return
   allocate(ratio(nr, nc))
   ratio = self%values/lag%values
   where (ratio > 0.0_dp .and. .not. ieee_is_nan(ratio))
      df_new%values = log(ratio)
   end where
end if
end function log_change

pure function reindex(self, new_index, method, fill_value) result(df_new)
! return a dataframe with index replaced by new_index and values reindexed.
! method can be: "none" (exact), "ffill" (forward fill), "bfill" (back fill).
class(DataFrame_index_date), intent(in) :: self
type(date), intent(in) :: new_index(:)
character(len=*), intent(in), optional :: method
real(kind=dp), intent(in), optional :: fill_value
type(DataFrame_index_date) :: df_new
character(len=10) :: method_
integer :: i, j, nr_old, nc, pos
real(kind=dp) :: fill
logical :: old_sorted

method_ = "none"
if (present(method)) method_ = adjustl(method)
fill = default(ieee_value(0.0_dp, ieee_quiet_nan), fill_value)

nr_old = nrow(self)
nc = ncol(self)

df_new%index = new_index
df_new%columns = self%columns
allocate(df_new%values(size(new_index), nc))
df_new%values = fill
if (size(new_index) == 0 .or. nc == 0) return
if (nr_old == 0) return

old_sorted = is_sorted_index_array(self%index, ascending=.true.)

do i = 1, size(new_index)
   select case (trim(method_))
   case ("none")
      if (old_sorted) then
         pos = bsearch_exact_index(self%index, new_index(i))
      else
         pos = findloc_index(self%index, new_index(i))
      end if
   case ("ffill")
      if (old_sorted) then
         pos = bsearch_ffill_index(self%index, new_index(i))
      else
         pos = 0
         do j=1,nr_old
            if (self%index(j) <= new_index(i)) then
               if (pos == 0 .or. self%index(j) > self%index(pos)) pos = j
            end if
         end do
      end if
   case ("bfill")
      if (old_sorted) then
         pos = bsearch_bfill_index(self%index, new_index(i))
      else
         pos = 0
         do j=1,nr_old
            if (self%index(j) >= new_index(i)) then
               if (pos == 0 .or. self%index(j) < self%index(pos)) pos = j
            end if
         end do
      end if
   case default
      error stop "in reindex, invalid method"
   end select
   if (pos > 0) df_new%values(i,:) = self%values(pos,:)
end do
end function reindex


subroutine require_same_df(df0, df1, who)
type(DataFrame_index_date), intent(in) :: df0, df1
character(len=*), intent(in) :: who
character(len=200) :: msg
integer :: j
if (nrow(df0) /= nrow(df1)) then
   write(msg,'("in ",a,", nrow mismatch")') trim(who)
   error stop msg
end if
if (ncol(df0) /= ncol(df1)) then
   write(msg,'("in ",a,", ncol mismatch")') trim(who)
   error stop msg
end if
if (any(df0%index /= df1%index)) then
   write(msg,'("in ",a,", index mismatch")') trim(who)
   error stop msg
end if
do j=1,ncol(df0)
   if (trim(df0%columns(j)) /= trim(df1%columns(j))) then
      write(msg,'("in ",a,", columns mismatch")') trim(who)
      error stop msg
   end if
end do
end subroutine require_same_df

function add_df_df(df0, df1) result(res)
type(DataFrame_index_date), intent(in) :: df0
type(DataFrame_index_date), intent(in) :: df1
type(DataFrame_index_date)             :: res
call require_same_df(df0, df1, "add_df_df")
res = df0
if (allocated(res%values)) res%values = df0%values + df1%values
end function add_df_df

function subtract_df_df(df0, df1) result(res)
type(DataFrame_index_date), intent(in) :: df0
type(DataFrame_index_date), intent(in) :: df1
type(DataFrame_index_date)             :: res
call require_same_df(df0, df1, "subtract_df_df")
res = df0
if (allocated(res%values)) res%values = df0%values - df1%values
end function subtract_df_df

function mult_df_df(df0, df1) result(res)
type(DataFrame_index_date), intent(in) :: df0
type(DataFrame_index_date), intent(in) :: df1
type(DataFrame_index_date)             :: res
call require_same_df(df0, df1, "mult_df_df")
res = df0
if (allocated(res%values)) res%values = df0%values * df1%values
end function mult_df_df

function div_df_df(df0, df1) result(res)
type(DataFrame_index_date), intent(in) :: df0
type(DataFrame_index_date), intent(in) :: df1
type(DataFrame_index_date)             :: res
call require_same_df(df0, df1, "div_df_df")
res = df0
if (allocated(res%values)) res%values = df0%values / df1%values
end function div_df_df



elemental function power_df_n(df, n) result(res)
! return df**n element-wise
integer        , intent(in) :: n
type(DataFrame_index_date), intent(in) :: df
type(DataFrame_index_date)             :: res
res = df
if (allocated(res%values)) res%values = res%values**n
end function power_df_n

elemental function power_df_x(df, x) result(res)
! return df**x element-wise
real(kind=dp), intent(in)   :: x
type(DataFrame_index_date), intent(in) :: df
type(DataFrame_index_date)             :: res
res = df
if (allocated(res%values)) res%values = res%values**x
end function power_df_x

elemental function subset_stride(df, stride) result(df_new)
type(DataFrame_index_date), intent(in) :: df
integer, intent(in) :: stride
type(DataFrame_index_date) :: df_new
! print*,"df%index(1:nrow(df):stride)", df%index(1:nrow(df):stride)
! print*,"df%values(1:nrow(df):stride, :)", df%values(1:nrow(df):stride, :)
! in the line below, some parentheses are added to work around
! compiler bugs
if (stride == 0) error stop "in subset_stride, stride must nost equal 0"
df_new = DataFrame_index_date(index=(df%index(1:nrow(df):stride)), &
   columns=df%columns, values = (df%values(1:nrow(df):stride, :)))
end function subset_stride
end module dataframe_index_date_mod
! ---- end dataframe_index_date.f90 ----

! ---- begin io_utils.f90 ----
module io_utils_mod
    use kind_mod, only: dp
    use basic_stats_mod, only: mean, cov_mat, biased_cov_sd
    use util_mod, only: sort_int, cumul_sum
    use pca_jacobi_mod, only: principal_components_cov
    use dataframe_index_date_mod, only: DataFrame_index_date, nrow
    implicit none
    public :: print_true_params, print_model_selection, print_estimated_parameters, &
              print_estimated_parameters_dates, print_corrmat_segment, print_corrmat_diff, &
              corrmat_model_range, print_corrmat_model, keep_obs, &
              print_univar_segments, print_return_segments, print_covmat_model, &
              print_pca_loadings, print_lower_corr_sd, print_covmat_segment

contains

    !> Prints the true simulation parameters and empirical correlations for segments.
    subroutine print_true_params(true_cps, corr_true, x, y)
        integer, intent(in) :: true_cps(:)        ! Changepoint locations
        real(kind=dp), intent(in) :: corr_true(:) ! True correlation per segment
        real(kind=dp), intent(in) :: x(:), y(:)   ! Input series (n)
        integer :: n, k, nseg_true, seg_start_true, seg_end_true
        real(kind=dp) :: r_est

        if (size(x) /= size(y)) &
            error stop "print_true_params: size(x) /= size(y)"
        if (size(corr_true) /= size(true_cps) + 1) &
            error stop "print_true_params: size(corr_true) /= size(true_cps) + 1"

        n = size(x)
        nseg_true = size(corr_true)
        print "(a)", "TRUE PARAMETERS"
        print "(a10,a10,a15,a15)", "Start", "End", "Corr_true", "Corr_sim"
        seg_start_true = 1
        do k = 1, nseg_true
            if (k < nseg_true) then
                seg_end_true = true_cps(k)
            else
                seg_end_true = n
            end if
            r_est = sum((x(seg_start_true:seg_end_true)-mean(x(seg_start_true:seg_end_true)))*(y(seg_start_true:seg_end_true)-mean(y(seg_start_true:seg_end_true)))) / &
                    (sqrt(sum((x(seg_start_true:seg_end_true)-mean(x(seg_start_true:seg_end_true)))**2) * sum((y(seg_start_true:seg_end_true)-mean(y(seg_start_true:seg_end_true)))**2)))
            print "(i10,i10,f15.4,f15.4)", seg_start_true, seg_end_true, corr_true(k), r_est
            seg_start_true = seg_end_true + 1
        end do
    end subroutine print_true_params

    !> Prints AIC/BIC statistics for different numbers of segments.
    subroutine print_model_selection(dp_table, parent, best_aic_cp, best_bic_cp, params_per_seg, &
        print_each)
        real(kind=dp), intent(in) :: dp_table(:, :) ! Dynamic programming table of costs (n, max_m)
        integer, intent(in) :: parent(:, :)        ! DP parent pointers (n, max_m)
        integer, intent(out), optional :: best_aic_cp  ! # changepoints chosen by AIC
        integer, intent(out), optional :: best_bic_cp  ! # changepoints chosen by BIC
        integer, intent(in), optional :: params_per_seg ! parameters per segment (default 2)
        logical, intent(in), optional :: print_each
        logical                       :: print_each_
        ! params_per_seg=2: correlation model  → k = 2*m-1 (1 rho/seg + 1 location/break)
        ! params_per_seg=3: mean-shift model   → k = 3*m-1 (mu+sigma^2/seg + 1 location/break)
        integer :: n, max_m, m, cp, k, k_params, pps
        real(kind=dp) :: ll, aic(size(dp_table, 2)), bic(size(dp_table, 2))
        integer :: cps(size(dp_table, 2))
        integer :: best_m_aic, best_m_bic
        real(kind=dp) :: min_aic, min_bic
        print_each_ = .true.
        if (present(print_each)) print_each_ = print_each
        pps = 2
        if (present(params_per_seg)) pps = params_per_seg

        if (any(shape(dp_table) /= shape(parent))) &
            error stop "print_model_selection: dp_table and parent shapes are incompatible"

        n = size(dp_table, 1)
        max_m = size(dp_table, 2)

        if (print_each_) print "(/,a)", "   M      LL         AIC         BIC    ChangePoints"
        do m = 1, max_m
            if (dp_table(n, m) >= 1.0e19_dp) then
                aic(m) = 1.0e20_dp
                bic(m) = 1.0e20_dp
                cycle
            end if
            ll = -dp_table(n, m)
            k_params = pps * m - 1
            aic(m) = -2.0_dp*ll + 2.0_dp * k_params
            bic(m) = -2.0_dp*ll + real(k_params, dp) * log(real(n, dp))

            if (print_each_) write(*, "(i4, 3f12.2, 4x)", advance='no') &
               m, ll, aic(m), bic(m)
            cp = n
            cps(m) = n
            do k = m, 2, -1
                cps(k-1) = parent(cp, k)
                cp = cps(k-1)
            end do
            if (m > 1) call sort_int(cps(1:m-1))
            if (print_each_) then
               do k = 1, m-1
                  write(*, "(i0, ' ')", advance='no') cps(k)
               end do
               print *
            end if
        end do
        
        min_aic = 1.0e20_dp
        min_bic = 1.0e20_dp
        best_m_aic = 1
        best_m_bic = 1
        do m = 1, max_m
            if (aic(m) < min_aic) then
                min_aic = aic(m)
                best_m_aic = m
            end if
            if (bic(m) < min_bic) then
                min_bic = bic(m)
                best_m_bic = m
            end if
        end do
        print "(/,a,2(1x,i0),/)", "Changepoints chosen by AIC, BIC:", best_m_aic - 1, best_m_bic - 1
        if (present(best_aic_cp)) best_aic_cp = best_m_aic - 1
        if (present(best_bic_cp)) best_bic_cp = best_m_bic - 1
    end subroutine print_model_selection

    !> Prints the estimated parameters (breakpoints and correlations) for each model using indices.
    subroutine print_estimated_parameters(max_m, parent, x, y)
        integer, intent(in) :: max_m              ! Max changepoints
        integer, intent(in) :: parent(:, :)       ! DP parent pointers
        real(kind=dp), intent(in) :: x(:), y(:)   ! Input series
        integer :: n, m, cp, k, seg_start, seg_end
        integer :: cps(max_m)
        real(kind=dp) :: r_est

        if (size(x) /= size(y)) &
            error stop "print_estimated_parameters: size(x) /= size(y)"

        n = size(parent, 1)
        do m = 1, max_m
            ! Reconstruct and sort
            cp = n
            cps(m) = n
            do k = m, 2, -1
                cps(k-1) = parent(cp, k)
                cp = cps(k-1)
            end do
            if (m > 1) call sort_int(cps(1:m-1))

            print "(a,i2)", "estimated parameters for m =", m
            print "(a10,a10,a10)", "Start", "End", "Corr"
            seg_start = 1
            do k = 1, m
                if (k == m) then
                    seg_end = n
                else
                    seg_end = cps(k)
                end if
                r_est = sum((x(seg_start:seg_end)-mean(x(seg_start:seg_end)))*(y(seg_start:seg_end)-mean(y(seg_start:seg_end)))) / &
                        (sqrt(sum((x(seg_start:seg_end)-mean(x(seg_start:seg_end)))**2) * sum((y(seg_start:seg_end)-mean(y(seg_start:seg_end)))**2)))
                print "(i10,i10,f10.4)", seg_start, seg_end, r_est
                seg_start = seg_end + 1
            end do
            print *
        end do
    end subroutine print_estimated_parameters

    !> Prints the estimated parameters (breakpoints and correlations) for each model using date labels.
    subroutine print_estimated_parameters_dates(max_m, parent, x, y, dates)
        integer, intent(in) :: max_m              ! Max changepoints
        integer, intent(in) :: parent(:, :)       ! DP parent pointers
        real(kind=dp), intent(in) :: x(:), y(:)   ! Input series
        character(len=*), intent(in) :: dates(:)  ! Date labels
        integer :: n, m, cp, k, seg_start, seg_end
        integer :: cps(max_m)
        real(kind=dp) :: r_est, mx, my, sdx, sdy, covar
        real(kind=dp), allocatable :: x_seg(:), y_seg(:)

        if (size(x) /= size(y)) &
            error stop "print_estimated_parameters_dates: size(x) /= size(y)"

        n = size(parent, 1)
        allocate(x_seg(n), y_seg(n))
        do m = 1, max_m
            ! Reconstruct and sort
            cp = n
            cps(m) = n
            do k = m, 2, -1
                cps(k-1) = parent(cp, k)
                cp = cps(k-1)
            end do
            if (m > 1) call sort_int(cps(1:m-1))

            print "(a,i2)", "estimated parameters for m =", m
            print "(a12,a12,a10,a10,a10,a10,a10,a10,a10)", "Start", "End", "#obs", "Corr", "Covar", "sd_x", "sd_y", "mean_x", "mean_y"
            seg_start = 1
            do k = 1, m
                if (k == m) then
                    seg_end = n
                else
                    seg_end = cps(k)
                end if
                
                ! Extract segment
                x_seg(1:seg_end-seg_start+1) = x(seg_start:seg_end)
                y_seg(1:seg_end-seg_start+1) = y(seg_start:seg_end)
                mx = mean(x_seg(1:seg_end-seg_start+1))
                my = mean(y_seg(1:seg_end-seg_start+1))
                sdx = sqrt(sum((x_seg(1:seg_end-seg_start+1)-mx)**2) / max(1, (seg_end-seg_start)))
                sdy = sqrt(sum((y_seg(1:seg_end-seg_start+1)-my)**2) / max(1, (seg_end-seg_start)))
                covar = sum((x_seg(1:seg_end-seg_start+1)-mx)*(y_seg(1:seg_end-seg_start+1)-my)) / max(1, (seg_end-seg_start))
                r_est = covar / (sdx * sdy)
                
                ! r_est, covar, sdx, sdy, mx, my
                print "(a12,a12,i10,f10.4,5f10.4)", dates(seg_start), dates(seg_end), seg_end - seg_start + 1, r_est, covar, sdx, sdy, mx, my

                seg_start = seg_end + 1
            end do
            print *
        end do
        deallocate(x_seg, y_seg)
    end subroutine print_estimated_parameters_dates
    !> Prints correlation matrix (lower triangle), annualised std devs, and
    !! annualised arithmetic returns for one segment of a corrmat changepoint model.
    subroutine print_corrmat_segment(k, i0, i1, R, col_names, dates, p, scale_ret, in_sd, in_mu, do_pca_cov, do_pca_corr)
        integer,          intent(in)           :: k, i0, i1, p
        real(kind=dp),    intent(in)           :: R(:,:)
        character(len=*), intent(in)           :: col_names(:), dates(:)
        real(kind=dp),    intent(in)           :: scale_ret
        real(kind=dp),    intent(in), optional :: in_sd(:), in_mu(:)
        logical,          intent(in), optional :: do_pca_cov, do_pca_corr
        integer       :: a, b, m
        real(kind=dp) :: mu(p), sd(p), cov_ab, r_ab
        real(kind=dp) :: S(p, p), C(p, p), sd_s(p)
        real(kind=dp), parameter :: ann = 15.87401_dp  ! sqrt(252), daily → annual

        m = i1 - i0 + 1
        print "(/,'Segment ',i0,': ',a,' to ',a,' (',i0,' obs)')", &
            k, trim(dates(i0)), trim(dates(i1)), m

        if (present(in_sd) .and. present(in_mu)) then
            sd = in_sd
            mu = in_mu
        else
            do a = 1, p
                mu(a) = sum(R(i0:i1, a)) / m
                sd(a) = sqrt(max(sum((R(i0:i1,a) - mu(a))**2) / m, 0.0_dp))
            end do
        end if

        print "(a)", "  Correlation:"
        write (*, "(8x)", advance="no")
        do a = 1, p
            write (*, "(a8)", advance="no") trim(col_names(a))
        end do
        print *
        do a = 1, p
            write (*, "(4x,a4)", advance="no") trim(col_names(a))
            do b = 1, a
                if (sd(a) > 0.0_dp .and. sd(b) > 0.0_dp) then
                    cov_ab = sum((R(i0:i1,a) - mu(a)) * (R(i0:i1,b) - mu(b))) / m
                    r_ab   = cov_ab / (sd(a) * sd(b))
                else
                    r_ab = 0.0_dp
                end if
                write (*, "(f8.3)", advance="no") r_ab
            end do
            print *
        end do

        write (*, "(4x,a4,*(f8.3))") "*SD*",  sd * ann / scale_ret
        write (*, "(3x,a5,*(f8.3))") "*RET*", mu * 252 / scale_ret

        if ((present(do_pca_cov) .and. do_pca_cov) .or. &
            (present(do_pca_corr) .and. do_pca_corr)) then
            call biased_cov_sd(R(i0:i1, :), S, sd_s)
            if (present(do_pca_cov) .and. do_pca_cov) &
                call print_pca_loadings(S, col_names, "PCA of covariance matrix")
            if (present(do_pca_corr) .and. do_pca_corr) then
                do a = 1, p
                    do b = 1, p
                        if (sd_s(a) > 0.0_dp .and. sd_s(b) > 0.0_dp) then
                            C(a,b) = S(a,b) / (sd_s(a) * sd_s(b))
                        else
                            C(a,b) = merge(1.0_dp, 0.0_dp, a == b)
                        end if
                    end do
                end do
                call print_pca_loadings(C, col_names, "PCA of correlation matrix")
            end if
        end if
    end subroutine print_corrmat_segment

    !> For each pair of assets, tests whether the correlation changed significantly
    !! between two segments using the Fisher z-test with Bonferroni correction.
    !! Only pairs that are significant after correction are printed.
    !!
    !! H0: rho1 = rho2.  Test statistic: (atanh(r1)-atanh(r2)) / sqrt(1/(n1-3)+1/(n2-3))
    !! Two-sided p-value via erfc.  Bonferroni threshold: alpha / (p*(p-1)/2).
    subroutine print_corrmat_diff(i0a, i1a, i0b, i1b, R, col_names, alpha, sd1, mu1, sd2, mu2, scale_ret)
        integer,          intent(in) :: i0a, i1a, i0b, i1b
        real(kind=dp),    intent(in) :: R(:,:)
        character(len=*), intent(in) :: col_names(:)
        real(kind=dp),    intent(in) :: alpha, scale_ret
        real(kind=dp),    intent(in) :: sd1(:), mu1(:), sd2(:), mu2(:)

        integer       :: p, ia, ib, na, nb, npairs, nsig, k
        real(kind=dp) :: r1, r2, z1, z2, se, stat, p_val, thresh
        real(kind=dp), parameter :: r_clamp = 1.0_dp - 1.0e-10_dp
        real(kind=dp), parameter :: ann = 15.87401_dp  ! sqrt(252), daily → annual
        integer,       allocatable :: sig_ia(:), sig_ib(:)
        real(kind=dp), allocatable :: sig_r1(:), sig_r2(:), sig_stat(:), sig_pval(:)
        character(len=11) :: pair_str

        p      = size(col_names)
        na     = i1a - i0a + 1
        nb     = i1b - i0b + 1
        npairs = p * (p - 1) / 2
        thresh = alpha / npairs

        allocate(sig_ia(npairs), sig_ib(npairs), &
                 sig_r1(npairs), sig_r2(npairs), sig_stat(npairs), sig_pval(npairs))

        nsig = 0
        do ia = 1, p
            do ib = ia + 1, p
                if (sd1(ia) > 0.0_dp .and. sd1(ib) > 0.0_dp) then
                    r1 = sum((R(i0a:i1a,ia)-mu1(ia)) * (R(i0a:i1a,ib)-mu1(ib))) &
                         / (na * sd1(ia) * sd1(ib))
                else
                    r1 = 0.0_dp
                end if
                if (sd2(ia) > 0.0_dp .and. sd2(ib) > 0.0_dp) then
                    r2 = sum((R(i0b:i1b,ia)-mu2(ia)) * (R(i0b:i1b,ib)-mu2(ib))) &
                         / (nb * sd2(ia) * sd2(ib))
                else
                    r2 = 0.0_dp
                end if
                r1    = max(-r_clamp, min(r_clamp, r1))
                r2    = max(-r_clamp, min(r_clamp, r2))
                z1    = atanh(r1)
                z2    = atanh(r2)
                se    = sqrt(1.0_dp/(na - 3) + 1.0_dp/(nb - 3))
                stat  = (z1 - z2) / se
                p_val = erfc(abs(stat) / sqrt(2.0_dp))
                if (p_val < thresh) then
                    nsig = nsig + 1
                    sig_ia(nsig)   = ia
                    sig_ib(nsig)   = ib
                    sig_r1(nsig)   = r1
                    sig_r2(nsig)   = r2
                    sig_stat(nsig) = stat
                    sig_pval(nsig) = p_val
                end if
            end do
        end do

        if (nsig > 0) then
            print "('  Sig. corr. changes (Bonferroni adj. alpha=',f6.4,'): ',i0,'/',i0,' = ',f5.3)", &
                thresh, nsig, npairs, real(nsig, dp) / npairs
            print "(4x, a11, 4a8, a9, 8a7)", "Pair       ", "r1", "r2", "r1-r2", "z", "p", &
                "sd_x1", "sd_x2", "sd_y1", "sd_y2", "ret_x1", "ret_x2", "ret_y1", "ret_y2"
            do k = 1, nsig
                pair_str = trim(col_names(sig_ia(k))) // "-" // trim(col_names(sig_ib(k)))
                print "(4x, a11, 4f8.3, f9.6, 8f7.3)", pair_str, &
                    sig_r1(k), sig_r2(k), sig_r1(k) - sig_r2(k), sig_stat(k), sig_pval(k), &
                    sd1(sig_ia(k)) * ann / scale_ret, sd2(sig_ia(k)) * ann / scale_ret, &
                    sd1(sig_ib(k)) * ann / scale_ret, sd2(sig_ib(k)) * ann / scale_ret, &
                    mu1(sig_ia(k)) * 252 / scale_ret, mu2(sig_ia(k)) * 252 / scale_ret, &
                    mu1(sig_ib(k)) * 252 / scale_ret, mu2(sig_ib(k)) * 252 / scale_ret
            end do
        end if

        deallocate(sig_ia, sig_ib, sig_r1, sig_r2, sig_stat, sig_pval)
    end subroutine print_corrmat_diff

    subroutine print_corrmat_model(best_bic, seg_ends, R, col_names, ret_dates, &
                                   scale_ret, print_diffs, alpha_diff, do_pca_cov, do_pca_corr)
        !> Print the correlation structure for one changepoint model.
        !! Pre-computes segment means and std devs once and passes them to
        !! print_corrmat_segment and print_corrmat_diff to avoid recomputation.
        integer,          intent(in)           :: best_bic, seg_ends(:)
        real(kind=dp),    intent(in)           :: R(:,:)
        character(len=*), intent(in)           :: col_names(:), ret_dates(:)
        real(kind=dp),    intent(in)           :: scale_ret, alpha_diff
        logical,          intent(in)           :: print_diffs
        logical,          intent(in), optional :: do_pca_cov, do_pca_corr
        integer :: m_segs, n_col, k, seg_start, m_k, a
        real(kind=dp), allocatable :: seg_mu(:,:), seg_sd(:,:)

        m_segs = size(seg_ends)
        n_col  = size(col_names)

        if (m_segs - 1 == best_bic) then
            print "(/,'Correlation structure: ',i0,' changepoint',a,' (',i0,' segment',a,') [BIC]')", &
                m_segs-1, merge("s"," ", m_segs-1 /= 1), m_segs, merge("s"," ", m_segs /= 1)
        else
            print "(/,'Correlation structure: ',i0,' changepoint',a,' (',i0,' segment',a,')')", &
                m_segs-1, merge("s"," ", m_segs-1 /= 1), m_segs, merge("s"," ", m_segs /= 1)
        end if

        allocate(seg_mu(n_col, m_segs), seg_sd(n_col, m_segs))
        seg_start = 1
        do k = 1, m_segs
            m_k = seg_ends(k) - seg_start + 1
            do a = 1, n_col
                seg_mu(a, k) = sum(R(seg_start:seg_ends(k), a)) / m_k
                seg_sd(a, k) = sqrt(max(sum((R(seg_start:seg_ends(k), a) - seg_mu(a,k))**2) / m_k, 0.0_dp))
            end do
            seg_start = seg_ends(k) + 1
        end do

        seg_start = 1
        do k = 1, m_segs
            call print_corrmat_segment(k, seg_start, seg_ends(k), R, col_names, ret_dates, n_col, &
                                       scale_ret, in_sd=seg_sd(:,k), in_mu=seg_mu(:,k), &
                                       do_pca_cov=do_pca_cov, do_pca_corr=do_pca_corr)
            if (print_diffs .and. k < m_segs) &
                call print_corrmat_diff(seg_start, seg_ends(k), seg_ends(k)+1, seg_ends(k+1), &
                                        R, col_names, alpha_diff, &
                                        seg_sd(:,k), seg_mu(:,k), seg_sd(:,k+1), seg_mu(:,k+1), scale_ret)
            seg_start = seg_ends(k) + 1
        end do
        deallocate(seg_mu, seg_sd)
    end subroutine print_corrmat_model

    pure elemental subroutine corrmat_model_range(print_segs, best_bic, max_m, m_lo, m_hi)
        !> Maps the print_segs control parameter to a range [m_lo, m_hi] of segment
        !! counts to display: 0 = BIC-chosen only, 1 = 0 through BIC, 2 = all studied.
        integer, intent(in)  :: print_segs, best_bic, max_m
        integer, intent(out) :: m_lo, m_hi
        select case (print_segs)
        case (1)
            m_lo = 1
            m_hi = best_bic + 1
        case (2)
            m_lo = 1
            m_hi = max_m
        case default  ! 0: BIC only
            m_lo = best_bic + 1
            m_hi = best_bic + 1
        end select
    end subroutine corrmat_model_range

    subroutine keep_obs(df, max_days, latest, verbose)
        !> Keep at most max_days rows of df; print the range used if verbose is present and true.
        type(DataFrame_index_date), intent(in out) :: df
        integer, intent(in) :: max_days
        logical, intent(in) :: latest
        logical, intent(in), optional :: verbose
        df = df%keep_rows(max_days + 1, latest=latest)
        if (present(verbose)) then
            if (verbose) print "('using ',a,' ',i0,' values (',a,' to ',a,')')", &
                merge("latest  ", "earliest", latest), nrow(df) - 1, &
                trim(df%index(2)%to_str()), trim(df%index(nrow(df))%to_str())
        end if
    end subroutine keep_obs

    subroutine print_univar_segments(best_bic, seg_ends, z, series_name, ret_dates)
        !> Print segment statistics (mean, sd, min, max, first, last) for a univariate series z.
        integer, intent(in)          :: best_bic, seg_ends(:)
        real(kind=dp), intent(in)    :: z(:)
        character(len=*), intent(in) :: series_name, ret_dates(:)
        integer :: ms, k, i0, i1, nseg
        real(kind=dp) :: zmean, zsd
        ms = size(seg_ends)
        if (ms == best_bic + 1) then
            print "(/,'BIC-selected model (',i0,' changepoint(s)) -- ',a)", best_bic, series_name
        else
            print "(/,'model (',i0,' changepoint(s)) -- ',a)", ms - 1, series_name
        end if
        print "(a12,a12,a8,6a12)", "start", "end", "n", "mean", "sd", "min", "max", "first", "last"
        i0 = 1
        do k = 1, ms
            i1 = seg_ends(k)
            nseg = i1 - i0 + 1
            zmean = sum(z(i0:i1)) / nseg
            if (nseg > 1) then
                zsd = sqrt(sum((z(i0:i1) - zmean)**2) / (nseg - 1))
            else
                zsd = 0.0_dp
            end if
            print "(a12,a12,i8,6f12.4)", ret_dates(i0), ret_dates(i1), nseg, &
                zmean, zsd, minval(z(i0:i1)), maxval(z(i0:i1)), z(i0), z(i1)
            i0 = i1 + 1
        end do
    end subroutine print_univar_segments

    subroutine print_return_segments(best_bic, seg_ends, r, series_name, ret_dates, scale_ret)
        !> Print annualised return and volatility for each segment of a variance
        !! changepoint model.  r(:) are the raw (scaled) returns for one asset.
        !! Annualised return  = mean(r) * 252 / scale_ret
        !! Annualised vol     = sqrt(mean(r^2) * 252) / scale_ret
        integer,          intent(in) :: best_bic, seg_ends(:)
        real(kind=dp),    intent(in) :: r(:), scale_ret
        character(len=*), intent(in) :: series_name, ret_dates(:)
        real(kind=dp), parameter :: days_per_year = 252.0_dp
        integer       :: ms, k, i0, i1, nseg
        real(kind=dp) :: ann_ret, ann_vol, rmin, rmax, rfirst, rlast, sc
        ms = size(seg_ends)
        sc = 100.0_dp / scale_ret   ! converts stored units to percent
        if (ms == best_bic + 1) then
            print "(/,'BIC-selected model (',i0,' changepoint(s)) -- ',a)", best_bic, series_name
        else
            print "(/,'model (',i0,' changepoint(s)) -- ',a)", ms - 1, series_name
        end if
        ! r is in units of scale_ret (e.g. percent when scale_ret=100)
        ! Divide once by scale_ret to get actual returns, then express as %
        print "(a12,a12,a8,a12,a12,a10,a10,a10,a10)", &
            "start", "end", "n", "ann_ret%", "ann_vol%", "min%", "max%", "first%", "last%"
        i0 = 1
        do k = 1, ms
            i1     = seg_ends(k)
            nseg   = i1 - i0 + 1
            ann_ret = sum(r(i0:i1)) / nseg * days_per_year * sc
            ann_vol = sqrt(sum(r(i0:i1)**2) / nseg * days_per_year) * sc
            rmin   = minval(r(i0:i1)) * sc
            rmax   = maxval(r(i0:i1)) * sc
            rfirst = r(i0) * sc
            rlast  = r(i1) * sc
            print "(a12,a12,i8,2f12.2,4f10.2)", &
                ret_dates(i0), ret_dates(i1), nseg, ann_ret, ann_vol, rmin, rmax, rfirst, rlast
            i0 = i1 + 1
        end do
    end subroutine print_return_segments

    subroutine print_covmat_model(best_bic, seg_ends, R, col_names, ret_dates)
        !> Print annualized covariance matrix (x252) for each segment.
        integer, intent(in)          :: best_bic, seg_ends(:)
        real(kind=dp), intent(in)    :: R(:,:)
        character(len=*), intent(in) :: col_names(:), ret_dates(:)
        real(kind=dp), parameter     :: days_per_year = 252.0_dp
        integer :: ms, k, jc, i0, i1
        real(kind=dp), allocatable :: C(:,:)
        ms = size(seg_ends)
        if (ms == best_bic + 1) then
            print "(/,'BIC-selected model (',i0,' changepoint(s))')", best_bic
        else
            print "(/,'model (',i0,' changepoint(s))')", ms - 1
        end if
        i0 = 1
        do k = 1, ms
            i1 = seg_ends(k)
            print "('segment ',i0,': ',a,' to ',a,' (',i0,' obs)')", &
                k, ret_dates(i0), ret_dates(i1), i1 - i0 + 1
            C = cov_mat(R(i0:i1, :)) * days_per_year
            print "(5x,*(a8,:,1x))", (trim(col_names(jc)), jc=1,size(col_names))
            do jc = 1, size(col_names)
                print "(a8,*(1x,f8.4))", trim(col_names(jc)), C(jc,:)
            end do
            i0 = i1 + 1
        end do
    end subroutine print_covmat_model

    subroutine print_covmat_segment(k, i0, i1, R, col_names, dates, scale_ret, do_pca)
        !> Print one segment of a covariance changepoint model: header, correlation
        !! lower triangle, annualized std devs, and optionally PCA loadings.
        integer,          intent(in) :: k, i0, i1
        real(kind=dp),    intent(in) :: R(:,:)
        character(len=*), intent(in) :: col_names(:), dates(:)
        real(kind=dp),    intent(in) :: scale_ret
        logical,          intent(in) :: do_pca
        real(kind=dp) :: S(size(col_names), size(col_names)), sd(size(col_names))
        print "(/,'Segment ',i0,': ',a,' to ',a,' (',i0,' obs)')", &
            k, trim(dates(i0)), trim(dates(i1)), i1 - i0 + 1
        call biased_cov_sd(R(i0:i1, :), S, sd)
        call print_lower_corr_sd(S, sd, col_names, scale_ret)
        if (do_pca) call print_pca_loadings(S, col_names)
    end subroutine print_covmat_segment

    subroutine print_lower_corr_sd(S, sd, col_names, scale_ret)
        !> Print correlation matrix (lower triangle) derived from covariance matrix S
        !! and standard deviations sd, followed by a row of annualized std devs.
        real(kind=dp),    intent(in) :: S(:,:), sd(:)
        character(len=*), intent(in) :: col_names(:)
        real(kind=dp),    intent(in) :: scale_ret
        real(kind=dp), parameter :: ann = 15.87401_dp  ! sqrt(252), daily -> annual
        integer :: a, b, p
        real(kind=dp) :: r_ab
        p = size(col_names)
        print "(a)", "  Correlation:"
        write(*, "(8x)", advance='no')
        do a = 1, p
            write(*, "(a8)", advance='no') trim(col_names(a))
        end do
        print *
        do a = 1, p
            write(*, "(4x,a4)", advance='no') trim(col_names(a))
            do b = 1, a
                if (sd(a) > 0.0_dp .and. sd(b) > 0.0_dp) then
                    r_ab = S(a,b) / (sd(a) * sd(b))
                else
                    r_ab = 0.0_dp
                end if
                write(*, "(f8.3)", advance='no') r_ab
            end do
            print *
        end do
        write(*, "(4x,a4)", advance='no') '*SD*'
        do a = 1, p
            write(*, "(f8.3)", advance='no') sd(a) * ann / scale_ret
        end do
        print *
    end subroutine print_lower_corr_sd

    subroutine print_pca_loadings(S, col_names, title)
        !> Print principal component loadings, variance explained, and cumulative
        !! variance explained for matrix S with given column labels and optional title.
        real(kind=dp),    intent(in)           :: S(:,:)
        character(len=*), intent(in)           :: col_names(:)
        character(len=*), intent(in), optional :: title
        real(kind=dp), allocatable :: evals(:), evecs(:,:), var_explained(:)
        integer :: a, j, p
        p = size(col_names)
        call principal_components_cov(S, evals, evecs, var_explained)
        if (present(title)) then
            print "(/,a)", "  " // title // ":"
        else
            print "(/,a)", "  Principal component loadings:"
        end if
        write(*, "(a12,*(1x,f12.3))") "  var_exp", var_explained
        write(*, "(a12,*(1x,f12.3))") "  cumul",   cumul_sum(var_explained)
        write(*, "(a12,*(1x,i12))")   "  PC",       (j, j=1,p)
        do a = 1, p
            write(*, "(a12,*(1x,f12.3))") "  " // trim(col_names(a)), evecs(a,:)
        end do
    end subroutine print_pca_loadings

end module io_utils_mod

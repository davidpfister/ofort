module move_alloc_examples_mod
implicit none
contains

subroutine show_int_vector(name, x)
! Print allocation status and contents of an integer vector.
character(len=*), intent(in) :: name
integer, allocatable, intent(in) :: x(:)

if (allocated(x)) then
   print *, trim(name), " allocated, bounds =", lbound(x), ubound(x), " values =", x
else
   print *, trim(name), " not allocated"
end if

end subroutine show_int_vector

subroutine show_real_matrix(name, x)
! Print allocation status, bounds, and contents of a real matrix.
character(len=*), intent(in) :: name
real(kind=kind(1.0d0)), allocatable, intent(in) :: x(:,:)

integer :: i

if (allocated(x)) then
   print *, trim(name), " allocated"
   print *, "  lbound =", lbound(x), " ubound =", ubound(x)
   do i = lbound(x,1), ubound(x,1)
      print *, x(i,:)
   end do
else
   print *, trim(name), " not allocated"
end if

end subroutine show_real_matrix

subroutine test_basic_move()
! Move allocation from one vector to another.
integer, allocatable :: a(:), b(:)

allocate(a(5))
a = [10, 20, 30, 40, 50]

print *
print *, "test_basic_move"
call show_int_vector("a before", a)
call show_int_vector("b before", b)

call move_alloc(a, b)

call show_int_vector("a after ", a)
call show_int_vector("b after ", b)

end subroutine test_basic_move

subroutine test_move_replaces_allocated_to()
! Move allocation to an already allocated vector.
integer, allocatable :: a(:), b(:)

allocate(a(3))
allocate(b(2))

a = [1, 2, 3]
b = [-1, -2]

print *
print *, "test_move_replaces_allocated_to"
call show_int_vector("a before", a)
call show_int_vector("b before", b)

call move_alloc(a, b)

call show_int_vector("a after ", a)
call show_int_vector("b after ", b)

end subroutine test_move_replaces_allocated_to

subroutine test_nonunit_lower_bound()
! Move allocation while preserving nonunit lower bounds.
integer, allocatable :: a(:), b(:)

integer :: i

allocate(a(-2:2))
do i = lbound(a,1), ubound(a,1)
   a(i) = 100 + i
end do

print *
print *, "test_nonunit_lower_bound"
call show_int_vector("a before", a)
call show_int_vector("b before", b)

call move_alloc(a, b)

call show_int_vector("a after ", a)
call show_int_vector("b after ", b)

print *, "b(-2) =", b(-2), " b(0) =", b(0), " b(2) =", b(2)

end subroutine test_nonunit_lower_bound

subroutine test_matrix_move()
! Move allocation of a rank-2 real array.
integer, parameter :: dp = kind(1.0d0)
integer, parameter :: n1 = 2
integer, parameter :: n2 = 3

real(kind=dp), allocatable :: a(:,:), b(:,:)

allocate(a(0:n1-1, -1:n2-2))
a = reshape([ &
   1.0_dp, 2.0_dp, &
   3.0_dp, 4.0_dp, &
   5.0_dp, 6.0_dp  &
   ], shape(a))

print *
print *, "test_matrix_move"
call show_real_matrix("a before", a)
call show_real_matrix("b before", b)

call move_alloc(a, b)

call show_real_matrix("a after ", a)
call show_real_matrix("b after ", b)

print *, "b(0,-1) =", b(0,-1)
print *, "b(1, 1) =", b(1, 1)

end subroutine test_matrix_move

subroutine test_resize_idiom()
! Resize an allocatable vector using a temporary and move_alloc.
integer, allocatable :: a(:), tmp(:)

integer :: nold

allocate(a(3))
a = [11, 22, 33]

print *
print *, "test_resize_idiom"
call show_int_vector("a before resize", a)

nold = size(a)
allocate(tmp(2*nold))
tmp(1:nold) = a
tmp(nold+1:) = 0

call move_alloc(tmp, a)

a(4:6) = [44, 55, 66]

call show_int_vector("tmp after move", tmp)
call show_int_vector("a after resize ", a)

end subroutine test_resize_idiom

subroutine make_vector(n, x)
! Create a vector and return it with move_alloc.
integer, intent(in) :: n
integer, allocatable, intent(out) :: x(:)

integer, allocatable :: tmp(:)
integer :: i

allocate(tmp(n))
do i = 1, n
   tmp(i) = i*i
end do

call move_alloc(tmp, x)

end subroutine make_vector

subroutine test_return_from_subroutine()
! Test move_alloc with an intent(out) allocatable argument.
integer, allocatable :: x(:)

print *
print *, "test_return_from_subroutine"

call make_vector(6, x)
call show_int_vector("x", x)

end subroutine test_return_from_subroutine

subroutine test_move_unallocated_from()
! Move from an unallocated source.
integer, allocatable :: a(:), b(:)

allocate(b(4))
b = [7, 8, 9, 10]

print *
print *, "test_move_unallocated_from"
call show_int_vector("a before", a)
call show_int_vector("b before", b)

call move_alloc(a, b)

call show_int_vector("a after ", a)
call show_int_vector("b after ", b)

end subroutine test_move_unallocated_from

end module move_alloc_examples_mod

program xmove_alloc
use move_alloc_examples_mod, only: test_basic_move, test_move_replaces_allocated_to, &
   test_nonunit_lower_bound, test_matrix_move, test_resize_idiom, &
   test_return_from_subroutine, test_move_unallocated_from
implicit none

call test_basic_move()
call test_move_replaces_allocated_to()
call test_nonunit_lower_bound()
call test_matrix_move()
call test_resize_idiom()
call test_return_from_subroutine()
call test_move_unallocated_from()

end program xmove_alloc

module ofort_binding
  use, intrinsic :: iso_c_binding
  implicit none
  private

  integer, parameter :: ofort_text_buffer_size = 65536

  public :: ofort_interpreter

  type :: ofort_interpreter
     private
     type(c_ptr) :: handle = c_null_ptr
   contains
     procedure :: create => ofort_fortran_create
     procedure :: destroy => ofort_fortran_destroy
     procedure :: reset => ofort_fortran_reset
     procedure :: execute => ofort_fortran_execute
     procedure :: check => ofort_fortran_check
     procedure :: output => ofort_fortran_output
     procedure :: error => ofort_fortran_error
     procedure :: warnings => ofort_fortran_warnings
     procedure :: set_implicit_typing => ofort_fortran_set_implicit_typing
     procedure :: set_warnings_enabled => ofort_fortran_set_warnings_enabled
     procedure :: set_fast_mode => ofort_fortran_set_fast_mode
     procedure :: set_trace_assign => ofort_fortran_set_trace_assign
     final :: ofort_fortran_finalize
  end type ofort_interpreter

  interface
     function ofort_c_create() bind(c) result(p)
       import :: c_ptr
       type(c_ptr) :: p
     end function ofort_c_create

     subroutine ofort_c_destroy(p) bind(c)
       import :: c_ptr
       type(c_ptr), value :: p
     end subroutine ofort_c_destroy

     subroutine ofort_c_reset(p) bind(c)
       import :: c_ptr
       type(c_ptr), value :: p
     end subroutine ofort_c_reset

     function ofort_c_execute(p, source) bind(c) result(rc)
       import :: c_ptr, c_char, c_int
       type(c_ptr), value :: p
       character(kind=c_char), dimension(*), intent(in) :: source
       integer(c_int) :: rc
     end function ofort_c_execute

     function ofort_c_check(p, source) bind(c) result(rc)
       import :: c_ptr, c_char, c_int
       type(c_ptr), value :: p
       character(kind=c_char), dimension(*), intent(in) :: source
       integer(c_int) :: rc
     end function ofort_c_check

     subroutine ofort_c_set_implicit_typing(p, enabled) bind(c)
       import :: c_ptr, c_int
       type(c_ptr), value :: p
       integer(c_int), value :: enabled
     end subroutine ofort_c_set_implicit_typing

     subroutine ofort_c_set_warnings_enabled(p, enabled) bind(c)
       import :: c_ptr, c_int
       type(c_ptr), value :: p
       integer(c_int), value :: enabled
     end subroutine ofort_c_set_warnings_enabled

     subroutine ofort_c_set_fast_mode(p, enabled) bind(c)
       import :: c_ptr, c_int
       type(c_ptr), value :: p
       integer(c_int), value :: enabled
     end subroutine ofort_c_set_fast_mode

     subroutine ofort_c_set_trace_assign(p, enabled) bind(c)
       import :: c_ptr, c_int
       type(c_ptr), value :: p
       integer(c_int), value :: enabled
     end subroutine ofort_c_set_trace_assign

     function ofort_c_copy_output(p, buf, buf_size) bind(c) result(n)
       import :: c_ptr, c_char, c_int
       type(c_ptr), value :: p
       character(kind=c_char), dimension(*), intent(out) :: buf
       integer(c_int), value :: buf_size
       integer(c_int) :: n
     end function ofort_c_copy_output

     function ofort_c_copy_error(p, buf, buf_size) bind(c) result(n)
       import :: c_ptr, c_char, c_int
       type(c_ptr), value :: p
       character(kind=c_char), dimension(*), intent(out) :: buf
       integer(c_int), value :: buf_size
       integer(c_int) :: n
     end function ofort_c_copy_error

     function ofort_c_copy_warnings(p, buf, buf_size) bind(c) result(n)
       import :: c_ptr, c_char, c_int
       type(c_ptr), value :: p
       character(kind=c_char), dimension(*), intent(out) :: buf
       integer(c_int), value :: buf_size
       integer(c_int) :: n
     end function ofort_c_copy_warnings
  end interface

contains

  subroutine ofort_fortran_create(this)
    class(ofort_interpreter), intent(inout) :: this
    if (c_associated(this%handle)) call this%destroy()
    this%handle = ofort_c_create()
  end subroutine ofort_fortran_create

  subroutine ofort_fortran_destroy(this)
    class(ofort_interpreter), intent(inout) :: this
    if (c_associated(this%handle)) then
       call ofort_c_destroy(this%handle)
       this%handle = c_null_ptr
    end if
  end subroutine ofort_fortran_destroy

  subroutine ofort_fortran_finalize(this)
    type(ofort_interpreter), intent(inout) :: this
    if (c_associated(this%handle)) then
       call ofort_c_destroy(this%handle)
       this%handle = c_null_ptr
    end if
  end subroutine ofort_fortran_finalize

  subroutine ofort_fortran_reset(this)
    class(ofort_interpreter), intent(inout) :: this
    if (c_associated(this%handle)) call ofort_c_reset(this%handle)
  end subroutine ofort_fortran_reset

  function ofort_fortran_execute(this, source) result(rc)
    class(ofort_interpreter), intent(inout) :: this
    character(len=*), intent(in) :: source
    integer :: rc
    character(kind=c_char), allocatable :: c_source(:)

    call ensure_created(this)
    c_source = to_c_string(source)
    rc = ofort_c_execute(this%handle, c_source)
  end function ofort_fortran_execute

  function ofort_fortran_check(this, source) result(rc)
    class(ofort_interpreter), intent(inout) :: this
    character(len=*), intent(in) :: source
    integer :: rc
    character(kind=c_char), allocatable :: c_source(:)

    call ensure_created(this)
    c_source = to_c_string(source)
    rc = ofort_c_check(this%handle, c_source)
  end function ofort_fortran_check

  function ofort_fortran_output(this) result(text)
    class(ofort_interpreter), intent(inout) :: this
    character(len=:), allocatable :: text
    call ensure_created(this)
    text = copy_c_text(this%handle, ofort_c_copy_output)
  end function ofort_fortran_output

  function ofort_fortran_error(this) result(text)
    class(ofort_interpreter), intent(inout) :: this
    character(len=:), allocatable :: text
    call ensure_created(this)
    text = copy_c_text(this%handle, ofort_c_copy_error)
  end function ofort_fortran_error

  function ofort_fortran_warnings(this) result(text)
    class(ofort_interpreter), intent(inout) :: this
    character(len=:), allocatable :: text
    call ensure_created(this)
    text = copy_c_text(this%handle, ofort_c_copy_warnings)
  end function ofort_fortran_warnings

  subroutine ofort_fortran_set_implicit_typing(this, enabled)
    class(ofort_interpreter), intent(inout) :: this
    logical, intent(in) :: enabled
    call ensure_created(this)
    call ofort_c_set_implicit_typing(this%handle, merge(1_c_int, 0_c_int, enabled))
  end subroutine ofort_fortran_set_implicit_typing

  subroutine ofort_fortran_set_warnings_enabled(this, enabled)
    class(ofort_interpreter), intent(inout) :: this
    logical, intent(in) :: enabled
    call ensure_created(this)
    call ofort_c_set_warnings_enabled(this%handle, merge(1_c_int, 0_c_int, enabled))
  end subroutine ofort_fortran_set_warnings_enabled

  subroutine ofort_fortran_set_fast_mode(this, enabled)
    class(ofort_interpreter), intent(inout) :: this
    logical, intent(in) :: enabled
    call ensure_created(this)
    call ofort_c_set_fast_mode(this%handle, merge(1_c_int, 0_c_int, enabled))
  end subroutine ofort_fortran_set_fast_mode

  subroutine ofort_fortran_set_trace_assign(this, enabled)
    class(ofort_interpreter), intent(inout) :: this
    logical, intent(in) :: enabled
    call ensure_created(this)
    call ofort_c_set_trace_assign(this%handle, merge(1_c_int, 0_c_int, enabled))
  end subroutine ofort_fortran_set_trace_assign

  subroutine ensure_created(this)
    class(ofort_interpreter), intent(inout) :: this
    if (.not. c_associated(this%handle)) call this%create()
  end subroutine ensure_created

  function to_c_string(text) result(c_text)
    character(len=*), intent(in) :: text
    character(kind=c_char), allocatable :: c_text(:)
    integer :: i

    allocate(c_text(len(text) + 1))
    do i = 1, len(text)
       c_text(i) = text(i:i)
    end do
    c_text(len(text) + 1) = c_null_char
  end function to_c_string

  function copy_c_text(handle, copier) result(text)
    type(c_ptr), intent(in), value :: handle
    interface
       function copier(p, buf, buf_size) bind(c) result(n)
         import :: c_ptr, c_char, c_int
         type(c_ptr), value :: p
         character(kind=c_char), dimension(*), intent(out) :: buf
         integer(c_int), value :: buf_size
         integer(c_int) :: n
       end function copier
    end interface
    character(len=:), allocatable :: text
    character(kind=c_char), allocatable :: buf(:)
    integer(c_int) :: n
    integer :: i, ncopy

    allocate(buf(ofort_text_buffer_size))
    n = copier(handle, buf, int(size(buf), c_int))
    ncopy = min(max(int(n), 0), ofort_text_buffer_size - 1)
    allocate(character(len=ncopy) :: text)
    do i = 1, ncopy
       text(i:i) = transfer(buf(i), " ")
    end do
  end function copy_c_text

end module ofort_binding

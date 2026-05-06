module shape_mod
   implicit none

   private
   public :: shape, dp

   integer, parameter :: dp = kind(1.0d0)

   type :: shape
      character(len=20) :: name = "shape"
      character(len=20) :: kind = "generic"
      real(kind=dp) :: radius = 0.0_dp
      real(kind=dp) :: width  = 0.0_dp
      real(kind=dp) :: height = 0.0_dp
   contains
      procedure :: describe => describe_shape
      procedure :: area     => area_shape
   end type shape

contains

   subroutine describe_shape(self)
      ! Print a description of a shape.
      class(shape), intent(in) :: self

      if (self%kind == "circle") then
         print *, "circle: ", trim(self%name), " radius =", self%radius
      else if (self%kind == "rectangle") then
         print *, "rectangle: ", trim(self%name), &
                  " width =", self%width, " height =", self%height
      else
         print *, "generic shape: ", trim(self%name)
      end if
   end subroutine describe_shape

   function area_shape(self) result(y)
      ! Return the area of a shape.
      class(shape), intent(in) :: self
      real(kind=dp) :: y

      if (self%kind == "circle") then
         y = acos(-1.0_dp)*self%radius**2
      else if (self%kind == "rectangle") then
         y = self%width*self%height
      else
         y = 0.0_dp
      end if
   end function area_shape

end module shape_mod

program main
   use shape_mod, only: shape, dp
   implicit none

   type(shape) :: s
   type(shape) :: c
   type(shape) :: r
   type(shape), allocatable :: objects(:)

   integer, parameter :: nobj = 3
   integer :: i

   s%name = "plain shape"
   s%kind = "generic"

   c%name = "unit circle"
   c%kind = "circle"
   c%radius = 1.0_dp

   r%name = "box"
   r%kind = "rectangle"
   r%width = 3.0_dp
   r%height = 4.0_dp

   print *, "individual objects:"
   call s%describe()
   print *, "area =", s%area()

   call c%describe()
   print *, "area =", c%area()

   call r%describe()
   print *, "area =", r%area()

   print *
   print *, "array of non-polymorphic objects:"

   allocate(objects(nobj))

   objects(1) = s
   objects(2) = c
   objects(3) = r

   do i = 1, size(objects)
      call objects(i)%describe()
      print *, "area =", objects(i)%area()
   end do

end program main


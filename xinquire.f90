program test_inquire_statement
   implicit none

   integer, parameter :: unit = 10
   character(len=*), parameter :: filename = "xinquire_test.txt"

   logical :: file_exists
   logical :: unit_opened
   logical :: file_opened
   logical :: named

   integer :: ios
   integer :: number
   integer :: next_unit
   integer :: recl
   integer :: size
   integer :: pos

   character(len=256) :: name
   character(len=32) :: access
   character(len=32) :: action
   character(len=32) :: blank
   character(len=32) :: decimal
   character(len=32) :: delim
   character(len=32) :: direct
   character(len=32) :: encoding
   character(len=32) :: form
   character(len=32) :: formatted_str
   character(len=32) :: pad
   character(len=32) :: position
   character(len=32) :: read_str
   character(len=32) :: readwrite
   character(len=32) :: sequential
   character(len=32) :: sign
   character(len=32) :: stream
   character(len=32) :: unformatted_str
   character(len=32) :: write_str

   inquire(file=filename, exist=file_exists)
   print '(a,l1)', "before open: file exists = ", file_exists

   inquire(unit=unit, opened=unit_opened)
   print '(a,l1)', "before open: unit opened = ", unit_opened

   open(unit, file=filename, status="replace", action="readwrite", &
      access="stream", form="formatted", position="rewind", iostat=ios)
   if (ios /= 0) error stop "could not open file"

   write(unit, '(a)') "line 1"
   write(unit, '(a)') "line 2"

   inquire(unit=unit, &
      opened=unit_opened, &
      named=named, &
      name=name, &
      number=number, &
      access=access, &
      action=action, &
      blank=blank, &
      decimal=decimal, &
      delim=delim, &
      direct=direct, &
      encoding=encoding, &
      form=form, &
      formatted=formatted_str, &
      unformatted=unformatted_str, &
      pad=pad, &
      position=position, &
      read=read_str, &
      write=write_str, &
      readwrite=readwrite, &
      sequential=sequential, &
      stream=stream, &
      sign=sign, &
      recl=recl, &
      size=size, &
      pos=pos, &
      iostat=ios)

   if (ios /= 0) error stop "inquire by unit failed"

   print *
   print '(a)', "inquire by unit:"
   print '(a,l1)', "opened      = ", unit_opened
   print '(a,l1)', "named       = ", named
   print '(a,a)',  "name        = ", trim(name)
   print '(a,i0)', "number      = ", number
   print '(a,a)',  "access      = ", trim(access)
   print '(a,a)',  "action      = ", trim(action)
   print '(a,a)',  "blank       = ", trim(blank)
   print '(a,a)',  "decimal     = ", trim(decimal)
   print '(a,a)',  "delim       = ", trim(delim)
   print '(a,a)',  "direct      = ", trim(direct)
   print '(a,a)',  "encoding    = ", trim(encoding)
   print '(a,a)',  "form        = ", trim(form)
   print '(a,a)',  "formatted   = ", trim(formatted_str)
   print '(a,a)',  "unformatted = ", trim(unformatted_str)
   print '(a,a)',  "pad         = ", trim(pad)
   print '(a,a)',  "position    = ", trim(position)
   print '(a,a)',  "read        = ", trim(read_str)
   print '(a,a)',  "write       = ", trim(write_str)
   print '(a,a)',  "readwrite   = ", trim(readwrite)
   print '(a,a)',  "sequential  = ", trim(sequential)
   print '(a,a)',  "stream      = ", trim(stream)
   print '(a,a)',  "sign        = ", trim(sign)
   print '(a,i0)', "recl        = ", recl
   print '(a,i0)', "size        = ", size
   print '(a,i0)', "pos         = ", pos

   inquire(file=filename, &
      exist=file_exists, &
      opened=file_opened, &
      named=named, &
      number=number, &
      size=size, &
      iostat=ios)

   if (ios /= 0) error stop "inquire by file failed"

   print *
   print '(a)', "inquire by file:"
   print '(a,l1)', "exist       = ", file_exists
   print '(a,l1)', "opened      = ", file_opened
   print '(a,l1)', "named       = ", named
   print '(a,i0)', "number      = ", number
   print '(a,i0)', "size        = ", size

   inquire(iolength=recl) 123, 3.5, "abc"
   print *
   print '(a,i0)', "inquire(iolength=...) for 123, 3.5, 'abc' = ", recl

   close(unit)

   inquire(unit=unit, opened=unit_opened)
   print *
   print '(a,l1)', "after close: unit opened = ", unit_opened

   open(newunit=next_unit, file=filename, status="old", action="read", iostat=ios)
   if (ios /= 0) error stop "could not reopen file with newunit"

   print '(a,i0)', "newunit selected unit number = ", next_unit

   inquire(unit=next_unit, opened=unit_opened, action=action, read=read_str, &
      write=write_str, readwrite=readwrite, iostat=ios)
   if (ios /= 0) error stop "inquire on newunit failed"

   print '(a,l1)', "newunit opened = ", unit_opened
   print '(a,a)',  "action         = ", trim(action)
   print '(a,a)',  "read           = ", trim(read_str)
   print '(a,a)',  "write          = ", trim(write_str)
   print '(a,a)',  "readwrite      = ", trim(readwrite)

   close(next_unit, status="delete")

   inquire(file=filename, exist=file_exists)
   print *
   print '(a,l1)', "after delete: file exists = ", file_exists

end program test_inquire_statement

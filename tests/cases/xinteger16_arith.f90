program xinteger16_arith
  implicit none
  integer :: fails
  integer(16) :: a, b, c, d, e, h

  fails = 0

  a = 3037000500_16
  b = 3037000500_16
  c = a * b
  if (c /= 9223372037000250000_16) then
     print *, 'FAIL multiply:', c
     fails = fails + 1
  end if

  d = 9223372036854775807_16
  e = d + 1_16
  if (e /= 9223372036854775808_16) then
     print *, 'FAIL add past int64:', e
     fails = fails + 1
  end if

  if (e - d /= 1_16) then
     print *, 'FAIL subtract:', e - d
     fails = fails + 1
  end if

  h = huge(0_16)
  if (h /= 170141183460469231731687303715884105727_16) then
     print *, 'FAIL huge:', h
     fails = fails + 1
  end if

  if (h / 2_16 /= 85070591730234615865843651857942052863_16) then
     print *, 'FAIL divide:', h / 2_16
     fails = fails + 1
  end if

  if (fails == 0) then
     print *, 'ok'
  else
     print *, fails, 'integer(16) arithmetic tests failed'
  end if
end program

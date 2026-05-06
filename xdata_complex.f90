program main
implicit none
integer, parameter :: dp = kind(1.0d0)
complex(kind=dp) :: z, zz(3), zzz(3)
data z /(3.0_dp, 4.0_dp)/
data zz /3*(3.0_dp, 4.0_dp)/
data zzz /(3.0_dp, 4.0_dp), (30.0_dp, 40.0_dp), (300.0_dp, 400.0_dp)/
print "(*(f8.2))", z
print "(*(f8.2))", zz
print "(*(f8.2))", zzz
end program main

program xprimes_sieve
   ! Count primes up to nmax using a sieve over odd candidates only.
   implicit none

   integer, parameter :: nmax = 10**7, long_int = selected_int_kind(18)
   integer(kind=long_int) :: sum_prime
   integer :: i, p, p2, nprime, last_prime
   logical :: is_prime(3:nmax)

   is_prime = .true.

   do p = 3, int(sqrt(real(nmax))), 2
      if (is_prime(p)) then
         p2 = p*p
         do i = p2, nmax, 2*p
            is_prime(i) = .false.
         end do
      end if
   end do

   nprime = 1
   sum_prime = 2
   last_prime = 2

   do p = 3, nmax, 2
      if (is_prime(p)) then
         nprime = nprime + 1
         sum_prime = sum_prime + p
         last_prime = p
      end if
   end do

   print "('upper bound, #primes, sum, last =',*(1x,i0))", nmax, nprime, sum_prime, last_prime

end program xprimes_sieve

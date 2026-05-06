program xprimes_skip_even
   ! Count primes up to nmax, using only odd candidates after 2.
   implicit none

   integer, parameter :: nmax = 100000
   integer :: n, d, nprime, sum_prime, last_prime
   logical :: is_prime

   nprime = 1
   sum_prime = 2
   last_prime = 2

   do n = 3, nmax, 2
      is_prime = .true.

      do d = 3, int(sqrt(real(n))), 2
         if (mod(n, d) == 0) then
            is_prime = .false.
            exit
         end if
      end do

      if (is_prime) then
         nprime = nprime + 1
         sum_prime = sum_prime + n
         last_prime = n
      end if
   end do
   print "('upper bound, #primes, sum, last =',*(1x,i0))", nmax, nprime, sum_prime, last_prime
end program xprimes_skip_even

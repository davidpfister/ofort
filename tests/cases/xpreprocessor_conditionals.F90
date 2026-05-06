#define N 5
#if defined(MISSING)
print *, "bad1"
#elif defined(N)
print *, N
#else
print *, "bad2"
#endif
#ifndef MISSING
print *, "pass"
#endif
end

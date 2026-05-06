program xutil_regressions
implicit none
character(len=5) :: words(3)
logical :: tf(5)
integer :: ivec(5)
words = [character(len=5) :: "alpha", "beta", "gamma"]
tf = [.false., .true., .true., .false., .true.]
ivec = [1, 2, 3, 4, 5]
print *, join(words, "-")
print *, pack(ivec, tf .and. ivec >= 2 .and. ivec <= 5)
print *, count(tf(2:) .neqv. tf(:4))
contains
function join(words, sep) result(str)
character(len=*), intent(in) :: words(:), sep
character(len=(size(words)-1)*len(sep) + sum(len_trim(words))) :: str
integer :: i, nw
nw = size(words)
if (nw < 1) then
   str = ""
   return
end if
write (str, "(10000(a))") trim(words(1)), (sep // trim(words(i)), i = 2, nw)
end function join
end program xutil_regressions

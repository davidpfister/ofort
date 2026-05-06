interface assignment(=)
  subroutine assign_i(a,b)
    integer, intent(out) :: a
    integer, intent(in) :: b
  end subroutine
end interface assignment(=)
print *, 'pass'
end

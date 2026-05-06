subroutine allocate(result)
  integer :: result
  result = result + 1
end

function if(save)
  integer :: save
  integer :: if
  if = save + 2
end

program main
  integer :: save
  integer :: type
  integer :: result
  parameter(result=4)
  save = 1
  type = if(result)
  call allocate(save)
  print *, result, save, type
end

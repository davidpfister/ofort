integer :: count1 = 1, count2 = 4, rate = 2
write(*,'(a,f9.6)') 'Time taken ', (count2-count1)/real(rate)
end

subroutine ezcdf_error(status,nam3,nam1,nam2)
  include "netcdf.inc"
  integer, intent(in) :: status
  character(len=*), intent(in) :: nam1, nam2, nam3
  if (status .eq. nf_noerr) return
  write(*,10) trim(nam1),trim(nam2),trim(nam3)
10 format('% ',a,'--E-- A netCDF error has occurred in: ' ,a/ &
        'while processing: ',a)
  print *, nf_strerror(status)
  return
end subroutine ezcdf_error

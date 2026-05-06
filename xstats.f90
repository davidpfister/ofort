module statistics_mod
! 04/12/2007 3:55pm fixed sd_wgt, sd_fixed_mean_wgt
! branched from statistics.f90
implicit none
private
public  :: dp,geo_mean,mean,mean_2d,mean_3d,sd,sd_by_col,skew,kurtosis,print_basic_stats_col, &
           mean_by_row,mean_by_col,print_stats_one_var_per_row, &
           average_rank,average_rank_by_col,print_basic_stats,stat_vec_str,stat,stats,stat_labels, &
           print_stats,print_stats_binary,print_stats_momentum,count_signs,sign_labels, &
           istat_str,print_many_stats_matrix_col,print_stats_annualized,print_stats_extended, &
           obs_per_year,istat_str_check,sd_fixed_mean,normalize_sum_abs,concentration,print_stats_matrix, &
           rms,median,prob_positive,diff_tf,sharpe,drawdown,r2_fit,r2_trend,r2_cumul_trend,sd_wgt,sd_fixed_mean_wgt, &
           diff,bound,lookback,stats_cat,num_sign_changes,num_changes,sd_weighted,norm_abs,bin_means,bin_freq, &
           stats_count_categories,rolling_stat,transition_count,transition_prob,bin, &
           bin_counts,first,last,minval_def,maxval_def,basic_stats_str,sd_general,print_computed_stats, &
           sd_asymm,mean_dim_1,standardize,nunique,unique_values,histogram,density,roughness,print_rmse_obs, &
           stats_binary,mean_abs_diff,semidev,semisharpe,diff_nonoverlap,diff_rms,var_ratio,difference, &
           correl_mask,slope,frequency_changes,frequency_changes_rows,correl,print_stats_tensor,vol_rms, &
           num_wgt,cumul_sum,rescale_volatility,dot,write_stats_groups,sharpe_monthly,stretch_param,stretch_dt, &
           set,display,read_stretch_param_vec,write_stats_ranges,percentile,expectile,write_stats_nday_returns, &
           obs_count,vol_from_prices,maxval_antithetic,range,range_mean,mean_abs_sum,print_stats_panel, &
           print_stats_good,print_stats_ranges,print_stats_combo_two,frac_greater,frac_smaller,rms_ema,vol_rms_ema, &
           ema_rolling,vol_rms_ema_rolling,detrend,percentiles,print_stats_quantiles,below,print_stats_bin_widths, &
           rescale_sd_col,rescale_sd,rms_nonzero,sharpe_by_col,equal_vol_sum,set_obs_per_year,rolling_stat_good, &
           linearly_weighted_mean,mean_int,stats_ex_nan,mean_mask,iqr,is_outlier_iqr,is_outlier_iqr_good, &
           num_outliers_iqr,madev,madev_good,num_bin_changes,cagr,cumul_ret,print_computed_basket_stats, &
           show_binary_corr,compound_ret,bin_stats,sharpe_adj,vol_normalize_ema,sq_dist,running_mean, &
           rolling_stat_func,print_many_stats_vec_str,cagr_prices,scale_ret_cagr,print_bin_freq,filter_data, &
           madev_mat,moving_average_i1_i2,acf,print_stats_vol_norm,rollmean,rollmean_ratio,sums,moving_averages, &
           rollmean_12,sums_nonoverlap,normalize_vol,add_row_means,rescale_columns,corr_alpha_beta, &
           print_corr_simple_reg,print_stats_mac_ret,stats_mac_ret_xvec_yvec,indexx,print_corr_alpha_beta_many, &
           aic_penalty,inf_crit_mvn,print_freq,print_stats_train_test,acf_str,bin_prob,stdz, &
           print_stats_ranges_madev,print_stats_ranges_signals_returns,print_stats_binned_returns, &
           print_stats_bins
integer, parameter :: output_unit = 6, dp = kind(1.0d0)
real(kind=dp), parameter :: bad_real = -999.0_dp
interface stdz
   module procedure stdz_vec,stdz_mat
end interface stdz
interface print_freq
   module procedure print_freq_int_vec,print_freq_int_mat
end interface print_freq
interface indexx
   module procedure indexx_real,indexx_int
end interface indexx
interface assert_equal
   module procedure assert_equal_2,assert_equal_2__
end interface assert_equal
interface acf
   module procedure acf_vec,acf_mat
end interface acf
interface display
   module procedure display_stretch_param
end interface display
interface set
   module procedure set_stretch_param
end interface set
interface default
   module procedure default_logical,default_integer,default_character,default_real
end interface default
interface difference
   module procedure difference_vec,difference_mat,difference_panel
end interface difference
interface diff_nonoverlap
   module procedure diff_nonoverlap_vec
end interface diff_nonoverlap
interface diff_rms
   module procedure diff_rms_lags_vec
end interface diff_rms
interface unique_values
   module procedure unique_values_real
end interface unique_values
interface nunique
   module procedure nunique_real
end interface nunique
interface print_computed_stats
   module procedure print_computed_stats_matrix
end interface print_computed_stats
interface num_changes
   module procedure num_changes_int,num_changes_tf,num_changes_real
end interface num_changes
interface num_sign_changes
   module procedure num_sign_changes_real
end interface num_sign_changes
interface diff
   module procedure diff_vec,diff_mat,diff_tensor
end interface diff
interface stat
   module procedure stat_vec_str
end interface stat
interface stats
   module procedure stat_mat_str,stat_tensor_str,stat_tensor_str_many,stat_mat_str_many,stat_vec_str,stat_vec_str_many, &
                    stat_vec_int,stat_vec_int_many,stat_mat_int_many
end interface
interface stats_cat
   module procedure stat_categories_many,stat_categories_many_str
end interface stats_cat
interface print_stats
   module procedure print_many_stats_vec,print_many_stats_vec_str, &
                    print_many_stats_matrix_col,print_stats_matrix,print_stats_panel
end interface
interface print_stats_extended
   module procedure print_many_stats_matrix_extended
end interface print_stats_extended
interface bin
   module procedure bin_12
end interface bin
interface rank
   module procedure rank_real
end interface rank
interface rolling_stat_good
   module procedure rolling_stat_good_vec,rolling_stat_good_matrix
end interface rolling_stat_good
interface set_alloc
   module procedure set_alloc_real_vec,set_alloc_character_vec,set_alloc_int_vec,set_alloc_real_matrix
end interface set_alloc
interface sq_dist
   module procedure sq_dist_vec_mat,sq_dist_vec_vec
end interface sq_dist
interface rolling_stat_func
   module procedure rolling_stat,rolling_stat_func_matrix
end interface rolling_stat_func
interface filter_data
   module procedure filter_data_vec,filter_data_matrix
end interface filter_data
interface madev
   module procedure madev_vec,madev_mat,madev_2ma_vec
end interface madev
interface rollmean_ratio
   module procedure rollmean_ratio_vec,rollmean_ratio_mat
end interface rollmean_ratio
interface normalize_vol
   module procedure normalize_vol_mat,normalize_vol_vec
end interface normalize_vol
real(kind=dp)                       :: obs_per_year = 1.0_dp, scale_ret_cagr = 1.0_dp
real(kind=dp)  , private, parameter :: bad = 0.0d0, one = 1.0_dp, tiny_real = 1.0e-10_dp, zero=0.0_dp, &
                                       big_real=1.0e30_dp, bad_acf  = -2.0_dp
logical :: show_binary_corr = .true.
integer, parameter :: nlen=20
integer, public, parameter :: iimean = 1, iisd  = 2, iiskew = 3, iikurt = 4, iifirst = 5, iilast = 6, &
                              iimin  = 7, iimax = 8, iistd_err = 9, iisharpe = 10,  &
                              iipos = 11, iineg = 12, iisum = 13, iimean_abs = 14, iimean_nonzero = 15, &
                              iicount = 16, iicgr = 17, iizscore = 18, iimedian=19, iiconcen = 20, iidrawdn = 21, &
                              iir2_cum = 22, iisum_abs = 23, iigeo_ret = 24, iisign_changes = 25, iizero = 26, iiavg_dev = 27, &
                              iione = 28, iisharpe_log = 29, iisemidev = 30, iisemisharpe = 31, iimean_abs_diff=32, &
                              iichanges = 33, iirms = 34, iivol_rms = 35, iivol = 36, iichange = 37, iipct_change = 38, &
                              iiavg_pos = 39, iiavg_neg = 40, iinum_wgt = 41, iinum_min = 42, iinum_max = 43, &
                              iiavg_ann = 44, nunchgd = 45, nchgd = 46, &
                              nperc_01 = 47, nperc_05 = 48, &
                              nperc_10 = 49, nperc_25 = 50, nperc_50 = 51, nperc_75 = 52, &
                              nperc_90 = 53, nperc_95 = 54, nperc_99 = 55,  &
                              nmean_01 = 56, nmean_05 = 57, &
                              nmean_10 = 58, nmean_25 = 59, nmean_50 = 60, nmean_75 = 61, &
                              nmean_90 = 62, nmean_95 = 63, nmean_99 = 64,  &
                              iisharpe_01 = 65, iisharpe_05 = 66, iisharpe_10 = 67, iisharpe_25 = 68, &
                              iisharpe_50 = 69, iigeomean=70, iiobs_year = 71, iivariance=72, &
                              iirange = 73, iifrac_zero=74, iifrac_one = 75, iifrac_min = 76, iifrac_max = 77, &
                              iipenultimate = 78, iigain = 79, iiloss = 80, iiwgt_mean = 81, iicount_nan=82, &
                              iifirst_nan=83, iilast_nan = 84, iiminloc = 85, iimaxloc = 86, iiwgt_rms = 87, &
                              iisharpe_adj = 88, iicagr_ret = 89, iicagr_prices = 90, iiwin_loss = 91, & 
                              iimean_div_sd = 92, nstats = 92, months_per_year = 12
integer, private , parameter :: istdout = output_unit, bad_unit = -1
character (len=20), parameter :: str_none = "none", str_mean_abs = "mean_abs", str_trans(2) = [str_none,str_mean_abs]
character (len=*), parameter :: basic_stats_str(5)=(/"median","mean  ","sd    ","min   ","max   "/), &
                                fmt_acsv = "(100(a,','))"
character (len=4), parameter :: sign_labels(3) = (/" neg","zero"," pos"/)
character (len=nlen), parameter :: stat_labels(nstats) = [  "mean                ",& !  1
                                                            "sd                  ",& !  2
                                                            "skew                ",& !  3
                                                            "kurt                ",& !  4   
                                                            "first               ",& !  5
                                                            "last                ",& !  6
                                                            "min                 ",& !  7
                                                            "max                 ",& !  8
                                                            "stderr              ",& !  9
                                                            "Sharpe              ",& ! 10
                                                            "pos                 ",& ! 11
                                                            "neg                 ",& ! 12
                                                            "sum                 ",& ! 13
                                                            "avgabs              ",& ! 14
                                                            "nzmean              ",& ! 15
                                                            "count               ",& ! 16
                                                            "CGR                 ",& ! 17
                                                            "zscore              ",& ! 18
                                                            "median              ",& ! 19
                                                            "concen              ",& ! 20
                                                            "drawdn              ",& ! 21
                                                            "r2_cum              ",& ! 22
                                                            "sumabs              ",& ! 23
                                                            "georet              ",& ! 24
                                                            "sgnchg              ",& ! 25
                                                            "zero                ",& ! 26
                                                            "avgdev              ",& ! 27
                                                            "one                 ",& ! 28
                                                            "Shrplg              ",& ! 29
                                                            "semdev              ",& ! 30
                                                            "Shrpdn              ",& ! 31
                                                            "absdif              ",& ! 32
                                                            "chnges              ",& ! 33
                                                            "rms                 ",& ! 34
                                                            "volrms              ",& ! 35
                                                            "vol                 ",& ! 36
                                                            "change              ",& ! 37
                                                            "pctchg              ",& ! 38
                                                            "avgpos              ",& ! 39
                                                            "avgneg              ",& ! 40
                                                            "numwgt              ",& ! 41
                                                            "nummin              ",& ! 42
                                                            "nummax              ",& ! 43
                                                            "avgann              ",& ! 44
                                                            "unchgd              ",& ! 45
                                                            "chgd                ",& ! 46
                                                            "perc_01             ",& ! 47
                                                            "perc_05             ",& ! 48
                                                            "perc_10             ",& ! 49
                                                            "perc_25             ",& ! 50
                                                            "perc_50             ",& ! 51
                                                            "perc_75             ",& ! 52
                                                            "perc_90             ",& ! 53
                                                            "perc_95             ",& ! 54
                                                            "perc_99             ",& ! 55
                                                            "mean_01             ",& ! 56
                                                            "mean_05             ",& ! 57
                                                            "mean_10             ",& ! 58
                                                            "mean_25             ",& ! 59
                                                            "mean_50             ",& ! 60
                                                            "mean_75             ",& ! 61
                                                            "mean_90             ",& ! 62
                                                            "mean_95             ",& ! 63
                                                            "mean_99             ",& ! 64
                                                            "Sharpe_01           ",& ! 65
                                                            "Sharpe_05           ",& ! 66
                                                            "Sharpe_10           ",& ! 67
                                                            "Sharpe_25           ",& ! 68
                                                            "Sharpe_50           ",& ! 69 
                                                            "geomean             ",& ! 70
                                                            "obs_year            ",& ! 71
                                                            "variance            ",& ! 72
                                                            "range               ",& ! 73
                                                            "frac_zero           ",& ! 74
                                                            "frac_one            ",& ! 75
                                                            "frac_min            ",& ! 76
                                                            "frac_max            ",& ! 77
                                                            "penult              ",& ! 78
                                                            "gain                ",& ! 79
                                                            "loss                ",& ! 80
                                                            "wgt_mean            ",& ! 81
                                                            "count_NaN           ",& ! 82
                                                            "first_NaN           ",& ! 83
                                                            "last_NaN            ",& ! 84
                                                            "minloc              ",& ! 85
                                                            "maxloc              ",& ! 86
                                                            "wgt_rms             ",& ! 87
                                                            "Sharpe_adj          ",& ! 88
                                                            "CAGR_ret            ",& ! 89
                                                            "CAGR                ",& ! 90
                                                            "win/loss            ",& ! 91
                                                            "mean/sd             "]  ! 92
character (len=*), parameter :: mod_str="in statistics_mod::"
type :: stretch_param
   real(kind=dp) :: x1, x2, power, scale, ymin=-big_real, ymax=big_real
   character (len=100) :: normalization
end type stretch_param
contains
!
function roughness(xx) result(yy)
! proportional to integral of 2nd squared derivative
real(kind=dp), intent(in) :: xx(:)
real(kind=dp)             :: yy
integer                   :: i,n
yy = 0.0_dp
n  = size(xx)
do i=2,n-1
   yy = yy + (2*xx(i)-xx(i-1)-xx(i+1))**2
end do
end function roughness
!
elemental function istat_str(str) result(istat)
character (len=*), intent(in) :: str
integer                       :: istat
do istat=1,nstats
   if (str == stat_labels(istat)) return
end do
istat = 0
end function istat_str
!
function istat_str_check(str) result(istat)
character (len=*), intent(in) :: str(:)
integer                       :: istat(size(str))
integer                       :: i,n,nbad
character (len=*), parameter  :: msg=mod_str // "istat_str_check, "
nbad = 0
n = size(str)
do i=1,n
   istat(i) = istat_str(str(i))
   if (istat(i) == 0) then
      write (*,*) msg // "i, str(i)=",i,"'" // trim(str(i)) // "'  -- invalid str(i)"
      nbad = nbad + 1
   end if
end do
if (nbad > 0) then
   write (*,*) msg,"n, nbad = ",n, nbad
   write (*,*) "stopping " // msg
   stop
end if
end function istat_str_check
!
function stat_vec_int(istat,xx) result(xstat)
! compute one statistic for a vector
integer      , intent(in) :: istat
real(kind=dp), intent(in) :: xx(:)
real(kind=dp)             :: xstat
if (istat > 0 .and. istat <= nstats) xstat = stat_vec_str(stat_labels(istat),xx)
end function stat_vec_int
!
function stat_vec_int_many(istat,xx) result(xstat)
! compute many statistics for a vector
integer      , intent(in) :: istat(:)
real(kind=dp), intent(in) :: xx(:)
real(kind=dp)             :: xstat(size(istat))
integer                   :: i,ni
ni = size(istat)
do i=1,ni
   xstat(i) = stat_vec_int(istat(i),xx)
end do
end function stat_vec_int_many
!
function stat_mat_int_many(istat,xx) result(xstat)
! compute many statistics for a matrix
integer      , intent(in) :: istat(:)
real(kind=dp), intent(in) :: xx(:,:)
real(kind=dp)             :: xstat(size(istat),size(xx,2))
integer                   :: i,j,ni,nvar
nvar = size(xx,2)
ni = size(istat)
do i=1,ni
   do j=1,nvar
      xstat(i,j) = stat_vec_int(istat(i),xx(:,j))
   end do
end do
end function stat_mat_int_many
!
function stat_categories_many(istat,ncat,ix,xx) result(yy)
integer      , intent(in) :: istat(:)
integer      , intent(in) :: ncat
integer      , intent(in) :: ix(:)
real(kind=dp), intent(in) :: xx(:)
real(kind=dp)             :: yy(size(istat),ncat)
integer                   :: i
yy    = 0.0_dp
if (size(ix) /= size(xx)) return
do i=1,ncat
   yy(:,i) = stat_vec_int_many(istat,pack(xx,ix==i))
end do
end function stat_categories_many
!
function stat_categories_many_str(cstat,ncat,ix,xx) result(yy)
character (len=*), intent(in) :: cstat(:)
integer          , intent(in) :: ncat
integer          , intent(in) :: ix(:)
real(kind=dp)    , intent(in) :: xx(:)
real(kind=dp)                 :: yy(size(cstat),ncat)
yy = stat_categories_many(istat_str(cstat),ncat,ix,xx)
end function stat_categories_many_str
!
subroutine stats_count_categories(cstats,ix,xx,ncount,xstats,ierr)
! compute statistics for each category of xx, denoted by corresponding element of ix
character (len=*), intent(in)  :: cstats(:)
integer          , intent(in)  :: ix(:)
real(kind=dp)    , intent(in)  :: xx(:)
integer          , intent(out) :: ncount(:)
real(kind=dp)    , intent(out) :: xstats(:,:)
integer          , intent(out) :: ierr
integer                        :: i,j,ncat,nobs,nstat
ierr   = 0
ncat   = size(ncount)
nstat  = size(cstats)
nobs   = size(ix)
if (size(xstats,1) /= nstat) then
   ierr = 1
else if (size(xstats,2) /= ncat) then
   ierr = 2
else if (size(xx) /= nobs) then
   ierr = 3
end if
if (ierr /= 0) return
xstats = stat_categories_many_str(cstats,ncat,ix,xx)
ncount = 0
do i=1,nobs
   j = ix(i)
   if (j > 0 .and. j <= ncat) ncount(j) = ncount(j) + 1
end do
end subroutine stats_count_categories
!
function stat_mat_str(str_stat,xx,good) result(xstat)
! compute a statistic for each column of xx(:,:)
character (len=*), intent(in) :: str_stat
real(kind=dp)    , intent(in) :: xx(:,:)
logical          , intent(in), optional :: good(:,:)
real(kind=dp)                 :: xstat(size(xx,2))
integer                       :: i
if (present(good)) then
   if (size(xx,1) /= size(good,1) .or. size(xx,2) /= size(good,2)) then
      xstat = bad_real
      return
   end if
   do i=1,size(xx,2)
      xstat(i) = stat_vec_str(str_stat,pack(xx(:,i),good(:,i)))
   end do
else
   do i=1,size(xx,2)
      xstat(i) = stat_vec_str(str_stat,xx(:,i))
   end do
end if
end function stat_mat_str
!
function stat_tensor_str(str_stat,xx) result(xstat)
! compute a statistic for xx(:,i2,i3), i2=1,n2, i3=1,n3
character (len=*), intent(in) :: str_stat
real(kind=dp)    , intent(in) :: xx(:,:,:)
real(kind=dp)                 :: xstat(size(xx,2),size(xx,3))
integer                       :: i,j
do i=1,size(xx,2)
   do j=1,size(xx,3)
      xstat(i,j) = stat_vec_str(str_stat,xx(:,i,j))
   end do
end do
end function stat_tensor_str
!
function stat_tensor_str_many(str_stat,xx) result(xstat)
! compute statistics for xx(:,i2,i3), i2=1,n2, i3=1,n3
character (len=*), intent(in) :: str_stat(:)
real(kind=dp)    , intent(in) :: xx(:,:,:)
real(kind=dp)                 :: xstat(size(str_stat),size(xx,2),size(xx,3))
integer                       :: i,j,istat
do istat=1,size(str_stat)
   do i=1,size(xx,2)
      do j=1,size(xx,3)
         xstat(istat,i,j) = stat_vec_str(str_stat(istat),xx(:,i,j))
      end do
   end do
end do
end function stat_tensor_str_many
!
function stat_mat_str_many(str_stat,xx) result(xstat)
! compute statistics for each column of xx(:,:)
character (len=*), intent(in) :: str_stat(:)
real(kind=dp)    , intent(in) :: xx(:,:)
real(kind=dp)                 :: xstat(size(str_stat),size(xx,2))
integer                       :: i,j
do i=1,size(xx,2)
   do j=1,size(str_stat)
      xstat(j,i) = stat_vec_str(str_stat(j),xx(:,i))
   end do
end do
end function stat_mat_str_many
!
function stat_vec_str(str_stat,xx) result(xstat)
! compute a statistic for xx(:)
character (len=*), intent(in) :: str_stat
real(kind=dp)    , intent(in) :: xx(:)
real(kind=dp)                 :: xstat,yy(size(xx)),xsum,xdiv,xsd
integer                       :: nx
nx = size(xx)
if (nx < 1) then
   xstat = bad
   return
end if
select case (str_stat)
   case (stat_labels(iimedian))   ; xstat = median(xx)
   case (stat_labels(iimean))     ; xstat = mean(xx)
   case (stat_labels(iigeomean))  ; xstat = geo_mean(xx)
   case (stat_labels(iimean_nonzero)); xstat = mean(pack(xx,abs(xx) > tiny_real))
   case (stat_labels(iisum))      ; xstat = sum(xx)
   case (stat_labels(iigeo_ret))  ; xstat = product(1+xx) - 1.0_dp
   case (stat_labels(iimean_abs)) ; xstat = mean(abs(xx))
   case (stat_labels(iiavg_dev))  ; xstat = mean(abs(xx-mean(xx)))
   case (stat_labels(iione))      ; xstat = 1.0_dp
   case (stat_labels(iisum_abs))  ; xstat = sum(abs(xx))
   case (stat_labels(iisd))       ; xstat = sd(xx)
   case (stat_labels(iivariance)) ; xstat = variance(xx)
   case (stat_labels(iiskew))     ; xstat = skew(xx)
   case (stat_labels(iikurt))     ; xstat = kurtosis(xx)
   case (stat_labels(iimin))      ; xstat = minval(xx)
   case (stat_labels(iimax))      ; xstat = maxval(xx)
   case (stat_labels(iifirst))    ; xstat = xx(1)
   case (stat_labels(iilast))     ; xstat = xx(size(xx))
   case (stat_labels(iiwgt_mean)) ; xstat = linearly_weighted_mean(xx)
   case (stat_labels(iiwgt_rms))  ; xstat = sqrt(linearly_weighted_mean(xx**2))
   case (stat_labels(iicount_nan)) ; xstat = dble(count(isnan(xx)))
   case (stat_labels(iifirst_nan)) ; xstat = dble(first_true(isnan(xx)))
   case (stat_labels(iilast_nan)) ; xstat = dble(last_true(isnan(xx)))
   case (stat_labels(iipenultimate))
      if (size(xx) > 1) then
         xstat = xx(size(xx)-1)
      end if
   case (stat_labels(iigain))     ; xstat = mean(max(0.0_dp,xx))
   case (stat_labels(iiloss))     ; xstat = mean(min(0.0_dp,xx))
   case (stat_labels(iistd_err))  ; xstat = sd(xx)/sqrt(one * max(1,size(xx)))
   case (stat_labels(iisharpe))
        if(sd(xx) > tiny_real) then
           xstat = sqrt(obs_per_year)*mean(xx)/sd(xx)
        else
           xstat = zero
        end if
   case (stat_labels(iisharpe_adj))  ; xstat = sharpe_adj(xx,obs_per_year)
   case (stat_labels(iiavg_ann))     ; xstat = obs_per_year*mean(xx)
   case (stat_labels(iivol_rms))     ; xstat = sqrt(obs_per_year)*rms(xx)
   case (stat_labels(iivol))         ; xstat = sqrt(obs_per_year)*sd(xx)
   case (stat_labels(iizscore))      ; if(size(xx) > 1 .and. sd(xx) > tiny_real) xstat = sqrt(real(size(xx)))*mean(xx)/sd(xx)
   case (stat_labels(iipos))         ; xstat = count(xx > tiny_real)       /(one * size(xx))
   case (stat_labels(iineg))         ; xstat = count(xx <-tiny_real)       /(one * size(xx))
   case (stat_labels(iizero))        ; xstat = count(abs(xx)   <= tiny_real) /(one * size(xx))
   case (stat_labels(iifrac_zero))   ; xstat = count(abs(xx)   <= tiny_real) /(one * size(xx))
   case (stat_labels(iifrac_one))    ; xstat = count(abs(xx-1) <= tiny_real) /(one * size(xx))
   case (stat_labels(iifrac_min))    ; xstat = count(abs(xx-minval(xx)) <= tiny_real) /(one * size(xx))
   case (stat_labels(iifrac_max))    ; xstat = count(abs(xx-maxval(xx)) <= tiny_real) /(one * size(xx))
   case (stat_labels(iicount))       ; xstat = one*size(xx)
   case (stat_labels(iisign_changes)); xstat = 1.0_dp*num_sign_changes(xx) ! (1.0_dp*num_sign_changes(xx))/max(1,size(xx))
   case (stat_labels(iiconcen))
         xsum = sum(abs(xx))**2
         if (xsum > zero) then
            xstat = sum(xx**2)/xsum
         else
            xstat = zero
         end if
   case (stat_labels(iidrawdn))   ; xstat = drawdown(xx)
   case (stat_labels(iir2_cum))   ; xstat = r2_cumul_trend(xx)
   case (stat_labels(iicgr))      
      yy = 1.0_dp + xx
      if (all(yy > zero)) then
         xstat = exp(mean(log(yy))) - 1.0_dp
      else
         xstat = -1.0_dp
      end if
   case (stat_labels(iisharpe_log))      
      yy = 1.0_dp + xx
      if (all(yy > zero)) then
         xstat = sharpe(log(yy))
      else
         xstat = bad_real
      end if
   case (stat_labels(iisemidev))
      xstat = semidev(xx)
   case (stat_labels(iisemisharpe))
      xstat = semisharpe(xx)
   case (stat_labels(iimean_abs_diff))
      xstat = mean_abs_diff(xx)
   case (stat_labels(iichanges))
      xstat = frequency_changes(xx)
   case (stat_labels(iirms))
      xstat = rms(xx)
   case (stat_labels(iichange))
      xstat = change(xx)
   case (stat_labels(iipct_change))
      xstat = percent_change(xx)
   case (stat_labels(iiavg_pos))
      xstat = mean(pack(xx,xx>0.0_dp)) ! average of positive elements
   case (stat_labels(iiavg_neg))
      xstat = mean(pack(xx,xx<0.0_dp)) ! average of negative elements
   case (stat_labels(iinum_wgt))
      xstat = num_wgt(xx)
   case (stat_labels(iinum_max))
      xstat = count(xx==maxval(xx))
   case (stat_labels(iinum_min))
      xstat = count(xx==minval(xx))
   case (stat_labels(nunchgd))
      if (nx > 1) then
         xstat = dble(count(xx(2:) == xx(:nx-1)))
      else
         xstat = 0.0_dp
      end if
   case (stat_labels(nchgd))
      if (nx > 1) then
         xstat = dble(count(xx(2:) /= xx(:nx-1)))
      else
         xstat = 0.0_dp
      end if
   case (stat_labels(nperc_01)) ; xstat = percentile(0.01_dp,xx)
   case (stat_labels(nperc_05)) ; xstat = percentile(0.05_dp,xx)
   case (stat_labels(nperc_10)) ; xstat = percentile(0.10_dp,xx)
   case (stat_labels(nperc_25)) ; xstat = percentile(0.25_dp,xx)
   case (stat_labels(nperc_50)) ; xstat = percentile(0.50_dp,xx)
   case (stat_labels(nperc_75)) ; xstat = percentile(0.75_dp,xx)
   case (stat_labels(nperc_90)) ; xstat = percentile(0.90_dp,xx)
   case (stat_labels(nperc_95)) ; xstat = percentile(0.95_dp,xx)
   case (stat_labels(nperc_99)) ; xstat = percentile(0.99_dp,xx)
   case (stat_labels(nmean_01)) ; xstat = expectile(0.01_dp,xx)
   case (stat_labels(nmean_05)) ; xstat = expectile(0.05_dp,xx)
   case (stat_labels(nmean_10)) ; xstat = expectile(0.10_dp,xx)
   case (stat_labels(nmean_25)) ; xstat = expectile(0.25_dp,xx)
   case (stat_labels(nmean_50)) ; xstat = expectile(0.50_dp,xx)
   case (stat_labels(nmean_75)) ; xstat = expectile(0.75_dp,xx)
   case (stat_labels(nmean_90)) ; xstat = expectile(0.90_dp,xx)
   case (stat_labels(nmean_95)) ; xstat = expectile(0.95_dp,xx)
   case (stat_labels(nmean_99)) ; xstat = expectile(0.99_dp,xx)
   case (stat_labels(iiobs_year)); xstat = obs_per_year
   case (stat_labels(iisharpe_01))
      xdiv = expectile(0.01_dp,xx)
      if (xdiv < -tiny_real) then
         xstat = sqrt(obs_per_year)*mean(xx)/(-xdiv)
      else
         xstat = 0.0_dp
      end if
   case (stat_labels(iisharpe_05))
      xdiv = expectile(0.05_dp,xx)
      if (xdiv < -tiny_real) then
         xstat = sqrt(obs_per_year)*mean(xx)/(-xdiv)
      else
         xstat = 0.0_dp
      end if
   case (stat_labels(iisharpe_10))
      xdiv = expectile(0.10_dp,xx)
      if (xdiv < -tiny_real) then
         xstat = sqrt(obs_per_year)*mean(xx)/(-xdiv)
      else
         xstat = 0.0_dp
      end if
   case (stat_labels(iisharpe_25))
      xdiv = expectile(0.25_dp,xx)
      if (xdiv < -tiny_real) then
         xstat = sqrt(obs_per_year)*mean(xx)/(-xdiv)
      else
         xstat = 0.0_dp
      end if
   case (stat_labels(iisharpe_50))
      xdiv = expectile(0.50_dp,xx)
      if (xdiv < -tiny_real) then
         xstat = sqrt(obs_per_year)*mean(xx)/(-xdiv)
      else
         xstat = 0.0_dp
      end if
   case (stat_labels(iirange))
      xstat = maxval(xx) - minval(xx)
   case (stat_labels(iiminloc))
      xstat = dble(minloc(xx,dim=1))
   case (stat_labels(iimaxloc))
      xstat = dble(maxloc(xx,dim=1))
   case (stat_labels(iicagr_prices))
      xstat = cagr_prices(xx)
   case (stat_labels(iiwin_loss))
      xstat = win_loss(xx)
   case (stat_labels(iicagr_ret))
      xstat = cagr(xx)
   case (stat_labels(iimean_div_sd))
      xsd = sd(xx)
      if (xsd > 0.0_dp) then
         xstat = mean(xx)/xsd
      else
         xstat = bad_real
      end if
   case default
      write (*,*) "in stat_vec_str, no matching function for str_stat = '" // trim(str_stat) // "'"
      xstat = bad
end select
end function stat_vec_str
!
pure function num_wgt(xx) result(xstat)
! effective number of weights in xx(:)
! if all values of xx(:) are the same and nonzere, num_wgt = size(xx)
! if exactly one element of xx is nonzero, num_wgt = 1
real(kind=dp), intent(in) :: xx(:)
real(kind=dp)             :: xstat
real(kind=dp)             :: xsum
xsum  = sum(xx**2)
if (xsum > 0.0_dp) then
   xstat = (sum(xx)**2)/xsum
else
   xstat = 0.0_dp
end if
end function num_wgt
!
function change(xx) result(yy)
real(kind=dp), intent(in) :: xx(:)
real(kind=dp)             :: yy
integer                   :: n
n = size(xx)
if (n > 1) then
   yy = xx(n) - xx(1)
else
   yy = 0.0_dp
end if
end function change
!
function percent_change(xx) result(yy)
real(kind=dp), intent(in) :: xx(:)
real(kind=dp)             :: yy
integer                   :: n
n = size(xx)
if (n > 1) then
   yy = 100.0_dp * (xx(n)-xx(1)) / xx(1)
else
   yy = 0.0_dp
end if
end function percent_change
!
pure function vol_rms(xx) result(yy)
real(kind=dp), intent(in) :: xx(:)
real(kind=dp)             :: yy
yy = sqrt(obs_per_year)*rms(xx)
end function vol_rms
!
function frequency_changes(xx) result(freq)
real(kind=dp), intent(in) :: xx(:)
real(kind=dp)             :: freq
integer                   :: n
n = size(xx)
if (n < 2) then
   freq = 0.0_dp
   return
end if
freq = count(abs(xx(2:)-xx(:n-1)) > tiny_real)/(n-1.0_dp)
end function frequency_changes
!
function frequency_changes_rows(xx) result(freq)
! determine how often rows of a matrix differ from the previous row
real(kind=dp), intent(in) :: xx(:,:)
real(kind=dp)             :: freq
integer                   :: i,n,nch
n = size(xx,1)
nch = 0
if (n < 2) then
   freq = 0.0_dp
   return
end if
do i=2,n
   if (any(abs(xx(i,:)-xx(i-1,:)) > tiny_real)) nch = nch + 1
end do
freq = nch/(n-1.0_dp)
end function frequency_changes_rows
!
function num_sign_changes_real(xx) result(nchanges)
! count the # of sign changes for consecutive elements of xx(:)
real(kind=dp), intent(in) :: xx(:)
integer                   :: nchanges
nchanges = num_changes_tf(xx > 0.0_dp)
end function num_sign_changes_real
!
function num_changes_int(ivec) result(nchanges)
! count # of changes
integer, intent(in) :: ivec(:)
integer             :: nchanges
integer             :: n
n = size(ivec)
if (n < 2) then
   nchanges = 0
else
   nchanges = count(ivec(2:n) /= ivec(1:n-1))
end if
end function num_changes_int
!
function num_changes_real(xx) result(nchanges)
! count # of changes in xx(:)
real(kind=dp), intent(in) :: xx(:)
integer             :: nchanges
integer             :: n
n = size(xx)
if (n < 2) then
   nchanges = 0
else
   nchanges = count(xx(2:n) /= xx(1:n-1))
end if
end function num_changes_real
!
function num_changes_tf(tf) result(nchanges)
! count # of switches from true to false and vice versa
logical, intent(in) :: tf(:)
integer             :: nchanges
integer             :: n
n = size(tf)
if (n < 2) then
   nchanges = 0
else
   nchanges = count(tf(2:n) .neqv. tf(1:n-1))
end if
end function num_changes_tf
!
pure function sharpe(xx,obs_year) result(xsh)
! compute the Sharpe ratio (mean/sd) of set of returns -- use module variable obs_per_year to annualize
real(kind=dp), intent(in) :: xx(:)
real(kind=dp), intent(in), optional :: obs_year
real(kind=dp)             :: xsh
real(kind=dp)             :: xsd
xsd = sd(xx)
if(xsd > tiny_real) then
   xsh = sqrt(default(obs_per_year,obs_year))*mean(xx)/xsd
else
   xsh = zero
end if
end function sharpe
!
function sharpe_adj(xx,obs_year) result(xsh)
! Sharpe ratio adjusted for skewness and kurtosis
real(kind=dp), intent(in) :: xx(:)
real(kind=dp), intent(in), optional :: obs_year
real(kind=dp)             :: xsh
real(kind=dp)             :: xsd,xsh_obs
xsd = sd(xx)
if (xsd <= tiny_real) then
   xsh = zero
   return
end if
xsh_obs = mean(xx)/xsd
xsh = sqrt(default(obs_per_year,obs_year)) * xsh_obs * (1 + (skew(xx)/6)*xsh_obs - (kurtosis(xx)/24)*xsh_obs**2)
end function sharpe_adj
!
function sharpe_monthly(xx) result(xsh)
! compute the Sharpe ratio (mean/sd) of set of monthly returns
real(kind=dp), intent(in) :: xx(:)
real(kind=dp)             :: xsh
real(kind=dp)             :: xsd
xsd = sd(xx)
if(xsd > tiny_real) then
   xsh = sqrt(dble(months_per_year))*mean(xx)/xsd
else
   xsh = zero
end if
end function sharpe_monthly
!
function semisharpe(xx,xtarget) result(xsh)
! compute the Sharpe ratio (mean/sd) of set of returns -- use module variable obs_per_year to annualize
real(kind=dp), intent(in)           :: xx(:)
real(kind=dp), intent(in), optional :: xtarget
real(kind=dp)                       :: xsh
real(kind=dp)                       :: semisd,xmean ! ,xtarget_
xmean = mean(xx)
! if (present(xtarget)) then
!    xtarget_ = xtarget
! else
!    xtarget_ = xmean
! end if
! print*,"xtarget_=",xtarget_
! semisd = semidev(xx,xtarget_)
semisd = semidev(xx)
! print*,"semisd=",semisd
if (semisd > tiny_real) then
   xsh = sqrt(obs_per_year)*xmean/(2*semisd)
else
   xsh = zero
end if
end function semisharpe
!
function stats_ex_nan(str_stat,xx) result(xstat)
character (len=*), intent(in) :: str_stat(:)
real(kind=dp)    , intent(in) :: xx(:)
real(kind=dp)                 :: xstat(size(str_stat))
xstat = stat_vec_str_many(str_stat,pack(xx,.not. isnan(xx)))
end function stats_ex_nan
!
function stat_vec_str_many(str_stat,xx,nacf) result(xstat)
! compute statistics for xx(:)
character (len=*), intent(in) :: str_stat(:)
real(kind=dp)    , intent(in) :: xx(:)
integer          , intent(in), optional :: nacf
real(kind=dp)    , allocatable :: xstat(:)
! real(kind=dp)                 :: xstat(size(str_stat))
integer                       :: i,nstat,nacf_
nstat = size(str_stat)
nacf_ = max(0,default(0,nacf))
allocate (xstat(nstat+nacf_))
do i=1,nstat
   xstat(i) = stat_vec_str(str_stat(i),xx)
end do
if (nacf_ > 0) xstat(nstat+1:nstat+nacf_) = acf_vec(xx,nacf)
end function stat_vec_str_many
!
pure function mean_by_row(xx) result(xmean)
! compute the mean of each column of a matrix
real(kind=dp), intent(in) :: xx(:,:)
real(kind=dp)             :: xmean(size(xx,1))
integer                   :: i,nrow
nrow = size(xx,1)
do i=1,nrow
   xmean(i) = mean(xx(i,:))
end do
end function mean_by_row
!
pure function mean_by_col(xx) result(xmean)
! compute the mean of each column of a matrix
real(kind=dp), intent(in) :: xx(:,:)
real(kind=dp)             :: xmean(size(xx,2))
integer                   :: i,ncol
ncol = size(xx,2)
do i=1,ncol
   xmean(i) = mean(xx(:,i))
end do
end function mean_by_col
!
pure function sd_by_col(xx) result(xsd)
! compute the sd of each column of a matrix
real(kind=dp), intent(in) :: xx(:,:)
real(kind=dp)             :: xsd(size(xx,2))
integer                   :: i,ncol
ncol = size(xx,2)
do i=1,ncol
   xsd(i) = sd(xx(:,i))
end do
end function sd_by_col
!
pure function sharpe_by_col(xx) result(xsharpe)
! compute the sharpe ratio of each column of a matrix
real(kind=dp), intent(in) :: xx(:,:)
real(kind=dp)             :: xsharpe(size(xx,2))
integer                   :: i,ncol
ncol = size(xx,2)
do i=1,ncol
   xsharpe(i) = sharpe(xx(:,i))
end do
end function sharpe_by_col
!
pure function mean_2d(xx) result(xmean)
! compute the mean of xx(:,:)
real(kind=dp), intent(in) :: xx(:,:)
real(kind=dp)             :: xmean
integer                   :: n
n = size(xx)
if (n > 0) then
   xmean = sum(xx)/n
else
   xmean = 0.0
end if
end function mean_2d
!
pure function mean_3d(xx) result(xmean)
! compute the mean of xx(:,:,:)
real(kind=dp), intent(in) :: xx(:,:,:)
real(kind=dp)             :: xmean
integer                   :: n
n = size(xx)
if (n > 0) then
   xmean = sum(xx)/n
else
   xmean = 0.0
end if
end function mean_3d
!
pure function geo_mean(xx) result(xmean)
! compute the mean of xx(:)
real(kind=dp), intent(in) :: xx(:)
real(kind=dp)             :: xmean
integer                   :: nuse
logical                   :: positive(size(xx))
positive = xx > 0.0_dp
nuse     = count(positive)
if (nuse < 1) then
   xmean = 1.0_dp
   return
else
   xmean = exp(sum(log(pack(xx,positive)))/nuse)
end if
end function geo_mean
!
pure function range(xx) result(xrange)
! compute the range of xx(:)
real(kind=dp), intent(in) :: xx(:)
real(kind=dp)             :: xrange
integer                   :: n
n = size(xx)
if (n > 1) then
   xrange = maxval(xx) - minval(xx)
else
   xrange = 0.0_dp
end if
end function range
!
pure function range_mean(xx) result(xrange)
! compute the mean of ranges extending to the end of xx(:)
real(kind=dp), intent(in) :: xx(:)
real(kind=dp)             :: xrange
integer                   :: i,n
n = size(xx)
xrange = 0.0_dp
if (n < 2) return
do i=1,n-1
   xrange = xrange + range(xx(i:))
end do
xrange = xrange/(n-1)
end function range_mean
!
pure function mean(xx) result(xmean)
! compute the mean of xx(:)
real(kind=dp), intent(in) :: xx(:)
real(kind=dp)             :: xmean
integer                   :: n
n = size(xx)
if (n > 0) then
   xmean = sum(xx)/n
else
   xmean = 0.0_dp
end if
end function mean
!
pure function mean_int(ivec) result(xmean)
! compute the mean of xx(:)
integer      , intent(in) :: ivec(:)
real(kind=dp)             :: xmean
integer                   :: n
n = size(ivec)
if (n > 0) then
   xmean = dble(sum(ivec))/n
else
   xmean = 0.0_dp
end if
end function mean_int
!
pure function bin_12(xx,x1,x2) result(ibin)
! find the bin defined by x1(i) and x2(i) to which xx belongs
real(kind=dp), intent(in) :: xx
real(kind=dp), intent(in) :: x1(:),x2(:)
integer                   :: i,ibin,nbins
nbins = size(x1)
if (size(x2) /= nbins) then
   ibin = -1
else
   ibin = 0
end if
do i=1,nbins
   if (xx >= x1(i) .and. xx < x2(i)) then
      ibin = i
      exit
   end if
end do
end function bin_12
!
pure function bin_means(xthresh,xx,yy) result(ymean)
real(kind=dp), intent(in) :: xthresh(:)
real(kind=dp), intent(in) :: xx(:)
real(kind=dp), intent(in) :: yy(:)
real(kind=dp)             :: ymean(size(xthresh)+1)
integer                   :: i,n,nthresh
n       = size(xx)
nthresh = size(xthresh)
if (size(yy) /= n .or. nthresh < 1) return
ymean(1) = mean(pack(yy,xx<xthresh(1)))
do i=1,nthresh-1
   ymean(i+1) = mean(pack(yy,xx>=xthresh(i) .and. xx<xthresh(i+1)))
end do
ymean(nthresh+1) = mean(pack(yy,xx>=xthresh(nthresh)))
end function  bin_means
!
function bin_stats(cstats,xthresh,xx,yy) result(ystats)
character (len=*), intent(in) :: cstats(:)
real(kind=dp), intent(in) :: xthresh(:)
real(kind=dp), intent(in) :: xx(:)
real(kind=dp), intent(in) :: yy(:)
real(kind=dp)             :: ystats(size(xthresh)+1,size(cstats))
integer                   :: i,n,nthresh
n       = size(xx)
nthresh = size(xthresh)
if (size(yy) /= n .or. nthresh < 1) return
ystats(1,:) = stats(cstats,pack(yy,xx<xthresh(1)))
do i=1,nthresh-1
   ystats(i+1,:) = stats(cstats,pack(yy,xx>=xthresh(i) .and. xx<xthresh(i+1)))
end do
ystats(nthresh+1,:) = stats(cstats,pack(yy,xx>=xthresh(nthresh)))
end function bin_stats
!
pure function bin_freq(xthresh,xx) result(nfreq)
! return the frequencies of observations of xx(:) in bins defined by xthresh(:)
real(kind=dp), intent(in) :: xthresh(:)
real(kind=dp), intent(in) :: xx(:)
integer                   :: nfreq(size(xthresh)+1)
integer                   :: i,n,nthresh
n       = size(xx)
nthresh = size(xthresh)
if (nthresh == 0) then
   nfreq = n
   return
end if
nfreq(1) = count(xx<xthresh(1))
do i=1,nthresh-1
   nfreq(i+1) = count(xx>=xthresh(i) .and. xx<xthresh(i+1))
end do
nfreq(nthresh+1) = count(xx>=xthresh(nthresh))
end function  bin_freq
!
pure function bin_prob(xthresh,xx) result(prob)
! return the frequencies of observations of xx(:) in bins defined by xthresh(:)
real(kind=dp), intent(in) :: xthresh(:)
real(kind=dp), intent(in) :: xx(:)
real(kind=dp)             :: prob(size(xthresh)+1)
prob = bin_freq(xthresh,xx)/real(max(1,size(xx)),kind=dp)
end function bin_prob
!
subroutine print_bin_freq(xthresh,xx,outu,fmt_header)
real(kind=dp)    , intent(in)           :: xthresh(:)
real(kind=dp)    , intent(in)           :: xx(:)
integer          , intent(in), optional :: outu
character (len=*), intent(in), optional :: fmt_header
integer                                 :: i,nthresh,outu_,nfreq
logical                                 :: print_zero_counts_
! print*,"entered print_bin_freq" !! debug
print_zero_counts_ = .false.
outu_ = default(istdout,outu)
nthresh = size(xthresh)
if (nthresh == 0) return
call write_format(fmt_header,outu_)
write (outu_,"(2a10,1x,a10)") ">=min","<max","#"
nfreq = count(xx<xthresh(1))
if (print_zero_counts_ .or. nfreq > 0) write (outu_,"(10x,f10.4,1x,i10)") xthresh(1),nfreq
do i=1,nthresh-1
   nfreq = count(xx>=xthresh(i) .and. xx<xthresh(i+1))
   if (print_zero_counts_ .or. nfreq > 0) write (outu_,"(2f10.4,1x,i10)") xthresh([i,i+1]),nfreq
end do
nfreq = count(xx>=xthresh(nthresh))
if (print_zero_counts_ .or. nfreq > 0) write (outu_,"(f10.4,10x,1x,i10)") xthresh(nthresh),nfreq
end subroutine print_bin_freq
!
pure function rms(xx) result(xrms)
! compute the root-mean-squared value of xx
real(kind=dp), intent(in) :: xx(:)
real(kind=dp)             :: xrms
integer                   :: n
n = size(xx)
if (n > 0) then
   xrms = sqrt(sum(xx**2)/n)
else
   xrms = -1.0
end if 
end function rms
!
pure function rms_ema(xx,lambda) result(xrms)
! compute the exponentially weighted root-mean-squared value of xx
real(kind=dp), intent(in) :: xx(:)
real(kind=dp), intent(in) :: lambda ! geometric decay factor -- 0.94 for Riskmetrics
real(kind=dp)             :: xrms
real(kind=dp)             :: xsq
integer                   :: i,n
if (abs(lambda - 1.0_dp) < 1.0d-10) then
   xrms = rms(xx)
   return
end if
n = size(xx)
if (n < 1) then
   xrms = -1.0_dp
   return
end if
xsq = xx(1)**2
do i=2,n
   xsq = lambda*xsq + (1-lambda)*xx(i)**2
end do
xrms = sqrt(xsq)
end function rms_ema
!
pure function ema_rolling(xx,lambda) result(xma)
real(kind=dp), intent(in) :: xx(:)
real(kind=dp), intent(in) :: lambda ! geometric decay factor -- 0.94 for Riskmetrics
real(kind=dp)             :: xma(size(xx))
integer                   :: i,n
n = size(xx)
if (n < 1) return
xma(1) = xx(1)
do i=2,n
   xma(i) = lambda*xma(i-1) + (1-lambda)*xx(i)
end do
end function ema_rolling
!
pure function vol_rms_ema_rolling(xx,lambda) result(xvol)
real(kind=dp), intent(in) :: xx(:)
real(kind=dp), intent(in) :: lambda ! geometric decay factor -- 0.94 for Riskmetrics
real(kind=dp)             :: xvol(size(xx))
xvol = sqrt(obs_per_year*ema_rolling(xx**2,lambda))
end function vol_rms_ema_rolling
!
pure function vol_rms_ema(xx,lambda) result(yy)
real(kind=dp), intent(in) :: xx(:)
real(kind=dp), intent(in) :: lambda ! geometric decay factor -- 0.94 for Riskmetrics
real(kind=dp)             :: yy
yy = sqrt(obs_per_year)*rms_ema(xx,lambda)
end function vol_rms_ema
!
pure function sd(xx,xmean) result(xsd)
! compute the standard deviation of xx(:)
real(kind=dp), intent(in) :: xx(:)
real(kind=dp), intent(in), optional :: xmean
real(kind=dp)             :: xsd
real(kind=dp)             :: xmean_
integer                   :: n
n = size(xx)
if (n > 1) then   
   if (present(xmean)) then
      xmean_ = xmean
   else
      xmean_ = sum(xx)/n
   end if
   xsd   = sqrt(sum((xx-xmean_)**2)/(n-1))
else
   xsd = -1.0
end if 
end function sd
!
pure function variance(xx) result(xvar)
! compute the variance of xx(:)
real(kind=dp), intent(in) :: xx(:)
real(kind=dp)             :: xvar
real(kind=dp)             :: xmean
integer                   :: n
n = size(xx)
if (n > 1) then   
   xmean  = sum(xx)/n
   xvar   = sum((xx-xmean)**2)/(n-1)
else
   xvar = -1.0
end if 
end function variance
!
pure function sd_general(xx,xmean,wgt) result(xsd)
! compute sd with or without a fixed mean, weighting
real(kind=dp), intent(in)           :: xx(:)
real(kind=dp), intent(in), optional :: xmean
real(kind=dp), intent(in), optional :: wgt(:)
real(kind=dp)                       :: xsd
if (present(wgt)) then
   xsd = sd_weighted(xx,wgt,present(xmean),xmean)
else
   if (present(xmean)) then
      xsd = sd_fixed_mean(xx,xmean)
   else
      xsd = sd(xx)
   end if
end if
end function sd_general
!
pure function sd_fixed_mean(xx,xmean) result(xsd)
! compute the standard deviation of xx(:), with mean xmean assumed known
real(kind=dp), intent(in) :: xx(:)  ! data for which standard deviation is to be calculated
real(kind=dp), intent(in) :: xmean  ! known mean of xx(:)
real(kind=dp)             :: xsd
integer                   :: n
n = size(xx)
if (n > 0) then   
   xsd   = sqrt(sum((xx-xmean)**2)/n)
else
   xsd = -1.0
end if 
end function sd_fixed_mean
!
pure function sd_weighted(xx,wgt,use_fixed_mean,fixed_mean) result(xsd)
! compute the standard deviation of xx(:) -- wrapper for sd_fixed_mean_wgt and sd_wgt
real(kind=dp), intent(in) :: xx(:)  ! data for which standard deviation is to be calculated
real(kind=dp), intent(in) :: wgt(:) ! weights on observations in xx(:) to use in computing sd
logical      , intent(in) :: use_fixed_mean
real(kind=dp), intent(in), optional :: fixed_mean
real(kind=dp)                       :: xsd
real(kind=dp)                       :: xmean
if (use_fixed_mean) then
   if (present(fixed_mean)) then
      xmean = fixed_mean
   else
      xmean = 0.0_dp
   end if
   xsd = sd_fixed_mean_wgt(xx,xmean,wgt)
else
   xsd = sd_wgt(xx,wgt)
end if
end function sd_weighted
!
pure function sd_fixed_mean_wgt(xx,xmean,wgt) result(xsd)
! compute the standard deviation of xx(:), with mean xmean assumed known
real(kind=dp), intent(in) :: xx(:)  ! data for which standard deviation is to be calculated
real(kind=dp), intent(in) :: xmean  ! known mean of xx(:)
real(kind=dp), intent(in) :: wgt(:) ! weights on observations in xx(:) to use in computing sd
real(kind=dp)             :: xsd
real(kind=dp)             :: ww(size(xx)),wsum
integer                   :: imax,n,nw
nw = size(wgt)
n  = size(xx)
if (n < 1) then
   xsd = -1.0
   return
end if
imax       = min(n,nw)
ww         = 0.0_dp
ww(1:imax) = wgt(1:imax)
wsum = sum(ww)
if (wsum > 0.0_dp) then
   ww = ww/wsum
else
   xsd = -2.0
   return
end if
xsd        = sqrt(sum(ww*(xx-xmean)**2))
end function sd_fixed_mean_wgt
!
pure function semidev(xx,xtarget) result(xsd)
! compute the semideviation
real(kind=dp), intent(in)           :: xx(:)
real(kind=dp), intent(in), optional :: xtarget
real(kind=dp)                       :: xsd
real(kind=dp)                       :: xtarget_
integer                             :: n
if (present(xtarget)) then
   xtarget_ = xtarget
else
   xtarget_ = 0.0_dp
end if
n = size(xx)
if (n > 1) then
   xsd = sqrt(sum(max(xtarget_ - xx,0.0_dp)**2)/n)
else
   xsd = -1.0_dp
end if
end function semidev
!
function sd_asymm(xx,casymm,xmean,wgt) result(xsd)
! compute an asymmetric standard deviation of xx(:), with mean xmean assumed known
real(kind=dp), intent(in)           :: xx(:)  ! data for which standard deviation is to be calculated
real(kind=dp), intent(in), optional :: casymm 
real(kind=dp), intent(in), optional :: xmean  ! known mean of xx(:)
real(kind=dp), intent(in), optional :: wgt(:) ! weights on observations in xx(:) to use in computing sd
real(kind=dp)             :: xsd
real(kind=dp)             :: ww(size(xx)),wsum,xmean_,xsdsq
integer                   :: imax,n,ndiv,nw
logical                   :: symmetric
symmetric = .false.
if (.not. present(casymm)) then
   symmetric = .true.
else if (abs(casymm) < 1.0d-10) then
   symmetric = .true.
end if
if (symmetric) then
   xsd = sd_general(xx,xmean,wgt)
   return
end if   
n  = size(xx)
if (n < 1) then
   xsd = -1.0
   return
end if
if (present(xmean)) then
   xmean_ = xmean
   ndiv   = n
else
   xmean_ = sum(xx)/n
   ndiv   = n-1
end if
! print*,"in sd_asymm, xmean_, ndiv =",xmean_,ndiv ! debug
! print*,"casymm =",casymm," xx =",xx
if (present(wgt)) then
   nw         = size(wgt)
   imax       = min(n,nw)
   ww         = 0.0_dp
   ww(1:imax) = wgt(1:imax)
   wsum = sum(ww)
   if (wsum > 0.0_dp) then
      ww = ww/wsum
   else
      xsd = -2.0
      return
   end if
   xsdsq = sum((1-casymm+2*casymm*merge(1.0_dp,0.0_dp,xx>xmean_))*ww*(xx-xmean_)**2)
else
   xsdsq = sum((1-casymm+2*casymm*merge(1.0_dp,0.0_dp,xx>xmean_))*(xx-xmean_)**2)/ndiv
!   print*,"xsdsq =",xsdsq ! debug
end if
if (xsdsq > 0.0_dp) then
   xsd = sqrt(xsdsq)
else
   xsd = xsdsq
end if
end function sd_asymm
!
pure function sd_wgt(xx,wgt) result(xsd)
! compute the standard deviation of xx(:) with weights wgt(:)
real(kind=dp), intent(in) :: xx(:)  ! data for which standard deviation is to be calculated
real(kind=dp), intent(in) :: wgt(:) ! weights on observations in xx(:) to use in computing sd
real(kind=dp)             :: xsd
real(kind=dp)             :: ww(size(xx)),wsum,xmean
integer                   :: imax,n,nw
nw = size(wgt)
n  = size(xx)
if (n < 1) then
   xsd = -1.0
   return
end if
imax       = min(n,nw)
ww         = 0.0_dp
ww(1:imax) = wgt(1:imax)
wsum       = sum(ww)
if (wsum > 0.0_dp) then ! compute normalized weights ww
   ww = ww/wsum
else
   xsd = -2.0
   return
end if
xmean = sum(ww*xx)
xsd   = sum(ww*(xx-xmean)**2) * (nw/(nw-1.0d0))
if (xsd > zero) xsd = sqrt(xsd)
end function sd_wgt
!
pure function skew(xx) result(xsk)
! compute the skewness of xx(:) using the 3rd centered moment
real(kind=dp), intent(in) :: xx(:)
real(kind=dp)             :: xsk
real(kind=dp)             :: xsd,xmean
integer                   :: n
n = size(xx)
xsk = zero
if (n < 2) return
xmean = sum(xx)/n
xsd   = sqrt(sum((xx-xmean)**2)/(n-1))
if (xsd < tiny_real) return
xsk   = sum((xx-xmean)**3)/((n-1)*xsd**3)
end function skew
!
pure function kurtosis(xx) result(xkurt)
! compute the kurtosis of xx(:) using the 4th centered moment -- normal distribution has zero kurtosis
real(kind=dp), intent(in) :: xx(:)
real(kind=dp)             :: xkurt
real(kind=dp)             :: xsd,xmean
integer                    :: n
n = size(xx)
xkurt = zero
if (n < 2) return
xmean = sum(xx)/n
xsd   = sqrt(sum((xx-xmean)**2)/(n-1))
if (xsd < tiny_real) return
xkurt = sum((xx-xmean)**4)/((n-1)*xsd**4) - 3.0_dp ! subtract the kurtosis of the normal distribution
end function kurtosis
!
subroutine print_many_stats_vec(istat,xx,label,iu,fmt_stat,fmt_stat_labels)
! print several statistics for a vector, all in one line
integer          , intent(in)           :: istat(:)
real(kind=dp)    , intent(in)           :: xx(:)
character (len=*), intent(in)           :: label
integer          , intent(in), optional :: iu
character (len=*), intent(in), optional :: fmt_stat_labels
character (len=*), intent(in), optional :: fmt_stat
integer                                 :: iunit
character (len=100)                     :: fmt_s,fmt_sl
if (present(iu)) then
   iunit = iu
else
   iunit = istdout
end if
if (present(fmt_stat)) then
   fmt_s = fmt_stat
else
   fmt_s = "(1x,a10,100(1x,f10.4))"
end if
if (present(fmt_stat_labels)) then
   fmt_sl = fmt_stat_labels
else
   fmt_sl = "(/,100(1x,a10))"
end if
if (fmt_sl /= "") write (iunit,fmt_sl) "var",stat_labels(istat)
write (iunit,fmt_s) trim(label),stats(istat,xx)
end subroutine print_many_stats_vec
!
subroutine print_stats_ranges(cstats,xindep,thresh,xx,label,iu,outfile,fmt_stat,fmt_stat_labels, &
                              fmt_trailer,print_labels,csv,obs_year,xstats,fmt_header, &
                              binary_thresh,ranges,print_corr,print_last,print_stats_all, &
                              print_stats_indep,print_num_bin_changes,title,print_data,fmt_end,datu, &
                              cstats_indep)
! print stats on xx(:) for xindep(:) <= or > thresh
character (len=*), intent(in)           :: cstats(:) ! names of statistics to print
real(kind=dp)    , intent(in)           :: xindep(:) ! (n) independent variable
real(kind=dp)    , intent(in)           :: thresh(:) ! thresholds used to demarcate bins
real(kind=dp)    , intent(in)           :: xx(:)     ! (n) dependent variable
character (len=*), intent(in), optional :: label     ! label of independent variable
integer          , intent(in), optional :: iu        ! output unit
integer          , intent(in), optional :: datu      ! unit to which data printed if print_data is .true.
character (len=*), intent(in), optional :: fmt_stat_labels
character (len=*), intent(in), optional :: fmt_stat
character (len=*), intent(in), optional :: fmt_trailer,fmt_end
character (len=*), intent(in), optional :: outfile
logical          , intent(in), optional :: print_labels,print_stats_all,print_stats_indep,print_num_bin_changes,print_data
logical          , intent(in), optional :: csv
real(kind=dp)    , intent(in), optional :: obs_year
real(kind=dp)    , intent(in), optional :: xstats(:) ! if present, print these pre-computed statistics
character (len=*), intent(in), optional :: fmt_header,title
logical          , intent(in), optional :: binary_thresh,ranges,print_corr,print_last
character (len=*), intent(in), optional :: cstats_indep(:)
character (len=20), allocatable         :: cstats_indep_(:)
integer                                 :: i,n,isc,ithresh,outu,nthresh,nchanges,nzsc,ipow,nzpow,datu_
logical                                 :: first_call,xmask(size(xx)),print_stats_empty_bins_,print_corr_,print_last_, &
                                           print_stats_indep_,print_num_bin_changes_,csv_,print_num_obs_
character (len=20)                      :: label_thresh,label_
real(kind=dp)                           :: xindep_sd,xindep_zscore
real(kind=dp), allocatable              :: zz(:),zscale(:),zpow(:)
if (present(label)) then
   label_ = label
else
   label_ = "x"
end if
print_num_obs_ = .true.
if (present(cstats_indep)) then
   call set_alloc(cstats_indep,cstats_indep_)
else
   call set_alloc(["min","max"],cstats_indep_)
end if
! print*,"in print_stats_ranges, shape(thresh) =",shape(thresh) ! debug
csv_ = default(.false.,csv)
print_num_bin_changes_ = default(.false.,print_num_bin_changes)
print_stats_empty_bins_ = .false.
! print*,"entered print_stats_ranges" ! debug
print_corr_ = default(.false.,print_corr)
print_last_ = default(.false.,print_last)
print_stats_indep_ = default(.true.,print_stats_indep)
n = size(xx)
if (size(xindep) /= n) then
   write (*,*) "in print_stats_ranges, size(xindep), size(xx) =",size(xindep),n," must be equal, STOPPING"
   stop
end if
if (n < 1) return
nthresh = size(thresh)
outu = default(istdout,iu)
if (present(title)) then
   write (outu,"(a)") trim(title)
end if
if (present(fmt_header)) then
   write (outu,fmt_header)
end if
! if (print_corr_) 
if (print_corr_) then
   if (show_binary_corr) then
      call set_alloc(xindep/sd(xindep),zz)
      call set_alloc([0.001_dp,0.01_dp,0.1_dp,1.0_dp,3.0_dp,5.0_dp,10.0_dp,100.0_dp,1000.0_dp],zscale)
      call set_alloc([0.01_dp,0.5_dp,1.0_dp,1.5_dp,2.0_dp,2.5_dp,3.0_dp,5.0_dp,7.0_dp,10.0_dp,20.0_dp],zpow)
!     call set_alloc([real(kind=dp) ::],zscale) ! uncomment to avoid printing correlations of xindep to tanh(zscale*xx/xsd)
      nzsc  = size(zscale)
      nzpow = size(zpow)
      if (csv_) then
         write (outu,"('slope,corr,binary_corr',100(:,',corr_z_',f0.3))") zscale
         write (outu,"(100(f0.3,','))") slope(xindep,xx),correl(xindep,xx),correl(merge(-1.0_dp,1.0_dp,xindep<0),xx), &
                (correl(tanh(zscale(isc)*zz),xx),isc=1,nzsc),(correl(signed_power(zz,zpow(ipow)),xx),ipow=1,nzpow)
                 ! ,(correl(zz**3/(1+zscale(isc)**2),xx),isc=1,nzsc)
      else
         if (nzsc > 0) write (outu,"(27x,100a9)") ("tanh",isc=1,nzsc),("pow",ipow=1,nzpow)
         write (outu,"(3a9,100f9.3)") "slope","corr","bin_corr",zscale,zpow
         write (outu,"(100f9.3)") slope(xindep,xx),correl(xindep,xx),correl(merge(-1.0_dp,1.0_dp,xindep<0),xx), &
                (correl(tanh(zscale(isc)*zz),xx),isc=1,nzsc),(correl(signed_power(zz,zpow(ipow)),xx),ipow=1,nzpow)
               ! ,(correl(zz**3/(1+(zscale(isc)*zz)**2),xx),isc=1,nzsc)
      end if
   else
      write (outu,"('corr, slope =',2(1x,f0.3))") correl(xindep,xx),slope(xindep,xx)
   end if
end if
if (print_last_) then
   xindep_sd = sd(xindep) 
   if (xindep_sd > 0) then
      xindep_zscore = (xindep(n) - mean(xindep)) / xindep_sd
   else
      xindep_zscore = bad_real
   end if
   write (outu,"('last x, zscore(x), y =',100(1x,f0.4))") xindep(n),xindep_zscore,xx(n)
end if
if (print_stats_indep_) then
   if (csv_) then
      write (outu,"(a,/,100(',',f0.4))") "x,mean,sd,min,max",stats(["mean","sd  ","min ","max "],xindep)
   else
      write (outu,"(a,100(1x,f0.4))") "(mean, sd, min, max) x =",stats(["mean","sd  ","min ","max "],xindep)
   end if
end if
first_call = .true.
! print*,"(1) print_stats_ranges" ! debug
if (default(.true.,print_stats_all)) then
   call print_many_stats_vec_str(cstats,xx,"all",outu,outfile,fmt_stat,fmt_stat_labels, &
        fmt_trailer,first_call,csv,obs_year,xstats,xindep=xindep,cstats_indep=cstats_indep_, &
        print_num_obs=print_num_obs_)
end if
first_call = .false.
! print*,"(1.1) print_stats_ranges" ! debug
if (default(.false.,binary_thresh)) then
   do ithresh=1,nthresh
      write (label_thresh,"(a,'<=',f0.2)") trim(label_),thresh(ithresh)
      call print_many_stats_vec_str(cstats,pack(xx,xindep<=thresh(ithresh)),label_thresh, &
                       iu,outfile,fmt_stat,fmt_stat_labels, &
                       fmt_trailer,first_call,csv,obs_year,xstats, &
                       xindep=pack(xx,xindep<=thresh(ithresh)),cstats_indep=cstats_indep_, &
                       print_num_obs=print_num_obs_)
      write (label_thresh,"(a,'>',f0.2)") trim(label_),thresh(ithresh)
      call print_many_stats_vec_str(cstats,pack(xx,xindep>thresh(ithresh)),label_thresh,iu, &
           outfile,fmt_stat,fmt_stat_labels,fmt_trailer,first_call,csv,obs_year,xstats, &
           xindep=pack(xindep,xindep>thresh(ithresh)),cstats_indep=cstats_indep_, &
           print_num_obs=print_num_obs_)
   end do
end if
! print*,"(1.2) print_stats_ranges" ! debug
if (default(.true.,ranges)) then
   if (default(.false.,binary_thresh) .and. nthresh == 1) return
   ! print*,"(1.21) print_stats_ranges, thresh=",thresh ! debug
   if (print_num_bin_changes_ .and. nthresh > 0 .and. n > 1) then
      nchanges = num_bin_changes(xindep,thresh)
      write (outu,"('freq bin changes = ',i0,'/',i0,' = ',f0.3)") nchanges,n,nchanges/dble(max(1,n))
   end if
   do ithresh=0,nthresh
      ! print*,"(1.211) print_stats_ranges, ithresh=",ithresh,"size(thresh),bounds=", &
      !        size(thresh),lbound(thresh),ubound(thresh) ! debug
      if (nthresh > 0) then
         if (ithresh == 0) then
            ! print*,"(1.212) print_stats_ranges" ! debug
            xmask = xindep <= thresh(1)
            ! print*,"(1.2125) print_stats_ranges, thresh(1)=",thresh(1) ! debug
            write (label_thresh,"('<=',f0.1)") thresh(1)
            ! print*,"(1.213) print_stats_ranges, label_thresh = '" // trim(label_thresh) // "'"
         else if (ithresh == nthresh) then
            xmask = xindep >  thresh(nthresh)
            write (label_thresh,"('>',f0.1)") thresh(nthresh)
         else
            xmask = xindep > thresh(ithresh) .and. xindep <= thresh(ithresh+1)
            write (label_thresh,"(f0.1,':',f0.1)") thresh([ithresh,ithresh+1])
         end if
      else
         label_thresh = "all"
         xmask        = .true.
      end if
      ! print*,"(1.22) print_stats_ranges" ! debug
      if (print_stats_empty_bins_ .or. any(xmask)) &
         call print_many_stats_vec_str(cstats,pack(xx,xmask),label_thresh,iu,outfile,fmt_stat,fmt_stat_labels, &
              fmt_trailer,first_call,csv,obs_year,xstats,xindep=pack(xindep,xmask),cstats_indep=cstats_indep_, &
              print_num_obs=print_num_obs_)
   end do
end if
if (default(.false.,print_data)) then
   datu_ = default(outu,datu)
   if (csv_) then
      write (datu_,"(/,'i,x(i),y(i)')")
   else
      write (datu_,"(/,100a8)") "i","x(i)","y(i)"
   end if
   do i=1,n
      write (datu_,merge("(i0,2(',',f0.4))","(i8,2(1x,f12.4))",csv_)) i,xindep(i),xx(i)
   end do
end if
call write_format(fmt_end,iu)
! print*,"exited print_stats_ranges" ! debug
end subroutine print_stats_ranges
!
subroutine print_stats_quantiles(cstats,nquant,xindep,xx,label,iu,outfile,fmt_stat,fmt_stat_labels, &
                                 fmt_trailer,print_labels,csv,obs_year,xstats,fmt_header, &
                                 binary_thresh,ranges,print_corr,print_stats_all)
! print stats on xx(:) for the numbers of quantiles in nquant(:)
character (len=*), intent(in)           :: cstats(:)
real(kind=dp)    , intent(in)           :: xindep(:) ! ,thresh(:)
integer          , intent(in)           :: nquant(:)
real(kind=dp)    , intent(in)           :: xx(:)
character (len=*), intent(in)           :: label
integer          , intent(in), optional :: iu
character (len=*), intent(in), optional :: fmt_stat_labels
character (len=*), intent(in), optional :: fmt_stat
character (len=*), intent(in), optional :: fmt_trailer
character (len=*), intent(in), optional :: outfile
logical          , intent(in), optional :: print_labels,print_stats_all
logical          , intent(in), optional :: csv
real(kind=dp)    , intent(in), optional :: obs_year
real(kind=dp)    , intent(in), optional :: xstats(:) ! if present, print these pre-computed statistics
character (len=*), intent(in), optional :: fmt_header
logical          , intent(in), optional :: binary_thresh,ranges,print_corr
integer                                 :: inq,iu_,istat
if (present(iu)) then
   iu_ = iu
else
   iu_ = istdout
end if
! real(kind=dp), allocatable :: thresh(:)
do inq=1,size(nquant)   
   write (iu_,"('#bins,',i0,/,100(',',a))") nquant(inq) + 1,(trim(cstats(istat)),istat=1,size(cstats))
   call print_stats_ranges(cstats,xindep,percentiles(open_grid(nquant(inq),0.0_dp,1.0_dp),xindep),xx,label,iu,outfile, &
                           fmt_stat,fmt_stat_labels, &
                           fmt_trailer,print_labels,csv,obs_year,xstats,fmt_header, &
                           binary_thresh,ranges,print_corr,print_stats_all)
end do
end subroutine print_stats_quantiles
!
subroutine print_stats_bin_widths(cstats,widths,xindep,xx,label,iu,outfile,fmt_stat,fmt_stat_labels, &
                                  fmt_trailer,print_labels,csv,obs_year,xstats,fmt_header, &
                                  binary_thresh,ranges,print_corr,print_stats_all,indep_label, &
                                  fmt_header_indep,cstats_indep)
! print stats on xx(:) for bins with specified widths(:)
character (len=*), intent(in)           :: cstats(:)
real(kind=dp)    , intent(in)           :: xindep(:)
real(kind=dp)    , intent(in)           :: widths(:)
real(kind=dp)    , intent(in)           :: xx(:)
character (len=*), intent(in)           :: label
integer          , intent(in), optional :: iu
character (len=*), intent(in), optional :: fmt_stat_labels
character (len=*), intent(in), optional :: fmt_stat
character (len=*), intent(in), optional :: fmt_trailer
character (len=*), intent(in), optional :: outfile
logical          , intent(in), optional :: print_labels,print_stats_all
logical          , intent(in), optional :: csv
real(kind=dp)    , intent(in), optional :: obs_year
real(kind=dp)    , intent(in), optional :: xstats(:) ! if present, print these pre-computed statistics
character (len=*), intent(in), optional :: fmt_header
logical          , intent(in), optional :: binary_thresh,ranges,print_corr
character (len=*), intent(in), optional :: indep_label,fmt_header_indep
integer                                 :: iw,iu_,i1,i2,istat
character (len=20), allocatable         :: indep_label_,cstats_indep_(:)
character (len=*), intent(in), optional :: cstats_indep(:)
logical          , parameter            :: print_stats_indep_within_psr = .false.
if (present(indep_label)) then
   indep_label_ = indep_label
else
   indep_label_ = "indep"
end if
if (present(iu)) then
   iu_ = iu
else
   iu_ = istdout
end if
if (present(cstats_indep)) then
   cstats_indep_ = cstats_indep
else
   cstats_indep_ = cstats
end if
call print_stats(cstats_indep_,xindep,label=indep_label_,outfile=outfile,fmt_header=fmt_header_indep,csv=csv)
do iw=1,size(widths)
   if (widths(iw) <= 0.0_dp) cycle
   if (print_stats_indep_within_psr) &
      write (iu_,"('bin_width,',f0.3,/,100(',',a))") widths(iw),(trim(cstats(istat)),istat=1,size(cstats))
   i1 = int(minval(xindep)/widths(iw))
   i2 = int(maxval(xindep)/widths(iw))
   call print_stats_ranges(cstats,xindep,grid_min_max(i2-i1+1,i1*widths(iw),i2*widths(iw)),xx,label,iu,outfile, &
                           fmt_stat,fmt_stat_labels, &
                           fmt_trailer,print_labels,csv,obs_year,xstats,fmt_header, &
                           binary_thresh,ranges,print_corr,print_stats_all, &
                           print_stats_indep=print_stats_indep_within_psr)
end do
end subroutine print_stats_bin_widths
!
elemental function below(xx,xdiv) result(yy)
real(kind=dp), intent(in) :: xx,xdiv
real(kind=dp)             :: yy
if (xdiv /= 0.0_dp) then
   yy = int(xx/xdiv)*xdiv
else
   yy = xx
end if
end function below
!
function grid_min_max(n,xmin,xmax) result(xgrid)
! return evenly spaced grid between xmin and xmax, with points at both boundaries
integer      , intent(in) :: n
real(kind=dp), intent(in) :: xmin,xmax
real(kind=dp)             :: xgrid(n)
real(kind=dp)             :: xh
integer                   :: i
if (n < 1) return
xgrid(1) = xmin
if (n < 2) return
xgrid(n) = xmax
xh = (xmax - xmin)/(n-1)
do i=2,n-1
   xgrid(i) = xgrid(i-1) + xh
end do
end function grid_min_max
!
pure function open_grid(n,xmin,xmax) result(xx)
! uniform grid between xmin and xmax with points NOT
! placed at xmin or xmax
integer      , intent(in) :: n
real(kind=dp), intent(in) :: xmin,xmax
real(kind=dp)             :: xx(n)
real(kind=dp)             :: dx
integer                   :: i
if (n < 1) return
dx = (xmax - xmin)/(n+1)
forall (i=1:n) xx(i) = xmin + (i*dx)
end function open_grid
!
subroutine print_stats_vol_norm(cstats,xx,vol,powers,outu,fmt_header,fmt_trailer)
character (len=*), intent(in)           :: cstats(:)
real(kind=dp)    , intent(in)           :: xx(:),vol(:) ! (n)
real(kind=dp)    , intent(in), optional :: powers(:)
integer          , intent(in), optional :: outu
character (len=*), intent(in), optional :: fmt_header,fmt_trailer
real(kind=dp)    , allocatable          :: powers_(:)
integer                                 :: outu_,ipow,istat
call assert_equal("in print_stats_vol_norm, ",size(xx),size(vol))
outu_ = default(istdout,outu)
if (present(powers)) then
   call set_alloc(powers,powers_)
else
   call set_alloc([0.0_dp,0.5_dp,1.0_dp,1.5_dp,2.0_dp],powers_)
end if
call write_format(fmt_header,outu_)
write (*,"(a5,100a8)") "pow",(trim(cstats(istat)),istat=1,size(cstats))
do ipow=1,size(powers_)
   write (*,"(f5.2,100f8.3)") powers_(ipow),stats(cstats,xx/vol**powers_(ipow))
end do
call write_format(fmt_trailer,outu_)
end subroutine print_stats_vol_norm
!
subroutine print_many_stats_vec_str(cstats,xx,label,iu,outfile,fmt_stat,fmt_stat_labels, &
                                    fmt_trailer,print_labels,csv,obs_year,xstats,fmt_header,nacf, &
                                    xindep,cstats_indep,print_num_obs)
! print several statistics for vector xx(:), all in one line
character (len=*), intent(in)           :: cstats(:)   ! statistics to be printed for xx(:)
real(kind=dp)    , intent(in)           :: xx(:)       ! data for which statistics printed
real(kind=dp)    , intent(in), optional :: xindep(:)
character (len=*), intent(in)           :: label
integer          , intent(in), optional :: iu          ! unit to which output written
character (len=*), intent(in), optional :: fmt_stat_labels
character (len=*), intent(in), optional :: fmt_stat
character (len=*), intent(in), optional :: fmt_trailer
character (len=*), intent(in), optional :: outfile
logical          , intent(in), optional :: print_labels
logical          , intent(in), optional :: csv
real(kind=dp)    , intent(in), optional :: obs_year
real(kind=dp)    , intent(in), optional :: xstats(:) ! if present, print these pre-computed statistics
character (len=*), intent(in), optional :: fmt_header
integer          , intent(in), optional :: nacf
character (len=*), intent(in), optional :: cstats_indep(:)
logical          , intent(in), optional :: print_num_obs
character (len=20), allocatable         :: cstats_indep_(:)
logical                                 :: csv_,print_labels_,print_num_obs_
integer                                 :: i,iunit,ncstats,nacf_
character (len=100)                     :: fmt_s,fmt_sl
real(kind=dp)                           :: old_obs_per_year
character (len=*), parameter            :: msg=mod_str // "print_many_stats_vec_str, "
! print*,msg !! debug
print_num_obs_ = default(.false.,print_num_obs)
if (present(obs_year)) then
   old_obs_per_year = obs_per_year
   obs_per_year     = obs_year
end if
if (present(csv)) then
   csv_ = csv
else
   csv_ = .false.
end if
! print*,msg,"csv_=",csv_," present(xindep)=",present(xindep)," print_num_obs_=",print_num_obs_ !! debug
if (present(print_labels)) then
   print_labels_ = print_labels
else
   print_labels_ = .true.
end if
if (present(iu)) then
   iunit = iu
else
   if (present(outfile)) then
      call get_unit(iunit,outfile)
   else
      iunit = istdout
   end if
end if
! print*,"iunit=",iunit ! debug
if (present(fmt_stat)) then
   fmt_s = fmt_stat
else
   if (print_num_obs_) then
      fmt_s = merge("(a,',',i0,100(',',f0.4))     ", &
                    "(1x,a10,1x,i10,100(1x,f10.4))",csv_)
   else
      fmt_s = merge("(a,100(',',f0.4))     ", &
                    "(1x,a10,100(1x,f10.4))",csv_)
   end if
end if
if (present(fmt_stat_labels)) then
   fmt_sl = fmt_stat_labels
else
!   fmt_sl = merge("(/,100(a,',')) ","(/,100(1x,a10))",csv_)
   fmt_sl = merge("(100(a,',')) ","(100(1x,a10))",csv_)
end if
! write (*,"(a)") "fmt_sl = '" // trim(fmt_sl) // "'" !! debug
if (present(xindep)) then
   if (size(xindep) /= size(xx)) then
      print*,"size(xindep), size(xx) =",size(xindep),size(xx)," must be equal, RETURNING"
      return
   end if
   if (present(cstats_indep)) then
      call set_alloc(cstats_indep,cstats_indep_)
   else
      call set_alloc(["mean","sd  ","min ","max "],cstats_indep_)
   end if
else
   allocate (cstats_indep_(0))
end if
nacf_ = default(0,nacf)
ncstats = size(cstats)
if (nacf_ < 1 .and. ncstats < 1) return
if (present(fmt_header)) then
   if (fmt_header /= "") write (iunit,fmt_header)
end if
! print*,"(1) here, print_labels_=",print_labels_," print_num_obs_=",print_num_obs_," fmt_sl=",trim(fmt_sl) !! debug
if (print_labels_ .and. fmt_sl /= "") then
   if (print_num_obs_) then
      write (iunit,fmt_sl) "var","count", &
                           (trim("x_" // cstats_indep_(i)),i=1,size(cstats_indep_)), &
                           (trim(cstats(i)),i=1,ncstats),("ACF_" // trim(str_int(i)),i=1,nacf_)
   else
      write (iunit,fmt_sl) "var", &
                           (trim("x_" // cstats_indep_(i)),i=1,size(cstats_indep_)), &
                           (trim(cstats(i)),i=1,ncstats),("ACF_" // trim(str_int(i)),i=1,nacf_)
   end if
end if
! print*,"present(xindep),present(xstats)=",present(xindep),present(xstats) ! debug
if (present(xstats)) then
   if (size(xstats) /= ncstats) then
      write (*,*) msg,"size(xstats), size(cstats)=",size(xstats),ncstats," must be equal, STOPPING"
      stop
   end if
   if (present(xindep)) then
      write (iunit,fmt_s) trim(label),0,stats(cstats_indep_,xindep),xstats
   else
      write (iunit,fmt_s) trim(label),0,xstats
   end if
else
   if (present(xindep)) then
!      write (iunit,fmt_s) trim(label),size(xx),stats(cstats_indep_,xindep),stats(cstats,xx),acf_vec(xx,nacf_)
      if (csv_) then
         if (print_num_obs_) then
            fmt_s = "(a,',',i0,100(',',f0.4))"
         else
            fmt_s = "(a,100(',',f0.4))"
         end if
      else
         if (print_num_obs_) then
            fmt_s = "(a11,i11,100f11.4)"
         else
            fmt_s = "(a11,100f11.4)"
         end if
      end if
      if (print_num_obs_) then
         write (iunit,fmt_s) trim(label),size(xx),stats(cstats_indep_,xindep),stats(cstats,xx),acf_vec(xx,nacf_)
      else
         write (iunit,fmt_s) trim(label),stats(cstats_indep_,xindep),stats(cstats,xx),acf_vec(xx,nacf_)
      end if
   else
      if (print_num_obs_) then
         write (iunit,fmt_s) trim(label),size(xx),stats(cstats,xx),acf_vec(xx,nacf_)
      else
         write (iunit,fmt_s) trim(label),stats(cstats,xx),acf_vec(xx,nacf_)
      end if
   end if
end if
if (present(fmt_trailer)) then
   if (fmt_trailer /= "") write (iunit,fmt_trailer)
end if
if (present(obs_year)) obs_per_year = old_obs_per_year  
end subroutine print_many_stats_vec_str
!
subroutine print_stats_train_test(cstats,xx,itrain,itest,iu,outfile,fmt_stat,fmt_stat_labels, &
                                  fmt_trailer,print_labels,csv,obs_year,xstats,fmt_header,nacf,overall)
! print several statistics for vector xx(:), all in one line
character (len=*), intent(in)           :: cstats(:)   ! statistics to be printed for xx(:)
real(kind=dp)    , intent(in)           :: xx(:)       ! data for which statistics printed
integer          , intent(in)           :: itrain(:),itest(:)
integer          , intent(in), optional :: iu          ! unit to which output written
character (len=*), intent(in), optional :: fmt_stat_labels
character (len=*), intent(in), optional :: fmt_stat
character (len=*), intent(in), optional :: fmt_trailer
character (len=*), intent(in), optional :: outfile
logical          , intent(in), optional :: print_labels
logical          , intent(in), optional :: csv
real(kind=dp)    , intent(in), optional :: obs_year
real(kind=dp)    , intent(in), optional :: xstats(:) ! if present, print these pre-computed statistics
character (len=*), intent(in), optional :: fmt_header
integer          , intent(in), optional :: nacf
logical          , intent(in), optional :: overall
logical                                 :: overall_
overall_ = default(.false.,overall)
call write_format(fmt_header)
if (overall_) call print_stats(cstats,xx,label="overall",print_num_obs=.true.)
call print_stats(cstats,xx(itrain),label="train",print_num_obs=.true.,print_labels=.not. overall_)
call print_stats(cstats,xx(itest) ,label="test" ,print_num_obs=.true.,print_labels=.false.)
call write_format(fmt_trailer)
end subroutine print_stats_train_test
!
subroutine print_many_stats_matrix_col(istat,xx,labels,iu,fmt_stat,fmt_stat_labels,fmt_header,nacf)
! for each column of a matrix, print several statistics in one line
integer          , intent(in)           :: istat(:)
real(kind=dp)    , intent(in)           :: xx(:,:)
character (len=*), intent(in)           :: labels(:)
integer          , intent(in), optional :: iu,nacf
character (len=*), intent(in), optional :: fmt_stat_labels
character (len=*), intent(in), optional :: fmt_stat
character (len=*), intent(in), optional :: fmt_header
integer                                 :: i,iunit,nvar,iacf,nacf_
character (len=100)                     :: fmt_s,fmt_sl
character (len=*), parameter            :: msg = mod_str // "print_many_stats_matrix_col, "
real(kind=dp), allocatable              :: xacf(:,:)
if (size(xx,2) /= size(labels)) then
    write (*,*) msg,"size(xx,2), size(labels) =",size(xx,2), size(labels),"should be equal"
    return
end if
if (present(iu)) then
   iunit = iu
else
   iunit = istdout
end if
if (present(fmt_stat)) then
   fmt_s = fmt_stat
else
   fmt_s = "(1x,a10,100(1x,f10.4))"
end if
if (present(fmt_stat_labels)) then
   fmt_sl = fmt_stat
else
   fmt_sl = "(/,100(1x,a10))"
end if
if (present(fmt_header)) then
   if (fmt_header /= "") write (iunit,fmt_header)
end if
if (fmt_sl /= "") write (iunit,fmt_sl) "var",stat_labels(istat)
nvar = size(labels)
nacf_ = default(0,nacf)
do i=1,nvar
   write (iunit,fmt_s) trim(labels(i)),stats(istat,xx(:,i))
end do
if (nacf_ > 0) then
   allocate (xacf(nacf_,nvar))
   xacf = acf_mat(xx,nacf_)
   do iacf=1,nacf_
      write (iunit,fmt_s) "ACF",xacf(iacf,:)
   end do
end if
end subroutine print_many_stats_matrix_col
!
subroutine print_stats_tensor(cstats,xx,labels_2d,labels_3d,outu,fmt_stat,fmt_stat_labels,fmt_header,fmt_trailer, &
                              mask_rows,title,var_name,csv,outfile)
character (len=*), intent(in)           :: cstats(:)
real(kind=dp)    , intent(in)           :: xx(:,:,:) ! (n1,n2,n3)
character (len=*), intent(in)           :: labels_2d(:) ! (n2)
character (len=*), intent(in)           :: labels_3d(:) ! (n3)
integer          , intent(in), optional :: outu ! unit to which stats are written
character (len=*), intent(in), optional :: fmt_stat_labels
character (len=*), intent(in), optional :: fmt_stat
character (len=*), intent(in), optional :: fmt_header,fmt_trailer
logical          , intent(in), optional :: mask_rows(:)
character (len=*), intent(in), optional :: title
character (len=*), intent(in), optional :: var_name
logical          , intent(in), optional :: csv
character (len=*), intent(in), optional :: outfile
integer                                 :: i2,n2,n3
n2 = size(xx,2)
n3 = size(xx,3)
! print*,"entered print_stats_tensor, shape(xx) =",shape(xx) ! debug
if (size(labels_2d) /= n2 .or. size(labels_3d) /= n3) then
   write (*,*) "in print_stats_tensor, size(labels_2d), size(labels_3d) =",size(labels_2d),size(labels_3d), &
               "shape(xx) =",shape(xx),"need size(labels_2d) = size(xx,2) and size(labels_3d) = size(xx,3)"
   stop
end if
if (present(title)) write (outu,*) trim(title)
do i2=1,n2
   call print_stats_matrix(cstats,xx(:,i2,:),labels_3d,outu,fmt_stat,fmt_stat_labels,fmt_header,fmt_trailer,mask_rows, &
        "data set: " // labels_2d(i2),var_name,csv,outfile)
end do
end subroutine print_stats_tensor
!
subroutine print_stats_matrix(cstats,xx,labels,outu,fmt_stat,fmt_stat_labels,fmt_header,fmt_trailer, &
                              mask_rows,title,var_name,csv,outfile,stats_by_rows,obs_year,print_num_obs, &
                              good,nacf,print_corr,sd_min)
! for each column of a matrix, print several statistics in one line
character (len=*), intent(in)           :: cstats(:)
real(kind=dp)    , intent(in)           :: xx(:,:)
character (len=*), intent(in), optional :: labels(:)
integer          , intent(in), optional :: outu ! unit to which stats are written
integer          , intent(in), optional :: nacf
character (len=*), intent(in), optional :: fmt_stat_labels
character (len=*), intent(in), optional :: fmt_stat
character (len=*), intent(in), optional :: fmt_header,fmt_trailer
logical          , intent(in), optional :: mask_rows(:),good(:,:)
character (len=*), intent(in), optional :: title
character (len=*), intent(in), optional :: var_name
logical          , intent(in), optional :: csv,stats_by_rows
character (len=*), intent(in), optional :: outfile
real(kind=dp)    , intent(in), optional :: obs_year
logical          , intent(in), optional :: print_num_obs
logical          , intent(in), optional :: print_corr
real(kind=dp)    , intent(in), optional :: sd_min ! standard deviation of variable below which its statistics are not printed
real(kind=dp)                           :: old_obs_per_year
logical                                 :: csv_,print_num_obs_,print_corr_
integer                                 :: i,outunit,nvar,iacf,nacf_
character (len=100), allocatable        :: labels_(:)
character (len=100)                     :: fmt_s,fmt_sl,var_name_
character (len=*), parameter            :: msg = mod_str // "print_stats_matrix, "
real(kind=dp), allocatable              :: xacf(:,:)
logical      , parameter                :: newline_ = .false.
nacf_          = default(0,nacf)
nvar           = size(xx,2)
print_num_obs_ = default(.false.,print_num_obs)
print_corr_    = default(.false.,print_corr)
if (size(cstats) < 1 .and. nacf_ < 1 .and. .not. print_corr_ .and. .not. print_num_obs_) return
if (present(good)) then
   if (size(good,1) /= size(xx,1) .or. size(good,2) /= size(xx,2)) then
      write (*,*) "in print_stats_matrix, shape(xx)=",shape(xx)," shape(good)=",shape(good), &
                  "must be equal, RETURNING"
      return
   end if
end if
if (present(labels)) then
   if (size(labels) /= nvar) then
      write (*,*) msg,"size(xx,2), size(labels)=",nvar,size(labels)," must be equal, STOPPING"
      stop
   end if
   allocate (labels_(nvar))
   do i=1,nvar
      labels_(i) = labels(i)
   end do
else
   allocate (labels_(nvar))
   do i=1,nvar
      write (labels_(i),"(a,i0)") "x",i
   end do
end if
if (present(var_name)) then
   var_name_ = var_name
else
   var_name_ = "var"
end if
! if (size(cstats) == 0) return
if (present(outu)) then
   outunit = outu
else
   if (present(outfile)) then
      call get_unit(outunit)
   else
      outunit = istdout
   end if
end if
if (present(csv)) then
   csv_ = csv
else
   csv_ = (present(outfile) .or. outunit /= istdout)
end if
if (present(outfile)) then
   call get_unit(outunit,outfile)
!   open (unit=outunit,file=outfile,action="write")
end if
if (present(fmt_stat)) then
   fmt_s = fmt_stat
else
   if (csv_) then
      fmt_s = "(a,100(:,',',f0.6))"
   else
      fmt_s = "(1x,a20,100(1x,f10.4))"
   end if
end if
if (present(fmt_stat_labels)) then
   fmt_sl = fmt_stat_labels
else
   if (csv_) then
      fmt_sl = "(100(a,:,','))"
   else
      if (present(title) .or. present(fmt_header)) then
         fmt_sl = "(a20,100(1x,a10))"
      else
         fmt_sl = merge("(/,a20,100(1x,a10))","(a20,100(1x,a10))  ",newline_)
      end if
   end if
end if
if (present(fmt_header)) then
   if (fmt_header /= "") write (outunit,fmt_header)
end if
if (present(title)) write (outunit,*) trim(title)
if (present(obs_year)) then
   old_obs_per_year = obs_per_year
   obs_per_year     = obs_year
end if
if (print_num_obs_) write (outunit,merge("('#obs,',i0) ","('#obs: ',i0)",csv_)) size(xx,1)
if (size(cstats) < 1 .and. nacf_ < 1 .and. .not. print_corr_) return
if (default(.false.,stats_by_rows)) then
   if (csv_) then
      write (outunit,merge("(1000(',',a))     ","(a20,1000(1x,a10))",csv_)) &
             (trim(labels_(i)),i=1,nvar)
   else
      write (outunit,"(21x,1000(1x,a10))") (trim(labels_(i)),i=1,nvar)
   end if
   do i=1,size(cstats)
      write (outunit,fmt_s) trim(cstats(i)),stats(cstats(i),xx)
   end do
   if (nacf_ > 0) then
      allocate (xacf(nacf_,nvar))
      xacf = acf_mat(xx,nacf_)
      do iacf=1,nacf_
         write (outunit,fmt_s) "ACF_" // trim(str_int(iacf)),xacf(iacf,:)
      end do
   end if
else
   if (fmt_sl /= "") write (outunit,fmt_sl) trim(var_name_),(trim(cstats(i)),i=1,size(cstats)), &
                     ("ACF_" // trim(str_int(i)),i=1,nacf_)
   if (size(cstats) > 0 .or. nacf_ > 0) then
      do i=1,nvar
         if (present(sd_min)) then
            if (sd(xx(:,i)) < sd_min) cycle
         end if
         if (present(mask_rows)) then
            write (outunit,fmt_s) trim(labels_(i)),stats(cstats,pack(xx(:,i),mask_rows),nacf=nacf)
         else if (present(good)) then
            write (outunit,fmt_s) trim(labels_(i)),stats(cstats,pack(xx(:,i),good(:,i)),nacf=nacf)
         else
            write (outunit,fmt_s) trim(labels_(i)),stats(cstats,xx(:,i),nacf=nacf)
         end if
      end do
   end if
end if
if (print_corr_) call print_corr_mat(xx,labels,iunit=outu,csv=csv,fmt_header="(/,'CORRELATIONS')")
if (present(obs_year)) obs_per_year = old_obs_per_year 
if (present(fmt_trailer)) then
   if (fmt_trailer /= "") write (outunit,fmt_trailer)
end if
end subroutine print_stats_matrix
!
subroutine print_stats_panel(cstats,xx,labels_2,labels_3,outu,fmt_stat,fmt_stat_labels,fmt_header,fmt_trailer, &
                             mask_rows,title,var_name,csv,outfile,stats_by_rows,obs_year,print_num_obs)
character (len=*), intent(in)           :: cstats(:)
real(kind=dp)    , intent(in)           :: xx(:,:,:)
character (len=*), intent(in)           :: labels_2(:),labels_3(:)
integer          , intent(in), optional :: outu ! unit to which stats are written
character (len=*), intent(in), optional :: fmt_stat_labels
character (len=*), intent(in), optional :: fmt_stat
character (len=*), intent(in), optional :: fmt_header,fmt_trailer
logical          , intent(in), optional :: mask_rows(:)
character (len=*), intent(in), optional :: title
character (len=*), intent(in), optional :: var_name
logical          , intent(in), optional :: csv,stats_by_rows
character (len=*), intent(in), optional :: outfile
real(kind=dp)    , intent(in), optional :: obs_year
logical          , intent(in), optional :: print_num_obs
integer                                 :: i3
if (present(title)) write (default(istdout,outu),*) trim(title)
do i3=1,size(xx,3)
   call print_stats_matrix(cstats,xx(:,:,i3),labels_2,outu,fmt_stat,fmt_stat_labels,fmt_header,fmt_trailer, &
                           mask_rows,title=labels_3(i3),var_name=var_name,csv=csv,outfile=outfile, &
                           stats_by_rows=stats_by_rows,obs_year=obs_year,print_num_obs=print_num_obs)
end do
end subroutine print_stats_panel
!
subroutine print_computed_stats_matrix(cstats,xstats,labels,iu,fmt_stat,fmt_stat_labels,fmt_header,fmt_trailer, &
                                       title,var_name)
! branched from print_stats_matrix -- stats have already been computed
! for each column of a matrix, print several statistics in one line
character (len=*), intent(in)           :: cstats(:)   ! (nstats) -- names of stats computed
real(kind=dp)    , intent(in)           :: xstats(:,:) ! (nstats,nvar)
character (len=*), intent(in)           :: labels(:)   ! (nvar)   -- variable labels
integer          , intent(in), optional :: iu
character (len=*), intent(in), optional :: fmt_stat_labels
character (len=*), intent(in), optional :: fmt_stat
character (len=*), intent(in), optional :: fmt_header,fmt_trailer
character (len=*), intent(in), optional :: title
character (len=*), intent(in), optional :: var_name
integer                                 :: i,iunit,nstats,nvar
character (len=100)                     :: fmt_s,fmt_sl,var_name_
character (len=*), parameter            :: msg = mod_str // "print_computed_stats_matrix, "
if (present(var_name)) then
   var_name_ = var_name
else
   var_name_ = "var"
end if
nstats = size(cstats)
if (nstats == 0) return
if (size(xstats,2) /= size(labels)) then
   write (*,*) msg,"size(xstats,2), size(labels) =",size(xstats,2), size(labels),"should be equal, RETURNING"
   return
else if (size(xstats,1) /= nstats) then
   write (*,*) msg,"size(cstats), size(xstats,1) =",nstats,size(xstats,1),"should be equal, RETURNING"
   return
end if
if (present(iu)) then
   iunit = iu
else
   iunit = istdout
end if
if (present(fmt_stat)) then
   fmt_s = fmt_stat
else
   fmt_s = "(1x,a10,100(1x,f10.4))"
end if
if (present(fmt_stat_labels)) then
   fmt_sl = fmt_stat_labels
else
   fmt_sl = "(/,100(1x,a10))"
end if
if (present(fmt_header)) then
   if (fmt_header /= "") write (iunit,fmt_header)
end if
if (present(title)) write (iunit,*) trim(title)
! print*,"size(cstats)=",size(cstats)," fmt_sl = '" // trim(fmt_sl) // "'"
if (fmt_sl /= "") write (iunit,fmt_sl) trim(var_name_),cstats
nvar = size(labels)
do i=1,nvar
   write (iunit,fmt_s) trim(labels(i)),xstats(:,i)
end do
if (present(fmt_trailer)) then
   if (fmt_trailer /= "") write (iunit,fmt_trailer)
end if
end subroutine print_computed_stats_matrix
!
subroutine print_many_stats_matrix_extended(cstat,istat,xx,labels,iu,fmt_stat,fmt_stat_labels,fmt_header)
! for each column of a matrix, print several statistics in one line
! also print statistics on cstat, a "summary statistic" applied to each row
character (len=*), intent(in)           :: cstat
integer          , intent(in)           :: istat(:)
real(kind=dp)    , intent(in)           :: xx(:,:)
character (len=*), intent(in)           :: labels(:)
integer          , intent(in), optional :: iu
character (len=*), intent(in), optional :: fmt_stat_labels
character (len=*), intent(in), optional :: fmt_stat
character (len=*), intent(in), optional :: fmt_header
integer                                 :: i,iunit,nvar,nobs
character (len=100)                     :: fmt_s,fmt_sl
real(kind=dp)                           :: yy(size(xx,1))
nobs = size(xx,1)
do i=1,nobs
   yy(i) = stat_vec_str(cstat,xx(i,:))
end do
if (present(iu)) then
   iunit = iu
else
   iunit = istdout
end if
if (present(fmt_stat)) then
   fmt_s = fmt_stat
else
   fmt_s = "(1x,a10,100(1x,f10.4))"
end if
if (present(fmt_stat_labels)) then
   fmt_sl = fmt_stat
else
   fmt_sl = "(/,100(1x,a10))"
end if
if (present(fmt_header)) then
   if (fmt_header /= "") write (iunit,fmt_header)
end if
if (fmt_sl /= "") write (iunit,fmt_sl) "var",stat_labels(istat)
nvar = size(labels)
do i=1,nvar
   write (iunit,fmt_s) trim(labels(i)),stats(istat,xx(:,i))
end do
write (iunit,fmt_s) trim(cstat),stats(istat,yy)
end subroutine print_many_stats_matrix_extended
!
subroutine print_basic_stats_col(xx,symbols,fmt_stat,fmt_sym,print_first_last,print_geo_ret,title)
! print statistics for each column of a matrix
real(kind=dp)    , intent(in)           :: xx(:,:)
character (len=*), intent(in), optional :: symbols(:)
character (len=*), intent(in), optional :: fmt_stat,fmt_sym
character (len=100)                     :: fmt_s,fmt_sym_use,fmt_title_
logical          , intent(in), optional :: print_first_last,print_geo_ret
character (len=*), intent(in), optional :: title
integer                                 :: nrows,ncol
fmt_title_ = "(/,1x,a)"
nrows = size(xx,1)
ncol  = size(xx,2)
! if (present(symbols)) write (*,*) symbols
if (present(fmt_stat)) then
   fmt_s = fmt_stat
else
   fmt_s = "(1x,a10,100(1x,f10.4))"
end if
if (present(fmt_sym)) then
   fmt_sym_use = fmt_sym
else
   fmt_sym_use = "(/,7x,'stat',6x,100(1x,a10))"
end if
if (present(title)) write (*,fmt_title_) title
if (present(symbols)) then
   if (size(symbols) /= ncol) then
      write (*,*) "in statistics.f90::statistics_mod::print_basic_stats_col, size(symbols), size(xx,2) =",size(symbols),ncol, &
                  "should be equal, STOPPING"
      stop
   end if
   write (*,fmt_sym_use) symbols
end if
if (present(print_first_last)) then
   if (print_first_last) then
      write (*,fmt_s) "first",xx(1,:)
      write (*,fmt_s) "last" ,xx(nrows,:)
   end if
end if
if (present(print_geo_ret)) then
   if (print_geo_ret) write (*,fmt_s) "geom. ret",((xx(nrows,:)/xx(1,:)) ** (1.0/(nrows-1))) - 1.0
end if
write (*,fmt_s) "mean",mean_by_col(xx)
write (*,fmt_s)   "sd",  sd_by_col(xx)
write (*,fmt_s)  "min",minval(xx,dim=1)
write (*,fmt_s)  "max",maxval(xx,dim=1)
end subroutine print_basic_stats_col
!
subroutine print_basic_stats(xx,fmt_stat,print_first_last,print_geo_ret)
! print statistics for a vector
real(kind=dp)    , intent(in)           :: xx(:)
character (len=*), intent(in), optional :: fmt_stat
character (len=100)                     :: fmt_s
logical          , intent(in), optional :: print_first_last,print_geo_ret
integer                                 :: nrows
real(kind=dp)                           :: xmean,xsd
real(kind=dp), parameter                :: tiny_real = 1.0d-12
nrows = size(xx)
if (present(fmt_stat)) then
   fmt_s = fmt_stat
else
   fmt_s = "(1x,a10,100(1x,f10.4))"
end if
if (present(print_first_last)) then
   if (print_first_last) then
      write (*,fmt_s) "first",xx(1)
      write (*,fmt_s) "last" ,xx(nrows)
   end if
end if
if (present(print_geo_ret)) then
   if (print_geo_ret) write (*,fmt_s) "geom. ret",((xx(nrows)/xx(1)) ** (1.0/(nrows-1))) - 1.0
end if
xmean = mean(xx)
xsd = sd(xx)
write (*,fmt_s) "mean",xmean
write (*,fmt_s)   "sd",  xsd
if (xsd > tiny_real) write (*,fmt_s) "mean/sd",xmean/xsd
write (*,fmt_s)  "min",minval(xx)
write (*,fmt_s)  "max",maxval(xx)
end subroutine print_basic_stats
!
subroutine print_stats_one_var_per_row(xx,symbols,fmt_stat,fmt_label,fmt_header)
real(kind=dp)      , intent(in)           :: xx(:,:)
character (len=*)  , intent(in)           :: symbols(:)
character (len=*)  , intent(in), optional :: fmt_stat, fmt_label, fmt_header
character (len=100)                       :: fmt_s,fmt_l
integer                                   :: i,nsym
real(kind=dp)                             :: yy(size(xx,1))
nsym  = size(symbols)
if (present(fmt_stat)) then
   fmt_s = fmt_stat
else
   fmt_s = "(3x,a10,100f10.4)"
end if
if (present(fmt_label)) then
   fmt_l = fmt_label
else  
   fmt_l = "(1x,a10,2x,100a10)"
end if
if (present(fmt_header)) then
    if (fmt_header /= "") write (*,fmt_header)
end if
write (*,fmt_l) "variable","mean","sd","skew","kurt","min","max","first","last"
do i=1,nsym
   yy = xx(:,i)
   write (*,fmt_s) symbols(i),mean(yy),sd(yy),skew(yy),kurtosis(yy), &
                   minval(yy),maxval(yy),yy(1),yy(size(yy))
end do
end subroutine print_stats_one_var_per_row
!
pure function average_rank(ivec) result(xavg)
integer, intent(in) :: ivec(:)
real(kind=dp)       :: xavg
integer             :: i,n
n = size(ivec)
xavg = dot_product((/(i,i=1,n)/),ivec) / (one * sum(ivec))
end function average_rank
!
pure function average_rank_by_col(ivec) result(xavg)
integer, intent(in) :: ivec(:,:)
real(kind=dp)       :: xavg(size(ivec,2))
integer             :: i,ncol
ncol = size(ivec,2)
do i=1,ncol
   xavg(i) = average_rank(ivec(:,i))
end do
end function average_rank_by_col
!
subroutine print_stats_momentum(nlags,thresh,xx,yy,istat,iu,fmt_out,fmt_stat_labels,fmt_header)
! print statistics for yy conditional the on the average value of xx 
! in the past nlags periods being above or below thresh
real(kind=dp)    , intent(in)           :: thresh
real(kind=dp)    , intent(in)           :: xx(:),yy(:)
integer          , intent(in)           :: istat(:)
integer          , intent(in)           :: nlags ! # of lags used to compute momentum
integer          , intent(in), optional :: iu
character (len=*), intent(in), optional :: fmt_out
character (len=*), intent(in), optional :: fmt_stat_labels
character (len=*), intent(in), optional :: fmt_header
character (len=100)                     :: fmt_o,fmt_sl,fmt_h
integer                                 :: i,iunit,n,nuse
character (len=*), parameter            :: msg = mod_str // "print_stats_momentum, "
logical          , allocatable          :: tf(:)
n    = size(xx)
nuse = n - nlags
if (nlags < 1) then
   write (*,*) msg,"nlags =",nlags,"should be >= 1"
   return
else if (nlags >= n) then
   write (*,*) msg,"nlags, size(xx)=",nlags,n,"need nlags < size(xx)"
   return
else if (size(yy) /= n) then
   write (*,*) msg,"size(xx), size(yy)=",size(xx),size(yy),"should be same"
   return
end if
allocate (tf(nuse))
do i=1,nuse
   tf(i) = sum(xx(i:i+nlags-1)) > thresh
end do
if (present(iu)) then
   iunit = iu
else
   iunit = istdout
end if
if (present(fmt_out)) then
   fmt_o = fmt_out
else
   fmt_o = "(a7,i6,100(1x,f10.4))"
end if
if (present(fmt_stat_labels)) then
   fmt_sl = fmt_stat_labels
else
   fmt_sl = "(7x,a6,100(1x,a10))"
end if
if (present(fmt_header)) then
   fmt_h = fmt_header
else
   fmt_h = ""
!    if (fmt_header /= "") write (iunit,fmt_header)
end if
call print_stats_binary(tf,yy(nlags+1:),istat,iunit,fmt_o,fmt_sl,fmt_h)
! if (fmt_sl /= "") write (iunit,fmt_sl) "#",stat_labels(istat)
! write (iunit,fmt_o) "true ",count(tf)      ,stats(istat,pack(yy,tf      ))
! write (iunit,fmt_o) "false",count(.not. tf),stats(istat,pack(yy,.not. tf))
end subroutine print_stats_momentum
!
subroutine print_stats_binary(tf,yy,istat,iu,fmt_out,fmt_stat_labels,fmt_header)
! print statistics for yy conditional on tf being true or false
logical          , intent(in)           :: tf(:)
real(kind=dp)    , intent(in)           :: yy(:)
integer          , intent(in)           :: istat(:)
integer          , intent(in), optional :: iu
character (len=*), intent(in), optional :: fmt_out
character (len=*), intent(in), optional :: fmt_stat_labels
character (len=*), intent(in), optional :: fmt_header
character (len=100)                     :: fmt_o,fmt_sl   
integer                                 :: iunit
if (present(iu)) then
   iunit = iu
else
   iunit = istdout
end if
if (present(fmt_out)) then
   fmt_o = fmt_out
else
   fmt_o = "(a7,i6,100(1x,f10.4))"
end if
if (present(fmt_stat_labels)) then
   fmt_sl = fmt_stat_labels
else
   fmt_sl = "(7x,a6,100(1x,a10))"
end if
if (present(fmt_header)) then
    if (fmt_header /= "") write (iunit,fmt_header)
end if
if (fmt_sl /= "") write (iunit,fmt_sl) "#",stat_labels(istat)
write (iunit,fmt_o) "true ",count(tf)      ,stats(istat,pack(yy,tf      ))
write (iunit,fmt_o) "false",count(.not. tf),stats(istat,pack(yy,.not. tf))
end subroutine print_stats_binary
!
subroutine stats_binary(tf,yy,nn,xmean,xsd,ierr)
logical      , intent(in)  :: tf(:)
real(kind=dp), intent(in)  :: yy(:)
integer      , intent(out) :: nn(:)
real(kind=dp), intent(out) :: xmean(:)
real(kind=dp), intent(out) :: xsd(:)
integer      , intent(out) :: ierr
integer                    :: n
integer      , parameter   :: ncat = 2
xmean =  0.0d0
xsd   = -one
n     = size(tf)
if (n < 2) then
   ierr = 1
else if (size(yy) /= n) then
   ierr = 2
else if (size(nn)    /= ncat) then
   ierr = 3
else if (size(xmean) /= ncat) then
   ierr = 4
else if (size(xsd)   /= ncat) then
   ierr = 5
end if
if (ierr /= 0) return
   nn(1) = count(tf)
   nn(2) = n - nn(1)
xmean(1) = mean(pack(yy,tf))
xmean(2) = mean(pack(yy,.not. tf)) 
  xsd(1) =   sd(pack(yy,tf))
  xsd(2) =   sd(pack(yy,.not. tf))
end subroutine stats_binary 
!
function count_signs(xx,xtiny) result(nn)
! return the # of negative, zero, and positive elements of xx
real(kind=dp), intent(in)           :: xx(:)
real(kind=dp), intent(in), optional :: xtiny
integer                             :: nn(3)
integer                             :: i
real(kind=dp)                       :: thresh
if (present(xtiny)) then
   thresh = xtiny
else
   thresh = 1.0d-12
end if
nn = 0
do i=1,size(xx)
   if      (xx(i) <= -thresh) then
      nn(1) = nn(1) + 1
   else if (xx(i) >= thresh)  then
      nn(3) = nn(3) + 1
   else
      nn(2) = nn(2) + 1
   end if
end do
end function count_signs
!
subroutine print_stats_annualized(label,sym,xmat,obs_per_year,fmt_header,fmt_stat,iu)
! print annualized statistics for each column of a matrix
character (len=*), intent(in)           :: label
character (len=*), intent(in)           :: sym(:)
real(kind=dp)    , intent(in)           :: xmat(:,:)
real(kind=dp)    , intent(in), optional :: obs_per_year
character (len=*), intent(in), optional :: fmt_header
character (len=*), intent(in), optional :: fmt_stat
integer          , intent(in), optional :: iu
character (len=100)                     :: fmt_st,fmt_h
integer                                 :: i,iunit,ncol
real(kind=dp)                           :: xobs
ncol = size(sym)
if (present(iu)) then
   iunit = iu
else
   iunit = istdout
end if
if (present(fmt_stat)) then
   fmt_st = fmt_stat
else 
   fmt_st = "(6x,a6,3x,100f7.2)"
end if
if (present(fmt_header)) then
   fmt_h = fmt_header
else
   fmt_h = "(/,2x,a,/,17x,100a7)"
end if
if (present(obs_per_year)) then
   xobs = obs_per_year
else
   xobs = one
end if
write (iunit,fmt_h)   label,sym
write (iunit,fmt_st)      "min",(minval(xmat(:,i)),i=1,ncol)
write (iunit,fmt_st)      "max",(maxval(xmat(:,i)),i=1,ncol)
write (iunit,fmt_st) "mean_ann",      xobs * mean_by_col(xmat)
write (iunit,fmt_st)   "sd_ann",sqrt(xobs) *   sd_by_col(xmat)
end subroutine print_stats_annualized
!
function median(xx) result(xmed)
! return the median of xx(:)
real(kind=dp), intent(in) :: xx(:)
real(kind=dp)             :: xmed
real(kind=dp)             :: xcopy(size(xx))
xcopy = xx
call median_sub(xcopy,size(xx),xmed)
end function median
!
subroutine median_sub(x,n,xmed)
! Find the median of X(1), ... , X(N), using as much of the quicksort
! algorithm as is needed to isolate it.
! 8/30/2006 Modified so that code does not try to access an out-of-bounds array element if all the values of x(:) are NaN
! N.B. On exit, the array X is partially ordered.
! By Alan Miller
!     Latest revision - 26 November 1996
implicit none
integer, intent(in)  :: n
real(kind=dp), intent(in out) :: x(:)
real(kind=dp), intent(out)    :: xmed
! Local variables
real(kind=dp)    :: temp, xhi, xlo, xmax, xmin
logical :: odd
integer :: hi, lo, nby2, nby2p1, mid, i, j, k
nby2 = n / 2
nby2p1 = nby2 + 1
odd = .true.
!     HI & LO are position limits encompassing the median.
if (n == 2 * nby2) odd = .false.
lo = 1
hi = n
if (n < 3) then
  if (n < 1) then
    xmed = 0.0
    return
  end if
  xmed = x(1)
  if (n == 1) return
  xmed = 0.5*(xmed + x(2))
  return
end if

!     Find median of 1st, middle & last values.

10 mid = (lo + hi)/2
xmed = x(mid)
xlo = x(lo)
xhi = x(hi)
if (xhi < xlo) then          ! Swap xhi & xlo
  temp = xhi
  xhi = xlo
  xlo = temp
end if
if (xmed > xhi) then
  xmed = xhi
else if (xmed < xlo) then
  xmed = xlo
end if

! The basic quicksort algorithm to move all values <= the sort key (XMED)
! to the left-hand end, and all higher values to the other end.

i = lo
j = hi
50 do
!  if (x(i) >= xmed) exit ! line in original Alan Miller code replaced by one below
  if (x(i) >= xmed .or. i == n) exit
  i = i + 1
end do
do
!  if (x(j) <= xmed) exit ! line in original Alan Miller code replaced by one below
  if (x(j) <= xmed .or. j == 1) exit
  j = j - 1
end do
if (i < j) then
  temp = x(i)
  x(i) = x(j)
  x(j) = temp
  i = i + 1
  j = j - 1

!     Decide which half the median is in.

  if (i <= j) go to 50
end if

if (.not. odd) then
  if (j == nby2 .and. i == nby2p1) go to 130
  if (j < nby2) lo = i
  if (i > nby2p1) hi = j
  if (i /= j) go to 100
  if (i == nby2) lo = nby2
  if (j == nby2p1) hi = nby2p1
else
  if (j < nby2p1) lo = i
  if (i > nby2p1) hi = j
  if (i /= j) go to 100

! Test whether median has been isolated.

  if (i == nby2p1) return
end if
100 if (lo < hi - 1) go to 10

if (.not. odd) then
  xmed = 0.5*(x(nby2) + x(nby2p1))
  return
end if
temp = x(lo)
if (temp > x(hi)) then
  x(lo) = x(hi)
  x(hi) = temp
end if
xmed = x(nby2p1)
return
! Special case, N even, J = N/2 & I = J + 1, so the median is
! between the two halves of the series.   Find max. of the first
! half & min. of the second half, then average.

130 xmax = x(1)
do k = lo, j
  xmax = max(xmax, x(k))
end do
xmin = x(n)
do k = i, hi
  xmin = Min(xmin, x(k))
end do
xmed = 0.5*(xmin + xmax)
end subroutine median_sub
!
function prob_positive(xx) result(xpos)
! return the proportion of values in xx that are positive
real(kind=dp), intent(in) :: xx(:)
real(kind=dp)             :: xpos
integer                   :: n
n = size(xx)
if (n < 1) then
   xpos = zero
else
   xpos = count(xx>0)/(1.0d0*n)
end if
end function prob_positive
!
pure function concentration(xx) result(xcon)
real(kind=dp), intent(in) :: xx(:)
real(kind=dp)             :: xcon
real(kind=dp)             :: xsum
xsum = sum(abs(xx))**2
if (xsum > zero) then
   xcon = sum(xx**2)/xsum
else
   xcon = zero
end if
end function concentration
!
pure function lookback(xx) result(yy)
real(kind=dp), intent(in) :: xx(:)
real(kind=dp)             :: yy
real(kind=dp)             :: xsum
integer                   :: i,n
xsum = sum(xx)
if (xsum > zero) then
   n  = size(xx)
   yy = sum((/(i*xx(i),i=1,n)/)) / xsum
else
   yy = zero
end if
end function lookback
!
function diff_tf(xx,tf) result(xdiff)
! return the difference between the values of xx when tf is .true. vs. .false.
real(kind=dp), intent(in) :: xx(:)
logical      , intent(in) :: tf(:)
real(kind=dp)             :: xdiff
integer                   :: n
n = size(xx)
if (size(tf) /= n .or. n == 0) then
   xdiff = zero
else
   xdiff = (sum(xx,mask=tf) - sum(xx,mask=.not. tf)) / n
end if
end function diff_tf
!
function drawdown(xx) result(yy)
! compute the most negative sum of consecutive negative values in xx(:)
real(kind=dp), intent(in) :: xx(:)
real(kind=dp)             :: yy
integer                   :: i,n
real(kind=dp)             :: xdraw
n     = size(xx)
yy    = zero
xdraw = zero
do i=1,n
   if (xx(i) > zero) then
      yy = min(yy,xdraw)
      xdraw = zero
   else
      xdraw = xdraw + xx(i)
   end if
end do
yy = min(yy,xdraw)   
end function drawdown
!
function r2_fit(xx,resid) result(yy)
! return the R^2 of a fit to data xx(:) with residuals resid(:)
real(kind=dp), intent(in) :: xx(:)
real(kind=dp), intent(in) :: resid(:)
real(kind=dp)             :: yy
yy = 1.0_dp - mean(resid**2)/variance(xx)
end function r2_fit
!
function r2_trend(xx) result(yy)
! compute the R^2 of the correlation of xx(:) with a trend line
real(kind=dp), intent(in) :: xx(:)
real(kind=dp)             :: yy
integer                   :: i
yy = correl(xx,1.0_dp*(/(i,i=1,size(xx))/)) ** 2
end function r2_trend
!
function r2_cumul_trend(xx) result(yy)
! compute the R^2 of the correlation of the cumulative sum of xx(:) with a trend line
real(kind=dp), intent(in) :: xx(:)
real(kind=dp)             :: yy
yy = r2_trend(cumul_sum(xx))
end function r2_cumul_trend
!
function norm_abs(xx) result(xnormalized)
real(kind=dp), intent(in) :: xx(:)
real(kind=dp)             :: xnormalized(size(xx))
real(kind=dp)             :: xsum
xsum = sum(abs(xx))
if (xsum > zero) then
   xnormalized = xx/xsum
else
   xnormalized = xx
end if
end function norm_abs
!
subroutine normalize_sum_abs(xx)
! normalize xx so that the sum(abs(xx)) = 1.0
real(kind=dp), intent(in out) :: xx(:)
real(kind=dp)                 :: xsum
xsum = sum(abs(xx))
if (xsum > zero) xx = xx/xsum
end subroutine normalize_sum_abs
!
recursive function slope(xx,yy,mask_xy) result(bb)
real(kind=dp), intent(in)           :: xx(:),yy(:)
logical      , intent(in), optional :: mask_xy(:)
real(kind=dp)                       :: bb,xsd
character (len=*), parameter :: msg="in statistics_mod::slope, "
if (present(mask_xy)) then
   bb = slope(pack(xx,mask_xy),pack(yy,mask_xy))
   if (size(xx) /= size(yy) .or. size(xx) /= size(mask_xy)) then
      write (*,*) msg,"size(xx),size(yy),size(mask_xy)=",size(xx),size(yy),size(mask_xy), &
                  " must be equal, STOPPPING"
      stop
   end if
else
   if (size(xx) /= size(yy)) then
      write (*,*) msg,"size(xx),size(yy)=",size(xx),size(yy)," must be equal, STOPPPING"
      stop
   end if
   xsd = sd(xx)
   if (xsd > 0.0_dp) then
      bb = correl(xx,yy)*sd(yy)/sd(xx)
   else
      bb = 0.0_dp
   end if
end if
end function slope
!
function correl_mask(xx,yy,mask_xy) result(rr)
real(kind=dp), intent(in) :: xx(:),yy(:)
logical      , intent(in) :: mask_xy(:)
real(kind=dp)             :: rr
if (size(xx) == size(yy) .and. size(xx) == size(mask_xy)) then
   rr = correl(pack(xx,mask_xy),pack(yy,mask_xy))
else
   rr = -4.0_dp
end if
end function correl_mask
!
pure function correl(xx,yy) result(rr)
! compute the linear (Pearson) correlation of xx(:) and yy(:)
real(kind=dp), intent(in) :: xx(:),yy(:)
integer                   :: n
real(kind=dp)             :: sxx,sxy,syy,rr,xmean,ymean,xt(size(xx)),yt(size(xx))
real(kind=dp), parameter  :: tiny_real = 1.0e-20_dp
n  = size(xx)
rr = 0.0_dp
if (n < 2) then
   rr = -2.0_dp
else if (size(yy) /= n) then
   rr = -3.0_dp
end if
if (rr < -1.5) return
xmean = sum(xx)/n
ymean = sum(yy)/n
xt    = xx - xmean
yt    = yy - ymean
sxx   = dot_product(xt,xt)
syy   = dot_product(yt,yt)
sxy   = dot_product(xt,yt)
rr    = sxy/(sqrt(sxx*syy) + tiny_real)
end function correl
!
pure subroutine corr_alpha_beta(xx,yy,corr,alpha,beta,xmean,ymean,xsd,ysd,resid,ypred)
! compute the linear (Pearson) correlation of xx(:) and yy(:)
! regress yy(:) on xx(:) and compute the slope beta, and the regression intercept alpha
real(kind=dp), intent(in)            :: xx(:),yy(:)
real(kind=dp), intent(out)           :: corr,alpha,beta
real(kind=dp), intent(out), optional :: xmean,ymean,xsd,ysd,resid(:),ypred(:)
integer                              :: n
real(kind=dp)                        :: sxx,sxy,syy,rr,xmean_,ymean_,xsd_,ysd_,xt(size(xx)),yt(size(xx))
real(kind=dp), parameter             :: tiny_real = 1.0e-20_dp
n  = size(xx)
rr = 0.0_dp
if (n < 2) then
   rr = -2.0_dp
else if (size(yy) /= n) then
   rr = -3.0_dp
end if
if (rr < -1.5) return
xmean_ = sum(xx)/n
ymean_ = sum(yy)/n
xt     = xx - xmean_
yt     = yy - ymean_
sxx    = dot_product(xt,xt)
syy    = dot_product(yt,yt)
sxy    = dot_product(xt,yt)
xsd_   = sqrt(sxx/n)
ysd_   = sqrt(syy/n)
corr   = (sxy/n)/(xsd_*ysd_ + tiny_real)
if (xsd_ > 0.0_dp) then
   beta = corr * ysd_/xsd_
else
   beta = 0.0_dp
end if
alpha = ymean_ - beta*xmean_
if (present(xmean)) xmean = xmean_
if (present(ymean)) ymean = ymean_
if (present(xsd)) xsd = xsd_
if (present(ysd)) ysd = ysd_
if (present(resid)) then
!   call assert_equal("in corr_alpha_beta, size(yy), size(resid) =",size(yy),size(resid))
   if (size(yy) == size(resid)) then
      resid = yy - beta*xx - alpha
   else
      resid = bad_real
   end if
end if
if (present(ypred)) then
!   call assert_equal("in corr_alpha_beta, size(yy), size(resid) =",size(yy),size(resid))
   if (size(yy) == size(ypred)) then
      ypred = beta*xx + alpha
   else
      ypred = bad_real
   end if
end if
end subroutine corr_alpha_beta
!
subroutine print_corr_alpha_beta_many(sym_x,xx,yy,outu)
! regress yy(:) on each column of xx(:,:) and print the results
character (len=*)  , intent(in)           :: sym_x(:) ! (nsym)
real(kind=dp)      , intent(in)           :: xx(:,:)  ! (n,nsym)
real(kind=dp)      , intent(in)           :: yy(:)    ! (n)
integer            , intent(in), optional :: outu
integer                                   :: isym,nsym,outu_
real(kind=dp)                             :: xcorr,alpha,beta,xsd
character (len=*)  , parameter            :: sub_name="print_corr_alpha_beta_many"
call assert_equal(size(sym_x),size(xx,2),"size(sym_x)","size(xx,2)",sub_name)
call assert_equal(size(xx,1),size(yy),"size(xx,1)","size(yy)",sub_name)
nsym  = size(sym_x)
outu_ = default(istdout,outu)
write (outu_,"(/,a10,100a12)") "sym","corr","beta","alpha","xsd","Sharpe_res"
do isym=1,nsym
   call corr_alpha_beta(xx(:,isym),yy,xcorr,alpha,beta,xsd=xsd)
   write (outu_,"(a10,100f12.4)") trim(sym_x(isym)),xcorr,beta,alpha,xsd,stats("Sharpe",yy - beta*xx(:,isym))
end do   
end subroutine print_corr_alpha_beta_many
!
function cumul_sum(xx) result(yy)
! compute the cumulative sum of xx(:)
real(kind=dp), intent(in) :: xx(:)
real(kind=dp)             :: yy(size(xx))
integer                   :: i,n
n = size(xx)
if (n < 1) return
yy(1) = xx(1)
do i=2,n
   yy(i) = yy(i-1) + xx(i)
end do
end function cumul_sum
!
pure function first(xx) result(x1)
real(kind=dp), intent(in) :: xx(:)
real(kind=dp)             :: x1
if (size(xx) > 0) then
   x1 = xx(1)
else
   x1 = 0.0_dp
end if
end function first
!
pure function last(xx) result(xlast)
real(kind=dp), intent(in) :: xx(:)
real(kind=dp)             :: xlast
integer                   :: n
n = size(xx)
if (n > 0) then
   xlast = xx(n)
else
   xlast = 0.0_dp
end if
end function last
!
pure function minval_def(xx,xdefault) result(xmin)
! return minval(xx) except when size(xx)==0, in which 0 or xdefault is returned
real(kind=dp), intent(in) :: xx(:)
real(kind=dp), intent(in), optional :: xdefault
real(kind=dp)             :: xmin
if (size(xx) > 0) then
   xmin = minval(xx)
else
   if (present(xdefault)) then
      xmin = xdefault
   else
      xmin = 0.0_dp
   end if
end if
end function minval_def
!
pure function maxval_def(xx,xdefault) result(xmax)
! return maxval(xx) except when size(xx)==0, in which 0 or xdefault is returned
real(kind=dp), intent(in)           :: xx(:)
real(kind=dp), intent(in), optional :: xdefault
real(kind=dp)                       :: xmax
if (size(xx) > 0) then
   xmax = maxval(xx)
else
   if (present(xdefault)) then
      xmax = xdefault
   else
      xmax = 0.0_dp
   end if
end if
end function maxval_def
!
pure subroutine difference_vec(xx,yy,nlags)
! difference xx(:) using nlags lags
real(kind=dp), intent(in)               :: xx(:)
real(kind=dp), intent(out), allocatable :: yy(:)
integer      , intent(in) , optional    :: nlags
integer                                 :: nlags_,nx,ny
nlags_ = default(1,nlags)
nx     = size(xx)
ny     = nx - nlags_
if (ny < 1 .or. nlags_ < 0) then
   allocate (yy(0))
   return
end if
allocate (yy(ny))
if (nlags_ == 0) then
   yy = xx
else
   yy = xx(nlags_+1:nx) - xx(1:nx-nlags_)
end if
end subroutine difference_vec
!
pure subroutine difference_mat(xx,yy,nlags)
! difference xx(:,:) using nlags lags
real(kind=dp), intent(in)               :: xx(:,:)
real(kind=dp), intent(out), allocatable :: yy(:,:)
integer      , intent(in) , optional    :: nlags
integer                                 :: nlags_,ncol,nx,ny
nlags_ = default(1,nlags)
ncol   = size(xx,2)
nx     = size(xx,1)
ny     = nx - nlags_
if (ny < 1 .or. nlags_ < 0) then
   allocate (yy(0,ncol))
   return
end if
allocate (yy(ny,ncol))
if (nlags_ == 0) then
   yy = xx
else
   yy = xx(nlags_+1:nx,:) - xx(1:nx-nlags_,:)
end if
end subroutine difference_mat
!
pure subroutine difference_panel(xx,yy,nlags)
! difference xx(:,:,:) using nlags lags
real(kind=dp), intent(in)               :: xx(:,:,:)
real(kind=dp), intent(out), allocatable :: yy(:,:,:)
integer      , intent(in) , optional    :: nlags
integer                                 :: nlags_,n2,n3,nx,ny
nlags_ = default(1,nlags)
nx     = size(xx,1)
n2     = size(xx,2)
n3     = size(xx,3)
ny     = nx - nlags_
if (ny < 1 .or. nlags_ < 0) then
   allocate (yy(0,n2,n3))
   return
end if
allocate (yy(ny,n2,n3))
if (nlags_ == 0) then
   yy = xx
else
   yy = xx(nlags_+1:nx,:,:) - xx(1:nx-nlags_,:,:)
end if
end subroutine difference_panel
!
pure function diff_vec(xx,nlags) result(yy)
! difference xx(:) using nlags lags
real(kind=dp), intent(in) :: xx(:)
integer      , intent(in) :: nlags
real(kind=dp)             :: yy(size(xx)-nlags)
integer                   :: nx
nx = size(xx)
if (nlags >= nx .or. nlags < 0) return
if (nlags == 0) then
   yy = xx
else
   yy = xx(nlags+1:nx) - xx(1:nx-nlags)
end if
end function diff_vec
!
function diff_nonoverlap_vec(xx,nlags) result(yy)
! return noverlapping differences of xx with spacing nlags
real(kind=dp), intent(in) :: xx(:)
integer      , intent(in) :: nlags
real(kind=dp)             :: yy((size(xx)-1)/nlags)
integer                   :: i,imin,ny
ny = size(yy)
do i=1,ny
   imin  = 1 + ((i-1)*nlags)
   yy(i) = xx(imin+nlags) - xx(imin)
end do
end function diff_nonoverlap_vec
!
function diff_rms_lag_vec(xx,lag) result(xrms)
! return the variance of noverlapping differences of xx with spacing lag
! assumes that xx is detrended
real(kind=dp), intent(in) :: xx(:)
integer      , intent(in) :: lag
real(kind=dp)             :: xrms
real(kind=dp)             :: yy((size(xx)-1)/lag)
integer                   :: i,imin,ny
ny = size(yy)
do i=1,ny
   imin  = 1 + ((i-1)*lag)
   yy(i) = xx(imin+lag) - xx(imin)
end do
xrms = sum(yy**2)/ny
end function diff_rms_lag_vec
!
function var_ratio(xx,nlags) result(ratios)
! compute variance ratio of differences of a time series
real(kind=dp), intent(in) :: xx(:)
integer      , intent(in) :: nlags
real(kind=dp)             :: ratios(nlags)
real(kind=dp)             :: var(nlags)
integer                   :: i
if (nlags < 1) return
var = diff_rms_lags_vec(xx,nlags)
if (var(1) > 0.0_dp) then
   ratios(1) = 1.0_dp
   forall (i=1:nlags) ratios(i) = var(i)/(i*var(1))
else
   ratios = -1.0_dp
end if
end function var_ratio
!
function diff_rms_lags_vec(xx,nlags) result(xrms)
! return the variance of noverlapping differences of xx with spacing lag
! assumes that xx is detrended
real(kind=dp), intent(in) :: xx(:)
integer      , intent(in) :: nlags
real(kind=dp)             :: xrms(nlags)
integer                   :: i
do i=1,nlags
   xrms(i) = diff_rms_lag_vec(xx,i)
end do
end function diff_rms_lags_vec
!
pure function diff_mat(xx,nlags) result(yy)
! difference each column of xx(:,:) using nlags lags
real(kind=dp), intent(in) :: xx(:,:)
integer      , intent(in) :: nlags
real(kind=dp)             :: yy(size(xx,1)-nlags,size(xx,2))
integer                   :: nobs
nobs = size(xx,1)
if (nlags >= nobs .or. nlags < 0) return
if (nlags == 0) then
   yy = xx
else
   yy = xx(nlags+1:nobs,:) - xx(1:nobs-nlags,:)
end if
end function diff_mat
!
pure function diff_tensor(xx,nlags) result(yy)
! difference each column of xx(:,:) using nlags lags
real(kind=dp), intent(in) :: xx(:,:,:)
integer      , intent(in) :: nlags
real(kind=dp)             :: yy(size(xx,1)-nlags,size(xx,2),size(xx,3))
integer                   :: nobs
nobs = size(xx,1)
if (nlags >= nobs .or. nlags < 0) return
if (nlags == 0) then
   yy = xx
else
   yy = xx(nlags+1:nobs,:,:) - xx(1:nobs-nlags,:,:)
end if
end function diff_tensor
!
elemental function bound(xx,xmin,xmax) result(xbnd)
real(kind=dp), intent(in) :: xx,xmin,xmax
real(kind=dp)             :: xbnd
xbnd = min(max(xx,xmin),xmax)
end function bound
!
function rolling_stat(cstat,xx,min_use,max_use) result(yy)
character (len=*), intent(in)           :: cstat
real(kind=dp)    , intent(in)           :: xx(:)
integer          , intent(in), optional :: min_use,max_use
real(kind=dp)                           :: yy(size(xx))
integer                                 :: min_use_,max_use_,i,i1,n
n = size(xx)
if (present(min_use)) then
   min_use_ = min_use
else
   min_use_ = 1
end if
if (present(max_use)) then
   max_use_ = max_use
else
   max_use_ = n
end if
yy = zero
do i=max(min_use_,1),n
   i1 = max(1,i - max_use_ + 1)
   yy(i) = stats(cstat,xx(i1:i)) 
end do
end function rolling_stat
!
function rolling_stat_func_matrix(cstat,xx,min_use,max_use) result(yy)
character (len=*), intent(in)           :: cstat
real(kind=dp)    , intent(in)           :: xx(:,:)
integer          , intent(in), optional :: min_use,max_use
real(kind=dp)                           :: yy(size(xx,1),size(xx,2))
integer                                 :: min_use_,max_use_,i,i1,n,icol,ncol
n = size(xx,1)
ncol = size(xx,2)
if (present(min_use)) then
   min_use_ = min_use
else
   min_use_ = 1
end if
if (present(max_use)) then
   max_use_ = max_use
else
   max_use_ = n
end if
yy = zero
do i=max(min_use_,1),n
   i1 = max(1,i - max_use_ + 1)
   do icol=1,ncol
      yy(i,icol) = stats(cstat,xx(i1:i,icol)) 
   end do
end do
end function rolling_stat_func_matrix
!
function transition_count(istate,nstates) result(freq)
! compute the frequency of transitions between states
integer, intent(in) :: istate(:)
integer, intent(in) :: nstates
integer             :: freq(nstates,nstates)
integer             :: i,i0,i1,n
freq = 0
n    = size(istate)
if (n < 2) return
do i=2,n
   i1 = istate(i-1)
   i0 = istate(i)
   if (i1 >= 1 .and. i1 <= nstates .and. i0 >= 1 .and. i0 <= nstates) freq(i0,i1) = freq(i0,i1) + 1
end do
end function transition_count
!
function transition_prob(istate,nstates) result(prob)
! compute the frequency of transitions between states
integer, intent(in) :: istate(:)
integer, intent(in) :: nstates
real(kind=dp)       :: prob(nstates,nstates)
integer             :: i,ftrans(nstates,nstates)
ftrans = transition_count(istate,nstates)
forall (i=1:nstates) prob(i,:) = ftrans(i,:)/dble(max(1,sum(ftrans(i,:))))
end function transition_prob
!
pure function bin_counts(ivec,nbins) result(ncount)
! count the number of elements in ivec = 1, 2, ..., nbins
integer, intent(in) :: ivec(:),nbins
integer             :: i,j,ncount(nbins)
ncount = 0
do i=1,size(ivec)
   j = ivec(i)
   if (j > 0 .and. j <= nbins) ncount(j) = ncount(j) + 1
end do
end function bin_counts
!
function mean_dim_1(x3d) result(y2d)
! compute mean along 1st dimension of x3d
real(kind=dp), intent(in) :: x3d(:,:,:)
real(kind=dp)             :: y2d(size(x3d,2),size(x3d,3))
integer                   :: n1
n1 = size(x3d,1)
if (n1 > 0) then
   y2d = sum(x3d,dim=1)/n1
else
   y2d = 0.0_dp
end if
end function mean_dim_1
!
function mean_abs_diff(xx) result(yy)
! return the mean absolute difference of successive values
real(kind=dp), intent(in) :: xx(:)
real(kind=dp)             :: yy
integer                   :: ndiff
ndiff = size(xx) - 1
if (ndiff < 1) then
   yy = 0.0_dp
   return
end if
yy = sum(abs(xx(2:)-xx(:ndiff))) / ndiff
end function mean_abs_diff
!
subroutine standardize(yy,ymean,ysd)
! shift and scale yy so that it has mean ymean and standard deviation ysd
real(kind=dp), intent(in out)            :: yy(:)
real(kind=dp), intent(in)     , optional :: ymean,ysd
real(kind=dp)                            :: mean_input,sd_input,ymean_,ysd_
integer                                  :: ny
ny = size(yy)
if (ny < 1) return
if (present(ymean)) then
   ymean_ = ymean
else
   ymean_ = 0.0_dp
end if
if (present(ysd)) then
   ysd_   = ysd
else
   ysd_   = 1.0_dp
end if
mean_input = mean(yy)
sd_input   = sd(yy)
if (ny < 2 .or. sd_input < tiny_real) then
   yy = yy + ymean_ - mean_input
else
   yy = ymean_ + (yy - mean_input) * (ysd_/sd_input) 
end if
end subroutine standardize
!
function stdz_vec(xx) result(yy)
! return in yy(:) a scaled and shifted version of xx(:) with mean 0 and standard deviation 1
real(kind=dp), intent(in) :: xx(:)
real(kind=dp)             :: yy(size(xx))
yy = xx
call standardize(yy)
end function stdz_vec
!
function stdz_mat(xx) result(yy)
! return in yy(:,:) a scaled and shifted version of xx(:,:) with each column having mean 0 and standard deviation 1
real(kind=dp), intent(in) :: xx(:,:)
real(kind=dp)             :: yy(size(xx,1),size(xx,2))
integer                   :: icol
do icol=1,size(xx,2)
   yy(:,icol) = stdz_vec(xx(:,icol))
end do
end function stdz_mat
!
subroutine get_unit(iunit,xfile)
! GET_UNIT returns a free Fortran unit number if
! file xfile is not present or is not connected, returns
! unit of xfile if it is present and connected 
integer, intent(out) :: iunit
character (len=*), intent(in), optional :: xfile
integer              :: i,ios
logical              :: lopen
integer, parameter   :: iu_min = 20, iu_max = 99
if (present(xfile)) then
   inquire (file=xfile,number=iunit)
   if (iunit /= bad_unit) return
end if
iunit = 0
do i = iu_min,iu_max
    inquire (unit=i,opened=lopen,iostat=ios)
    if (ios == 0) then
      if (.not. lopen) then
        iunit = i
        return
      end if
    end if
end do
end subroutine get_unit
!
subroutine unique_values_real(xx,xuniq,thresh)
! return in xuniq(:) the unique values in xx(:)
real(kind=dp), intent(in)               :: xx(:)
real(kind=dp), intent(out), allocatable :: xuniq(:)
real(kind=dp), intent(in) , optional    :: thresh
integer                                 :: i,n,nuniq
real(kind=dp)                           :: thresh_,xset(size(xx))
if (present(thresh)) then
   thresh_ = thresh
else
   thresh_ = tiny_real
end if
n = size(xx)
if (n < 2) then
   allocate (xuniq(n))
   xuniq = xx
   return
end if
nuniq = 1
xset(1) = xx(1)
do i=2,n
   if (all(abs(xx(i)-xset(:nuniq)) > thresh_)) then
      nuniq = nuniq + 1
      xset(nuniq) = xx(i)
   end if
end do
allocate (xuniq(nuniq))
xuniq = xset(:nuniq)
end subroutine unique_values_real
!
function nunique_real(xx,thresh) result(nu)
! count the number of unique values in xx(:)
real(kind=dp), intent(in)           :: xx(:)
real(kind=dp), intent(in), optional :: thresh
integer                             :: nu
real(kind=dp), allocatable          :: xuniq(:)
call unique_values(xx,xuniq,thresh)
nu = size(xuniq)
end function nunique_real
!
function obs_count(xx,xbins) result(nobs)
! count the number of observations in bins defined by xbins(:)
real(kind=dp), intent(in) :: xx(:),xbins(:)
integer                   :: nobs(size(xbins)-1)
integer                   :: i,j,n,nbins
n = size(xx)
nbins = size(xbins) - 1
nobs = 0
do i=1,n
   do j=1,nbins
      if (xx(i) >= xbins(j) .and. xx(i) <= xbins(j+1)) then
         nobs(j) = nobs(j) + 1
         exit
      end if 
   end do
end do
end function obs_count
!
subroutine histogram(xx,xgrid,nobs,xh,print_freq)
! compute # of observations in equally-spaced bins 
real(kind=dp), intent(in)  :: xx(:)
real(kind=dp), intent(out) :: xgrid(:) ! (nbins+1) xgrid(i) and xgrid(i+1) are the bounds of bin i
integer      , intent(out) :: nobs(:)  ! (nbins)   # of observations in each bin
real(kind=dp), intent(out), optional :: xh
logical      , intent(in) , optional :: print_freq
logical                              :: print_freq_
integer                              :: i,j,k,nbins
real(kind=dp)                        :: xmin,xmax,xh_
if (present(print_freq)) then
   print_freq_ = print_freq
else
   print_freq_ = .false.
end if
nbins = size(nobs)
xmin  = minval(xx)
xmax  = maxval(xx)
if (size(xgrid) /= nbins+1) then
   write (*,*) mod_str // "histogram, size(xgrid), size(nobs) =",size(xgrid),size(nobs), &
   " need size(xgrid) == size(nobs) + 1, STOPPING"
   stop
end if
xgrid(1) = xmin
if (nbins == 0) then
   return
else if (nbins == 1) then
   xgrid(2) = xmax
   return
end if
xh_    = (xmax-xmin)/nbins
if (present(xh)) xh = xh_
forall (i=1:nbins) xgrid(i+1) = xmin + i*xh_
nobs = 0
do i=1,size(xx)
   j = nbins
   do k=1,nbins-1
      if (xx(i) < xgrid(k+1)) then
         j = k
         exit
      end if
   end do
   nobs(j) = nobs(j) + 1
end do
if (print_freq_) then
   write (*,"(/,1x,'#obs = ',i0,/,2(a9,2x),a10)") size(xx),"min","max","#obs"
   do i=1,nbins
      write (*,"(2(f10.4,1x),i10)") xgrid(i),xgrid(i+1),nobs(i)
   end do
end if
end subroutine histogram
!
subroutine density(xx,xmid,xdens,print_freq)
! compute a density estimate using the frequency of observations in bins
real(kind=dp), intent(in)  :: xx(:)
real(kind=dp), intent(out) :: xmid(:)  ! (nbins) centers of bins
real(kind=dp), intent(out) :: xdens(:) ! (nbins) density of observations -- #obs/bin_width
logical      , intent(in) , optional :: print_freq
integer                    :: i,nobs(size(xmid)),n,nbins
real(kind=dp)              :: xh,xgrid(size(xmid)+1)
n     = size(xx)
nbins = size(xmid)
if (n < 1 .or. nbins < 2) return
call histogram(xx,xgrid,nobs,xh,print_freq)
do i=1,nbins
   xmid(i)  = (xgrid(i) + xgrid(i+1))/2
   xdens(i) = nobs(i)/(n*xh)
end do
end subroutine density
!
subroutine print_rmse_obs(xpred,xtrue,xobs,rmse_pred,fmt_header,outu,csv)
real(kind=dp)    , intent(in)           :: xpred(:)
real(kind=dp)    , intent(in), optional :: xtrue(:),rmse_pred,xobs(:)
character (len=*), intent(in), optional :: fmt_header
logical          , intent(in), optional :: csv
integer          , intent(in), optional :: outu
logical                                 :: csv_
integer                      :: n,outu_
character (len=*), parameter :: fmt_cr = "(1x,a25,':',1x,100(1x,f12.6))", msg = mod_str // "print_rmse_obs, ", &
                                fmt_arcsv = "(a,1000(:,',',f0.6))"
real(kind=dp)                :: rmse_pred_
logical                      :: computed_rmse_pred
csv_ = default(.false.,csv)
outu_ = default(istdout,outu)
n = size(xpred)
if (present(xtrue)) then
   if (size(xtrue) /= n) then
      write (*,*) msg // "size(xpred), size(xtrue) =",n,size(xtrue)," must be equal, STOPPING"
      stop
   end if
end if
if (present(xobs)) then
   if (size(xobs) /= n) then
      write (*,*) msg,"size(xobs), size(xpred) =",size(xobs),n," must be equal, STOPPING"
      stop
   end if
end if
computed_rmse_pred = .true.
if (present(rmse_pred)) then
   rmse_pred_ = rmse_pred
else if (present(xobs)) then
   rmse_pred_ = rms(xobs-xpred)
else
   computed_rmse_pred = .false.
end if
if (present(fmt_header)) then
   if (fmt_header /= "") write (outu_,fmt_header)
end if
if (csv_) then
   if (computed_rmse_pred) write (outu_,fmt_arcsv) "rmse_pred_obs",rmse_pred_
   if (present(xtrue)) write (outu_,fmt_arcsv)     "rmse_pred_true",rms(xpred-xtrue)
else
   if (computed_rmse_pred) write (outu_,fmt_cr) "rmse(pred,obs)",rmse_pred_
   if (present(xtrue)) write (outu_,fmt_cr)     "rmse(pred,true)",rms(xpred-xtrue)
end if
end subroutine print_rmse_obs
!
elemental function default_logical(def,opt) result(tf)
logical, intent(in)           :: def
logical, intent(in), optional :: opt
logical                       :: tf
if (present(opt)) then
   tf = opt
else
   tf = def
end if
end function default_logical
!
elemental function default_integer(def,opt) result(tf)
integer, intent(in)           :: def
integer, intent(in), optional :: opt
integer                       :: tf
if (present(opt)) then
   tf = opt
else
   tf = def
end if
end function default_integer
!
elemental function default_character(def,opt) result(yy)
! return opt if it is present, otherwise def (character arguments and result)
character (len=*), intent(in)           :: def
character (len=*), intent(in), optional :: opt
character (len=len(def))                :: yy
if (present(opt)) then
   yy = opt
else
   yy = def
end if
end function default_character
!
subroutine rescale_volatility(vol_target,profits,profits_nc,positions,i1)
real(kind=dp), intent(in)               :: vol_target
real(kind=dp), intent(in out)           :: profits(:)
real(kind=dp), intent(in out), optional :: profits_nc(:),positions(:)
integer      , intent(in), optional :: i1
real(kind=dp)                       :: vol_sys,scale_vol
integer                             :: i1_
if (size(profits) < 1) return
i1_ = default(1,i1)
vol_sys   = vol_rms(profits(i1_:))
scale_vol = vol_target/vol_sys
if (vol_sys > tiny_real) then
   profits   = profits*scale_vol
   if (present(positions))  positions  = positions*scale_vol
   if (present(profits_nc)) profits_nc = profits_nc*scale_vol
end if
end subroutine rescale_volatility
!
pure function dot(xx) result(yy)
real(kind=dp), intent(in) :: xx(:)
real(kind=dp)             :: yy
integer                   :: i,n
n = size(xx)
if (n < 1) then
   yy = 0.0_dp
else
   yy = sum(xx*[(i,i=1,n)])
end if
end function dot
!
subroutine write_stats_groups(igroup,xx,cstats,outu,group_label,fmt_trailer,relation,min_obs_group)
! write stats for xx(:) conditional on igroup(:)
integer          , intent(in)  :: igroup(:)
real(kind=dp)    , intent(in)  :: xx(:) 
character (len=*), intent(in)  :: cstats(:)
integer          , intent(in)  :: outu 
character (len=*), intent(in), optional  :: relation
integer          , intent(in), optional :: min_obs_group
logical          , allocatable :: mask_group(:)
integer                        :: i,j,ncount,n,min_obs_group_
character (len=*), intent(in), optional :: group_label,fmt_trailer
character (len=100) :: group_label_,relation_
character (len=*), parameter :: msg = "in statistics_mod::write_stats_group, "
min_obs_group_ = default(1,min_obs_group)
n = size(xx)
if (size(igroup) /= n) then
   write (*,*) msg,"size(igroup), size(xx) =",size(igroup),n," must be equal, STOPPING"
   stop
end if
if (present(relation)) then
   relation_ = relation
else
   relation_ = "=="
end if
allocate (mask_group(n))
if (present(group_label)) then
   group_label_ = group_label
else
   group_label_ = "group"
end if
write (outu,*)
write (outu,fmt_acsv) "relation",trim(relation_)
write (outu,fmt_acsv) trim(group_label_),"count",(trim(cstats(i)),i=1,size(cstats))
if (relation_ == "==") write (outu,"('all,',(i0,','),100(f0.4,','))") size(xx),stats(cstats,xx)
do j = minval(igroup),maxval(igroup)
   if (relation_ == ">=") then
      mask_group = (igroup >= j)
   else if (relation == "<=") then
      mask_group = (igroup <= j)
   else if (relation_ == "==") then
      mask_group = (igroup == j)
   else
      write (*,*) msg,"relation_ = ",trim(relation_)," invalid, STOPPING"
      stop
   end if
   ncount = count(mask_group)
   if (ncount < min_obs_group_) cycle
   write (outu,"(2(i0,','),100(f0.4,','))") j,ncount,stats(cstats,pack(xx,mask_group))
end do
if (present(fmt_trailer)) then
   if (fmt_trailer /= "") write (outu,fmt_trailer)
end if
end subroutine write_stats_groups
!
subroutine set_stretch_param(par,x1,x2,power,scale,normalization,ymin,ymax)
type(stretch_param), intent(in out)       :: par
real(kind=dp)      , intent(in), optional :: x1,x2,power,scale,ymin,ymax
character (len=*)  , intent(in), optional :: normalization
if (present(x1))    par%x1    = x1
if (present(x2))    par%x2    = x2
if (present(power)) par%power = power
if (present(scale)) par%scale = scale
if (present(scale)) par%normalization = normalization
if (present(ymin))  par%ymin  = ymin
if (present(ymax))  par%ymax  = ymax
end subroutine set_stretch_param
!
function stretch_dt(par,xx) result(yy)
! transform xx(:) to yy(:) using function defined by par
type(stretch_param), intent(in) :: par
real(kind=dp)      , intent(in) :: xx(:)
real(kind=dp)                   :: yy(size(xx))
real(kind=dp)                   :: mult,xscale,yscale,zz
integer                         :: i,n
character (len=*), parameter    :: msg="in statistics_mod::stretch_dt, "
logical, parameter              :: smooth_x12 = .true.
logical                         :: print_mult_
print_mult_ = .true.
n = size(xx)
do i=1,n
   if (xx(i) < par%x1) then
      if (smooth_x12) then
         zz    = par%x1 - xx(i)
         yy(i) = -(zz**par%power)
      else
         yy(i) = abs(xx(i))**par%power*merge(1,-1,xx(i)>0)
      end if
   else if (xx(i) > par%x2) then
      if (smooth_x12) then
         zz    = xx(i) - par%x2
         yy(i) = zz**par%power
      else
         yy(i) = abs(xx(i))**par%power*merge(1,-1,xx(i)>0)
      end if
   else
      yy(i) = 0.0_dp
   end if
   if (abs(par%scale) > 0.0_dp) yy(i)  = yy(i) * (1 - exp(-(xx(i)/par%scale)**2))
end do
select case (par%normalization)
   case (str_mean_abs)
   xscale = mean(abs(xx))
   yscale = mean(abs(yy))
   if (yscale > 0.0_dp) then
      mult = xscale/yscale
      if (print_mult_) then
         call display(par,fmt_header="(/,' in stretch_dt')")
         write (*,"(a,f0.4)") "mult = ",mult
      end if
      yy = yy * mult
   end if
case (str_none)
   continue
case default
   write (*,*) msg,"par%normalization = '" // trim(par%normalization) // "', must be one of", &
               (" '" // trim(str_trans(i)) // "'",i=1,size(str_trans)),", STOPPING"
   stop
end select
! write (*,*) msg,"par%ymax, par%ymin =",par%ymax,par%ymin ! debug
yy = min(par%ymax,max(par%ymin,yy))
end function stretch_dt
!
subroutine display_stretch_param(par,outu,fmt_header,fmt_trailer,csv,write_labels,write_param,advance)
type(stretch_param), intent(in), optional :: par
integer            , intent(in), optional :: outu
character (len=*)  , intent(in), optional :: fmt_header,fmt_trailer
logical            , intent(in), optional :: csv
logical            , intent(in), optional :: write_labels,write_param
character (len=*)  , intent(in), optional :: advance
logical                                   :: csv_
integer                                   :: outu_
if (.not. present(par)) return
csv_ = default(.false.,csv)
outu_ = default(istdout,outu)
if (present(fmt_header)) then
   if (fmt_header /= "") write (outu_,fmt_header)
end if
if (default(.true.,write_labels)) write (outu_,merge("(100(a,','))","(100a14)    ",csv_), &
    advance=default("yes",advance)) "x1","x2","power","scale","ymin","ymax","normalization"
if (default(.true.,write_param)) write (outu_,merge("(6(f0.4,','),a,',')","(6f14.4,a14)       ",csv_), &
    advance=default("yes",advance)) par%x1,par%x2,par%power,par%scale,par%ymin,par%ymax, &
                                    trim(par%normalization)
if (present(fmt_trailer)) then
   if (fmt_trailer /= "") write (outu_,fmt_trailer)
end if
end subroutine display_stretch_param
!
subroutine read_stretch_param_vec(iu,par)
! read par(:) from unit iu
integer            , intent(in)               :: iu
type(stretch_param), intent(out), allocatable :: par(:)
integer              :: i,ierr,npar
character (len=1000) :: text
logical              :: print_param_
character (len=*), parameter :: msg = "in read_filter_param_vec, "
print_param_ = .true.
read (iu,*) npar
if (npar < 1) then
   allocate (par(0))
   return
end if
allocate (par(npar))
if (print_param_) write (*,"(/,100a10)") "x1","x2","power","scale"
do i=1,npar
   read (iu,"(a)") text
   read (text,*,iostat=ierr) par(i)%x1,par(i)%x2,par(i)%power,par(i)%scale
   if (ierr /= 0) then
      write (*,*) msg,"for i=",i," could not read par(i) from '" // trim(text) // "', STOPPING"
      stop
   end if
   if (print_param_) write (*,"(4(f9.4,1x))") par(i)%x1,par(i)%x2,par(i)%power,par(i)%scale
end do
if (print_param_) write (*,*)
end subroutine read_stretch_param_vec
!
subroutine write_stats_ranges(cstats,groups,xx,group_label,labels,outu,fmt_trailer)
! write stats for contiguous groups
character (len=*), intent(in) :: cstats(:),labels(:),group_label
integer          , intent(in) :: groups(:)
real(kind=dp)    , intent(in) :: xx(:,:)
integer          , intent(in) :: outu
character (len=*), intent(in), optional :: fmt_trailer
integer                       :: igroup,ngroups,group_min,group_max,i,k1,k2,n12,ncol_mat,nobs
real(kind=dp), allocatable    :: group_sum(:,:)
character (len=*), parameter  :: msg="in write_stats_ranges, "
logical          , parameter  :: print_debug = .false.
integer, allocatable          :: nobs_group(:)
if (print_debug) print*,msg,"shape(groups)=",shape(groups)," shape(xx)=",shape(xx) ! debug
nobs      = size(xx,1)
if (size(groups) /= nobs) then
   write (*,*) msg,"size(groups), nobs =",size(groups),nobs," must be equal, STOPPING"
   stop
end if
if (print_debug) print*,msg,"nobs=",nobs
ncol_mat  = size(xx,2)
group_min = groups(1)
group_max = groups(nobs)
if (print_debug) print*,msg,"group_min=",group_min," group_max=",group_max
ngroups   = group_max - group_min + 1
if (ngroups > 0) then
   allocate (group_sum(ngroups,ncol_mat),nobs_group(ngroups))
   group_sum = 0.0_dp
   do igroup=group_min,group_max
      i  = igroup - group_min + 1
      k1 = first_true(groups == igroup)
      k2 = last_true(groups == igroup)
      n12 = k2 - k1 + 1
      nobs_group(i) = n12
      if (k1 == 0 .or. k2 == 0 .or. n12 < 1) cycle
!      print*,"i,k1,k2,shape(xx)=",i,k1,k2,shape(xx) ! debug
      group_sum(i,:) = sum(xx(k1:k2,:),dim=1)
   end do
   do i=1,size(cstats)
      write (outu,"(a,100(',',f0.4))") trim(cstats(i)),stats(cstats(i),group_sum)
   end do
   write (outu,fmt_acsv) trim(group_label),(trim(labels(i)),i=1,size(labels))
   do igroup=group_min,group_max
      i  = igroup - group_min + 1
      if (any(groups == igroup)) write (outu,"(i0,100(',',f0.4))") &
                                 igroup,group_sum(i,:)
   end do
end if
if (present(fmt_trailer)) then
   if (fmt_trailer /= "") write (outu,fmt_trailer)
end if
end subroutine write_stats_ranges
!
pure function first_true(tf) result(i1)
! return the location of the first true element in tf(:)
logical, intent(in) :: tf(:)
integer             :: i1
integer             :: i
i1 = 0
do i=1,size(tf)
   if (tf(i)) then
      i1 = i
      return
   end if
end do
end function first_true
!
pure function last_true(tf) result(i1)
! return position of last true element of tf(:), 0 if no true elements
logical, intent(in) :: tf(:)
integer             :: i1
integer             :: i
i1 = 0
do i=size(tf),1,-1
   if (tf(i)) then
      i1 = i
      return
   end if
end do
end function last_true
!
function percentile(perc,xx) result(yy)
! return the perc percentile (quantile) of xx, with perc = 0.01 meaning the first percentile 
real(kind=dp), intent(in) :: perc  ! percentile
real(kind=dp), intent(in) :: xx(:)
real(kind=dp)             :: yy
integer                   :: i,j,n,irank(size(xx))
n     = size(xx)
if (n < 1) return
i     = min(n,max(1,nint(perc*n)))
call rank(xx,irank)
j     = irank(i)
yy    = xx(j)
end function percentile
!
function percentiles(perc,xx) result(yy)
! return the perc percentile (quantile) of xx, with perc = 0.01 meaning the first percentile 
real(kind=dp), intent(in) :: perc(:)  ! percentile
real(kind=dp), intent(in) :: xx(:)
real(kind=dp)             :: yy(size(perc))
integer                   :: iperc,i,j,n,irank(size(xx))
n     = size(xx)
if (n < 1) return
call rank(xx,irank)
do iperc=1,size(perc)
   i         = min(n,max(1,nint(perc(iperc)*n)))
   j         = irank(i)
   yy(iperc) = xx(j)
end do
end function percentiles
!
function expectile(perc,xx) result(yy)
! return the perc expectile of xx, with perc = 0.01 meaning the first percentile 
real(kind=dp), intent(in) :: perc  ! percentile
real(kind=dp), intent(in) :: xx(:)
real(kind=dp)             :: yy
integer                   :: i,n,irank(size(xx))
n     = size(xx)
if (n < 1) return
i     = min(n,max(1,nint(perc*n)))
call rank(xx,irank)
yy    = mean(xx(irank(:i)))
end function expectile
!
Subroutine rank_real(XDONT, IRNGT)
! __________________________________________________________
!   MRGRNK = Merge-sort ranking of an array
!   For performance reasons, the first 2 passes are taken
!   out of the standard loop, and use dedicated coding.
! __________________________________________________________
! __________________________________________________________
      Real (kind=dp), Dimension (:), Intent (In) :: XDONT
      Integer, Dimension (:), Intent (Out) :: IRNGT
! __________________________________________________________
      Real (kind=dp) :: XVALA, XVALB
!
      Integer, Dimension (SIZE(IRNGT)) :: JWRKT
      Integer :: LMTNA, LMTNC, IRNG1, IRNG2
      Integer :: NVAL, IIND, IWRKD, IWRK, IWRKF, JINDA, IINDA, IINDB
!
      NVAL = Min (SIZE(XDONT), SIZE(IRNGT))
      Select Case (NVAL)
      Case (:0)
         Return
      Case (1)
         IRNGT (1) = 1
         Return
      Case Default
         Continue
      End Select
!
!  Fill-in the index array, creating ordered couples
!
      Do IIND = 2, NVAL, 2
         If (XDONT(IIND-1) <= XDONT(IIND)) Then
            IRNGT (IIND-1) = IIND - 1
            IRNGT (IIND) = IIND
         Else
            IRNGT (IIND-1) = IIND
            IRNGT (IIND) = IIND - 1
         End If
      End Do
      If (Modulo(NVAL, 2) /= 0) Then
         IRNGT (NVAL) = NVAL
      End If
!
!  We will now have ordered subsets A - B - A - B - ...
!  and merge A and B couples into     C   -   C   - ...
!
      LMTNA = 2
      LMTNC = 4
!
!  First iteration. The length of the ordered subsets goes from 2 to 4
!
      Do
         If (NVAL <= 2) Exit
!
!   Loop on merges of A and B into C
!
         Do IWRKD = 0, NVAL - 1, 4
            If ((IWRKD+4) > NVAL) Then
               If ((IWRKD+2) >= NVAL) Exit
!
!   1 2 3
!
               If (XDONT(IRNGT(IWRKD+2)) <= XDONT(IRNGT(IWRKD+3))) Exit
!
!   1 3 2
!
               If (XDONT(IRNGT(IWRKD+1)) <= XDONT(IRNGT(IWRKD+3))) Then
                  IRNG2 = IRNGT (IWRKD+2)
                  IRNGT (IWRKD+2) = IRNGT (IWRKD+3)
                  IRNGT (IWRKD+3) = IRNG2
!
!   3 1 2
!
               Else
                  IRNG1 = IRNGT (IWRKD+1)
                  IRNGT (IWRKD+1) = IRNGT (IWRKD+3)
                  IRNGT (IWRKD+3) = IRNGT (IWRKD+2)
                  IRNGT (IWRKD+2) = IRNG1
               End If
               Exit
            End If
!
!   1 2 3 4
!
            If (XDONT(IRNGT(IWRKD+2)) <= XDONT(IRNGT(IWRKD+3))) Cycle
!
!   1 3 x x
!
            If (XDONT(IRNGT(IWRKD+1)) <= XDONT(IRNGT(IWRKD+3))) Then
               IRNG2 = IRNGT (IWRKD+2)
               IRNGT (IWRKD+2) = IRNGT (IWRKD+3)
               If (XDONT(IRNG2) <= XDONT(IRNGT(IWRKD+4))) Then
!   1 3 2 4
                  IRNGT (IWRKD+3) = IRNG2
               Else
!   1 3 4 2
                  IRNGT (IWRKD+3) = IRNGT (IWRKD+4)
                  IRNGT (IWRKD+4) = IRNG2
               End If
!
!   3 x x x
!
            Else
               IRNG1 = IRNGT (IWRKD+1)
               IRNG2 = IRNGT (IWRKD+2)
               IRNGT (IWRKD+1) = IRNGT (IWRKD+3)
               If (XDONT(IRNG1) <= XDONT(IRNGT(IWRKD+4))) Then
                  IRNGT (IWRKD+2) = IRNG1
                  If (XDONT(IRNG2) <= XDONT(IRNGT(IWRKD+4))) Then
!   3 1 2 4
                     IRNGT (IWRKD+3) = IRNG2
                  Else
!   3 1 4 2
                     IRNGT (IWRKD+3) = IRNGT (IWRKD+4)
                     IRNGT (IWRKD+4) = IRNG2
                  End If
               Else
!   3 4 1 2
                  IRNGT (IWRKD+2) = IRNGT (IWRKD+4)
                  IRNGT (IWRKD+3) = IRNG1
                  IRNGT (IWRKD+4) = IRNG2
               End If
            End If
         End Do
!
!  The Cs become As and Bs
!
         LMTNA = 4
         Exit
      End Do
!
!  Iteration loop. Each time, the length of the ordered subsets
!  is doubled.
!
      Do
         If (LMTNA >= NVAL) Exit
         IWRKF = 0
         LMTNC = 2 * LMTNC
!
!   Loop on merges of A and B into C
!
         Do
            IWRK = IWRKF
            IWRKD = IWRKF + 1
            JINDA = IWRKF + LMTNA
            IWRKF = IWRKF + LMTNC
            If (IWRKF >= NVAL) Then
               If (JINDA >= NVAL) Exit
               IWRKF = NVAL
            End If
            IINDA = 1
            IINDB = JINDA + 1
!
!   Shortcut for the case when the max of A is smaller
!   than the min of B. This line may be activated when the
!   initial set is already close to sorted.
!
!          IF (XDONT(IRNGT(JINDA)) <= XDONT(IRNGT(IINDB))) CYCLE
!
!  One steps in the C subset, that we build in the final rank array
!
!  Make a copy of the rank array for the merge iteration
!
            JWRKT (1:LMTNA) = IRNGT (IWRKD:JINDA)
!
            XVALA = XDONT (JWRKT(IINDA))
            XVALB = XDONT (IRNGT(IINDB))
!
            Do
               IWRK = IWRK + 1
!
!  We still have unprocessed values in both A and B
!
               If (XVALA > XVALB) Then
                  IRNGT (IWRK) = IRNGT (IINDB)
                  IINDB = IINDB + 1
                  If (IINDB > IWRKF) Then
!  Only A still with unprocessed values
                     IRNGT (IWRK+1:IWRKF) = JWRKT (IINDA:LMTNA)
                     Exit
                  End If
                  XVALB = XDONT (IRNGT(IINDB))
               Else
                  IRNGT (IWRK) = JWRKT (IINDA)
                  IINDA = IINDA + 1
                  If (IINDA > LMTNA) Exit! Only B still with unprocessed values
                  XVALA = XDONT (JWRKT(IINDA))
               End If
!
            End Do
         End Do
!
!  The Cs become As and Bs
!
         LMTNA = 2 * LMTNA
      End Do
!
      Return
end subroutine rank_real
!
subroutine write_stats_nday_returns(cstats,tenors,xx,outu,scale_ret)
! write stats on n-day returns computed from price levels xx(:)
character (len=*), intent(in)           :: cstats(:)
integer          , intent(in)           :: tenors(:)
real(kind=dp)    , intent(in)           :: xx(:)
integer          , intent(in)           :: outu
real(kind=dp)    , intent(in), optional :: scale_ret
integer                                 :: i,j,nobs
nobs = size(xx)
do j=1,size(tenors)
   i = tenors(j)
   if (i < 1) cycle
   call print_stats(cstats,default_real(100.0_dp,scale_ret)*(xx(i+1:)/xx(:nobs-i)-1), &
                    str_int(i),print_labels=(i==1),csv=.true.,iu=outu)
end do
write (outu,*)
end subroutine write_stats_nday_returns
!
elemental function default_real(def,opt) result(yy)
! return opt if it is present, otherwise def (real arguments and result)
real(kind=dp), intent(in)           :: def
real(kind=dp), intent(in), optional :: opt
real(kind=dp)                       :: yy
if (present(opt)) then
   yy = opt
else
   yy = def
end if
end function default_real
!
elemental function str_int(i,ndigits) result(ch) 
! convert integer to character
integer,intent(in) :: i 
integer,intent(in), optional :: ndigits
character(len=20)  :: ch 
integer            :: temp, digit,nlen,nzeros
ch = ""
temp = abs(i) 
do 
   digit = mod(temp,10) + 1 
   ch = "0123456789"(digit:digit) // ch 
   temp = temp/10 
   if (temp == 0) exit  ! I'd sure like an UNTIL statement 
end do 
if (present(ndigits)) then
   nlen = len_trim(ch)
   nzeros = ndigits - nlen
   if (nzeros > 0) ch = repeat("0",nzeros) // ch
end if
if (i < 0) ch = "-" // trim(ch)
end function str_int
!
function vol_from_prices(prices) result(vol)
real(kind=dp), intent(in) :: prices(:)
real(kind=dp)             :: vol
integer                   :: i,nret
real(kind=dp), allocatable :: ret(:)
logical, allocatable       :: good_ret(:)
nret = size(prices) - 1
if (nret < 1) then
   vol = -1.0_dp
   return
end if
allocate (ret(nret),good_ret(nret))
ret = 0.0_dp
do i=1,nret
   good_ret(i) = minval(prices([i,i+1])) > 0
   if (good_ret(i)) ret(i) = log(prices(i+1)/prices(i))
end do
vol = stats("volrms",pack(ret,good_ret))
end function vol_from_prices
!
function maxval_antithetic(xx) result(xmax)
real(kind=dp), intent(in) :: xx(:)
real(kind=dp)             :: xmax
xmax = (maxval(xx) + maxval(-xx))/2
end function maxval_antithetic
!
function mean_abs_sum(xx,wgt_pow) result(yy)
real(kind=dp), intent(in) :: xx(:)
real(kind=dp), intent(in), optional :: wgt_pow
real(kind=dp)             :: yy
integer                   :: i,n
real(kind=dp)             :: yadd,wgt,wgt_sum
n  = size(xx)
yy = 0.0_dp
if (n < 1) return
wgt = 0.0_dp
wgt_sum = 0.0_dp
do i=1,n
   yadd = abs(sum(xx(i:)))
   if (present(wgt_pow)) then
      wgt  = (n-i+1.0_dp)**(-wgt_pow)
   else
      wgt = 1.0_dp
   end if
   wgt_sum = wgt_sum + wgt
   yy = yy + wgt*yadd
end do
yy = yy/wgt_sum
end function mean_abs_sum
!
subroutine print_stats_good(cstats,xx,good,labels,outu,csv)
! print stats for good(:,:) elements of columns xx(:,:) and print the number of bad values in each column
character (len=*), intent(in)           :: cstats(:)
real(kind=dp)    , intent(in)           :: xx(:,:)
logical          , intent(in)           :: good(:,:)
character (len=*), intent(in), optional :: labels(:)
integer          , intent(in), optional :: outu
logical          , intent(in), optional :: csv
integer                                 :: i,icol,ncol,outu_
character (len=*), parameter            :: msg="in print_stats_good, ",fmt_ci = "(a,1000(',',i0))"
logical                                 :: csv_
ncol = size(xx,2)
outu_ = default(istdout,outu)
csv_ = default(.false.,csv)
if (size(xx,1) /= size(good,1) .or. size(good,2) /= ncol) then
   write (*,*) msg,"shape(xx)=",shape(xx)," shape(good)=",shape(good), &
               "should be equal, RETURNING"
   return
else if (size(labels) /= ncol) then
   write (*,*) msg,"size(xx,2), size(labels) =",ncol,size(labels)," should be equal, RETURNING"
   return
end if
if (csv_) then
   write (outu_,fmt_ci) "#variables",ncol
   write (outu_,fmt_ci) "#obs",size(xx,1)
   write (outu_,"(1000(a,','))") "var","#good","#bad",(trim(cstats(i)),i=1,size(cstats))
else
   write (outu_,"(/,a,100(1x,i0))") "# of variables, observations =",ncol,size(xx,1)
   write (outu_,"(/,a,t21,100a8)") "var","#good","#bad",(trim(cstats(i)),i=1,size(cstats))
end if
do icol=1,ncol
   if (csv_) then
      write (outu_,"(a,2(',',i8),100(',',f0.4))") labels(icol),count(good(:,icol)),count(.not. good(:,icol)), &
                                          stats(cstats,pack(xx(:,icol),good(:,icol)))
   else
      write (outu_,"(a20,2i8,100f10.4)") labels(icol),count(good(:,icol)),count(.not. good(:,icol)), &
                                  stats(cstats,pack(xx(:,icol),good(:,icol)))
   end if
end do
end subroutine print_stats_good
!
subroutine print_stats_combo_two(cstats,wgt1,x1,x2,outu,csv,fmt_header,fmt_trailer)
! print statistics for linear combinations of x1(:) and x2(:)
character (len=*), intent(in) :: cstats(:)
real(kind=dp), intent(in) :: wgt1(:)
real(kind=dp), intent(in) :: x1(:),x2(:)
integer, intent(in), optional :: outu
logical, intent(in), optional :: csv
character (len=*), intent(in), optional :: fmt_header,fmt_trailer
integer                       :: iwgt,outu_
character (len=20)            :: wgt_label
real(kind=dp)                 :: ww
outu_ = default(istdout,outu)
if (size(x1) /= size(x2)) then
   write (*,*) "in stats_combo_two, sizes of x1 and x2 are ",size(x1),size(x2)," must be equal, STOPPING"
   stop
end if
if (present(fmt_header)) then
   if (fmt_header /= "") write (outu_,fmt_header)
end if
do iwgt=1,size(wgt1)
   ww = wgt1(iwgt)
   write (wgt_label,"(f6.3)") ww
   call print_many_stats_vec_str(cstats,ww*x1 + (1-ww)*x2,label=trim(wgt_label),iu=outu_,csv=.true., &
                                 print_labels=(iwgt==1))
end do
if (present(fmt_trailer)) then
   if (fmt_trailer /= "") write (outu_,fmt_trailer)
end if
end subroutine print_stats_combo_two
!
pure function frac_greater(xvec,xx) result(frac)
! return the fraction of xvec(:) greater than xx
real(kind=dp), intent(in) :: xx,xvec(:)
real(kind=dp)             :: frac
integer                   :: n
n = size(xvec)
if (n > 0) then
   frac = count(xvec > xx)/dble(n)
else
   frac = 0.0_dp
end if
end function frac_greater
!
pure function frac_smaller(xvec,xx) result(frac)
! return the fraction of xvec(:) smaller than xx
real(kind=dp), intent(in) :: xx,xvec(:)
real(kind=dp)             :: frac
integer                   :: n
n = size(xvec)
if (n > 0) then
   frac = count(xvec < xx)/dble(n)
else
   frac = 0.0_dp
end if
end function frac_smaller
!
function detrend(xx) result(yy)
! remove the trend in xx(:) so that xx(1) = xx(size(xx))
real(kind=dp), intent(in) :: xx(:)
real(kind=dp)             :: yy(size(xx))
integer                   :: i,n
real(kind=dp)             :: slope,yshift
n = size(xx)
if (n == 0) then
   return
else if (n == 1) then
   yy(1) = 0.0_dp
   return
end if
slope = (xx(n) - xx(1))/(n-1)
yshift = 0.0_dp
do i=1,n
   yy(i) = xx(i) + yshift
   yshift = yshift - slope
end do
end function detrend
!
function rescale_sd_col(xmat,col_base) result(ymat)
real(kind=dp), intent(in) :: xmat(:,:)
integer      , intent(in), optional :: col_base
real(kind=dp)             :: ymat(size(xmat,1),size(xmat,2))
integer                   :: icol,ncol,col_base_
real(kind=dp)             :: sd_col_base,sd_col
ncol = size(xmat,2)
ymat = xmat
if (ncol < 2) return
if (present(col_base)) then
   col_base_ = col_base
else
   col_base_ = 1
end if
if (col_base_ < 1 .or. col_base_ > ncol) return
sd_col_base = sd(ymat(:,col_base_))
do icol=1,ncol
   if (icol == col_base_) cycle
   sd_col = sd(ymat(:,icol))
   if (sd_col > 0) ymat(:,icol) = ymat(:,icol)*sd_col_base/sd_col
end do
end function rescale_sd_col
!
function rescale_sd(xx) result(yy)
real(kind=dp), intent(in) :: xx(:)
real(kind=dp)             :: yy(size(xx))
real(kind=dp)             :: xsd
xsd = sd(xx)
if (xsd > 0) then
   yy = xx/xsd
else
   yy = xx
end if
end function rescale_sd
!
pure function rms_nonzero(xx) result(xrms)
real(kind=dp), intent(in) :: xx(:)
real(kind=dp)             :: xrms
xrms = rms(pack(xx,xx/=0.0_dp))
end function rms_nonzero
!
function equal_vol_sum(xmat) result(xvec)
real(kind=dp), intent(in) :: xmat(:,:)
real(kind=dp)             :: xvec(size(xmat,1))
real(kind=dp)             :: wgt(size(xmat,2)),sd_col
integer                   :: icol,ncol
ncol = size(xmat,2)
do icol=1,ncol
   sd_col = sd(xmat(:,icol))
   if (sd_col > 0) then
      wgt(icol) = 1/sd_col
   else
      wgt(icol) = 0.0_dp
   end if
end do
xvec = matmul(xmat,wgt)
end function equal_vol_sum
!
subroutine set_obs_per_year(period)
character (len=*), intent(in) :: period
select case (period)
   case ("day")    ; obs_per_year = 252.0_dp
   case ("week")   ; obs_per_year =  52.0_dp
   case ("month")  ; obs_per_year =  12.0_dp
   case ("quarter"); obs_per_year =   4.0_dp
   case ("year")   ; obs_per_year =   1.0_dp
end select
end subroutine set_obs_per_year
!
subroutine rolling_stat_good_vec(cstat,nuse,xx,good,xstat,good_stat)
! compute in xstat(:) rolling statistics on xx(:) using nuse values where the data is good(:)
character (len=*), intent(in)  :: cstat
integer          , intent(in)  :: nuse
real(kind=dp)    , intent(in)  :: xx(:)        ! (n) -- data for which rolling statistic computed
logical          , intent(in)  :: good(:)      ! (n) -- true where the xx has good data
real(kind=dp)    , intent(out) :: xstat(:)     ! (n) -- rolling statistic
logical          , intent(out) :: good_stat(:) ! (n) -- true where rolling statistic could be computed
integer                        :: i,i1,n
good_stat = .false.
n = size(xx)
if (any([size(good),size(xstat),size(good_stat)] /= size(xx))) then
   write (*,*) "in statistics_mod::rolling_stat, size(xx), size(good), size(xstat), size(good_stat) =", &
               size(xx),size(good),size(xstat),size(good_stat)," should all be equal, STOPPING"
   stop
end if
if (n < 1 .or. nuse < 1) return
do i=nuse,n
   i1 = i - nuse + 1
   if (all(good(i1:i))) then
      good_stat(i) = .true.
      xstat(i)     = stats(cstat,xx(i1:i))
   end if
end do
end subroutine rolling_stat_good_vec
!
subroutine rolling_stat_good_matrix(cstat,nuse,xx,good,xstat,good_stat)
! compute in xstat(:) rolling statistics on xx(:) where the data is good(:)
character (len=*), intent(in)  :: cstat
integer          , intent(in)  :: nuse
real(kind=dp)    , intent(in)  :: xx(:,:)        ! (n) -- data for which rolling statistic computed
logical          , intent(in)  :: good(:,:)      ! (n) -- true where the xx has good data
real(kind=dp)    , intent(out) :: xstat(:,:)     ! (n) -- rolling statistic
logical          , intent(out) :: good_stat(:,:) ! (n) -- true where rolling statistic could be computed
integer                        :: n,icol,ncol
good_stat = .false.
n = size(xx,1)
ncol = size(xx,2)
if (any([size(good,1),size(xstat,1),size(good_stat,1)] /= size(xx,1)) .or. &
    any([size(good,2),size(xstat,2),size(good_stat,2)] /= size(xx,2))) then
   write (*,*) "in rolling_stat, size(xx), size(good), size(xstat), size(good_stat) =", &
               size(xx),size(good),size(xstat),size(good_stat)," should all be equal, STOPPING"
   stop
end if
do icol=1,ncol
   call rolling_stat_good_vec(cstat,nuse,xx(:,icol),good(:,icol),xstat(:,icol),good_stat(:,icol))
end do
end subroutine rolling_stat_good_matrix
!
function linearly_weighted_mean(xx) result(xmean)
real(kind=dp), intent(in) :: xx(:)
real(kind=dp)             :: xmean
integer                   :: i,n
n = size(xx)
if (n < 1) then
   xmean = 0.0_dp
   return
end if
xmean = sum([(i*xx(i),i=1,n)]) / (0.5_dp*n*(1+n))
end function linearly_weighted_mean
!
pure function acf_mat(xx,nlags) result(xacf)
! return the autcorrelations of the columns of xx(:,:)
real(kind=dp), intent(in) :: xx(:,:)
integer      , intent(in) :: nlags
real(kind=dp)             :: xacf(nlags,size(xx,2))
integer                   :: icol
forall (icol=1:size(xx,2)) xacf(:,icol) = acf_vec(xx(:,icol),nlags)
end function acf_mat
!
pure function acf_vec(xx,nlags) result(xacf)
! return the autocorrelation up to the first nlags lags
real(kind=dp), intent(in) :: xx(:)
integer      , intent(in) :: nlags
real(kind=dp)             :: xacf(nlags)
real(kind=dp)             :: sumsq,xmean,xzm(size(xx))
integer                   :: i,nx
nx = size(xx)
if (nlags < 1) return
xacf = bad_acf
if (nx < 2) return
xmean = sum(xx)/nx
xzm   = xx - xmean
sumsq = sum(xzm**2)
if (sumsq <= zero) then
   xacf = zero
else
   do i=1,min(nlags,nx-1)
      xacf(i) = dot_product(xzm(i+1:),xzm(:nx-i))/sumsq
   end do
end if
end function acf_vec
!
pure function mean_mask(xx,xmask) result(xmean)
real(kind=dp), intent(in) :: xx(:)
logical      , intent(in) :: xmask(:)
real(kind=dp)             :: xmean
integer                   :: n
n = size(xx)
if (size(xmask) /= n) then
   xmean = -huge(0.0e0_dp)
else if (n < 1) then
   xmean = 0.0_dp
else
   xmean = sum(xx,xmask)/max(1,count(xmask))
end if
end function mean_mask
!
function iqr(xx) result(yy)
real(kind=dp), intent(in) :: xx(:)
real(kind=dp)             :: yy
yy = percentile(0.75_dp,xx) - percentile(0.25_dp,xx)
end function iqr
!
function is_outlier_iqr(xx,iqr_mult) result(tf)
! determine which elements of xx(:) are outliers using Tukey's method involving the interquartile range
real(kind=dp), intent(in)           :: xx(:)
real(kind=dp), intent(in), optional :: iqr_mult
logical                             :: tf(size(xx))
real(kind=dp)                       :: iqr_mult_,q1,q3,xiqr,xlow,xhigh
real(kind=dp), parameter            :: tukey_iqr_mult = 1.5_dp
q1    = percentile(0.25_dp,xx)
q3    = percentile(0.75_dp,xx)
xiqr  = q3 - q1
iqr_mult_ = default(tukey_iqr_mult,iqr_mult)
xlow  = q1 - iqr_mult_*xiqr
xhigh = q3 + iqr_mult_*xiqr
tf = xx < xlow .or. xx > xhigh
end function is_outlier_iqr
!
function true_pos_func(tf) result(ipos)
! return in ipos the positions of the true elements in tf(:)
logical, intent(in) :: tf(:)
integer             :: ipos(count(tf))
integer             :: i,j
j = 0
do i=1,size(tf)
   if (tf(i)) then
      j = j + 1
      ipos(j) = i
   end if
end do
end function true_pos_func
!
function is_outlier_iqr_good(xx,good,iqr_mult) result(tf)
! determine which elements of xx(:) where good(:) is .true. are outliers using Tukey's method involving the interquartile range
real(kind=dp), intent(in)           :: xx(:)
logical      , intent(in)           :: good(:)
real(kind=dp), intent(in), optional :: iqr_mult
logical                             :: tf(size(xx))
integer                             :: iuse(count(good))
if (size(xx) /= size(good)) return
tf = .false.
iuse = true_pos_func(good)
tf(iuse) = is_outlier_iqr(xx(iuse),iqr_mult)
end function is_outlier_iqr_good
!
function num_outliers_iqr(xx,good,iqr_mult) result(nout)
! count elements of xx(:) where good(:) is .true. are outliers using Tukey's method involving the interquartile range
real(kind=dp), intent(in)           :: xx(:)
logical      , intent(in), optional :: good(:)
real(kind=dp), intent(in), optional :: iqr_mult
integer                             :: nout
if (present(good)) then
   nout = count(is_outlier_iqr_good(xx,good,iqr_mult))
else
   nout = count(is_outlier_iqr(xx,iqr_mult))
end if
end function num_outliers_iqr
!
function moving_average_i1_i2(xx,i1,i2) result(xma)
! return moving average of xx(:) using observations i1 to i2, where the current observation corresponds to 1
! for (i1,i2) = (1,nma) the function returns a simple moving average with nma terms, including the current observation
real(kind=dp), intent(in) :: xx(:)
integer      , intent(in) :: i1,i2
real(kind=dp)             :: xma(size(xx))
integer                   :: i,n,j1,j2
xma = 0.0_dp
if (i1 > i2 .or. n < 1) return
n = size(xx)
do i=1,n
   j1 = min(n,max(1,i - i1 + 1))
   j2 = min(n,max(1,i - i2 + 1))
   xma(i) = mean(xx(j2:j1))
end do
end function moving_average_i1_i2
!
pure function madev_vec(xx,nma,wgt_ma,method) result(xdev)
! compute the simple moving average deviation of xx(:)
real(kind=dp), intent(in) :: xx(:)
integer      , intent(in) :: nma ! # of terms in moving average
real(kind=dp), intent(in), optional :: wgt_ma
character (len=*), intent(in), optional :: method
real(kind=dp)             :: xdev(size(xx)),wgt_ma_
integer                   :: i,i1,n
character (len=20)        :: method_
real(kind=dp)             :: wgt_moving_mean
if (present(method)) then
   method_ = method
else
   method_ = "diff"
end if
n = size(xx)
if (n < 1) return
wgt_ma_ = default(1.0_dp,wgt_ma)
if (nma < 1) then
   xdev = xx
   return
end if
xdev = 0.0_dp
do i=1,n
   i1 = max(1,i - nma + 1)
   wgt_moving_mean = wgt_ma_*mean(xx(i1:i))
   if (method_ == "ratio") then
      if (wgt_moving_mean /= 0.0_dp) xdev(i) = xx(i)/wgt_moving_mean - 1.0_dp
   else
      xdev(i) = xx(i) - wgt_moving_mean
   end if
end do
end function madev_vec
!
pure function madev_2ma_vec(xx,nma1,nma2,wgt_ma,method) result(xdev)
! compute the simple moving average deviation of xx(:)
real(kind=dp), intent(in) :: xx(:)
integer      , intent(in) :: nma1, nma2 ! # of terms in each moving average
real(kind=dp), intent(in), optional :: wgt_ma
character (len=*), intent(in), optional :: method
real(kind=dp)             :: xdev(size(xx)),wgt_ma_
integer                   :: i,i11,i12,n
character (len=20)        :: method_
real(kind=dp)             :: moving_mean_1,wgt_moving_mean_2
if (present(method)) then
   method_ = method
else
   method_ = "diff"
end if
n = size(xx)
if (n < 1) return
wgt_ma_ = default(1.0_dp,wgt_ma)
if (nma2 < 1) then
   xdev = xx
   return
end if
xdev = 0.0_dp
do i=1,n
   i11 = max(1,i - nma1 + 1)
   i12 = max(1,i - nma2 + 1)
   moving_mean_1 = mean(xx(i11:i))
   wgt_moving_mean_2 = wgt_ma_*mean(xx(i12:i))
   if (method_ == "ratio") then
      if (wgt_moving_mean_2 /= 0.0_dp) xdev(i) = moving_mean_1/wgt_moving_mean_2 - 1.0_dp
   else
      xdev(i) = moving_mean_1 - wgt_moving_mean_2
   end if
end do
end function madev_2ma_vec
!
function madev_mat(xx,nma,wgt_ma,method) result(xdev)
! compute the simple moving average deviation of each column of xx(:,:)
real(kind=dp), intent(in) :: xx(:,:)
integer      , intent(in) :: nma ! # of terms in moving average
real(kind=dp), intent(in), optional :: wgt_ma
character (len=*), intent(in), optional :: method
real(kind=dp)             :: xdev(size(xx,1),size(xx,2))
integer                   :: icol
forall (icol=1:size(xx,2)) xdev(:,icol) = madev(xx(:,icol),nma,wgt_ma,method)
end function madev_mat
!
subroutine madev_good(xx,good,nma,xdev,good_dev,wgt_ma)
real(kind=dp), intent(in) :: xx(:)   ! (n)
logical      , intent(in) :: good(:) ! (n)
integer      , intent(in) :: nma
real(kind=dp), intent(in), optional :: wgt_ma
real(kind=dp), intent(out) :: xdev(size(xx))
logical      , intent(out) :: good_dev(size(xx))
real(kind=dp)              :: wgt_ma_
integer                    :: i,i1,n
n = size(xx)
if (n < 1 .or. size(good) /= n) return
wgt_ma_ = default(1.0_dp,wgt_ma)
if (nma < 1) then
   xdev = xx
   return
end if
good_dev = .false.
do i=1,n
   i1 = max(1,i - nma + 1)
   if (good(i)) then
      xdev(i) = xx(i) - wgt_ma_*mean(pack(xx(i1:i),good(i1:i)))
      good_dev(i) = .true.
   end if
end do
end subroutine madev_good
!
pure function bin_thresh(xx,thresh) result(ibin)
real(kind=dp), intent(in) :: xx
real(kind=dp), intent(in) :: thresh(:)
integer                   :: ibin
integer                   :: ithresh,nthresh
nthresh = size(thresh)
ibin = nthresh + 1
do ithresh=1,nthresh
   if (xx <= thresh(ithresh)) then
      ibin = ithresh
      return
   end if
end do
end function bin_thresh
!
pure function num_bin_changes(xx,thresh) result(nch)
real(kind=dp), intent(in) :: xx(:)
real(kind=dp), intent(in) :: thresh(:)
integer                   :: nch
integer                   :: ibin,ibin_old,nthresh,i,n
nthresh = size(thresh)
n = size(xx)
nch = 0
if (n < 2 .or. nthresh < 1) then
   nch = 0
   return
end if
do i=1,n
   ibin = bin_thresh(xx(i),thresh)
   if (i > 1) then
      if (ibin /= ibin_old) nch = nch + 1
   end if
   ibin_old = ibin
end do
end function num_bin_changes
!
function cagr_prices(prices) result(yy)
real(kind=dp), intent(in) :: prices(:)
real(kind=dp)             :: yy
integer                   :: n
real(kind=dp), parameter  :: bad_cagr = -999.0_dp,scale_ret_ = 100.0_dp
real(kind=dp)             :: xtime
n  = size(prices)
yy = bad_cagr
if (n < 2) return
if (any(prices([1,n]) <= 0.0_dp)) return
xtime = (n-1)/obs_per_year
! print*,"xtime=",xtime
yy =  scale_ret_ * ((prices(n)/prices(1))**(1/xtime) - 1)
end function cagr_prices
!
pure function cagr(xx,scale_ret) result(yy)
real(kind=dp), intent(in) :: xx(:)
real(kind=dp), intent(in), optional :: scale_ret
real(kind=dp)                       :: yy
real(kind=dp)                       :: scale_ret_
integer                             :: n
n = size(xx)
scale_ret_ = default(scale_ret_cagr,scale_ret)
if (n < 1 .or. obs_per_year <= 0.0_dp) then
   yy = 0.0_dp
   return
end if
yy = scale_ret_ * (product(1 + xx/scale_ret_)**(obs_per_year/n) - 1.0_dp)
end function cagr
!
function win_loss(xx) result(yy)
real(kind=dp), intent(in) :: xx(:)
real(kind=dp)             :: yy
real(kind=dp)             :: gross_loss
gross_loss = -sum(xx,xx<0.0_dp)
if (gross_loss > 0.0_dp) then
   yy = sum(xx,xx>0.0_dp)/gross_loss
else
   yy = 0.0_dp
end if
end function win_loss
!
function cumul_ret(xret) result(xcumul)
real(kind=dp), intent(in) :: xret(:)
real(kind=dp)             :: xcumul
if (size(xret) < 1) then
   xcumul = 0.0_dp
   return
end if
if (all(xret > -1.0_dp)) then
   xcumul = product(1+xret) - 1.0_dp
else
   xcumul = -1.0_dp
end if
end function cumul_ret
!
subroutine print_computed_basket_stats(cstats_agg,cstats_ret,sym,xstats,nvar,nacf,outu,fmt_header)
character (len=*), intent(in) :: cstats_agg(:) ! nstats_agg
character (len=*), intent(in) :: cstats_ret(:) ! nstats_ret
character (len=*), intent(in) :: sym(:)        ! nsym
real(kind=dp)    , intent(in) :: xstats(:,:,:) ! (nstats_ret + nacf, nstats_agg, nsym)
integer          , intent(in) :: nvar(:)       ! nsym
integer          , intent(in), optional :: outu,nacf
character (len=*), intent(in), optional :: fmt_header
integer                                 :: iacf,nacf_,istat,jstat,outu_,nstats_agg,nstats_ret,isym,nsym,ierr
nacf_ = default(0,nacf)
ierr = first_false([size(xstats,1)==size(cstats_ret)+nacf_, size(xstats,2)==size(cstats_agg), size(xstats,3)==size(sym), &
                    size(nvar)==size(sym)])
if (ierr /= 0) then
   print*,"in statistics_mod::print_computed_basket_stats, ierr =",ierr," RETURNING"
   return
end if
nstats_agg = size(cstats_agg)
nstats_ret = size(cstats_ret)
nsym = size(sym)
outu_ = default(istdout,outu)
call write_format(fmt_header,outu_)
   do istat=1,nstats_agg  
      write (outu_,"(/,'statistic: ',a)") trim(cstats_agg(istat))
      write (outu_,"(a25,100a10)",advance="no") "category","#stocks",(trim(cstats_ret(jstat)),jstat=1,nstats_ret)
      write (outu_,"(100(:,4x,'ACF_',i2.2))") (iacf,iacf=1,nacf)
      do isym=1,nsym
         write (outu_,"(a25,i10,100f10.4)") trim(sym(isym)),nvar(isym),xstats(:,istat,isym)
      end do  
   end do
end subroutine print_computed_basket_stats
!
pure function first_false(tf) result(i1)
! return the location of the first false element in tf(:)
logical, intent(in) :: tf(:)
integer             :: i1
integer             :: i
i1 = 0
do i=1,size(tf)
   if (.not. tf(i)) then
      i1 = i
      return
   end if
end do
end function first_false
!
subroutine write_format(format_str,iunit,advance)
! write format_str to unit iunit if it is present and not blank
! otherwise, do nothing
character (len=*), intent(in), optional :: format_str
integer          , intent(in), optional :: iunit
character (len=*), intent(in), optional :: advance
integer                                 :: iu
if (.not. present(format_str)) return
if (present(iunit)) then
   iu = iunit
else
   iu = istdout
end if
! iu = default(istdout,iunit)
if (format_str /= "") write (iu,format_str,advance=default("yes",advance))
end subroutine write_format
!
subroutine set_alloc_real_vec(xx,yy) 
! for real vectors xx(:) and yy(:), allocate yy and set it to xx
real(kind=dp), intent(in)               :: xx(:)
real(kind=dp), intent(out), allocatable :: yy(:)
integer                                 :: ni
ni = size(xx)
allocate (yy(ni))
yy = xx
end subroutine set_alloc_real_vec
!
subroutine set_alloc_real_matrix(xx,yy)
! for real matrices xx(:,:) and yy(:,:), allocate yy and set it to xx
real(kind=dp) , intent(in)               :: xx(:,:)
real(kind=dp) , intent(out), allocatable :: yy(:,:)
allocate (yy(size(xx,1),size(xx,2)))
yy = xx
end subroutine set_alloc_real_matrix
!
pure recursive subroutine set_alloc_int_vec(ii,jj,jmin,jmax)
! for integer vectors xx(:) and yy(:), allocate yy and set it to xx
integer, intent(in)               :: ii(:)
integer, intent(out), allocatable :: jj(:)
integer, intent(in) , optional    :: jmin,jmax
integer                           :: ni
if (present(jmin) .and. present(jmax)) then
   call set_alloc_int_vec(pack(ii,ii >= jmin .and. ii <= jmax),jj)
else if (present(jmin)) then
   call set_alloc_int_vec(pack(ii,ii >= jmin),jj)
else if (present(jmax)) then
   call set_alloc_int_vec(pack(ii,ii <= jmax),jj)
else
   ni = size(ii)
!   print*,"size(ii)=",size(ii) ! debug
!   print*,"ni=",ni ! debug
   allocate (jj(ni))
   jj = ii
end if
end subroutine set_alloc_int_vec
!
subroutine set_alloc_character_vec(xx,yy,nsize) 
! for character arrays xx(:) and yy(:), allocate yy and set it to xx
character (len=*) , intent(in)               :: xx(:)
character (len=*) , intent(out), allocatable :: yy(:)
integer           , intent(out), optional    :: nsize
allocate (yy(size(xx)))
yy = xx
if (present(nsize)) nsize = size(yy)
end subroutine set_alloc_character_vec
!
function compound_ret(ret,method,scale_ret) result(yy)
real(kind=dp)    , intent(in) :: ret(:)
character (len=*), intent(in) :: method
real(kind=dp)    , intent(in) :: scale_ret
real(kind=dp)                 :: yy
integer                       :: n
n = size(ret)
if (n < 1) then
   yy = 0.0_dp
   return
end if
if (method == "sum") then
   yy = sum(ret)
else 
   yy = scale_ret*(product(1+ret/scale_ret) - 1.0_dp)
end if
end function compound_ret
!
elemental function signed_power(xx,xpow) result(yy)
real(kind=dp), intent(in) :: xx,xpow
real(kind=dp)             :: yy
if (xx == 0.0_dp) then
   yy = 0.0_dp
else if (xx > 0.0_dp) then
   yy = xx**xpow
else
   yy = -(abs(xx)**xpow)
end if
end function signed_power
!
subroutine vol_normalize_ema(xx,yy,lambda,power,xsq_const,xsq_min,xsq_max)
! normalize df using df_ret
! type(date_frame), intent(in)           :: df_ret
real(kind=dp)   , intent(in)           :: xx(:)
! type(date_frame), intent(in out)       :: df
real(kind=dp)   , intent(in out)       :: yy(:)
real(kind=dp)   , intent(in)           :: lambda
real(kind=dp)   , intent(in), optional :: power,xsq_const,xsq_min,xsq_max
integer                                :: i,nobs
real(kind=dp)                          :: xsq,xold(size(xx)),power_,xsq_const_,xsq_min_,xsq_max_
xsq_const_ = default(0.01_dp,xsq_const)
xsq_min_ = default(0.01_dp,xsq_min)
xsq_max_ = default(1.0_dp,xsq_max)
power_ = default(1.0_dp,power)
nobs = size(xx)
if (nobs < 1) return
xsq = -1.0_dp
xold = xx
xsq = xold(1)**2
do i=2,nobs
   if (xsq > 0) then
      yy(i) = yy(i)/(sqrt(min(max(xsq_const_+xsq,xsq_min_),xsq_max_))**power_)
      xsq = (1-lambda)*xsq + lambda*xold(i)**2    
   else
      xsq = xold(i)**2
   end if
end do
end subroutine vol_normalize_ema
!
pure function sq_dist_vec_mat(xx,xmat) result(dist)
real(kind=dp), intent(in) :: xx(:),xmat(:,:)
real(kind=dp)             :: dist(size(xmat,1))
integer                   :: i
if (size(xx) /= size(xmat,2)) then
   dist = bad_real
else
   forall (i=1:size(xmat,1)) dist(i) = sum((xx - xmat(i,:))**2)
end if
end function sq_dist_vec_mat
!
pure function sq_dist_vec_vec(xx,yy) result(dist)
real(kind=dp), intent(in) :: xx(:),yy(:)
real(kind=dp)             :: dist
if (size(xx) /= size(yy)) then
   dist = bad_real
else
   dist = sum((xx-yy)**2)
end if
end function sq_dist_vec_vec
!
function running_mean(xx) result(xmean)
real(kind=dp), intent(in) :: xx(:)
real(kind=dp)             :: xmean(size(xx))
integer                   :: i,n
n = size(xx)
if (n < 1) return
xmean(1) = xx(1)
do i=2,n
   xmean(i) = ((i-1)*xmean(i-1) + xx(i))/i
end do
end function running_mean
! 
pure function rollmean(xx,k) result(yy)
! compute the rolling mean of xx(:) using at most k observations
real(kind=dp), intent(in) :: xx(:)
integer      , intent(in) :: k
real(kind=dp)             :: yy(size(xx))
integer                   :: i
real(kind=dp)             :: xsum
if (k < 1) then
   yy = 0.0_dp
   return
end if
xsum = 0.0_dp
do i=1,size(xx)
   if (i <= k) then
      xsum  = xsum + xx(i)
      yy(i) = xsum/i
   else
      xsum  = xsum + xx(i) - xx(i-k)
      yy(i) = xsum/k
   end if
end do
end function rollmean
!
pure function lag(xx,k,xdefault) result(yy)
real(kind=dp), intent(in) :: xx(:)
integer      , intent(in) :: k
real(kind=dp), intent(in), optional :: xdefault
real(kind=dp)             :: yy(size(xx))
integer                   :: n,j1,j2
n  = size(xx)
yy = default(0.0_dp,xdefault)
if (k == 0) then
   yy = xx
   return
else if (abs(k) > n) then
   return
end if
j1 = abs(k) + 1
j2 = n - abs(k)
if (k > 0) then
   yy(j1:) = xx(:j2)
else
   yy(:j2) = xx(j1:)
end if
end function lag
!
pure function rollmean_12(xx,j1,j2,xdefault) result(yy)
! compute the rolling mean of xx(:) using observations j1 to j2
real(kind=dp), intent(in)           :: xx(:)
integer      , intent(in)           :: j1,j2
real(kind=dp), intent(in), optional :: xdefault
real(kind=dp)                       :: yy(size(xx))
yy = lag(rollmean(xx,j2-j1+1),j1-1,xdefault=xdefault)
end function rollmean_12
!
pure function rollmean_ratio_vec(xx,k1,k2) result(yy)
real(kind=dp), intent(in) :: xx(:)
integer      , intent(in) :: k1,k2
real(kind=dp)             :: yy(size(xx))
yy = rollmean(xx,k1)/rollmean(xx,k2)
end function rollmean_ratio_vec
!
function rollmean_ratio_mat(xx,k1,k2) result(yy)
real(kind=dp), intent(in) :: xx(:,:)
integer      , intent(in) :: k1,k2
real(kind=dp)             :: yy(size(xx,1),size(xx,2))
integer                   :: icol
forall (icol=1:size(xx,2)) yy(:,icol) = rollmean_ratio(xx(:,icol),k1,k2)
end function rollmean_ratio_mat
!
subroutine filter_data_vec(xx,xmin,xmax,iprint,cstats,outu,fmt_header,fmt_trailer)
! remove elements of xx(:) outside the range (xmin,xmax), optionally print statistics on original, kept, and removed data
real(kind=dp)    , intent(in out), allocatable :: xx(:)
real(kind=dp)    , intent(in)                  :: xmin,xmax
integer          , intent(in)    , optional    :: iprint ! (0,no printing), (1,#obs kept, removed), (2, stats original), (3, stats kept), (4, stats removed)
character (len=*), intent(in)    , optional    :: cstats(:)
integer          , intent(in)    , optional    :: outu
character (len=*), intent(in)    , optional    :: fmt_header,fmt_trailer
logical                                        :: keep(size(xx))
integer                                        :: iprint_,norig,n,nrem,outu_
real(kind=dp)                    , allocatable :: xremoved(:)
if (.not. allocated(xx)) return
outu_ = default(istdout,outu)
call write_format(fmt_header,outu_)
norig = size(xx)
if (norig < 1) return
iprint_ = default(4,iprint)
if (iprint > 1) call print_stats(cstats,xx,"original",iu=outu_,fmt_header="()")
keep = xx>=xmin .and. xx <=xmax
call set_alloc(pack(xx,.not. keep),xremoved)
call set_alloc(pack(xx,keep),xx)
n    = size(xx)
nrem = norig - n
if (iprint > 2) call print_stats(cstats,xx,"kept",iu=outu_,print_labels=.false.)
if (iprint > 3) call print_stats(cstats,xremoved,"removed",iu=outu_,print_labels=.false.)
if (iprint > 0) write (outu_,"(/,6a15,/,3f15.6,3i15)") "xmin","xmax","frac_removed","#original","#kept","#removed", &
                                                        xmin,xmax,nrem/dble(n),norig,n,nrem
call write_format(fmt_trailer,outu_)
end subroutine filter_data_vec
!
subroutine filter_data_matrix(xx,xmin,xmax,icol_filter,iprint,cstats,outu,fmt_header,fmt_trailer)
! remove rows of xx(:,:) where xx(:,icol_filter) is outside the range (xmin,xmax), optionally print statistics on original, kept, and removed data
real(kind=dp)    , intent(in out), allocatable, target :: xx(:,:)
real(kind=dp)    , intent(in)                  :: xmin,xmax
integer          , intent(in)    , optional    :: icol_filter
integer          , intent(in)    , optional    :: iprint ! (0,no printing), (1,#obs kept, removed), (2, stats original), (3, stats kept), (4, stats removed)
character (len=*), intent(in)    , optional    :: cstats(:)
integer          , intent(in)    , optional    :: outu
character (len=*), intent(in)    , optional    :: fmt_header,fmt_trailer
logical                                        :: keep(size(xx,1))
integer                                        :: iprint_,norig,n,nrem,outu_,icol_filter_
real(kind=dp)                    , allocatable :: xremoved(:,:)
real(kind=dp)                    , pointer     :: zz(:)
integer                          , allocatable :: ikeep(:),irem(:)
icol_filter_ = default(1,icol_filter)
if (.not. allocated(xx)) return
if (icol_filter_ > size(xx,2)) return
zz => xx(:,icol_filter_)
outu_ = default(istdout,outu)
! print*,"outu_=",outu_ !! debug
call write_format(fmt_header,outu_)
norig = size(xx,1)
if (norig < 1) return
iprint_ = default(4,iprint)
if (iprint_ > 1) call print_stats(cstats,zz,"original",iu=outu_,fmt_header="()")
keep = zz>=xmin .and. zz <=xmax
call set_alloc(true_pos_func(keep),ikeep)
call set_alloc(true_pos_func(.not. keep),irem)
call set_alloc((xx(irem,:)),xremoved)
call set_alloc((xx(ikeep,:)),xx)
n    = size(xx,1)
nrem = norig - n
if (iprint_ > 2) call print_stats(cstats,xx(:,icol_filter_),"kept",iu=outu_,print_labels=.false.)
if (iprint_ > 3) call print_stats(cstats,xremoved(:,icol_filter_),"removed",iu=outu_,print_labels=.false.)
if (iprint_ > 0) write (outu_,"(/,6a15,/,3f15.6,3i15)") "xmin","xmax","frac_removed","#original","#kept","#removed", &
                                                        xmin,xmax,nrem/dble(n),norig,n,nrem
call write_format(fmt_trailer,outu_)
end subroutine filter_data_matrix
!
subroutine assert_equal_2(msg,n1,n2)
! print an error message and stop if n1 /= n2
character (len=*), intent(in) :: msg
integer          , intent(in) :: n1,n2
if (n1 /= n2) then
   write (*,"(a,2(1x,i0),a)") msg,n1,n2," must be equal, STOPPING"
   stop
end if
end subroutine assert_equal_2
!
function sums(xx,max_terms) result(yy)
real(kind=dp), intent(in) :: xx(:)
integer      , intent(in) :: max_terms
real(kind=dp)             :: yy(size(xx),max_terms)
integer                   :: i,j,n
n = size(xx)
if (n < 1 .or. max_terms < 1) return
yy(:,1) = xx
do j=2,max_terms
   do i=1,j-1
      yy(i,j) = yy(i,j-1)
   end do
   do i=j,n
      yy(i,j) = yy(i,j-1) + xx(i-j+1)
   end do
end do
do j=n+1,max_terms
   yy(:,j) = yy(:,n)
end do
end function sums
!
function moving_averages(xx,max_terms) result(yy)
real(kind=dp), intent(in) :: xx(:)
integer      , intent(in) :: max_terms
real(kind=dp)             :: yy(size(xx),max_terms)
integer                   :: i,j,n
n = size(xx)
if (n < 1 .or. max_terms < 1) return
yy = sums(xx,max_terms)
do j=2,max_terms
   do i=1,j-1
      yy(i,j) = yy(i,j)/i
   end do
   do i=j,n
      yy(i,j) = yy(i,j)/j
   end do
end do
do j=n+1,max_terms
   yy(:,j) = yy(:,n)
end do
end function moving_averages
!
function sums_nonoverlap(xx,nterms) result(xsums)
real(kind=dp), intent(in)  :: xx(:)
integer      , intent(in)  :: nterms
real(kind=dp), allocatable :: xsums(:)
integer                    :: i,i1,nsums,n
n = size(xx)
if (n == 0 .or. nterms < 1 .or. n < nterms) then
   allocate (xsums(0))
   return
else if (nterms == 1) then
   call set_alloc(xx,xsums)
   return
end if
nsums = n/nterms
allocate (xsums(nsums))
do i=1,nsums
   i1 = 1 + (i-1)*nterms
   xsums(i) = sum(xx(i1:i1+nterms-1))
end do 
end function sums_nonoverlap
!
function normalize_vol_mat(xx,vol_target) result(yy)
! scale the columns of xx(:,:) to have volatility of vol_target
real(kind=dp), intent(in) :: xx(:,:)
real(kind=dp), intent(in) :: vol_target
real(kind=dp)             :: yy(size(xx,1),size(xx,2))
integer                   :: i,ncol
real(kind=dp)             :: vol
ncol = size(xx,2)
yy   = xx
do i=1,ncol
   vol = stats("vol",xx(:,i))
   if (vol /= 0.0_dp) yy(:,i) = xx(:,i)*vol_target/vol
end do
end function normalize_vol_mat
!
function normalize_vol_vec(xx,vol_target) result(yy)
! scale xx(:) to have volatility of vol_target
real(kind=dp), intent(in) :: xx(:)
real(kind=dp), intent(in) :: vol_target
real(kind=dp)             :: yy(size(xx))
real(kind=dp)             :: vol
yy   = xx
vol = stats("vol",xx)
if (vol /= 0.0_dp) yy = xx*vol_target/vol
end function normalize_vol_vec
!
function add_row_means(xx) result(yy)
real(kind=dp), intent(in)     :: xx(:,:)
integer                       :: ncol
real(kind=dp)                 :: yy(size(xx,1),size(xx,2)+1)
ncol = size(xx,2)
if (ncol < 1) return
yy(:,:ncol)  = xx
yy(:,ncol+1) = sum(xx,dim=2)/ncol
! call set_alloc(yy,xx)
end function add_row_means
!
subroutine rescale_columns(xx,cstat,target_stat,stat_min)
! rescale columns so that they have same target_stat, such as standard deviation
real(kind=dp)    , intent(in out)       :: xx(:,:)
character (len=*), intent(in)           :: cstat
real(kind=dp)    , intent(in), optional :: target_stat
real(kind=dp)    , intent(in), optional :: stat_min
integer                                 :: icol
real(kind=dp)                           :: xstat
do icol=1,size(xx,2)
   xstat = stats(cstat,xx(:,icol))
   if (xstat > default(0.0_dp,stat_min)) xx(:,icol) = xx(:,icol) * default(1.0_dp,target_stat)/xstat
end do
end subroutine rescale_columns
!
subroutine print_corr_simple_reg(xx,yy,outu,fmt_header,fmt_trailer,what,print_stats_labels)
! compute and print the results of a simple linear regression of yy(:) on xx(:)
real(kind=dp)    , intent(in)           :: xx(:),yy(:) ! (n)
integer          , intent(in), optional :: outu
character (len=*), intent(in), optional :: fmt_header,fmt_trailer
character (len=*), intent(in), optional :: what
logical          , intent(in), optional :: print_stats_labels
integer                                 :: outu_
real(kind=dp)                           :: corr,alpha,beta,xmean,ymean,xsd,ysd
character (len=20)                      :: what_
what_ = "" ; if (present(what)) what_ = what
call assert_equal("in print_corr_simple_reg, size(xx), size(yy) =",size(xx),size(yy))
outu_ = default(istdout,outu)
call write_format(fmt_header,outu_)
if (default(.true.,print_stats_labels)) then
   if (what_ == "all") then
      write (outu_,"(100a10)")   "corr","alpha","beta","mean_x","mean_y","sd_x","sd_y"
   else
      write (outu_,"(100a10)")   "corr","alpha","beta"
   end if
end if
if (what_ == "all") then
   call corr_alpha_beta(xx,yy,corr,alpha,beta,xmean,ymean,xsd,ysd)
else
   call corr_alpha_beta(xx,yy,corr,alpha,beta)
end if
if (what_ == "all") then
   write (outu_,"(100f10.4)") corr,alpha,beta,xmean,ymean,xsd,ysd
else
   write (outu_,"(100f10.4)") corr,alpha,beta
end if
call write_format(fmt_trailer,outu_)
end subroutine print_corr_simple_reg  
!
function stats_mac_ret_xvec_yvec(cstats,xx,yy,nma1,nma2,pos_long,pos_short,scale_ret,i1) result(ystats)
! return statistics on the profits of a system traded on yy(:) using a moving average crossover of xx(:)
character (len=*), intent(in) :: cstats(:)
real(kind=dp)    , intent(in) :: xx(:)      ! (n)
real(kind=dp)    , intent(in) :: yy(:)      ! (n)
integer          , intent(in) :: nma1,nma2
real(kind=dp)    , intent(in) :: pos_long,pos_short
real(kind=dp)    , intent(in), optional :: scale_ret
integer          , intent(in), optional :: i1
real(kind=dp)                 :: ystats(size(cstats))
real(kind=dp)                 :: yret(size(yy)-1),xpos(size(xx))
logical                       :: mask_long(size(xx))
integer                       :: i1_,n,nret
i1_    = default(max(nma1,nma2),i1)
n      = size(xx)
ystats = bad_real
call assert_equal("in stats_mac_ret_vec_vec, size(xx), size(yy) =",n,size(yy))
mask_long = rollmean_ratio(xx,nma1,nma2) > 1.0_dp
nret = n - 1
if (nret < 1 .or. i1_ > nret) return
yret = default(1.0_dp,scale_ret) * (xx(2:)/xx(:nret) - 1.0_dp)
xpos = merge(pos_long,pos_short,mask_long)
ystats  = stats(cstats,yret(i1_:) * xpos(i1_:nret))
end function stats_mac_ret_xvec_yvec
!
subroutine print_stats_mac_ret(xx,yy,nma1,nma2,cstats,scale_ret,fmt_header,title,outu, &
           i1,sym,what)
! print stats on the returns of xx(:) when the nma period moving average (MA) is above the nma2 period MA
real(kind=dp)    , intent(in)           :: xx(:)      ! (n) predictor time series
real(kind=dp)    , intent(in)           :: yy(:)      ! (n) traded time series
integer          , intent(in)           :: nma1,nma2  ! moving average lengths
character (len=*), intent(in), optional :: cstats(:)
character (len=*), intent(in), optional :: sym
real(kind=dp)    , intent(in), optional :: scale_ret  ! return scaling
character(len=*) , intent(in), optional :: fmt_header,title
integer          , intent(in), optional :: outu     
character (len=*), intent(in), optional :: what(:)         ! elements can be "all", "long", "short", "long_cash","long_short"
integer          , intent(in), optional :: i1              ! first return to use in computing statistics
real(kind=dp)    , target               :: yret(size(xx)-1)
real(kind=dp)    , pointer              :: yret_use(:)
integer                                 :: i,n,nret,outu_,i1_
logical          , target               :: mask_long(size(xx))
logical          , pointer              :: mask_long_use(:)
character (len=20), allocatable         :: cstats_(:),what_(:)
character (len=20)                      :: sym_
sym_ = ""
if (present(sym)) sym_ = sym
i1_ = default(max(nma1,nma2),i1)
if (present(cstats)) then
   call set_alloc(cstats,cstats_)
else
   call set_alloc(["count","mean ","sd   "],cstats_)
end if
if (present(what)) then
   call set_alloc(what,what_)
else
   call set_alloc(["all  ","long ","short"],what_)
end if
outu_ = default(istdout,outu)
n = size(xx)
call assert_equal("in print_stats_mac_ret, size(xx), size(yy) =",n,size(yy))
nret = n - 1
if (n < 2 .or. i1_ > nret) return
yret = default(1.0_dp,scale_ret) * (xx(2:)/xx(:nret) - 1.0_dp)
mask_long = rollmean_ratio(xx,nma1,nma2) > 1.0_dp
call write_format(fmt_header)
if (present(title)) write (outu_,"(a)") trim(title)
yret_use      => yret(i1_:)
mask_long_use => mask_long(i1_:nret)
if (size(what_) > 0) write (outu_,"(100(a8,1x))") trim(sym_),"#",(trim(cstats(i)),i=1,size(cstats))
if (any(what_ == "all"))   call print_stats_nobs(cstats_,yret_use,"all",outu=outu_)
if (any(what_ == "long"))  call print_stats_nobs(cstats_,pack(yret_use,mask_long_use),"long",outu=outu_)
if (any(what_ == "short")) call print_stats_nobs(cstats_,pack(yret_use,.not. mask_long_use),"short",outu=outu_)
if (any(what_ == "long_cash")) call print_stats_nobs(cstats_,yret_use*merge(1.0_dp,0.0_dp,mask_long_use), &
                                    "lng_cash",outu=outu_)
if (any(what_ == "long_short")) call print_stats_nobs(cstats_,yret_use*merge(1.0_dp,-1.0_dp,mask_long_use), &
                                    "lng_shrt",outu=outu_)
end subroutine print_stats_mac_ret
!
subroutine print_stats_nobs(cstats,xx,label,print_cstats,outu,sym)
! print the number of observations xx(:) and statistics about them
character (len=*), intent(in)           :: cstats(:)
real(kind=dp)    , intent(in)           :: xx(:)      
character (len=*), intent(in)           :: label
logical          , intent(in), optional :: print_cstats
integer          , intent(in), optional :: outu     
character (len=*), intent(in), optional :: sym
character (len=100)                     :: fmt_out_,sym_
integer                                 :: i,outu_
sym_ = ""
if (present(sym)) sym_ = sym
outu_ = default(istdout,outu)
fmt_out_ = "(a8,1x,i8,100(1x,f8.4))"
if (default(.false.,print_cstats)) write (outu_,"(100(a8,1x))") trim(sym_),"#",(trim(cstats(i)),i=1,size(cstats))
write (outu_,fmt_out_) trim(label),size(xx),stats(cstats,xx)
end subroutine print_stats_nobs
!
recursive subroutine quick_sort(list, order)
! Quick sort routine from:
! Brainerd, W.S., Goldberg, C.H. & Adams, J.C. (1990) "Programmer's Guide to
! Fortran 90", McGraw-Hill  ISBN 0-07-000248-7, pages 149-150.
! Modified by Alan Miller to include an associated integer array which gives
! the positions of the elements in the original order.
real(kind=dp), intent(in out) :: list(:)
integer      , intent(out)    :: order(:)
! Local variable
integer :: i
do i = 1, size(list)
  order(i) = i
end do
if (any(isnan(list))) return
call quick_sort_1(1, size(list))
contains
recursive subroutine quick_sort_1(left_end, right_end)
integer, intent(in) :: left_end, right_end
!     Local variables
integer             :: i, j, itemp
real(kind=dp)                :: reference, temp
integer, parameter  :: max_simple_sort_size = 6
if (right_end < left_end + max_simple_sort_size) then
  ! Use interchange sort for small lists
  call interchange_sort(left_end, right_end)
else
  ! Use partition ("quick") sort
  reference = list((left_end + right_end)/2)
  i = left_end - 1; j = right_end + 1
  do
    ! Scan list from left end until element >= reference is found
    do
      i = i + 1
!      if (i > size(list)) exit ! added 01/03/2021 10:54 AM by Vivek Rao to avoid out-of-bounds error
      if (list(i) >= reference) exit
    end do
    ! Scan list from right end until element <= reference is found
    do
      j = j - 1
!      if (j < 1) exit ! added 01/03/2021 10:55 AM by Vivek Rao to avoid out-of-bounds error
      if (list(j) <= reference) exit
    end do
    if (i < j) then
      ! Swap two out-of-order elements
      temp = list(i); list(i) = list(j); list(j) = temp
      itemp = order(i); order(i) = order(j); order(j) = itemp
    else if (i == j) then
      i = i + 1
      exit
    else
      exit
    end if
  end do
  if (left_end < j) call quick_sort_1(left_end, j)
  if (i < right_end) call quick_sort_1(i, right_end)
end if
end subroutine quick_sort_1

subroutine interchange_sort(left_end, right_end)
integer, intent(in) :: left_end, right_end
!     Local variables
integer             :: i, j, itemp
real(kind=dp)                :: temp
do i = left_end, right_end - 1
  do j = i+1, right_end
    if (list(i) > list(j)) then
      temp = list(i); list(i) = list(j); list(j) = temp
      itemp = order(i); order(i) = order(j); order(j) = itemp
    end if
  end do
end do
end subroutine interchange_sort
end subroutine quick_sort
!
function indexx_int(xx) result(iord)
! return iord(:) such that xx(iord) is in ascending order
integer, intent(in) :: xx(:)
integer             :: iord(size(xx))
iord = indexx_real(1.0_dp*xx)
end function indexx_int
!
function indexx_real(xx) result(iord)
! return iord(:) such that xx(iord) is sorted
real(kind=dp), intent(in) :: xx(:)
integer                   :: iord(size(xx))
real(kind=dp)             :: xcp(size(xx))
xcp = xx
call quick_sort(xcp,iord)
end function indexx_real
!
subroutine assert_equal_2__(n1,n2,name1,name2,procedure)
! print an error message and stop if n1 /= n2
integer          , intent(in) :: n1,n2
character (len=*), intent(in) :: procedure   ! name of program unit where assertion is made
character (len=*), intent(in) :: name1,name2 ! variable names 
if (n1 /= n2) then
   write (*,"(a,2(1x,a),' =',2(1x,i0),a)") "in " // trim(procedure) // ",", &
          trim(name1),trim(name2),n1,n2," must be equal, STOPPING"
   stop
end if
end subroutine assert_equal_2__
!
subroutine print_corr_mat(xx,labels,fmt_header,iunit,fmt_label,fmt_corr,fmt_row_label,csv)
! print a correlation matrix with labels
real(kind=dp)    , intent(in)           :: xx(:,:)    ! data for which correlations of columns are to be computed
character (len=*), intent(in), optional :: labels(:)  ! labels of columns
character (len=*), intent(in), optional :: fmt_header
integer          , intent(in), optional :: iunit
character (len=*), intent(in), optional :: fmt_label,fmt_row_label
character (len=*), intent(in), optional :: fmt_corr
logical          , intent(in), optional :: csv
character (len=20)                      :: labels_(size(xx,2))
character (len=100)                     :: fmt_h,fmt_label_use,fmt_corr_use
integer                                 :: i,iu
logical                                 :: csv_
if (present(csv)) then
   csv_ = csv
else
   csv_ = .false.
end if
if (present(iunit)) then
   iu = iunit
else
   iu = istdout
end if
if (present(fmt_header)) then
   fmt_h = fmt_header
else
   fmt_h = ""
end if
if (csv_) then
   fmt_label_use = "(100(',',a))"
else
   fmt_label_use = "(12x,100a12)" 
end if
if (present(fmt_label)) then
   if (fmt_label /= "") fmt_label_use = fmt_label
end if
if (csv_) then
   fmt_corr_use = "(',',f0.3)"
else
   fmt_corr_use = "(f12.3)"
end if
if (present(fmt_corr)) then
   if (fmt_corr_use /= "") fmt_corr_use = fmt_corr
end if
! print*,"calling print_square_matrix" ! debug
if (present(labels)) then
   call print_square_matrix(corr_mat(xx),labels(:size(xx,2)),fmt_label_use, &
        fmt_corr_use,fmt_h,fmt_row_label=fmt_row_label,iunit=iu)
else
   do i=1,size(labels_) 
      write (labels_(i),"('x',i0)") i
   end do
   call print_square_matrix(corr_mat(xx),labels_,fmt_label_use,fmt_corr_use,fmt_h,iu)
end if
! print*,"returned from print_square_matrix" ! debug
end subroutine print_corr_mat
!
subroutine print_square_matrix(xx,labels,fmt_labels,fmt_xx,fmt_header,iunit,fmt_row_label)
! print a square matrix of real numbers with labels for the rows and columns
real(kind=dp)      , intent(in)           :: xx(:,:)
character (len=*)  , intent(in)           :: labels(:)
character (len=*)  , intent(in)           :: fmt_labels,fmt_xx
character (len=*)  , intent(in), optional :: fmt_header,fmt_row_label
integer            , intent(in), optional :: iunit
integer                                   :: i,iu,j,nrow,ncol
character (len=20)                        :: fmt_row_label_
if (present(fmt_row_label)) then
   fmt_row_label_ = fmt_row_label
else
   fmt_row_label_ = "(a12)"
end if
nrow    = size(xx,dim=1)
ncol    = size(xx,dim=2)
if (present(iunit)) then
   iu = iunit
else
   iu = istdout
end if
if (present(fmt_header)) then
   if (fmt_header /= "") write (iu,fmt_header)
end if
! print*,"in psm, fmt_labels = '" // trim(fmt_labels) // "' fmt_row_label_ = '" // trim(fmt_row_label_) // &
!       "' fmt_xx = '" // trim(fmt_xx) // "'"
write (iu,fmt_labels) (trim(labels(j)),j=1,ncol)
do i=1,nrow
   write (iu,fmt_row_label_,advance="no") trim(labels(i))
   do j=1,ncol
      write (iu,fmt_xx,advance="no") xx(i,j)
   end do
   write (iu,*)
end do
end subroutine print_square_matrix
!
function corr_mat(xmat,good) result(xcorr)
! compute the correlation matrix of the columns of xmat(:,:)
real(kind=dp), intent(in)           :: xmat(:,:)
logical      , intent(in), optional :: good(:,:)
real(kind=dp)                       :: xcorr(size(xmat,2),size(xmat,2))
integer                             :: i,j,ncol
logical                             :: xuse(size(xmat,1))
ncol = size(xmat,2)
if (present(good)) then
   if (size(xmat,1) /= size(good,1) .or. size(xmat,2) /= size(good,2)) then
      write (*,*) "in corr_mat, shape(xmat)=",shape(xmat)," shape(good)=",shape(good), &
                  "shapes must be equal, STOPPING"
      stop
   end if
end if
do i=1,ncol
   xcorr(i,i) = 1.0_dp
   do j=1,i-1
      if (present(good)) then
         xuse = good(:,i) .and. good(:,j)
         xcorr(i,j) = correl(pack(xmat(:,i),xuse),pack(xmat(:,j),xuse))
      else
         xcorr(i,j) = correl(xmat(:,i),xmat(:,j))
      end if
   end do
end do
do i=1,ncol
   do j=i+1,ncol
      xcorr(i,j) = xcorr(j,i)
   end do
end do
end function corr_mat
!
function aic_penalty(nparam,nobs) result(penalty)
! Akaike Information Criterion (AIC) penalty
! http://www.phdeconomics.sssup.it/documents/Lesson18.pdf "Lesson 18: Building a Vector Autoregressive Model" 
! by Umberto Triacca, p5
integer, intent(in) :: nparam, nobs
real(kind=dp)       :: penalty
if (nobs > 0) then
   penalty = 2*nparam/dble(nobs)
else
   penalty = 0.0_dp
end if
end function aic_penalty
!
elemental function inf_crit_mvn(criterion,nparam,nobs,log_det_cov) result(y)
character (len=*), intent(in) :: criterion
integer          , intent(in) :: nparam
integer          , intent(in) :: nobs
real(kind=dp)    , intent(in) :: log_det_cov
real(kind=dp)                 :: y
real(kind=dp)                 :: penalty
select case (criterion)
   case ("aic"); penalty = 2*nparam/dble(nobs)
   case ("bic"); penalty = log(dble(nobs))*nparam/dble(nobs)
   case ("hqc"); penalty = 2*log(log(dble(nobs)))*nparam/dble(nobs)
   case ("raw"); penalty = 0.0_dp
   case default; penalty = 0.0_dp
end select
y = log_det_cov + penalty
end function inf_crit_mvn
!
subroutine print_freq_int_vec(ivec,label,outu,print_min,print_max,print_mode,print_mean, &
                              print_zero_counts,fmt_header,fmt_trailer)
! print frequencies of values in integer vector and other statistics
integer          , intent(in)           :: ivec(:) ! data for which frequencies computed
character (len=*), intent(in), optional :: label   ! name for frequencies, default '#'
integer          , intent(in), optional :: outu    ! unit to which output written
character (len=*), intent(in), optional :: fmt_header,fmt_trailer ! format strings to print upon entering and leaving subroutine, if present
logical          , intent(in), optional :: print_min,print_max,print_mode,print_mean,print_zero_counts
integer                                 :: i,mode,outu_,ncount,ncount_max,num_le,nobs
character (len=*), parameter            :: fmt_ir = "(4i10,3f10.4)", fmt_ci = "(a10,i10)",fmt_cr = "(a10,f10.4)"
character (len=100)                     :: label_
real(kind=dp)                           :: denom
logical                                 :: print_mode_,print_zero_counts_
print_zero_counts_ = default(.true.,print_zero_counts)
print_mode_ = default(.true.,print_mode)
nobs  = size(ivec)
denom = real(max(1,nobs),kind=dp)
outu_ = default(istdout,outu)
if (present(label)) then
   label_ = label
else
   label_ = "#"
end if
call write_format(fmt_header,outu_)
write (outu_,"(7a10)") "value",trim(label_),"#cumul","#left","frac","cumul","left"
if (print_mode_) ncount_max = 0
num_le = 0
do i=minval(ivec),maxval(ivec)
   ncount = count(ivec==i)
   num_le = num_le + ncount
   if (ncount > 0 .or. print_zero_counts_) write (outu_,fmt_ir) i,ncount,num_le,nobs-num_le, &
                       [ncount,num_le,nobs-num_le]/denom
   if (print_mode_) then
      if (ncount > ncount_max) then
         ncount_max = ncount
         mode = i
      end if
   end if
end do
if (default(.true.,print_min)) write (*,fmt_ci) "min",minval(ivec)
if (default(.true.,print_max)) write (*,fmt_ci) "max",maxval(ivec)
if (print_mode_) write (*,fmt_ci) "mode",mode
if (default(.true.,print_mean)) write (*,fmt_cr) "mean",sum(ivec)/denom
call write_format(fmt_trailer,outu_)
end subroutine print_freq_int_vec
!
function variable_names(n,prefix,suffix,imin) result(names)
! construct variable names from integers
integer          , intent(in)           :: n
character (len=*), intent(in), optional :: prefix
character (len=*), intent(in), optional :: suffix
integer          , intent(in), optional :: imin
character (len=100)                     :: names(n)
integer                                 :: i,j,imin_
imin_ = default(1,imin)
names = ""
do i=1,n
   j = imin_ + i - 1
   if (present(prefix)) names(i) = prefix
   names(i) = trim(names(i)) // str_int(j)
   if (present(suffix)) names(i) = trim(names(i)) // suffix
end do
end function variable_names
!
subroutine print_freq_int_mat(ivec,labels,outu,print_min,print_max,print_mode,print_mean,fmt_header,fmt_trailer)
! print frequencies of values in integer matrix and other statistics
integer          , intent(in)           :: ivec(:,:) ! (*,nvar) data for which frequencies computed
character (len=*), intent(in), optional :: labels(:) ! (nvar)   name for frequencies, default '#'
integer          , intent(in), optional :: outu      ! unit to which output written
character (len=*), intent(in), optional :: fmt_header,fmt_trailer ! format strings to print upon entering and leaving subroutine, if present
logical          , intent(in), optional :: print_min,print_max,print_mode,print_mean
integer                                 :: i,ivar,outu_,nvar
integer          , allocatable          :: ncount(:),ncount_max(:),mode(:)
character (len=*), parameter            :: fmt_i = "(1000i10)", fmt_ci = "(a10,1000i10)",fmt_cr = "(a10,1000f10.4)"
character (len=100), allocatable        :: labels_(:)
real(kind=dp)                           :: denom
logical                                 :: print_mode_,print_zero_counts_
print_zero_counts_ = .false.
nvar = size(ivec,2)
if (present(labels)) then
   if (size(labels) /= nvar) then
      write (*,*) "in print_freq_int_mat, size(ivec,2), size(labels) =",nvar,size(labels)," msut be equal, STOPPING"
      stop
   end if
end if
print_mode_ = default(.true.,print_mode)
denom = real(max(1,size(ivec,1)),kind=dp)
outu_ = default(istdout,outu)
allocate (labels_(nvar))
if (present(labels)) then
   labels_ = labels
else
   labels_ = variable_names(nvar,prefix="col")
end if
call write_format(fmt_header,outu_)
write (outu_,"(1000a10)") "value",(trim(labels_(ivar)),ivar=1,nvar)
if (print_mode_) then
   allocate (ncount_max(nvar),mode(nvar))
   ncount_max = 0
end if
allocate (ncount(nvar))
do i=minval(ivec),maxval(ivec)
   ncount = [(count(ivec(:,ivar)==i),ivar=1,nvar)]
   if (print_zero_counts_ .or. any(ncount > 0)) write (outu_,fmt_i) i,ncount
   if (print_mode_) then
      do ivar=1,nvar
         if (ncount(ivar) > ncount_max(ivar)) then
            ncount_max(ivar) = ncount(ivar)
            mode(ivar) = i
         end if
      end do
   end if
end do
if (default(.true.,print_min)) write (*,fmt_ci) "min",minval(ivec,dim=1)
if (default(.true.,print_max)) write (*,fmt_ci) "max",maxval(ivec,dim=1)
if (print_mode_) write (*,fmt_ci) "mode",mode
if (default(.true.,print_mean)) write (*,fmt_cr) "mean",sum(ivec,dim=1)/denom
call write_format(fmt_trailer,outu_)
end subroutine print_freq_int_mat
!
function acf_str(lag) result(str)
! return a string 'ACF_lag', for example 'ACF_3' for lag = 3
integer, intent(in) :: lag
character (len=10)  :: str
write (str,"('ACF_',i0)") lag
end function acf_str

subroutine print_stats_ranges_madev(xsignal, xret, sym_signal, sym_ret, nma_vec, thresh, scale_madev, cstats_ret)
! Print statistics on conditional returns for each symbol,
! using moving average deviation (madev) ranges defined by
! MA lengths and thresholds.
real(kind=dp)    , intent(in) :: xsignal(:,:)  ! (nsignal, nsym_signal)
real(kind=dp)    , intent(in), target :: xret(:,:)     ! (nsignal-1, nsym_ret)
character (len=*), intent(in) :: sym_signal(:) ! (nsym_signal)
character (len=*), intent(in) :: sym_ret(:)    ! (nsym_ret)
integer          , intent(in) :: nma_vec(:)    ! moving average lengths
real(kind=dp)    , intent(in) :: thresh(:)     ! thresholds of moving average deviation after scaling
real(kind=dp)    , intent(in) :: scale_madev
character (len=*), intent(in) :: cstats_ret(:) ! statistics to print on conditional returns
integer :: ierr, inma, nma, isym_signal, isym_traded, nsym_signal, nsym_ret, nsignal
real(kind=dp), allocatable, target :: xmadev(:,:)
real(kind=dp), pointer :: xindep(:), xdep(:)
ierr = first_false([size(xret, 1) == size(xsignal, 1)-1, size(xsignal, 2) == size(sym_signal), size(xret, 2) == size(sym_ret)])
if (ierr /= 0) then
   print*,"ierr =",ierr
   stop
end if
nsym_signal = size(sym_signal)
nsym_ret = size(sym_ret)
nsignal = size(xsignal, 1)
do inma=1,size(nma_vec)
   nma = nma_vec(inma)
   xmadev = scale_madev * madev(xsignal, nma)/xsignal
   print "(/,'correlations of madev for moving average length ',i0)", nma
   call print_corr_mat(xmadev, sym_signal)
   do isym_signal=1,nsym_signal
      do isym_traded=1,nsym_ret
         xindep => xmadev(nma:nsignal-1, isym_signal)
         xdep=> xret(nma:,isym_traded)
!         associate (xindep => xmadev(nma:nsignal-1, isym_signal), xdep=>xret(nma:,isym_traded))
         print "(/,i0,' day MA ', a, ' corr(linear, binary) = ', 100(1x,f8.4))", nma, &
            trim(sym_signal(isym_signal)) // " to trade " // trim(sym_ret(isym_traded)), &
               correl(xindep, xdep), correl(merge(0.0_dp, 1.0_dp, xindep <= 0.0_dp), xdep)
         call print_stats_ranges(cstats_ret, xindep, thresh=thresh, xx=xdep)
!         end associate
      end do
   end do
end do
end subroutine print_stats_ranges_madev

subroutine print_stats_ranges_signals_returns(xsignal, xret, sym_signal, sym_ret, thresh, cstats_ret)
! print statistics on conditional returns for each symbol,
! using signal ranges defined by thresholds.
real(kind=dp)    , intent(in), target :: xsignal(:,:), xret(:,:)
character (len=*), intent(in) :: sym_signal(:) ! (nsym_signal)
character (len=*), intent(in) :: sym_ret(:)    ! (nsym_ret)
real(kind=dp)    , intent(in) :: thresh(:)     ! thresholds of signal
character (len=*), intent(in) :: cstats_ret(:) ! statistics to print on conditional returns
integer                       :: isym_signal, isym_traded, nsym_signal, nsym_ret
real(kind=dp), pointer :: xindep(:), xdep(:)
nsym_signal = size(sym_signal)
nsym_ret = size(sym_ret)
do isym_signal=1,nsym_signal
   do isym_traded=1,nsym_ret
!      associate (xindep => xsignal(:, isym_signal), xdep=>xret(:,isym_traded))
      xindep => xsignal(:, isym_signal)
      xdep => xret(:,isym_traded)
      print "(/, a, ' corr(linear, binary) = ', 100(1x,f8.4))", &
         trim(sym_signal(isym_signal)) // " to trade " // trim(sym_ret(isym_traded)), &
            correl(xindep, xdep), correl(merge(0.0_dp, 1.0_dp, xindep <= 0.0_dp), xdep)
      call print_stats_ranges(cstats_ret, xindep, thresh=thresh, xx=xdep)
!      end associate
   end do
end do
end subroutine print_stats_ranges_signals_returns

subroutine print_stats_binned_returns(ibin, xret, sym_signal, sym_ret, cstats_ret)
! print statistics on conditional returns for each symbol for specified bins
! UNFINISHED!
integer          , intent(in) :: ibin(:,:)
real(kind=dp)    , intent(in), target :: xret(:,:)
character (len=*), intent(in) :: sym_signal(:) ! (nsym_signal)
character (len=*), intent(in) :: sym_ret(:)    ! (nsym_ret)
character (len=*), intent(in) :: cstats_ret(:) ! statistics to print on conditional returns
integer                       :: isym_signal, isym_traded, nsym_signal, nsym_ret
real(kind=dp), pointer :: xdep(:)
nsym_signal = size(sym_signal)
nsym_ret = size(sym_ret)
do isym_signal=1,nsym_signal
   do isym_traded=1,nsym_ret
!      associate (xdep=>xret(:,isym_traded))
      xdep => xret(:,isym_traded)
      print "(/, a)", &
      trim(sym_signal(isym_signal)) // " to trade " // trim(sym_ret(isym_traded))
!       call print_stats_ranges(cstats_ret, xindep, thresh=thresh, xx=xdep)
!      end associate
   end do
end do
end subroutine print_stats_binned_returns

subroutine print_stats_bins(cstats,xindep,thresh,xx,label,iu,outfile,fmt_stat,fmt_stat_labels, &
                              fmt_trailer,print_labels,csv,obs_year,xstats,fmt_header, &
                              binary_thresh,ranges,print_last,print_stats_all, &
                              print_stats_indep,print_num_bin_changes,title,print_data,fmt_end,datu, &
                              cstats_indep)
! branched from print_stats_ranges
! print stats on xx(:) for xindep(:) <= or > thresh
character (len=*), intent(in)           :: cstats(:) ! names of statistics to print
real(kind=dp)    , intent(in)           :: xindep(:) ! (n) independent variable
real(kind=dp)    , intent(in)           :: thresh(:) ! thresholds used to demarcate bins
real(kind=dp)    , intent(in)           :: xx(:)     ! (n) dependent variable
character (len=*), intent(in), optional :: label     ! label of independent variable
integer          , intent(in), optional :: iu        ! output unit
integer          , intent(in), optional :: datu      ! unit to which data printed if print_data is .true.
character (len=*), intent(in), optional :: fmt_stat_labels
character (len=*), intent(in), optional :: fmt_stat
character (len=*), intent(in), optional :: fmt_trailer,fmt_end
character (len=*), intent(in), optional :: outfile
logical          , intent(in), optional :: print_labels,print_stats_all,print_stats_indep,print_num_bin_changes,print_data
logical          , intent(in), optional :: csv
real(kind=dp)    , intent(in), optional :: obs_year
real(kind=dp)    , intent(in), optional :: xstats(:) ! if present, print these pre-computed statistics
character (len=*), intent(in), optional :: fmt_header,title
logical          , intent(in), optional :: binary_thresh,ranges,print_last
character (len=*), intent(in), optional :: cstats_indep(:)
character (len=20), allocatable         :: cstats_indep_(:)
integer                                 :: n,ithresh,outu,nthresh,nchanges
logical                                 :: first_call,xmask(size(xx)),print_stats_empty_bins_,print_last_, &
                                           print_num_bin_changes_,csv_,print_num_obs_
character (len=20)                      :: label_thresh,label_
if (present(label)) then
   label_ = label
else
   label_ = "x"
end if
print_num_obs_ = .true.
if (present(cstats_indep)) then
   call set_alloc(cstats_indep,cstats_indep_)
else
   call set_alloc(["min","max"],cstats_indep_)
end if
csv_ = default(.false.,csv)
print_num_bin_changes_ = default(.false.,print_num_bin_changes)
print_stats_empty_bins_ = .false.
print_last_ = default(.false.,print_last)
n = size(xx)
if (size(xindep) /= n) then
   write (*,*) "in print_stats_ranges, size(xindep), size(xx) =",size(xindep),n," must be equal, STOPPING"
   stop
end if
if (n < 1) return
nthresh = size(thresh)
outu = default(istdout,iu)
if (present(title)) then
   write (outu,"(a)") trim(title)
end if
if (present(fmt_header)) then
   write (outu,fmt_header)
end if
first_call = .true.
if (default(.true.,print_stats_all)) then
   call print_many_stats_vec_str(cstats,xx,"all",outu,outfile,fmt_stat,fmt_stat_labels, &
        fmt_trailer,first_call,csv,obs_year,xstats,xindep=xindep,cstats_indep=cstats_indep_, &
        print_num_obs=print_num_obs_)
end if
first_call = .false.
if (default(.true.,ranges)) then
   if (default(.false.,binary_thresh) .and. nthresh == 1) return
   if (print_num_bin_changes_ .and. nthresh > 0 .and. n > 1) then
      nchanges = num_bin_changes(xindep,thresh)
      write (outu,"('freq bin changes = ',i0,'/',i0,' = ',f0.3)") nchanges,n,nchanges/dble(max(1,n))
   end if
   do ithresh=0,nthresh
      if (nthresh > 0) then
         if (ithresh == 0) then
            xmask = xindep <= thresh(1)
            write (label_thresh,"('<=',f0.1)") thresh(1)
         else if (ithresh == nthresh) then
            xmask = xindep >  thresh(nthresh)
            write (label_thresh,"('>',f0.1)") thresh(nthresh)
         else
            xmask = xindep > thresh(ithresh) .and. xindep <= thresh(ithresh+1)
            write (label_thresh,"(f0.1,':',f0.1)") thresh([ithresh,ithresh+1])
         end if
      else
         label_thresh = "all"
         xmask        = .true.
      end if
      if (print_stats_empty_bins_ .or. any(xmask)) &
         call print_many_stats_vec_str(cstats,pack(xx,xmask),label_thresh,iu,outfile,fmt_stat,fmt_stat_labels, &
              fmt_trailer,first_call,csv,obs_year,xstats,xindep=pack(xindep,xmask),cstats_indep=cstats_indep_, &
              print_num_obs=print_num_obs_)
   end do
end if
call write_format(fmt_end,iu)
end subroutine print_stats_bins
end module statistics_mod

program main
use statistics_mod
implicit none
print*,mean([10.0_dp, 20.0_dp, 30.0_dp])
end program main
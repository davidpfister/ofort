module kind_mod
implicit none
private
public :: dp,long_int,i64
integer, parameter :: dp = selected_real_kind(15, 307) ! double precision
integer, parameter :: long_int = selected_int_kind(15), i64 = long_int
end module kind_mod

module util_mod
use kind_mod, only: dp, long_int, i64
implicit none
private
public :: matrix,vector,append_col,prepend_col,cbind,combine_col,combine_mat,tensor, &
          cumul_sum,cumul_sum0,int_tf,itrue,ifalse,diag,diag_matrix,true_pos,true_pos_count, &
          demean,if_else,get_text_int,set_offdiagonal,polynom_value, &
          first_pos_ge,last_pos_le,first_row_all_true,last_row_all_true, &
          set_optional,optional_value,newl,integer_label,integer_labels, &
          present_and_true,conform,select_array,select_tensor_real,runif, &
          istdin,istdout,print_time_elapsed,unique,read_comments,num_matching_char, &
          read_vec_real,read_vec_char,read_vec_int,quote,irange,slice,repeat, &
          trim_append,sgn,open_grid,grid,same_rows,munge,exclude,copy_alloc, &
          in_range,good_pos,operator(.in.),operator(.notin.),vec_exclude,ivec, &
          all_equal,str,operator(+),join,join_quote,join_csv,concat,operator(.plus.),cumul_sum_periodic, &
          periodic_sum,default,copy_alloc_opt,check_included,lag_matrix,lag_matrix_vec, &
          variable_names,assert_eq,iminloc,nrerror,in_row,read_alloc,set_alloc, &
          merge_sub,element,grid_alloc,prepend,combine_vec_mat,combine_mat_tensor, &
          combine_tensors,assert,spread_alloc,reverse,renormalize,print_matrix_row_num, &
          size_optional,size_optional_char_vec,read_vec_alloc,set_optional_alloc,interp_two_points,num_obs_bins, &
          alloc_sub,normalize,merge_alloc,true_pos_alloc,write_xname_yname, &
          write_format,check_equal,check_equal_strings,growing_mean,conform_optional,write_lines, &
          grid_min_max,compare_vec,remove_char,copy_file,write_lines_file,select_match,append_file, &
          vector_to_matrix_alloc,size_optional_logical_vec,piecewise_constant,append,positions,dealloc, &
          num_unique,unique_values,unique_values_positions,upper_case_str,lower_case_str,max_optional, &
          min_optional,label_obs_bins,get_words_alloc,ones,sum_no_overlap,pos_first_nonzero,num_changes, &
          write_tensor,reshape_matrix,combine_matrices,sorted,remove_zero_rows,remove_zero_columns, &
          read_words_line,match,lag_data,skip_lines,short_file_name,base_file_name,unique_positions, &
          remove_duplicate_columns,order_distance,nonzero_columns,match_matrix,write_words,operator(.div.), &
          rbinary,exp_ma,merge_char,realloc,sine_bound,sine_transform,sign_changes,duration, &
          power_transform,round_up,grid_round,ts_transform,str_ratio_diff,str_none,running_sum, &
          zero_small_changes,bands,moving_average,bounded_time_series,last,round_less,positive, &
          piecewise_linear,unique_vec,fill_matrix_by_row,all_columns_equal, &
          print_wall_time_elapsed,uniq,nearest_element,exe_name,single,timestamp,timestring, &
          sech,file_exists,newline,diff,fill_vec,fill_panel,interpolate,rebase_vec,rebase_mat, &
          interpolate_matrix_summarize,match_string,get_var,operator(.notall.), &
          empty_char_vec,pi,lagged,zeros,frac_true,alloc_matrix,random_logical, &
          init_random_seed,default_variable_names,frac_changes,tail,seq, &
          above_diag,now,fill_previous,int_grid,get_data,first_true,last_true, &
          replace_char,unix,threshold_weights,time_elapsed,unix_dir,clip,and,close_file, &
          write_optional,pos_changes,pad_directory_name,first_false,backfill,size_optional_real_vec, &
          combine_str,directory_sep,str_real,str_concat,signed_power,operator(.pow.), &
          clip_transform,half_sine_bound,half_sine_transform,fold_bounds,group_sizes, &
          read_matrix,read_3d,random_number_seed,partition,first,default_alloc,first_pos_positive, &
          floor_10,ceiling_10,exact_match_ascending_int,text_after_char,common_value,join_fixed, &
          union_ascending,get_sub,write_trim_vec,matching_pos,ran_uni,text_in_lines,index_case, &
          print_matching_paragraphs,all_strings_in_lines,search_paragraphs_strings,add_uniform_noise, &
          rename_strings,pos_keep,files_exist,check_tickers_exist,lookup,pos,dividend_adjusted_prices, &
          returns,fill_bad,str_simple,str_log,str_diff,vec,print_comment_lines,alloc_char_vec,ends_with, &
          any_strings_in_lines,moving_average_data,madev,lag_good_data,check_all_equal,intersection, &
          add_constant_columns,random_matrix,print_matrix_simple,strip,num_fields,factorial,choose, &
          few_combinations,gen,gen_comb,choose_func,choose_func_long,factorial_long,write_int, &
          num_missing,moving_average_xlen,add_one_var,lower,operator(.exclude.),match_category, &
          concat_char_vec,assert_equal,assert_less,stop_if_missing,put_random_seed,squared_distances, &
          squared_distances_rows,distances_rows,geometric_series,assert_range,directory_exists,checkdir, &
          print_matrix,elu,elu_smooth,logistic,elu_logistic,x_times_logistic,wall_time_elapsed,missing_pos, &
          missing_pos_in_range,read_strings,maxloc_match,num_lines_string_first_field,alloc_init, &
          num_lines_file,lookup_data,sum_ranges,print_vector,duplicate_columns,read_matrix_alloc,read_matrix_unit, &
          is_positive,print_absolute_threshold_counts,print_threshold_counts,print_prices_large_returns, &
          read_words,filter_matrix_rows,unique_ordered,nearby_pos,init_wall_time,within,max_consecutive, &
          num_good_rows,current_time,filter_vec,mask_vec,assert_positive,c,positions_char_string,split, &
          split_string,demean_col,write_vec,print_labeled_vec,nonzero,indexx_order,indexx,tiny_real, &
          piecewise_sine,piecewise_cubic_unit,piecewise_cubic,piecewise_quintic,piecewise_func, &
          piecewise_func_unit,row_count_changes,changes_positions,set_optional_check_size,bad_real, &
          print_labeled_mat,subset,subset_vec_mat,operator(.posin.),unique_char,assert_zero, &
          bound_positions,capped_sum_abs,capped_sum_abs_rows,capped_sum_abs_col,set_random_seed, &
          complement,set_first_false,read_vec_data,assert_conform,same_shape,assert_le,combos,pow_norm, &
          slice_rows,bound_value,join_suffix,join_csv_suffix,diag_3d,offdiag,print_random_seeds, &
          get_numbers,remove,add_or_remove,get_random_seeds,num_records,set_time,ratios,ratio_diff, &
          weighted_sums,weighted_moving_average_vec,moving_average_vec,spline_power_wgt
interface slice_rows
   module procedure slice_rows_real_mat,slice_rows_int_mat
end interface slice_rows
interface print_matrix_row_num
   module procedure print_matrix_real_row_num,print_matrix_int_row_num
end interface print_matrix_row_num
interface same_shape
   module procedure same_shape_real_real_1d, same_shape_real_real_2d, same_shape_real_real_3d
end interface same_shape
interface read_vec_data
   module procedure read_vec_data_unit
end interface read_vec_data
interface nonzero
   module procedure nonzero_real,nonzero_int
end interface nonzero
interface within
   module procedure int_within,real_within
end interface within
interface unique_ordered
   module procedure unique_ordered_int,unique_ordered_i64
end interface unique_ordered
interface read_strings
   module procedure read_strings_vec
end interface read_strings
interface print_matrix
   module procedure print_matrix_simple
end interface print_matrix
interface assert_equal
   module procedure assert_equal_2,assert_equal_3,assert_equal_4,assert_equal_2__, &
                    assert_equal_3__,assert_equal_4__
end interface assert_equal
interface match_category
   module procedure match_category_string_scalar,match_category_string_vec
end interface match_category
interface lower
   module procedure lower_case_str
end interface lower
interface intersection
   module procedure intersection_char
end interface intersection
interface moving_average_data
   module procedure moving_average_data_full,moving_average_data_good,moving_average_min_obs,moving_average_data_full_matrix, &
                    moving_average_data_good_matrix,moving_average_min_obs_matrix
end interface moving_average_data
interface madev
   module procedure madev_good,madev_good_matrix
end interface madev
interface pos_keep
   module procedure pos_keep_char
end interface pos_keep
interface ran_uni
   module procedure ran_uni_vec
end interface ran_uni
interface matching_pos
   module procedure matching_pos_string
end interface matching_pos
interface match_string
   module procedure match_string_scalar,match_string_vec
end interface match_string
interface operator(.pow.)
   module procedure signed_power
end interface
interface operator (.exclude.)
   module procedure diff_vec_char
end interface
interface interpolate
   module procedure interpolate_vec,interpolate_matrix
end interface interpolate
interface diff
   module procedure diff_vector_real, diff_matrix_real, diff_vector_int
end interface diff
interface single
   module procedure single_integer,single_real
end interface single
interface nearest_element
   module procedure nearest_element_real
end interface nearest_element
interface all_columns_equal
   module procedure all_columns_equal_char
end interface all_columns_equal
interface positive
   module procedure positive_int_vec
end interface positive
interface true_pos
   module procedure true_pos_few, true_pos_func
end interface true_pos
interface last
   module procedure last_real
end interface last
interface append_col
   module procedure append_col_vec_mat_real,append_col_mat_vec_real
end interface append_col
interface ts_transform
   module procedure ts_transform_matrix
end interface ts_transform
interface sign_changes
   module procedure sign_changes_real
end interface sign_changes
interface sum_no_overlap
   module procedure sum_no_overlap_vector,sum_no_overlap_matrix
end interface sum_no_overlap
interface realloc
   module procedure realloc_real,realloc_logical,realloc_integer
end interface realloc
interface match_matrix
   module procedure match_integer_matrix
end interface match_matrix
interface unique_positions
   module procedure unique_positions_int
end interface unique_positions
interface lag_data
   module procedure lag_data_vec,lag_data_matrix
end interface lag_data
interface ones
   module procedure ones_vec
end interface ones
interface max_optional
   module procedure max_optional_int
end interface max_optional
interface min_optional
   module procedure min_optional_int
end interface min_optional
interface unique_values
   module procedure unique_values_char,unique_values_int,unique_values_real
end interface unique_values
interface uniq
   module procedure uniq_int,uniq_char,uniq_real
end interface uniq
interface unique_values_positions
   module procedure unique_values_positions_char
end interface unique_values_positions
interface num_unique
   module procedure num_unique_char
end interface num_unique
interface dealloc
   module procedure dealloc_char_vec,dealloc_real_vec,dealloc_real_matrix,dealloc_real_tensor, &
                    dealloc_logical_vec,dealloc_logical_matrix,dealloc_logical_tensor, &
                    dealloc_int_vec,dealloc_int_matrix,dealloc_int_tensor
end interface dealloc
interface append
   module procedure append_str,append_int
end interface append
interface vector_to_matrix_alloc
   module procedure vector_to_matrix_alloc_real
end interface vector_to_matrix_alloc
interface select_match
   module procedure select_match_vec_char
end interface select_match
interface compare_vec
   module procedure compare_vec_strings
end interface compare_vec
interface merge_alloc
   module procedure merge_alloc_int
end interface merge_alloc
interface set_optional_alloc
   module procedure set_optional_alloc_real,set_optional_alloc_int,set_optional_alloc_character
end interface set_optional_alloc
interface read_vec_alloc
   module procedure read_int_vec_alloc,read_unit_int_vec_alloc,read_unit_real_vec_alloc,read_words_line
end interface read_vec_alloc
interface size_optional
   module procedure size_optional_int_vec
end interface size_optional
interface renormalize
   module procedure renormalize_tensor,renormalize_vec
end interface renormalize
interface reverse
   module procedure reverse_real
end interface reverse
interface spread_alloc
   module procedure spread_alloc_char,spread_alloc_logical
end interface spread_alloc
interface combine_tensors
   module procedure combine_tensors_real
end interface combine_tensors
interface combine_mat_tensor
   module procedure combine_mat_tensor_real
end interface combine_mat_tensor
interface combine_vec_mat
   module procedure combine_vec_mat_real
end interface combine_vec_mat
interface prepend
   module procedure prepend_char
end interface prepend
interface grid_alloc
   module procedure grid_alloc_real,grid_alloc_int
end interface grid_alloc
interface element
   module procedure element_char
end interface element
interface merge_sub
   module procedure merge_sub_character
end interface merge_sub
interface read_alloc
   module procedure read_alloc_char
end interface read_alloc
interface in_row
   module procedure in_row_int
end interface in_row
interface first_pos_ge
   module procedure first_pos_ge_int,first_pos_ge_int_vec,first_pos_ge_real
end interface first_pos_ge
interface last_pos_le
   module procedure last_pos_le_int,last_pos_le_int_vec,last_pos_le_real
end interface last_pos_le
interface assert_eq
   module procedure assert_eq2,assert_eq3,assert_eq4,assert_eqn
end interface assert_eq
interface assert
   module procedure assert_scalar,assert_vec
end interface assert
interface demean
   module procedure demean_vec,demean_mat
end interface demean
interface lag_matrix
   module procedure lag_matrix_vec,lag_matrix_mat
end interface lag_matrix
interface copy_alloc_opt
   module procedure copy_alloc_opt_char_vec
end interface copy_alloc_opt
interface default
   module procedure default_logical,default_integer,default_real,default_character,default_character_nlen
end interface default
interface periodic_sum
   module procedure periodic_sum_vec,periodic_sum_mat
end interface periodic_sum
interface cumul_sum_periodic
   module procedure cumul_sum_periodic_vec,cumul_sum_periodic_matrix
end interface cumul_sum_periodic
interface matrix
   module procedure matrix_from_vec,matrix_reshape,matrix_row_col
end interface matrix
interface cbind
   module procedure combine_col_int,combine_col_real,combine_mat_col_real, &
                    combine_vec_mat_col_real,combine_mat_vec_col_real
end interface cbind
interface combine_col
   module procedure combine_col_int,combine_col_real
end interface combine_col
interface str
   module procedure str_int,str_logical
end interface str
interface all_equal
   module procedure all_equal_vec_real,all_equal_vec_int,all_equal_in_vec
end interface all_equal
interface vec_exclude
   module procedure vec_exclude_int
end interface vec_exclude
interface operator (.in.)
   module procedure int_in_vec,char_in_vec,int_vec_in_vec,char_vec_in_vec
end interface
interface operator (.notall.)
   module procedure notall
end interface
interface operator (.notin.)
   module procedure int_not_in_vec,char_not_in_vec,int_vec_not_in_vec
end interface
interface good_pos
   module procedure good_pos_int,good_pos_char
end interface good_pos
interface in_range
   module procedure in_range_int
end interface in_range
interface copy_alloc
   module procedure copy_alloc_matrix_int,copy_alloc_matrix_real,copy_alloc_vec_char,copy_alloc_vec_int,copy_alloc_vec_real
end interface copy_alloc
interface exclude
   module procedure exclude_vec_int,exclude_vec_real
end interface exclude
interface same_rows
   module procedure same_rows_real
end interface same_rows
interface grid
   module procedure grid_int,grid_real
end interface grid
interface sgn
   module procedure sgn_real
end interface sgn
interface unique
   module procedure unique_int,unique_char,unique_real
end interface unique
interface runif
   module procedure runif_vec
end interface runif
interface set_optional
   module procedure set_optional_real,set_optional_integer,set_optional_logical, &
                    set_optional_character
end interface set_optional
interface select_array
   module procedure select_tensor_real,select_vec_character
end interface select_array
interface set_alloc
   module procedure set_alloc_real_tensor,set_alloc_real_matrix,set_alloc_real_vec,set_alloc_character_vec, &
                    set_alloc_int_vec,set_alloc_character_mat,set_alloc_logical_vec,set_alloc_i64_vec, &
                    set_alloc_logical_matrix,set_alloc_integer_matrix,set_alloc_logical_tensor
end interface set_alloc
interface optional_value
   module procedure optional_value_integer, optional_value_character, optional_value_real, optional_value_logical
end interface optional_value
interface cumul_sum
   module procedure cumul_sum_vec,cumul_sum_mat
end interface cumul_sum
interface cumul_sum0
   module procedure cumul_sum0_vec,cumul_sum0_mat
end interface cumul_sum0
interface if_else
   module procedure if_else_real,if_else_int
end interface if_else
interface polynom_value
   module procedure polynom_value_scalar,polynom_value_vec
end interface polynom_value
interface conform
   module procedure conform_real_1d,conform_real_2d,conform_real_3d,conform_real_2d_3d
end interface conform
interface conform_optional
   module procedure conform_optional_real_1d,conform_optional_real_2d
end interface conform_optional
interface slice
   module procedure slice_int_vec,slice_real_vec
end interface slice
interface repeat
   module procedure repeat_char,repeat_char_vec,repeat_int,repeat_real,repeat_logical, &
                    repeat_real_vec
end interface repeat
interface operator(.plus.)
   module procedure char_plus_char,char_plus_int
end interface operator(.plus.)
interface operator(+)
   module procedure char_plus_char,char_plus_int
end interface operator(+)
interface check_included
   module procedure check_included_vec_int,check_included_vec_char
end interface check_included
interface alloc_sub
   module procedure alloc_sub_vec_real,alloc_sub_vec_int
end interface alloc_sub
interface check_equal
   module procedure check_equal_strings
end interface check_equal
interface growing_mean
   module procedure growing_mean_vec
end interface growing_mean
interface pos_first_nonzero
   module procedure pos_first_nonzero_real_vec
end interface pos_first_nonzero
interface sorted
   module procedure sorted_real
end interface sorted
interface match
   module procedure match_char
end interface match
interface unique_vec
   module procedure unique_vec_int,unique_char_int
end interface unique_vec
interface operator(.div.)
   module procedure matrix_by_vector_real
end interface operator(.div.)
interface alloc_matrix
   module procedure alloc_matrix_real
end interface alloc_matrix
interface random_logical
   module procedure random_logical_vec,random_logical_matrix,random_logical_3d
end interface random_logical
interface tail
   module procedure tail_real,tail_int
end interface tail
interface first
   module procedure first_int,first_real,first_char
end interface first
interface default_alloc
   module procedure default_alloc_char
end interface default_alloc
interface get_sub
   module procedure get_sub_vec_real,get_sub_matrix_real,get_sub_array_3d_real
end interface get_sub
interface lookup
   module procedure lookup_char_scalar,lookup_char_vec,lookup_char_matrix
end interface lookup
interface lag_good_data
   module procedure lag_good_data_vec
end interface lag_good_data
interface assert_range
   module procedure assert_int_range,assert_int_vec_range
end interface assert_range
interface maxloc_match
   module procedure maxloc_match_1,maxloc_match_2
end interface
interface alloc_init
   module procedure alloc_init_real
end interface alloc_init
interface num_changes
   module procedure num_changes_int
end interface num_changes
interface assert_positive
   module procedure assert_positive_int
end interface assert_positive
interface indexx
   module procedure indexx_real,indexx_int
end interface indexx
interface indexx_order
   module procedure indexx_order_real
end interface indexx_order
interface subset
   module procedure subset_char
end interface subset
interface operator (.posin.) ! a .posin. b returns the first position in b that matches a, 0 if no match
   module procedure match_string_scalar,match_string_vec,match_int_scalar,match_int_vec
end interface
! interface read_vec_line
!    module procedure read_vec_line_real
! end interface read_vec_line
integer                :: old_time_
integer(kind=long_int) :: mm(100,100)
integer, allocatable :: comb_mat(:,:)
real(kind=dp)    , parameter :: tiny_real = 1.0d-10, pi = 3.141592653589793238462643_dp, &
                                bad_real = -999.0_dp
integer          , parameter :: itrue = 1, ifalse = 0, istdin = 5, istdout = 6, bad_unit=-1, bad_int = -999
character (len=*), parameter :: newl = achar(10), mod_str = "in util_mod::", &
                                lower_case = "abcdefghijklmnopqrstuvwxyz", &
                                upper_case = "ABCDEFGHIJKLMNOPQRSTUVWXYZ",mod_name="util_mod", &
                                newline = char(10),bad_char="???"
character (len=20), parameter :: str_ratio_diff="ratio_diff", str_none="none",str_simple="simple",str_log="log", &
                                 str_diff="diff",str_trans(3)=[str_ratio_diff,str_diff,str_none]
! character (len=6), parameter  :: str_simple = "simple", str_log = "log"
type :: int_grid
   integer :: imin,imax,ih
end type int_grid
contains
function ran_uni_vec(n) result(xran)
integer, intent(in) :: n
real(kind=dp)       :: xran(n)
call random_number(xran)
end function ran_uni_vec
!
pure function diff_vector_int(xx) result(yy)
integer, intent(in) :: xx(:)
integer             :: yy(size(xx)-1)
integer             :: n
n = size(xx)
if (n > 1) yy = xx(2:)-xx(:n-1)
end function diff_vector_int
!
pure function diff_vector_real(xx) result(yy)
! return the first differences of xx(:) 
real(kind=dp), intent(in) :: xx(:)
real(kind=dp)             :: yy(size(xx)-1)
integer                   :: n
n = size(xx)
if (n > 1) yy = xx(2:)-xx(:n-1)
end function diff_vector_real
!
pure function diff_matrix_real(xx) result(yy)
! return the difference of consecutive elements for each column of yy(:,:)
real(kind=dp), intent(in) :: xx(:,:)
real(kind=dp)             :: yy(size(xx,1)-1,size(xx,2))
integer                   :: n
n = size(xx,1)
if (n > 1) yy = xx(2:,:)-xx(:n-1,:)
end function diff_matrix_real
!
elemental function sech(xx) result(yy)
! hyperbolic secant
real(kind=dp), intent(in) :: xx
real(kind=dp)             :: yy
yy = 1/cosh(xx)
end function sech
!
function exe_name() result(xname)
! return the program name, including directory
character (len=1000) :: xname
character (len=1000) :: dir_name
call getcwd(dir_name)
! call getarg(0,xname)
call get_command_argument(0,xname)
xname = trim(dir_name) // "\" // trim(xname)
end function exe_name
!
function matrix_by_vector_real(xmat,xx) result(ymat)
! divide each column of xmat(:,:) by the corresponding element in xx(:)
real(kind=dp), intent(in) :: xmat(:,:),xx(:)
real(kind=dp)             :: ymat(size(xmat,1),size(xmat,2))
integer                   :: i,n2
n2 = size(xmat,2)
forall (i=1:n2) ymat(:,i) = xmat(:,i)/xx(i)
end function matrix_by_vector_real
!
! subroutine read_vec_line_real(iu,xx,nread)
! ! read words from line, where the line has the # of words followed by the words
! ! n word_1 word_2 ... word_n
! integer          , intent(in)               :: iu
! real(kind=dp)    , intent(out), allocatable :: xx(:)
! integer          , intent(out), optional    :: nread
! character (len=10000)                       :: text
! integer                                     :: ierr,nw
! read (iu,"(a)") text
! read (text,*,iostat=ierr) nw
! if (ierr /= 0) then
!    write (*,*) "in read_vec_line_real, could not read integer from '" // trim(text) // "', STOPPING"
!    stop
! end if
! if (nw > 0) then
!    allocate (xx(nw))
!    read (text,*) nw,xx
! else
!    allocate (xx(0))
! end if
! if (present(nread)) nread = size(xx)
! end subroutine read_vec_line_real
!
subroutine read_words_line(iu,words,nread,echo,label)
! read words from line, where the line has the # of words followed by the words
! n word_1 word_2 ... word_n
integer          , intent(in)               :: iu
character (len=*), intent(out), allocatable :: words(:)
integer          , intent(out), optional    :: nread
character (len=*), intent(in) , optional    :: label
logical          , intent(in) , optional    :: echo
character (len=10000)                       :: text
integer                                     :: i,ierr,nread_,nw
read (iu,"(a)") text
read (text,*,iostat=ierr) nw
if (ierr /= 0) then
   write (*,*) "in read_words_line, could not read integer from '" // trim(text) // "', STOPPING"
   stop
end if
if (nw > 0) then
   allocate (words(nw))
   read (text,*,iostat=ierr) nw,words
   if (ierr /= 0) then
      write (*,*) "in read_words_line, could not read",nw," words from '" // trim(text) // "', STOPPING"
      stop
   end if
else
   allocate (words(0))
end if
nread_ = size(words)
if (present(nread)) nread = nread_
if (default(.false.,echo)) then
   if (present(label)) write (*,*) trim(label) // ":"
   write (*,*) (trim(words(i)) // " ",i=1,nread_)
   write (*,*)
end if
end subroutine read_words_line
!
function num_changes_int(ivec) result(nch)
integer, intent(in) :: ivec(:)
integer             :: nch
integer             :: n
n = size(ivec)
if (n > 1) then
   nch = count(ivec(2:) /= ivec(:n-1))
else
   nch = 0
end if
end function num_changes_int
!
function pos_first_nonzero_real_vec(xx) result(ipos)
real(kind=dp), intent(in) :: xx(:)
integer                   :: ipos
integer                   :: i
ipos = 0
do i=1,size(xx)
   if (xx(i) /= 0.0_dp) then
      ipos = i
      exit
   end if
end do
end function pos_first_nonzero_real_vec
!
function sum_no_overlap_vector(xx,nsum) result(xsum)
! compute non-overlapping nsum-term sums of xx(:)
real(kind=dp), intent(in) :: xx(:)
integer      , intent(in) :: nsum
real(kind=dp)             :: xsum(size(xx)/nsum)
integer                   :: i
do i=1,size(xx)/nsum
   xsum(i) = sum(xx((i-1)*nsum+1:i*nsum))
end do
end function sum_no_overlap_vector
!
function sum_no_overlap_matrix(xx,nsum) result(xsum)
! compute non-overlapping nsum-term sums of xx(:)
real(kind=dp), intent(in) :: xx(:,:)
integer      , intent(in) :: nsum
real(kind=dp)             :: xsum(size(xx,1)/nsum,size(xx,2))
integer                   :: i,j
do i=1,size(xx,1)/nsum
   do j=1,size(xx,2)
      xsum(i,j) = sum(xx((i-1)*nsum+1:i*nsum,j))
   end do
end do
end function sum_no_overlap_matrix
!
subroutine compare_vec_strings(xx,yy,xname,yname)
! list which elements of xx are not in yy and which elements of yy are not in xx
character (len=*), intent(in) :: xx(:),yy(:)
character (len=*), intent(in), optional :: xname,yname
character (len=100) :: xname_,yname_
logical             :: x_not_in_y(size(xx))
integer             :: i,nx,ny,nx_not_in_y
xname_ = default("x",xname)
yname_ = default("y",yname)
nx = size(xx)
ny = size(yy)
x_not_in_y = [(all(yy/=xx(i)),i=1,size(xx))]
nx_not_in_y = count(x_not_in_y)
if (nx_not_in_y == 0) then
   write (*,*) "all elements of " // trim(xname_) // " are in " // trim(yname_)
else
   write (*,*) nx_not_in_y," elements of " // trim(xname_) // " not in " // trim(yname_) // ":"
   do i=1,nx
      if (x_not_in_y(i)) write (*,*) trim(xx(i))
   end do
   write (*,*)
end if
call compare_vec_strings_(yy,xx,yname,xname)
end subroutine compare_vec_strings
!
subroutine compare_vec_strings_(xx,yy,xname,yname)
character (len=*), intent(in) :: xx(:),yy(:)
character (len=*), intent(in), optional :: xname,yname
character (len=100) :: xname_,yname_
logical             :: x_not_in_y(size(xx))
integer             :: i,nx,ny,nx_not_in_y
xname_ = default("x",xname)
yname_ = default("y",yname)
nx = size(xx)
ny = size(yy)
x_not_in_y = [(all(yy/=xx(i)),i=1,size(xx))]
nx_not_in_y = count(x_not_in_y)
if (nx_not_in_y == 0) then
   write (*,*) "all elements of " // trim(xname_) // " are in " // trim(yname_)
else
   write (*,*) nx_not_in_y," elements of " // trim(xname_) // " not in " // trim(yname_) // ":"
   do i=1,nx
      if (x_not_in_y(i)) write (*,*) trim(xx(i))
   end do
   write (*,*)
end if
end subroutine compare_vec_strings_
!
subroutine check_equal_strings(xx,yy,xname,yname,caller,stop_error)
! check that each element of xx matches that of yy
character (len=*), intent(in)           :: xx(:),yy(:)
character (len=*), intent(in), optional :: xname,yname,caller
logical          , intent(in), optional :: stop_error
logical                                 :: stop_error_
character (len=100)                     :: xname_,yname_,call_msg
integer                                 :: n,ny,i,ibad
character (len=*), parameter            :: msg="in util_mod::check_equal_strings, "
stop_error_ = default(.true.,stop_error)
if (present(caller)) then
   call_msg = "called from " // trim(caller) // ","
else
   call_msg = ""
end if
call set_optional(xname_,"x",xname)
call set_optional(yname_,"y",yname)
! xname_ = default("x",xname)
! yname_ = default("y",yname)
n  = size(xx)
ny = size(yy)
if (n /= ny) then
   write (*,*) msg // trim(call_msg)," size(xx), size(yy) =",n,ny," must be equal"
   if (stop_error_) then
      write (*,*) "STOPPING"
      stop
   end if
end if
ibad = 0
do i=1,n
   if (xx(i) /= yy(i)) then
      ibad = i
      exit
   end if
end do
if (ibad /= 0) then
   write (*,*) msg // trim(call_msg)
   write (*,*) trim(xname_) // " =",(" " // trim(xx(i)),i=1,n)
   write (*,*) trim(yname_) // " =",(" " // trim(yy(i)),i=1,n)
   write (*,*) trim(xname_) // " not matching " // trim(yname_) // " for element ",ibad, &
               " '" // trim(xx(ibad)) // "' not equal to '" // trim(yy(ibad)) // "'"
   if (stop_error_) then
      write (*,*) "STOPPING"
      stop
   end if
end if
end subroutine check_equal_strings
!
function normalize(xx) result(yy)
real(kind=dp), intent(in) :: xx(:)
real(kind=dp)             :: yy(size(xx))
yy = xx/max(sum(abs(xx)),tiny_real)
end function normalize
!
subroutine alloc_sub_vec_real(xx,n)
! allocate xx to size n
real(kind=dp), intent(out), allocatable :: xx(:)
integer      , intent(in)               :: n
allocate (xx(max(0,n)))
end subroutine alloc_sub_vec_real
!
subroutine alloc_sub_vec_int(xx,n)
! allocate xx to size n
integer, intent(out), allocatable :: xx(:)
integer, intent(in)               :: n
allocate (xx(max(0,n)))
end subroutine alloc_sub_vec_int
!
subroutine read_alloc_char(iu,xx,nx,print_vec,label,same_line)
! read the size of an allocatable array and then the array from the next line
integer          , intent(in)               :: iu    ! unit read
character (len=*), intent(out), allocatable :: xx(:) ! data read
integer          , intent(out), optional    :: nx    ! size(xx)
logical          , intent(in) , optional    :: print_vec
character (len=*), intent(in) , optional    :: label
logical          , intent(in) , optional    :: same_line
integer                                     :: i,nx_,ndum
read (iu,*) nx_
nx_ = max(0,nx_)
allocate (xx(nx_))
if (present_and_true(same_line)) then
   backspace(iu)
   read (iu,*) ndum,xx
else
   read (iu,*) xx
end if
if (present(nx)) nx = nx_
if (default(.false.,print_vec)) write (*,"(1x,a30,':',100(1x,a))") trim(default("          ",label)), &
                                                               (trim(xx(i)),i=1,size(xx))
end subroutine read_alloc_char
!
subroutine check_included_vec_int(ii,jj)
! check that each element in ii(:) is in jj(:), stopping otherwise
integer, intent(in) :: ii(:),jj(:)
integer             :: i,ni,nbad
ni   = size(ii)
nbad = 0
do i=1,ni
   if (ii(i) .notin. jj) then
      nbad = nbad + 1
      write (*,*) "in check_included, i, ii(i) =",i,ii(i)," not in jj"
   end if
end do
if (nbad > 0) stop
end subroutine check_included_vec_int
!
subroutine check_included_vec_char(ii,jj)
! check that each element in ii(:) is in jj(:), stopping otherwise
character (len=*), intent(in) :: ii(:),jj(:)
integer                       :: i,ni,nbad
ni   = size(ii)
nbad = 0
do i=1,ni
   if (ii(i) .notin. jj) then
      nbad = nbad + 1
      write (*,*) "in check_included, i, ii(i) =",i,ii(i)," not in jj"
   end if
end do
if (nbad > 0) stop
end subroutine check_included_vec_char
!
function join(words,sep) result(str)
! trim and concatenate a vector of character variables,
! inserting sep between them
character (len=*), intent(in)                                   :: words(:),sep
character (len=(size(words)-1)*len(sep) + sum(len_trim(words))) :: str
integer                                                         :: i,nw
nw  = size(words)
str = ""
if (nw < 1) then
   return
else
   str = words(1)
end if
do i=2,nw
   str = trim(str) // sep // words(i) 
end do
write (str,"(10000(a))") trim(words(1)),(sep // trim(words(i)), i = 2,nw)
end function join
!
function join_quote(words,sep,quote_char) result(str)
! trim and concatenate a vector of character variables,
! inserting sep between them
character (len=*), intent(in)        :: words(:),sep
character (len=(size(words)-1)*len(sep) + sum(len_trim(words)) + 2*size(words)) :: str
character (len=1), intent(in), optional :: quote_char
integer                              :: i,nw
character (len=1)                    :: quote_char_
quote_char_ = default("'",quote_char)
nw  = size(words)
str = ""
if (nw < 1) then
   return
else
   str = quote_char_ // trim(words(1)) // quote_char_
end if
do i=2,nw
   str = trim(str) // sep // quote_char_ // trim(words(i)) // quote_char_
end do
end function join_quote
!
function join_csv(words) result(str)
! trim and concatenate a vector of character variables,
! inserting a comma between them
character (len=*), intent(in)                            :: words(:)
character (len=(size(words)-1)*1 + sum(len_trim(words))) :: str
integer                                                  :: i,nw
nw  = size(words)
if (nw < 1) then
   str = ""
   return
end if
write (str,"(10000(a))") trim(words(1)),("," // trim(words(i)), i = 2,nw)
end function join_csv
!
function join_csv_suffix(words,suffix) result(str)
! trim and concatenate a vector of character variables,
! inserting a comma between them
character (len=*), intent(in)                            :: words(:)
character (len=*), intent(in)                            :: suffix
! character (len=1000) :: str
character (len=(size(words)-1)*1 + sum(len_trim(words)) + size(words)*len(suffix)) :: str
integer                                                  :: i,nw
nw  = size(words)
if (nw < 1) then
   str = ""
   return
end if
write (str,"(10000(a))") trim(words(1)) // suffix,("," // trim(words(i)) // suffix, i = 2,nw)
end function join_csv_suffix
!
function join_suffix(words,suffix) result(str)
! trim and concatenate a vector of character variables,
! inserting a suffix after each trimmed element
character (len=*), intent(in)                                    :: words(:)
character (len=*), intent(in)                                    :: suffix
character (len=(size(words)*len(suffix) + sum(len_trim(words)))) :: str
integer                                                          :: i,nw
nw  = size(words)
str = ""
if (nw < 1) return
write (str,"(10000(a))") (trim(words(i)) // suffix, i = 1,nw)
end function join_suffix
!
function concat(cvec,sep,cquote) result(yy)
! join strings
character (len=*), intent(in) :: cvec(:)
character (len=*), intent(in), optional :: sep,cquote
character (len=100*size(cvec)) :: yy
if (present(sep) .and. present(cquote)) then
   yy = join_(cvec,sep,cquote)
else if (present(cquote)) then
   yy = join_(cvec," ",cquote)
else if (present(sep)) then
   yy = join_(cvec,sep,"")
else
   yy = join_(cvec," ","")
end if
end function concat
!
function join_(cvec,sep,cquote) result(yy)
! join strings
character (len=*), intent(in) :: cvec(:)
character (len=*), intent(in) :: sep
character (len=*), intent(in) :: cquote
character (len=100*size(cvec)) :: yy
integer :: i,n
n = size(cvec)
yy = ""
do i=1,n
   if (i > 1) then
      yy = trim(yy) // sep // cquote // trim(cvec(i)) // cquote
   else
      yy = cquote // trim(cvec(i)) // cquote
   end if
!   if (i < n) yy = trim(yy) + delim
end do
end function join_
!
elemental function char_plus_char(c1,c2) result(c12)
! trim two strings and add them
character (len=*),   intent(in) :: c1,c2
character (len=len(c1)+len(c2)) :: c12
c12 = trim(c1) // trim(c2)
end function char_plus_char
!
elemental function char_plus_int(c1,i) result(c12)
! add a string to an integer
character (len=*),   intent(in) :: c1
integer          ,   intent(in) :: i
character (len=*), parameter :: cdelim_ = "_"
character (len=len(c1)+len(cdelim_)+20) :: c12
c12 = trim(c1) // cdelim_ // trim(str(i))
end function char_plus_int
!
function sign_changes_real(xx) result(tf)
real(kind=dp), intent(in) :: xx(:)
logical                   :: tf(size(xx))
integer                   :: i,n
n = size(xx)
if (n < 1) return
tf(1) = .false.
forall (i=2:n) tf(i) = (xx(i) > 0.0_dp .and. xx(i-1) < 0.0_dp) .or. (xx(i) < 0.0_dp .and. xx(i-1) > 0.0_dp)
end function sign_changes_real
!
elemental function sgn_real(xx,thresh,smooth) result(yy)
! return sign of xx (-1,0,1)
real(kind=dp), intent(in)           :: xx
real(kind=dp), intent(in), optional :: thresh
logical      , intent(in), optional :: smooth
real(kind=dp)                       :: yy
if (present(thresh)) then
   if (abs(xx) < thresh) then
      if (present_and_false(smooth)) then
         yy = 0.0_dp
      else
         yy = xx/thresh
      end if
   else if (xx >= thresh) then
      yy =  1.0_dp
   else
      yy = -1.0_dp
   end if
else
   if (xx == 0.0_dp) then
      yy = 0.0_dp
   else if (xx > 0.0_dp) then
      yy = 1.0_dp
   else
      yy = -1.0_dp
   end if
end if
end function sgn_real
!
elemental function trim_append(xx,yy) result(xy)
character (len=*), intent(in) :: xx,yy
character (len=len(xx) + len(yy)) :: xy
xy = trim(xx) // yy
end function trim_append
!
function munge(xx,yy,delim) result(xy)
! create array of strings containing combinations of xx and yy
character (len=*), intent(in) :: xx(:),yy(:),delim
character (len=len(xx)+len(yy)+len(delim)) :: xy(size(xx)*size(yy))
integer :: ix,iy,nx
nx = size(xx)
forall (ix=1:size(xx),iy=1:size(yy)) xy(ix + (iy-1)*nx) = trim(xx(ix)) // delim // trim(yy(iy))
end function munge
!
pure function repeat_logical(n,xx) result(yy)
! repeat 1-D array of logical variables with xx repeated n times
integer          , intent(in) :: n
logical          , intent(in) :: xx
logical                       :: yy(n)
integer                       :: i
yy = [(xx,i=1,n)]
end function repeat_logical
!
pure function repeat_char(n,xx) result(yy)
! repeat 1-D array of character variables with xx repeated n times
integer          , intent(in) :: n
character (len=*), intent(in) :: xx
character (len=len(xx))       :: yy(n)
integer                       :: i
yy = (/(xx,i=1,n)/)
end function repeat_char
!
pure function repeat_int(n,i) result(ivec)
! repeat 1-D array of integer variables with i repeated n times
integer, intent(in) :: n,i
integer             :: ivec(n)
integer             :: j
forall (j=1:n) ivec(j) = i
end function repeat_int
!
pure function repeat_real(n,x) result(xvec)
! return 1-D array of real variables with x repeated n times
integer, intent(in)       :: n
real(kind=dp), intent(in) :: x
real(kind=dp)             :: xvec(n)
integer                   :: j
forall (j=1:n) xvec(j) = x
end function repeat_real
!
pure function zeros(n) result(xvec)
! return a vector of n zeros
integer, intent(in) :: n
real(kind=dp)       :: xvec(n)
xvec = 0.0_dp
end function zeros
!
pure function repeat_real_vec(n,x) result(xvec)
! repeat 1-D array of real variables with x repeated n times
integer, intent(in)       :: n
real(kind=dp), intent(in) :: x(:)
real(kind=dp)             :: xvec(n*size(x))
integer                   :: i,j,k
i = 0
do j=1,n
   do k=1,size(x)
      i = i + 1
      xvec(i) = x(k)
   end do
end do
end function repeat_real_vec
!
function repeat_char_vec(n,xx,alternate) result(yy)
! repeat 1-D array with xx repeated n times
integer          , intent(in) :: n
character (len=*), intent(in) :: xx(:)
logical          , intent(in), optional :: alternate
character (len=len(xx))       :: yy(n*size(xx))
integer                       :: i,j
if (present_and_false(alternate)) then
   yy = (/((xx(j),i=1,n),j=1,size(xx))/)
else
   yy = (/(xx,i=1,n)/)
end if
end function repeat_char_vec
!
function slice_int_vec(ivec,i1,i2) result(jvec)
! return the slice ivec(i1:i2), avoiding out-of-bounds
! array access
integer, intent(in)            :: ivec(:)
integer, intent(in), optional  :: i1,i2
integer, allocatable           :: jvec(:)
integer                        :: j1,j2,nj
if (present(i1)) then
   j1 = max(lbound(ivec,dim=1),i1)
else
   j1 = lbound(ivec,dim=1)
end if
if (present(i2)) then
   j2 = min(ubound(ivec,dim=1),i2)
else
   j2 = ubound(ivec,dim=1)
end if
nj = j2 - j1 + 1
allocate (jvec(nj))
jvec = ivec(j1:j2)
end function slice_int_vec
!
function slice_real_vec(ivec,i1,i2) result(jvec)
! return the slice ivec(i1:i2), avoiding out-of-bounds
! array access
real(kind=dp), intent(in)            :: ivec(:)
integer      , intent(in), optional  :: i1,i2
real(kind=dp), allocatable           :: jvec(:)
integer                              :: j1,j2,nj
if (present(i1)) then
   j1 = max(lbound(ivec,dim=1),i1)
else
   j1 = lbound(ivec,dim=1)
end if
if (present(i2)) then
   j2 = min(ubound(ivec,dim=1),i2)
else
   j2 = ubound(ivec,dim=1)
end if
nj = j2 - j1 + 1
allocate (jvec(nj))
jvec = ivec(j1:j2)
end function slice_real_vec
!
function slice_rows_int_mat(imat,i1,i2) result(jmat)
! return the slice imat(i1:i2,:), avoiding out-of-bounds
! array access
integer      , intent(in)           :: imat(:,:)
integer      , intent(in), optional :: i1,i2
integer      , allocatable          :: jmat(:,:)
integer                             :: j1,j2,nj
if (present(i1)) then
   j1 = max(lbound(imat,dim=1),i1)
else
   j1 = lbound(imat,dim=1)
end if
if (present(i2)) then
   j2 = min(ubound(imat,dim=1),i2)
else
   j2 = ubound(imat,dim=1)
end if
nj = j2 - j1 + 1
allocate (jmat(nj,size(imat,2)))
jmat = imat(j1:j2,:)
end function slice_rows_int_mat
!
function slice_rows_real_mat(imat,i1,i2) result(jmat)
! return the slice imat(i1:i2,:), avoiding out-of-bounds
! array access
real(kind=dp), intent(in)           :: imat(:,:)
integer      , intent(in), optional :: i1,i2
real(kind=dp), allocatable          :: jmat(:,:)
integer                             :: j1,j2,nj
if (present(i1)) then
   j1 = max(lbound(imat,dim=1),i1)
else
   j1 = lbound(imat,dim=1)
end if
if (present(i2)) then
   j2 = min(ubound(imat,dim=1),i2)
else
   j2 = ubound(imat,dim=1)
end if
nj = j2 - j1 + 1
allocate (jmat(nj,size(imat,2)))
jmat = imat(j1:j2,:)
end function slice_rows_real_mat
!
subroutine init_wall_time()
call system_clock(old_time_)
end subroutine init_wall_time
!
subroutine print_wall_time_elapsed(old_time,fmt_trailer,outu,t1_cpu)
! print the time elapsed since old_time by calling system_clock
integer          , intent(in), optional :: old_time ! initialized with call system_clock(old_time)
character (len=*), intent(in), optional :: fmt_trailer
integer          , intent(in), optional :: outu
real(kind=dp)    , intent(in), optional :: t1_cpu
integer                                 :: itick,new_time,outu_
real(kind=dp)                           :: new_time_cpu
character (len=100)                     :: fmt_time_
if (present(old_time)) old_time_ = old_time
outu_ = default(istdout,outu)
fmt_time_ = "(/,1x,'wall time elapsed(s) = ',f9.3)"
call system_clock(new_time,itick)
write (outu_,fmt_time_) (new_time-old_time_)/dble(itick)
if (present(t1_cpu)) then
   call cpu_time(new_time_cpu)
   write (outu_,"(1x,' cpu time elapsed(s) = ',f9.3)") new_time_cpu-t1_cpu
end if
if (present(fmt_trailer)) then
   if (fmt_trailer /= "") write (outu_,fmt_trailer)
end if
end subroutine print_wall_time_elapsed
!
subroutine set_time(time_cpu,time_clock)
real(kind=dp), intent(out) :: time_cpu
integer      , intent(out) :: time_clock
call cpu_time(time_cpu)
call system_clock(time_clock)
end subRoutine set_time
!
function wall_time_elapsed(old_time) result(xtime)
! return the wall clock time elapsed in seconds
integer          , intent(in)           :: old_time ! set with call system_clock(old_time)
real(kind=dp)                           :: xtime
integer                                 :: itick,new_time
call system_clock(new_time,itick)
xtime = (new_time-old_time)/dble(itick)
end function wall_time_elapsed
!
function time_elapsed(old_time) result(ytime)
real(kind=dp)    , intent(in) :: old_time
real(kind=dp)                 :: ytime
real(kind=dp)                 :: new_time
call cpu_time(new_time)
ytime = new_time - old_time
end function time_elapsed
!
subroutine print_time_elapsed(old_time,fmt_trailer,print_time,title)
! print time elapsed since old_time
real(kind=dp)    , intent(in)           :: old_time ! previously set by call cpu_time(old_time)
character (len=*), intent(in), optional :: fmt_trailer,title
logical          , intent(in), optional :: print_time
real(kind=dp)                           :: new_time
character (len=100)                     :: fmt_time_
! logical                                 :: print_time_
fmt_time_ = "(/,1x,'time elapsed(s)',1x,f0.2,1x,a)"
call cpu_time(new_time)
write (*,fmt_time_) new_time-old_time
if (present(title)) write (*,"(a)") trim(title)
if (present(fmt_trailer)) then
   if (fmt_trailer /= "") then
      if (default(.true.,print_time)) then
         write (*,fmt_trailer,advance="no")
         write (*,"(a)") " at " // now()
      else
         write (*,fmt_trailer)
      end if
   end if
end if
end subroutine print_time_elapsed
!
elemental function optional_value_real(xdef,xopt) result(yy)
! set yy to (xopt,xdef) if xopt (is,is not) PRESENT
real(kind=dp), intent(in)           :: xdef
real(kind=dp), intent(in), optional :: xopt
real(kind=dp)                       :: yy
if (present(xopt)) then
   yy = xopt
else
   yy = xdef
end if
end function optional_value_real
!
elemental function optional_value_integer(xdef,xopt) result(yy)
! set yy to (xopt,xdef) if xopt (is,is not) PRESENT
integer, intent(in)           :: xdef
integer, intent(in), optional :: xopt
integer                       :: yy
if (present(xopt)) then
   yy = xopt
else
   yy = xdef
end if
end function optional_value_integer
!
elemental function optional_value_character(xdef,xopt) result(yy)
! set yy to (xopt,xdef) if xopt (is,is not) PRESENT
character (len=*), intent(in)           :: xdef
character (len=*), intent(in), optional :: xopt
character (len=len(xdef))               :: yy
if (present(xopt)) then
   yy = xopt
else
   yy = xdef
end if
end function optional_value_character
!
elemental function optional_value_logical(xdef,xopt) result(yy)
! set yy to (xopt,xdef) if xopt (is,is not) PRESENT
logical, intent(in)           :: xdef
logical, intent(in), optional :: xopt
logical                       :: yy
if (present(xopt)) then
   yy = xopt
else
   yy = xdef
end if
end function optional_value_logical
!
subroutine set_optional_alloc_real(xx,xdef,xopt)
! set xx(:) to xopt(:) if present and xdef(:) if not
real(kind=dp), intent(out), allocatable :: xx(:)
real(kind=dp), intent(in)               :: xdef(:)
real(kind=dp), intent(in) , optional    :: xopt(:)
if (present(xopt)) then
   call set_alloc(xopt,xx)
else
   call set_alloc(xdef,xx)
end if
end subroutine set_optional_alloc_real
!
subroutine set_optional_alloc_int(xx,xdef,xopt)
! set xx(:) to xopt(:) if present and xdef(:) if not
integer, intent(out), allocatable :: xx(:)
integer, intent(in)               :: xdef(:)
integer, intent(in) , optional    :: xopt(:)
if (present(xopt)) then
   call set_alloc(xopt,xx)
else
   call set_alloc(xdef,xx)
end if
end subroutine set_optional_alloc_int
!
subroutine set_optional_alloc_character(xx,xdef,xopt,n)
! set xx to (xopt,xdef) if xopt (is,is not) PRESENT
character(len=*), intent(out), allocatable :: xx(:)
character(len=*), intent(in)               :: xdef(:)
character(len=*), intent(in) , optional    :: xopt(:)
integer         , intent(out), optional    :: n
if (present(xopt)) then
   call set_alloc(xopt,xx)
else
   call set_alloc(xdef,xx)
end if
if (present(n)) n = size(xx)
end subroutine set_optional_alloc_character
!
elemental subroutine set_optional_real(xx,xdef,xopt)
! set xx to (xopt,xdef) if xopt (is,is not) PRESENT
real(kind=dp), intent(out)          :: xx
real(kind=dp), intent(in)           :: xdef
real(kind=dp), intent(in), optional :: xopt
if (present(xopt)) then
   xx = xopt
else
   xx = xdef
end if
end subroutine set_optional_real
!
elemental subroutine set_optional_integer(i,idef,iopt)
! set i to (iopt,idef) if iopt (is,is not) PRESENT
integer, intent(out)          :: i
integer, intent(in)           :: idef
integer, intent(in), optional :: iopt
if (present(iopt)) then
   i = iopt
else
   i = idef
end if
end subroutine set_optional_integer
!
elemental subroutine set_optional_logical(xx,xdef,xopt)
! set xx to (xopt,xdef) if xopt (is,is not) PRESENT
logical, intent(out)          :: xx
logical, intent(in)           :: xdef
logical, intent(in), optional :: xopt
if (present(xopt)) then
   xx = xopt
else
   xx = xdef
end if
end subroutine set_optional_logical
!
elemental subroutine set_optional_character(xx,xdef,xopt)
! set xx to (xopt,xdef) if xopt (is,is not) PRESENT
character(len=*), intent(out)          :: xx
character(len=*), intent(in)           :: xdef
character(len=*), intent(in), optional :: xopt
if (present(xopt)) then
   xx = xopt
else
   xx = xdef
end if
end subroutine set_optional_character
!
pure function present_and_true(xx) result(tf)
logical, intent(in), optional :: xx
logical                       :: tf
if (present(xx)) then
   tf = xx
else
   tf = .false.
end if
end function present_and_true
!
pure function present_and_false(xx) result(tf)
logical, intent(in), optional :: xx
logical                       :: tf
if (present(xx)) then
   tf = .not. xx
else
   tf = .false.
end if
end function present_and_false
!
pure function first_row_all_true(tf) result(irow)
logical, intent(in) :: tf(:,:)
integer             :: irow
integer             :: i
irow = 0
do i=1,size(tf,1)
   if (all(tf(i,:))) then
      irow = i
      exit
   end if
end do
end function first_row_all_true
!
pure function last_row_all_true(tf) result(irow)
logical, intent(in) :: tf(:,:)
integer             :: irow
integer             :: i
irow = 0
do i=size(tf,1),1,-1
   if (all(tf(i,:))) then
      irow = i
      exit
   end if
end do
end function last_row_all_true
!
elemental function if_else_real(tf,xtrue,xfalse) result(xx)
logical      , intent(in) :: tf
real(kind=dp), intent(in) :: xtrue,xfalse
real(kind=dp)             :: xx
if (tf) then
   xx = xtrue
else
   xx = xfalse
end if
end function if_else_real
!
elemental function if_else_int(tf,itrue,ifalse) result(ii)
logical      , intent(in) :: tf
integer      , intent(in) :: itrue,ifalse
integer                   :: ii
if (tf) then
   ii = itrue
else
   ii = ifalse
end if
end function if_else_int
!
function demean_vec(xx,cdemean) result(xdm)
! demean a vector
real(kind=dp), intent(in)           :: xx(:)
real(kind=dp), intent(in), optional :: cdemean
real(kind=dp)                       :: xdm(size(xx))
if (size(xx) > 0) then
   if (present(cdemean)) then
      xdm = xx - cdemean*sum(xx)/size(xx)
   else
      xdm = xx - sum(xx)/size(xx)
   end if
end if
end function demean_vec
!
function demean_mat(xx,cdemean) result(xdm)
! demean each column of xx(:,:)
real(kind=dp), intent(in)  :: xx(:,:)
real(kind=dp), intent(in), optional :: cdemean
real(kind=dp)              :: xdm(size(xx,1),size(xx,2))
integer                    :: icol,ncol,nobs
nobs = size(xx,1)
ncol = size(xx,2)
if (nobs < 1) return
forall (icol=1:ncol) xdm(:,icol) = xx(:,icol) - default(1.0_dp,cdemean)*sum(xx(:,icol))/nobs
end function demean_mat
!
function demean_col(xx,cdemean) result(xdm)
! demean each column of xx(:,:) by default(1,cdemean) of column mean
real(kind=dp), intent(in)           :: xx(:,:)
real(kind=dp), intent(in), optional :: cdemean
real(kind=dp)                       :: xdm(size(xx,1),size(xx,2))
xdm = demean_mat(xx,cdemean)
end function demean_col
!
subroutine true_pos_count(tf,ipos,npos_true)
! return in ipos(:) the first size(ipos) true positions in tf(:), and in npos_true the # of true positions
! stored in ipos
logical, intent(in)  :: tf(:)
integer, intent(out) :: ipos(:)
integer, intent(out) :: npos_true
integer              :: i,npos,ntf
ipos = 0
npos = size(ipos)
ntf  = size(tf)
npos_true = 0
if (npos == 0 .or. ntf == 0) return
do i=1,ntf
   if (tf(i)) then
      npos_true = npos_true + 1
      ipos(npos_true) = i
      if (npos_true == npos) return
   end if
end do
end subroutine true_pos_count
!
subroutine true_pos_alloc(tf,ipos)
! return in ipos the true positions of tf(:)
logical, intent(in)               :: tf(:)
integer, intent(out), allocatable :: ipos(:)
integer                           :: jpos(size(tf)),ntrue
call true_pos_count(tf,jpos,ntrue)
allocate (ipos(ntrue))
ipos = jpos(:ntrue)
end subroutine true_pos_alloc
!
function true_pos_few(npos,tf) result(ipos)
! return in ipos(1:npos) the positions of the first npos true elements in tf(:)
integer, intent(in) :: npos
logical, intent(in) :: tf(:)
integer             :: ipos(npos)
integer             :: i,j,ntf
ipos = 0
j    = 0
ntf  = size(tf)
if (npos < 1) return
do i=1,ntf
   if (tf(i)) then
      j = j + 1
      ipos(j) = i
      if (j == npos) return
   end if
end do
end function true_pos_few
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
subroutine periodic_sum_vec(nperiod,xx,yy)
! compute cumulative sums of groups of values of xx(:)
integer      , intent(in)               :: nperiod
real(kind=dp), intent(in)               :: xx(:)
real(kind=dp), intent(out), allocatable :: yy(:)
integer                                 :: i,imin,n,ny
n = size(xx)
if (nperiod < 1 .or. nperiod > n) then
   allocate (yy(0))
   return
end if
ny = n/nperiod
allocate (yy(ny))
do i=1,ny
   imin  = 1 + (i-1)*nperiod
   yy(i) = sum(xx(imin:imin+nperiod-1))
end do
end subroutine periodic_sum_vec
!
subroutine periodic_sum_mat(nperiod,xx,yy)
! compute cumulative sums of groups of values of xx(:,:)
integer      , intent(in)               :: nperiod
real(kind=dp), intent(in)               :: xx(:,:)
real(kind=dp), intent(out), allocatable :: yy(:,:)
integer                                 :: i,imin,n,ny,ncol
n    = size(xx,1)
ncol = size(xx,2)
if (nperiod < 1 .or. nperiod > n) then
   allocate (yy(0,ncol))
   return
end if
ny = n/nperiod
allocate (yy(ny,ncol))
do i=1,ny
   imin  = 1 + (i-1)*nperiod
   yy(i,:) = sum(xx(imin:imin+nperiod-1,:),dim=1)
end do
end subroutine periodic_sum_mat
!
function cumul_sum_periodic_vec(xx,nperiod) result(yy)
! compute cumulative sums of groups of values of xx(:)
real(kind=dp), intent(in)  :: xx(:)
integer      , intent(in)  :: nperiod
real(kind=dp), allocatable :: yy(:)
integer                    :: i,imin,n,ny
n = size(xx)
if (nperiod < 1 .or. nperiod > n) then
   allocate (yy(0))
   return
end if
ny = n/nperiod
allocate (yy(ny))
do i=1,ny
   imin  = 1 + (i-1)*nperiod
   yy(i) = sum(xx(imin:imin+nperiod-1))
end do
end function cumul_sum_periodic_vec
!
function cumul_sum_periodic_matrix(xx,nperiod) result(yy)
! compute cumulative sums of groups of rows of xx(:,:)
real(kind=dp), intent(in)  :: xx(:,:)
integer      , intent(in)  :: nperiod
real(kind=dp), allocatable :: yy(:,:)
integer                    :: i,imin,n,ny,ncol
n    = size(xx,1)
ncol = size(xx,2)
if (nperiod < 1 .or. nperiod > n) then
   allocate (yy(0,ncol))
   return
end if
ny = n/nperiod
allocate (yy(ny,ncol))
do i=1,ny
   imin    = 1 + (i-1)*nperiod
   yy(i,:) = sum(xx(imin:imin+nperiod-1,:),dim=1)
end do
end function cumul_sum_periodic_matrix
!
pure function cumul_sum_vec(xx) result(yy)
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
end function cumul_sum_vec
!
pure function cumul_sum0_vec(xx) result(yy)
! return zero followed by the cumulative sum of xx(:)
real(kind=dp), intent(in) :: xx(:)
real(kind=dp)             :: yy(size(xx)+1)
yy = [0.0_dp,cumul_sum_vec(xx)]
end function cumul_sum0_vec
!
function cumul_sum0_mat(xx) result(yy)
! return zero followed by the cumulative sum of xx(:)
real(kind=dp), intent(in) :: xx(:,:)
real(kind=dp)             :: yy(size(xx,1)+1,size(xx,2))
integer                   :: ivar
forall (ivar=1:size(xx,2)) yy(:,ivar) = [0.0_dp,cumul_sum_vec(xx(:,ivar))]
end function cumul_sum0_mat
!
function cumul_sum_mat(xx) result(yy)
! compute the cumulative sum of xx(:)
real(kind=dp), intent(in) :: xx(:,:)
real(kind=dp)             :: yy(size(xx,1),size(xx,2))
integer                   :: i,n1,n2
n1 = size(xx,1)
n2 = size(xx,2)
if (n1 < 1 .or. n2 < 1) return
yy(1,:) = xx(1,:)
do i=2,n1
   yy(i,:) = yy(i-1,:) + xx(i,:)
end do
end function cumul_sum_mat
!
function growing_mean_vec(xx) result(yy)
! compute the cumulative sum of xx(:)
real(kind=dp), intent(in) :: xx(:)
real(kind=dp)             :: yy(size(xx))
real(kind=dp)             :: ysum(size(xx))
integer                   :: i,n
n = size(xx)
if (n < 1) return
ysum(1) = xx(1)
yy(1)   = ysum(1)
do i=2,n
   ysum(i) = ysum(i-1) + xx(i)
   yy(i)   = ysum(i)/i
end do
end function growing_mean_vec
!
subroutine lag_data_vec(nlag,xx,yy)
! return in yy(:) xx(:) lagged by nlag elements. yy(1) = xx(1-nlag) etc.
integer      , intent(in)  :: nlag
real(kind=dp), intent(in)  :: xx(:) ! (nobs)
real(kind=dp), intent(out) :: yy(:) ! (nobs)
integer                    :: i,nobs
nobs = size(xx)
if (size(yy) /= nobs) then
   write (*,*) "in util_mod::lag_data_vec, size(xx), size(yy) =",size(xx),size(yy)," must be equal, STOPPING"
   stop
end if
if (nobs > 0) then
   forall (i=1:nobs) yy(i) = xx(min(nobs,max(1,i-nlag)))
end if
end subroutine lag_data_vec
!
subroutine lag_good_data_vec(nlag,xx,xgood,yy,ygood,ydefault)
integer      , intent(in)  :: nlag
real(kind=dp), intent(in)  :: xx(:)    ! (nobs)
logical      , intent(in)  :: xgood(:) ! (nobs)
logical      , intent(out) :: ygood(:) ! (nobs)
real(kind=dp), intent(out) :: yy(:)    ! (nobs)
real(kind=dp), intent(in), optional :: ydefault
integer                    :: i,j,nobs
call check_all_equal([size(xx),size(xgood),size(yy),size(ygood)], &
                     "in util_mod::lag_good_data_vec, size(xx), size(xgood), size(yy), size(ygood) =")
nobs = size(xx)
do i=1,nobs
   j = i + nlag
   if (j > 0 .and. j <= nobs) then
      yy(i)    = xx(j)
      ygood(i) = xgood(j)
   else
      ygood(i) = .false.
   end if
end do
if (present(ydefault)) then
   where (.not. ygood) yy = ydefault
end if
end subroutine lag_good_data_vec
!
subroutine lag_data_matrix(nlag,xx,yy)
! return in yy(:,:) the columns of xx(:,:) lagged by nlag elements. yy(1,:) = xx(1-nlag,:) etc.
integer      , intent(in)  :: nlag
real(kind=dp), intent(in)  :: xx(:,:) ! (nobs,ncol)
real(kind=dp), intent(out) :: yy(:,:) ! (nobs,ncol)
integer                    :: i,nobs
nobs = size(xx,1)
if (size(yy,1) /= nobs .or. size(xx,2) /= size(yy,2)) then
   write (*,*) "in util_mod::lag_data_matrix, shape(xx)=",shape(xx)," shape(yy)=",shape(yy), &
               " must have same dimensions, STOPPING"
   stop
end if
if (nobs > 0) then
   forall (i=1:nobs) yy(i,:) = xx(min(nobs,max(1,i-nlag)),:)
end if
end subroutine lag_data_matrix
!
function lag_matrix_vec(nlags,xx) result(xmat)
! return a matrix of lagged values of a vector, with the 1st-lagged vector in column 1,
! the 2nd-lagged vector in column 2, etc.
real(kind=dp), intent(in) :: xx(:)  ! vector to be lagged
integer      , intent(in) :: nlags
real(kind=dp)             :: xmat(size(xx)-nlags,nlags)
integer                   :: i,i1,iadd
iadd = size(xx) - nlags - 1
do i=1,nlags
   i1 = 1+nlags-i
   xmat(:,i) = xx(i1:i1+iadd)
end do
end function lag_matrix_vec
!
function lag_matrix_mat(nlags,xx) result(xmat)
! return a matrix of lagged values of a matrix, with the 1st-lagged vector in column 1,
! the 2nd-lagged vector in column 2, etc.
real(kind=dp), intent(in) :: xx(:,:)  ! matrix to be lagged
integer      , intent(in) :: nlags
real(kind=dp)             :: xmat(size(xx,1)-nlags,nlags*size(xx,2))
integer                   :: i,i1,iadd,j1,ncol
iadd = size(xx,1) - nlags - 1
ncol = size(xx,2)
! print*,"in lag_matrix_mat, iadd, nlags, shape(xx) =",iadd,nlags,shape(xx)," shape(xmat)=",shape(xmat) !! debug
do i=1,nlags
   i1                   = 1+nlags-i
   j1                   = 1 + (i-1)*ncol
   xmat(:,j1:j1+ncol-1) = xx(i1:i1+iadd,:)
end do
end function lag_matrix_mat
!
function matrix_row_col(nrow,ncol) result(xmat)
integer, intent(in) :: nrow,ncol
real(kind=dp) :: xmat(nrow,ncol)
xmat = 0.0_dp
end function matrix_row_col
!
function matrix_from_vec(xvec) result(xmat)
! convert a vector of N elements to an Nx1 matrix
real(kind=dp), intent(in) :: xvec(:)
real(kind=dp)             :: xmat(size(xvec),1)
xmat(:,1) = xvec
end function matrix_from_vec
!
function matrix_reshape(xvec,ncol) result(xmat)
! convert a vector of N elements to an ncol column matrix
real(kind=dp), intent(in) :: xvec(:)
integer      , intent(in) :: ncol
real(kind=dp)             :: xmat(size(xvec)/ncol,ncol)
integer                   :: icol,nrows
character (len=*), parameter :: msg=mod_str // "matrix_reshape, "
nrows = size(xvec)/ncol
if (ncol < 1 .or. size(xvec) /= nrows*ncol) then
   write (*,*) msg,"size(xvec), ncol, nrows =",size(xvec),ncol,nrows," need ncol > 0, size(xvec) = ncol*nrows"
   stop
end if
forall (icol=1:ncol) xmat(:,icol) = xvec(1+(icol-1)*nrows:icol*nrows)
end function matrix_reshape
!
function vector(xmat) result(xvec)
! convert a matrix to a vector
real(kind=dp), intent(in) :: xmat(:,:)
real(kind=dp)             :: xvec(size(xmat))
xvec = reshape(xmat,(/size(xmat)/))
end function vector
!
function tensor(xmat) result(xtens)
! convert a MxN matrix to an MxNx1 tensor
real(kind=dp), intent(in) :: xmat(:,:)
real(kind=dp)             :: xtens(size(xmat,1),size(xmat,2),1)
xtens(:,:,1) = xmat
end function tensor
!
function combine_col_real(x1,x2) result(xmat)
! combine real vectors into a matrix
real(kind=dp), intent(in) :: x1(:),x2(:)
real(kind=dp)             :: xmat(size(x1),2)
if (size(x1) == size(x2)) then
   xmat(:,1) = x1
   xmat(:,2) = x2
else
   write (*,*) mod_str,"size(x1), size(x2) =",size(x1),size(x2)," must be equal, stopPinG"
   stop
end if
end function combine_col_real
!
function combine_mat_col_real(x1,x2) result(xmat)
! combine matrices by column
real(kind=dp), intent(in) :: x1(:,:),x2(:,:)
real(kind=dp)             :: xmat(size(x1,1),size(x1,2)+size(x2,2))
integer                   :: ncol_1
ncol_1 = size(x1,2)
if (size(x1,1) == size(x2,1)) then
   xmat(:,:ncol_1)   = x1
   xmat(:,ncol_1+1:) = x2
else
   write (*,*) mod_str,"size(x1,1), size(x2,1) =",size(x1,1),size(x2,1)," must be equal, stoppinG"
   stop
end if
end function combine_mat_col_real
!
function combine_vec_mat_col_real(x1,x2) result(xmat)
! prepend a vector to the first column of a matrix
real(kind=dp), intent(in) :: x1(:),x2(:,:)
real(kind=dp)             :: xmat(size(x1,1),1+size(x2,2))
call assert_equal("in combine_vec_mat_col_real, size(x1), size(x2,1) =",size(x1),size(x2,1))
xmat = cbind(matrix(x1),x2)
end function combine_vec_mat_col_real
!
function combine_mat_vec_col_real(x1,x2) result(xmat)
! append a vector to the first column of a matrix
real(kind=dp), intent(in) :: x1(:,:),x2(:)
real(kind=dp)             :: xmat(size(x1,1),1+size(x1,2))
call assert_equal("in combine_mat_vec_col_real, size(x1,1), size(x2) =",size(x1,1),size(x2))
! print*,"shape(x1)=",shape(x1)," shape(x2)=",shape(x2) !! debug
xmat = cbind(x1,matrix(x2))
end function combine_mat_vec_col_real
!
function combine_col_int(x1,x2) result(xmat)
! combine real vectors into a matrix
integer, intent(in) :: x1(:),x2(:)
integer             :: xmat(size(x1),2)
if (size(x1) == size(x2)) then
   xmat(:,1) = x1
   xmat(:,2) = x2
else
   write (*,*) mod_str,"size(x1), size(x2) =",size(x1),size(x2)," must be equal, stoppinG"
   stop
end if
end function combine_col_int
!
function prepend_col(x1,x2) result(xmat)
real(kind=dp), intent(in) :: x1(:),x2(:,:)
real(kind=dp)             :: xmat(size(x1),size(x2,2)+1)
if (size(x1) == size(x2,1)) then
   xmat(:,1)  = x1
   xmat(:,2:) = x2
else
   write (*,*) "error in prepend_col"
   stop
end if
end function prepend_col
!
function append_col_vec_mat_real(x1,x2) result(xmat)
real(kind=dp), intent(in) :: x1(:),x2(:,:)
real(kind=dp)             :: xmat(size(x1),size(x2,2)+1)
if (size(x1) == size(x2,1)) then
   xmat(:,1)  = x1
   xmat(:,2:) = x2
else
   write (*,*) "error in append_col"
   return
end if
end function append_col_vec_mat_real
!
function append_col_mat_vec_real(x1,x2) result(xmat)
real(kind=dp), intent(in) :: x1(:,:),x2(:)
real(kind=dp)             :: xmat(size(x2),size(x1,2)+1)
integer                   :: ncol_x1
ncol_x1 = size(x1,2)
if (size(x1,1) == size(x2)) then
   xmat(:,:ncol_x1)  = x1
   xmat(:,ncol_x1+1) = x2
else
   write (*,*) "shape(x1)=",shape(x1)," shape(x2)=",shape(x2)
   write (*,*) "error in append_col_vec_mat_real, RETURNING"
   return
end if
end function append_col_mat_vec_real
!
function combine_mat(x1,x2) result(xmat)
real(kind=dp), intent(in) :: x1(:,:),x2(:,:)
real(kind=dp)             :: xmat(size(x1,1),size(x1,2),2)
if (size(x1,1) == size(x2,1) .and. size(x1,2) == size(x2,2)) then
   xmat(:,:,1) = x1
   xmat(:,:,2) = x2
else
   write (*,*) "error in combine_mat"
   return
end if
end function combine_mat
!
function combine_vec_mat_real(xvec,xmat,idim,position) result(ymat)
! augment matrix xmat(:,:) by vector xvec(:) by adding either a row or column, at either the beginning or the end
real(kind=dp), intent(in) :: xvec(:)    ! (n)
real(kind=dp), intent(in) :: xmat(:,:)  ! (n1,n2)
integer      , intent(in) :: idim
character (len=*), intent(in) :: position
real(kind=dp), allocatable :: ymat(:,:)
integer :: n,n1,n2
character (len=*), parameter :: msg = mod_str // "combine_vec_mat, "
n   = size(xvec)
n1  = size(xmat,1)
n2  = size(xmat,2)
if (idim < 1 .and. idim > 2 .and. position /= "before" .and. position /= "after") then
   call set_alloc(xmat,ymat)
   return
end if
if (idim == 1) then ! add another row
   call assert(n == n2,msg // "size(xvec) /= size(xmat,2)",stop_error=.true.)
   allocate (ymat(n1+1,n2))
   if (position == "before") then
      ymat(1,:)  = xvec
      ymat(2:,:) = xmat
   else
      ymat(:n1,:) = xmat
      ymat(n1+1,:) = xvec
   end if
else ! add another column
   call assert(n == n1,msg // "size(xvec) /= size(xmat,1)",stop_error=.true.)
   allocate (ymat(n1,n2+1))
   if (position == "before") then
      ymat(:,1)    = xvec
      ymat(:,2:)   = xmat
   else
      ymat(:,:n2)  = xmat
      ymat(:,n2+1) = xvec
   end if
end if
end function combine_vec_mat_real
!
function combine_mat_tensor_real(xmat,xtens,idim,position) result(ytens)
! augment tensor xtens(:,:) by matrix xmat(:) along dimension idim
real(kind=dp)    , intent(in)           ::  xmat(:,:)    ! (m1,m2)
real(kind=dp)    , intent(in)           :: xtens(:,:,:)  ! (n1,n2,n3)
integer          , intent(in)           :: idim
character (len=*), intent(in), optional :: position
real(kind=dp)    , allocatable          :: ytens(:,:,:)
integer                                 :: n1,n2,n3
character (len=*), parameter            :: msg = mod_str // "combine_vec_mat, "
character (len=20)                      :: position_
position_ = default("before",position)
n1  = size(xtens,1)
n2  = size(xtens,2)
n3  = size(xtens,3)
call assert(idim>0 .and. idim<=3,msg // "need 1 <= idim <= 3",stop_error=.true.)
call assert(position_=="before" .or. position_ == "after","need position = 'before' or 'after'",stop_error=.true.)
if (any(shape(xmat) /= exclude(shape(xtens),iexcl=[idim]))) then
   write (*,*) msg,"idim =",idim," shape(xmat)=",shape(xmat)," shape(xtens)=",shape(xtens), &
               " cannot combine matrix with tensor along specified dimension"
   stop
end if
if (idim == 1) then ! add another row
   allocate (ytens(n1+1,n2,n3))
   if (position_ == "before") then
      ytens(1 ,:,:) = xmat
      ytens(2:,:,:) = xtens
   else
      ytens(n1+1,:,:) = xmat
      ytens(:n1 ,:,:) = xtens
   end if
else if (idim == 2) then ! add another column
   allocate (ytens(n1,n2+1,n3))
   if (position_ == "before") then
      ytens(:,1   ,:) = xmat
      ytens(:,2:  ,:) = xtens
   else
      ytens(:,n2+1,:) = xmat
      ytens(:,:n2 ,:) = xtens
   end if
else
   allocate (ytens(n1,n2,n3+1))
   if (position_ == "before") then
      ytens(:,:,1)  = xmat
      ytens(:,:,2:) = xtens
   else
      ytens(:,:,n3+1) = xmat
      ytens(:,:,:n3)  = xtens
   end if
end if
end function combine_mat_tensor_real
!
function combine_tensors_real(aa,bb,idim) result(ytens)
! combine tensors aa and bb along dimension idim
real(kind=dp)    , intent(in)           :: aa(:,:,:)  ! (m1,m2,m3)
real(kind=dp)    , intent(in)           :: bb(:,:,:)  ! (n1,n2,n3)
integer          , intent(in)           :: idim
real(kind=dp)    , allocatable          :: ytens(:,:,:)
integer                                 :: m1,m2,m3,n1,n2,n3
character (len=*), parameter            :: msg = mod_str // "combine_tensors_real, "
m1  = size(aa,1)
m2  = size(aa,2)
m3  = size(aa,3)
n1  = size(bb,1)
n2  = size(bb,2)
n3  = size(bb,3)
call assert(idim>0 .and. idim<=3,msg // "need 1 <= idim <= 3",stop_error=.true.)
if (any(exclude(shape(aa),iexcl=[idim]) /= exclude(shape(bb),iexcl=[idim]))) then
   write (*,*) msg,"idim =",idim," shape(aa)=",shape(aa)," shape(bb)=",shape(bb), &
               " cannot combine matrix with tensor along specified dimension"
   stop
end if
if (idim == 1) then
   allocate (ytens(m1+n1,n2,n3))
   ytens(:m1  ,:,:) = aa
   ytens(m1+1:,:,:) = bb
else if (idim == 2) then
   allocate (ytens(n1,m2+n2,n3))
   ytens(:,:m2  ,:) = aa
   ytens(:,m2+1:,:) = bb
else
   allocate (ytens(n1,n2,m3+n3))
   ytens(:,:,:m3  )  = aa
   ytens(:,:,m3+1:) = bb
end if
end function combine_tensors_real
!
elemental function int_tf(tf) result(i)
! convert logical variable to integer
logical, intent(in) :: tf
integer             :: i
if (tf) then
   i = itrue
else
   i = ifalse
end if
end function int_tf
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
elemental function str_int(i,ndigits,prefix) result(ch)
! convert integer to character
integer         ,intent(in)           :: i
integer         ,intent(in), optional :: ndigits
character(len=*),intent(in), optional :: prefix
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
if (present(prefix)) ch = trim(prefix) // trim(ch)
end function str_int
!
elemental function str_logical(tf) result(ch)
! convert logical to character
logical,intent(in) :: tf
character(len=5)   :: ch
ch = merge("TRUE ","FALSE",tf)
end function str_logical
!
subroutine set_offdiagonal(xod,xx)
! set off-diagonal elements of square matrix x(:,:) to xod
real(kind=dp), intent(in)     :: xod
real(kind=dp), intent(in out) :: xx(:,:)
integer                       :: i,j,n
n = size(xx,1)
if (size(xx,2) /= n) return
do i=1,n
   do j=1,n
      if (i /= j) xx(i,j) = xod
   end do
end do
end subroutine set_offdiagonal
!
pure function diag_matrix(vec) result(mat)
! return a diagonal matrix with elements from vec(:)
real(kind=dp), intent(in) :: vec(:)
real(kind=dp)             :: mat(size(vec),size(vec))
integer                   :: i
mat = 0.0_dp
do i=1,size(vec)
   mat(i,i) = vec(i)
end do
end function diag_matrix
!
pure function above_diag(xx) result(yy)
! return in yy(:) the above-diagonal elements of xx(:,:)
real(kind=dp), intent(in) :: xx(:,:)
real(kind=dp)             :: yy((size(xx,1)*size(xx,1)-size(xx,1))/2)
integer                   :: i,j,iy,n1,n2
n1 = size(xx,1)
n2 = size(xx,2)
iy = 0
do i=1,n1
   do j=i+1,n2
      iy = iy+1
      yy(iy) = xx(i,j)
      if (iy == size(yy)) return
   end do
end do
end function above_diag
!
pure function diag(xx) result(xdiag)
! extract the diagonal of a matrix
real(kind=dp), intent(in) :: xx(:,:)
real(kind=dp)             :: xdiag(size(xx,1))
integer                   :: i,n1,n2
n1 = size(xx,1)
n2 = size(xx,2)
forall (i=1:min(n1,n2)) xdiag(i) = xx(i,i)
end function diag
!
pure function offdiag(xx) result(xod)
! extract the off-diagonal of a matrix, in column major order
real(kind=dp), intent(in) :: xx(:,:)
real(kind=dp)             :: xod(size(xx,1)*(size(xx,1)-1))
integer                   :: i1,i2,i,n1,n2
n1 = size(xx,1)
n2 = size(xx,2)
do i2=1,n2
   do i1=1,n1
      if (i1 /= i2) then
         i = i + 1
         if (i > size(xod)) return
         xod(i) = xx(i1,i2)
      end if
   end do
end do
end function offdiag
!
pure function diag_3d(xx) result(xdiag)
! stack the diagonals of matrices xx(:,:,i), i = 1, num_matrices
real(kind=dp), intent(in) :: xx(:,:,:)
real(kind=dp)             :: xdiag(size(xx,1)*size(xx,3))
integer                   :: i3,n1,n3,j
n1 = size(xx,1)
n3 = size(xx,3)
do i3=1,n3
   j = 1 + (i3-1)*n1
   xdiag(j:j+n1-1) = diag(xx(:,:,i3))
end do
end function diag_3d
!
subroutine get_words_alloc(in_unit,words)
! allocate and read a vector of words
! the line of text contains the number of words followed by the words
integer          , intent(in)  :: in_unit
character (len=10000)          :: text
character (len=*), allocatable, intent(out) :: words(:)
integer                        :: ierr,nw
read (in_unit,"(a)",iostat=ierr) text
read (text,*) nw
nw = max(nw,0)
allocate (words(nw))
read (text,*) nw,words
end subroutine get_words_alloc
!
subroutine get_text_int(in_unit,text,ii)
! read integer ii from text
integer          , intent(in)  :: in_unit
character (len=*), intent(out) :: text
integer          , intent(out) :: ii
read (in_unit,"(a)") text
read (text,*) ii
end subroutine get_text_int
!
pure function polynom_value_scalar(xx,xpoly) result(yy)
real(kind=dp), intent(in) :: xx
real(kind=dp), intent(in) :: xpoly(:) ! polynomial coefficients, starting with the lowest order (constant term)
real(kind=dp)             :: yy
real(kind=dp)             :: xpow
integer                   :: i,ndeg
ndeg = size(xpoly) - 1
yy   = 0.0_dp
xpow = 1.0_dp
do i=1,ndeg+1
   yy = yy + xpoly(i)*xpow
   xpow = xpow * xx
end do
end function polynom_value_scalar
!
pure function polynom_value_vec(xx,xpoly) result(yy)
real(kind=dp), intent(in) :: xx(:)
real(kind=dp), intent(in) :: xpoly(:) ! polynomial coefficients, starting with the lowest order (constant term)
real(kind=dp)             :: yy(size(xx))
integer                   :: i
forall (i=1:size(xx)) yy(i) = polynom_value_scalar(xx(i),xpoly)
end function polynom_value_vec
!
pure function first_pos_ge_int(ivec,ival) result(ipos)
! return the position of the first element of ivec(:) that is >= ival,
! n+1 if none are >= ival
integer, intent(in) :: ivec(:),ival
integer             :: ipos
integer             :: i,n
n    = size(ivec)
ipos = n+1
do i=1,n
   if (ivec(i) >= ival) then
      ipos = i
      exit
   end if
end do
end function first_pos_ge_int
!
pure function first_pos_ge_int_vec(ivec,ival) result(ipos)
! return the position of the first element of ivec(:) that is >= ival,
! n+1 if none are >= ival
integer, intent(in) :: ivec(:),ival(:)
integer             :: ipos(size(ival))
integer             :: i,j,n
n    = size(ivec)
ipos = n+1
do j=1,size(ival)
   do i=1,n
      if (ivec(i) >= ival(j)) then
         ipos(j) = i
         exit
      end if
   end do
end do
end function first_pos_ge_int_vec
!
pure function first_pos_ge_real(xvec,xval) result(ipos)
! return the position of the first element of xvec(:) that is >= xval,
! n+1 if none are >= xval
real(kind=dp), intent(in) :: xvec(:),xval
integer                   :: ipos
integer                   :: i,n
n    = size(xvec)
ipos = n+1
do i=1,n
   if (xvec(i) >= xval) then
      ipos = i
      exit
   end if
end do
end function first_pos_ge_real
!
pure function last_pos_le_int_vec(ivec,ival) result(ipos)
! return the position of the last element of ivec(:) that is <= ival,
! 0 if none are >=
integer, intent(in) :: ivec(:),ival(:)
integer             :: ipos(size(ival))
integer             :: i,j,n
n    = size(ivec)
ipos = 0
do j=1,size(ival)
   do i=n,1,-1
      if (ivec(i) <= ival(j)) then
         ipos(j) = i
         exit
      end if
   end do
end do
end function last_pos_le_int_vec
!
pure function last_pos_le_int(ivec,ival) result(ipos)
! return the position of the last element of ivec(:) that is <= ival,
! 0 if none are >=
integer, intent(in) :: ivec(:),ival
integer             :: ipos
integer             :: i,n
n  = size(ivec)
ipos = 0
do i=n,1,-1
   if (ivec(i) <= ival) then
      ipos = i
      exit
   end if
end do
end function last_pos_le_int
!
pure function last_pos_le_real(xvec,xval) result(ipos)
! return the position of the last element of xvec(:) that is <= xval,
! 0 if none are >=
real(kind=dp), intent(in) :: xvec(:),xval
integer                   :: ipos
integer                   :: i,n
n    = size(xvec)
ipos = 0
do i=n,1,-1
   if (xvec(i) <= xval) then
      ipos = i
      exit
   end if
end do
end function last_pos_le_real
!
function integer_label(i,fmt_i) result(ilabel)
! return integer labels from i1 to i2 with format fmt_i
integer          , intent(in)           :: i
character (len=*), intent(in), optional :: fmt_i
character (len=20)                      :: ilabel
character (len=20)                      :: fmt_i_
call set_optional(fmt_i_,xdef="(i0)",xopt=fmt_i)
write (ilabel,fmt_i_) i
end function integer_label
!
function integer_labels(i1,i2,fmt_i) result(ilabel)
! return integer labels from i1 to i2 with format fmt_i
integer          , intent(in)           :: i1,i2
character (len=*), intent(in), optional :: fmt_i
character (len=20)                      :: ilabel(i2-i1+1)
character (len=20)                      :: fmt_i_
integer                                 :: i,n
n = i2 - i1 + 1
call set_optional(fmt_i_,xdef="(i0)",xopt=fmt_i)
do i=1,n
   write (ilabel(i),fmt_i_) i1 + i - 1
end do
end function integer_labels
!
function conform_real_3d(xx,yy) result(tf)
! check that two matrices are conformable
real(kind=dp), intent(in) :: xx(:,:,:),yy(:,:,:)
logical                   :: tf
tf = all(shape(xx) == shape(yy))
end function conform_real_3d
!
function conform_real_2d_3d(yy,xx,dim) result(tf)
real(kind=dp), intent(in) :: xx(:,:,:),yy(:,:)
logical                   :: tf
integer      , intent(in) :: dim(:)
integer      , parameter  :: rank_x = 2
integer                   :: i
if (size(dim) /= rank_x .or. any(dim > 3) .or. any(dim < 1)) then
   tf = .false.
   return
end if
tf = .true.
do i=1,rank_x
   if (size(xx,dim(i)) /= size(yy,i)) then
      tf = .false.
      exit
   end if
end do
end function conform_real_2d_3d
!
function conform_real_2d(xx,yy) result(tf)
! check that two matrices are conformable
real(kind=dp), intent(in)           :: xx(:,:)
real(kind=dp), intent(in), optional :: yy(:,:)
logical                             :: tf
if (present(yy)) then
   tf = all(shape(xx) == shape(yy))
else
   tf = .true.
end if
end function conform_real_2d
!
function conform_real_1d(xx,yy) result(tf)
! check that two vectors are conformable
real(kind=dp), intent(in) :: xx(:),yy(:)
logical                   :: tf
tf = all(shape(xx) == shape(yy))
end function conform_real_1d
!
function conform_optional_real_1d(xx,yy) result(tf)
! check that two vectors are conformable if they are present
real(kind=dp), intent(in)           :: xx(:)
real(kind=dp), intent(in), optional :: yy(:)
logical                             :: tf
if (present(yy)) then
   tf = size(xx) == size(yy)
else
   tf = .true.
end if
end function conform_optional_real_1d
!
function conform_optional_real_2d(xx,yy) result(tf)
! check that two matrices are conformable if they are present
real(kind=dp), intent(in)           :: xx(:,:)
real(kind=dp), intent(in), optional :: yy(:,:)
logical                             :: tf
if (present(yy)) then
   tf = all(shape(xx) == shape(yy))
else
   tf = .true.
end if
end function conform_optional_real_2d
!
function positions(xmask,i1,i2) result(ipos)
! return integer vector ipos(:) such that corresponding elements of jvec are between jmin and jmax
logical      , intent(in)           :: xmask(:)
integer      , intent(in), optional :: i1,i2
integer      , allocatable          :: ipos(:)
integer      , allocatable          :: ivec(:)
integer                             :: i,i1_,i2_,n
n   = size(xmask)
i1_ = default(1,i1)
i2_ = default(n,i2)
call set_alloc([(i,i=1,n)],ivec)
call set_alloc(pack(ivec,xmask .and. ivec>=i1_ .and. ivec<=i2_),ipos)
end function positions
!
subroutine select_tensor_real(iuse,xx,idim)
! select elements in positions iuse along dimension idim
integer      , intent(in)                  :: iuse(:)
real(kind=dp), intent(in out), allocatable :: xx(:,:,:)
integer      , intent(in)    , optional    :: idim
integer                                    :: idim_
character (len=*), parameter               :: msg=mod_str//"select_tensor_real, "
call set_optional(idim_,1,idim)
select case (idim_)
   case (1); call set_alloc((xx(iuse,:,:)),xx)
   case (2); call set_alloc((xx(:,iuse,:)),xx)
   case (3); call set_alloc((xx(:,:,iuse)),xx)
   case default
      write (*,*) msg,"idim_ =",idim_," should be between 1 and 3, stopPinG"
      stop
end select
end subroutine select_tensor_real
!
subroutine select_vec_character(iuse,xx,idim)
! select elements in positions iuse along dimension idim
integer          , intent(in)                  :: iuse(:)
integer          , intent(in)    , optional    :: idim
character (len=*), intent(in out), allocatable :: xx(:)
character (len=*), parameter                   :: msg=mod_str//"select_vec_character, "
integer                                        :: idim_
call set_optional(idim_,1,idim)
if (idim_ /= 1) then
   write (*,*) msg,"idim_ =",idim_," must equal 1, stoppinG"
   stop
end if
call set_alloc((xx(iuse)),xx)
end subroutine select_vec_character
!
subroutine match_char(xgood,xx,iuse)
! return in iuse(:) the positions in xx(:) of elements that are found in xgood(:)
character (len=*), intent(in)               :: xgood(:)
character (len=*), intent(in)               :: xx(:)
integer          , intent(out), allocatable :: iuse(:)
logical                                     :: xmask(size(xx))
integer                                     :: i,j,n,nuse
n = size(xx)
forall (i=1:n) xmask(i) = any(xgood == xx(i))
nuse = count(xmask)
allocate (iuse(nuse))
j = 0
do i=1,n
   if (xmask(i)) then
      j = j + 1
      iuse(j) = i
      if (j == nuse) exit
   end if
end do
end subroutine match_char
!
subroutine select_match_vec_char(xgood,xx,xuse)
! return in xuse the elements in xx(:) that are in xgood(:)
character (len=*), intent(in)               :: xgood(:),xx(:)
character (len=*), intent(out), allocatable :: xuse(:)
integer                       , allocatable :: iuse(:)
call match_char(xgood,xx,iuse)
call set_alloc(xx(iuse),xuse)
end subroutine select_match_vec_char
!
subroutine set_alloc_real_vec(xx,yy,nsize)
! for real vectors xx(:) and yy(:), allocate yy and set it to xx
real(kind=dp), intent(in)               :: xx(:)
real(kind=dp), intent(out), allocatable :: yy(:)
integer      , intent(out), optional    :: nsize
integer                                 :: ni
ni = size(xx)
allocate (yy(ni))
yy = xx
if (present(nsize)) nsize = ni
end subroutine set_alloc_real_vec
!
pure recursive subroutine set_alloc_int_vec(ii,jj,jmin,jmax)
! for integer vectors xx(:) and yy(:), allocate yy and set it to xx
! keep only values between jmin and jmax, inclusive, if they are present
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
pure recursive subroutine set_alloc_i64_vec(ii,jj,jmin,jmax)
! for integer vectors xx(:) and yy(:), allocate yy and set it to xx
integer(kind=i64), intent(in)               :: ii(:)
integer(kind=i64), intent(out), allocatable :: jj(:)
integer(kind=i64), intent(in) , optional    :: jmin,jmax
integer(kind=i64)                           :: ni
if (present(jmin) .and. present(jmax)) then
   call set_alloc(pack(ii,ii >= jmin .and. ii <= jmax),jj)
else if (present(jmin)) then
   call set_alloc(pack(ii,ii >= jmin),jj)
else if (present(jmax)) then
   call set_alloc(pack(ii,ii <= jmax),jj)
else
   ni = size(ii)
   allocate (jj(ni))
   jj = ii
end if
end subroutine set_alloc_i64_vec
!
subroutine set_alloc_logical_vec(xx,yy)
logical, intent(in) :: xx(:)
logical, intent(out), allocatable :: yy(:)
integer             :: n
n = size(xx)
allocate (yy(n))
yy = xx
end subroutine set_alloc_logical_vec
!
subroutine set_alloc_logical_matrix(xx,yy)
logical, intent(in)               :: xx(:,:)
logical, intent(out), allocatable :: yy(:,:)
allocate (yy(size(xx,1),size(xx,2)))
yy = xx
end subroutine set_alloc_logical_matrix
!
subroutine set_alloc_logical_tensor(xx,yy)
logical, intent(in)               :: xx(:,:,:)
logical, intent(out), allocatable :: yy(:,:,:)
allocate (yy(size(xx,1),size(xx,2),size(xx,3)))
yy = xx
end subroutine set_alloc_logical_tensor
!
subroutine set_alloc_integer_matrix(xx,yy)
! for integer matrices xx(:,:) and yy(:,:), allocate yy and set it to xx
integer , intent(in)               :: xx(:,:)
integer , intent(out), allocatable :: yy(:,:)
allocate (yy(size(xx,1),size(xx,2)))
yy = xx
end subroutine set_alloc_integer_matrix
!
subroutine set_alloc_real_matrix(xx,yy)
! for real matrices xx(:,:) and yy(:,:), allocate yy and set it to xx
real(kind=dp) , intent(in)               :: xx(:,:)
real(kind=dp) , intent(out), allocatable :: yy(:,:)
allocate (yy(size(xx,1),size(xx,2)))
yy = xx
end subroutine set_alloc_real_matrix
!
subroutine set_alloc_real_tensor(xx,yy)
! for real tensors xx(:,:,:) and yy(:,:,:), allocate yy and set it to xx
real(kind=dp) , intent(in)               :: xx(:,:,:)
real(kind=dp) , intent(out), allocatable :: yy(:,:,:)
allocate (yy(size(xx,1),size(xx,2),size(xx,3)))
yy = xx
end subroutine set_alloc_real_tensor
!
pure subroutine set_alloc_character_vec(xx,yy,nsize)
! for character arrays xx(:) and yy(:), allocate yy and set it to xx
character (len=*) , intent(in)               :: xx(:)
character (len=*) , intent(out), allocatable :: yy(:)
integer           , intent(out), optional    :: nsize
allocate (yy(size(xx)))
yy = xx
if (present(nsize)) nsize = size(yy)
end subroutine set_alloc_character_vec
!
subroutine set_alloc_character_mat(xx,yy)
! for character arrays xx(:,:) and yy(:,:), allocate yy and set it to xx
character (len=*) , intent(in)               :: xx(:,:)
character (len=*) , intent(out), allocatable :: yy(:,:)
allocate (yy(size(xx,1),size(xx,2)))
yy = xx
end subroutine set_alloc_character_mat
!
subroutine add_uniform_noise(xx,ran_scale)
! add uniform noise in the range (-ran_scale/2, ran_scale/2) with 1.0_dp the default_value of ran_scale
real(kind=dp), intent(in out) :: xx(:)
real(kind=dp), intent(in), optional :: ran_scale
xx = xx + default(1.0_dp,ran_scale)*(ran_uni(size(xx))-0.5_dp)
end subroutine add_uniform_noise
!
function runif_vec(n,xmean) result(xran)
! generate vector of uniform random variates
integer      , intent(in)           :: n
real(kind=dp), intent(in), optional :: xmean
real(kind=dp)                       :: xran(n)
call random_number(xran)
if (present(xmean)) xran = xran + xmean - 0.5_dp
end function runif_vec
!
function num_unique_char(xx) result(nq)
character (len=*), intent(in) :: xx(:)
integer                       :: nq
integer                       :: ipos(size(xx))
call unique_char(xx,ipos,nq)
end function num_unique_char
!
function unique_vec_int(ivec) result(jvec)
! return in jvec the unique values of ivec(:)
integer, intent(in)  :: ivec(:)
integer, allocatable :: jvec(:)
integer              :: n,nuniq
integer              :: ipos(size(ivec))
n = size(ivec)
! print*,"ivec=",ivec !! debug
call unique_int(ivec,ipos,nuniq)
! print*,"nuniq=",nuniq !! debug
if (nuniq > 0) then
   call set_alloc(ivec(ipos(:nuniq)),jvec)
else
   allocate (jvec(0))
end if
end function unique_vec_int
!
function unique_char_int(ivec) result(jvec)
! return in jvec the unique values of ivec(:)
character (len=*), intent(in)          :: ivec(:)
character (len=len(ivec)), allocatable :: jvec(:)
integer                                :: n,nuniq
integer                                :: ipos(size(ivec))
n = size(ivec)
! print*,"ivec=",ivec !! debug
call unique_char(ivec,ipos,nuniq)
! print*,"nuniq=",nuniq !! debug
if (nuniq > 0) then
   call set_alloc(ivec(ipos(:nuniq)),jvec)
else
   allocate (jvec(0))
end if
end function unique_char_int
!
subroutine unique_int(ivec,ipos,nuniq)
! return in ipos(1:nuniq) the positions of the unique elements of ivec(:)
integer, intent(in)  :: ivec(:)
integer, intent(out) :: ipos(:) ! positions of unique integers in ivec
integer, intent(out) :: nuniq   ! # of unique integers in ivec
integer              :: i,n
n = size(ivec)
if (size(ipos) /= n) then
   write (*,*) mod_str//"unique_int, size(ivec), size(ipos) =",n,size(ipos)," should be equal, stopPinG"
   stop
end if
if (n == 0) then
   nuniq = 0
   return
end if
ipos(1) = 1
nuniq   = 1
do i=2,n
   if (all(ivec(i) /= ivec(ipos(:nuniq)))) then
      nuniq = nuniq + 1
      ipos(nuniq) = i
   end if
end do
end subroutine unique_int
!
subroutine unique_real(xx,ipos,nuniq,tol)
! return in ipos(1:nuniq) the positions of the unique elements of xx(:)
real(kind=dp), intent(in)  :: xx(:)
integer      , intent(out) :: ipos(:) ! positions of unique integers in xx
integer      , intent(out) :: nuniq   ! # of unique integers in xx
real(kind=dp), intent(in), optional :: tol ! error tolerance
integer                    :: i,n
n = size(xx)
ipos = 0
if (size(ipos) /= n) then
   write (*,*) mod_str//"unique_int, size(xx), size(ipos) =",n,size(ipos)," should be equal, stopPinG"
   stop
end if
if (n == 0) then
   nuniq = 0
   return
end if
ipos(1) = 1
nuniq   = 1
do i=2,n
   if (all(abs(xx(i) - xx(ipos(:nuniq))) > default(1.0e-10_dp,tol))) then
!   if (all(abs(xx(i) - xx(ipos(:nuniq)) > 1.0d-10 )))) then
      nuniq = nuniq + 1
      ipos(nuniq) = i
   end if
end do
end subroutine unique_real
!
subroutine unique_positions_int(ivec,ipos,freq)
! return in ipos the positions of the first occurrences of the unique elements of ivec(:)
integer, intent(in)                         :: ivec(:)
integer, intent(out), allocatable           :: ipos(:) ! positions of unique integers in ivec
integer, intent(out), optional, allocatable :: freq(:)
integer                                     :: i,n,nuniq
n = size(ivec)
allocate (ipos(n))
if (n == 0) return
ipos(1) = 1
nuniq   = 1
do i=2,n
   if (all(ivec(i) /= ivec(ipos(:nuniq)))) then
      nuniq = nuniq + 1
      ipos(nuniq) = i
   end if
end do
call set_alloc((ipos(:nuniq)),ipos)
if (present(freq)) then
   allocate (freq(nuniq))
   forall (i=1:nuniq) freq(i) = count(ivec==ivec(ipos(i)))
end if
end subroutine unique_positions_int
!
function uniq_char(ivec) result(yy)
! return the unique values in ivec(:)
character (len=*)        , intent(in)  :: ivec(:)
character (len=len(ivec)), allocatable :: yy(:)
call unique_values_char(ivec,yy)
end function uniq_char
!
subroutine unique_values_char(ivec,uniq,i1,freq,igroup)
! return in uniq(:) the unique character values in ivec,
! in i1(:) the first positions where they are found, and
! in freq(:) their frequencies
character (len=*), intent(in)                         :: ivec(:) ! (n)
character (len=*), intent(out),           allocatable :: uniq(:)
integer          , intent(out), optional, allocatable :: i1(:)
integer          , intent(out), optional, allocatable :: freq(:)
integer          , intent(out), optional              :: igroup(:)
integer                                               :: i,ipos(size(ivec)),nuniq ! (n) positions of unique integers in ivec
call unique_char(ivec,ipos,nuniq)
if (nuniq > 0) then
   call set_alloc(ivec(ipos(:nuniq)),uniq)
else
   allocate (uniq(0))
end if
if (present(i1)) then
   if (nuniq > 0) then
      call set_alloc(ipos(:nuniq),i1)
   else
      allocate (i1(0))
   end if
end if
if (present(freq)) then
   allocate (freq(nuniq))
   do i=1,nuniq
      freq(i) = count(ivec==uniq(i))
   end do
end if
if (present(igroup)) then
   if (size(igroup) /= size(ivec)) then
      igroup = -1
      return
   else
      igroup = match_string(ivec,uniq)
   end if
end if
end subroutine unique_values_char
!
function uniq_int(ivec) result(yy)
! return the unique values in ivec(:)
integer, intent(in)  :: ivec(:)
integer, allocatable :: yy(:)
call unique_values_int(ivec,yy)
end function uniq_int
!
subroutine unique_values_int(ivec,uniq,i1,freq)
! return in uniq(:) the unique integer values in ivec
! and in i1(:) the first positions where they are found
integer          , intent(in)                         :: ivec(:) ! (n)
integer          , intent(out),           allocatable :: uniq(:)
integer          , intent(out), optional, allocatable :: i1(:)
integer          , intent(out), optional, allocatable :: freq(:)
integer                                               :: i,ipos(size(ivec)),nuniq ! (n) positions of unique integers in ivec
call unique(ivec,ipos,nuniq) ! output: ipos(:), nuniq
if (nuniq > 0) then
   call set_alloc(ivec(ipos(:nuniq)),uniq)
else
   allocate (uniq(0))
end if
if (present(i1)) then
   if (nuniq > 0) then
      call set_alloc(ipos(:nuniq),i1)
   else
      allocate (i1(0))
   end if
end if
if (present(freq)) then
   allocate (freq(nuniq))
   do i=1,nuniq
      freq(i) = count(ivec==uniq(i))
   end do
end if
end subroutine unique_values_int
!
subroutine unique_values_real(ivec,uniq,i1,freq,tol)
! return in uniq(:) the unique real values in ivec
! and in i1(:) the first positions where they are found
real(kind=dp)          , intent(in)                         :: ivec(:) ! (n)
real(kind=dp)          , intent(out),           allocatable :: uniq(:)
integer          , intent(out), optional, allocatable :: i1(:)
integer          , intent(out), optional, allocatable :: freq(:)
real(kind=dp)    , intent(in) , optional              :: tol ! error tolerance
integer                                               :: i,ipos(size(ivec)),nuniq ! (n) positions of unique integers in ivec
call unique(ivec,ipos,nuniq,tol)
if (nuniq > 0) then
   call set_alloc(ivec(ipos(:nuniq)),uniq)
else
   allocate (uniq(0))
end if
if (present(i1)) then
   if (nuniq > 0) then
      call set_alloc(ipos(:nuniq),i1)
   else
      allocate (i1(0))
   end if
end if
if (present(freq)) then
   allocate (freq(nuniq))
   do i=1,nuniq
      freq(i) = count(ivec==uniq(i))
   end do
end if
end subroutine unique_values_real
!
function uniq_real(ivec,tol) result(yy)
! return the unique values in ivec(:) up to tolerance tol
real(kind=dp), intent(in)  :: ivec(:)
real(kind=dp), intent(in), optional  :: tol
real(kind=dp), allocatable :: yy(:)
call unique_values_real(ivec,yy,tol=tol)
end function uniq_real
!
subroutine unique_values_positions_char(ivec,uniq,i1,i2)
! return in uniq(:) the unique character values in ivec
! and in i1(:) the first positions where they are found
character (len=*), intent(in)  :: ivec(:) ! (n)
character (len=*), intent(out), allocatable :: uniq(:)
integer, intent(out), allocatable  :: i1(:),i2(:)
integer :: i,ipos(size(ivec)),j,n,nuniq ! (n) positions of unique integers in ivec
n = size(ivec)
call unique_char(ivec,ipos,nuniq)
call set_alloc(ivec(ipos(:nuniq)),uniq)
call set_alloc(ipos(:nuniq),i1)
allocate (i2(nuniq))
i2 = n
do i=1,nuniq
   do j=i1(i)+1,n
      if (ivec(j) /= ivec(i1(i))) then
         i2(i) = j-1
         exit
      end if
   end do
end do
end subroutine unique_values_positions_char
!
subroutine unique_char(ivec,ipos,nuniq)
! return in ipos(1:nuniq) the positions of the unique elements of ivec(:)
character (len=*), intent(in)  :: ivec(:) ! (n)
integer, intent(out) :: ipos(:) ! (n) positions of unique integers in ivec
integer, intent(out) :: nuniq   ! # of unique integers in ivec
integer              :: i,n
n = size(ivec)
if (size(ipos) /= n) then
   write (*,*) mod_str//"unique_char, size(ivec), size(ipos) =",n,size(ipos)," should be equal, stopPinG"
   stop
end if
if (n == 0) return
ipos(1) = 1
nuniq   = 1
do i=2,n
   if (all(ivec(i) /= ivec(ipos(:nuniq)))) then
      nuniq = nuniq + 1
      ipos(nuniq) = i
   end if
end do
end subroutine unique_char
!
function in_row_int(ivec,imat) result(tf)
! return true if any row of imat(:,:) equals ivec(:)
integer, intent(in) :: ivec(:)
integer, intent(in) :: imat(:,:)
logical             :: tf
integer             :: i,nrows
tf    = .false.
nrows = size(imat,1)
if (size(ivec) /= size(imat,2)) return
do i=1,nrows
   tf = all(ivec == imat(i,:))
   if (tf) return
end do
end function in_row_int
!
! subroutine unique_rows_int(imat,ipos,nuniq)
! ! return in ipos(1:nuniq) the positions of the unique elements of ivec(:)
! integer, intent(in)  :: imat(:,:)
! integer, intent(out) :: ipos(:) ! positions of unique integers in ivec
! integer, intent(out) :: nuniq   ! # of unique integers in ivec
! integer              :: i,n
! n = size(imat,1)
! if (size(ipos) /= n) then
!    write (*,*) mod_str//"unique_int, size(imat,1), size(ipos) =",n,size(ipos)," should be equal, stopPinG"
!    stop
! end if
! if (n == 0) return
! ipos(1) = 1
! nuniq   = 1
! do i=2,n
!    if (in_row_int(imat(i,:),imat(ipos(:nuniq),:))) then
!       nuniq = nuniq + 1
!       ipos(nuniq) = i
!    end if
! end do
! end subroutine unique_rows_int
!
subroutine read_comments(iu,marker,echo,comments)
! read comments from a file, treating lines beginning with marker and followed by a space or newline to be comments
integer          , intent(in) :: iu
character (len=*), intent(in) :: marker
character (len=*), intent(out), allocatable, optional :: comments(:)
logical, intent(in), optional  :: echo
integer, parameter             :: max_comments = 100
character (len=1000)           :: lines(max_comments),word,file_name
integer                        :: i,ierr,nread
logical                        :: echo_
call set_optional(echo_,.false.,echo)
nread = max_comments
inquire (unit=iu,name=file_name)
if (echo_) write (*,*) "comments from file " // trim(file_name)
do i=1,max_comments
   read (iu,"(a)",iostat=ierr) lines(i)
   if (ierr /= 0) then
      nread = i-1
      exit
   end if
   read (lines(i),*) word
   if (word /= marker) then
      backspace (iu)
      nread = i-1
      exit
   end if
   if (echo_) write (*,*) trim(lines(i))
end do
if (present(comments)) then
   allocate (comments(nread))
   comments = lines(1:nread)
end if
if (echo_) write (*,*)
end subroutine read_comments
!
elemental function num_fields(text,delim,xstrip) result(n)
! find the number of fields when splitting text using delimiter delim
! if xstrip is .true. and presen, strip a delimiter appearing at the end
character (len=*), intent(in) :: text
character (len=1), intent(in), optional :: delim
logical          , intent(in), optional :: xstrip
character (len=1)                       :: delim_
logical                                 :: xstrip_
integer                                 :: n
xstrip_ = default(.true.,xstrip)
delim_ = default(",",delim)
if (xstrip_) then
   n = 1 + num_matching_char(strip(text,delim_),delim_)
else
   n = 1 + num_matching_char(text,delim_)
end if
end function num_fields
!
elemental function num_matching_char(text,char_match) result(nc)
! return the number of characters of text matching char_match
character (len=*), intent(in) :: text
character (len=*), intent(in) :: char_match
integer                       :: i,nc
if (len(char_match) /= 1) then
   nc = -1
   return
end if
nc = 0
do i=1,len(text)
   if (text(i:i) == char_match) nc = nc + 1
end do
end function num_matching_char
!
subroutine read_vec_real(text,cdelim,max_read,xx,nread,print_values_read)
! read floating point numbers from a string or count how many can be read
character (len=*), intent(in)                         :: text     ! character variable from which data read
integer          , intent(in) , optional              :: max_read
character (len=*), intent(in) , optional              :: cdelim   ! if present, delimiter of variables in string
real(kind=dp)    , intent(out), optional, allocatable :: xx(:)    ! values read
integer          , intent(out), optional              :: nread    ! # of values read
logical          , intent(in) , optional              :: print_values_read
real(kind=dp)                           , allocatable :: xread(:)
character (len=len(text))                   :: mod_text
character (len=*)             , parameter   :: new_delim = ","
integer                                     :: i,ierr,nread_,max_read_,nlen
logical                                     :: read_mod_text
logical                       , parameter   :: print_debug = .false.
nlen = len_trim(text)
if (present(cdelim)) then
   max_read_ = num_matching_char(text,cdelim) + 1
else
   max_read_ = (nlen+1)/2
end if
if (present(max_read)) max_read_ = min(max_read_,max_read)
allocate (xread(max_read_))
if (present(cdelim)) then
   read_mod_text = (cdelim /= " " .and. cdelim /= ",")
else
   read_mod_text = .false.
end if
if (read_mod_text) then
   mod_text = text
   do i=1,nlen
      if (text(i:i) == cdelim) mod_text(i:i) = new_delim
   end do
end if
nread_ = 0
do i=max_read_,1,-1
   if (read_mod_text) then
      read (mod_text,*,iostat=ierr) xread(:i)
      if (print_debug) write (*,*) "i, ierr, mod_text = ",i,ierr," '" // trim(mod_text) // "'"
   else
      read (text,*,iostat=ierr) xread(:i)
      if (print_debug) write (*,*) "i, ierr, text = ",i,ierr," '" // trim(text) // "'"
   end if
   if (ierr == 0) then
      nread_ = i
      exit
   end if
end do
if (present(nread)) nread = nread_
if (present(xx)) then
   allocate (xx(nread_))
   xx = xread(:nread_)
   if (present_and_true(print_values_read)) write (*,*) size(xx)," value(s) read: ",xx
end if
deallocate (xread)
end subroutine read_vec_real
!
subroutine read_vec_int(text,cdelim,max_read,ivec,nread,print_values_read)
! read integers from a string or count how many can be read
character (len=*), intent(in)                         :: text     ! character variable from which data read
integer          , intent(in) , optional              :: max_read
character (len=*), intent(in) , optional              :: cdelim   ! if present, delimiter of variables in string
integer          , intent(out), optional, allocatable :: ivec(:)  ! values read
integer          , intent(out), optional              :: nread    ! # of values read
logical          , intent(in) , optional              :: print_values_read
integer                                 , allocatable :: iread(:)
character (len=len(text))                   :: mod_text
character (len=*)             , parameter   :: new_delim = ","
integer                                     :: i,ierr,nread_,max_read_,nlen
logical                                     :: read_mod_text
logical                       , parameter   :: print_debug = .false.
nlen = len_trim(text)
if (present(cdelim)) then
   max_read_ = num_matching_char(text,cdelim) + 1
else
   max_read_ = (nlen+1)/2
end if
if (present(max_read)) max_read_ = min(max_read_,max_read)
allocate (iread(max_read_))
if (present(cdelim)) then
   read_mod_text = (cdelim /= " " .and. cdelim /= ",")
else
   read_mod_text = .false.
end if
if (read_mod_text) then
   mod_text = text
   do i=1,nlen
      if (text(i:i) == cdelim) mod_text(i:i) = new_delim
   end do
end if
nread_ = 0
do i=max_read_,1,-1
   if (read_mod_text) then
      read (mod_text,*,iostat=ierr) iread(:i)
      if (print_debug) write (*,*) "i, ierr, mod_text = ",i,ierr," '" // trim(mod_text) // "'"
   else
      read (text,*,iostat=ierr) iread(:i)
      if (print_debug) write (*,*) "i, ierr, text = ",i,ierr," '" // trim(text) // "'"
   end if
   if (ierr == 0) then
      nread_ = i
      exit
   end if
end do
if (present(nread)) nread = nread_
if (present(ivec)) then
   allocate (ivec(nread_))
   ivec = iread(:nread_)
   if (present_and_true(print_values_read)) write (*,*) size(ivec)," value(s) read: ",ivec
end if
deallocate (iread)
end subroutine read_vec_int
!
subroutine read_vec_char(text,cdelim,max_read,xchar,nread,print_values_read)
! read character variables from a string or count how many can be read
character (len=*), intent(in)                         :: text     ! character variable from which data read
integer          , intent(in) , optional              :: max_read
character (len=*), intent(in) , optional              :: cdelim   ! if present, delimiter of variables in string
character (len=*), intent(out), optional, allocatable :: xchar(:)    ! values read
integer          , intent(out), optional              :: nread    ! # of values read
logical          , intent(in) , optional              :: print_values_read
character (len=100)           , allocatable :: xread(:)
character (len=len(text))                   :: mod_text
character (len=*)             , parameter   :: new_delim = ","
integer                                     :: i,ierr,nread_,max_read_,nlen
logical                                     :: read_mod_text
logical                       , parameter   :: print_debug = .false.
nlen = len_trim(text)
if (present(cdelim)) then
   max_read_ = num_matching_char(text,cdelim) + 1
else
   max_read_ = (nlen+1)/2
end if
if (present(max_read)) max_read_ = min(max_read_,max_read)
allocate (xread(max_read_))
if (present(cdelim)) then
   read_mod_text = (cdelim /= " " .and. cdelim /= ",")
else
   read_mod_text = .false.
end if
if (read_mod_text) then
   mod_text = text
   do i=1,nlen
      if (text(i:i) == cdelim) mod_text(i:i) = new_delim
   end do
end if
nread_ = 0
do i=max_read_,1,-1
   if (read_mod_text) then
      read (mod_text,*,iostat=ierr) xread(:i)
      if (print_debug) write (*,*) "i, ierr, mod_text = ",i,ierr," '" // trim(mod_text) // "'"
   else
      read (text,*,iostat=ierr) xread(:i)
      if (print_debug) write (*,*) "i, ierr, text = ",i,ierr," '" // trim(text) // "'"
   end if
   if (ierr == 0) then
      nread_ = i
      exit
   end if
end do
if (present(nread)) nread = nread_
if (present(xchar)) then
   allocate (xchar(nread_))
   xchar = xread(:nread_)
   if (present_and_true(print_values_read)) write (*,*) size(xchar)," value(s) read:", &
                                            (" '"//trim(xchar(i))//"'",i=1,size(xchar))
end if
deallocate (xread)
end subroutine read_vec_char
!
function quote(text) result(quoted_text)
! return a quoted and trimmed string
character (len=*), intent(in)      :: text
character (len=len_trim(text) + 2) :: quoted_text
quoted_text = "'" // trim(text) // "'"
end function quote
!
pure function irange(i1,i2) result(ivec)
! return an array of consecutive integers from i1 to i2, including both endpoints
integer, intent(in) :: i1,i2
integer             :: ivec(max(0,i2-i1+1))
integer             :: i
do i=i1,i2
   ivec(i-i1+1) = i
end do
end function irange
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
pure function geometric_series(n,a,r,normalize) result(yy)
integer      , intent(in) :: n ! # of terms of series
real(kind=dp), intent(in) :: a ! first term of series
real(kind=dp), intent(in) :: r ! common ratio
logical      , intent(in), optional :: normalize
real(kind=dp)             :: yy(n)
real(kind=dp)             :: ysum
integer                   :: i
if (n < 1) return
yy(1) = a
do i=2,n
   yy(i) = r*yy(i-1)
end do
if (present(normalize)) then
   if (normalize) then
      ysum = sum(yy)
      if (ysum /= 0.0_dp) yy = yy/ysum
   end if
end if
end function geometric_series
!
function grid_real(n,xmin,xh) result(xx)
! return a grid of n values, starting at xmin,
! with increments of xh
integer      , intent(in) :: n
real(kind=dp), intent(in), optional :: xmin,xh
real(kind=dp)             :: xx(n)
integer                   :: i
forall (i=1:n) xx(i) = default(1.0_dp,xmin) + (i-1)*default(1.0_dp,xh)
end function grid_real
!
subroutine grid_alloc_real(n,xmin,xh,xx)
! allocate a grid of n values, starting at xmin,
! with increments of xh
integer      , intent(in) :: n
real(kind=dp), intent(in) :: xmin,xh
real(kind=dp), allocatable, intent(out) :: xx(:)
integer                   :: i
if (n < 1) then
   allocate (xx(0))
   return 
end if
allocate (xx(n))
forall (i=1:n) xx(i) = xmin + (i-1)*xh
end subroutine grid_alloc_real
!
subroutine grid_alloc_int(n,xmin,xh,xx)
! allocate a grid of n values, starting at xmin,
! with increments of xh
integer, intent(in)               :: n
integer, intent(in)               :: xmin,xh
integer, allocatable, intent(out) :: xx(:)
integer                           :: i
if (n < 1) then
   allocate (xx(0))
   return
end if
allocate (xx(n))
forall (i=1:n) xx(i) = xmin + (i-1)*xh
end subroutine grid_alloc_int
!
function grid_int(n,imin,inc) result(ivec)
! return a grid of n values, starting at imin,
! with increments of inc
integer      , intent(in) :: n
integer      , intent(in) :: imin,inc
integer                   :: ivec(n)
integer                   :: i
if (n < 1) return
ivec(1) = imin
do i=2,n
   ivec(i) = ivec(i-1) + inc
end do
end function grid_int
!
pure function all_equal_vec_real(xx,yy,tol,iexcl) result(tf)
! true if elements of xx and yy, excluding those in positions iexcl(:), are the same, using tolerance tol
real(kind=dp), intent(in)           :: xx(:),yy(:)
real(kind=dp), intent(in), optional :: tol
integer      , intent(in), optional :: iexcl(:)
logical                             :: tf
real(kind=dp)                       :: tol_
integer                             :: i
call set_optional_real(tol_,tiny_real,tol)
if (size(xx) /= size(yy)) then
   tf = .false.
   return
end if
if (present(iexcl)) then
   tf = .true.
   do i=1,size(xx)
      if ((i .notin. iexcl) .and. abs(xx(i)-yy(i)) > tol_) then
         tf = .false.
         exit
      end if
   end do
else
   tf = all(abs(xx-yy) <= tol_)
end if
end function all_equal_vec_real
!
pure function all_equal_vec_int(xx,yy,iexcl) result(tf)
! true if elements of xx and yy, excluding those in positions iexcl(:), are the same
integer      , intent(in)           :: xx(:),yy(:)
integer      , intent(in), optional :: iexcl(:)
logical                             :: tf
integer                             :: i
if (size(xx) /= size(yy)) then
   tf = .false.
   return
end if
if (present(iexcl)) then
   tf = .true.
   do i=1,size(xx)
      if ((i .notin. iexcl) .and. xx(i) /= yy(i)) then
         tf = .false.
         exit
      end if
   end do
else
   tf = all(xx == yy)
end if
end function all_equal_vec_int
!
subroutine same_rows_real(irow,xmat,isame,tol,iexcl,include_irow)
! return a list of rows in xmat(:,:) that are the same as xmat(irow,:),
! excluding row irow
integer      , intent(in)               :: irow
real(kind=dp), intent(in)               :: xmat(:,:)
integer      , intent(out), allocatable :: isame(:)  ! list of rows that are the same as xmat(irow,:), excluding irow
real(kind=dp), intent(in) , optional    :: tol       ! tolerance used to determine if rows are equal
integer      , intent(in) , optional    :: iexcl(:)  ! columns to exclude when comparing rows
logical      , intent(in) , optional    :: include_irow
logical                                 :: include_irow_
real(kind=dp)                           :: tol_
integer                                 :: i,nrows
logical                                 :: same(size(xmat,1))
include_irow_ = present_and_true(include_irow)
if (present(tol)) then
   tol_ = tol
else
   tol_ = tiny_real
end if
nrows = size(xmat,1)
same  = .false.
if (irow < 1 .or. irow > nrows) then
   allocate (isame(0))
   return
end if
forall (i=1:nrows) same(i) = ((i /= irow .or. (i == irow .and. include_irow_)) .and. &
                               all_equal_vec_real(xmat(i,:),xmat(irow,:),tol=tol_,iexcl=iexcl))
call true_pos_alloc(same,isame)
end subroutine same_rows_real
!
subroutine good_pos_int(ivec,ipos,values_include,values_exclude,imin,imax)
! return in ipos the positions in ivec that are not in values_exclude and that are in the range (imin,imax), inclusive
integer, intent(in)               :: ivec(:)
integer, intent(out), allocatable :: ipos(:)
integer, intent(in) , optional    :: values_include(:) ! if present, allowed values in jvec
integer, intent(in) , optional    :: values_exclude(:) ! values to exclude from jvec
integer, intent(in) , optional    :: imin     ! min allowable value in jvec
integer, intent(in) , optional    :: imax     ! max allowable
integer                           :: i,j,jpos(size(ivec)),nj,n
n  = size(ivec)
nj = 0
do i=1,n
   j = ivec(i)
   if (.not. in_range(j,imin,imax)) cycle
   if (present(values_exclude)) then
      if (any(values_exclude == j)) cycle
   end if
   if (present(values_include)) then
      if (all(values_include /= j)) cycle
   end if
   nj = nj + 1
   jpos(nj) = i
end do
allocate (ipos(nj))
ipos = jpos(:nj)
end subroutine good_pos_int
!
subroutine good_pos_char(ivec,ipos,values_include,values_exclude)
! return in ipos the positions in ivec that are not in values_exclude inclusive
character(len=*), intent(in)               :: ivec(:)
integer         , intent(out), allocatable :: ipos(:)
character(len=*), intent(in) , optional    :: values_include(:) ! if present, allowed values in jvec
character(len=*), intent(in) , optional    :: values_exclude(:) ! values to exclude from jvec
integer                           :: i,jpos(size(ivec)),nj,n
n  = size(ivec)
nj = 0
do i=1,n
   if (present(values_exclude)) then
      if (any(values_exclude == ivec(i))) cycle
   end if
   if (present(values_include)) then
      if (all(values_include /= ivec(i))) cycle
   end if
   nj = nj + 1
   jpos(nj) = i
end do
allocate (ipos(nj))
ipos = jpos(:nj)
end subroutine good_pos_char
!
elemental function in_range_int(i,imin,imax) result(tf)
! return .true. if i >= imin and i <= imax
! if imin or imin is not present, the condition is satisfied
integer, intent(in)           :: i
integer, intent(in), optional :: imin,imax
logical                       :: tf
tf = .true.
if (present(imin))      then
   tf = i >= imin
   if (.not. tf) return
end if
if (present(imax)) then
   tf = i <= imax
   if (.not. tf) return
end if
end function in_range_int
!
function exclude_vec_int(ivec,iexcl) result(jvec)
! return in jvec the elements in ivec except those in position iexcl(:)
integer, intent(in)            :: ivec(:)
integer, intent(in), optional  :: iexcl(:)
integer, allocatable :: jvec(:)
integer              :: i,n,nuse,iuse(size(ivec))
n  = size(ivec)
if (present(iexcl)) then
   nuse = 0
   do i=1,n
      if (all(iexcl /= i)) then
         nuse = nuse + 1
         iuse(nuse) = i
      end if
   end do
   call copy_alloc_vec_int(ivec(iuse(:nuse)),jvec)
else
   allocate (jvec(n))
   jvec = ivec
end if
end function exclude_vec_int
!
function exclude_vec_real(ivec,iexcl) result(jvec)
! return in jvec the elements in ivec except those in position iexcl(:)
real(kind=dp), intent(in)            :: ivec(:)
integer      , intent(in), optional  :: iexcl(:)
real(kind=dp), allocatable :: jvec(:)
integer              :: i,n,nuse,iuse(size(ivec))
n  = size(ivec)
if (present(iexcl)) then
   nuse = 0
   do i=1,n
      if (all(iexcl /= i)) then
         nuse = nuse + 1
         iuse(nuse) = i
      end if
   end do
   call copy_alloc_vec_real(ivec(iuse(:nuse)),jvec)
else
   allocate (jvec(n))
   jvec = ivec
end if
end function exclude_vec_real
!
! function exclude_matrix_int(imat,irow_excl,icol_excl) result(jmat)
! integer, intent(in)           :: imat(:,:)
! integer, intent(in), optional :: irow_excl(:),icol_excl(:)
! integer, allocatable          :: jmat(:,:)
! call copy_alloc_matrix_int(imat,jmat, &
!      exclude_vec_int(irange(1,size(imat,1)),irow_excl),exclude_vec_int(irange(1,size(imat,2)),icol_excl))
! end function exclude_matrix_int
!
subroutine copy_alloc_matrix_int(imat,jmat,irow_use,icol_use,irow_excl,icol_excl)
! copy imat to allocatable jmat, optionally using only rows irow_use(:) and columns icol_use(:) and
! excluding rows irow_excl(:) and columns icol_excl(:)
integer, intent(in)               :: imat(:,:)
integer, intent(out), allocatable :: jmat(:,:)
integer, intent(in) , optional    :: irow_use(:),icol_use(:),irow_excl(:),icol_excl(:)
integer, allocatable              :: jrow_use(:),jcol_use(:)
integer                           :: nrow,ncol
nrow = size(imat,1)
ncol = size(imat,2)
call copy_alloc_vec_int(irange(1,nrow),jrow_use,values_include=irow_use,values_exclude=irow_excl)
call copy_alloc_vec_int(irange(1,ncol),jcol_use,values_include=icol_use,values_exclude=icol_excl)
allocate (jmat(size(jrow_use),size(jcol_use)))
jmat = imat(jrow_use,jcol_use)
end subroutine copy_alloc_matrix_int
!
subroutine copy_alloc_matrix_real(xmat,ymat,irow_use,icol_use,irow_excl,icol_excl)
! copy xmat to allocatable ymat, optionally using only rows irow_use(:) and columns icol_use(:) and
! excluding rows irow_excl(:) and columns icol_excl(:)
real(kind=dp), intent(in)               :: xmat(:,:)
real(kind=dp), intent(out), allocatable :: ymat(:,:)
integer, intent(in) , optional    :: irow_use(:),icol_use(:),irow_excl(:),icol_excl(:)
integer, allocatable              :: jrow_use(:),jcol_use(:)
integer                           :: nrow,ncol
nrow = size(xmat,1)
ncol = size(xmat,2)
call copy_alloc_vec_int(irange(1,nrow),jrow_use,values_include=irow_use,values_exclude=irow_excl)
call copy_alloc_vec_int(irange(1,ncol),jcol_use,values_include=icol_use,values_exclude=icol_excl)
allocate (ymat(size(jrow_use),size(jcol_use)))
ymat = xmat(jrow_use,jcol_use)
end subroutine copy_alloc_matrix_real
!
subroutine copy_alloc_vec_int(ivec,jvec,values_include,values_exclude,imin,imax)
! return in jvec the values in ivec that are in values_include and are not in values_exclude
! and that are in the range (imin,imax), inclusive
integer, intent(in)               :: ivec(:)  ! source vector
integer, intent(out), allocatable :: jvec(:)  ! output vector
integer, intent(in) , optional    :: values_include(:)
integer, intent(in) , optional    :: values_exclude(:) ! values to exclude from jvec
integer, intent(in) , optional    :: imin     ! min allowable value in jvec
integer, intent(in) , optional    :: imax     ! max allowable
integer,              allocatable :: ipos(:)
call good_pos(ivec,ipos,values_include=values_include,values_exclude=values_exclude,imin=imin,imax=imax)
allocate(jvec(size(ipos)))
jvec = ivec(ipos)
end subroutine copy_alloc_vec_int
!
subroutine copy_alloc_vec_char(ivec,jvec,values_include,values_exclude)
! return in jvec the values in ivec that are in values_include and are not in values_exclude
! and that are in the range (imin,imax), inclusive
character (len=*), intent(in)               :: ivec(:)  ! source vector
character (len=*), intent(out), allocatable :: jvec(:)  ! output vector
character (len=*), intent(in) , optional    :: values_include(:)
character (len=*), intent(in) , optional    :: values_exclude(:) ! values to exclude from jvec
integer,              allocatable :: ipos(:)
call good_pos(ivec,ipos,values_include=values_include,values_exclude=values_exclude)
allocate(jvec(size(ipos)))
jvec = ivec(ipos)
end subroutine copy_alloc_vec_char
!
function vec_exclude_int(ivec,values_exclude) result(jvec)
! return in jvec(:) the values of ivec(:) not in values_exclude(:)
integer, intent(in)  :: ivec(:)
integer, intent(in)  :: values_exclude(:)
integer, allocatable :: jvec(:)
integer              :: i,kvec(size(ivec)),nk
nk = 0
do i=1,size(ivec)
   if (ivec(i) .notin. values_exclude) then
      nk = nk + 1
      kvec(nk) = ivec(i)
   end if
end do
allocate (jvec(nk))
jvec = kvec(:nk)
end function vec_exclude_int
!
pure function int_vec_in_vec(ivec,jvec) result(tf)
integer, intent(in) :: ivec(:),jvec(:)
logical             :: tf(size(ivec))
integer             :: i
forall (i=1:size(ivec)) tf(i) = int_in_vec(ivec(i),jvec)
end function int_vec_in_vec
!
pure function int_in_vec(i,ivec) result(tf)
integer, intent(in) :: i,ivec(:)
logical             :: tf
tf = (any(i == ivec))
end function int_in_vec
!
pure function char_in_vec(i,ivec) result(tf)
! return .true. if any element of ivec(:) equals i
character (len=*), intent(in) :: i,ivec(:)
logical                       :: tf
tf = (any(i == ivec))
end function char_in_vec
!
pure function char_vec_in_vec(jvec,ivec) result(tf)
! return .true. for each element of jvec(:) found in ivec(:)
character (len=*), intent(in) :: jvec(:),ivec(:)
logical                       :: tf(size(jvec))
integer                       :: i
forall (i=1:size(jvec)) tf(i) = any(jvec(i) == ivec)
end function char_vec_in_vec
!
pure function notall(ivec) result(tf)
logical, intent(in) :: ivec(:)
logical             :: tf
tf = .not. all(ivec)
end function notall
!
pure function int_vec_not_in_vec(ivec,jvec) result(tf)
integer, intent(in) :: ivec(:),jvec(:)
logical             :: tf(size(ivec))
integer             :: i
forall (i=1:size(ivec)) tf(i) = int_not_in_vec(ivec(i),jvec)
end function int_vec_not_in_vec
!
pure function int_not_in_vec(i,ivec) result(tf)
integer, intent(in) :: i,ivec(:)
logical             :: tf
tf = .not. int_in_vec(i,ivec)
end function int_not_in_vec
!
pure function char_not_in_vec(i,ivec) result(tf)
character (len=*), intent(in) :: i,ivec(:)
logical                       :: tf
tf = .not. (any(i == ivec))
! tf = .not. char_in_vec(i,ivec)
end function char_not_in_vec
!
subroutine copy_alloc_vec_real(xvec,yvec)
! allocate yvec to the size xvec and copy the contents of xvec to yvec
real(kind=dp), intent(in)               :: xvec(:) ! source vector
real(kind=dp), intent(out), optional, allocatable :: yvec(:) ! output vector
integer                                 :: n
if (.not. present(yvec)) return
n = size(xvec)
allocate (yvec(n))
yvec = xvec
end subroutine copy_alloc_vec_real
!
pure function ivec(n) result(jj)
! return a vector of consecutive integers from 1 to n
integer, intent(in) :: n
integer             :: jj(n)
integer             :: i
forall (i=1:n) jj(i) = i
end function ivec
!
elemental function default_logical(def,opt) result(tf)
! return opt if it is present, otherwise def (logical arguments and result)
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
elemental function default_integer(def,opt) result(ii)
! return opt if it is present, otherwise def (integer arguments and result)
integer, intent(in)           :: def
integer, intent(in), optional :: opt
integer                       :: ii
if (present(opt)) then
   ii = opt
else
   ii = def
end if
end function default_integer
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
function default_character_nlen(nlen,def,opt) result(yy)
! return string of length nlen that is opt if it is present, otherwise def (character arguments and result)
integer          , intent(in)           :: nlen
character (len=*), intent(in)           :: def
character (len=*), intent(in), optional :: opt
character (len=nlen)                    :: yy
if (present(opt)) then
   yy = opt
else
   yy = def
end if
end function default_character_nlen
!
subroutine copy_alloc_opt_char_vec(yy,xdef,xopt)
! copy xopt(:) to yy(:) if xopt is present, otherwise copy xdef(:)
character (len=*), intent(in)               :: xdef(:)
character (len=*), intent(in) , optional    :: xopt(:)
character (len=*), intent(out), allocatable :: yy(:)
if (present(xopt)) then
   call copy_alloc_char_vec(xopt,yy)
else
   call copy_alloc_char_vec(xdef,yy)
end if
end subroutine copy_alloc_opt_char_vec
!
subroutine copy_alloc_char_vec(xx,yy)
! copy xx(:) to yy(:)
character (len=*), intent(in)               :: xx(:)
character (len=*), intent(out), allocatable :: yy(:)
allocate (yy(size(xx)))
yy = xx
end subroutine copy_alloc_char_vec
!
function assert_eq2(n1,n2,string)
character(len=*), intent(in) :: string
integer, intent(in) :: n1,n2
integer :: assert_eq2
if (n1 == n2) then
   assert_eq2=n1
else
   write (*,*) "nrerror: an assert_eq failed with this tag:", string
   stop "program terminated by assert_eq2"
end if
end function assert_eq2
!BL
function assert_eq3(n1,n2,n3,string)
character(len=*), intent(in) :: string
integer, intent(in) :: n1,n2,n3
integer :: assert_eq3
if (n1 == n2 .and. n2 == n3) then
   assert_eq3=n1
else
   write (*,*) "nrerror: an assert_eq failed with this tag:", string
   stop "program terminated by assert_eq3"
end if
end function assert_eq3
!BL
function assert_eq4(n1,n2,n3,n4,string)
character(len=*), intent(in) :: string
integer, intent(in) :: n1,n2,n3,n4
integer :: assert_eq4
if (n1 == n2 .and. n2 == n3 .and. n3 == n4) then
   assert_eq4=n1
else
   write (*,*) "nrerror: an assert_eq failed with this tag:", string
   stop "program terminated by assert_eq4"
end if
end function assert_eq4
!BL
function assert_eqn(nn,string)
character(len=*), intent(in) :: string
integer, dimension(:), intent(in) :: nn
integer :: assert_eqn
if (all(nn(2:) == nn(1))) then
   assert_eqn=nn(1)
else
   write (*,*) "nrerror: an assert_eq failed with this tag:", string
stop "program terminated by assert_eqn"
end if
end function assert_eqn
!
subroutine nrerror(string)
character(len=*), intent(in) :: string
write (*,*) "nrerror: ",string
stop "program terminated by nrerror"
end subroutine nrerror
!
function iminloc(arr)
real(kind=dp), dimension(:), intent(in) :: arr
integer, dimension(1) :: imin
integer :: iminloc
imin=minloc(arr(:))
iminloc=imin(1)
end function iminloc
!
subroutine merge_alloc_int(itrue,ifalse,tf,ivec)
integer, intent(in)               :: itrue(:),ifalse(:)
logical, intent(in)               :: tf
integer, intent(out), allocatable :: ivec(:)
if (tf) then
   call set_alloc(itrue,ivec)
else
   call set_alloc(ifalse,ivec)
end if
end subroutine merge_alloc_int
!
elemental subroutine merge_sub_character(xx,tf,xtrue,xfalse)
! set xx to xtrue (xfalse) if tf is true (false)
character (len=*), intent(out) :: xx
logical          , intent(in)  :: tf
character (len=*), intent(in)  :: xtrue,xfalse
if (tf) then
   xx = xtrue
else
   xx = xfalse
end if
end subroutine merge_sub_character
!
elemental function merge_char(tf,xtrue,xfalse) result(xx)
! return xtrue or xfalse, depending on tf
logical          , intent(in) :: tf
character (len=*), intent(in), optional :: xtrue,xfalse
character (len=1000)          :: xx
if (tf) then
   call set_optional(xx,"",xtrue)
else
   call set_optional(xx,"",xfalse)
end if
end function merge_char
!
function element_char(i,xvec,xdef) result(xx)
! return xdef or xvec(i)
integer          , intent(in), optional :: i
character (len=*), intent(in), optional :: xvec(:)
character (len=*), intent(in), optional :: xdef
character (len=1000)                    :: xx
if (present(xdef)) then
   xx = xdef
else
   xx = ""
end if
if (present(xvec)) then
   if (present(i)) then
      if (i > 0 .and. i <= size(xvec)) xx = xvec(i)
   end if
end if
end function element_char
!
function rebase_vec(xx,method,base) result(yy)
real(kind=dp)    , intent(in) :: xx(:)
character (len=*), intent(in) :: method
real(kind=dp)    , intent(in), optional   :: base
real(kind=dp)                 :: yy(size(xx))
if (size(xx) < 1) return
if (method == "shift") then
   yy = xx - default(xx(1),base)
else if (method == "divide") then
   yy = xx / default(xx(1),base)
else
   yy = xx
end if
end function rebase_vec
!
function rebase_mat(xx,method,base) result(yy)
real(kind=dp)    , intent(in) :: xx(:,:)
character (len=*), intent(in) :: method
real(kind=dp)    , intent(in), optional :: base
real(kind=dp)                           :: yy(size(xx,1),size(xx,2))
integer                                 :: icol
do icol=1,size(xx,2)
   yy(:,icol) = rebase_vec(xx(:,icol),method,base)
end do
end function rebase_mat
!
function prepend_char(xadd,xx) result(yy)
! set yy equal to [xadd,xx]
character (len=*), intent(in)                  :: xadd(:)
character (len=*), intent(in)                  :: xx(:)
character (len=len(xx(1)))                     :: yy(size(xx)+size(xadd))
integer                                        :: n,nadd
n = size(xx)
nadd = size(xadd)
yy(1:n) = xx
if (nadd > 0) yy(:nadd) = xadd
yy(nadd+1:) = xx
end function prepend_char
!
subroutine assert_vec(tf,msg,stop_error,jerr)
! test if all elements of tf are true
logical          , intent(in)            :: tf(:)
character (len=*), intent(in)            :: msg
logical          , intent(in) , optional :: stop_error
integer          , intent(out), optional :: jerr
integer                                  :: ierr
ierr = first_false(tf)
if (ierr /= 0) then
   write (*,*) "in " // msg // ", ierr =",ierr
   if (present(stop_error)) then
      if (stop_error) stop
   end if
end if
if (present(jerr)) jerr = ierr
end subroutine assert_vec
!
subroutine assert_scalar(tf,msg,stop_error)
! test if tf is true
logical          , intent(in)            :: tf
character (len=*), intent(in)            :: msg
logical          , intent(in) , optional :: stop_error
! integer                                  :: ierr
if (.not. tf) then
   write (*,*) "in " // trim(msg)
   if (present(stop_error)) then
      if (stop_error) then
         write (*,*) "stopping in " // mod_str // "assert_scalar"
         stop
      end if
   end if
end if
! call assert_vec([tf],msg,stop_error,jerr)
end subroutine assert_scalar
!
pure function first_false(tf) result(i1)
! return the location of the first false element in tf(:), 0 if all .true.
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
subroutine spread_alloc_char(idim,ncopies,xvec,xmat)
! create in xmat a 2D array containing copies of xvec, with an extra dimension
! along dimension idim
integer          , intent(in)               :: idim,ncopies
character (len=*), intent(in)               :: xvec(:)
character (len=*), intent(out), allocatable :: xmat(:,:)
integer                                     :: i,n,ncopies_
n        = size(xvec)
ncopies_ = max(0,ncopies)
if      (idim == 1) then
   allocate (xmat(ncopies_,n))
   forall (i=1:n) xmat(:,i) = xvec(i)
else if (idim == 2) then
   allocate (xmat(n,ncopies_))
   forall (i=1:n) xmat(i,:) = xvec(i)
else
   write (*,*) "in util_mod::spread_alloc_char, idim =",idim," need idim = 1 or 2"
   stop
end if
end subroutine spread_alloc_char
!
subroutine spread_alloc_logical(idim,ncopies,xvec,xmat)
! create in xmat a 2D array containing copies of xvec, with an extra dimension
! along dimension idim
integer, intent(in)               :: idim,ncopies
logical, intent(in)               :: xvec(:)
logical, intent(out), allocatable :: xmat(:,:)
integer                           :: i,n,ncopies_
n        = size(xvec)
ncopies_ = max(0,ncopies)
if      (idim == 1) then
   allocate (xmat(ncopies_,n))
   forall (i=1:n) xmat(:,i) = xvec(i)
else if (idim == 2) then
   allocate (xmat(n,ncopies_))
   forall (i=1:n) xmat(i,:) = xvec(i)
else
   write (*,*) "in util_mod::spread_alloc_logical, idim =",idim," need idim = 1 or 2"
   stop
end if
end subroutine spread_alloc_logical
!
function reverse_real(xx) result(xrev)
real(kind=dp), intent(in) :: xx(:)
real(kind=dp)             :: xrev(size(xx))
integer                   :: n
n = size(xx)
if (n > 0) xrev = xx(n:1:-1)
end function reverse_real
!
! subroutine match_tf_col_char(xx,xgood,tf_mat)
! character (len=*), intent(in)               :: xx(:)       !
! character (len=*), intent(in)               :: xgood(:)
! logical          , intent(out), allocatable :: tf_mat(:,:)
! end subroutine match_tf_col_char
!
!
subroutine renormalize_vec(xx)
real(kind=dp), intent(in out) :: xx(:)
real(kind=dp)                 :: xsum
if (size(xx) < 1) return
xsum = sum(xx)
if (abs(xsum) > 0.0_dp) xx = xx/xsum
end subroutine renormalize_vec
!
subroutine renormalize_tensor(xx,dim)
! renormalize so that sum(xx,dim=3) = 1.0 everywhere
real(kind=dp), intent(in out) :: xx(:,:,:)
integer      , intent(in)     :: dim
integer                       :: i,j,n1,n2,n3
n1  = size(xx,1)
n2  = size(xx,2)
n3  = size(xx,3)
if (dim == 1) then
   do i=1,n2
      do j=1,n3
         call renormalize(xx(:,i,j))
      end do
   end do
else if (dim == 2) then
   do i=1,n1
      do j=1,n3
         call renormalize(xx(i,:,j))
      end do
   end do
else if (dim == 3) then
   do i=1,n1
      do j=1,n2
         call renormalize(xx(i,j,:))
      end do
   end do
end if
end subroutine renormalize_tensor
!
subroutine print_matrix_real_row_num(xx,col_labels,i1,i2,title,fmt_ir,fmt_icol,fmt_col_labels, &
                                     fmt_header,fmt_trailer,print_col_num,row_num_name,outu)
! print matrix of real numbers with row numbers
real(kind=dp)    , intent(in)           :: xx(:,:)       ! (n,ncol) matrix to be printed
character (len=*), intent(in), optional :: col_labels(:) ! column labels
integer          , intent(in), optional :: i1,i2    ! range of rows to print
character (len=*), intent(in), optional :: title    ! title to print
character (len=*), intent(in), optional :: fmt_ir   ! format to print data
character (len=*), intent(in), optional :: fmt_icol ! format to print column numbers
character (len=*), intent(in), optional :: fmt_col_labels         ! format to print column labels
character (len=*), intent(in), optional :: fmt_header,fmt_trailer ! formats to print before and after printing data
character (len=*), intent(in), optional :: row_num_name
logical          , intent(in), optional :: print_col_num          ! print column numbers
integer          , intent(in), optional :: outu                   ! unit to which data printed
character (len=100)                     :: fmt_ir_,fmt_icol_,fmt_col_labels_
integer                                 :: icol,j,n,outu_
n = size(xx,1)
outu_ = default(istdout,outu)
call set_optional(fmt_ir_,"(i6,1000f12.6)",fmt_ir)
call set_optional(fmt_icol_,"(6x,1000i12)",fmt_icol)
call set_optional(fmt_col_labels_,"(1000a12)",fmt_col_labels)
call write_format(fmt_header,outu_)
if (present(title)) write (outu_,*) trim(title)
if (present(row_num_name)) then
   write (outu_,"(a6)",advance="no") trim(row_num_name)
else
   write (outu_,"(6x)",advance="no")
end if
if (present(col_labels)) write (outu_,fmt_col_labels_) (trim(col_labels(icol)),icol=1,size(col_labels))
if (default(.false.,print_col_num)) write (outu_,fmt_icol_) (icol,icol=1,size(xx,2))
do j=max(1,default(1,i1)),min(n,default(n,i2))
   write (outu_,fmt_ir_) j,xx(j,:)
end do
call write_format(fmt_trailer,outu_)
end subroutine print_matrix_real_row_num
!
subroutine print_matrix_int_row_num(xx,col_labels,i1,i2,title,fmt_ir,fmt_icol,fmt_col_labels, &
                                    fmt_header,fmt_trailer,print_col_num,outu)
! print matrix of real numbers with row numbers
integer          , intent(in)           :: xx(:,:)       ! (n,ncol) matrix to be printed
character (len=*), intent(in), optional :: col_labels(:) ! column labels
integer          , intent(in), optional :: i1,i2    ! range of rows to print
character (len=*), intent(in), optional :: title    ! title to print
character (len=*), intent(in), optional :: fmt_ir   ! format to print data
character (len=*), intent(in), optional :: fmt_icol ! format to print column numbers
character (len=*), intent(in), optional :: fmt_col_labels         ! format to print column labels
character (len=*), intent(in), optional :: fmt_header,fmt_trailer ! formats to print before and after printing data
logical          , intent(in), optional :: print_col_num          ! print column numbers
integer          , intent(in), optional :: outu                   ! unit to which data printed
character (len=100)                     :: fmt_ir_,fmt_icol_,fmt_col_labels_
integer                                 :: icol,j,n,outu_
n = size(xx,1)
outu_ = default(istdout,outu)
call set_optional(fmt_ir_,"(i6,1000i12)",fmt_ir)
call set_optional(fmt_icol_,"(6x,1000i12)",fmt_icol)
call set_optional(fmt_col_labels_,"(6x,1000a12)",fmt_col_labels)
call write_format(fmt_header,outu_)
if (present(title)) write (outu_,*) trim(title)
if (present(col_labels)) write (outu_,fmt_col_labels_) (col_labels(icol),icol=1,size(col_labels))
if (default(.false.,print_col_num)) write (outu_,fmt_icol_) (icol,icol=1,size(xx,2))
do j=max(1,default(1,i1)),min(n,default(n,i2))
   write (outu_,fmt_ir_) j,xx(j,:)
end do
call write_format(fmt_trailer,outu_)
end subroutine print_matrix_int_row_num
!
function size_optional_int_vec(ix) result(n)
integer, intent(in), optional :: ix(:)
integer                       :: n
if (present(ix)) then
   n = size(ix)
else
   n = 0
end if
end function size_optional_int_vec
!
function size_optional_char_vec(ix) result(n)
character (len=*), intent(in), optional :: ix(:)
integer                                 :: n
if (present(ix)) then
   n = size(ix)
else
   n = 0
end if
end function size_optional_char_vec
!
function size_optional_real_vec(xx) result(n)
real(kind=dp), intent(in), optional :: xx(:)
integer                             :: n
if (present(xx)) then
   n = size(xx)
else
   n = 0
end if
end function size_optional_real_vec
!
function size_optional_logical_vec(ix) result(n)
logical, intent(in), optional :: ix(:)
integer                       :: n
if (present(ix)) then
   n = size(ix)
else
   n = 0
end if
end function size_optional_logical_vec
!
subroutine read_unit_int_vec_alloc(iu,ivec,print_vec,label)
! read ivec(:) from unit iu and print it if print_vec is present and .true.
integer          , intent(in)               :: iu
integer          , intent(out), allocatable :: ivec(:)
logical          , intent(in) , optional    :: print_vec
character (len=*), intent(in) , optional    :: label
character (len=1000)                        :: text
read (iu,"(a)") text
call read_int_vec_alloc(text,ivec)
if (default(.false.,print_vec)) write (*,*) trim(label)," = ",ivec
end subroutine read_unit_int_vec_alloc
!
subroutine read_unit_real_vec_alloc(iu,xx,print_vec,label,nread)
! read xx(:) from unit iu and print it if print_vec is present and .true.
integer          , intent(in)               :: iu
real(kind=dp)    , intent(out), allocatable :: xx(:)
logical          , intent(in) , optional    :: print_vec
character (len=*), intent(in) , optional    :: label
integer          , intent(out), optional    :: nread
character (len=1000)                        :: text
read (iu,"(a)") text
call read_real_vec_alloc(text,xx)
if (default(.false.,print_vec)) write (*,*) trim(label)," = ",xx
if (present(nread)) nread = size(xx)
end subroutine read_unit_real_vec_alloc
!
subroutine read_int_vec_alloc(text,ivec)
! read ivec(:) from text, which contains the number of integers followed by the integers
character (len=*), intent(in)               :: text
integer          , intent(out), allocatable :: ivec(:)
integer                                     :: ierr,n
character (len=*), parameter                :: msg="in util_mod::read_int_vec_alloc, "
read (text,*,iostat=ierr) n
if (ierr /= 0) then
   write (*,*) msg,"could not read an integer from '" // trim(text) // "'"
   stop
end if
allocate (ivec(n))
if (n > 0) then
   read (text,*,iostat=ierr) n,ivec
   if (ierr /= 0) then
      write (*,*) msg,"could not read ",n+1," integers from '" // trim(text) // "'"
      stop
   end if
end if
end subroutine read_int_vec_alloc
!
subroutine read_real_vec_alloc(text,xx)
! read xx(:) from text
character (len=*), intent(in)               :: text
real(kind=dp)    , intent(out), allocatable :: xx(:)
integer                                     :: ierr,n
character (len=*), parameter                :: msg="in util_mod::read_real_vec_alloc, "
read (text,*,iostat=ierr) n
if (ierr /= 0) then
   write (*,*) msg,"could not read an integer from '" // trim(text) // "'"
   stop
end if
allocate (xx(n))
if (n > 0) then
   read (text,*,iostat=ierr) n,xx
   if (ierr /= 0) then
      write (*,*) msg,"could not read integer and ",n," reals from '" // trim(text) // "'"
      stop
   end if
end if
end subroutine read_real_vec_alloc
!
function interp_two_points(xx,x1,x2,y1,y2,slope_left,slope_right) result(yy)
! linear interpolation between two points
real(kind=dp), intent(in)           :: xx,x1,x2,y1,y2
real(kind=dp), intent(in), optional :: slope_left,slope_right
real(kind=dp)                       :: yy
real(kind=dp)                       :: slope
if (x2 > x1) then
   slope = (y2 - y1) / (x2 - x1)
else
   slope = 0.0_dp
end if
if (xx <= x1) then
   yy = y1 - default(slope,slope_left) *(x1-xx)
else if (xx >= x2) then
   yy = y2 + default(slope,slope_right)*(xx-x2)
else
   yy = y1 + slope*(xx-x1)
end if
end function interp_two_points
!
function label_obs_bins(thresh,fmt_real) result(labels)
! labels for ranges determined by thresh(:)
real(kind=dp)     , intent(in) :: thresh(:)
character (len=30)             :: labels(size(thresh)+1)
character (len=*) , intent(in), optional :: fmt_real
character (len=20)             :: fstr
integer                        :: i,nthresh
logical                        :: in_quotes
in_quotes = .true.
call set_optional(fstr,"f0.4",fmt_real)
nthresh = size(thresh)
if (nthresh < 1) return
! write (labels(1),"('x<=',f0.4)") thresh(1)
write (labels(1),"('x<='," // trim(fstr) // ")") thresh(1)
do i=1,nthresh-1
!   write (labels(i+1),"(f0.4,'<x<=',f0.4)") thresh([i,i+1])
   write (labels(i+1),"(" // trim(fstr) // ",'<x<='," // trim(fstr) // ")") thresh([i,i+1])
end do
! write (labels(nthresh+1),"('x>',f0.4)") thresh(nthresh)
write (labels(nthresh+1),"('x>'," // trim(fstr) // ")") thresh(nthresh)
if (in_quotes) then
   do i=1,size(labels)
      labels(i) = "'" // trim(labels(i)) // "'"
   end do
end if
end function label_obs_bins
!
function num_obs_bins(xx,thresh) result(nn)
! count the number of observations in xx(:) in regions defined by ascending thresholds thresh(:)
real(kind=dp), intent(in) :: xx(:)
real(kind=dp), intent(in) :: thresh(:)
integer                   :: nn(size(thresh)+1),i,j,k
nn = 0
do i=1,size(xx)
   j = size(nn)
   do k=1,size(thresh)
      if (xx(i) <= thresh(k)) then
         j = k
         exit
      end if
   end do
   nn(j) = nn(j) + 1
end do
end function num_obs_bins
!
subroutine write_xname_yname(xname,yname,iu,skip_present,skip_missing,cdelim)
character (len=*), intent(in), optional :: xname,yname
integer          , intent(in), optional :: iu
logical          , intent(in), optional :: skip_present,skip_missing
character (len=*), intent(in), optional :: cdelim
integer                                 :: iu_
character (len=10)                      :: cdelim_
iu_     = default(istdout,iu)
cdelim_ = default("vs.",cdelim)
if (present(xname) .and. present(yname)) then
   if (present_and_true(skip_present)) write (iu_,*)
   write (iu_,*) trim(xname) // " " // trim(cdelim_) // " " // trim(yname)
else
   if (present_and_true(skip_missing)) write (iu_,*)
end if
end subroutine write_xname_yname
!
subroutine write_lines(outu,lines,format_str,format_header)
integer          , intent(in), optional :: outu
character (len=*), intent(in), optional :: lines(:)
character (len=*), intent(in), optional :: format_str,format_header
integer                                 :: outu_,i
outu_ = default(istdout,outu)
call write_format(format_header,iunit=outu_)
if (.not. present(lines)) return
! if (present(format_str)) write (*,*) "in write_lines, format_str = '" // trim(format_str) // "'"
do i=1,size(lines)
   if (present(format_str)) then
      write (outu_,format_str) trim(lines(i))
   else
      write (outu_,*)          trim(lines(i))
   end if
end do
end subroutine write_lines
!
subroutine write_lines_file(xfile,lines,format_str,format_header)
character (len=*), intent(in), optional :: xfile
character (len=*), intent(in), optional :: lines(:)
character (len=*), intent(in), optional :: format_str,format_header
integer                                 :: outu
integer                                 :: nskip
nskip = 0
call get_unit_open_file(xfile,outu,xaction="w",nlines_skip_append=nskip)
call write_lines(outu,lines,format_str,format_header)
end subroutine write_lines_file
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
elemental function remove_char(xx,xrem) result(yy)
! remove instances of character xrem from xx
character (len=*), intent(in) :: xx
character (len=*), intent(in), optional :: xrem
character (len=len(xx))       :: yy
integer                       :: i,j
if (.not. present(xrem)) then
   yy = xx
   return
end if
j  = 1
yy = ""
do i=1,len(xx)
   if (index(xrem,xx(i:i)) /= 0) cycle
   yy(j:j) = xx(i:i)
   j = j+1
end do
end function remove_char
!
subroutine append_file(xfile,text)
character (len=*), intent(in)           :: xfile
character (len=*), intent(in), optional :: text(:)
integer                                 :: i,outu
if (.not. present(text)) return
inquire (file=xfile,number=outu)
do i=1,size(text)
   write (outu,"(a)") trim(text(i))
end do
end subroutine append_file
!
subroutine copy_file(xfile,yfile,out_unit,max_copy)
! copy contents of xfile to yfile
character (len=*), intent(in)               :: xfile,yfile
integer          , intent(in)    , optional :: max_copy
integer          , intent(in out), optional :: out_unit
character (len=10000)                       :: text
integer                                     :: ierr,iu,ou,icopy
if (xfile == yfile) then
   write (*,*) "in copy_file, input and output files are both " // trim(xfile)," RETURNING"
   return
end if
ou = default(bad_unit,out_unit)
if (ou == bad_unit) call get_unit_open_file(yfile,ou,xaction="w",nlines_skip_append=0)
call get_unit_open_file(xfile,iu,xaction="r")
icopy = 0
do
   icopy = icopy + 1
   if (present(max_copy)) then
      if (icopy > max_copy) exit
   end if
   read (iu,"(a)",iostat=ierr) text
   if (ierr /= 0) exit
   write (ou,"(a)") trim(text)
end do
if (present(out_unit)) out_unit = ou
end subroutine copy_file
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
subroutine get_unit_open_file(xfile,iunit,xaction,nrow_skip,nlines_skip_append)
! connect file xfile to iunit for action xaction
! same as subroutine open_file, except that iunit is an intent(out) argument
! set by a call to get_unit
character (len=*), intent(in)           :: xfile
integer          , intent(out)          :: iunit ! unit to which xfile is connected upon output
character (len=*), intent(in)           :: xaction
integer          , intent(in), optional :: nrow_skip
integer          , intent(in), optional :: nlines_skip_append
integer                                 :: i,ierr,junit,nlines_skip_append_
character (len=1)                       :: xact
character (len=*), parameter            :: msg="in open_file, "
call get_unit(iunit)
if (present(nlines_skip_append)) then
   nlines_skip_append_ = nlines_skip_append
else
   nlines_skip_append_ = 1
end if
if (xaction == "r" .or. xaction == "R") then
   xact = "r"
else if (xaction == "w" .or. xaction == "W") then
   xact = "w"
else
   write (*,*) msg,"need xaction equal one of ('r','R','w','W')"
   return
end if
if (xact == "r") then
   open (unit=iunit,file=xfile,action="read",status="old",iostat=ierr)
   if (ierr /= 0) then
      write (*,*) msg,"could not open for reading file '" // trim(xfile) // "', iostat =",ierr
      if (.not. file_exists(xfile)) write (*,*) "file does not exist"
!      inquire(file=xfile,exist=file_exists)
      stop
   end if
else if (xact == "w") then
   inquire (file=xfile,number=junit)
!   print*,"iunit, junit, xfile =",iunit,junit,trim(xfile)
   if (junit /= bad_unit .and. junit /= iunit) close (junit)
   if (junit /= iunit) then
!      write (*,*) "connecting ",trim(xfile)," to unit",iunit," for writing"
      if (junit == bad_unit) then
         open (unit=iunit,file=xfile,action="write",status="replace",iostat=ierr)
      else
         open (unit=iunit,file=xfile,action="write",position="append",iostat=ierr)
      end if
   end if
   if (ierr /= 0) then
      write (*,*) msg,"could not open for writing file '" // trim(xfile) // "', iostat =",ierr
      stop
   end if
   if (junit /= bad_unit) then
      do i=1,nlines_skip_append_
         write (iunit,*)
      end do
   end if
end if
if (present(nrow_skip)) then
   do i=1,nrow_skip
      if (xact == "r") then
         read (iunit,*)
      else
         write (iunit,*)
      end if
   end do
end if
end subroutine get_unit_open_file
!
subroutine check_tickers_exist(tickers,dir,suffix,good_ticker_file)
character (len=*), intent(in)           :: tickers(:)
character (len=*), intent(in), optional :: dir,suffix,good_ticker_file
character (len=1000)                    :: dir_,xfile
character (len=100)                     :: suffix_
integer                                 :: i,ntickers,nmiss
logical                                 :: xexist(size(tickers))
ntickers = size(tickers)
call set_optional(dir_,"",dir)
call pad_directory_name(dir_,merge("/","\",unix()))
call set_optional(suffix_,"",suffix)
do i=1,ntickers
   xfile = trim(dir_) // trim(tickers(i)) // trim(suffix_)
   xexist(i) = file_exists(xfile)
   if (.not. xexist(i)) write (*,*) trim(xfile)
end do
nmiss = count(.not. xexist)
if (nmiss > 0) then
   write (*,"('#missing files = ',i0)") nmiss
   if (present(good_ticker_file)) then
      call write_lines_file(good_ticker_file,pack(tickers,xexist),format_str="(a)")
      write (*,"(a)") "wrote good tickers to " // trim(good_ticker_file)
   end if
   stop "program stopped because of missing files"
end if
end subroutine check_tickers_exist
!
function file_exists(xfile) result(tf)
! return .true. if a file xfile exists, otherwise .false.
character (len=*), intent(in) :: xfile
logical                       :: tf
inquire (file=xfile,exist=tf)
! print*,trim(xfile)," ",tf !! debug
end function file_exists
!
function directory_exists(xfile) result(tf)
character (len=*), intent(in) :: xfile
logical                       :: tf
integer                       :: nlen
character (len=1)             :: last_char
nlen = len_trim(xfile)
if (nlen > 0) then
   last_char = xfile(nlen:nlen)
   if (last_char == "\" .or. last_char == "/") then
      inquire (file=xfile(1:nlen-1),exist=tf)
      print*,"in directory_exists ",trim(xfile(1:nlen-1)),tf !! debug
      return
   end if
end if
inquire (file=xfile,exist=tf)
! print*,trim(xfile)," ",tf !! debug
end function directory_exists
!
subroutine checkdir(dir)
character(len=*), intent(in) :: dir
integer :: unitno
! Test whether the directory exists
call get_unit(unitno)
open(unit=unitno,file=trim(dir)//"deleteme.txt",status="replace",err=1234)
! line below replaced by two lines above because g95 does not support "newunit"
! open(newunit=unitno,file=fname,status="replace",err=1234)
close (unitno)
return
       ! If doesn't exist, end gracefully
1234 write(*,*) 'Data directory, '//trim(dir)//' does not exist or could not write there!'
stop
end subroutine checkdir
!
function files_exist(xfiles,dir,suffix,print_missing) result(tf)
character (len=*), intent(in) :: xfiles(:)
character (len=*), intent(in), optional :: dir,suffix
logical          , intent(in), optional :: print_missing
character (len=1000)          :: dir_,suffix_,xfile
logical                       :: tf(size(xfiles))
logical                       :: print_exist_,print_missing_
integer                       :: ifile
print_exist_ = .false. ! .false.
print_missing_ = default(.false.,print_missing) 
call set_optional(dir_,"",dir)
call pad_directory_name(dir_,merge("/","\",unix()))
call set_optional(suffix_,"",suffix)
! print*,"dir_=",trim(dir_)
do ifile=1,size(xfiles)
   xfile = trim(dir_) // trim(xfiles(ifile)) // trim(suffix_)
   tf(ifile) = file_exists(xfile)
   if (print_exist_) write (*,"(l3,1x,a)") tf(ifile),trim(xfile)
   if (print_missing_) write (*,"(a)") "missing " // trim(xfile)
end do
end function files_exist
!
subroutine vector_to_matrix_alloc_real(nrow,ncol,yvec,ymat)
integer      , intent(in)               :: nrow,ncol
real(kind=dp), intent(in)               :: yvec(:)
real(kind=dp), intent(out), allocatable :: ymat(:,:)
integer                                 :: nelem
character (len=*), parameter            :: msg="in vector_to_matrix_alloc_real, "
nelem = nrow*ncol
if (size(yvec) /= nelem) then
   write (*,*) msg,"nrow, ncol, nrow*ncol, size(yvec) =",nrow,ncol,nrow*ncol,size(yvec),"need nrow*ncol == size(yvec), STOPPING"
   stop
end if
call set_alloc(reshape(yvec,[nrow,ncol]),ymat)
end subroutine vector_to_matrix_alloc_real
!
function piecewise_constant(xx,update) result(yy)
real(kind=dp), intent(in) :: xx(:)        ! (n)
logical      , intent(in) :: update(:)    ! (n)
real(kind=dp)             :: yy(size(xx)) ! (n)
integer                   :: i,n
n = size(xx)
if (n < 1) return
yy(1) = xx(1)
do i=2,n
   if (update(i)) then
      yy(i) = xx(i)
   else
      yy(i) = yy(i-1)
   end if
end do
end function piecewise_constant
!
elemental function piecewise_linear(xx,x1,x2,y1,y2) result(yy)
! y ranges from y1 to y2 as x varies from x1 to x2 and is constant outside (x1,x2)
real(kind=dp), intent(in) :: xx,x1,x2,y1,y2
real(kind=dp)             :: yy
real(kind=dp)             :: slope,x12
x12 = x2 - x1
if (abs(x12) > 0.0_dp) then
   slope = (y2-y1)/x12
else
   slope = 0.0_dp
end if
if (xx <= x1) then
   yy = y1
else if (xx >= x2) then
   yy = y2
else
   yy = y1 + slope*(xx-x1)
end if
end function piecewise_linear
!
elemental function piecewise_sine(xx,x1,x2,y1,y2) result(yy)
! piecewise sine y ranges from y1 to y2 as x varies from x1 to x2 and is constant outside (x1,x2)
real(kind=dp), intent(in) :: xx,x1,x2,y1,y2
real(kind=dp)             :: yy
real(kind=dp)             :: x12,z
if (xx <= x1) then
   yy = y1
   return
else if (xx >= x2) then
   yy = y2
   return
end if
x12 = x2 - x1
if (x12 == 0.0_dp) return
z  = pi*((xx - x1)/x12 - 0.5_dp)
yy = (y2 - y1)*(1+sin(z))/2 + y1
end function piecewise_sine
!
subroutine append_str(base,new,combined)
! append new(:) to base(:) to create combined(:)
character (len=*), intent(in)               :: base(:),new(:)
character (len=*), intent(out), allocatable :: combined(:)
integer                                     :: nbase,nnew
nbase = size(base)
nnew  = size(new)
allocate (combined(nbase+nnew))
combined(:nbase) = base
combined(nbase+1:) = new
end subroutine append_str
!
function combine_str(xx,yy) result(zz)
character (len=*), intent(in) :: xx(:),yy(:)
character (len=100) :: zz(size(xx)+size(yy))
integer :: i,nx,ny
nx = size(xx)
ny = size(yy)
do i=1,nx+ny
   if (i <= nx) then
      zz(i) = trim(xx(i))
   else
      zz(i) = trim(yy(i-nx))
   end if
end do
end function combine_str
!
subroutine append_int(base,new,combined)
! for integer arrays, append new(:) to base(:) to create combined(:)
integer, intent(in)               :: base(:),new(:)
integer, intent(out), allocatable :: combined(:)
integer                           :: nbase,nnew
nbase = size(base)
nnew  = size(new)
allocate (combined(nbase+nnew))
combined(:nbase) = base
combined(nbase+1:) = new
end subroutine append_int
!
pure subroutine dealloc_char_vec(xx)
character (len=*), intent(in out), allocatable :: xx(:)
if (allocated(xx)) deallocate (xx)
end subroutine dealloc_char_vec
!
pure subroutine dealloc_real_vec(xx)
real(kind=dp), intent(in out), allocatable :: xx(:)
if (allocated(xx)) deallocate (xx)
end subroutine dealloc_real_vec
!
pure subroutine dealloc_real_matrix(xx)
real(kind=dp), intent(in out), allocatable :: xx(:,:)
if (allocated(xx)) deallocate (xx)
end subroutine dealloc_real_matrix
!
pure subroutine dealloc_real_tensor(xx)
real(kind=dp), intent(in out), allocatable :: xx(:,:,:)
if (allocated(xx)) deallocate (xx)
end subroutine dealloc_real_tensor
!
pure subroutine dealloc_int_vec(xx)
integer, intent(in out), allocatable :: xx(:)
if (allocated(xx)) deallocate (xx)
end subroutine dealloc_int_vec
!
pure subroutine dealloc_int_matrix(xx)
integer, intent(in out), allocatable :: xx(:,:)
if (allocated(xx)) deallocate (xx)
end subroutine dealloc_int_matrix
!
pure subroutine dealloc_int_tensor(xx)
integer, intent(in out), allocatable :: xx(:,:,:)
if (allocated(xx)) deallocate (xx)
end subroutine dealloc_int_tensor
!
pure subroutine dealloc_logical_vec(xx)
logical, intent(in out), allocatable :: xx(:)
if (allocated(xx)) deallocate (xx)
end subroutine dealloc_logical_vec
!
pure subroutine dealloc_logical_matrix(xx)
logical, intent(in out), allocatable :: xx(:,:)
if (allocated(xx)) deallocate (xx)
end subroutine dealloc_logical_matrix
!
pure subroutine dealloc_logical_tensor(xx)
logical, intent(in out), allocatable :: xx(:,:,:)
if (allocated(xx)) deallocate (xx)
end subroutine dealloc_logical_tensor
!
elemental function upper_case_str(input_string) result(output_string)
! convert string to upper case
character(*), intent(in)     :: input_string
character(len(input_string)) :: output_string
integer                      :: i, n
output_string = input_string
do i = 1, len(output_string)
   ! -- find location of letter in lower case constant string
   n = index(lower_case, output_string(i:i))
   ! -- if current substring is a lower case letter, make it upper case
   if (n /= 0) output_string(i:i) = upper_case(n:n)
end do
end function upper_case_str
!
elemental function lower_case_str(input_string) result(output_string)
! convert string to lower case
character(*), intent(in)     :: input_string
character(len(input_string)) :: output_string
integer                      :: i, n 
output_string = input_string
do i = 1, len(output_string)
   ! -- find location of letter in upper case constant string
   n = index(upper_case, output_string(i:i))
   ! -- if current substring is an upper case letter, make it lower case
   if (n /= 0) output_string(i:i) = lower_case(n:n)
end do
end function lower_case_str
!
elemental function max_optional_int(ii,jj) result(mmax)
integer, intent(in)           :: ii
integer, intent(in), optional :: jj
integer                       :: mmax
if (present(jj)) then
   mmax = max(ii,jj)
else
   mmax = ii
end if
end function max_optional_int
!
elemental function min_optional_int(ii,jj) result(mmin)
! return the minimum of ii and jj if jj is present, otherwise ii
integer, intent(in)           :: ii
integer, intent(in), optional :: jj
integer                       :: mmin
if (present(jj)) then
   mmin = min(ii,jj)
else
   mmin = ii
end if
end function min_optional_int
!
pure function ones_vec(n) result(xx)
integer, intent(in) :: n
real(kind=dp)       :: xx(n)
xx = 1.0_dp
end function ones_vec
!
subroutine write_tensor(tens,col_labels,outu,fmt_r,fmt_col_labels,title)
real(kind=dp)    , intent(in)           :: tens(:,:,:) ! (nobs,nrows,ncol)
character (len=*), intent(in), optional :: col_labels(:)      ! (ncol)
integer          , intent(in), optional :: outu
character (len=*), intent(in), optional :: fmt_r,fmt_col_labels,title
integer                                 :: i,irow,outu_,iobs,nobs,nrows
character (len=100)                     :: fmt_r_,fmt_col_labels_
call set_optional(fmt_r_  ,"(1000(f0.6,:,','))",fmt_r)
call set_optional(fmt_col_labels_,"(1000(a,:,','))",fmt_col_labels)
nobs  = size(tens,1)
nrows = size(tens,2)
outu_ = default(istdout,outu)
! print*,"fmt_col_labels_= '" // trim(fmt_col_labels_) // "'"
if (present(title))      write (outu_,"(a)") title
if (present(col_labels)) write (outu_,fmt_col_labels_) (trim(col_labels(i)),i=1,size(col_labels))
do iobs=1,nobs
   do irow=1,nrows
      write (outu_,fmt_r_) tens(iobs,irow,:)
   end do
   write (outu_,*)
end do
end subroutine write_tensor
!
subroutine reshape_matrix(xx,n1_new,n2_new,xfill)
real(kind=dp), intent(in out), allocatable :: xx(:,:)
integer      , intent(in)    , optional    :: n1_new,n2_new
real(kind=dp), intent(in)    , optional    :: xfill
integer                                    :: n1,n2,n1_new_,n2_new_
real(kind=dp), allocatable                 :: xtemp(:,:)
logical      , parameter                   :: print_debug=.false.
n1      = size(xx,1)
n2      = size(xx,2)
n1_new_ = default(n1,n1_new)
n2_new_ = default(n2,n2_new)
if (print_debug) then
   write (*,*)
   write (*,*) "in reshape_matrix, n1, n2, n1_new_, n2_new_=",n1,n2,n1_new_,n2_new_
end if
if (n1 == n1_new_ .or. n1_new_ < 0) then
   continue
else if (n1 >  n1_new_) then
   call set_alloc((xx(:n1_new_,:)),xx)
else
   allocate (xtemp(n1_new_,n2))
   xtemp = default(0.0_dp,xfill)
   xtemp(:n1,:) = xx
   call set_alloc(xtemp,xx)
   deallocate (xtemp)
end if
n1 = size(xx,1)
if (n2 == n2_new_ .or. n2_new_ < 0) then
   continue
else if (n2 >  n2_new_) then
   call set_alloc((xx(:,:n2_new_)),xx)
else
   allocate (xtemp(n1,n2_new_))
   xtemp = default(0.0_dp,xfill)
   xtemp(:,:n2) = xx
   call set_alloc(xtemp,xx)
end if
end subroutine reshape_matrix
!
subroutine combine_matrices(xx,yy,idim,combined)
! combine matrices xx and yy along dimension idim
real(kind=dp), intent(in)  :: xx(:,:),yy(:,:)
integer      , intent(in)  :: idim
real(kind=dp), allocatable, intent(out) :: combined(:,:)
integer                                 :: jdim,nx,ny,nnew,ncommon
character (len=*), parameter            :: msg="in combine_matrices, "
logical                                 :: print_debug_
print_debug_ = .false.
if (idim < 1 .or. idim > 2) then
   allocate (combined(0,0))
   return
end if
nx = size(xx,idim)
ny = size(yy,idim)
nnew  = nx + ny
jdim = 3 - idim
ncommon = size(xx,jdim)
if (size(yy,jdim) /= ncommon) then
   write (*,*) msg,"shape(xx)=",shape(xx)," shape(yy)=",shape(yy),"idim=",idim," not compatible, STOPPING"
   stop
end if
if (idim == 1) then
   allocate (combined(nnew,ncommon))
   combined(:nx,:) = xx
   if (ny > 0) combined(nx+1:,:) = yy
else
   allocate (combined(ncommon,nnew))
   combined(:,:nx) = xx
   if (ny > 0) combined(:,nx+1:) = yy
end if
if (print_debug_) then
   write (*,*) msg," idim =",idim
   write (*,*) "shape(xx)       =",shape(xx)
   write (*,*) "shape(yy)       =",shape(yy)
   write (*,*) "shape(combined) =",shape(combined)
   call print_matrix_simple(xx,title="xx")
   call print_matrix_simple(yy,title="yy")
   call print_matrix_simple(combined,title="combined")
end if
end subroutine combine_matrices
!
subroutine print_matrix_simple(xx,fmt_r,title,fmt_header,fmt_trailer,outu)
! write matrix xx(:,:)
real(kind=dp)    , intent(in)           :: xx(:,:) ! data to be written
character (len=*), intent(in), optional :: fmt_r   ! format to use in writing data
character (len=*), intent(in), optional :: title   ! title
character (len=*), intent(in), optional :: fmt_header,fmt_trailer ! formats to print at beginning and end of subroutine
integer          , intent(in), optional :: outu
character (len=100)                     :: fmt_r_
integer                                 :: i,outu_
outu_ = default(istdout,outu)
call set_optional(fmt_r_,"(1000(f10.4,1x))",fmt_r)
call write_format(fmt_header,outu_)
if (present(title)) write (outu_,*) title
if (size(xx) == 0) return
do i=1,size(xx,1)
   write (outu_,fmt_r_) xx(i,:)
end do
call write_format(fmt_trailer,outu_)
end subroutine print_matrix_simple
!
subroutine print_vector(xx,fmt_r,title,fmt_trailer,outu)
! print xx(:) to unit outu using format fmt_r
real(kind=dp)    , intent(in)           :: xx(:)
character (len=*), intent(in), optional :: fmt_r,title
character (len=*), intent(in), optional :: fmt_trailer
integer          , intent(in), optional :: outu
character (len=100)                     :: fmt_r_
integer                                 :: outu_
outu_ = default(istdout,outu)
call set_optional(fmt_r_,"(100f10.4)",fmt_r)
if (present(title)) write (outu_,*) title
if (size(xx) == 0) return
write (outu_,fmt_r_) xx
call write_format(fmt_trailer,outu_)
end subroutine print_vector
!
subroutine print_labeled_vec(sym,xx,sym_label,xlabel,outu,fmt_header,fmt_trailer,abs_min,print_num_printed, &
                             order,fmt_labels,fmt_sym_xx)
! print vector xx(:) with labels sym(:) and column names sym_label and xlabel
character (len=*), intent(in)           :: sym(:) ! (n)
real(kind=dp)    , intent(in)           :: xx(:)  ! (n)
character (len=*), intent(in)           :: sym_label,xlabel ! labels for character and real data
integer          , intent(in), optional :: outu
character (len=*), intent(in), optional :: fmt_header,fmt_trailer
real(kind=dp)    , intent(in), optional :: abs_min
logical          , intent(in), optional :: print_num_printed ! print the # of elements that will printed and the size of xx(:)
character (len=*), intent(in), optional :: order
character (len=*), intent(in), optional :: fmt_sym_xx,fmt_labels
integer                                 :: i,j,n,outu_,indx(size(xx))
real(kind=dp)                           :: abs_min_
character (len=100)                     :: fmt_labels_,fmt_sym_xx_
call set_optional(fmt_labels_,"(2a15)",fmt_labels)
call set_optional(fmt_sym_xx_,"(a15,f15.4)",fmt_sym_xx)
n = size(sym)
outu_ = default(istdout,outu)
call assert_equal("in print_labeled_vec, size(sym), size(xx) =",n,size(xx))
if (n < 1) return
abs_min_ = default(-1.0_dp,abs_min)
call write_format(fmt_header,outu_)
if (default(.false.,print_num_printed)) &
   write (outu_,"('#>=thresh, total =',2(1x,i0))") count(xx > abs_min_),size(xx)
indx = indexx_order(xx,order)
write (outu_,fmt_labels_) trim(sym_label),trim(xlabel)
do j=1,n
   i = indx(j)
   if (abs(xx(i)) >= abs_min_) write (outu_,fmt_sym_xx_) trim(sym(i)),xx(i)
end do
call write_format(fmt_trailer,outu_)
end subroutine print_labeled_vec
!
subroutine print_labeled_mat(sym,xx,sym_label,xlabel,outu,fmt_header,fmt_trailer,abs_min,print_num_printed, &
                             order,fmt_labels,fmt_sym_xx)
! print vector xx(:) with labels sym(:) and column names sym_label and xlabel
character (len=*), intent(in)           :: sym(:)    ! (n)
real(kind=dp)    , intent(in)           :: xx(:,:)   ! (n,ncol)
character (len=*), intent(in)           :: sym_label ! labels for character and real data
character (len=*), intent(in)           :: xlabel(:) ! (ncol)
integer          , intent(in), optional :: outu
character (len=*), intent(in), optional :: fmt_header,fmt_trailer
real(kind=dp)    , intent(in), optional :: abs_min
logical          , intent(in), optional :: print_num_printed ! print the # of elements that will printed and the size of xx(:)
character (len=*), intent(in), optional :: order
character (len=*), intent(in), optional :: fmt_sym_xx,fmt_labels
integer                                 :: i,j,n,outu_,indx(size(xx,1))
real(kind=dp)                           :: abs_min_
character (len=100)                     :: fmt_labels_,fmt_sym_xx_
call set_optional(fmt_labels_,"(1000a15)",fmt_labels)
call set_optional(fmt_sym_xx_,"(a15,1000f15.4)",fmt_sym_xx)
n = size(sym)
outu_ = default(istdout,outu)
call assert_equal("in print_labeled_mat, size(sym), size(xx) =",n,size(xx,1))
if (n < 1) return
abs_min_ = default(-1.0_dp,abs_min)
call write_format(fmt_header,outu_)
if (default(.false.,print_num_printed)) &
   write (outu_,"('#>=thresh, total, thresh, abs_min_ =',2(1x,i0),g12.6)") count(xx(:,1) > abs_min_),n,abs_min_
indx = indexx_order(xx(:,1),order)
write (outu_,fmt_labels_) trim(sym_label),(trim(xlabel(i)),i=1,size(xlabel))
do j=1,n
   i = indx(j)
   if (abs(xx(i,1)) >= abs_min_) write (outu_,fmt_sym_xx_) trim(sym(i)),xx(i,:)
end do
call write_format(fmt_trailer,outu_)
end subroutine print_labeled_mat
!
function sorted_real(xx) result(tf)
! return .true. if xx(:) is sorted in ascending order
real(kind=dp), intent(in) :: xx(:)
logical                   :: tf
integer                   :: i,n
tf = .true.
n  = size(xx)
do i=1,n-1
   if (xx(i) > xx(i+1)) then
      tf = .false.
      exit
   end if
end do
end function sorted_real
!
subroutine remove_zero_rows(xmat)
! remove rows of xmat(:,:) for which all elements are zero
real(kind=dp), intent(in out), allocatable :: xmat(:,:)
integer                      , allocatable :: isel(:)
integer                                    :: i,nrows
nrows = size(xmat,1)
allocate (isel(nrows))
isel = 0
do i=1,nrows
   isel(i) = merge(i,0,maxval(abs(xmat(i,:))) > tiny_real)
end do
call set_alloc((xmat(pack(isel,isel>0),:)),xmat)
end subroutine remove_zero_rows
!
function nonzero_columns(xmat,thresh) result(icol)
! return in icol(:) the locations of the columns in xmat that have any nonzero elements
real(kind=dp), intent(in)           :: xmat(:,:)
real(kind=dp), intent(in), optional :: thresh
integer      , allocatable          :: icol(:)
integer                             :: i,ncol
real(kind=dp)                       :: thresh_
thresh_ = default(tiny_real,thresh)
ncol    = size(xmat,2)
allocate (icol(ncol))
icol = 0
do i=1,ncol
   if (any(abs(xmat(:,i)) > thresh_)) icol(i) = i
end do
call set_alloc(pack(icol,icol>0),icol)
end function nonzero_columns
!
subroutine remove_zero_columns(xmat)
! remove columns of xmat(:,:) for which all elements are zero
real(kind=dp), intent(in out), allocatable :: xmat(:,:)
integer                      , allocatable :: isel(:)
integer                                    :: i,ncol
ncol = size(xmat,2)
allocate (isel(ncol))
isel = 0
do i=1,ncol
   isel(i) = merge(i,0,maxval(abs(xmat(:,i))) > tiny_real)
end do
call set_alloc((xmat(:,pack(isel,isel>0))),xmat)
end subroutine remove_zero_columns
!
subroutine remove_duplicate_columns(xmat,thresh,isel)
! remove columns of xmat(:,:) whose elements are the same as other another column
real(kind=dp), intent(in out), allocatable           :: xmat(:,:)
real(kind=dp), intent(in)    , optional              :: thresh
integer      , intent(out)   , optional, allocatable :: isel(:)
real(kind=dp)                              :: thresh_
integer                      , allocatable :: jsel(:)
integer                                    :: i,j,ncol
logical                                    :: duplicate
ncol = size(xmat,2)
if (ncol < 1) return
thresh_ = default(tiny_real,thresh)
allocate (jsel(ncol))
jsel    = 0
jsel(1) = 1
do i=2,ncol
   duplicate = .false.
   do j=1,i-1
      if (all(abs(xmat(:,i)-xmat(:,j)) <= thresh_)) then
         duplicate = .true.
         exit
      end if
   end do
   jsel(i) = merge(0,i,duplicate)
end do
call set_alloc((xmat(:,pack(jsel,jsel>0))),xmat)
if (present(isel)) call set_alloc(pack(jsel,jsel>0),isel)
end subroutine remove_duplicate_columns
!
subroutine skip_lines(nlines,iu,xaction)
integer          , intent(in) :: nlines
integer          , intent(in) :: iu
character (len=*), intent(in) :: xaction
integer :: i
if (xaction == "r") then
   do i=1,nlines
      read (iu,*)
   end do
end if
end subroutine skip_lines
!
subroutine skip_lines_unit(iu,nlines)
integer, intent(in)           :: iu
integer, intent(in), optional :: nlines
integer                       :: i
if (.not. present(nlines)) return
do i=1,nlines
   read (iu,*)
end do
end subroutine 
!
function short_file_name(fname) result(yy)
! remove the directory from a file name
character (len=*), intent(in) :: fname
character (len=100)           :: yy
integer                       :: ipos
ipos = index(fname,"\",back=.true.)
if (ipos < len(yy)) then
   yy = fname(ipos+1:)
else
   yy = fname
end if
end function short_file_name
!
function base_file_name(fname) result(yy)
! remove extensions (text following the last ".") from Windows file names
character (len=*), intent(in) :: fname
character (len=100)           :: yy
integer                       :: ipos
yy   = short_file_name(fname)
ipos = index(yy,".",back=.true.)
if (ipos > 0) then
   yy = trim(yy(:ipos-1))
end if
end function base_file_name
!
function order_distance(xx,xvec) result(nd)
real(kind=dp), intent(in) :: xx,xvec(:)
integer                   :: nd
integer                   :: i,n
n = size(xvec)
nd = 0
do i=1,n
   if (xvec(i) == xx) then
      continue
   else if (xvec(i) > xx) then
      nd = nd + 1
   else
      nd = nd - 1
   end if
end do
end function order_distance
!
function match_category_string_scalar(xx,sym,sym_cat,categories) result(icat)
character (len=*), intent(in) :: xx
character (len=*), intent(in) :: sym(:),sym_cat(:) ! (n)
character (len=*), intent(in) :: categories(:)
integer                       :: icat
integer                       :: i,jcat,n
icat = 0
n = size(sym)
if (size(sym_cat) /= n) then
   write (*,*) "in match_category_string, size(sym), size(sym_cat)=",n,size(sym_cat)," must be equal, STOPPING"
   stop
end if
do i=1,n
   if (xx == sym(i)) then
      do jcat=1,size(categories)
         if (sym_cat(i) == categories(jcat)) then
            icat = jcat
            return
         end if
      end do
   end if
end do
end function match_category_string_scalar
!
function match_category_string_vec(xx,sym,sym_cat,categories) result(icat)
character (len=*), intent(in) :: xx(:)
character (len=*), intent(in) :: sym(:),sym_cat(:) ! (n)
character (len=*), intent(in) :: categories(:)
integer                       :: icat(size(xx))
integer                       :: i
do i=1,size(xx)
   icat(i) = match_category_string_scalar(xx(i),sym,sym_cat,categories)
end do
end function match_category_string_vec
!
pure function match_int_scalar(ii,ivec) result(ipos)
! return the position of the first element in ivec that
! matches ii, 0 otherwise
integer, intent(in) :: ii,ivec(:)
integer             :: ipos
integer             :: j
ipos = 0
do j=1,size(ivec)
   if (ivec(j) == ii) then
   ipos = j
   return
   end if
end do
end function match_int_scalar
!
pure function match_int_vec(ii,ivec) result(ipos)
! return the position of the first element in ivec that
! matches ii, 0 otherwise
integer, intent(in) :: ii(:),ivec(:)
integer             :: ipos(size(ii))
integer             :: i
forall (i=1:size(ii)) ipos(i) = match_int_scalar(ii(i),ivec)
end function match_int_vec
!
pure function match_string_scalar(ii,ivec) result(ipos)
! return the position of the first element in ivec that
! matches ii, 0 otherwise
character (len=*), intent(in) :: ii,ivec(:)
integer                       :: ipos
integer                       :: j
ipos = 0
do j=1,size(ivec)
   if (ivec(j) == ii) then
   ipos = j
   return
   end if
end do
end function match_string_scalar
!
pure function matching_pos_string(ii,ivec) result(ipos)
! return in ipos the positions of ivec that match elements of ii, excluding elements of ii with no matches
character (len=*), intent(in)  :: ii(:),ivec(:)
integer          , allocatable :: ipos(:)
integer                        :: jpos(size(ii))
jpos = match_string_vec(ii,ivec)
call set_alloc(pack(jpos,jpos>0),ipos)
end function matching_pos_string
!
pure function match_string_vec(ii,ivec) result(ipos)
! return the position of the first element in ivec that
! matches ii, 0 otherwise
character (len=*), intent(in) :: ii(:),ivec(:)
integer                       :: ipos(size(ii))
integer                       :: i
forall (i=1:size(ii)) ipos(i) = match_string_scalar(ii(i),ivec)
end function match_string_vec
!
subroutine match_integer_matrix(xnames,ynames,idir,jdir,outu)
character (len=*), intent(in)     :: xnames(:),ynames(:)
integer          , intent(in)     :: idir(:,:)
integer          , intent(in out) :: jdir(:,:)
integer          , intent(in), optional :: outu
integer                           :: i,j,ii,jj,nx,ny,outu_
outu_ = default(istdout,outu)
nx = size(xnames)
ny = size(ynames)
do i=1,nx
   ii = match_string_scalar(xnames(i),ynames)
   if (ii == 0) then
      write (outu_,*) "WARNING: no match for symbol ",trim(xnames(i))," in ", &
                  (trim(ynames(j)) // " ",j=1,ny)
      cycle
   end if
   do j=1,nx
      jj = match_string_scalar(xnames(j),ynames)
      if (jj > 0) jdir(i,j) = idir(ii,jj)
   end do
end do
end subroutine match_integer_matrix
!
subroutine write_words(label,words,fmt_c,outu)
character (len=*), intent(in)           :: label,words(:)
character (len=*), intent(in)           :: fmt_c
integer          , intent(in), optional :: outu
integer                                 :: i,outu_,nw
outu_ = default(istdout,outu)
nw = size(words)
write (outu_,fmt_c) trim(label),(trim(words(i)),i=1,nw)
end subroutine write_words
!
elemental function rbinary(xx) result(yy)
real(kind=dp), intent(in) :: xx
real(kind=dp)             :: yy
yy = merge(1.0_dp,0.0_dp,xx>0.0_dp)
end function rbinary
!
function moving_average(xx,n1,n2) result(xma)
! simple moving average using terms n1 to n2
real(kind=dp), intent(in) :: xx(:)
integer      , intent(in) :: n1,n2
real(kind=dp)             :: xma(size(xx))
integer                   :: i,i1,i2,n,n12
xma = 0.0_dp
n = size(xx)
if (n < 1) return
do i=1,n
   i2 = min(n,max(1,i-n1+1))
   i1 = min(n,max(1,i-n2+1))
   n12 = i2 - i1 + 1
   if (n12 > 0) xma(i) = sum(xx(i1:i2))/n12
end do
end function moving_average
!
function exp_ma(xx,alpha) result(yy)
! exponential moving average
real(kind=dp), intent(in) :: xx(:)
real(kind=dp), intent(in) :: alpha
real(kind=dp)             :: yy(size(xx))
integer                   :: i,n
n = size(xx)
if (n < 1) return
if (alpha == 1.0_dp) then
   yy = xx
   return
end if
yy(1) = xx(1)
do i=2,n
   yy(i) = alpha*xx(i) + (1-alpha)*yy(i-1)
end do
end function exp_ma
!
subroutine realloc_real(n,xx,xdef)
! allocate xx to size n and set elements to xdef if present
integer      , intent(in)                  :: n
real(kind=dp), intent(in out), allocatable :: xx(:)
real(kind=dp), intent(in)    , optional    :: xdef
integer                                    :: n_
n_ = max(0,n)
if (allocated(xx)) then
   if (size(xx) == n_) return
   deallocate (xx)
end if
allocate (xx(n_))
if (present(xdef)) xx = xdef
end subroutine realloc_real
!
subroutine realloc_logical(n,xx,xdef)
! allocate xx to size n and set elements to xdef if present
integer      , intent(in)                  :: n
logical      , intent(in out), allocatable :: xx(:)
logical      , intent(in)    , optional    :: xdef
integer                                    :: n_
n_ = max(0,n)
if (allocated(xx)) then
   if (size(xx) == n_) return
   deallocate (xx)
end if
allocate (xx(n_))
if (present(xdef)) xx = xdef
end subroutine realloc_logical
!
subroutine realloc_integer(n,xx,xdef)
! allocate xx to size n and set elements to xdef if present
integer      , intent(in)                  :: n
integer      , intent(in out), allocatable :: xx(:)
integer      , intent(in)    , optional    :: xdef
integer                                    :: n_
n_ = max(0,n)
if (allocated(xx)) then
   if (size(xx) == n_) return
   deallocate (xx)
end if
allocate (xx(n_))
if (present(xdef)) xx = xdef
end subroutine realloc_integer
!
elemental function sine_bound(xx) result(yy)
! takes on value -1 for xx <= -1, 1 for xx >= 1, varies smoothly in between
real(kind=dp), intent(in) :: xx
real(kind=dp)             :: yy
yy = sin(min(pi/2,max(-pi/2,0.5_dp*pi*xx)))
end function sine_bound
!
elemental function half_sine_bound(xx) result(yy)
! takes on value -1 for xx <= -1, 1 for xx >= 1, varies smoothly in between
real(kind=dp), intent(in) :: xx
real(kind=dp)             :: yy
yy = sin(min(pi/2,max(0.0_dp,0.5_dp*pi*xx)))
end function half_sine_bound
!
elemental function sine_transform(xx,x1,x2,y1,y2) result(yy)
! ranges from y1 to y2 as x varies from x1 to x2
real(kind=dp), intent(in) :: xx,x1,x2,y1,y2
real(kind=dp)             :: yy
real(kind=dp)             :: arg,dx
dx = x2 - x1
if (abs(dx) > tiny_real) then
   arg = 0.5*pi*min(1.0_dp,max(-1.0_dp,-1.0_dp + 2*(xx-x1)/dx))
else
   arg = 0.0_dp
end if
yy = sin(arg)
yy = 0.5_dp*(y2-y1)*yy + 0.5_dp*(y1+y2)
end function sine_transform
!
elemental function half_sine_transform(xx,x1,x2,y1,y2) result(yy)
! ranges from y1 to y2 as x varies from x1 to x2
real(kind=dp), intent(in) :: xx,x1,x2,y1,y2
real(kind=dp)             :: yy
real(kind=dp)             :: arg,dx
dx = x2 - x1
if (abs(dx) > tiny_real) then
   arg = 0.5*pi*min(1.0_dp,max(0.0_dp,(xx-x1)/dx))
else
   arg = 0.0_dp
end if
yy = sin(arg)
yy = y1 + (y2-y1)*yy ! 0.5_dp*(y2-y1)*yy + 0.5_dp*(y1+y2)
end function half_sine_transform
!
function duration(xx) result(ndur)
! length of time xx has been consecutively positive or negative
real(kind=dp), intent(in) :: xx(:)
integer                   :: ndur(size(xx))
integer                   :: i,n,old_dur
n = size(xx)
if (n < 1) return
old_dur = 0
do i=1,n
   if (xx(i) > 0) then
      ndur(i) = max(0,old_dur) + 1
   else if (xx(i) < 0) then
      ndur(i) = min(0,old_dur) - 1
   else
      ndur(i) = 0
   end if
   old_dur = ndur(i)
end do
end function duration
!
elemental function signed_power(xx,pow) result(yy)
! signed power transform -- monotonic for all pow
real(kind=dp), intent(in) :: pow
real(kind=dp), intent(in) :: xx
real(kind=dp)             :: yy
yy = power_transform(pow,xx)
end function signed_power
!
elemental function power_transform(pow,xx) result(yy)
! signed power transform -- monotonic for all pow
real(kind=dp), intent(in) :: pow
real(kind=dp), intent(in) :: xx
real(kind=dp)             :: yy
if (xx == 0.0_dp) then
   yy = 0.0_dp
   return
end if
yy = merge(1,-1,xx>0)*abs(xx)**pow
end function power_transform
!
elemental function round_less(xspacing,xx) result(yy)
real(kind=dp), intent(in) :: xspacing,xx
real(kind=dp)             :: yy
if (xx < 0.0_dp) then
   yy = -round_up(xspacing,-xx)
   return
end if
if (abs(xspacing) < tiny_real .or. abs(xx) < tiny_real) then
   yy = xx
   return
end if
yy = int(xx/xspacing)*xspacing
end function round_less
!
elemental function round_up(xspacing,xx) result(yy)
! round xx to a larger magnitude on a grid with spacing xspacing
! For example, round_up(0.5_dp,2.1_dp) = 2.5_dp, round_up(0.5_dp,-2.3_dp) = -2.5_dp
real(kind=dp), intent(in) :: xspacing,xx
real(kind=dp)             :: yy
integer                   :: n
real(kind=dp)             :: xround
if (abs(xspacing) < tiny_real .or. abs(xx) < tiny_real) then
   yy = xx
   return
end if
n = int(xx/xspacing)
xround = n*xspacing
if (xx > 0) then
   if (xx <= xround) then
      yy = xround
   else
      yy = xround + xspacing
   end if
else
   if (xx >= xround) then
      yy = xround
   else
      yy = xround - xspacing
   end if
end if
end function round_up
!
function grid_round(xspacing,x1,x2) result(yy)
! return a grid with with points at multiples of xspacing that contains (x1,x2)
real(kind=dp), intent(in)  :: xspacing,x1,x2
real(kind=dp), allocatable :: yy(:)
real(kind=dp)              :: y1,y2
integer                    :: i,ierr,ny
! y1 = round_up(xspacing,x1)
y1 = round_less(xspacing,x1)
y2 = round_up(xspacing,x2)
ny = nint((y2-y1)/xspacing) + 1
allocate (yy(ny),stat=ierr)
if (ierr /= 0) then
   write (*,*) "in ",mod_name // "::grid_round, could not allocate yy(ny) for ny =",ny
   allocate (yy(0))
   return
end if
forall (i=1:ny) yy(i) = y1 + (i-1)*xspacing
end function grid_round
!
function ts_transform_matrix(trans,xx) result(yy)
character (len=*), intent(in) :: trans
real(kind=dp), intent(in) :: xx(:,:)
real(kind=dp), allocatable :: yy(:,:)
integer                    :: i,ncol,nobs,ny
character (len=*), parameter :: msg = "in ts_transform_matrix, "
ncol = size(xx,2)
nobs = size(xx,1)
if (trans == str_ratio_diff) then
   ny = max(0,nobs - 1)
   allocate (yy(ny,ncol))
   if (ny == 0) return
   yy = xx(2:,:)/xx(:ny,:) - 1.0_dp
else if (trans == str_diff) then
   ny = max(0,nobs - 1)
   allocate (yy(ny,ncol))
   if (ny == 0) return
   yy = xx(2:,:) - xx(:ny,:)
else if (trans == str_none) then
   call set_alloc(xx,yy)
else
   write (*,*) msg,"trans = '" // trim(trans) // "' is invalid"
   write (*,*) "must be one of", &
               (" '" // trim(str_trans(i)) // "'",i=1,size(str_trans))
   write (*,*) "STOPPING"
   stop
end if
end function ts_transform_matrix
!
function running_sum(nterms,xx) result(yy)
! return a running sum using nterms values of xx(:) for each element
integer      , intent(in) :: nterms
real(kind=dp), intent(in) :: xx(:)
real(kind=dp)             :: yy(size(xx)-nterms+1)
integer                   :: i
if (nterms > 0) then
   do i=1,size(yy)
      yy(i) = sum(xx(i:i+nterms-1))
!      yy(i-nterms+1) = sum(xx(i:i+nterms-1))
   end do
end if
end function running_sum
!
subroutine zero_small_changes(xx,min_change,max_change)
! set small changes in xx(:) to zero
real(kind=dp), intent(in out) :: xx(:)
real(kind=dp), intent(in)     :: min_change,max_change
integer                       :: i,n
real(kind=dp)                 :: dx
n = size(xx)
do i=2,n
   dx = xx(i) - xx(i-1)
   if (dx >= min_change .and. dx <= max_change) xx(i) = xx(i-1)
end do
end subroutine zero_small_changes
!
subroutine bands(band_inner,band_outer,abs_min,xx,nunch)
! at each time, if position deviation exceeds band_outer,
! trade so that position is within band_inner of target
real(kind=dp), intent(in)     :: band_inner,band_outer
real(kind=dp), intent(in)     :: abs_min ! minimum absolute positions (set smaller positions to zero)
real(kind=dp), intent(in out) :: xx(:)
integer      , intent(out), optional :: nunch
integer                       :: i,n,nunch_
real(kind=dp)                 :: x1,x2
n = size(xx)
nunch_ = 0
do i=2,n
   if (abs(xx(i)) < abs_min) xx(i) = 0.0_dp
   x1 = xx(i) - band_outer
   x2 = xx(i) + band_outer
   if (xx(i-1) < x1) then
      xx(i) = xx(i) - band_inner
   else if (xx(i-1) > x2) then
      xx(i) = xx(i) + band_inner
   else
      xx(i)  = xx(i-1)
      nunch_ = nunch_ + 1
   end if
end do
if (present(nunch)) nunch = nunch_
end subroutine bands
!
function bounded_time_series(xx,ret_min,ret_max) result(yy)
! bound the returns of a time series
real(kind=dp), intent(in) :: xx(:),ret_min,ret_max
real(kind=dp)             :: yy(size(xx))
integer                   :: i,n
real(kind=dp)             :: ret
n = size(xx)
if (n < 1) return
yy(1) = xx(1)
do i=2,n
   ret = xx(i)/xx(i-1) - 1.0_dp
   yy(i) = yy(i-1)*(1+min(ret_max,max(ret_min,ret)))
end do
end function bounded_time_series
!
pure function tail_int(xx) result(yy)
! return the last element of xx(:)
integer, intent(in) :: xx(:)
integer             :: yy
integer             :: n
n = size(xx)
if (n > 0) then
   yy = xx(n)
else
   yy = bad_int
end if
end function tail_int
!
pure function tail_real(xx) result(yy)
! return the last element of xx(:)
real(kind=dp), intent(in) :: xx(:)
real(kind=dp)             :: yy
integer                   :: n
n = size(xx)
if (n > 0) then
   yy = xx(n)
else
   yy = bad_real
end if
end function tail_real
!
function last_real(n,xx) result(yy)
! return a vector with the last min(n,size(xx)) observations of xx
integer, intent(in) :: n
real(kind=dp), intent(in)  :: xx(:)
real(kind=dp), allocatable :: yy(:)
integer                    :: i1,nobs
nobs = size(xx)
if (n < 1 .or. nobs < 1) then
   allocate (yy(0))
   return
end if
i1 = max(1,nobs-n+1)
call set_alloc(xx(i1:),yy)
end function last_real
!
function positive_int_vec(ivec) result(jvec)
integer, intent(in) :: ivec(:)
integer             :: jvec(count(ivec>0))
jvec = pack(ivec,ivec>0)
end function positive_int_vec
!
subroutine interpolate_matrix_summarize(good,xorig,xx,outu,labels,fmt_header)
! interpolate data using average of data before and after
logical      , intent(in)  :: good(:,:)
real(kind=dp), intent(in)  :: xorig(:,:)
real(kind=dp), intent(out) :: xx(:,:)
integer, intent(in)        :: outu
character (len=*), intent(in) :: labels(:)
character (len=*), intent(in), optional :: fmt_header
integer                    :: icol,ncol,n,nbad
ncol = size(xx,2)
n    = size(xx,1)
if (size(good,1) /= n .or. size(good,2) /= ncol .or. size(xorig,1) /= n .or. size(xorig,2) /= ncol) then
   print*,"in interpolate_matrix, shape(good)=",shape(good), &
          " shape(xorig)=",shape(xorig)," shape(xx)=",shape(xx)," should all be equal, STOPPING"
   stop
end if
if (present(fmt_header)) then
   if (fmt_header /= "") write (outu,fmt_header)
end if
do icol=1,ncol
   call interpolate_vec(good(:,icol),xorig(:,icol),xx(:,icol))
   nbad = count(.not. good(:,icol))
   write (outu,"(a,',',i0,',',f0.1)") trim(labels(icol)),nbad,nbad*100.0_dp/max(1,n)
end do
end subroutine interpolate_matrix_summarize
!
subroutine interpolate_matrix(good,xorig,xx)
! interpolate data using average of data before and after
logical      , intent(in)  :: good(:,:)
real(kind=dp), intent(in)  :: xorig(:,:)
real(kind=dp), intent(out) :: xx(:,:)
integer                    :: icol,ncol,n
ncol = size(xx,2)
n    = size(xx,1)
if (size(good,1) /= n .or. size(good,2) /= ncol .or. size(xorig,1) /= n .or. size(xorig,2) /= ncol) then
   print*,"in interpolate_matrix, shape(good)=",shape(good), &
          " shape(xorig)=",shape(xorig)," shape(xx)=",shape(xx)," should all be equal, STOPPING"
   stop
end if
do icol=1,ncol
   call interpolate_vec(good(:,icol),xorig(:,icol),xx(:,icol))
end do
end subroutine interpolate_matrix
!
subroutine interpolate_vec(good,xorig,xx)
! interpolate data using average of data before and after
logical      , intent(in)  :: good(:)
real(kind=dp), intent(in)  :: xorig(:)
real(kind=dp), intent(out) :: xx(:)
integer                    :: i,ibef,iaft,n
n = size(good)
if (any([size(xorig), size(xx)] /= n)) then
   write (*,*) "in interpolate_vec, size(good), size(xorig), size(xx) =", &
               n,size(xorig),size(xx)," must be equal, STOPPING"
   stop
end if
do i=1,n
   if (good(i)) then
      xx(i) = xorig(i)
   else
      ibef = last_true(good(:i-1))
      iaft = first_true(good(i+1:))
      if (iaft /= 0) iaft = iaft + i
      if (ibef > 0 .and. iaft > 0) then
         xx(i) = (xorig(ibef) + xorig(iaft))/2
      else if (ibef > 0) then
         xx(i) = xorig(ibef)
      else if (iaft > 0) then
         xx(i) = xorig(iaft)
      end if
   end if
end do
end subroutine interpolate_vec
!
function fill_bad(xx,xgood) result(yy)
real(kind=dp), intent(in) :: xx(:)
logical      , intent(in) :: xgood(:)
real(kind=dp)             :: yy(size(xx))
integer                   :: i
real(kind=dp)             :: last_good
last_good = 0.0_dp
do i=1,size(xx)
   if (xgood(i)) then
      last_good = xx(i)
      yy(i) = xx(i)
   else
      yy(i) = last_good
   end if
end do
end function fill_bad
!
subroutine fill_previous(xdata,xgood,ydata,ygood)
real(kind=dp), intent(in)  :: xdata(:) ! (n)
logical      , intent(in)  :: xgood(:) ! (n)
real(kind=dp), intent(out) :: ydata(:) ! (n)
logical      , intent(out) :: ygood(:) ! (n)
integer                    :: i,ilast_good,n
n = size(xdata)
if (any([size(xgood),size(ydata),size(ygood)] /= n)) then
   write (*,*) "in util_mod::fill_previous, sizes of xdata, xgood, ydata, ygood are ",n,[size(xgood),size(ydata),size(ygood)], &
               "must be equal, STOPPING"
   stop
end if
ilast_good = 0
ygood      = .false.
ydata      = bad_real
do i=1,n
   if (xgood(i)) ilast_good = i
   if (ilast_good > 0) then
      ydata(i) = xdata(ilast_good)
      ygood(i) = .true.
   end if
end do
end subroutine fill_previous
!
pure function first_true(tf) result(i1)
! return the location of the first true element in tf(:), 0 if none true
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
subroutine fill_vec(good,xvec,nfilled,fill_initial)
! fill data in xvec(:) using earlier data when data is not good
logical      , intent(in)    :: good(:)
real(kind=dp), intent(inout) :: xvec(:)
integer      , intent(out), optional :: nfilled ! # of values filled
integer                      :: i,i1,n
real(kind=dp)                :: xgood
logical, intent(in), optional :: fill_initial
logical                      :: found_good_value
nfilled = 0
n = size(good)
if (size(xvec) /= n) then
   write (*,*) "in fill_vec, size(good), size(xvec) =",size(good),size(xvec)," must be equal, STOPPING"
   stop
end if
found_good_value = .false.
if (default(.false.,fill_initial)) then
   i1 = first_true(good)
   if (i1 > 1) then
      xgood = xvec(i1)
      xvec(1:i1-1) = xgood
      nfilled = nfilled + i1 - 1
      found_good_value = .true.
   else
      i1 = 1
   end if
else
   i1 = 1
end if
do i=i1,n
   if (good(i)) then
      xgood = xvec(i)
      found_good_value = .true.
   else
      if (i > 1 .and. found_good_value) then
         xvec(i) = xgood
         nfilled = nfilled + 1
      end if
   end if
end do
end subroutine fill_vec
!
subroutine fill_panel(xx,labels_2,labels_3,fill_initial,min_good_value,write_interp_stats)
real(kind=dp)    , intent(in out) :: xx(:,:,:)
character (len=*), intent(in)     :: labels_2(:),labels_3(:)
real(kind=dp)    , intent(in)     :: min_good_value
logical          , intent(in)     :: fill_initial,write_interp_stats
integer                           :: i2,i3,n2,n3
integer, allocatable              :: nfilled(:,:),nbad(:,:)
logical :: good(size(xx,1))
n2 = size(xx,2)
n3 = size(xx,3)
allocate (nfilled(n2,n3),nbad(n2,n3))
if (write_interp_stats) write (*,"(/,'#points filled',/,a20,a8,3x,100a6)") "var","pts",labels_2
do i3=1,n3
   do i2=1,n2
      good = xx(:,i2,i3) > min_good_value
      nbad(i2,i3) = count(.not. good)
      ! output: xx, nfilled
      call fill_vec(good,xx(:,i2,i3),nfilled(i2,i3),fill_initial=fill_initial)
   end do
   if (write_interp_stats) then
      write (*,"(a20,a8,100i6)") trim(labels_3(i3)),"bad",nbad(:,i3)
      write (*,"(a20,a8,100i6)") trim(labels_3(i3)),"filled",nfilled(:,i3)
      write (*,"(a20,a8,100i6)") trim(labels_3(i3)),"remain",nbad(:,i3)-nfilled(:,i3)
   end if
end do
end subroutine fill_panel
!
subroutine fill_matrix_by_row(good,xmat)
! for each row of a matrix, fill positions with data from earlier positions if necessary
logical      , intent(in)     :: good(:,:) ! (n1,n2)
real(kind=dp), intent(in out) :: xmat(:,:) ! (n1,n2)
integer :: i,j,n1,n2
real(kind=dp) :: base
n1 = size(good,1)
n2 = size(good,2)
if (size(xmat,1) /= n1 .or. size(xmat,2) /= n2) then
   write (*,*) "in fill_matrix_by_row, shape(good)=",shape(good)," shape(xmat)=",shape(xmat), &
               " must be equal, STOPPING"
   stop
end if
if (n2 < 2) return
do i=1,n1
   base = xmat(i,1)
   do j=2,n2
      if (good(i,j)) then
         base = xmat(i,j)
      else
         xmat(i,j) = base
      end if
   end do
end do
end subroutine fill_matrix_by_row
!
function all_columns_equal_char(xmat) result(tf)
character (len=*), intent(in) :: xmat(:,:)
logical                       :: tf
integer                       :: i,ncol
ncol = size(xmat,2)
tf = .true.
if (ncol < 2) return
do i=2,ncol
   tf = all(xmat(:,i) == xmat(:,1))
   if (.not. tf) return
end do
end function all_columns_equal_char
!
function nearest_element_real(xx,xvec) result(yy)
! return in yy the value of the element of xvec(:) that is closest to xx (in absolute deviation terms)
real(kind=dp), intent(in) :: xx
real(kind=dp), intent(in) :: xvec(:)
real(kind=dp)             :: yy
integer                   :: i,n
real(kind=dp)             :: dist,min_dist
n = size(xvec)
if (n < 1) return
yy = xvec(1)
min_dist = abs(xx-xvec(1))
do i=2,n
   dist = abs(xx-xvec(i))
   if (dist < min_dist) then
      min_dist = dist
      yy = xvec(i)
   end if
end do
end function nearest_element_real
!
! function first_repeat(ivec) result(tf)
! integer, intent(in) :: ivec(:)
! logical             :: tf(size(ivec))
! integer             :: i
! do i=1,size(ivec)-1
!    tf(i) = (ivec(i) == ivec(i+1))
! end do
! end function first_repeats
!
function single_integer(ivec) result(tf)
! return .true. at the locations of ivec with values that differ from previous and subsequent elements
integer, intent(in) :: ivec(:)
logical             :: tf(size(ivec))
integer             :: i,n
n = size(ivec)
if (n <= 1) then
   tf = .true.
   return
end if
  do i=1,n
   if (i == 1) then
      tf(i) = ivec(i+1) /= ivec(i)
   else if (i == n) then
      tf(i) = ivec(i-1) /= ivec(i)
   else
      tf(i) = (ivec(i)  /= ivec(i-1)) .and. (ivec(i) /= ivec(i+1))
   end if
end do
end function single_integer
!
function single_real(xvec) result(tf)
! return .true. at the locations of xvec with values that differ from previous and subsequent elements
real(kind=dp), intent(in) :: xvec(:)
logical             :: tf(size(xvec))
integer             :: i,n
n = size(xvec)
if (n <= 1) then
   tf = .true.
   return
end if
do i=1,n
   if (i == 1) then
      tf(i) = xvec(i+1) /= xvec(i)
   else if (i == n) then
      tf(i) = xvec(i-1) /= xvec(i)
   else
      tf(i) = (xvec(i)  /= xvec(i-1)) .and. (xvec(i) /= xvec(i+1))
   end if
end do
end function single_real
!
subroutine timestamp(timestring)
implicit none
character (len=*), intent(out), optional :: timestring
!*****************************************************************************80
!
!! TIMESTAMP prints the current YMDHMS date as a time stamp.
!
!  Example:
!
!    May 31 2001   9:45:54.872 AM
!
!  Licensing:
!
!    This code is distributed under the GNU LGPL license.
!
!  Modified:
!
!    31 May 2001
!
!  Author:
!
!    John Burkardt
!
!  Parameters:
!
!    None
!
  character ( len = 8 )  ampm
  integer   ( kind = 4 ) d
  character ( len = 8 )  date
  integer   ( kind = 4 ) h
  integer   ( kind = 4 ) m
  integer   ( kind = 4 ) mm
  character ( len = 9 ), parameter, dimension(12) :: month = (/ &
    'January  ', 'February ', 'March    ', 'April    ', &
    'May      ', 'June     ', 'July     ', 'August   ', &
    'September', 'October  ', 'November ', 'December ' /)
  integer   ( kind = 4 ) n
  integer   ( kind = 4 ) s
  character ( len = 10 ) time
  integer   ( kind = 4 ) values(8)
  integer   ( kind = 4 ) y
  character ( len = 5 )  zone

  call date_and_time ( date, time, zone, values )

  y = values(1)
  m = values(2)
  d = values(3)
  h = values(5)
  n = values(6)
  s = values(7)
  mm = values(8)

  if ( h < 12 ) then
    ampm = 'AM'
  else if ( h == 12 ) then
    if ( n == 0 .and. s == 0 ) then
      ampm = 'Noon'
    else
      ampm = 'PM'
    end if
  else
    h = h - 12
    if ( h < 12 ) then
      ampm = 'PM'
    else if ( h == 12 ) then
      if ( n == 0 .and. s == 0 ) then
        ampm = 'Midnight'
      else
        ampm = 'AM'
      end if
    end if
  end if
if (present(timestring)) then
  write (timestring, '(a,1x,i2,1x,i4,2x,i2,a1,i2.2,a1,i2.2,a1,i3.3,1x,a)' ) &
    trim ( month(m) ), d, y, h, ':', n, ':', s, '.', mm, trim ( ampm )
else
  write ( *, '(a,1x,i2,1x,i4,2x,i2,a1,i2.2,a1,i2.2,a1,i3.3,1x,a)' ) &
    trim ( month(m) ), d, y, h, ':', n, ':', s, '.', mm, trim ( ampm )
end if
  return
end subroutine timestamp
!
function timestring() result(xx)
character (len=100) :: xx
call timestamp(xx)
end function timestring
!
subroutine get_var(ysym,symbols,xx,yy,stop_missing)
! put data for symbol ysym in yy(:)
character (len=*), intent(in) :: symbols(:)
real(kind=dp)    , intent(in) :: xx(:,:)
character (len=*), intent(in) :: ysym
real(kind=dp)    , allocatable, intent(out) :: yy(:)
logical, intent(in), optional :: stop_missing
integer                       :: icol
logical                       :: stop_missing_
stop_missing_ = default(.true.,stop_missing)
icol = match_string_scalar(ysym,symbols)
if (icol /= 0) then
   call set_alloc(xx(:,icol),yy)
else
   write (*,*) "could not find data for '" // trim(ysym) // "'"
   if (stop_missing_) then
      write (*,*) "STOPPING"
      stop
   end if
end if
end subroutine get_var
!
function empty_char_vec() result(xx)
character (len=1) :: xx(0)
xx = " "
end function empty_char_vec
!
function lagged(xx,nlag,fill_value) result(yy)
! return xx(:) with each element shifted by nlag values to the right
real(kind=dp), intent(in)           :: xx(:)
real(kind=dp), intent(in), optional :: fill_value
real(kind=dp)                       :: yy(size(xx))
integer      , intent(in)           :: nlag
integer                             :: n
n = size(xx)
yy = default(0.0_dp,fill_value)
if (nlag == 0) then
   yy = xx
else if (nlag > 0) then
   yy(1+nlag:n) = xx(1:n-nlag)
else if (nlag < 0) then
   yy(1:n+nlag) = xx(1-nlag:n)
end if
end function lagged
!
function pos_changes(xx) result(ipos)
! return positions of the first value and of positions with values different from the previous value
real(kind=dp), intent(in) :: xx(:)
integer, allocatable :: ipos(:)
integer              :: n
n = size(xx)
if (n == 0) then
   allocate(ipos(0))
   return
end if
ipos = true_pos([.true.,xx(2:) /= xx(:n-1)])
end function pos_changes
!
! function pos_changes_real(xx) result(ipos)
! real(kind=dp), intent(in)  :: xx(:)
! integer      , allocatable
! end function pos_changes_real
!
! function rows_real(xx,tf) result(yy)
! real(kind=dp), intent(in) :: xx(:,:)
! logical      , intent(in) :: tf(:)
! real(kind=dp)             :: yy(count(tf),size(xx,2))
! integer                   ::
! yy = 0.0_dp
! end function rows_real
function frac_true(xx) result(yy)
logical, intent(in) :: xx(:)
real(kind=dp)       :: yy
yy = count(xx)/dble(max(1,size(xx)))
end function frac_true
!
function frac_changes(xx) result(yy)
! return the fraction of times xx(i) is not the same as xx(i-1) for logical array xx(:)
logical, intent(in) :: xx(:)
real(kind=dp)       :: yy
integer             :: n
n = size(xx)
if (n < 2) then
   yy = 0.0_dp
   return
end if
yy = count(xx(2:) .neqv. xx(:n-1)) / dble(n-1)
end function frac_changes
!
subroutine alloc_matrix_real(n1,n2,xx,xdef)
integer                   , intent(in)  :: n1,n2
real(kind=dp), allocatable, intent(out) :: xx(:,:)
real(kind=dp), optional   , intent(in)  :: xdef
allocate (xx(n1,n2))
if (present(xdef)) xx = xdef
end subroutine alloc_matrix_real
!
function random_logical_vec(n,prob) result(tf)
! return a logical vector with n*prob true elements on average
integer, intent(in) :: n
real(kind=dp), intent(in) :: prob
logical             :: tf(n)
real(kind=dp)       :: xx(n)
call random_number(xx)
tf = xx > (1-prob)
end function random_logical_vec
!
function random_logical_matrix(nrow,ncol,prob) result(tf)
! return a logical matrix with each element having probability prob of being true
integer, intent(in) :: nrow,ncol
real(kind=dp), intent(in) :: prob
logical             :: tf(nrow,ncol)
real(kind=dp)       :: xx(nrow,ncol)
call random_number(xx)
tf = xx > (1-prob)
end function random_logical_matrix
!
function random_logical_3d(n1,n2,n3,prob) result(tf)
! return a logical matrix with each element having probability prob of being true
integer      , intent(in) :: n1,n2,n3
real(kind=dp), intent(in) :: prob
logical                   :: tf(n1,n2,n3)
real(kind=dp)             :: xx(n1,n2,n3)
call random_number(xx)
tf = xx > (1-prob)
end function random_logical_3d
!
subroutine init_random_seed()
integer              :: i, n, clock
integer, allocatable :: seed(:)
call random_seed(size = n)
allocate (seed(n))
call system_clock(count=clock)
seed = clock + 37 * [(i-1, i = 1, n)]
call random_seed(put=seed)
deallocate (seed)
end subroutine init_random_seed
!
subroutine put_random_seed(iadd) 
integer, allocatable :: seed(:) 
integer, intent(in), optional :: iadd
integer              :: seed_size
integer, parameter   :: nmax = 33
integer, parameter   :: iran(nmax) = &
[993639,510370,867989,459062,250118,21367,615149,928396,60451,&
375304,451750,778177,920970,929490,559068,168877,198559,&
147494,138494,709469,770595,304923,951942,108290,651756,&
326105,825471,403004,732210,245191,968430,163348,865109]
integer :: iadd_
iadd_ = default(0,iadd)
call random_seed(size=seed_size)
if (seed_size < 1) then
   return
else if (seed_size <= nmax) then
   allocate (seed(seed_size))
   seed = iran(:seed_size)
   call random_seed(put=seed+iadd_)
else
   write (*,*) "in put_random_seed, seed_size =",seed_size," need seed_size <= ",nmax,"STOPPING"
   stop
end if
end subroutine put_random_seed
!
function default_variable_names(n,base) result(names)
integer, intent(in) :: n
character (len=*), intent(in) :: base
character (len=20)            :: names(n)
integer                       :: i
do i=1,n
   write (names(i),"(a,i0)") base,i
end do
end function default_variable_names
!
function seq(n) result(ivec)
! return a sequence of integers from 1 to n
integer, intent(in) :: n
integer             :: ivec(n)
integer             :: i
ivec = [(i,i=1,n)]
end function seq
!
function current_time(format,print_seconds) result(str)
character (len=*), intent(in)           :: format ! "iso" or not
logical          , intent(in), optional :: print_seconds
character (len=22) :: str
character (len=2)  :: am_pm
integer            :: ival(8),hour
integer, parameter :: iyear = 1, imonth = 2, iday = 3, ihour = 5, iminute = 6, isecond = 7
logical            :: print_seconds_
print_seconds_ = .true.
if (present(print_seconds)) print_seconds_ = print_seconds
call date_and_time(values=ival)
if (format == "iso") then
   if (print_seconds_) then
      write (str,"(i4.4,2('-',i2.2),1x,i2.2,2(':',i2.2))") ival([iyear,imonth,iday,ihour,iminute,isecond])
   else
      write (str,"(i4.4,2('-',i2.2),1x,i2.2,':',i2.2)") ival([iyear,imonth,iday,ihour,iminute])
   end if
else if (format == "24h") then
   if (print_seconds_) then
      write (str,"(2(i2.2,'/'),i4.4,1x,2(i2.2,':'),i2.2)") ival([imonth,iday,iyear,ihour,iminute,isecond])
   else
      write (str,"(2(i2.2,'/'),i4.4,1x,i2.2,':',i2.2)") ival([imonth,iday,iyear,ihour,iminute])
   end if
else if (format == "am_pm") then
   hour = ival(ihour)
   if (hour > 12) then
      hour = hour - 12
      am_pm = "PM"
   else
      am_pm = "AM"
   end if
   if (print_seconds_) then
      write (str,"(2(i2.2,'/'),i4.4,1x,2(i2.2,':'),i2.2,1x,a)") ival([imonth,iday,iyear]),hour,ival([iminute,isecond]),am_pm
   else
      write (str,"(2(i2.2,'/'),i4.4,1x,i2.2,':',i2.2,1x,a)") ival([imonth,iday,iyear]),hour,ival([iminute]),am_pm
   end if
end if
end function current_time
!
function now() result(str)
character (len=19) :: str
integer            :: ival(8)
call date_and_time(values=ival)
write (str,"(i4.4,2('-',i2.2),1x,i2.2,2(':',i2.2))") ival([1,2,3,5,6,7])
end function now
!
subroutine get_data(label,sym,xx,yy)
! get yy(:) from column in xx(:,:) corresponding to label(:)
character (len=*)     , intent(in)            :: label,sym(:)
real(kind=dp)         , intent(in) , target   :: xx(:,:)
real(kind=dp), pointer, intent(out), optional :: yy(:)
integer                                       :: i,icol_
icol_ = match_string_scalar(label,sym)
if (icol_ == 0) then
   write (*,*) "in util_mod::get_data, available symbols are",(" '" // trim(sym(i)) // "'",i=1,size(sym))
   write (*,*) "could not read data for '" // trim(label) // "', STOPPING"
   stop
end if
if (present(yy)) yy => xx(:,icol_)
end subroutine get_data
!
elemental function replace_char(text,old_char,new_char) result(new_text)
character (len=*), intent(in) :: text,old_char,new_char
character (len=len(text))     :: new_text
integer                       :: i,nlen
nlen = len(text)
new_text = text
do i=1,nlen
   if (index(old_char,new_text(i:i)) /= 0) new_text(i:i) = new_char
end do
end function replace_char
!
function unix() result(is_unix)
! test if the operating system is Unix
logical :: is_unix
character (len=100) :: path
call get_environment_variable("PATH",path)
is_unix = path(1:1) == "/"
end function unix
!
function unix_dir(dir) result(yy)
character (len=*), intent(in) :: dir
character (len=1000)          :: yy
integer                       :: nlen
nlen = len(dir)
if (nlen < 2) then
   yy = replace_char(dir,"\","/")
   return
end if
if (dir(2:2) == ":") then
   yy = "/mnt/" // dir(1:1) // trim(replace_char(dir(3:),"\","/"))
else
   yy = replace_char(dir,"\","/")
end if
end function unix_dir
!
pure function threshold_weights(xx,wgt_min) result(yy)
! set weights less than wgt_min and renormalize weight so that they sum to one
real(kind=dp), intent(in) :: xx(:),wgt_min
real(kind=dp)             :: yy(size(xx))
integer                   :: n
real(kind=dp)             :: ysum
n = size(xx)
if (n == 0) then
   return
else if (n == 1) then
   yy = 1.0_dp
   return
end if
yy = merge(xx,0.0_dp,xx>=wgt_min)
ysum = sum(yy)
if (ysum > 0) then
   yy = yy/ysum
else
   yy = 1.0_dp/n
end if
end function threshold_weights
!
elemental function clip(xx,xmin,xmax) result(yy)
real(kind=dp), intent(in) :: xx,xmin,xmax
real(kind=dp)             :: yy
yy = min(xmax,max(xmin,xx))
end function clip
!
elemental function clip_transform(xx,xmin,xmax,transform) result(yy)
real(kind=dp), intent(in) :: xx,xmin,xmax
character (len=*), intent(in), optional :: transform
real(kind=dp)             :: yy
character (len=20) :: transform_
transform_ = default("none",transform)
if (transform_ == "sine") then
   yy = sine_transform(xx,xmin,xmax,xmin,xmax)
else if (transform_ == "half_sine") then
   yy = half_sine_transform(xx,xmin,xmax,xmin,xmax)
else
   yy = min(xmax,max(xmin,xx))
end if
end function clip_transform
!
elemental function and(xx,yy) result(tf)
! return .true. if xx and yy are both .true. or if xx is .true. and yy is not present
logical, intent(in), optional :: xx,yy
logical                       :: tf
tf = default(.true.,xx) .and. default(.true.,yy)
end function and
!
subroutine close_file(xfile)
! close a file if it is open
character (len=*), intent(in) :: xfile
integer                       :: iu
inquire(file=xfile,number=iu)
if (iu > -1) close(iu)
end subroutine close_file
!
subroutine write_optional(outu,xfmt)
integer          , intent(in), optional :: outu
character (len=*), intent(in), optional :: xfmt
if (xfmt /= "") write (default(istdout,outu),xfmt)
end subroutine write_optional
!
subroutine pad_directory_name(dir_name,dir_sep)
! append dir_sep to dir_name if dir_name does not already end in dir_sep
character (len=*), intent(in out)       :: dir_name
character (len=1), intent(in), optional :: dir_sep
integer                                 :: len_dir
character (len=1)                       :: dir_sep_
if (present(dir_sep)) then
   dir_sep_ = dir_sep
else
   dir_sep_ = directory_sep()
end if
len_dir = len_trim(dir_name)
if (len_dir < len(dir_name)) then
   if (dir_name(len_dir:len_dir) /= dir_sep_) dir_name = trim(dir_name) // dir_sep_
end if
end subroutine pad_directory_name
!
function backfill(xx,good) result(yy)
real(kind=dp), intent(in) :: xx(:) ! (n)
logical      , intent(in) :: good(:)
real(kind=dp)             :: yy(size(xx))
integer                   :: i,n
real(kind=dp)             :: xgood
logical                   :: found_good
n = size(xx)
found_good = .false.
do i=1,n
   if (good(i)) then
      yy(i) = xx(i)
      xgood = xx(i)
      found_good = .true.
   else
      if (found_good) then
         yy(i) = xgood
      else
         yy(i) = bad_real
      end if
   end if
end do
end function backfill
!
function directory_sep() result(ch)
character (len=1) :: ch
ch = merge('/','\',unix())
end function directory_sep
!
elemental function str_real(xx,fmt_real) result(ch)
real(kind=dp), intent(in) :: xx
character (len=*), intent(in), optional :: fmt_real
character (len=20) :: ch
if (present(fmt_real)) then
   write (ch,fmt_real) xx
else
   write (ch,"(f20.4)") xx
end if
ch = adjustl(ch)
end function str_real
!
pure function str_concat(fmt,str,xx) result(new_str)
character (len=*), intent(in) :: fmt,str
real(kind=dp), intent(in) :: xx(:)
character (len=100) :: new_str
write (new_str,fmt) trim(str),xx
end function str_concat
!
subroutine fold_bounds(n,nfolds,i1,i2)
! return i1(:) and i2(:) that specify folds of n
integer, intent(in)  :: n,nfolds
integer, intent(out) :: i1(nfolds),i2(nfolds)
integer              :: j,nelem(nfolds)
if (nfolds < 1 .or. n < 1) then
   i1 = 0
   i2 = 0
   return
end if
nelem = group_sizes(n,nfolds)
i1(1) = 1
i2(1) = 1 + nelem(1) - 1
do j=2,nfolds
   i1(j) = i2(j-1) + 1
   i2(j) = i1(j)   + nelem(j) - 1
end do
end subroutine fold_bounds
!
recursive pure function group_sizes(n,ngroups) result(nelem)
! return group sizes that add up to n and have the lowest variation possible
integer, intent(in) :: n        ! sum of group sizes
integer, intent(in) :: ngroups  ! # of groups
integer             :: nelem(ngroups)
integer             :: ndiv
if (ngroups < 1) then
   return
else if (ngroups == 1) then
   nelem = max(0,n)
   return
else if (ngroups > n) then
   nelem(1:n) = 1
   nelem(n+1:) = 0
   return
end if
ndiv = n/ngroups
nelem = ndiv + group_sizes(n-ndiv*ngroups,ngroups)
end function group_sizes
!
subroutine read_strings_vec(iu,strings,nmax,fmt,close_unit)
! read strings from unit iu, one string per line
integer            , intent(in)               :: iu
character (len=*)  , intent(out), allocatable :: strings(:)
integer            , intent(in) , optional    :: nmax
character (len=*)  , intent(in) , optional    :: fmt
logical            , intent(in) , optional    :: close_unit
integer                                       :: i,nmax_,ierr,nread
nmax_ = default(nmax,1000000)
allocate (strings(nmax_))
nread = nmax_
do i=1,nmax_
   if (present(fmt)) then
      read (iu,fmt,iostat=ierr) strings(i)
   else
      read (iu,*,iostat=ierr) strings(i)
   end if
   if (ierr /= 0) then
      nread = i-1
      exit
   end if
end do
call set_alloc((strings(:nread)),strings)
if (present(close_unit)) then
   if (close_unit) close(iu)
end if
end subroutine read_strings_vec
!
subroutine read_matrix_alloc(xfile,xx,iline_dim,sym,max_row,max_col)
! read matrix xx(;,:) from file xfile that has the dimensions on line iline_dim
character (len=*), intent(in)                         :: xfile
integer          , intent(in)                         :: iline_dim
real(kind=dp)    , intent(out), allocatable           :: xx(:,:)
character (len=*), intent(out), allocatable, optional :: sym(:)
integer          , intent(in) ,              optional :: max_row,max_col
integer                                               :: iline,iu,nrow,ncol
call get_unit_open_file(xfile,iu,"r")
do iline=1,iline_dim-1
   read (iu,*)
end do
read (iu,*) nrow,ncol
if (present(max_row)) nrow = min(nrow,max_row)
if (present(max_col)) ncol = min(ncol,max_col)
! print*,"nrow, ncol=",nrow,ncol !! debug
allocate (xx(nrow,ncol))
if (present(sym)) then
   allocate (sym(ncol))
   read (iu,*) sym
end if
do iline=1,nrow
   read (iu,*) xx(iline,:)
end do
! print*,"shape(xx)=",shape(xx) !! debug
close (iu)
end subroutine read_matrix_alloc
!
subroutine read_matrix_unit(iu,xx,nlines_skip_init,nlines_skip_after_dim)
! read # of columns and rows from successive lines, then allocate and read rows of matrix
integer      , intent(in)               :: iu
real(kind=dp), intent(out), allocatable :: xx(:,:)
integer      , intent(in) , optional    :: nlines_skip_init ! # of lines to skip at beginning of data file
integer      , intent(in) , optional    :: nlines_skip_after_dim ! # of lines to skip after reading dimenions before reading matrix
integer                                 :: i,ierr,ncol,nrows
call skip_lines_unit(iu,nlines_skip_init)
read (iu,*) ncol
read (iu,*) nrows
call skip_lines_unit(iu,nlines_skip_after_dim)
allocate (xx(nrows,ncol))
xx = -999.0_dp
do i=1,nrows
   read (iu,*,iostat=ierr) xx(i,:)
   if (ierr /= 0) then
      write (*,*) "could not read data for row ",i
      exit
   end if
end do
end subroutine read_matrix_unit
!
subroutine read_matrix(iu,xx,ncol_skip)
! read matrix with fixed dimensions from unit iu
integer      , intent(in) :: iu
real(kind=dp), intent(out) :: xx(:,:)
integer      , intent(in), optional :: ncol_skip
integer                             :: i,ncol_skip_
character (len=1), allocatable :: dum(:)
ncol_skip_ = default(0,ncol_skip)
allocate (dum(ncol_skip_))
do i=1,size(xx,1)
   read (iu,*) dum,xx(i,:)
end do
end subroutine read_matrix
!
subroutine read_3d(iu,xx,ncol_skip)
integer      , intent(in) :: iu
real(kind=dp), intent(out) :: xx(:,:,:)
integer      , intent(in), optional :: ncol_skip
integer                             :: i1,i2,ncol_skip_
character (len=1), allocatable :: dum(:)
ncol_skip_ = default(0,ncol_skip)
allocate (dum(ncol_skip_))
do i1=1,size(xx,1)
   do i2=1,size(xx,2)
      read (iu,*) dum,xx(i1,i2,:)
   end do
end do
end subroutine read_3d
!
subroutine random_number_seed(iseed)
integer, intent(in) :: iseed
integer             :: put_vec(33)
put_vec = iseed
call random_seed(put=put_vec)
end subroutine random_number_seed
!
subroutine get_random_seeds(seeds)
integer, intent(out), allocatable :: seeds(:)
integer :: nseeds
call random_seed(size=nseeds)
allocate (seeds(nseeds))
call random_seed(get=seeds)
end subroutine get_random_seeds
!
pure function partition(n,npart) result(ipart)
integer, intent(in) :: n,npart
integer             :: ipart(npart)
integer             :: i
if (npart <= 0) return
if (n <= 1) then
   ipart = n
   return
end if
if (npart < n) then
   forall (i=1:npart) ipart(i) = nint(n*i/(npart+1.0_dp))
else
   forall (i=1:npart) ipart(i) = i
end if
end function partition
!
pure function first_int(vec) result(yy)
integer, intent(in) :: vec(:)
integer             :: yy
if (size(vec) > 0) then
   yy = vec(1)
else
   yy = bad_int
end if
end function first_int
!
pure function first_real(vec) result(yy)
real(kind=dp), intent(in) :: vec(:)
real(kind=dp)             :: yy
if (size(vec) > 0) then
   yy = vec(1)
else
   yy = bad_int
end if
end function first_real
!
pure function first_char(vec) result(yy)
character (len=*), intent(in) :: vec(:)
character (len=len(vec))      :: yy
if (size(vec) > 0) then
   yy = vec(1)
else
   yy = bad_char
end if
end function first_char
!
function default_alloc_char(xdef,xx) result(zz)
character (len=*), intent(in) :: xdef(:)
character (len=*), intent(in), optional :: xx(:)
character (len=100), allocatable :: zz(:)
if (present(xx)) then
   call set_alloc(xx,zz)
else
   call set_alloc(xdef,zz)
end if
end function default_alloc_char
!
pure function first_pos_positive(vec) result(ipos)
integer, intent(in) :: vec(:)
integer :: ipos
integer :: i
ipos = 0
do i=1,size(vec)
   if (vec(i) > 0) then
      ipos = i
      return
   end if
end do
end function first_pos_positive
!
elemental function floor_10(xx) result(yy)
real(kind=dp), intent(in) :: xx
real(kind=dp)             :: yy
yy = 10.0_dp**(floor(log10(abs(xx)))) * merge(1,-1,xx>0.0_dp)
end function floor_10
!
elemental function ceiling_10(xx) result(yy)
real(kind=dp), intent(in) :: xx
real(kind=dp)             :: yy
yy = 10.0_dp**(ceiling(log10(abs(xx)))) * merge(1,-1,xx>0.0_dp)
end function ceiling_10
!
subroutine exact_match_ascending_int(ivec,jm,ipos,found,i1)
! return the location ipos>=i1 of the first element of ivec such that ivec(ipos)==jm,
! 0 if jm < ivec(1), and size(ivec)+1 if jm > ivec(size(ivec))
integer, intent(in)           :: ivec(:) ! vector to be searched for match
integer, intent(in)           :: jm      ! value to look for
integer, intent(out)          :: ipos    ! first position at which ivec(ipos) >= jm
logical, intent(out)          :: found   ! .true. if jm found in ivec(:)
integer, intent(in), optional :: i1      ! first position at which to look
integer                       :: i,i1_,n
found = .false.
ipos  = 0
n     = size(ivec)
if (present(i1)) then
   i1_ = max(1,i1)
else
   i1_ = 1
end if
if (n < 1 .or. i1_ > n) return
do i=i1_,n
   if (ivec(i) >= jm) then
      ipos = i
      found = ivec(i) == jm
      return
   end if
end do
end subroutine exact_match_ascending_int
!
elemental function text_after_char(xx,xchar,back) result(yy)
character (len=*), intent(in) :: xx,xchar
character (len=len(xx))       :: yy
logical          , intent(in), optional :: back
integer                       :: ipos,nlen
nlen = len(xx)
if (nlen < 1) return
ipos = index(xx,xchar,back=back)
if (ipos == 0) then
   yy = xx
else if (ipos == nlen) then
   yy = ""
else
   yy = xx(ipos+1:)
end if
end function text_after_char
!
function common_value(ivec,idef) result(jj)
! if all elements of ivec(:) have the same value, return it; otherwise return a default value
integer, intent(in)           :: ivec(:)
integer, intent(in), optional :: idef
integer                       :: jj
jj = merge(minval(ivec),default(0,idef),minval(ivec)==maxval(ivec))
end function common_value
!
function join_fixed(words,nlen) result(text)
character (len=*), intent(in)    :: words(:)
integer          , intent(in)    :: nlen
character (len=size(words)*nlen) :: text
integer                          :: i
character (len=100)              :: fmt_t
! print*,"in join_fixed, size(words), nlen=",size(words),nlen
write (fmt_t,"('(10000a',i0,')')") nlen
write (text,fmt_t) (trim(words(i)),i=1,size(words))
end function join_fixed
!
pure function union_ascending(xx,yy) result(zz)
! return the union of xx(:) and yy(:), assuming they are in ascending order
integer, intent(in)  :: xx(:),yy(:)
integer, allocatable :: zz(:)
integer              :: i,ix,iy,nx,ny,nz
logical              :: use_x
nx = size(xx)
ny = size(yy)
nz = nx + ny
allocate (zz(nz))
if (nx == 0 .or. ny == 0) then
   call set_alloc(unique_ordered([xx,yy]),zz)
   return
end if
ix = 1
iy = 1
do i=1,nz
   if (ix > nx) then
      use_x = .false.
   else if (iy > ny) then
      use_x = .true.
   else
      use_x = xx(ix) < yy(iy)
   end if
   if (use_x) then
      zz(i) = xx(ix)
      ix = ix + 1
   else
      zz(i) = yy(iy)
      iy = iy + 1
   end if
end do
call set_alloc(unique_ordered(zz),zz)
end function union_ascending
!
pure function unique_ordered_int(ivec) result(jvec)
! return in jvec(:) the unique values of ivec(:), assuming ivec(:) is ordered
integer, intent(in)  :: ivec(:)
integer, allocatable :: jvec(:)
integer              :: n
n = size(ivec)
if (n == 0 .or. n == 1) then
   call set_alloc(ivec,jvec)
   return
end if
call set_alloc(pack(ivec,[.true.,ivec(2:)/=ivec(:n-1)]),jvec)
end function unique_ordered_int
!
pure function unique_ordered_i64(ivec) result(jvec)
! return in jvec(:) the unique values of ivec(:), assuming ivec(:) is ordered
integer(kind=i64), intent(in)  :: ivec(:)
integer(kind=i64), allocatable :: jvec(:)
integer                        :: n
n = size(ivec)
if (n == 0 .or. n == 1) then
   call set_alloc(ivec,jvec)
   return
end if
call set_alloc(pack(ivec,[.true.,ivec(2:)/=ivec(:n-1)]),jvec)
end function unique_ordered_i64
!
subroutine get_sub_vec_real(xx,iget,yy,ygood,xgood)
! set yy = xx(iget) where iget is in bounds and xgood is .true.
real(kind=dp), intent(in)           :: xx(:)    ! (n)
integer      , intent(in)           :: iget(:)  ! (nget)
logical      , intent(in), optional :: xgood(:) ! (n)
real(kind=dp), intent(out)          :: yy(:)    ! (nget)
logical      , intent(out)          :: ygood(:) ! (nget)
integer                             :: i,iuse,nget,n
character (len=*), parameter        :: msg="in get_sub_vec_real, "
logical      , allocatable          :: xgood_(:)
n    = size(xx)
nget = size(iget)
if (size(yy) /= nget .or. size(ygood) /= nget) then
   print*,msg,"size(iget), size(yy), size(ygood) =",nget,size(yy),size(ygood)," should all be equal, STOPPING"
   stop
else if (present(xgood)) then
   if (size(xgood) /= n) then
      print*,msg,"size(xx), size(xgood) =",n,size(xgood)," should be equal, STOPPING"
      stop
   end if
end if
if (present(xgood)) then
   call set_alloc(xgood,xgood_)
else
   allocate (xgood_(n))
   xgood_ = .true.
end if
do i=1,nget
   ygood(i) = .false.
   iuse = iget(i)
   if (iuse > 0 .and. iuse <= n) then
      if (xgood_(iuse)) then
         yy(i) = xx(iuse)
         ygood(i) = .true.
      end if
   end if
end do
end subroutine get_sub_vec_real
!
subroutine get_sub_matrix_real(xx,iget,jget,yy,ygood,xgood)
! set yy = xx(iget,jget) where (iget,jget) is in bounds and xgood is .true.
real(kind=dp), intent(in)           :: xx(:,:)    ! (n1,n2)
integer      , intent(in)           :: iget(:)    ! (ni)
integer      , intent(in)           :: jget(:)    ! (nj)
logical      , intent(in), optional :: xgood(:,:) ! (n1,n2)
real(kind=dp), intent(out)          :: yy(:,:)    ! (ni,nj)
logical      , intent(out)          :: ygood(:,:) ! (ni,nj)
integer                             :: i,j,iuse,juse,ni,nj,n1,n2
character (len=*), parameter        :: msg="in get_sub_matrix_real, "
logical      , allocatable          :: xgood_(:,:)
n1 = size(xx,1)
n2 = size(xx,2)
ni = size(iget)
nj = size(jget)
if (any([size(yy,1),size(ygood,1)] /= ni) .or. any([size(yy,2),size(ygood,2)] /= nj)) then
   print*,msg,"[size(iget),size(jget)]=",[ni,nj]," shape(yy)=",shape(yy)," shape(ygood)=",shape(ygood), &
         " should all be equal, STOPPING"
   stop
else if (present(xgood)) then
   if (size(xgood,1) /= n1 .or. size(xgood,2) /= n2) then
      print*,msg,"shape(xx)=",shape(xx)," shape(xgood)=",shape(xgood)," should be equal, STOPPING"
      stop
   end if
end if
if (present(xgood)) then
   call set_alloc(xgood,xgood_)
else
   allocate (xgood_(n1,n2))
   xgood_ = .true.
end if
ygood = .false.
do_i: do i=1,ni
   iuse = iget(i)
   if (iuse < 1 .or. iuse > ni) cycle do_i
   do_j: do j=1,nj
      juse = jget(j)
      if (juse < 1 .or. juse > nj) cycle do_j
      if (xgood_(iuse,juse)) then
         yy(i,j)    = xx(iuse,juse)
         ygood(i,j) = .true.
      end if
   end do do_j
end do do_i
end subroutine get_sub_matrix_real
!
subroutine get_sub_array_3d_real(xx,iget,jget,kget,yy,ygood,xgood,ydef)
! set yy = xx(iget,jget) where (iget,jget) is in bounds and xgood is .true.
real(kind=dp), intent(in)           :: xx(:,:,:)    ! (n1,n2,n3)
integer      , intent(in)           :: iget(:)      ! (ni)
integer      , intent(in)           :: jget(:)      ! (nj)
integer      , intent(in)           :: kget(:)      ! (nk)
logical      , intent(in), optional :: xgood(:,:,:) ! (n1,n2,n3)
real(kind=dp), intent(out)          :: yy(:,:,:)    ! (ni,nj,nk)
logical      , intent(out)          :: ygood(:,:,:) ! (ni,nj,nk)
real(kind=dp), intent(in), optional :: ydef
integer                             :: i,j,k,iuse,juse,kuse,ni,nj,nk,n1,n2,n3
character (len=*), parameter        :: msg="in get_sub_array_3d_real, "
logical      , allocatable          :: xgood_(:,:,:)
n1 = size(xx,1)
n2 = size(xx,2)
n3 = size(xx,3)
ni = size(iget)
nj = size(jget)
nk = size(kget)
! print*,msg // " n1, n2, n3, ni, nj, nk =",n1, n2, n3, ni, nj, nk !! debug
if (any([size(yy,1),size(ygood,1)] /= ni) .or. any([size(yy,2),size(ygood,2)] /= nj) &
         .or. any([size(yy,3),size(ygood,3)] /= nk)) then
   print*,msg,"[size(iget),size(jget),size(kget)]=",[ni,nj,nk]," shape(yy)=",shape(yy)," shape(ygood)=",shape(ygood), &
         " should all be equal, STOPPING"
   stop
else if (present(xgood)) then
   if (size(xgood,1) /= n1 .or. size(xgood,2) /= n2 .or. size(xgood,3) /= n3) then
      print*,msg,"shape(xx)=",shape(xx)," shape(xgood)=",shape(xgood)," should be equal, STOPPING"
      stop
   end if
end if
if (present(xgood)) then
   call set_alloc(xgood,xgood_)
else
   allocate (xgood_(n1,n2,n3))
   xgood_ = .true.
end if
ygood = .false.
if (present(ydef)) yy = ydef
do_i: do i=1,ni
   iuse = iget(i)
   if (iuse < 1 .or. iuse > n1) cycle do_i
   do_j: do j=1,nj
      juse = jget(j)
      if (juse < 1 .or. juse > n2) cycle do_j
      do_k: do k=1,nk
         kuse = kget(k)
!         print*,"ni, nj, nk, iuse, juse, kuse =",ni,nj,nk,iuse,juse,kuse," shape(xx)=",shape(xx)," shape(xgood_)=",shape(xgood_) !! debug
         if (kuse < 1 .or. kuse > n3) cycle do_k
         if (xgood_(iuse,juse,kuse)) then
            yy(i,j,k)    = xx(iuse,juse,kuse)
            ygood(i,j,k) = .true.
         end if
      end do do_k
   end do do_j
end do do_i
end subroutine get_sub_array_3d_real
!
! subroutine write_trim_vec(strings,label,prefix,suffix,outu)
! subroutine write_trim_vec(strings,outu)
subroutine write_trim_vec(strings,prefix,suffix,outu)
character (len=*), intent(in)           :: strings(:)
character (len=*), intent(in), optional  :: prefix,suffix
integer          , intent(in), optional :: outu
integer                                 :: outu_,i
character (len=10)                      :: prefix_,suffix_
prefix_ = default(nlen=10,def="'",opt=prefix)
suffix_ = default(nlen=10,def="'",opt=prefix)
outu_   = default(istdout,outu)
! write (outu_,"(100(a,1x))") ("'" // trim(strings(i)) // "'",i=1,size(strings))
write (outu_,"(100(a,1x))") (trim(prefix_) // trim(strings(i)) // trim(suffix_),i=1,size(strings))
end subroutine write_trim_vec
!
subroutine write_vec(strings,fmt,prefix,suffix,outu,fmt_header,fmt_trailer,print_count)
! write trimmed strings(:) with format fmt and optional prefix and suffix to unit outu
character (len=*), intent(in)           :: strings(:)
character (len=*), intent(in)           :: fmt
character (len=*), intent(in), optional :: prefix,suffix,fmt_header,fmt_trailer
integer          , intent(in), optional :: outu
logical          , intent(in), optional :: print_count
integer                                 :: outu_,i,n
character (len=10)                      :: prefix_,suffix_
n       = size(strings)
prefix_ = default(nlen=10,def="",opt=prefix)
suffix_ = default(nlen=10,def="",opt=suffix)
outu_   = default(istdout,outu)
call write_format(fmt_header,outu_)
if (default(.false.,print_count)) write (outu_,"('count = ',i0)") n
! write (outu_,"(100(a,1x))") ("'" // trim(strings(i)) // "'",i=1,size(strings))
write (outu_,fmt=fmt) (trim(prefix_) // trim(strings(i)) // trim(suffix_),i=1,n)
call write_format(fmt_trailer,outu_)
end subroutine write_vec
!
function all_strings_in_lines(lines,search_strings,case_sensitive) result(found)
! return .true. if all search_strings(:) are found in lines(:)
character (len=*), intent(in) :: lines(:)
character (len=*), intent(in) :: search_strings(:)
logical, intent(in), optional :: case_sensitive
logical                       :: found
integer                       :: i,nstrings
nstrings = size(search_strings)
found = .false.
if (nstrings < 1) return
do i=1,nstrings
   if (.not. text_in_lines(lines,trim(search_strings(i)),case_sensitive)) return
end do
found = .true.
end function all_strings_in_lines
!
!
function any_strings_in_lines(lines,search_strings,case_sensitive) result(found)
! return .true. if any of search_strings(:) are found in lines(:)
character (len=*), intent(in) :: lines(:)
character (len=*), intent(in) :: search_strings(:)
logical, intent(in), optional :: case_sensitive
logical                       :: found
integer                       :: i,nstrings
nstrings = size(search_strings)
if (nstrings < 1) then
   found = .false.
   return
end if
found = .true.
do i=1,nstrings
   if (text_in_lines(lines,trim(search_strings(i)),case_sensitive)) return
end do
found = .false.
end function any_strings_in_lines
!
function text_in_lines(lines,text,case_sensitive) result(found)
! return .true. if text is found in any of lines(:)
character (len=*), intent(in) :: lines(:)
character (len=*), intent(in) :: text
logical, intent(in), optional :: case_sensitive
logical                       :: found
integer                       :: i
logical                       :: case_sensitive_
character (len=len(text))     :: text_lower
case_sensitive_ = default(.true.,case_sensitive)
found = .false.
if (case_sensitive_) then
   do i=1,size(lines)
      if (index(lines(i),text) /= 0) then
         found = .true.
         return
      end if
   end do
else
   text_lower = lower_case_str(text)
!   print*,"text_lower = '" // trim(text_lower) // "'" !! debug
!   stop !! debug
   do i=1,size(lines)
   !   if (index_case(lines(i),text,case_sensitive=.false.) /= 0) then
      if (index(lower_case_str(lines(i)),text_lower) /= 0) then
         found = .true.
         return
      end if
   end do
end if
end function text_in_lines
!
function index_case(string,substring,case_sensitive) result(ipos)
! do case-sensitive or insensitive index
character (len=*), intent(in) :: string,substring
logical, intent(in), optional :: case_sensitive
integer                       :: ipos
logical                       :: case_sensitive_
case_sensitive_ = .false.
if (present(case_sensitive)) case_sensitive_ = case_sensitive
if (case_sensitive) then
   ipos = index(string,substring)
else
   ipos = index(lower_case_str(string),lower_case_str(substring))
end if    
end function index_case
!
subroutine print_matching_paragraphs(lines,search_string,case_sensitive,outu,max_matches,max_lines_print, &
                                     max_lines_search,print_num_matches)
! print paragraph (separated by blank lines) containing search_string
character (len=*), intent(in)           :: lines(:)
character (len=*), intent(in)           :: search_string
logical          , intent(in), optional :: case_sensitive    ! string matching is case sensitive unless this argument is present and .false.
integer          , intent(in), optional :: outu              ! unit to which output is written
integer          , intent(in), optional :: max_matches       ! maximum # of matching paragraphs to print
integer          , intent(in), optional :: max_lines_print   ! maximum # of lines to print from each paragraph
integer          , intent(in), optional :: max_lines_search  ! maximum # of lines to search within each paragraph
logical          , intent(in), optional :: print_num_matches ! print # of matching paragraphs at end
integer                                 :: outu_,nlines,nmatch,ipar,npar,iblank(size(lines)),i,i1,i2,j,max_lines_print_, &
                                           max_matches_,nlines_search_
logical                                 :: print_num_matches_
print_num_matches_ = default(.true.,print_num_matches)
max_lines_print_   = default(1000000,max_lines_print)
max_matches_       = default(1000000,max_matches)
nlines_search_     = default(1000000,max_lines_search)
outu_              = default(istdout,outu)
nlines             = size(lines)
npar               = 0
do i=1,nlines
   if (lines(i) == "") then
      npar = npar + 1
      iblank(npar) = i
   end if
end do
nmatch = 0
do_par: do ipar=1,npar
   if (nmatch > max_matches_) exit
   if (ipar == 1) then
      i1 = 1
   else
      i1 = iblank(ipar-1)
   end if
   i2 = iblank(ipar)
   if (text_in_lines(lines(i1:min(i2,i1+1+nlines_search_)),search_string,case_sensitive=.false.)) then
      nmatch = nmatch + 1
      do j=i1,min(i1+max_lines_print_,i2)
         write (outu_,"(a)") trim(lines(j))
      end do
   end if
end do do_par
if (print_num_matches_) write (outu_,*) newline // "#matches for '" // search_string // "' = ",nmatch," out of",npar
end subroutine print_matching_paragraphs
!
subroutine search_paragraphs_strings(lines,search_strings,case_sensitive,outu,max_matches,max_lines_print, &
                                     max_lines_search,print_num_matches)
! print paragraph (separated by blank lines) containing search_string
character (len=*), intent(in)           :: lines(:)
character (len=*), intent(in)           :: search_strings(:)
logical          , intent(in), optional :: case_sensitive    ! string matching is case sensitive unless this argument is present and .false.
integer          , intent(in), optional :: outu              ! unit to which output is written
integer          , intent(in), optional :: max_matches       ! maximum # of matching paragraphs to print
integer          , intent(in), optional :: max_lines_print   ! maximum # of lines to print from each paragraph
integer          , intent(in), optional :: max_lines_search  ! maximum # of lines to search within each paragraph
logical          , intent(in), optional :: print_num_matches ! print # of matching paragraphs at end
integer                                 :: outu_,nlines,nmatch,ipar,npar,iblank(size(lines)),i,i1,i2,j,max_lines_print_, &
                                           max_matches_,nlines_search_,isearch
logical                                 :: print_num_matches_
print_num_matches_ = default(.true.,print_num_matches)
max_lines_print_   = default(1000000,max_lines_print)
max_matches_       = default(1000000,max_matches)
nlines_search_     = default(1000000,max_lines_search)
outu_              = default(istdout,outu)
nlines             = size(lines)
npar               = 0
do i=1,nlines
   if (lines(i) == "") then
      npar = npar + 1
      iblank(npar) = i
   end if
end do
nmatch = 0
do_par: do ipar=1,npar
   if (nmatch > max_matches_) exit
   if (ipar == 1) then
      i1 = 1
   else
      i1 = iblank(ipar-1)
   end if
   i2 = iblank(ipar)
   if (all_strings_in_lines(lines(i1:min(i2,i1+1+nlines_search_)),search_strings,case_sensitive=.false.)) then
      nmatch = nmatch + 1
      do j=i1,min(i1+max_lines_print_,i2)
         write (outu_,"(a)") trim(lines(j))
      end do
   end if
end do do_par
if (print_num_matches_) write (outu_,"(/,'#matches = ',i0,' out of ',i0,' for strings = ',100(:,1x,'''',a,''''))")  &
    nmatch,npar,(trim(search_strings(isearch)),isearch=1,size(search_strings))
end subroutine search_paragraphs_strings
!
pure function rename_strings(xx,xold,xnew) result(yy)
character (len=*), intent(in) :: xx(:),xold(:),xnew(:)
character (len=len(xx))       :: yy(size(xx))
integer                       :: i,irep,nrep
yy = xx
nrep = size(xold)
if (size(xnew) /= nrep) return
do_i: do i=1,size(xx)
   do irep=1,nrep
      if (yy(i) == xold(irep)) then
         yy(i) = xnew(irep)
         cycle do_i
      end if   
   end do
end do do_i
end function rename_strings
!
pure function pos_keep_char(xx,exclude) result(ipos)
character (len=*), intent(in) :: xx(:),exclude(:)
integer, allocatable :: ipos(:)
integer              :: i,jpos(size(xx)),n
n = size(xx)
forall (i=1:n) jpos(i) = merge(0,i,(any(exclude == xx(i))))
call set_alloc(pack(jpos,jpos > 0),ipos)
end function pos_keep_char
!
function lookup_char_scalar(xx,yy,xkey,ydefault) result(yvalue)
! return the value of yy(:) corresponding to xkey in xx(:), for xx(:), yy(:), xkey of type character
character (len=*), intent(in)           :: xx(:),yy(:) ! (n)
character (len=*), intent(in)           :: xkey
character (len=*), intent(in), optional :: ydefault    ! default value of yvalue when xkey not found in xx
character (len=len(yy))                 :: yvalue
integer                                 :: i,n
n = size(xx)
if (size(yy) /= n) then
   write (*,*) "in lookup, size(xx), size(yy) =",n,size(yy)," must be equal, STOPPING"
   stop
end if
if (present(ydefault)) then
   yvalue = ydefault
else
   yvalue = ""
end if
do i=1,n
   if (xx(i) == xkey) then
      yvalue = yy(i)
      return
   end if
end do
end function lookup_char_scalar
!
function lookup_char_vec(xx,yy,xkey,ydefault) result(yvalue)
! return the values of yy(:) corresponding to xkeys(:) in xx(:), for xx(:), yy(:), xkey(:) of type character
character (len=*), intent(in)           :: xx(:),yy(:) ! (n)
character (len=*), intent(in)           :: xkey(:)
character (len=*), intent(in), optional :: ydefault ! default value of yvalue(:) when xkey(:) not found in xx(:)
character (len=len(yy))                 :: yvalue(size(xkey))
integer                                 :: ikey,imatch,n
n = size(xx)
if (size(yy) /= n) then
   write (*,*) "in lookup, size(xx), size(yy) =",n,size(yy)," must be equal, STOPPING"
   stop
end if
if (present(ydefault)) then
   yvalue = ydefault
else
   yvalue = ""
end if
do_key: do ikey=1,size(xkey)
   imatch = match_string_scalar(xkey(ikey),xx)
   if (imatch /= 0) yvalue(ikey) = yy(imatch)
end do do_key
end function lookup_char_vec
!
function lookup_char_matrix(xx,yy,xkey,ydefault) result(yvalue)
! return the values in rows of yy(:,:) corresponding to xkeys(:) in xx(:), for xx(:,)), yy(:), xkey of type character
character (len=*), intent(in)           :: xx(:),yy(:,:)
character (len=*), intent(in)           :: xkey(:)
character (len=*), intent(in), optional :: ydefault ! default value of yvalue(:,:) when xkey(:) not found in xx(:)
character (len=len(yy))                 :: yvalue(size(xkey),size(yy,2))
integer                                 :: ikey,imatch,n
n = size(xx)
if (size(yy,1) /= n) then
   write (*,*) "in lookup, size(xx), size(yy,1) =",n,size(yy)," must be equal, STOPPING"
   stop
end if
if (present(ydefault)) then
   yvalue = ydefault
else
   yvalue = ""
end if
do_key: do ikey=1,size(xkey)
   imatch = match_string_scalar(xkey(ikey),xx)
   if (imatch /= 0) yvalue(ikey,:) = yy(imatch,:)
end do do_key
end function lookup_char_matrix
!
function pos(xx,xvec) result(ipos)
! return the first position of xvec(:) that matches xx, 0 if no match, -1 if size(xvec) == 0
character (len=*), intent(in) :: xx,xvec(:)
integer                       :: ipos
integer                       :: i,size_xvec
size_xvec = size(xvec)
if (size_xvec == 0) then
   ipos = -1
   return
end if
do i=1,size_xvec
   if (xvec(i) == xx) then
      ipos = i
      return
   end if
end do
ipos = 0
end function pos
!
function dividend_adjusted_prices(prices,dividends) result(xadj)
real(kind=dp), intent(in) :: prices(:)          ! (n)
reaL(kind=dp), intent(in) :: dividends(:)       ! (n)
real(kind=dp)             :: xadj(size(prices)) ! (n)
integer                   :: i,n
real(kind=dp)             :: wratio(size(prices)) ! wealth relative
n = size(prices)
if (size(dividends) /= n) then
   print*,"in dividend_adjusted_prices, size(prices), size(dividends) =",n,size(dividends)," must be equal, STOPPING"
   stop
end if
wratio = 1.0_dp
do i=2,n
   if (prices(i-1) /= 0.0_dp) wratio(i) = (prices(i) + dividends(i))/prices(i-1)
end do
do i=n,1,-1
   if (i == n) then
      xadj(i) = prices(i)
   else if (wratio(i+1) /= 0.0_dp) then
      xadj(i) = xadj(i+1)/wratio(i+1)
   else
      xadj(i) = prices(i)
   end if
end do
end function dividend_adjusted_prices
!
function returns(prices,dividends,method) result(xret)
real(kind=dp)    , intent(in)           :: prices(:)
real(kind=dp)    , intent(in), optional :: dividends(:)
character (len=*), intent(in), optional :: method
real(kind=dp)                           :: xret(size(prices)-1)
integer                                 :: i,n
real(kind=dp)                           :: div_
character (len=10)                      :: method_
n = size(prices)
if (present(dividends)) then
   if (size(dividends) /= n) then
      print*,"in returns, size(prices), size(dividends) =",n,size(dividends)," must be equal, STOPPING"
      stop
   end if
end if
if (present(method)) then
   method_ = method
else
   method_ = str_simple
end if
xret = bad_real
do i=1,n-1
   if (present(dividends)) then
      div_ = dividends(i+1)
   else
      div_ = 0.0_dp
   end if
   select case (method_)
      case (str_simple)
         if (prices(i) /= 0.0_dp) xret(i) = (prices(i+1) + div_)/prices(i) - 1.0_dp
      case (str_log)
         if (prices(i) /= 0.0_dp) xret(i) = log((prices(i+1) + div_)/prices(i))
      case (str_diff)
         xret(i) = prices(i+1) + div_ - prices(i)
      case default
         write (*,*) "in returns, method_ = " // trim(method_) // " must be one of " // &
                    [str_simple,str_log,str_diff] // " STOPPING"
         stop
   end select
end do
end function returns
!
function vec(s1,s2,s3,s4,s5,s6,s7,s8,s9,s10) result(str)
! return a 1-D character array of the arguments present, assuming that later arguments are not present if earlier ones are missing
character (len=*), intent(in), optional :: s1,s2,s3,s4,s5,s6,s7,s8,s9,s10
character (len=100), allocatable :: str(:)
if (present(s10)) then
   allocate (str(10))
   str(1)=s1; str(2)=s2; str(3)=s3; str(4)=s4; str(5)=s5; str(6)=s6; str(7)=s7; str(8)=s8; str(9)=s9 ; str(10)=s10
else if (present(s9)) then
   allocate (str(9))
   str(1)=s1; str(2)=s2; str(3)=s3; str(4)=s4; str(5)=s5; str(6)=s6; str(7)=s7; str(8)=s8; str(9)=s9
else if (present(s8)) then
   allocate (str(8))
   str(1)=s1; str(2)=s2; str(3)=s3; str(4)=s4; str(5)=s5; str(6)=s6; str(7)=s7; str(8)=s8
else if (present(s7)) then
   allocate (str(7))
   str(1)=s1; str(2)=s2; str(3)=s3; str(4)=s4; str(5)=s5; str(6)=s6; str(7)=s7
else if (present(s6)) then
   allocate (str(6))
   str(1)=s1; str(2)=s2; str(3)=s3; str(4)=s4; str(5)=s5; str(6)=s6
else if (present(s5)) then
   allocate (str(5))
   str(1)=s1; str(2)=s2; str(3)=s3; str(4)=s4; str(5)=s5
else if (present(s4)) then
   allocate (str(4))
   str(1)=s1; str(2)=s2; str(3)=s3; str(4)=s4
else if (present(s3)) then
   allocate (str(3))
   str(1)=s1; str(2)=s2; str(3)=s3
else if (present(s2)) then
   allocate (str(2))
   str(1)=s1; str(2)=s2
else if (present(s1)) then
   allocate (str(1))
   str(1)=s1
else
   allocate (str(0))
end if
end function vec
!
! subroutine returns_good(prices,good_prices,dividends,good_div,method) result(xret)
! real(kind=dp)    , intent(in)           :: prices(:)      ! (n) 
! logical          , intent(in)           :: good_prices(:) ! (n)
! real(kind=dp)    , intent(in), optional :: dividends(:)   ! (n)
! logical          , intent(in), optional :: good_div(:)    ! (n)
! character (len=*), intent(in), optional :: method
! real(kind=dp)                           :: xret(size(prices)-1)
! integer                                 :: i,n
! real(kind=dp)                           :: div_
! character (len=10)                      :: method_
! character (len=*), parameter            :: msg="in returns_good, "
! n=size(prices)
! if (present(dividends)) then
!    if (size(dividends) /= n) then
!        write (*,*) msg,"in returns, size(prices), size(dividends) =",n,size(dividends)," must be equal, STOPPING"
!       stop
!    end if
!    if (.not. present(good_div)) then
!       write (*,*) msg,"dividends PRESENT but good_div not PRESENT, STOPPING"
!       stop
!    else if (size(good_div)) then
!       write (*,*) msg,"size(prices), size(good_div) =",n,size(good_div)," must be equal, STOPPING"
!       stop
!    end if
! end if
! if (present(method)) then
!    method_=method
! else
!    method_=str_simple
! end if
! xret=bad_real
! do i=1,n-1
!    if (present(dividends)) then
!       div_=dividends(i+1)
!    else
!       div_=0.0_dp
!    end if
!    select case (method_)
!       case (str_simple)
!          if (prices(i) /= 0.0_dp) xret(i)=(prices(i+1) + div_)/prices(i) - 1.0_dp
!       case (str_log)
!          if (prices(i) /= 0.0_dp) xret(i)=log((prices(i+1) + div_)/prices(i))
!       case (str_diff)
!          xret(i)=prices(i+1) + div_ - prices(i)
!       case default
!          write (*,*) "in returns, method_=" // trim(method_) // " must be one of " // &
!                     [str_simple,str_log,str_diff] // " STOPPING"
!          stop
!    end select
! end do
! end function returns_good
!
subroutine print_comment_lines(infile,comment_char,outu,fmt_header)
! print lines from infile that begin with one of the characters in comment_char
character (len=*), intent(in)           :: infile,comment_char
character (len=*), intent(in), optional :: fmt_header
integer          , intent(in), optional :: outu
integer                                 :: i,ierr_read,iu,outu_,max_read_
character (len=10000)                   :: text
max_read_ = 1000000
outu_ = default(istdout,outu)
call write_format(fmt_header,outu_)
call get_unit_open_file(infile,iu,"r")
do i=1,max_read_
   read (iu,"(a)",iostat=ierr_read) text
   if (ierr_read /= 0) exit
   if (index(comment_char,text(1:1)) /= 0) write (outu_,"(a)") trim(text)
end do
close(iu)
end subroutine print_comment_lines
!
pure subroutine alloc_char_vec(n,xx)
integer          , intent(in)                         :: n
character (len=*), intent(out), allocatable, optional :: xx(:) 
if (present(xx)) allocate(xx(n))
end subroutine alloc_char_vec
!
elemental function ends_with(text,string) result(tf)
character (len=*), intent(in) :: text,string
logical                       :: tf
integer                       :: len_text,len_string
len_text = len_trim(text)
len_string = len_trim(string)
tf = .false.
if (len_string > len_text .or. len_text < 1) return
tf = text(len_text-len_string+1:len_text) == trim(string)
end function ends_with
!
subroutine moving_average_data_good(nma,xx,xgood,xma,xma_good,use_fewer_edge,use_fewer_middle,default_value)
! compute moving average with missing data
integer      , intent(in)  :: nma
real(kind=dp), intent(in)  :: xx(:)       ! (nobs)
logical      , intent(in)  :: xgood(:)    ! (nobs)
real(kind=dp), intent(out) :: xma(:)      ! (nobs)
logical      , intent(out) :: xma_good(:) ! (nobs)
logical      , intent(in), optional :: use_fewer_edge,use_fewer_middle
real(kind=dp), intent(in), optional :: default_value
integer                    :: sizes(4),nobs,mma,i,i1,i2
logical                    :: use_fewer_edge_,use_fewer_middle_
use_fewer_edge_   = default(.false.,use_fewer_edge)
use_fewer_middle_ = default(.false.,use_fewer_middle)
nobs = size(xx)
sizes = [size(xx),size(xgood),size(xma),size(xma_good)]
if (minval(sizes) /= maxval(sizes)) then
   write (*,*) "size(xx),size(xgood),size(xma),size(xma_good)=",sizes," must all be equal, STOPPING"
   stop
end if
xma_good = .false.
if (nma > 0) then ! moving average using current and past data
   do i=merge(1,nma,use_fewer_edge_),nobs
      i1          = max(1,i-nma+1)
      xma(i)      = mean(xx(i1:i))
      if (use_fewer_middle_) then
         xma_good(i) = any(xgood(i1:i))
      else
         xma_good(i) = all(xgood(i1:i))
      end if
   end do
else if (nma < 0) then ! moving average using current and future data
   mma = abs(nma)
   do i=1,merge(nobs,nobs-mma+1,use_fewer_edge_)
      i2          = min(nobs,i+mma-1)
      xma(i)      = mean(xx(i:i2))
      if (use_fewer_middle_) then
         xma_good(i) = any(xgood(i:i2))
      else
         xma_good(i) = all(xgood(i:i2))
      end if
   end do
else
   xma      = xx
   xma_good = xgood
end if
if (present(default_value)) then
   where (.not. xma_good) xma = default_value
end if
end subroutine moving_average_data_good
!
subroutine madev_good(nma,xx,xgood,xmadev,xmadev_good,use_fewer_edge,use_fewer_middle,default_value,method,nlag)
! compute moving average deviation with missing data
integer      , intent(in)  :: nma
real(kind=dp), intent(in)  :: xx(:)       ! (nobs)
logical      , intent(in)  :: xgood(:)    ! (nobs)
real(kind=dp), intent(out) :: xmadev(:)      ! (nobs)
logical      , intent(out) :: xmadev_good(:) ! (nobs)
logical      , intent(in), optional :: use_fewer_edge,use_fewer_middle
real(kind=dp), intent(in), optional :: default_value
character (len=*), intent(in), optional :: method ! ("diff","ratio")
integer          , intent(in), optional :: nlag
real(kind=dp)              :: xma(size(xx))
logical                    :: xma_good(size(xx))
character (len=10)         :: method_
if (present(method)) then
   method_ = trim(method)
else
   method_ = "diff"
end if
call moving_average_data_good(nma,xx,xgood,xma,xma_good,use_fewer_edge,use_fewer_middle,default_value)
if (method_ == "ratio") then
   xmadev_good = xgood .and. xma_good .and. (xma /= 0.0_dp)
   where (xmadev_good) xmadev = xx/xma - 1.0_dp
   if (present(default_value)) xmadev = merge(xmadev,default_value,xmadev_good)
else if (method_ == "diff") then
   xmadev      = xx - xma
   xmadev_good = xgood .and. xma_good
   if (present(default_value)) xmadev = merge(xmadev,default_value,xmadev_good)
end if
if (present(nlag)) then
   call lag_good_data(nlag,(xmadev),(xmadev_good),xmadev,xmadev_good)
end if
end subroutine madev_good
!
subroutine madev_good_matrix(nma,xx,xgood,xma,xma_good,use_fewer_edge,use_fewer_middle,default_value,nlag)
! compute moving average with missing data for each column of xx(:,:)
integer      , intent(in)  :: nma
real(kind=dp), intent(in)  :: xx(:,:)       ! (nobs,nvar)
logical      , intent(in)  :: xgood(:,:)    ! (nobs,nvar)
real(kind=dp), intent(out) :: xma(:,:)      ! (nobs,nvar)
logical      , intent(out) :: xma_good(:,:) ! (nobs,nvar)
logical      , intent(in), optional :: use_fewer_edge,use_fewer_middle
real(kind=dp), intent(in), optional :: default_value
integer      , intent(in), optional :: nlag
integer                    :: sizes_obs(4),sizes_var(4),nobs,nvar,ivar
logical                    :: use_fewer_edge_
character (len=*), parameter :: msg = "in madev_good_matrix, "
use_fewer_edge_ = default(.false.,use_fewer_edge)
nobs = size(xx,1)
nvar = size(xx,2)
sizes_obs = [size(xx,1),size(xgood,1),size(xma,1),size(xma_good,1)]
sizes_var = [size(xx,2),size(xgood,2),size(xma,2),size(xma_good,2)]
if (minval(sizes_obs) /= maxval(sizes_obs)) then
   write (*,*) msg,"size(xx,1),size(xgood,1),size(xma,1),size(xma_good,1)=",sizes_obs," must all be equal, STOPPING"
   stop
else if (minval(sizes_var) /= maxval(sizes_var)) then
   write (*,*) msg,"size(xx,2),size(xgood,2),size(xma,2),size(xma_good,2)=",sizes_var," must all be equal, STOPPING"
   stop
end if
do ivar=1,nvar
   call madev_good(nma,xx(:,ivar),xgood(:,ivar),xma(:,ivar),xma_good(:,ivar), &
                                 use_fewer_edge,use_fewer_middle,default_value,nlag=nlag)
end do
end subroutine madev_good_matrix
!
subroutine moving_average_data_good_matrix(nma,xx,xgood,xma,xma_good,use_fewer_edge,use_fewer_middle,default_value)
! compute moving average with missing data for each column of xx(:,:)
integer      , intent(in)  :: nma
real(kind=dp), intent(in)  :: xx(:,:)       ! (nobs,nvar)
logical      , intent(in)  :: xgood(:,:)    ! (nobs,nvar)
real(kind=dp), intent(out) :: xma(:,:)      ! (nobs,nvar)
logical      , intent(out) :: xma_good(:,:) ! (nobs,nvar)
logical      , intent(in), optional :: use_fewer_edge,use_fewer_middle
real(kind=dp), intent(in), optional :: default_value
integer                    :: sizes_obs(4),sizes_var(4),nobs,nvar,ivar
logical                    :: use_fewer_edge_
character (len=*), parameter :: msg = "in moving_average_data_good_matrix, "
use_fewer_edge_ = default(.false.,use_fewer_edge)
nobs = size(xx,1)
nvar = size(xx,2)
sizes_obs = [size(xx,1),size(xgood,1),size(xma,1),size(xma_good,1)]
sizes_var = [size(xx,2),size(xgood,2),size(xma,2),size(xma_good,2)]
if (minval(sizes_obs) /= maxval(sizes_obs)) then
   write (*,*) msg,"size(xx,1),size(xgood,1),size(xma,1),size(xma_good,1)=",sizes_obs," must all be equal, STOPPING"
   stop
else if (minval(sizes_var) /= maxval(sizes_var)) then
   write (*,*) msg,"size(xx,2),size(xgood,2),size(xma,2),size(xma_good,2)=",sizes_var," must all be equal, STOPPING"
   stop
end if
do ivar=1,nvar
   call moving_average_data_good(nma,xx(:,ivar),xgood(:,ivar),xma(:,ivar),xma_good(:,ivar), &
                                 use_fewer_edge,use_fewer_middle,default_value)
end do
end subroutine moving_average_data_good_matrix
!
subroutine moving_average_min_obs(nma,xx,xgood,xma,xma_good,min_obs)
! compute moving average with missing data
integer      , intent(in)  :: nma
real(kind=dp), intent(in)  :: xx(:)       ! (nobs)
logical      , intent(in)  :: xgood(:)    ! (nobs)
real(kind=dp), intent(out) :: xma(:)      ! (nobs)
logical      , intent(out) :: xma_good(:) ! (nobs)
integer      , intent(in)  :: min_obs
integer                    :: sizes(4),nobs,mma,i,i1,i2,min_obs_,ngood
min_obs_ = max(1,min(abs(nma),min_obs))
nobs = size(xx)
sizes = [size(xx),size(xgood),size(xma),size(xma_good)]
if (minval(sizes) /= maxval(sizes)) then
   write (*,*) "in moving_average_min_obs, size(xx),size(xgood),size(xma),size(xma_good)=",sizes," must all be equal, STOPPING"
   stop
end if
xma_good = .false.
xma      = bad_real
if (nma > 0) then ! moving average using current and past data
   do i=max(1,min_obs_),nobs
      i1          = max(1,i-nma+1)
      ngood       = count(xgood(i1:i))
      if (ngood >= min_obs_) then
         xma(i)      = mean(pack(xx(i1:i),xgood(i1:i)))
         xma_good(i) = .true.
      end if
   end do
else if (nma < 0) then ! moving average using current and future data
   mma = abs(nma)
   do i=1,min(nobs,nobs+1-min_obs_)
      i2          = min(nobs,i+mma-1)
      ngood       = count(xgood(i:i2))
      if (ngood >= min_obs_) then
         xma(i)      = mean(pack(xx(i:i2),xgood(i:i2)))
         xma_good(i) = .true.
      end if
   end do
else
   xma      = xx
   xma_good = xgood
end if
end subroutine moving_average_min_obs
!
subroutine moving_average_min_obs_matrix(nma,xx,xgood,xma,xma_good,min_obs)
! compute moving average with missing data
integer      , intent(in)    :: nma
real(kind=dp), intent(in)    :: xx(:,:)       ! (nobs,nvar)
logical      , intent(in)    :: xgood(:,:)    ! (nobs,nvar)
real(kind=dp), intent(out)   :: xma(:,:)      ! (nobs,nvar)
logical      , intent(out)   :: xma_good(:,:) ! (nobs,nvar)
integer      , intent(in)    :: min_obs
integer                      :: sizes_obs(4),sizes_var(4),nobs,ivar,nvar
character (len=*), parameter :: msg = "in moving_average_min_obs_matrix, "
nobs = size(xx,1)
nvar = size(xx,2)
sizes_obs = [size(xx,1),size(xgood,1),size(xma,1),size(xma_good,1)]
sizes_var = [size(xx,2),size(xgood,2),size(xma,2),size(xma_good,2)]
if (minval(sizes_obs) /= maxval(sizes_obs)) then
   write (*,*) msg,"size(xx,1),size(xgood,1),size(xma,1),size(xma_good,1)=",sizes_obs," must all be equal, STOPPING"
   stop
else if (minval(sizes_var) /= maxval(sizes_var)) then
   write (*,*) msg,"size(xx,2),size(xgood,2),size(xma,2),size(xma_good,2)=",sizes_var," must all be equal, STOPPING"
   stop
end if
do ivar=1,nvar
   call moving_average_min_obs(nma,xx(:,ivar),xgood(:,ivar),xma(:,ivar),xma_good(:,ivar),min_obs)
end do
end subroutine moving_average_min_obs_matrix
!
subroutine moving_average_data_full(nma,xx,xma)
integer      , intent(in)  :: nma
real(kind=dp), intent(in)  :: xx(:)       ! (nobs)
real(kind=dp), intent(out) :: xma(:)      ! (nobs)
integer                    :: i,sizes(2),nobs,mma,i1,i2
nobs = size(xx)
sizes = [nobs,size(xma)]
if (minval(sizes) /= maxval(sizes)) then
   write (*,*) "in moving_average_data, size(xx),size(xma)=",sizes," must all be equal, STOPPING"
   stop
end if
if (nma > 0) then ! moving average using current and past data
   do i=1,nobs
      i1     = max(1,i-nma+1)
      xma(i) = mean(xx(i1:i))
   end do
else if (nma < 0) then ! moving average using current and future data
   mma = abs(nma)
   do i=1,nobs
      i2     = min(nobs,i+mma-1)
      xma(i) = mean(xx(i:i2))
   end do
else
   xma = xx
end if
end subroutine moving_average_data_full
!
subroutine moving_average_data_full_matrix(nma,xx,xma)
integer      , intent(in)  :: nma
real(kind=dp), intent(in)  :: xx(:,:)     ! (nobs,nvar)
real(kind=dp), intent(out) :: xma(:,:)    ! (nobs,nvar)
integer                    :: ivar,nvar,sizes_obs(2),sizes_var(2),nobs
character (len=*), parameter :: msg = "in moving_average_data_matrix, "
nobs = size(xx,1)
nvar = size(xx,2)
sizes_obs = [nobs,size(xma,1)]
sizes_var = [nvar,size(xma,2)]
if (minval(sizes_obs) /= maxval(sizes_obs)) then
   write (*,*) msg,"size(xx,1),size(xma,1)=",sizes_obs," must be equal, STOPPING"
   stop
else if (minval(sizes_var) /= maxval(sizes_var)) then
   write (*,*) msg,"size(xx,2),size(xma,2)=",sizes_var," must be equal, STOPPING"
   stop
end if
do ivar=1,nvar
   call moving_average_data_full(nma,xx(:,ivar),xma(:,ivar))
end do
end subroutine moving_average_data_full_matrix
!
pure function mean(xx) result(xmean)
real(kind=dp), intent(in) :: xx(:)
real(kind=dp)             :: xmean
xmean = sum(xx)/max(1,size(xx))
end function mean
!
function all_equal_in_vec(vec) result(tf)
integer, intent(in) :: vec(:)
logical :: tf
integer :: i,n
n = size(vec)
tf = .true.
if (n < 2) return
do i=2,n
   if (vec(i) /= vec(i-1)) then
      tf = .false.
      return
   end if
end do
end function all_equal_in_vec
!
subroutine check_all_equal(vec,msg)
integer          , intent(in) :: vec(:)
character (len=*), intent(in) :: msg
if (.not. all_equal(vec)) then
   write (*,*) msg,vec," must all be equal, STOPPING"
   stop
end if
end subroutine check_all_equal
!
function intersection_char(xx,yy) result(zz)
character (len=*)      , intent(in)  :: xx(:),yy(:)
character (len=len(xx)), allocatable :: zz(:)
logical                              :: in_yy(size(xx))
integer                              :: i
do i=1,size(xx)
   in_yy(i) = any(xx(i) == yy)
end do
call set_alloc(pack(xx,in_yy),zz)
end function intersection_char
!
function add_constant_columns(xmat,xconst) result(ymat)
real(kind=dp), intent(in) :: xmat(:,:)
real(kind=dp), intent(in) :: xconst(:)
real(kind=dp)             :: ymat(size(xmat,1),size(xmat,2) + size(xconst))
integer                   :: icol_add,ncol_x
ncol_x = size(xmat,2)
ymat(:,:ncol_x) = xmat
forall (icol_add=1:size(xconst)) ymat(:,ncol_x+icol_add) = xconst(icol_add)
end function add_constant_columns
!
function random_matrix(nrow,ncol) result(xmat)
integer, intent(in) :: nrow,ncol
real(kind=dp)       :: xmat(nrow,ncol)
call random_number(xmat)
end function random_matrix
!
elemental function strip(xx,xchar) result(yy)
! replace trailing characters of xx that equal xchar with a space
character (len=*), intent(in) :: xx
character (len=1), intent(in) :: xchar
character (len=len(xx))       :: yy
integer                       :: i,nlen
yy = xx
nlen = len(xx)
if (nlen < 1) return
do i=nlen,1,-1
   if (yy(i:i) == " ") cycle
   if (yy(i:i) == xchar) then
      yy(i:i) = " "
   else
      return
   end if
end do
end function strip
!
elemental function factorial(n) result(ifact)
integer, intent(in) :: n
integer             :: ifact
integer             :: i
ifact = 1
do i=2,n
   ifact = ifact*i
end do
end function factorial
!
elemental function factorial_long(n) result(ifact)
integer(kind=long_int), intent(in) :: n
integer(kind=long_int)             :: ifact
integer(kind=long_int)             :: i
ifact = 1
do i=2,n
   ifact = ifact*i
end do
end function factorial_long
!
elemental function choose(n,k) result(j)
integer, intent(in)    :: n,k
integer                :: j
integer                :: i
integer(kind=long_int) :: numer,k_
if (k > n) then
   j = 0
   return
end if
if (n < 1) then
   j = 1
   return
end if
if (n == k .or. k == 0) then
   j = 1
   return
else if (k == 1 .or. k == n-1) then
   j = n
   return
end if
k_ = merge(n-k,k,k > n/2) 
numer = 1
do i=n-k_+1,n
   numer = numer*i
end do
j = numer/factorial_long(k_)
! print*,n,k,numer,factorial(k),j
end function choose
!
recursive function choose_func(n,k) result(cmb)
integer :: cmb
integer, intent(in) :: n,k
if (k > n .or. k < 0) then
   cmb = 0
   return
else if (n < 1 .or. k == 0) then
   cmb = 1
   return
end if
if (k == n) then
   cmb = 1
else if (k == 1) then
   cmb = n
else if (mm(n,k) /=0)  then
   cmb = mm(n,k)
else if ((k /= 1) .and. (k /= n)) then
   cmb = choose_func(n-1,k-1) + choose_func(n-1,k)
   mm(n,k) = cmb
end if      
end function choose_func
!
recursive function choose_func_long(n,k) result(cmb)
integer(kind=long_int) :: cmb
integer(kind=long_int), intent(in) :: n,k
if (k > n .or. k < 0) then
   cmb = 0
   return
else if (n < 1 .or. k == 0) then
   cmb = 1
   return
end if
if (k == n) then
   cmb = 1
else if (k == 1) then
   cmb = n
else if (mm(n,k) /=0)  then
   cmb = mm(n,k)
else if ((k /= 1) .and. (k /= n)) then
   cmb = choose_func_long(n-1,k-1) + choose_func_long(n-1,k)
   mm(n,k) = cmb
end if      
end function choose_func_long
!
function few_combinations(n,k) result(imat)
integer, intent(in) :: n,k
integer             :: imat(choose(n,k),k)
integer             :: i1,i2,i3,ncomb
ncomb = 0
imat = 0
if (k == 3) then
   do i1=1,n
      do i2=i1+1,n
         do i3=i2+1,n
            ncomb = ncomb + 1
            imat(ncomb,:) = [i1,i2,i3]
         end do
      end do
   end do
end if
end function few_combinations
!
recursive subroutine gen(m,n_max,m_max,comb,comb_mat,zero_icomb)
! based on https://rosettacode.org/wiki/Combinations#Fortran
integer, intent(in)               :: m,n_max,m_max
integer, intent(in out)           :: comb(m_max)
integer, intent(in out)           :: comb_mat(:,:)
logical, intent(in)    , optional :: zero_icomb
integer                           :: n
integer, save                     :: icomb=0
logical                           :: call_gen
if (default(.false.,zero_icomb)) icomb = 0
if (m > m_max) then
   icomb = icomb + 1
   if (icomb <= size(comb_mat,1)) comb_mat(icomb,:) = comb
else
   do n = 1, n_max
      if (m == 1) then
         call_gen = .true.
      else if (n> comb(m - 1)) then
         call_gen = .true.
      else
         call_gen = .false.
      end if
      if (call_gen) then
         comb(m) = n
         call gen(m+1,n_max,m_max,comb,comb_mat)
      end if
   end do
end if
end subroutine gen
!
subroutine combos(n_max,m_max)
! print combinations of m_max out of n_max
! 06/01/2019 02:38 PM branched from xcombinations.f90
! 06/01/2019 02:37 PM from Rosetta Code, combinations problem https://rosettacode.org/wiki/Combinations#Fortran
integer, intent(in)  :: n_max,m_max
integer              :: icomb,nchoose
integer, allocatable :: comb(:)
logical              :: print_comb_
print_comb_ = .false.
if (allocated(comb_mat)) deallocate (comb_mat)
nchoose = choose(n_max,m_max)
! print*,"n_max, m_max, nchoose =",n_max,m_max,nchoose !! debug
allocate (comb(m_max),comb_mat(nchoose,m_max))
comb = 0
call gen(1,n_max,m_max,comb,comb_mat,zero_icomb=.true.)
if (print_comb_) then
   do icomb=1,nchoose
      write (*,*) icomb,comb_mat(icomb,:)
   end do
   write (*,*) "#comb =",nchoose
end if
end subroutine combos
!
subroutine gen_comb(n,k,imat)
! generate in rows of imat(:,:) all combinations of k things out of n
integer, intent(in)               :: n,k
integer, intent(out), allocatable :: imat(:,:)
if (k > n) then
   if (allocated(imat)) deallocate(imat)
   allocate (imat(0,k))
   return
end if
call combos(n,k)
call set_alloc(comb_mat,imat)
end subroutine gen_comb
!
subroutine write_int(label,ivec,frmt)
character (len=*), intent(in) :: label
integer          , intent(in) :: ivec(:)
character (len=*), intent(in), optional :: frmt
character (len=1000) :: frmt_
if (present(frmt)) then
   frmt_ = frmt
else
   frmt_ = "(a,10000(1x,i0))"
end if
write (*,frmt_) trim(label),ivec
end subroutine write_int
!
function num_missing(ivec,jvec) result(nmiss)
! return the number of elements of jvec not found in ivec
integer, intent(in) :: ivec(:),jvec(:)
integer             :: nmiss
integer             :: i
nmiss = 0
do i=1,size(jvec)
   if (all(jvec(i) /= ivec)) nmiss = nmiss + 1
end do
end function num_missing
!
recursive function moving_average_xlen(xx,xlen) result(xma)
real(kind=dp), intent(in) :: xx(:)
real(kind=dp), intent(in) :: xlen
real(kind=dp)             :: xma(size(xx))
integer                   :: i,i1,nma,n,nma_floor
real(kind=dp)             :: wgt_last,xdiv
n    = size(xx)
if (xlen > n) then
   xma = moving_average_xlen(xx,real(n,kind=dp))
   return
end if
nma  = ceiling(xlen)
xdiv = abs(xlen)
xma  = 0.0_dp
if (nma <= n .and. n > 1) then
   nma_floor = nma - 1
   wgt_last  = xlen - nma_floor
!   print*,"xlen, xdiv, nma_floor, wgt_last =",xlen,xdiv,nma_floor,wgt_last
   do i=1,n
      if (i <= nma_floor) then
         xma(i) = mean(xx(:i))
      else
         i1     = i - nma_floor + 1
         xma(i) = (sum(xx(i1:i)) + wgt_last*xx(i1-1))/xdiv
      end if
   end do
end if
end function moving_average_xlen
!
subroutine add_one_var(nvar,iuse_init,iuse)
integer, intent(in)               :: nvar
integer, intent(in)               :: iuse_init(:)
integer, intent(out), allocatable :: iuse(:,:)
integer                           :: ivar,ncomb,juse(nvar,size(iuse_init)+1)
! print*,"iuse_init=",iuse_init," shape(juse)=",shape(juse) !! debug
ncomb = 0
do ivar=1,nvar
   if (all(iuse_init /= ivar)) then
      ncomb = ncomb + 1
      juse(ncomb,:) = [iuse_init,ivar]
   end if
end do
call set_alloc(juse(:ncomb,:),iuse)
end subroutine add_one_var
!
function diff_vec_char(xx,yy) result(zz)
! return the elements of xx(:) not in yy(:)
character (len=*)      , intent(in)  :: xx(:),yy(:)
character (len=len(xx)), allocatable :: zz(:)
integer                              :: i
logical                              :: xuse(size(xx))
forall (i=1:size(xx)) xuse(i) = all(yy /= xx(i))
call set_alloc(pack(xx,xuse),zz)
end function diff_vec_char
!
pure function concat_char_vec(xx,yy) result(zz)
character (len=*), intent(in) :: xx(:),yy(:)
character (len=max(len(xx),len(yy))) :: zz(size(xx)+size(yy))
integer                              :: nx
nx = size(xx)
zz(:nx)   = xx
zz(nx+1:) = yy
end function concat_char_vec
!
subroutine assert_int_range(msg,var,i,imin,imax)
! assert that imin <= i <= imax
character (len=*), intent(in) :: msg,var
integer          , intent(in) :: i,imin,imax
logical, parameter            :: debug = .false. ! .true.
if (debug) print*,"in assert_int_range, i, imin, imax =",i,imin,imax
if (i < imin .or. i > imax) then
   write (*,"(a,a,i0,a,i0,' <= ',a,' <= ',i0,' , STOPPING')") msg,var // " = ",i," , need ",imin,var,imax
   stop
end if
end subroutine assert_int_range
!
subroutine assert_int_vec_range(msg,var,ivec,imin,imax)
! assert that all(imin <= ivec(:) <= imax)
character (len=*), intent(in) :: msg,var
integer          , intent(in) :: ivec(:),imin,imax
logical, parameter            :: debug = .false. ! .true.
integer                       :: k,n
if (debug) print*,"in assert_int_range, ivec, imin, imax =",ivec,imin,imax
n = size(ivec)
do k=1,n
   if (ivec(k) < imin .or. ivec(k) > imax) then
      write (*,"(a,a,i0,a,i0,a,i0,' <= ',a,' <= ',i0)") msg,"element ",k," of " // var // " equals ", &
      ivec(k)," , need all ",imin,var,imax
      stop
   end if
end do
end subroutine assert_int_vec_range
!
subroutine assert_positive_int(msg,i)
! print an error message and stop if i <= 0
! sample call: call assert_positive("in main, i ",i)
character (len=*), intent(in) :: msg
integer          , intent(in) :: i
if (i <= 0) then
   write (*,"(a,' =',1x,i0,a)") trim(msg),i,", must be > 0, STOPPING"
   stop
end if
end subroutine assert_positive_int
!
subroutine assert_equal_2(msg,n1,n2)
! print an error message and stop if n1 /= n2
character (len=*), intent(in) :: msg   ! beginning of error message
integer          , intent(in) :: n1,n2
if (n1 /= n2) then
   write (*,"(a,2(1x,i0),a)") msg,n1,n2," must be equal, STOPPING"
   stop
end if
end subroutine assert_equal_2
!
subroutine assert_le(n1,n2,name1,name2,procedure)
! print an error message and stop if n1 > n2
integer          , intent(in) :: n1,n2
character (len=*), intent(in) :: procedure   ! name of program unit where assertion is made
character (len=*), intent(in) :: name1,name2 ! variable names 
if (n1 > n2) then
   write (*,"(a,2(1x,a),' =',2(1x,i0),a)") "in " // trim(procedure) // ",", &
          trim(name1),trim(name2),n1,n2," need " // trim(name1) // " <= " // trim(name2) // ", STOPPING"
   stop
end if
end subroutine assert_le
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
subroutine assert_equal_3__(n1,n2,n3,name1,name2,name3,procedure)
! print an error message and stop if n1, n2, and n3 are not all equal
integer          , intent(in) :: n1,n2,n3
character (len=*), intent(in) :: procedure         ! name of procedure where assertion is made
character (len=*), intent(in) :: name1,name2,name3 ! variable names 
if (n1 /= n2 .or. n1 /= n3) then
   write (*,"(a,3(1x,a),' =',3(1x,i0),a)") "in " // trim(procedure) // ",", &
          trim(name1),trim(name2),trim(name3),n1,n2,n3," must be equal, STOPPING"
   stop
end if
end subroutine assert_equal_3__
!
subroutine assert_equal_4__(n1,n2,n3,n4,name1,name2,name3,name4,procedure)
! print an error message and stop if n1, n2, and n3 are not all equal
integer          , intent(in) :: n1,n2,n3,n4
character (len=*), intent(in) :: procedure               ! name of procedure where assertion is made
character (len=*), intent(in) :: name1,name2,name3,name4 ! variable names 
if (n1 /= n2 .or. n1 /= n3 .or. n1 /= n4) then
   write (*,"(a,4(1x,a),' =',4(1x,i0),a)") "in " // trim(procedure) // ",", &
          trim(name1),trim(name2),trim(name3),trim(name4),n1,n2,n3,n4," must be equal, STOPPING"
   stop
end if
end subroutine assert_equal_4__
!
subroutine assert_less(msg,n1,n2)
integer          , intent(in) :: n1,n2
character (len=*), intent(in) :: msg
if (n1 >= n2) then
   write (*,"(a,2(1x,i0),a)") msg,n1,n2," need n1 < n2, STOPPING"
   stop
end if
end subroutine assert_less
!
subroutine assert_equal_3(msg,n1,n2,n3)
integer          , intent(in) :: n1,n2,n3
character (len=*), intent(in) :: msg
if (n1 /= n2 .or. n1 /= n3) then
   write (*,"(a,3(1x,i0),a)") msg,n1,n2,n3," must be equal, STOPPING"
   stop
end if
end subroutine assert_equal_3
!
subroutine assert_equal_4(msg,n1,n2,n3,n4)
integer          , intent(in) :: n1,n2,n3,n4
character (len=*), intent(in) :: msg
if (any([n2,n3,n4] /= n1)) then
   write (*,"(a,4(1x,i0),a)") msg,n1,n2,n3,n4," must be equal, STOPPING"
   stop
end if
end subroutine assert_equal_4
!
subroutine stop_if_missing(xx,yy,msg)
character (len=*), intent(in) :: xx(:),yy(:),msg
integer                       :: i,nmiss
nmiss = 0
do i=1,size(xx)
   if (all(yy /= xx(i))) then
      nmiss = nmiss + 1
      if (nmiss == 1) write (*,"(/,a)") msg
      write (*,"(a)") trim(xx(i))
   end if
end do
if (nmiss > 0) stop "STOPPED in stop_if_missing()"
end subroutine stop_if_missing
!
function squared_distances_rows(xx) result(xdist)
! compute Euclidean squared distances between rows
real(kind=dp), intent(in) :: xx(:,:)
real(kind=dp)             :: xdist(size(xx,1),size(xx,1))
integer                   :: i,j,nrows
nrows = size(xx,1)
do i=1,nrows
   do j=1,i-1
      xdist(i,j) = sum((xx(i,:)-xx(j,:))**2)
   end do
   xdist(i,i) = 0.0_dp
end do
do i=1,nrows
   do j=i+1,nrows
      xdist(i,j) = xdist(j,i)
   end do
end do
end function squared_distances_rows
!
function distances_rows(xx) result(xdist)
! compute Euclidean squared distances between rows
real(kind=dp), intent(in) :: xx(:,:)
real(kind=dp)             :: xdist(size(xx,1),size(xx,1))
xdist = sqrt(squared_distances_rows(xx))
end function distances_rows
!
function squared_distances(xx) result(xdist)
real(kind=dp), intent(in) :: xx(:,:)
real(kind=dp)             :: xdist(size(xx,2),size(xx,2))
integer                   :: i,j,ncol
ncol = size(xx,2)
do i=1,ncol
   do j=1,i-1
      xdist(i,j) = sum((xx(:,i)-xx(:,j))**2)
   end do
   xdist(i,i) = 0.0_dp
end do
do i=1,ncol
   do j=i+1,ncol
      xdist(i,j) = xdist(j,i)
   end do
end do
end function squared_distances
!
elemental function elu(xx) result(yy)
real(kind=dp), intent(in) :: xx
real(kind=dp)             :: yy
if (xx >= 0.0_dp) then
   yy = xx
else
   yy = exp(xx) - 1.0_dp
end if
end function elu
!
elemental function elu_smooth(xx) result(yy)
real(kind=dp), intent(in) :: xx
real(kind=dp)             :: yy
real(kind=dp)             :: c
if (xx >= 0.0_dp) then
   yy = xx
else if (xx >= -1.0_dp) then
   c  = 1.0_dp + xx
   yy = c*xx + (1-c)*(exp(xx) - 1.0_dp)    
else
   yy = exp(xx) - 1.0_dp
end if
end function elu_smooth
!
elemental function x_times_logistic(xx) result(yy)
real(kind=dp), intent(in) :: xx
real(kind=dp)             :: yy
yy = xx*logistic(xx)
end function x_times_logistic
!
elemental function elu_logistic(xx) result(yy)
real(kind=dp), intent(in) :: xx
real(kind=dp)             :: yy
yy = xx*logistic(xx) + (1-logistic(xx))*(exp(xx) - 1.0_dp) 
end function elu_logistic
!
elemental function logistic(xx) result(yy)
real(kind=dp), intent(in) :: xx
real(kind=dp)             :: yy
yy = 1/(1 + exp(-xx))
end function logistic
!
subroutine missing_pos(ivec,jvec,ipos_miss)
! return the positions in ivec(:) that are not found in jvec(:)
integer, intent(in)               :: ivec(:),jvec(:)
integer, intent(out), allocatable :: ipos_miss(:)    ! positions in ivec(:) not found in jvec(:)
logical                           :: ivec_miss(size(ivec))
integer                           :: i
forall (i=1:size(ivec)) ivec_miss(i) = all(jvec /= ivec(i))
call set_alloc(true_pos(ivec_miss),ipos_miss)
end subroutine missing_pos
!
subroutine missing_pos_in_range(ivec,jvec,imin,imax,ipos_miss)
! return the positions in ivec(:) that are not found in jvec(:) and are in the range (imin,imax) inclusive
integer, intent(in)               :: ivec(:),jvec(:),imin,imax
integer, intent(out), allocatable :: ipos_miss(:)    ! positions in ivec(:) not found in jvec(:)
logical                           :: ivec_miss(size(ivec))
integer                           :: i
forall (i=1:size(ivec)) ivec_miss(i) = ivec(i) >= imin .and. ivec(i) <= imax .and. all(ivec(i) /= jvec)
call set_alloc(true_pos(ivec_miss),ipos_miss)
end subroutine missing_pos_in_range
!
function maxloc_match_1(k,ivec,xx) result(j)
! find the position of the largest value of xx(:) such that ivec(:) == k
integer      , intent(in) :: k
integer      , intent(in) :: ivec(:) ! (n)
real(kind=dp), intent(in) :: xx(:)   ! (m)
integer                   :: j
integer                   :: i,n
real(kind=dp)             :: xmax
logical                   :: max_so_far
n = size(ivec)
if (size(xx) /= n) then
   write (*,*) "in maxloc_match, size(ivec), size(xx) =",size(ivec),size(xx)," must be equal, STOPPING"
   stop
end if
j = 0
if (n < 1) return
do i=1,n
   if (ivec(i) /= k) cycle
   max_so_far = .false.
   if (i == 1) then
      max_so_far = .true.
      j = 1
      xmax = xx(i)
   else if (xx(i) > xmax) then
      max_so_far = .true.
   end if
   if (max_so_far) then
      j    = i
      xmax = xx(i)
   end if
end do
end function maxloc_match_1
!
function maxloc_match_2(k1,k2,ivec,xx) result(j)
! find the position of the largest value of xx(:) such that ivec(:) == k
integer      , intent(in) :: k1,k2
integer      , intent(in) :: ivec(:,:) ! (n,2)
real(kind=dp), intent(in) :: xx(:)     ! (m)
integer                   :: j
integer                   :: i,n
real(kind=dp)             :: xmax
logical                   :: max_so_far
character (len=*), parameter :: msg = "in maxloc_match, "
n = size(ivec,1)
if (size(xx) /= n) then
   write (*,*) msg,"size(ivec), size(xx) =",size(ivec),size(xx)," must be equal, STOPPING"
   stop
else if (size(ivec,2) /= 2) then
   write (*,*) msg,"size(ivec,2) =",size(ivec,2)," must be 2, STOPPING"
   stop
end if
j = 0
if (n < 1) return
do i=1,n
   if (ivec(i,1) /= k1 .or. ivec(i,2) /= k2) cycle
   max_so_far = .false.
   if (i == 1) then
      max_so_far = .true.
      j = 1
      xmax = xx(i)
   else if (xx(i) > xmax) then
      max_so_far = .true.
   end if
   if (max_so_far) then
      j    = i
      xmax = xx(i)
   end if
end do
end function maxloc_match_2
!
function num_lines_string_first_field(string,xfile) result(nfound)
! return the number of times string is found in first field of lines of file xfile
character (len=*), intent(in) :: string
character (len=*), intent(in) :: xfile
integer                       :: nfound
integer                       :: iu,ierr
character (len=len(string))   :: cc
logical          , parameter  :: debug = .false.
nfound = 0
call get_unit_open_file(xfile,iu,"r")
do
   read (iu,*,iostat=ierr) cc
   if (ierr /= 0) exit
   if (cc == string) nfound = nfound + 1
end do
if (debug) write (*,*) "#times '" // trim(string) // "' found in '" // trim(xfile) // "' =",nfound
close(iu)
end function num_lines_string_first_field
!
subroutine alloc_init_real(n,xinit,xx)
integer      , intent(in)               :: n
real(kind=dp), intent(in)               :: xinit
real(kind=dp), intent(out), allocatable :: xx(:)
allocate (xx(n))
xx = xinit
end subroutine alloc_init_real
!
function num_lines_file(xfile) result(nlines)
character (len=*), intent(in)  :: xfile
integer                        :: nlines
integer                        :: ierr,iu
call get_unit(iu)
nlines = 0
open (unit=iu,file=xfile,action="read",iostat=ierr)
if (ierr /= 0) then
   nlines = -1
   return
end if
do
   read (iu,*,iostat=ierr)
   if (ierr /= 0) exit
   nlines = nlines + 1
end do
close(iu)
end function num_lines_file
!
function lookup_data(strings,string_data,ydata,msg_no_match) result(yy)
! return the values of ydata(:) corresponding to strings(:) in string_data(:)
character (len=*), intent(in) :: strings(:)
character (len=*), intent(in) :: string_data(:) ! (n)
real(kind=dp)    , intent(in) :: ydata(:)       ! (n)
character (len=*), intent(in), optional :: msg_no_match
real(kind=dp)                 :: yy(size(strings))
integer                       :: i,ipos,ndata
character (len=*), parameter  :: msg = "in util_mod::lookup_data, "
ndata = size(string_data)
if (size(ydata) /= ndata) then
   write (*,*) msg,"size(string_data), size(ydata)=",ndata,size(ydata)," must be equal, STOPPING"
   stop
end if
do i=1,size(strings)
   ipos = match_string(strings(i),string_data)
   if (ipos == 0) then
      write (*,*) msg
      if (present(msg_no_match)) then
         write (*,"(a)") trim(msg_no_match)
      else
         write (*,"('no match for')")
      end if
      write (*,*) trim(strings(i))
      stop "stopping"
   end if
   yy(i) = ydata(ipos)
end do
end function lookup_data
!
pure function sum_ranges(xx,ilast,default_sum) result(xsums)
real(kind=dp), intent(in)           :: xx(:)
integer      , intent(in)           :: ilast(:)
real(kind=dp), intent(in), optional :: default_sum
real(kind=dp)                       :: xsums(size(ilast))
integer                             :: i,j1,j2,n
n = size(xx)
xsums = default(0.0_dp,default_sum)
do i=1,size(ilast)
   if (i == 1) then
      j1 = 1
   else
      j1 = ilast(i-1) + 1
   end if
   j2 = ilast(i)
   if (j1 <= n .and. j1 > 0 .and. j2 <= n .and. j2 > 0) xsums(i) = sum(xx(j1:j2))
end do
end function sum_ranges
!
function duplicate_columns(xx) result(idup)
! return in idup(i) the column of xx(:,:) that is the same as xx(:,i), 0 if no other column is the same
real(kind=dp), intent(in) :: xx(:,:)
integer                   :: idup(size(xx,2))
integer                   :: nrows,ncol,icol,jcol
nrows = size(xx,1)
ncol  = size(xx,2)
idup  = 0
do_icol: do icol=2,ncol
   do jcol=1,icol-1
      if (all(xx(:,icol) == xx(:,jcol))) then
         idup(icol) = jcol
         cycle do_icol
      end if
   end do
end do do_icol
end function duplicate_columns
!
elemental function is_positive(i) result(tf)
integer, intent(in), optional :: i
logical                       :: tf
if (present(i)) then
   tf = i > 0
else
   tf = .false.
end if
end function is_positive
!
subroutine print_absolute_threshold_counts(xx,thresh,fmt_header,fmt_trailer)
! for each threshold, print the number of values in xx(:) that are greater in absolute value and the number on each side
real(kind=dp)    , intent(in)           :: xx(:)
real(kind=dp)    , intent(in)           :: thresh(:)
character (len=*), intent(in), optional :: fmt_header,fmt_trailer
integer                                 :: ithresh,nthresh,outu_,nmore,nless,n,irepeat
real(kind=dp)                           :: th
n = size(xx)
outu_ = istdout
nthresh = size(thresh)
if (nthresh < 1 .or. n < 1) return
call write_format(fmt_header,iunit=outu_)
write (outu_,"(100a15)") "thresh",("|x| > thresh","x > thresh","x < -thresh",irepeat=1,2)
do ithresh=1,nthresh
   th = thresh(ithresh)
   nmore = count(xx >  th)
   nless = count(xx <- th)
   write (outu_,"(f15.2,3i15,100f15.6)") th,nmore+nless,nmore,nless,[nmore+nless,nmore,nless]/dble(n)
end do
call write_format(fmt_trailer,iunit=outu_)
end subroutine print_absolute_threshold_counts
!
subroutine print_threshold_counts(xx,thresh,fmt_header,fmt_trailer)
! for each threshold, print the number of values in xx(:) that are greater
real(kind=dp)    , intent(in)           :: xx(:)
real(kind=dp)    , intent(in)           :: thresh(:)
character (len=*), intent(in), optional :: fmt_header,fmt_trailer
integer                                 :: ithresh,nthresh,outu_,nmore,n
real(kind=dp)                           :: th
n = size(xx)
outu_ = istdout
nthresh = size(thresh)
if (nthresh < 1 .or. n < 1) return
call write_format(fmt_header,iunit=outu_)
write (outu_,"(100a15)") "thresh","#x > thresh","fraction"
do ithresh=1,nthresh
   th = thresh(ithresh)
   nmore = count(xx >  th)
   write (outu_,"(f15.2,i15,f15.6)") th,nmore,nmore/dble(n)
end do
call write_format(fmt_trailer,iunit=outu_)
end subroutine print_threshold_counts
!
subroutine print_prices_large_returns(xx,thresh_low,thresh_high,icol_price,scale_ret,outu)
real(kind=dp), intent(in)           :: xx(:,:)
real(kind=dp), intent(in)           :: thresh_low,thresh_high
integer      , intent(in)           :: icol_price
real(kind=dp), intent(in), optional :: scale_ret
integer      , intent(in), optional :: outu
integer                             :: i,j,outu_,nret
real(kind=dp), allocatable          :: xret(:)
outu_ = default(istdout,outu)
nret = size(xx,1) - 1
if (nret < 1) return
call set_alloc(xx(2:,icol_price)/xx(:nret,icol_price)-1.0_dp,xret)
if (present(scale_ret)) xret = scale_ret*xret
do i=1,nret
   if (xret(i) < thresh_low .or. xret(i) > thresh_high) then
      write (outu_,"(/,'return = ',f14.4)") xret(i)
      do j=i,i+1
         write (outu_,"(100f14.4)") xx(j,:)         
      end do
   end if
end do
end subroutine print_prices_large_returns
!
subroutine read_words(iu,words,echo)
! read an integer, allocate words(:), and read one word per line
integer          , intent(in)               :: iu
character (len=*), intent(out), allocatable :: words(:)
logical          , intent(in) , optional    :: echo
integer                                     :: i,n
logical                                     :: echo_
echo_ = default(.false.,echo)
read (iu,*) n
allocate (words(n))
do i=1,n
   read (iu,*) words(i)
   if (echo_) write (*,"(a)") trim(words(i))
end do
end subroutine read_words
!
subroutine filter_matrix_rows(xx,icol,xmin,xmax)
! keep rows for which the data in columns icol(:) are within xmin(:) and xmax(:)
real(kind=dp), intent(in out), allocatable :: xx(:,:)
integer      , intent(in)                  :: icol(:)          ! (ncol_filter)
real(kind=dp), intent(in)                  :: xmin(:), xmax(:) ! (ncol_filter)
integer                                    :: j,jcol,ncol,ncol_filter
logical                                    :: xmask(size(xx,1))
ncol_filter = size(icol)
if (size(xmin) /= ncol_filter .or. size(xmax) /= ncol_filter) then
   write (*,*) "in util_mod::filter_matrix_rows, size(icol), size(xmin), size(xmax) =", &
               ncol_filter,size(xmin),size(xmax)," must be equal, STOPPING"
   stop
end if
ncol = size(xx,2)
if (ncol_filter < 1) return
xmask = .true.
do j=1,ncol_filter
   jcol = icol(j)
   if (jcol > 0 .and. jcol <= ncol) &
      xmask = xmask .and. xx(:,jcol) >= xmin(j) .and. xx(:,jcol) <= xmax(j)
end do
if (.not. all(xmask)) call set_alloc((xx(true_pos(xmask),:)),xx)
end subroutine filter_matrix_rows
!
pure recursive function nearby_pos(ivec,bad_val,method) result(jvec)
! return in jvec(:) the values in ivec(:), replacing bad values with ones found nearby
integer          , intent(in) :: ivec(:)
integer          , intent(in) :: bad_val
character (len=*), intent(in) :: method
integer                       :: jvec(size(ivec))
integer                       :: i,j,n
if (method == "earlier_then_later") then
   jvec = nearby_pos(nearby_pos(ivec,bad_val,"earlier"),bad_val,"later")
   return
end if
n = size(ivec)
jvec = ivec
do i=1,n
   if (ivec(i) == bad_val) then
      if (method == "earlier") then
         do j=i-1,1,-1
            if (ivec(j) /= bad_val) then
               jvec(i) = ivec(j)
               exit
            end if
         end do
      else if (method == "later") then
         do j=i+1,n
            if (ivec(j) /= bad_val) then
               jvec(i) = ivec(j)
               exit
            end if
         end do
      end if
   end if
end do
end function nearby_pos
!
elemental function int_within(i,i1,i2) result(tf)
integer, intent(in) :: i,i1,i2
logical             :: tf
tf = i >= i1 .and. i <= i2
end function int_within
!
elemental function real_within(x,x1,x2) result(tf)
real(kind=dp), intent(in) :: x,x1,x2
logical                   :: tf
tf = x >= x1 .and. x <= x2
end function real_within
!
function max_consecutive(tf) result(nmax)
logical, intent(in) :: tf(:)
integer             :: nmax
integer             :: i,ntrue
nmax = 0
ntrue = 0
do i=1,size(tf)
   if (tf(i)) then
      ntrue = ntrue + 1
   else
      ntrue = 0
   end if
   nmax = max(nmax,ntrue) 
end do
end function max_consecutive
!
pure function num_good_rows(good,min_good,max_bad) result(ngood)
! print the number of rows of good(:,:) that have at least min_good .true. values and no more than max_bad .false. values
logical, intent(in)           :: good(:,:)
integer, intent(in), optional :: min_good,max_bad
integer                       :: ngood
ngood = count(count(good,2)        >= default(1,min_good) .and. &
        count(.not. good,2)        <= default(size(good,2)-1,max_bad))
end function num_good_rows
!
function filter_vec(ivec,ibad,ascending) result(jvec)
! return in jvec(:) the elements of ivec(:), excluding those found in ibad(:)
integer, intent(in)           :: ivec(:)
integer, intent(in)           :: ibad(:)
logical, intent(in), optional :: ascending ! if .true., assume that ivec(:) and ibad(:) are non-descending
integer, allocatable          :: jvec(:)
call set_alloc(pack(ivec,mask_vec(ivec,ibad,ascending)),jvec)
end function filter_vec
!
function mask_vec(ivec,ibad,ascending) result(imask)
! return in imask(:) .true. if the corresponding element of ivec is not found in ibad(:)
integer, intent(in)           :: ivec(:)
integer, intent(in)           :: ibad(:)
logical, intent(in), optional :: ascending ! if .true., assume that ivec(:) and ibad(:) are non-descending
logical                       :: imask(size(ivec))
integer                       :: i,i1,ipos,n,nbad
logical                       :: found,ascending_
ascending_ = default(.false.,ascending)
imask = .true.
n = size(ivec)
nbad = size(ibad)
if (n == 0 .or. nbad == 0) return
if (ascending_) then
   i1 = 1
   ! write (*,"(5a8)") "i","ivec(i)","ipos","i1","found"
   do i=1,n
      call exact_match_ascending_int(ibad,ivec(i),ipos,found,i1)
      imask(i) = .not. found
   !   write (*,"(4i8,l8)") i,ivec(i),ipos,i1,found
      if (found) i1 = ipos
   end do
else
   forall (i=1:n) imask(i) = all(ibad /= ivec(i))
end if
end function mask_vec
!
function c(x1,x2,x3,x4,x5,x6,x7,x8,x9,x10) result(vec)
! return character array containing present arguments
character (len=*)  , intent(in), optional    :: x1,x2,x3,x4,x5,x6,x7,x8,x9,x10
character (len=100)            , allocatable :: vec(:)
character (len=100)            , allocatable :: vec_(:)
integer                                      :: n
allocate (vec_(10))
if (present(x1))  vec_(1)  = x1
if (present(x2))  vec_(2)  = x2
if (present(x3))  vec_(3)  = x3
if (present(x4))  vec_(4)  = x4
if (present(x5))  vec_(5)  = x5
if (present(x6))  vec_(6)  = x6
if (present(x7))  vec_(7)  = x7
if (present(x8))  vec_(8)  = x8
if (present(x9))  vec_(9)  = x9
if (present(x10)) vec_(10) = x10
n = count([present(x1),present(x2),present(x3),present(x4),present(x5), &
           present(x6),present(x7),present(x8),present(x9),present(x10)])
! print*,"n=",n !! debug
allocate (vec(n))
if (n > 0) vec = vec_(:n)
end function c
!
function positions_char_string(string,char) result(ipos)
! return in ipos(:) the positions of char in string, where char is assumed to have length 1
character (len=*), intent(in)  :: string  ! string that is searched
character (len=*), intent(in)  :: char    ! character to look for in string
integer          , allocatable :: ipos(:) ! positions of char in string
logical                        :: tf(len(string))
integer                        :: i
forall (i=1:len(string)) tf(i) = string(i:i) == char
call set_alloc(true_pos(tf),ipos)
end function positions_char_string
!
function split(string,delim,adjustl_words) result(words)
! split string by delim
character (len=*)   , intent(in)  :: string
character (len=*)   , intent(in)  :: delim
logical             , intent(in), optional :: adjustl_words
character (len=1000), allocatable :: words(:)
integer             , allocatable :: ipos(:)
integer                           :: i,ndelim,nlen
call set_alloc(positions_char_string(trim(string),delim),ipos)
ndelim = size(ipos)
nlen = len_trim(string)
allocate (words(ndelim+1))
if (ndelim == 0) then
   words(1) = string
   return
end if
words(1) = string(1:ipos(1)-1)
do i=2,ndelim
   words(i) = string(ipos(i-1)+1:ipos(i)-1)
end do
words(ndelim+1) = string(ipos(ndelim)+1:nlen)
if (default(.false.,adjustl_words)) words = adjustl(words)
end function split
!
subroutine split_string(string,delim,words,adjustl_words)
! split string by delim
character (len=*)                , intent(in)  :: string
character (len=*)                , intent(in)  :: delim
character (len=*)   , allocatable, intent(out) :: words(:)
logical             , optional   , intent(in)  :: adjustl_words
call set_alloc(split(string,delim,adjustl_words=adjustl_words),words)
end subroutine split_string
!
function nonzero_real(xx) result(xnz)
! return the nonzero values of xx(:)
real(kind=dp), intent(in)  :: xx(:)
real(kind=dp), allocatable :: xnz(:)
call set_alloc(pack(xx,xx/=0.0_dp),xnz)
end function nonzero_real
!
function nonzero_int(ii) result(inz)
! return the nonzero values of ii(:)
integer, intent(in)  :: ii(:)
integer, allocatable :: inz(:)
call set_alloc(pack(ii,ii/=0.0_dp),inz)
end function nonzero_int
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
function indexx_order_real(xx,order) result(iord)
! return iord(:) such that xx(iord) has specified order
real(kind=dp)    , intent(in)           :: xx(:)
character (len=*), intent(in), optional :: order ! "a" for ascending, "d" for descending, "" or "none" for original ordering
integer                                 :: iord(size(xx))
integer                                 :: i
character (len=1)                       :: ch
forall (i=1:size(xx)) iord(i) = i
if (.not. present(order)) return
if (order == "" .or. order == "none") return
ch = order(1:1)
if (ch == "a" .or. ch == "A") then
   iord = indexx(xx)
else if (ch == "d" .or. ch == "D") then
   iord = indexx(-xx)
end if
end function indexx_order_real
!
elemental function piecewise_cubic_unit(xx) result(yy)
! cubic function that passes through (-1,1) and (1,1) and has zero slope at x = -1 and x = 1
real(kind=dp), intent(in) :: xx
real(kind=dp)             :: yy
if (xx <= -1.0_dp) then
   yy = -1.0_dp
else if (xx >= 1.0_dp) then
   yy =  1.0_dp
else 
   yy = (3*xx - xx**3)/2
end if
end function piecewise_cubic_unit
!
elemental function piecewise_quintic_unit(xx) result(yy)
! quintic function that passes through (-1,1) and (1,1) and has zero slope at x = -1 and x = 1
real(kind=dp), intent(in) :: xx
real(kind=dp)             :: yy
if (xx <= -1.0_dp) then
   yy = -1.0_dp
else if (xx >= 1.0_dp) then
   yy =  1.0_dp
else 
   yy = (15*xx - 10*xx**3 + 3*xx**5)/8
end if
end function piecewise_quintic_unit
!
elemental function piecewise_cubic(xx,x1,x2,y1,y2) result(yy)
! return y1 for xx <= x1, y2 for xx >= x2, and a cubic interpolant in between that has zero derivative at x = x1 and x = x2
real(kind=dp), intent(in) :: xx,x1,x2,y1,y2
real(kind=dp)             :: yy
real(kind=dp)             :: x12
if (xx <= x1) then
   yy = y1
   return
else if (xx >= x2) then
   yy = y2
   return
end if
x12 = x2 - x1
if (x12 == 0.0_dp) then
   yy = (y1 + y2)/2
   return
end if
yy = piecewise_cubic_unit(2*(xx-x1)/x12 - 1)*(y2-y1)/2 + (y1+y2)/2
end function piecewise_cubic
!
elemental function piecewise_quintic(xx,x1,x2,y1,y2) result(yy)
! return y1 for xx <= x1, y2 for xx >= x2, and a quintic interpolant in between that has zero 1st and 2nd derivatives at x1 anx x2
real(kind=dp), intent(in) :: xx,x1,x2,y1,y2
real(kind=dp)             :: yy
real(kind=dp)             :: x12
if (xx <= x1) then
   yy = y1
   return
else if (xx >= x2) then
   yy = y2
   return
end if
x12 = x2 - x1
if (x12 == 0.0_dp) then
   yy = (y1 + y2)/2
   return
end if
yy = piecewise_quintic_unit(2*(xx-x1)/x12 - 1)*(y2-y1)/2 + (y1+y2)/2
end function piecewise_quintic
!
elemental function piecewise_func_unit(xx,func) result(yy)
! return -1 for xx <= -1, 1 for xx >= 1, and an interpolant in between
real(kind=dp)    , intent(in) :: xx
character (len=*), intent(in) :: func
real(kind=dp)                 :: yy
if (xx <= -1.0_dp) then
   yy = -1.0_dp
   return
else if (xx >= 1.0_dp) then
   yy = 1.0_dp
   return
end if
select case (func)
   case ("cubic")   ; yy = (3*xx - xx**3)/2
   case ("quintic") ; yy = (15*xx - 10*xx**3 + 3*xx**5)/8
   case ("sine")    ; yy = sin(pi*xx/2)
   case ("constant"); yy = 0.0_dp
   case ("linear")  ; yy = xx
   case ("tanh2")   ; yy = tanh(2*xx)
   case ("sqrt")   
      if (xx >= 1.0_dp) then
         yy = 1.0_dp
      else if (xx >= 0.0_dp) then
         yy = sqrt(xx)
      else if (xx > -1.0_dp) then
         yy = -sqrt(-xx)
      else
         yy = -1.0_dp
      end if
   case ("sqnl") ! square nonlinearity
      if (xx >= 1.0_dp) then
         yy = 1.0_dp
      else if (xx >= 0.0_dp) then
         yy = 2*xx - xx**2
      else if (xx > -1.0_dp) then
         yy = 2*xx + xx**2
      else
         yy = -1.0_dp
      end if
   case default     ; yy = xx
end select
end function piecewise_func_unit
!
elemental function piecewise_func(xx,x1,x2,y1,y2,func) result(yy)
! return y1 for xx <= x1, y2 for xx >= x2, and an interpolant in between
real(kind=dp)    , intent(in) :: xx,x1,x2,y1,y2
character (len=*), intent(in) :: func
real(kind=dp)                 :: yy
real(kind=dp)                 :: x12,ymean,xscaled
ymean = (y1+y2)/2
if (xx <= x1) then
   yy = y1
   return
else if (xx >= x2) then
   yy = y2
   return
end if
x12   = x2 - x1
if (x12 == 0.0_dp) then
   yy = ymean
   return
end if
xscaled = 2*(xx-x1)/x12 - 1
yy = 0.5_dp*(y2-y1)*piecewise_func_unit(xscaled,func) + ymean
end function piecewise_func
!
subroutine changes_positions(ivec,ipos,ival)
! return the first position and the positions where ivec(:) changes, and the corresponding values
integer, intent(in)               :: ivec(:)
integer, intent(out), allocatable :: ipos(:)
integer, intent(out), allocatable :: ival(:)
integer                           :: i,ich,n,nch
n = size(ivec)
if (n < 1) then
   allocate (ipos(0),ival(0))
   return
end if
nch = num_changes(ivec)
allocate (ipos(nch),ival(nch))
ipos(1) = 1
ival(1) = ivec(1)
ich = 1
do i=2,n
   if (ivec(i) /= ivec(i-1)) then
      ich = ich + 1
      ipos(ich) = i
      ival(ich) = ivec(i)
      if (ich == nch) exit
   end if
end do
end subroutine changes_positions
!
function count_rows(tf_mat) result(ntrue)
logical, intent(in) :: tf_mat(:,:)
integer             :: ntrue(size(tf_mat,1))
integer             :: i,n
n = size(tf_mat,1)
forall (i=1:n) ntrue(i) = count(tf_mat(i,:))
end function count_rows
!
subroutine row_count_changes(tf_mat,irows,ntrue)
logical, intent(in)               :: tf_mat(:,:)
integer, intent(out), allocatable :: irows(:),ntrue(:)
call changes_positions(count_rows(tf_mat),irows,ntrue)
end subroutine row_count_changes
!
subroutine set_optional_check_size(xx,xopt,xdefault)
! set xopt(:) to xx(:) if xopt(:) is present and the same size as xx(:)
! otherwise, set xopt(:) to xdefault if xdefault is present
real(kind=dp), intent(in)               :: xx(:)
real(kind=dp), intent(in out), optional :: xopt(:)
real(kind=dp), intent(in)    , optional :: xdefault
if (present(xopt)) then
   if (size(xx) == size(xopt)) then
      xopt = xx
   else if (present(xdefault)) then
      xopt = xdefault
   end if
end if           
end subroutine set_optional_check_size
!
subroutine subset_char(xfind,xdata,xfound)
! return in xfound the elements of xfind found in xdata
character (len=*), intent(in)               :: xfind(:),xdata(:)
character (len=*), intent(out), allocatable :: xfound(:)
logical                                     :: x_in_y(size(xfind))
x_in_y = xfind .in. xdata
call set_alloc(pack(xfind,x_in_y),xfound)
end subroutine subset_char
!
subroutine subset_vec_mat(sym_find,sym,xmat,sym_found,ymat)
! return in sym_found the elements of sym_find found in sym and in ymat the corresponding columns of xmat
character (len=*), intent(in)               :: sym_find(:)
character (len=*), intent(in)               :: sym(:)       ! (nsym)
real(kind=dp)    , intent(in)               :: xmat(:,:)    ! (n,nsym)
character (len=*), intent(out), allocatable :: sym_found(:) ! (nfound)
real(kind=dp)    , intent(out), allocatable :: ymat(:,:)    ! (n,nfound)
integer                       , allocatable :: iuse(:)
integer                                     :: ipos(size(sym_find))
ipos = sym_find .posin. sym
call set_alloc(true_pos(ipos > 0), iuse)
call set_alloc(sym_find(iuse),sym_found)
call set_alloc(xmat(:,pack(ipos,ipos>0)),ymat)
end subroutine subset_vec_mat
!
subroutine assert_zero(icode,msg)
integer          , intent(in) :: icode
character (len=*), intent(in) :: msg
if (icode == 0) return
write (*,"(a,1x,i0,a)") trim(msg),icode,", must be zero, STOPPING"
stop
end subroutine assert_zero
!
pure subroutine bound_positions(xpos,min_pos,max_pos,max_gross)
! bound indvidual positions between min_pos and max_pos and the gross position below max_gross
real(kind=dp), intent(inout)        :: xpos(:)
real(kind=dp), intent(in), optional :: min_pos,max_pos
real(kind=dp), intent(in), optional :: max_gross
real(kind=dp)                       :: gross_pos
if (present(min_pos)) xpos = max(min_pos,xpos)
if (present(max_pos)) xpos = min(max_pos,xpos)
if (present(max_gross)) then
   if (max_gross > 0.0_dp) then
      gross_pos = sum(abs(xpos))
      if (gross_pos > max_gross) xpos = xpos*max_gross/gross_pos
   else
      xpos = 0.0_dp
   end if
end if
end subroutine bound_positions
!
pure function capped_sum_abs(xx,cap) result(yy)
! return vector that is scaled so that the sum of its absolute values does not exceed cap
real(kind=dp), intent(in) :: xx(:)
real(kind=dp), intent(in) :: cap
real(kind=dp)             :: yy(size(xx))
real(kind=dp)             :: sum_abs
yy = 0.0_dp
if (cap > 0.0_dp) then
   sum_abs = sum(abs(xx))
   if (sum_abs > cap) yy = xx * cap/sum_abs
end if
end function capped_sum_abs
!
function capped_sum_abs_rows(xx,cap) result(yy)
! return arrat that is scaled so that the sum of the absolute values of each row does not exceed cap
real(kind=dp), intent(in) :: xx(:,:)
real(kind=dp), intent(in) :: cap
real(kind=dp)             :: yy(size(xx,1),size(xx,2))
integer                   :: i
forall (i=1:size(xx,1)) yy(i,:) = capped_sum_abs(xx(i,:),cap)
end function capped_sum_abs_rows
!
function capped_sum_abs_col(xx,cap) result(yy)
! return arrat that is scaled so that the sum of the absolute values of each row does not exceed cap
real(kind=dp), intent(in) :: xx(:,:)
real(kind=dp), intent(in) :: cap
real(kind=dp)             :: yy(size(xx,1),size(xx,2))
integer                   :: i
forall (i=1:size(xx,2)) yy(:,i) = capped_sum_abs(xx(:,i),cap)
end function capped_sum_abs_col
!
subroutine set_random_seed(fixed,offset,nburn_random)
logical, intent(in)           :: fixed        ! if .true., use a fixed seed
integer, intent(in), optional :: offset       ! constant added to generated seeds
integer, intent(in), optional :: nburn_random ! # of variates of RANDOM_NUMBER to burn off
integer, parameter            :: nburn = 100, nseeds_max = 12, seeds_vec(nseeds_max) = [824514020,218904035,384790913, &
                                 510442021,939900036,939295695,826403327,935378387, &
                                 634734772,413176190,91069182,818551196]
integer                       :: i,iburn,nseeds,itime,offset_,nburn_random_
integer, allocatable          :: seed(:)
real(kind=dp)                 :: xran,xseed(nburn + nseeds_max)
nburn_random_ = 100
offset_ = 0
if (present(nburn_random)) nburn_random_ = nburn_random
if (present(offset)) offset_ = offset
call random_seed(size=nseeds)
allocate(seed(nseeds))
if (fixed) then
   if (nseeds > nseeds_max) then
      seed(:nseeds_max) = seeds_vec + offset_
      seed(nseeds_max + 1:) = 0 ! NAG says to set the remaining elements of the seed array to zero to indicate zero entropy
   else
      seed = seeds_vec(:nseeds) + offset_
   end if
else ! set seed based on current time
   call system_clock(itime)
   seed = itime
   call random_seed(put=seed)
   call random_number(xseed)
   do i=1,nseeds
      if (i <= nseeds_max) then
         seed(i) = xseed(nburn+i)*1000000000 + offset_
      else
         seed(i) = 0
      end if
   end do
end if
call random_seed(put=seed)
do iburn=1,nburn_random_
   call random_number(xran)
end do
end subroutine set_random_seed
!
pure function complement(n,ivec) result(jvec)
! return in jvec(:) the integers from 1 to n not found in ivec(:)
integer, intent(in)  :: n
integer, intent(in)  :: ivec(:)
integer, allocatable :: jvec(:)
integer              :: i
logical              :: found(n)
if (n < 1) then
   allocate (jvec(0))
   return
end if
forall (i=1:n) found(i) = any(ivec == i)
call set_alloc(pack([(i,i=1,n)],.not. found),jvec)
end function complement
!
subroutine set_first_false(ival,tf,iflag)
! if any of tf(:) is not true, set ival to the corresponding value of iflag(:), or to the position of the first false element if iflag is not present
integer, intent(inout)        :: ival
logical, intent(in)           :: tf(:)
integer, intent(in), optional :: iflag(:)
integer                       :: ipos
ipos = first_false(tf)
if (ipos == 0) return
if (present(iflag)) then
   if (size(iflag) == size(tf)) then
      ival = iflag(ipos)
   else
      ival = -1
   end if
else
   ival = ipos
end if
end subroutine set_first_false
!
subroutine read_vec_data_unit(iu,xx,nlines_skip,close_unit)
! read xx(:) from unit iu, one element per line
integer      , intent(in)               :: iu           ! unit from which data read
real(kind=dp), intent(out), allocatable :: xx(:)        ! data read on output
integer      , intent(in) , optional    :: nlines_skip  ! # of lines to skip before reading data
logical      , intent(in) , optional    :: close_unit   ! if present and .true., close unit before RETURNing
integer      , parameter                :: nmax = 10**8 ! max # of obs to read
real(kind=dp)                           :: xbig(nmax)
integer                                 :: i,ierr,nread
nread = nmax
if (present(nlines_skip)) then
   do i=1,nlines_skip
      read (iu,*)
   end do
end if
do i=1,nmax
   read (iu,*,iostat=ierr) xbig(i)
   if (ierr /= 0) then
      nread = i-1
      exit
   end if
end do
allocate (xx(nread))
xx = xbig(:nread)
if (default(.false.,close_unit)) close(iu)
end subroutine read_vec_data_unit
!
subroutine assert_conform(x,y,msg)
! assert that two 1D real arrays have the same size
real(kind=dp)    , intent(in)           :: x(:)
real(kind=dp)    , intent(in), optional :: y(:)
character (len=*), intent(in), optional :: msg
if (.not. present(y)) return
if (size(x) /= size(y)) then
   if (present(msg)) write (*,"(a)") trim(msg)
   write (*,*) "in assert_conform, size(x)=",size(x)," size(y)=",size(y)," must be equal, STOPPING"
   stop
end if
end subroutine assert_conform
!
pure function same_shape_real_real_1d(x,y) result(tf)
! true if x(:) and y(:) have the same shape
real(kind=dp), intent(in)           :: x(:)
real(kind=dp), intent(in), optional :: y(:)
logical                             :: tf
if (present(y)) then
   tf = size(x) == size(y)
else
   tf = .true.
end if
end function same_shape_real_real_1d
!
pure function same_shape_real_real_2d(x,y) result(tf)
! true if x(:,:) and y(:,:) have the same shape
real(kind=dp), intent(in)           :: x(:,:)
real(kind=dp), intent(in), optional :: y(:,:)
logical                             :: tf
if (present(y)) then
   tf = all(shape(x) == shape(y))
else
   tf = .true.
end if
end function same_shape_real_real_2d
!
pure function same_shape_real_real_3d(x,y) result(tf)
! true if x(:,:,:) and y(:,:,:) have the same shape
real(kind=dp), intent(in)           :: x(:,:,:)
real(kind=dp), intent(in), optional :: y(:,:,:)
logical                             :: tf
if (present(y)) then
   tf = all(shape(x) == shape(y))
else
   tf = .true.
end if
end function same_shape_real_real_3d
!
pure function pow_norm(n,pow) result(wgt)
! return a vector containing a power of the first n integers, normalized to sum to 1
integer      , intent(in) :: n
real(kind=dp), intent(in) :: pow
real(kind=dp)             :: wgt(n)
integer                   :: i
if (n < 1) return
forall (i=1:n) wgt(i) = i**pow
wgt = wgt/sum(wgt)
end function pow_norm
!
elemental subroutine bound_value(xx,xmin,xmax)
! bound xx by xmin and xmax
real(kind=dp), intent(in out)           :: xx
real(kind=dp), intent(in)    , optional :: xmin,xmax
if (present(xmin)) xx = max(xx,xmin)
if (present(xmax)) xx = min(xx,xmax)
end subroutine bound_value
!
subroutine print_random_seeds(outu)
integer, intent(in), optional  :: outu
integer              :: outu_,nseeds
integer, allocatable :: seeds(:)
outu_ = default(istdout,outu)
call random_seed(size=nseeds)
allocate (seeds(nseeds))
call random_seed(get=seeds)
write (outu_,"('random_number_seeds =',1000(1x,i0))") seeds
end subroutine print_random_seeds
!
subroutine get_numbers(list, n)
!     Read in a list of numbers which may be separated by commas, blanks
!     or either `..' or `-'.
integer, intent(out) :: list(:) ! contains data read on output
integer, intent(out) :: n       ! # of values read
!     Local variables
character (len=4)   :: delimiters = " ,-."
character (len=100) :: text
integer             :: nmax, length, i1, i2, iostatus, i, number
logical             :: sequence
nmax = size(list)
start: do
  write (*,*) "enter variable numbers on one line"
  write (*,*) "e.g. 1-5 8 11 .. 15  use commas or blanks as separators"
  write (*,*) ": "
  read(*, "(a) ") text
  text = adjustl(text)
  length = len_trim(text)
  if (length == 0) then
    n = 0
    return
  end if
  n = 1
  i1 = 1
  sequence = .false.
  do
    i2 = scan( text(i1:), delimiters )
    if (i2 == 0) then
      i2 = length
    else
      i2 = i2 + i1 - 2
    end if
    read(text(i1:i2),*, iostat=iostatus) number
    if (iostatus /= 0) then
      write (*,*) "** error: numeric data expected **"
      write (*, "(1x, a) ") text(1:length)
      text = " "
      do i = i1, i2
        text(i:i) = "^"
      end do
      write (*, "(1x, a) ") text(1:i2)
      cycle start
    end if
    if (sequence) then
      if (number <= list(n-1)) then
        write (*,*) "variable numbers not increasing"
        write (*, "(1x, a) ") text(1:length)
        text = " "
        do i = i1, i2
          text(i:i) = "^"
        end do
        write (*, "(1x, a) ") text(1:i2)
        cycle start
      end if
      do
        if (n > size(list)) then
           n = size(list)
           exit
        end if
        list(n) = list(n-1) + 1
        if (list(n) >= number) exit
        n = n + 1
      end do
    else
      list(n) = number
    end if
    if (i2 == length) return
    i1 = i2 + 1
    sequence = .false.
                                       ! Find end of delimiters
    do
      if ( scan( text(i1:i1), delimiters ) > 0) then
        if (text(i1:i1) == "-" .or. text(i1:i1+1) == "..") sequence = .true.
        i1 = i1 + 1
      else
        exit
      end if
    end do
    n = n + 1
    if (n > nmax) then
      write (*,*) "** too many numbers entered - list truncated **"
      n = nmax
      return
    end if
  end do
end do start
return
end subroutine get_numbers
!
pure subroutine remove(ivec,ivalue)
! remove from ivec the elements equal ivalue
integer, intent(in out), allocatable :: ivec(:)
integer, intent(in)                  :: ivalue
if (.not. allocated(ivec)) return
call set_alloc(pack(ivec,ivec/=ivalue),ivec)
end subroutine remove
!
pure subroutine add_or_remove(ivec,ivalue)
! If one or more elements of ivec equal ivalue, remove them. If no element of ivec equals ivalue, add it to the end.
integer, intent(in out), allocatable :: ivec(:)
integer, intent(in)                  :: ivalue
if (.not. allocated(ivec)) then
   call set_alloc([ivalue],ivec)
   return
end if
if (any(ivec == ivalue)) then
   call set_alloc(pack(ivec,ivec/=ivalue),ivec)
else
   call set_alloc([ivec,ivalue],ivec)
end if
end subroutine add_or_remove
!
integer function num_records(filename)
! Return the number of records (lines) of a text file. 
! Milan Curcic https://github.com/modern-fortran/stock-prices/blob/392fed96a6ccb42c6398485e9ba8fb4c721b10c4/src/mod_io.f90#L14-L26
character(len=*), intent(in) :: filename
integer :: fileunit
fileunit = 100
open(unit=fileunit, file=filename, action="read", status="old")
! open(newunit=fileunit, file=filename, action="read", status="old") ! not supported by g95
num_records = 0
do
   read(unit=fileunit, fmt=*, end=1)
   num_records = num_records + 1
end do
1 continue
close(unit=fileunit)
end function num_records
!
function ratios(x) result(y)
! return the ratios of consecutive elements of x(:)
real(kind=dp), intent(in) :: x(:)
real(kind=dp)             :: y(size(x)-1)
integer                   :: n
n = size(x)
if (n > 1) y = x(2:)/x(:n-1)
end function ratios
!
function ratio_diff(x) result(y)
! return the ratios of consecutive elements of x(:) minus 1
real(kind=dp), intent(in) :: x(:)
real(kind=dp)             :: y(size(x)-1)
integer                   :: n
n = size(x)
if (n > 1) y = x(2:)/x(:n-1) - 1.0_dp
end function ratio_diff
!
pure function weighted_sums(xx,wgt) result(xma)
! products of xx(i-nwgt+1:i) and wgt(nwgt:1:-1)
real(kind=dp), intent(in) :: xx(:)
real(kind=dp), intent(in) :: wgt(:)
real(kind=dp)             :: xma(size(xx))
integer                   :: i,n,nwgt
xma = 0.0_dp
n = size(xx)
nwgt = size(wgt)
if (n < 1 .or. nwgt < 1 .or. nwgt > n) return
do i=nwgt,n
   xma(i) = sum(wgt(nwgt:1:-1)*xx(i-nwgt+1:i))
end do
end function weighted_sums
!
recursive pure function moving_average_vec(xx,nma) result(xma)
! simple moving average with nma terms
! uses growing average for xma(1:nma-1)
real(kind=dp), intent(in) :: xx(:)
integer      , intent(in) :: nma
real(kind=dp)             :: xma(size(xx))
integer                   :: i,m,n
if (nma < 1) return
n = size(xx)
if (n < 1) return
if (nma > n) then
   xma = moving_average_vec(xx,n)
   return
end if
do i=1,nma
   m = min(i,nma)
   xma(i) = sum(xx(i-m+1:i))/m       
end do
do i=nma+1,n
   xma(i) = xma(i-1) + (xx(i)-xx(i-nma))/nma
end do
end function moving_average_vec
!
pure function weighted_moving_average_vec(xx,wgt) result(xma)
! simple moving average with nma terms
! uses growing average for xma(1:nma-1)
real(kind=dp), intent(in) :: xx(:)
real(kind=dp), intent(in) :: wgt(:)
real(kind=dp)             :: xma(size(xx))
integer                   :: i,m,n,nma
nma = size(wgt)
if (nma < 1) return
n = size(xx)
if (n < 1) return
if (nma > n) then
   xma = moving_average_vec(xx,n)
   return
end if
do i=1,nma-1
   m = min(i,nma)
   xma(i) = sum(xx(i-m+1:i))/m       
end do
do i=nma,n
   xma(i) = sum(xx(i-nma+1:i)*wgt(nma:1:-1))
end do
end function weighted_moving_average_vec
!
pure function spline_power_wgt(n,power) result(wgt)
! return weights that decay smoothly to zero by lag n+1
integer      , intent(in) :: n
real(kind=dp), intent(in) :: power
real(kind=dp)             :: wgt(n)
integer                   :: i
if (n < 1) return
do i=1,n
   wgt(i) = (n - i + 1) ** power
end do
wgt = wgt/sum(wgt)
end function spline_power_wgt
end module util_mod

program xtest_util
use kind_mod, only: dp
use util_mod, only: diff, sech, normalize, join, join_quote, join_csv, concat, repeat, zeros, &
   slice, optional_value, set_optional, if_else, demean, true_pos, cumul_sum, cumul_sum0, &
   growing_mean, lag_matrix, matrix, vector, tensor, cbind, combine_col, str, int_tf, &
   diag_matrix, diag, offdiag, above_diag, polynom_value, first_pos_ge, last_pos_le, &
   integer_label, integer_labels, conform, positions, uniq, operator(.in.), operator(.notin.), &
   operator(.posin.), ivec, default, element, piecewise_constant, piecewise_linear, &
   piecewise_sine, upper_case_str, lower_case_str, max_optional, min_optional, ones, &
   sorted, nonzero_columns, moving_average, exp_ma, sine_bound, half_sine_bound, &
   sine_transform, duration, operator(.pow.), round_less, round_up, grid_round, running_sum, &
   tail, positive, first_true, last_true, nearest_element, single, lagged, frac_true, &
   frac_changes, seq, replace_char, threshold_weights, clip, first, default_variable_names, &
   first_pos_positive, floor_10, ceiling_10, union_ascending, pos, dividend_adjusted_prices, &
   returns, factorial, choose, elu, elu_smooth, logistic, within, max_consecutive, split, &
   nonzero, piecewise_cubic_unit, piecewise_cubic, piecewise_quintic
implicit none

integer, parameter :: n = 5
real(kind=dp) :: x(n), y(n), prices(n), dividends(n)
real(kind=dp) :: mat3x2(3,2), mat3x3(3,3)
real(kind=dp) :: xlag(n - 2, 2)
integer :: iv(n), jv(4)
logical :: tf(n)
character(len=8) :: words(3), colors(4)
character(len=12) :: labels(3)
character(len=1000), allocatable :: parts(:)
integer, allocatable :: ia(:)
real(kind=dp), allocatable :: ra(:)
real(kind=dp) :: scalar_real
integer :: scalar_int
logical :: scalar_logical
character(len=12) :: scalar_char

x = [1.0_dp, 2.0_dp, 4.0_dp, 7.0_dp, 11.0_dp]
y = [-2.0_dp, -0.5_dp, 0.0_dp, 0.5_dp, 2.0_dp]
iv = [1, 2, 2, 4, 7]
jv = [2, 4, 6, 8]
tf = [.false., .true., .true., .false., .true.]
words = [character(len=8) :: "alpha", "beta", "gamma"]
colors = [character(len=8) :: "red", "green", "blue", "gold"]

mat3x2 = reshape([1.0_dp, 2.0_dp, 3.0_dp, 10.0_dp, 20.0_dp, 30.0_dp], [3,2])
mat3x3 = reshape([1.0_dp, 2.0_dp, 3.0_dp, &
                  4.0_dp, 5.0_dp, 6.0_dp, &
                  7.0_dp, 8.0_dp, 9.0_dp], [3,3])

prices = [100.0_dp, 102.0_dp, 101.0_dp, 105.0_dp, 110.0_dp]
dividends = [0.0_dp, 0.0_dp, 1.0_dp, 0.0_dp, 0.5_dp]

print *, "diff(x) = ", diff(x)
print *, "diff(iv) = ", diff(iv)
print *, "sech(y) = ", sech(y)
print *, "normalize(x) = ", normalize(x)

print *, "join(words, '-') = ", trim(join(words, "-"))
print *, "join_quote(words, ',') = ", trim(join_quote(words, ","))
print *, "join_csv(words) = ", trim(join_csv(words))
print *, "concat(words, sep=' | ') = ", trim(concat(words, sep=" | "))

print *, "repeat(4, 9) = ", repeat(4, 9)
print *, "repeat(3, 2.5_dp) = ", repeat(3, 2.5_dp)
print *, "repeat(3, 'ha') = ", repeat(3, "ha")
print *, "zeros(4) = ", zeros(4)
print *, "slice(iv, 2, 4) = ", slice(iv, 2, 4)

print *, "optional_value(10, 20) = ", optional_value(10, 20)
call set_optional(scalar_real, 1.25_dp)
call set_optional(scalar_int, 7)
call set_optional(scalar_logical, .true.)
call set_optional(scalar_char, "default")
print *, "set_optional defaults = ", scalar_real, scalar_int, scalar_logical, trim(scalar_char)

print *, "if_else(tf, 1, 0) = ", if_else(tf, 1, 0)
print *, "demean(x) = ", demean(x)
print *, "true_pos(tf) = ", true_pos(tf)
print *, "cumul_sum(x) = ", cumul_sum(x)
print *, "cumul_sum0(x) = ", cumul_sum0(x)
print *, "growing_mean(x) = ", growing_mean(x)

xlag = lag_matrix(2, x)
print *, "lag_matrix(2, x) row 1 = ", xlag(1,:)
print *, "lag_matrix(2, x) row 3 = ", xlag(3,:)

print *, "matrix(x) shape = ", shape(matrix(x))
print *, "vector(mat3x2) = ", vector(mat3x2)
print *, "tensor(mat3x2) shape = ", shape(tensor(mat3x2))
print *, "cbind(x(1:3), y(1:3)) shape = ", shape(cbind(x(1:3), y(1:3)))
print *, "combine_col(iv(1:3), jv(1:3)) shape = ", shape(combine_col(iv(1:3), jv(1:3)))

print *, "str(123) = ", trim(str(123))
print *, "str(.true.) = ", trim(str(.true.))
print *, "int_tf(tf) = ", int_tf(tf)

print *, "diag_matrix([1,2,3]) = ", diag_matrix([1.0_dp, 2.0_dp, 3.0_dp])
print *, "diag(mat3x3) = ", diag(mat3x3)
print *, "offdiag(mat3x3) = ", offdiag(mat3x3)
print *, "above_diag(mat3x3) = ", above_diag(mat3x3)

print *, "polynom_value(2, [1,2,3]) = ", polynom_value(2.0_dp, [1.0_dp, 2.0_dp, 3.0_dp])
print *, "polynom_value(y, [1,2,3]) = ", polynom_value(y, [1.0_dp, 2.0_dp, 3.0_dp])

print *, "first_pos_ge(iv, 4) = ", first_pos_ge(iv, 4)
print *, "last_pos_le(iv, 4) = ", last_pos_le(iv, 4)
print *, "integer_label(12) = ", trim(integer_label(12))
labels = integer_labels(1, 3)
print *, "integer_labels(1,3) = ", labels

print *, "conform(x, y) = ", conform(x, y)
print *, "positions(tf) = ", positions(tf)
print *, "uniq(iv) = ", uniq(iv)
print *, "uniq(colors) = ", uniq(colors)

print *, "2 .in. iv = ", 2 .in. iv
print *, "9 .notin. iv = ", 9 .notin. iv
print *, "'green' .in. colors = ", "green" .in. colors
print *, "'black' .notin. colors = ", "black" .notin. colors
print *, "'blue' .posin. colors = ", "blue" .posin. colors
print *, "4 .posin. iv = ", 4 .posin. iv

print *, "ivec(5) = ", ivec(5)
print *, "default(99, 123) = ", default(99, 123)
print *, "element(2, colors) = ", trim(element(2, colors))

print *, "piecewise_constant(x, tf) = ", piecewise_constant(x, tf)
print *, "piecewise_linear(y, -1, 1, 10, 20) = ", piecewise_linear(y, -1.0_dp, 1.0_dp, 10.0_dp, 20.0_dp)
print *, "piecewise_sine(y, -1, 1, 10, 20) = ", piecewise_sine(y, -1.0_dp, 1.0_dp, 10.0_dp, 20.0_dp)

print *, "upper_case_str('Abc xyz') = ", upper_case_str("Abc xyz")
print *, "lower_case_str('Abc XYZ') = ", lower_case_str("Abc XYZ")
print *, "max_optional(3) = ", max_optional(3)
print *, "min_optional(3) = ", min_optional(3)
print *, "ones(4) = ", ones(4)
print *, "sorted(x) = ", sorted(x)
print *, "nonzero_columns(mat3x2) = ", nonzero_columns(mat3x2)

print *, "moving_average(x, 1, 1) = ", moving_average(x, 1, 1)
print *, "exp_ma(x, 0.5) = ", exp_ma(x, 0.5_dp)
print *, "sine_bound(y) = ", sine_bound(y)
print *, "half_sine_bound(y) = ", half_sine_bound(y)
print *, "sine_transform(y, -1, 1, 10, 20) = ", sine_transform(y, -1.0_dp, 1.0_dp, 10.0_dp, 20.0_dp)

print *, "duration(y) = ", duration(y)
print *, "y .pow. 2 = ", y .pow. 2.0_dp
print *, "round_less(0.25, y) = ", round_less(0.25_dp, y)
print *, "round_up(0.25, y) = ", round_up(0.25_dp, y)
print *, "grid_round(0.25, -0.7, 0.8) = ", grid_round(0.25_dp, -0.7_dp, 0.8_dp)
print *, "running_sum(3, x) = ", running_sum(3, x)

print *, "tail(x) = ", tail(x)
print *, "positive(iv) = ", positive(iv)
print *, "first_true(tf), last_true(tf) = ", first_true(tf), last_true(tf)
print *, "nearest_element(3.6, x) = ", nearest_element(3.6_dp, x)
print *, "single([4, 4, 5, 6, 6]) = ", single([4, 4, 5, 6, 6])
print *, "single([4.0_dp, 4.0_dp, 5.0_dp, 6.0_dp, 6.0_dp]) = ", &
   single([4.0_dp, 4.0_dp, 5.0_dp, 6.0_dp, 6.0_dp])
print *, "lagged(x, 2, -999) = ", lagged(x, 2, -999.0_dp)
print *, "frac_true(tf) = ", frac_true(tf)
print *, "frac_changes(tf) = ", frac_changes(tf)

print *, "seq(5) = ", seq(5)
print *, "replace_char('a-b-c', '-', '_') = ", replace_char("a-b-c", "-", "_")
print *, "threshold_weights(y, 0.75) = ", threshold_weights(y, 0.75_dp)
print *, "clip(y, -0.75, 0.75) = ", clip(y, -0.75_dp, 0.75_dp)

print *, "first(iv), first(x), first(colors) = ", first(iv), first(x), trim(first(colors))
print *, "default_variable_names(3, 'x') = ", default_variable_names(3, "x")
print *, "first_pos_positive(iv) = ", first_pos_positive(iv)
print *, "floor_10(123.4), ceiling_10(123.4) = ", floor_10(123.4_dp), ceiling_10(123.4_dp)

print *, "union_ascending([1,3,5], [2,3,4]) = ", union_ascending([1,3,5], [2,3,4])
print *, "pos('blue', colors) = ", pos("blue", colors)
print *, "dividend_adjusted_prices(prices, dividends) = ", dividend_adjusted_prices(prices, dividends)
print *, "returns(prices, dividends) = ", returns(prices, dividends)

print *, "factorial(5), choose(5,2) = ", factorial(5), choose(5,2)
print *, "elu(y) = ", elu(y)
print *, "elu_smooth(y) = ", elu_smooth(y)
print *, "logistic(y) = ", logistic(y)

print *, "within(3, 2, 4) = ", within(3, 2, 4)
print *, "within(0.5, 0, 1) = ", within(0.5_dp, 0.0_dp, 1.0_dp)
print *, "max_consecutive(tf) = ", max_consecutive(tf)

parts = split("one,two,three", ",")
print *, "split('one,two,three', ',') = ", parts

ia = nonzero([0, 1, 0, 2, 3])
ra = nonzero([0.0_dp, 1.5_dp, 0.0_dp, -2.0_dp])
print *, "nonzero integers = ", ia
print *, "nonzero reals = ", ra

print *, "piecewise_cubic_unit(y) = ", piecewise_cubic_unit(y)
print *, "piecewise_cubic(y, -1, 1, 10, 20) = ", piecewise_cubic(y, -1.0_dp, 1.0_dp, 10.0_dp, 20.0_dp)
print *, "piecewise_quintic(y, -1, 1, 10, 20) = ", piecewise_quintic(y, -1.0_dp, 1.0_dp, 10.0_dp, 20.0_dp)

end program xtest_util

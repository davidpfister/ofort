# ofort Extension Modules

`ofort` includes a small set of nonstandard extension modules for interpreted
workflows. They are convenience modules, not part of the core Fortran language
support required to run ordinary `ofort` programs.

Programs must import these procedures explicitly:

```fortran
use ofort_random_mod, only: rnorm
```

These modules are implemented by the `ofort` runtime. Programs that use them
are intended for `ofort` unless a compatible Fortran implementation of the same
module API is also provided for compiled builds.

## Module Summary

| Module | Purpose | Procedures |
| --- | --- | --- |
| `ofort_random_mod` | normal random variates | `rnorm`, `rnorm_fill` |
| `ofort_la_mod` | small dense linear algebra helpers | `matmul2`, `transpose2`, `crossprod`, `tcrossprod`, `center_cols`, `col_sums`, `col_means` |
| `ofort_io_mod` | simple numeric text readers | `read_matrix`, `read_vector` |
| `ofort_statistics_mod` | vector, matrix, and column statistics | `mean`, `variance`, `sd`, `cov`, `cor`, `variance_given_mean`, `sd_given_mean`, `calc_stats`, `calc_col_stats` |

`ofort_stats_mod` is accepted as an alias for `ofort_statistics_mod`.

## `ofort_random_mod`

### `rnorm`

```fortran
z = rnorm()
z = rnorm(n)
z = rnorm(n, method)
```

Returns standard normal random variates as `double precision`.

Arguments:

- `n`: optional integer number of variates. If omitted, `rnorm` returns a scalar.
  If supplied, `rnorm` returns a rank-1 array of length `n`.
- `method`: optional integer random-normal method. Method `1` is Box-Muller
  trigonometric generation. Method `2` is Marsaglia polar generation. The
  default is `2`.

Examples:

```fortran
double precision :: z
double precision, allocatable :: x(:)

z = rnorm()
x = rnorm(1000)
x = rnorm(1000, 1)
```

### `rnorm_fill`

```fortran
call rnorm_fill(x)
call rnorm_fill(x, method)
```

Fills an existing real scalar or real array with standard normal variates.

Arguments:

- `x`: real scalar or real array output. Rank-1 and rank-2 arrays are supported.
- `method`: optional integer generation method. Method `1` is Box-Muller.
  Method `2` is Marsaglia polar. The default is `2`.

`rnorm_fill` is preferred for large existing arrays because it avoids allocating
a temporary result.

## `ofort_la_mod`

The linear algebra procedures operate on rank-2 numeric arrays and return
`double precision` arrays.

### `transpose2`

```fortran
y = transpose2(x)
```

Returns the transpose of matrix `x`.

Arguments:

- `x`: rank-2 numeric array of shape `(nrow, ncol)`.

Result:

- rank-2 `double precision` array of shape `(ncol, nrow)`.

### `matmul2`

```fortran
c = matmul2(a, b)
```

Returns the matrix product `a * b`.

Arguments:

- `a`: rank-2 numeric array of shape `(m, k)`.
- `b`: rank-2 numeric array of shape `(k, n)`.

Result:

- rank-2 `double precision` array of shape `(m, n)`.

### `crossprod`

```fortran
c = crossprod(x)
c = crossprod(x, y)
```

Returns a crossproduct.

Arguments:

- `x`: rank-2 numeric array of shape `(nrow, xcols)`.
- `y`: optional rank-2 numeric array of shape `(nrow, ycols)`.

Result:

- If `y` is omitted, returns `transpose(x) * x`, shape `(xcols, xcols)`.
- If `y` is supplied, returns `transpose(x) * y`, shape `(xcols, ycols)`.

### `tcrossprod`

```fortran
c = tcrossprod(x)
c = tcrossprod(x, y)
```

Returns a transposed crossproduct.

Arguments:

- `x`: rank-2 numeric array of shape `(xrows, ncol)`.
- `y`: optional rank-2 numeric array of shape `(yrows, ncol)`.

Result:

- If `y` is omitted, returns `x * transpose(x)`, shape `(xrows, xrows)`.
- If `y` is supplied, returns `x * transpose(y)`, shape `(xrows, yrows)`.

### `col_sums`

```fortran
s = col_sums(x)
```

Arguments:

- `x`: rank-2 numeric array of shape `(nrow, ncol)`.

Result:

- rank-1 `double precision` array of length `ncol`, containing column sums.

### `col_means`

```fortran
mu = col_means(x)
```

Arguments:

- `x`: rank-2 numeric array of shape `(nrow, ncol)`.

Result:

- rank-1 `double precision` array of length `ncol`, containing column means.

### `center_cols`

```fortran
call center_cols(x, mean, out)
```

Subtracts one value from each column of `x`.

Arguments:

- `x`: rank-2 numeric input array of shape `(nrow, ncol)`.
- `mean`: rank-1 numeric input array of length `ncol`.
- `out`: rank-2 real output array of shape `(nrow, ncol)`.

## `ofort_io_mod`

The I/O module provides simple dependency-free readers for numeric text data.
It is intended for files that are easy to parse, such as whitespace-delimited
numeric matrices and simple comma-delimited files. It does not currently
implement quoted CSV fields.

### `read_matrix`

```fortran
call read_matrix(file, x)
call read_matrix(file, x, ncol=ncol)
call read_matrix(file, x, delimiter=",", header=.true., row_labels=labels)
```

Reads a numeric matrix from a text file and allocates the output matrix.

Arguments:

- `file`: character input file path.
- `x`: allocatable real rank-2 output array. The procedure allocates/replaces it
  with shape `(nrow, ncol)`.
- `ncol`: optional integer number of numeric columns. If omitted, the number of
  numeric columns is inferred from the first data row.
- `delimiter`: optional character delimiter. If omitted, runs of whitespace
  separate fields. For CSV-like files use `delimiter=","`.
- `header`: optional logical. If true, one non-comment, nonblank row after
  `skiprows` is skipped before data parsing.
- `skiprows`: optional integer number of physical input lines to skip first.
- `comment`: optional character comment marker. The default is `"#"`.
- `row_labels`: optional allocatable character rank-1 output array. If present,
  the first field of each data row is stored as a label and excluded from the
  numeric matrix.

Examples:

```fortran
real(8), allocatable :: x(:,:)
character(len=32), allocatable :: dates(:)

call read_matrix("x.txt", x)
call read_matrix("prices.csv", x, delimiter=",", header=.true., &
                 ncol=4, row_labels=dates)
```

### `read_vector`

```fortran
call read_vector(file, x)
call read_vector(file, x, delimiter=",", header=.true.)
```

Reads numeric fields from a text file into one rank-1 vector and allocates the
output vector.

Arguments:

- `file`: character input file path.
- `x`: allocatable real rank-1 output array.
- `delimiter`: optional character delimiter. If omitted, whitespace separates
  fields.
- `header`: optional logical. If true, one non-comment, nonblank row after
  `skiprows` is skipped before data parsing.
- `skiprows`: optional integer number of physical input lines to skip first.
- `comment`: optional character comment marker. The default is `"#"`.

## `ofort_statistics_mod`

The statistics module provides C-backed statistics routines for numeric vectors
and matrices. The procedures return `double precision` values or arrays.

### `mean`

```fortran
xmean = mean(x)
```

Arguments:

- `x`: rank-1 numeric array.

Result:

- arithmetic mean of `x`.

### `variance`

```fortran
xvar = variance(x)
```

Arguments:

- `x`: rank-1 numeric array with at least two observations.

Result:

- sample variance, dividing by `n - 1`.

### `sd`

```fortran
xsd = sd(x)
```

Arguments:

- `x`: rank-1 numeric array with at least two observations.

Result:

- sample standard deviation, dividing by `n - 1`.

### `cov`

```fortran
cxy = cov(x, y)
c = cov(x)
```

Arguments:

- `x`, `y`: rank-1 numeric arrays of equal length for the two-vector form.
- `x`: rank-2 numeric array for the matrix form, where columns are variables.

Result:

- two-vector form: sample covariance of `x` and `y`.
- matrix form: sample covariance matrix of the columns of `x`.

### `cor`

```fortran
rxy = cor(x, y)
r = cor(x)
```

Arguments:

- `x`, `y`: rank-1 numeric arrays of equal length for the two-vector form.
- `x`: rank-2 numeric array for the matrix form, where columns are variables.

Result:

- two-vector form: sample correlation of `x` and `y`.
- matrix form: sample correlation matrix of the columns of `x`.

### `variance_given_mean`

```fortran
xvar = variance_given_mean(x, xmean)
```

Arguments:

- `x`: rank-1 numeric array with at least two observations.
- `xmean`: previously computed mean of `x`.

Result:

- sample variance, dividing by `n - 1`.

### `sd_given_mean`

```fortran
xsd = sd_given_mean(x, xmean)
```

Arguments:

- `x`: rank-1 numeric array with at least two observations.
- `xmean`: previously computed mean of `x`.

Result:

- sample standard deviation, dividing by `n - 1`.

### `calc_stats`

```fortran
call calc_stats(x, mean=xmean)
call calc_stats(x, mean=xmean, sd=xsd, var=xvar)
```

Computes vector statistics in one call.

Arguments:

- `x`: rank-1 numeric input array.
- `mean`: scalar real output.
- `sd`: optional scalar real output, sample standard deviation.
- `var`: optional scalar real output, sample variance.

At least `x` and `mean` are required.

### `calc_col_stats`

```fortran
call calc_col_stats(x, mean=mu, sd=xs, var=xvar)
call calc_col_stats(x, cov=covmat, corr=cormat)
call calc_col_stats(x, rms=rms, cov_zm=cov_zm, corr_zm=corr_zm)
```

Computes column statistics for a rank-2 numeric matrix.

Arguments:

- `x`: rank-2 numeric input array of shape `(nrow, ncol)`.
- `mean`: optional rank-1 real output of length `ncol`.
- `sd`: optional rank-1 real output of length `ncol`, sample standard
  deviations using centered data and denominator `nrow - 1`.
- `var`: optional rank-1 real output of length `ncol`, sample variances using
  centered data and denominator `nrow - 1`.
- `cov`: optional rank-2 real output of shape `(ncol, ncol)`, sample covariance
  matrix using centered data and denominator `nrow - 1`.
- `corr`: optional rank-2 real output of shape `(ncol, ncol)`, sample
  correlation matrix using centered data.
- `rms`: optional rank-1 real output of length `ncol`, root mean square using
  zero-mean formulas.
- `cov_zm`: optional rank-2 real output of shape `(ncol, ncol)`, zero-mean
  covariance matrix. It divides raw crossproducts by `nrow`.
- `corr_zm`: optional rank-2 real output of shape `(ncol, ncol)`, zero-mean
  correlation matrix.

At least one output argument is required. Centered covariance/correlation paths
use a centered workspace for performance. Zero-mean outputs are useful for
finance-style daily-return calculations where the mean is treated as zero.

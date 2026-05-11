# ICCbin 1.2.0

* Added `rcbin_flex()`, an enhanced alternative to `rcbin()` that uses a Beta
  distribution for cluster-specific event proportions and supports overdispersed
  cluster sizes via the Negative Binomial distribution. Unlike `rcbin()`,
  the `prvar` and `csvar` parameters in `rcbin_flex()` represent actual
  variances rather than percentages.

* Improved performance of `iccbin()`: the resampling method computations
  (method `"rm"` and CI type `"rm"`) are now only performed when explicitly
  requested. Previously, the pairwise loops required by the resampling method
  were always executed, causing significant slowdowns for larger datasets even
  when the resampling method was not requested.

* Fixed an issue in `iccbin()` where passing a `cid` factor with empty levels
  (levels with zero observations) would silently produce incorrect results.
  Empty levels are now dropped with an informative warning.

* Fixed an error in `iccbin()` where a singleton cluster (a cluster with only
  one observation) caused a cryptic `missing value where TRUE/FALSE needed`
  error due to division by zero in several ICC estimators. Singleton clusters
  are now removed before estimation with an informative warning.

* Updated maintainer email address.

* Fixed typos in documentation across all functions.

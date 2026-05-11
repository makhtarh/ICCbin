# ICCbin
An R package facilitating clustered binary data generation, and estimation of Intracluster Correlation Coefficient for binary data

## Functions

### Data generation
- **`rcbin()`** — Generates correlated binary clustered data given an ICC, event proportion, number of clusters, cluster size, and percent variation in proportion and cluster size.
- **`rcbin_flex()`** — An enhanced alternative to `rcbin()` that uses a Beta distribution for cluster-specific event proportions and supports overdispersed cluster sizes via the Negative Binomial distribution. Unlike `rcbin()`, the `prvar` and `csvar` parameters represent actual variances rather than percentages.

### ICC estimation
- **`iccbin()`** — Estimates ICC for binary clustered data using 16 methods and 5 types of confidence intervals.

## Project history
This repository is a continuation of the original ICCbin project previously hosted under the GitHub account `akhtarh`, which is no longer accessible due to email account expiration.
Commit history is preserved from the original repository.

[![R-CMD-check](https://github.com/makhtarh/ICCbin/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/makhtarh/ICCbin/actions/workflows/R-CMD-check.yaml)

[![](https://cranlogs.r-pkg.org/badges/ICCbin)](https://cran.r-project.org/package=ICCbin)

[![](http://cranlogs.r-pkg.org/badges/grand-total/ICCbin)](https://cran.r-project.org/package=ICCbin)



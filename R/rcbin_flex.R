#' Generates correlated binary cluster data with flexible distributional options
#'
#' Generates correlated binary cluster data given value of Intracluster
#' Correlation, proportion of event and its variance, number of clusters,
#' cluster size and its variance, and minimum cluster size. Compared to
#' \code{\link{rcbin}}, this function uses a Beta distribution for
#' cluster-specific event proportions and supports overdispersed cluster sizes
#' via the Negative Binomial distribution. Parameters \code{prvar} and
#' \code{csvar} represent actual variances, not percentages.
#'
#' @param prop A numeric value between 0 and 1 denoting assumed proportion of
#'   event of interest, default value is 0.5. See Details.
#' @param prvar A non-negative numeric value (strictly less than
#'   \code{prop*(1-prop)}) denoting variance in assumed proportion of event
#'   (\code{prop}), default value is 0. See Details.
#' @param noc A positive numeric value giving the number of clusters to be
#'   generated.
#' @param csize A numeric value (\eqn{\ge 2}) denoting desired cluster size.
#' @param csvar A non-negative numeric value denoting variance of cluster size,
#'   default value is 0. See Details.
#' @param mincsize A numeric value (\eqn{\ge 2}) denoting the minimum cluster
#'   size, default value is 2. See Details.
#' @param rho A numeric value between 0 and 1 denoting desired level of
#'   Intracluster Correlation.
#'
#' @details If \code{prvar} is 0, the event proportion is constant across all
#'   clusters as supplied by \code{prop}. If \code{prvar} > 0, cluster-specific
#'   event proportions are generated from a Beta distribution with shape
#'   parameters \eqn{a} and \eqn{b} obtained by solving \code{prop}
#'   \eqn{= a/(a + b)} and \code{prvar} \eqn{= ab/[(a + b)^2(1 + a + b)]}.
#'   See \code{\link{rbeta}}.
#'
#' @details If \code{csvar} is 0, all clusters have equal size \code{csize}.
#'   For \code{csvar} > 0, cluster sizes are generated from a Normal
#'   distribution when \code{csvar} < \code{csize} (see \code{\link{rnorm}}),
#'   or from a Negative Binomial distribution when \code{csvar} \eqn{\ge}
#'   \code{csize} to handle overdispersion (see \code{\link{rnbinom}}). Any
#'   cluster size below \code{mincsize} is replaced by \code{mincsize}.
#'
#' @details Unlike \code{\link{rcbin}}, the parameters \code{prvar} and
#'   \code{csvar} represent actual variances, not percentages of \code{prop}
#'   or \code{csize}.
#'
#' @return A dataframe with two columns: cluster id (\code{cid}) and binary
#'   response (\code{y}).
#'
#' @references Lunn, A.D. and Davies, S.J., 1998. A note on generating
#'   correlated binary variables. Biometrika, 85(2), pp.487-490.
#'
#' @author Akhtar Hossain \email{ahossain@live.com}
#'
#' @seealso \code{\link{rcbin}} \code{\link{iccbin}}
#'
#' @examples
#' rcbin_flex(prop = .6, prvar = .05, noc = 100, csize = 10, csvar = 12,
#'            rho = 0.2, mincsize = 2)
#'
#' @importFrom stats rnorm rbinom rbeta rnbinom
#'
#' @export

rcbin_flex <- function(prop = .5, prvar = 0, noc, csize, csvar = 0,
                       mincsize = 2, rho) {
  if (noc <= 0) stop("The argument 'noc' should be > 0")
  if (prop < 0 || prop > 1) stop("The argument 'prop' should be in the range [0, 1]")
  if (prvar < 0 || prvar >= prop * (1 - prop))
    stop("The argument 'prvar' must be in [0, prop*(1-prop))")
  if (csize < 2) stop("The argument 'csize' should be >= 2")
  if (mincsize < 2) stop("The argument 'mincsize' should be >= 2")
  if (csvar < 0) stop("The argument 'csvar' should be >= 0")
  if (rho < 0 || rho > 1) stop("The argument 'rho' should be in the range [0, 1]")

  cssd <- sqrt(csvar)
  csmean <- csize

  # Generate cluster sizes
  if (csvar == 0) {
    csizen <- rep(csmean, noc)
  } else if (csvar >= csmean) {
    # Overdispersed: use Negative Binomial distribution
    cscv <- cssd / csmean
    r <- csmean / (csmean * cscv^2 - 1)
    csizen <- rnbinom(n = noc, size = r, mu = csmean)
  } else {
    # Normal distribution when csvar < csmean
    csizen <- round(rnorm(n = noc, mean = csmean, sd = cssd))
  }
  csizen[csizen < mincsize] <- mincsize

  # Generate cluster-specific event proportions
  if (prvar == 0) {
    propn <- rep(prop, noc)
  } else {
    a <- prop * (prop * (1 - prop) / prvar - 1)
    b <- (1 - prop) * (prop * (1 - prop) / prvar - 1)
    propn <- rbeta(noc, a, b)
  }

  # Generate binary cluster data
  cluster <- c(); x <- c()
  for (i in 1:noc) {
    ri <- sqrt(rho)
    zi <- rbinom(n = 1, size = 1, prob = propn[i])
    for (j in 1:csizen[i]) {
      yij <- rbinom(n = 1, size = 1, prob = propn[i])
      uij <- rbinom(n = 1, size = 1, prob = ri)
      xij <- (1 - uij) * yij + uij * zi
      cluster <- c(cluster, i)
      x <- c(x, xij)
    }
  }
  data.frame(cid = as.factor(cluster), y = x)
}

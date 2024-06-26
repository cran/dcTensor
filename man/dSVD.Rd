\name{dSVD}
\docType{methods}
\alias{dSVD}

\title{
Discretized Singular Value Decomposition (dSVD)
}
\description{
This function is the discretized version of SVD.
The input data X is decomposed to a matrix product U V'.
Unlike regular SVD, in dSVD,
U and V are estimated by adding binary regularization
so that the values are 0 or 1 as much as possible.
Likewise, U and V are estimated by adding ternary regularization
so that the values are -1, 0, or 1 as much as possible.
}
\usage{
dSVD(X, M=NULL, pseudocount=.Machine$double.eps,
    initU=NULL, initV=NULL, fixU=FALSE, fixV=FALSE,
    Ter_U=1e-10, L1_U=1e-10, L2_U=1e-10, eta=1e+10, J = 3,
    thr = 1e-10, num.iter = 100,
    viz = FALSE, figdir = NULL, verbose = FALSE)
}

\arguments{
\item{X}{
The input matrix which has N-rows and M-columns.
}
\item{M}{
The mask matrix which has N-rows and M-columns. If the input matrix has
missing values, specify the element as 0 (otherwise 1).
}
\item{pseudocount}{
The pseudo count to avoid zero division, when the element is zero (Default: Machine Epsilon).
}
\item{initU}{
The initial values of factor matrix U, which has N-rows and J-columns
(Default: NULL).
}
\item{initV}{ The initial values of factor matrix V, which
has M-rows and J-columns (Default: NULL).
}
\item{fixU}{ Whether the factor matrix U is updated in each iteration step
(Default: FALSE).
}
\item{fixV}{
Whether the factor matrix V is updated in each iteration step
(Default: FALSE).
}
\item{Ter_U}{
Paramter for terary (-1,0,1) regularitation (Default: 1e-10).
}
\item{L1_U}{
Paramter for L1 regularitation (Default: 1e-10).
This also works as small positive constant to prevent division by zero,
so should be set as 0.
}
\item{L2_U}{
Paramter for L2 regularitation (Default: 1e-10).
}
\item{eta}{
Stepsize of gradient descent algorithm (Default: 1e+10).
}
\item{J}{
The number of low-dimension (J < \{N, M\}, Default: 3)
}
\item{thr}{
When error change rate is lower than thr, the iteration is terminated
(Default: 1E-10).
}
\item{num.iter}{
The number of interation step (Default: 100).
}
\item{viz}{
If viz == TRUE, internal reconstructed matrix can be visualized.
}
\item{figdir}{
The directory for saving the figure, when viz == TRUE.
}
\item{verbose}{
If verbose == TRUE, Error change rate is generated in console window.
}
}

\value{
  U : A matrix which has N-rows and J-columns (J < \{N, M\}).
  V : A matrix which has M-rows and J-columns (J < \{N, M\}).
  RecError : The reconstruction error between data tensor and reconstructed
  tensor from U and V.
  TrainRecError : The reconstruction error calculated by training set
  (observed values specified by M).
  TestRecError : The reconstruction error calculated by test set
  (missing values specified by M).
  RelChange : The relative change of the error.
}

\author{Koki Tsuyuzaki}

\examples{
# Test data
matdata <- toyModel(model = "dSVD")

# Simple usage
out <- dSVD(matdata, J=2, num.iter=2)
}
\keyword{methods}
\name{dPLS}
\docType{methods}
\alias{dPLS}

\title{
Discretized Partial Least Squares (dPLS)
}
\description{
This function is the discretized version of PLS.
The input data objects are assumed to be a list containing multiple matrices
(X_1, X_2, ..., X_K),
and decomposed to multiple matrix products (U_1 V_1', U_2 V_2', ..., U_K V_K'),
where each U_k and V_k (k=1..K) is specific in each X_k.
Unlike regular PLS, in dPLS,
U_k and V_k are estimated by adding ternary regularization
so that the values are -1, 0, or 1 as much as possible.
}
\usage{
dPLS(X, M=NULL, pseudocount=.Machine$double.eps,
    initV=NULL, fixV=FALSE, Ter_V=1e-10,
    L1_V=1e-10, L2_V=1e-10, eta=1e+10, J = 3,
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
\item{initV}{ The initial values of factor matrix V, which
has M-rows and J-columns (Default: NULL).
}
\item{fixV}{
Whether the factor matrix V is updated in each iteration step
(Default: FALSE).
}
\item{Ter_V}{
Paramter for terary (-1,0,1) regularitation (Default: 1e-10).
}
\item{L1_V}{
Paramter for L1 regularitation (Default: 1e-10).
This also works as small positive constant to prevent division by zero,
so should be set as 0.
}
\item{L2_V}{
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
matdata <- toyModel(model = "dPLS_Easy")

# Simple usage
out <- dPLS(matdata, J=2, num.iter=2)
}
\keyword{methods}
## ----data, echo=TRUE----------------------------------------------------------
library("dcTensor")
X <- dcTensor::toyModel("dPLS_Easy")

## ----data2, echo=TRUE, fig.height=2.7, fig.width=8----------------------------
suppressMessages(library("fields"))
layout(t(1:3))
image.plot(X[[1]], main="X1", legend.mar=8)
image.plot(X[[2]], main="X2", legend.mar=8)
image.plot(X[[3]], main="X3", legend.mar=8)

## ----pls, echo=TRUE-----------------------------------------------------------
set.seed(123456)
out_dPLS <- dPLS(X, Ter_V=1E+5, J=3)
str(out_dPLS, 2)

## ----conv_pls, echo=TRUE, fig.height=4, fig.width=8---------------------------
layout(t(1:2))
plot(log10(out_dPLS$RecError[2:101]), type="b", main="Reconstruction Error")
plot(log10(out_dPLS$RelChange[2:101]), type="b", main="Relative Change")

## ----rec_pls, echo=TRUE, fig.height=5, fig.width=8----------------------------
recX <- lapply(seq_along(X), function(x){
  out_dPLS$U[[x]] %*% t(out_dPLS$V[[x]])
})
layout(rbind(1:3, 4:6))
image.plot(t(X[[1]]))
image.plot(t(X[[2]]))
image.plot(t(X[[3]]))
image.plot(t(recX[[1]]))
image.plot(t(recX[[2]]))
image.plot(t(recX[[3]]))

## ----u_v, echo=TRUE, fig.height=5, fig.width=8--------------------------------
layout(rbind(1:3, 4:6))
hist(out_dPLS$U[[1]], breaks=100)
hist(out_dPLS$U[[2]], breaks=100)
hist(out_dPLS$U[[3]], breaks=100)
hist(out_dPLS$V[[1]], breaks=100)
hist(out_dPLS$V[[2]], breaks=100)
hist(out_dPLS$V[[3]], breaks=100)

## ----sessionInfo, echo=FALSE--------------------------------------------------
sessionInfo()


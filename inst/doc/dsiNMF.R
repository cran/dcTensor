## ----data, echo=TRUE----------------------------------------------------------
library("dcTensor")
X <- dcTensor::toyModel("dsiNMF_Easy")

## ----data2, echo=TRUE, fig.height=2.7, fig.width=8----------------------------
suppressMessages(library("fields"))
layout(t(1:3))
image.plot(X[[1]], main="X1", legend.mar=8)
image.plot(X[[2]], main="X2", legend.mar=8)
image.plot(X[[3]], main="X3", legend.mar=8)

## ----bmf, echo=TRUE-----------------------------------------------------------
set.seed(123456)
out_dsiNMF <- dsiNMF(X, Bin_W=1E+1, Bin_H=c(1E+1, 1E+1, 1E+1), J=3)
str(out_dsiNMF, 2)

## ----conv_bmf, echo=TRUE, fig.height=4, fig.width=8---------------------------
layout(t(1:2))
plot(log10(out_dsiNMF$RecError[2:101]), type="b", main="Reconstruction Error")
plot(log10(out_dsiNMF$RelChange[2:101]), type="b", main="Relative Change")

## ----rec_bmf, echo=TRUE, fig.height=5, fig.width=8----------------------------
recX <- lapply(seq_along(X), function(x){
  out_dsiNMF$W %*% t(out_dsiNMF$H[[x]])
})
layout(rbind(1:3, 4:6))
image.plot(X[[1]], main="X1", legend.mar=8)
image.plot(X[[2]], main="X2", legend.mar=8)
image.plot(X[[3]], main="X3", legend.mar=8)
image.plot(recX[[1]], main="Reconstructed X1", legend.mar=8)
image.plot(recX[[2]], main="Reconstructed X2", legend.mar=8)
image.plot(recX[[3]], main="Reconstructed X3", legend.mar=8)

## ----w_h_bmf, echo=TRUE, fig.height=4, fig.width=8----------------------------
layout(rbind(1:2, 3:4))
hist(out_dsiNMF$W, main="W", breaks=100)
hist(out_dsiNMF$H[[1]], main="H1", breaks=100)
hist(out_dsiNMF$H[[2]], main="H2", breaks=100)
hist(out_dsiNMF$H[[3]], main="H3", breaks=100)

## ----data3, echo=TRUE, fig.height=3.5, fig.width=8----------------------------
suppressMessages(library("nnTensor"))
X2 <- nnTensor::toyModel("siNMF_Easy")
layout(t(1:3))
image.plot(X2[[1]], main="X1", legend.mar=8)
image.plot(X2[[2]], main="X2", legend.mar=8)
image.plot(X2[[3]], main="X3", legend.mar=8)

## ----sbmf, echo=TRUE----------------------------------------------------------
set.seed(123456)
out_dsiNMF2 <- dsiNMF(X2, Bin_W=1E+2, J=3)
str(out_dsiNMF2, 2)

## ----conv_sbmf, echo=TRUE, fig.height=4, fig.width=8--------------------------
layout(t(1:2))
plot(log10(out_dsiNMF2$RecError[2:101]), type="b", main="Reconstruction Error")
plot(log10(out_dsiNMF2$RelChange[2:101]), type="b", main="Relative Change")

## ----rec_sbmf, echo=TRUE, fig.height=5, fig.width=8---------------------------
recX <- lapply(seq_along(X2), function(x){
  out_dsiNMF2$W %*% t(out_dsiNMF2$H[[x]])
})
layout(rbind(1:3, 4:6))
image.plot(X2[[1]], main="X1", legend.mar=8)
image.plot(X2[[2]], main="X2", legend.mar=8)
image.plot(X2[[3]], main="X3", legend.mar=8)
image.plot(recX[[1]], main="Reconstructed X1", legend.mar=8)
image.plot(recX[[2]], main="Reconstructed X2", legend.mar=8)
image.plot(recX[[3]], main="Reconstructed X3", legend.mar=8)

## ----w_h_sbmf, echo=TRUE, fig.height=4, fig.width=8---------------------------
layout(rbind(1:2, 3:4))
hist(out_dsiNMF2$W, breaks=100)
hist(out_dsiNMF2$H[[1]], main="H1", breaks=100)
hist(out_dsiNMF2$H[[2]], main="H2", breaks=100)
hist(out_dsiNMF2$H[[3]], main="H3", breaks=100)

## ----sessionInfo, echo=FALSE--------------------------------------------------
sessionInfo()


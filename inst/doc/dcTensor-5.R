## ----data, echo=TRUE----------------------------------------------------------
library("dcTensor")
suppressMessages(library("nnTensor"))
X <- nnTensor::toyModel("siNMF_Hard")

## ----data2, echo=TRUE, fig.height=2.7, fig.width=8----------------------------
suppressMessages(library("fields"))
layout(t(1:3))
image.plot(X[[1]], main="X1", legend.mar=8)
image.plot(X[[2]], main="X2", legend.mar=8)
image.plot(X[[3]], main="X3", legend.mar=8)

## ----sbmf, echo=TRUE----------------------------------------------------------
set.seed(123456)
out_djNMF <- djNMF(X, Bin_W=1E-1, J=4)
str(out_djNMF, 2)

## ----conv_sbmf, echo=TRUE, fig.height=4, fig.width=8--------------------------
layout(t(1:2))
plot(log10(out_djNMF$RecError[-1]), type="b", main="Reconstruction Error")
plot(log10(out_djNMF$RelChange[-1]), type="b", main="Relative Change")

## ----rec_sbmf, echo=TRUE, fig.height=8, fig.width=8---------------------------
recX1 <- lapply(seq_along(X), function(x){
  out_djNMF$W %*% t(out_djNMF$H[[x]])
})
recX2 <- lapply(seq_along(X), function(x){
  out_djNMF$V[[x]] %*% t(out_djNMF$H[[x]])
})
layout(rbind(1:3, 4:6, 7:9))
image.plot(X[[1]], legend.mar=8, main="X1")
image.plot(X[[2]], legend.mar=8, main="X2")
image.plot(X[[3]], legend.mar=8, main="X3")
image.plot(recX1[[1]], legend.mar=8, main="Reconstructed X1 (Common Factor)")
image.plot(recX1[[2]], legend.mar=8, main="Reconstructed X2 (Common Factor)")
image.plot(recX1[[3]], legend.mar=8, main="Reconstructed X3 (Common Factor)")
image.plot(recX2[[1]], legend.mar=8, main="Reconstructed X1 (Specific Factor)")
image.plot(recX2[[2]], legend.mar=8, main="Reconstructed X2 (Specific Factor)")
image.plot(recX2[[3]], legend.mar=8, main="Reconstructed X3 (Specific Factor)")

## ----w_h_sbmf, echo=TRUE, fig.height=4, fig.width=8---------------------------
layout(rbind(1:4, 5:8))
hist(out_djNMF$W, main="W", breaks=100)
hist(out_djNMF$H[[1]], main="H1", breaks=100)
hist(out_djNMF$H[[2]], main="H2", breaks=100)
hist(out_djNMF$H[[3]], main="H3", breaks=100)
hist(out_djNMF$V[[1]], main="V1", breaks=100)
hist(out_djNMF$V[[2]], main="V2", breaks=100)
hist(out_djNMF$V[[3]], main="V3", breaks=100)

## ----sessionInfo, echo=FALSE--------------------------------------------------
sessionInfo()


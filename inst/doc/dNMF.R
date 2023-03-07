## ----data, echo=TRUE----------------------------------------------------------
library("dcTensor")
X <- dcTensor::toyModel("dNMF")

## ----data2, echo=TRUE, fig.height=4, fig.width=5------------------------------
suppressMessages(library("fields"))
image.plot(X, main="Original Data", legend.mar=8)

## ----bmf, echo=TRUE-----------------------------------------------------------
set.seed(123456)
out_BMF <- dNMF(X, Bin_U=1, Bin_V=1, J=5)
str(out_BMF, 2)

## ----conv_bmf, echo=TRUE, fig.height=4, fig.width=8---------------------------
layout(t(1:2))
plot(log10(out_BMF$RecError[2:101]), type="b", main="Reconstruction Error")
plot(log10(out_BMF$RelChange[2:101]), type="b", main="Relative Change")

## ----rec_bmf, echo=TRUE, fig.height=4, fig.width=8----------------------------
recX <- out_BMF$U %*% t(out_BMF$V)
layout(t(1:2))
image.plot(X, main="Original Data", legend.mar=8)
image.plot(recX, main="Reconstructed Data (BMF)", legend.mar=8)

## ----u_v, echo=TRUE, fig.height=4, fig.width=8--------------------------------
layout(t(1:2))
hist(out_BMF$U, breaks=100)
hist(out_BMF$V, breaks=100)

## ----u_v2, echo=TRUE----------------------------------------------------------
head(out_BMF$U)
head(out_BMF$V)

## ----u_v3, echo=TRUE----------------------------------------------------------
head(round(out_BMF$U, 0))
head(round(out_BMF$V, 0))

## ----data3, echo=TRUE---------------------------------------------------------
suppressMessages(library("nnTensor"))
X2 <- nnTensor::toyModel("NMF")

## ----data4, echo=TRUE, fig.height=4, fig.width=5------------------------------
image.plot(X2, main="Original Data", legend.mar=8)

## ----sbmf, echo=TRUE----------------------------------------------------------
set.seed(123456)
out_SBMF <- dNMF(X2, Bin_U=1E+6, J=5)
str(out_SBMF, 2)

## ----conv_sbmf, echo=TRUE, fig.height=4, fig.width=8--------------------------
layout(t(1:2))
plot(log10(out_SBMF$RecError[2:101]), type="b", main="Reconstruction Error")
plot(log10(out_SBMF$RelChange[2:101]), type="b", main="Relative Change")

## ----rec_sbmf, echo=TRUE, fig.height=4, fig.width=8---------------------------
recX2 <- out_SBMF$U %*% t(out_SBMF$V)
layout(t(1:2))
image.plot(X2, main="Original Data", legend.mar=8)
image.plot(recX2, main="Reconstructed Data (SBMF)", legend.mar=8)

## ----u_v4, echo=TRUE, fig.height=4, fig.width=8-------------------------------
layout(t(1:2))
hist(out_SBMF$U, breaks=100)
hist(out_SBMF$V, breaks=100)

## ----stmf, echo=TRUE----------------------------------------------------------
set.seed(123456)
out_STMF <- dNMF(X2, Ter_U=1E+6, J=5)
str(out_STMF, 2)

## ----conv_stmf, echo=TRUE, fig.height=4, fig.width=8--------------------------
layout(t(1:2))
plot(log10(out_STMF$RecError[2:101]), type="b", main="Reconstruction Error")
plot(log10(out_STMF$RelChange[2:101]), type="b", main="Relative Change")

## ----rec_stmf, echo=TRUE, fig.height=4, fig.width=8---------------------------
recX <- out_STMF$U %*% t(out_STMF$V)
layout(t(1:2))
image.plot(X2, main="Original Data", legend.mar=8)
image.plot(recX, main="Reconstructed Data (STMF)", legend.mar=8)

## ----u_v5, echo=TRUE, fig.height=4, fig.width=8-------------------------------
layout(t(1:2))
hist(out_STMF$U, breaks=100)
hist(out_STMF$V, breaks=100)

## ----sessionInfo, echo=FALSE--------------------------------------------------
sessionInfo()


## ----data, echo=TRUE----------------------------------------------------------
library("dcTensor")
X <- dcTensor::toyModel("dNMF")

## ----data2, echo=TRUE, fig.height=4, fig.width=5------------------------------
suppressMessages(library("fields"))
image.plot(X, main="Original Data", legend.mar=8)

## ----bmf, echo=TRUE-----------------------------------------------------------
set.seed(123456)
out_BMTF <- dNMTF(X, Bin_U=10, Bin_V=10, rank=c(5,5))
str(out_BMTF, 2)

## ----conv_bmf, echo=TRUE, fig.height=4, fig.width=8---------------------------
layout(t(1:2))
plot(log10(out_BMTF$RecError[-1]), type="b", main="Reconstruction Error")
plot(log10(out_BMTF$RelChange[-1]), type="b", main="Relative Change")

## ----rec_bmf, echo=TRUE, fig.height=4, fig.width=8----------------------------
recX <- out_BMTF$U %*% out_BMTF$S %*% t(out_BMTF$V)
layout(t(1:2))
image.plot(X, main="Original Data", legend.mar=8)
image.plot(recX, main="Reconstructed Data (BMF)", legend.mar=8)

## ----u_v, echo=TRUE, fig.height=4, fig.width=8--------------------------------
layout(t(1:3))
hist(out_BMTF$U, breaks=100)
hist(out_BMTF$S, breaks=100)
hist(out_BMTF$V, breaks=100)

## ----u_v2, echo=TRUE----------------------------------------------------------
out_BMTF$U[1:3,1:3]
out_BMTF$S
out_BMTF$V[1:3,1:3]

## ----u_v3, echo=TRUE----------------------------------------------------------
round(out_BMTF$U[1:3,1:3], 0)
round(out_BMTF$S, 0)
round(out_BMTF$V[1:3,1:3], 0)

## ----data3, echo=TRUE---------------------------------------------------------
suppressMessages(library("nnTensor"))
X2 <- nnTensor::toyModel("NMF")

## ----data4, echo=TRUE, fig.height=4, fig.width=5------------------------------
image.plot(X2, main="Original Data", legend.mar=8)

## ----sbmf, echo=TRUE----------------------------------------------------------
set.seed(123456)
out_SBMTF <- dNMTF(X2, Bin_U=1E+6, rank=c(5,5))
str(out_SBMTF, 2)

## ----conv_sbmf, echo=TRUE, fig.height=4, fig.width=8--------------------------
layout(t(1:2))
plot(log10(out_SBMTF$RecError[-1]), type="b", main="Reconstruction Error")
plot(log10(out_SBMTF$RelChange[-1]), type="b", main="Relative Change")

## ----rec_sbmf, echo=TRUE, fig.height=4, fig.width=8---------------------------
recX2 <- out_SBMTF$U %*% out_SBMTF$S %*% t(out_SBMTF$V)
layout(t(1:2))
image.plot(X2, main="Original Data", legend.mar=8)
image.plot(recX2, main="Reconstructed Data (SBMF)", legend.mar=8)

## ----u_v4, echo=TRUE, fig.height=4, fig.width=8-------------------------------
layout(t(1:3))
hist(out_SBMTF$U, breaks=100)
hist(out_SBMTF$S, breaks=100)
hist(out_SBMTF$V, breaks=100)

## ----stmf, echo=TRUE----------------------------------------------------------
set.seed(123456)
out_STMTF <- dNMTF(X2, Ter_U=1E+5, rank=c(5,5))
str(out_STMTF, 2)

## ----conv_stmf, echo=TRUE, fig.height=4, fig.width=8--------------------------
layout(t(1:2))
plot(log10(out_STMTF$RecError[-1]), type="b", main="Reconstruction Error")
plot(log10(out_STMTF$RelChange[-1]), type="b", main="Relative Change")

## ----rec_stmf, echo=TRUE, fig.height=4, fig.width=8---------------------------
recX <- out_STMTF$U %*%  out_STMTF$S %*% t(out_STMTF$V)
layout(t(1:2))
image.plot(X2, main="Original Data", legend.mar=8)
image.plot(recX, main="Reconstructed Data (STMF)", legend.mar=8)

## ----u_v5, echo=TRUE, fig.height=4, fig.width=8-------------------------------
layout(t(1:3))
hist(out_STMTF$U, breaks=100)
hist(out_STMTF$S, breaks=100)
hist(out_STMTF$V, breaks=100)

## ----sessionInfo, echo=FALSE--------------------------------------------------
sessionInfo()


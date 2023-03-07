## ----data, echo=TRUE----------------------------------------------------------
library("dcTensor")
X <- dcTensor::toyModel("dSVD")

## ----data2, echo=TRUE, fig.height=4, fig.width=5------------------------------
suppressMessages(library("fields"))
image.plot(X, main="Original Data", legend.mar=8)

## ----stmf, echo=TRUE----------------------------------------------------------
set.seed(123456)
out_STMF <- dSVD(X, Ter_U=1E+10, J=5)
str(out_STMF, 2)

## ----conv_stmf, echo=TRUE, fig.height=4, fig.width=8--------------------------
layout(t(1:2))
plot(log10(out_STMF$RecError[2:101]), type="b", main="Reconstruction Error")
plot(log10(out_STMF$RelChange[2:101]), type="b", main="Relative Change")

## ----rec_stmf, echo=TRUE, fig.height=4, fig.width=8---------------------------
recX <- out_STMF$U %*% t(out_STMF$V)
layout(t(1:2))
image.plot(X, main="Original Data", legend.mar=8)
image.plot(recX, main="Reconstructed Data (STMF)", legend.mar=8)

## ----u_v5, echo=TRUE, fig.height=4, fig.width=8-------------------------------
layout(t(1:2))
hist(out_STMF$U, breaks=100)
hist(out_STMF$V, breaks=100)

## ----sessionInfo, echo=FALSE--------------------------------------------------
sessionInfo()


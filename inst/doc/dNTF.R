## ----data, echo=TRUE----------------------------------------------------------
library("dcTensor")
X <- dcTensor::toyModel("dNTF")

## ----data2, echo=TRUE, fig.height=8, fig.width=8------------------------------
suppressMessages(library("nnTensor"))
plotTensor3D(X)

## ----bmf, echo=TRUE, fig.height=4, fig.width=8--------------------------------
set.seed(123456)
out_dNTF <- dNTF(X, Bin_A=c(1e+2, 1e+2, 1e+2), algorithm="KL", rank=4)
str(out_dNTF, 2)

## ----conv_bmf, echo=TRUE, fig.height=4, fig.width=8---------------------------
layout(t(1:2))
plot(log10(out_dNTF$RecError[2:101]), type="b", main="Reconstruction Error")
plot(log10(out_dNTF$RelChange[2:101]), type="b", main="Relative Change")

## ----rec_bmf, echo=TRUE, fig.height=4, fig.width=8----------------------------
recX <- recTensor(out_dNTF$S, out_dNTF$A)
layout(t(1:2))
plotTensor3D(X)
plotTensor3D(recX, thr=0)

## ----a_bmf, echo=TRUE, fig.height=4, fig.width=8------------------------------
layout(t(1:3))
hist(out_dNTF$A[[1]], main="A1", breaks=100)
hist(out_dNTF$A[[2]], main="A2", breaks=100)
hist(out_dNTF$A[[3]], main="A3", breaks=100)

## ----data3, echo=TRUE, fig.height=8, fig.width=8------------------------------
X2 <- nnTensor::toyModel("CP")
plotTensor3D(X2)

## ----sbmf, echo=TRUE, fig.height=4, fig.width=8-------------------------------
set.seed(123456)
out_dNTF2 <- dNTF(X2, Bin_A=c(1e+5, 1e+5, 1e-10), algorithm="KL", rank=4)
str(out_dNTF2, 2)

## ----conv_sbmf, echo=TRUE, fig.height=4, fig.width=8--------------------------
layout(t(1:2))
plot(log10(out_dNTF2$RecError[2:101]), type="b", main="Reconstruction Error")
plot(log10(out_dNTF2$RelChange[2:101]), type="b", main="Relative Change")

## ----rec_sbmf, echo=TRUE, fig.height=4, fig.width=8---------------------------
recX <- recTensor(out_dNTF2$S, out_dNTF2$A)
layout(t(1:2))
plotTensor3D(X2)
plotTensor3D(recX, thr=0)

## ----a_sbmf, echo=TRUE, fig.height=4, fig.width=8-----------------------------
layout(t(1:3))
hist(out_dNTF2$A[[1]], main="A1", breaks=100)
hist(out_dNTF2$A[[2]], main="A2", breaks=100)
hist(out_dNTF2$A[[3]], main="A3", breaks=100)

## ----sessionInfo, echo=FALSE--------------------------------------------------
sessionInfo()


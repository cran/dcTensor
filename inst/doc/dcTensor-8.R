## ----data, echo=TRUE----------------------------------------------------------
library("dcTensor")
X <- dcTensor::toyModel("dNTF")

## ----data2, echo=TRUE, fig.height=8, fig.width=8------------------------------
suppressMessages(library("nnTensor"))
plotTensor3D(X)

## ----bmf, echo=TRUE-----------------------------------------------------------
set.seed(123456)
out_dNTD <- dNTD(X, Bin_A=c(1e+6, 1e+6, 1e+6), thr=1e-20, rank=c(4,4,4))
str(out_dNTD, 2)

## ----conv_bmf, echo=TRUE, fig.height=4, fig.width=8---------------------------
layout(t(1:2))
plot(log10(out_dNTD$RecError[-1]), type="b", main="Reconstruction Error")
plot(log10(out_dNTD$RelChange[-1]), type="b", main="Relative Change")

## ----rec_bmf, echo=TRUE, fig.height=4, fig.width=8----------------------------
recX <- recTensor(out_dNTD$S, out_dNTD$A)
layout(t(1:2))
plotTensor3D(X)
plotTensor3D(recX, thr=0)

## ----a_bmf, echo=TRUE, fig.height=4, fig.width=8------------------------------
layout(t(1:3))
hist(out_dNTD$A[[1]], main="A1", breaks=100)
hist(out_dNTD$A[[2]], main="A2", breaks=100)
hist(out_dNTD$A[[3]], main="A3", breaks=100)

## ----data3, echo=TRUE, fig.height=8, fig.width=8------------------------------
X2 <- nnTensor::toyModel("CP")
plotTensor3D(X2)

## ----sbmf, echo=TRUE----------------------------------------------------------
set.seed(123456)
out_dNTD2 <- dNTD(X2, Bin_A=c(1e-10, 1e-10, 1e+5), rank=c(4,4,4))
str(out_dNTD2, 2)

## ----conv_sbmf, echo=TRUE, fig.height=4, fig.width=8--------------------------
layout(t(1:2))
plot(log10(out_dNTD2$RecError[-1]), type="b", main="Reconstruction Error")
plot(log10(out_dNTD2$RelChange[-1]), type="b", main="Relative Change")

## ----rec_sbmf, echo=TRUE, fig.height=4, fig.width=8---------------------------
recX <- recTensor(out_dNTD2$S, out_dNTD2$A)
layout(t(1:2))
plotTensor3D(X2)
plotTensor3D(recX, thr=0)

## ----a_sbmf, echo=TRUE, fig.height=4, fig.width=8-----------------------------
layout(t(1:3))
hist(out_dNTD2$A[[1]], main="A1", breaks=100)
hist(out_dNTD2$A[[2]], main="A2", breaks=100)
hist(out_dNTD2$A[[3]], main="A3", breaks=100)

## ----sessionInfo, echo=FALSE--------------------------------------------------
sessionInfo()


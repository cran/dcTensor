djNMF <- function(X, M=NULL, pseudocount=.Machine$double.eps,
    initW=NULL, initV=NULL, initH=NULL,
    fixW=FALSE, fixV=FALSE, fixH=FALSE,
    Bin_W=1e-10, Bin_V=rep(1e-10, length=length(X)),
    Bin_H=rep(1e-10, length=length(X)),
    Ter_W=1e-10, Ter_V=rep(1e-10, length=length(X)),
    Ter_H=rep(1e-10, length=length(X)),
    L1_W=1e-10, L1_V=rep(1e-10, length=length(X)),
    L1_H=rep(1e-10, length=length(X)),
    L2_W=1e-10, L2_V=rep(1e-10, length=length(X)),
    L2_H=rep(1e-10, length=length(X)),
    J = 3, w=NULL, algorithm = c("Frobenius", "KL", "IS", "PLTF"), p=1,
    thr = 1e-10, num.iter = 100,
    viz = FALSE, figdir = NULL, verbose = FALSE){
    # Argument check
    algorithm <- match.arg(algorithm)
    .checkdjNMF(X, M, pseudocount,
        initW, initV, initH, fixW, fixV, fixH,
        Bin_W, Bin_V, Bin_H, Ter_W, Ter_V, Ter_H,
        L1_W, L1_V, L1_H, L2_W, L2_V, L2_H,
        J, w,
        p, thr, num.iter, viz, figdir, verbose)
    # Initialization of W, V, H
    int <- .initdjNMF(X, M, pseudocount, fixV, fixH, w, initW, initV, initH, J, p, thr, algorithm, verbose)
    X <- int$X
    M <- int$M
    pM <- int$pM
    M_NA <- int$M_NA
    fixV <- int$fixV
    fixH <- int$fixH
    w <- int$w
    K <- int$K
    W <- int$W
    V <- int$V
    H <- int$H
    RecError <- int$RecError
    TrainRecError <- int$TrainRecError
    TestRecError <- int$TestRecError
    RelChange <- int$RelChange
    p <- int$p
    iter <- 1
    while ((RecError[iter] > thr) && (iter <= num.iter)) {
        # Before Update W, H_k
        X_bar <- lapply(seq_len(K), function(k){
            .recMatrix(W + V[[k]], H[[k]])
        })
        pre_Error <- sqrt(sum(unlist(lapply(seq_along(X), function(x){
            .recError(X[[x]], X_bar[[x]], notsqrt=TRUE)
        }))))
        # Update W
        if(!fixW){
            W_numer <- matrix(0, nrow=nrow(W), ncol=ncol(W))
            W_denom <- matrix(0, nrow=nrow(W), ncol=ncol(W))
            for(k in seq_len(K)){
                W_numer <- W_numer + w[k] * (pM[[k]] * X[[k]] * (pM[[k]] * X_bar[[k]])^(-p)) %*% H[[k]]
                W_denom <- W_denom + w[k] * (pM[[k]] * (W + V[[k]]) %*% t(H[[k]]))^(1-p) %*% H[[k]] + L1_W + L2_W * W
            }
            W_numer <- W_numer + 3 * Bin_W * W^2
            W_numer <- W_numer + 30 * Ter_W * W^4 + 36 * Ter_W * W^2
            W_denom <- W_denom + 2 * Bin_W * W^3 + Bin_W * W
            W_denom <- W_denom + 6 * Ter_W * W^5 + 52 * Ter_W * W^3 + 8 * Ter_W * W
            W <- .positive(W * W_numer / W_denom)^.rho(p)
        }
        # Update H_k
        for(k in seq_len(K)){
            if(!fixH[k]){
                Hk_numer <- (t(pM[[k]] * X[[k]]) * t(pM[[k]] * X_bar[[k]])^(-p)) %*% (W + V[[k]])
                Hk_denom <- t(pM[[k]] * (W + V[[k]]) %*% t(H[[k]]))^(1-p) %*% W + L1_H[k] + L2_H[k] * H[[k]]
                Hk_numer <- Hk_numer + 3 * Bin_H[k] * H[[k]]^2
                Hk_numer <- Hk_numer + 30 * Ter_H[k] * H[[k]]^4 + 36 * Ter_H[k] * H[[k]]^2
                Hk_denom <- Hk_denom + 2 * Bin_H[k] * H[[k]]^3 + Bin_H[k] * H[[k]]
                Hk_denom <- Hk_denom + 6 * Ter_H[k] * H[[k]]^5 + 52 * Ter_H[k] * H[[k]]^3 + 8 * Ter_H[k] * H[[k]]
                H[[k]] <- H[[k]] * (Hk_numer / Hk_denom)^.rho(p)
            }
        }
        # Update V_k
        for(k in seq_len(K)){
            if(!fixV[k]){
                Vk_numer <- (pM[[k]] * X[[k]] * (pM[[k]] * X_bar[[k]])^(-p)) %*% H[[k]]
                Vk_denom <- (pM[[k]] * (W + V[[k]]) %*% t(H[[k]]))^(1-p) %*% H[[k]] + L1_V[k] + L2_V[k] * V[[k]]
                Vk_numer <- Vk_numer + 3 * Bin_V[k] * V[[k]]^2
                Vk_numer <- Vk_numer + 30 * Ter_V[k] * V[[k]]^4 + 36 * Ter_V[k] * V[[k]]^2
                Vk_denom <- Vk_denom + 2 * Bin_V[k] * V[[k]]^3 + Bin_V[k] * V[[k]]
                Vk_denom <- Vk_denom + 6 * Ter_V[k] * V[[k]]^5 + 52 * Ter_V[k] * V[[k]]^3 + 8 * Ter_V[k] * V[[k]]
                V[[k]] <- V[[k]] * (Vk_numer / Vk_denom)^.rho(p)
            }
        }
        # After Update W, H_k
        iter <- iter + 1
        X_bar <- lapply(seq_len(K), function(k){
            .recMatrix(W + V[[k]], H[[k]])
        })
        RecError[iter] <- sqrt(sum(unlist(lapply(seq_along(X), function(x){
            .recError(X[[x]], X_bar[[x]], notsqrt=TRUE)
        }))))
        TrainRecError[iter] <- sqrt(sum(unlist(lapply(seq_along(X), function(x){
            .recError((1-M_NA[[x]]+M[[x]])*X[[x]], (1-M_NA[[x]]+M[[x]])*X_bar[[x]], notsqrt=TRUE)
        }))))
        TestRecError[iter] <- sqrt(sum(unlist(lapply(seq_along(X), function(x){
            .recError((M_NA[[x]]-M[[x]])*X[[x]], (M_NA[[x]]-M[[x]])*X_bar[[x]], notsqrt=TRUE)
        }))))
        RelChange[iter] <- abs(pre_Error - RecError[iter]) / RecError[iter]
        # Visualization
        if (viz && !is.null(figdir)) {
            png(filename = paste0(figdir, "/", iter-1, ".png"))
            .imageplot_djNMF(X, W, V, H)
            dev.off()
        }
        if (viz && is.null(figdir)) {
            .imageplot_djNMF(X, W, V, H)
        }
        # Verbose Message
        if (verbose) {
            cat(paste0(iter-1, " / ", num.iter, " |Previous Error - Error| / Error = ",
                RelChange[iter], "\n"))
        }
        # Exception Handling
        if (is.nan(RelChange[iter])) {
            stop("NaN is generated. Please run again or change the parameters.\n")
        }
    }
    # Visualization
    if (viz && !is.null(figdir)) {
        png(filename = paste0(figdir, "/finish.png"))
        .imageplot_djNMF(X, W, V, H)
        dev.off()
    }
    if (viz && is.null(figdir)) {
        .imageplot_djNMF(X, W, V, H)
    }
    # Output
    names(RecError) <- c("offset", seq_len(iter-1))
    names(TrainRecError) <- c("offset", seq_len(iter-1))
    names(TestRecError) <- c("offset", seq_len(iter-1))
    names(RelChange) <- c("offset", seq_len(iter-1))
    list(W = W, V = V, H = H,
        RecError = RecError,
        TrainRecError = TrainRecError,
        TestRecError = TestRecError,
        RelChange = RelChange)
}

.checkdjNMF <- function(X, M, pseudocount, initW, initV, initH, fixW, fixV, fixH, Bin_W, Bin_V, Bin_H, Ter_W, Ter_V, Ter_H,
    L1_W, L1_V, L1_H, L2_W, L2_V, L2_H, J, w,
    p, thr, num.iter, viz, figdir, verbose){
    stopifnot(is.list(X))
    if(length(X) < 2){
        stop("input list X must have at least two datasets!")
    }
    if(!is.null(M)){
        dimX <- as.vector(unlist(lapply(X, function(x){dim(x)})))
        dimM <- as.vector(unlist(lapply(M, function(x){dim(x)})))
        if(!identical(dimX, dimM)){
            stop("Please specify the dimensions of X and M are same")
        }
        lapply(seq(length(X)), function(i){
            .checkZeroNA(X[[i]], M[[i]], type="matrix")
        })
    }
    stopifnot(is.numeric(pseudocount))
    if(!is.null(initW)){
        if(!identical(nrow(X[[1]]), nrow(initW))){
            stop("Please specify nrow(X[[k]]) and nrow(W) are same")
        }
    }
    if(!is.null(initV)){
        nrowX <- as.vector(unlist(lapply(X, nrow)))
        nrowV <- as.vector(unlist(lapply(initV, nrow)))
        if(!identical(nrowX, nrowV)){
            stop("Please specify nrow(X[[k]]) and nrow(W) are same")
        }
    }
    if(!is.null(initH)){
        ncolX <- as.vector(unlist(lapply(X, ncol)))
        nrowH <- as.vector(unlist(lapply(initH, nrow)))
        if(!identical(ncolX, nrowH)){
            stop("Please specify all the ncol(initH[[k]]) are same as ncol(X[[k]]) (k=1,2,...)")
        }
    }
    stopifnot(is.logical(fixW))
    if(!is.logical(fixV)){
        if(!is.vector(fixV)){
            stop("Please specify the fixV as a logical or a logical vector such as c(TRUE, FALSE, TRUE)")
        }else{
            if(length(X) != length(fixV)){
                stop("Please specify the length of fixV same as the length of X")
            }
        }
    }
    if(!is.logical(fixH)){
        if(!is.vector(fixH)){
            stop("Please specify the fixH as a logical or a logical vector such as c(TRUE, FALSE, TRUE)")
        }else{
            if(length(X) != length(fixH)){
                stop("Please specify the length of fixH same as the length of X")
            }
        }
    }
    stopifnot(length(Bin_W) == 1)
    stopifnot(length(Ter_W) == 1)
    stopifnot(length(L1_W) == 1)
    stopifnot(length(L2_W) == 1)
    stopifnot(Bin_W > 0)
    stopifnot(Ter_W > 0)
    stopifnot(L1_W > 0)
    stopifnot(L2_W > 0)
    stopifnot(length(Bin_V) == length(X))
    stopifnot(length(Ter_V) == length(X))
    stopifnot(length(L1_V) == length(X))
    stopifnot(length(L2_V) == length(X))
    stopifnot(all(unlist(lapply(Bin_V, function(x){x > 0}))))
    stopifnot(all(unlist(lapply(Ter_V, function(x){x > 0}))))
    stopifnot(all(unlist(lapply(L1_V, function(x){x > 0}))))
    stopifnot(all(unlist(lapply(L2_V, function(x){x > 0}))))
    stopifnot(length(Bin_H) == length(X))
    stopifnot(length(Ter_H) == length(X))
    stopifnot(length(L1_H) == length(X))
    stopifnot(length(L2_H) == length(X))
    stopifnot(all(unlist(lapply(Bin_H, function(x){x > 0}))))
    stopifnot(all(unlist(lapply(Ter_H, function(x){x > 0}))))
    stopifnot(all(unlist(lapply(L1_H, function(x){x > 0}))))
    stopifnot(all(unlist(lapply(L2_H, function(x){x > 0}))))
    stopifnot(is.numeric(J))
    if(!is.null(w)){
        if(length(X) != length(w)){
            stop("The length of weight vector must be same as that of input list X!")
        }
    }
    stopifnot(is.numeric(p))
    stopifnot(is.numeric(thr))
    stopifnot(is.numeric(num.iter))
    stopifnot(is.logical(viz))
    stopifnot(is.logical(verbose))
    if(!is.character(figdir) && !is.null(figdir)){
        stop("Please specify the figdir as a string or NULL")
    }
}

.initdjNMF <- function(X, M, pseudocount, fixV, fixH, w, initW, initV, initH, J, p, thr, algorithm, verbose){
    K <- length(X)
    if(is.logical(fixV)){
        fixV <- rep(fixV, length=length(X))
    }
    if(is.logical(fixH)){
        fixH <- rep(fixH, length=length(X))
    }
    if(is.null(w)){
        w <- rep(1, length=length(X))
    }
    w <- w / sum(w)
    # NA mask
    M_NA <- list()
    length(M_NA) <- length(X)
    for(i in seq_along(X)){
        M_NA[[i]] <- X[[i]]
        M_NA[[i]][] <- 1
        M_NA[[i]][which(is.na(X[[i]]))] <- 0
    }
    if(is.null(M)){
        M <- M_NA
    }
    pM <- M
    # Pseudo count
    for(i in seq_along(X)){
        X[[i]][which(is.na(X[[i]]))] <- pseudocount
        X[[i]][which(X[[i]] == 0)] <- pseudocount
        pM[[i]][which(pM[[i]] == 0)] <- pseudocount
    }
    if(is.null(initW)){
        W <- matrix(runif(nrow(X[[1]])*J),
            nrow=nrow(X[[1]]), ncol=J)
    }else{
        W <- initW
    }
    if(is.null(initV)){
        V <- lapply(seq_along(X), function(x){
            matrix(runif(nrow(X[[1]])*J),
            nrow=nrow(X[[1]]), ncol=J)
        })
    }else{
        V <- initV
    }
    if(is.null(initH)){
        H <- lapply(seq_along(X), function(x){
            matrix(runif(ncol(X[[x]])*J),
                nrow=ncol(X[[x]]), ncol=J)
        })
    }else{
        H <- initH
    }
    RecError = c()
    TrainRecError = c()
    TestRecError = c()
    RelChange = c()
    RecError[1] <- thr * 10
    TrainRecError[1] <- thr * 10
    TestRecError[1] <- thr * 10
    RelChange[1] <- thr * 10
    # Algorithm
    if (algorithm == "Frobenius") {
        p = 0
    }
    if (algorithm == "KL") {
        p = 1
    }
    if (algorithm == "IS") {
        p = 2
    }
    if (algorithm == "PLTF") {
        p = p
    }
    if (verbose) {
        cat("Iterative step is running...\n")
    }
    list(X=X, M=M, pM=pM, M_NA=M_NA,
        fixV=fixV, fixH=fixH, w=w, K=K,
        W=W, V=V, H=H, RecError=RecError, TrainRecError=TrainRecError, TestRecError=TestRecError, RelChange=RelChange,
        p=p)
}

.imageplot_djNMF <- function(X, W, V, H){
    l <- length(X)
    layout(rbind(seq_len(l), seq_len(l)+l, seq_len(l)+2*l))
    lapply(seq_along(X), function(x){
        image.plot(t(X[[x]]))
    })
    lapply(seq_along(X), function(x){
        image.plot(t(W %*% t(H[[x]])))
    })
    lapply(seq_along(X), function(x){
        image.plot(t(V[[x]] %*% t(H[[x]])))
    })
}

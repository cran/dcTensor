X <- dtoyModel("dPLS_Easy")

out <- dPLS(X, J=3, num.iter=2)

expect_equivalent(length(out), 6)

nw <- function(a, b, mismatch=-20, gap=-10) {
	n <- nchar(a)
	m <- nchar(b)
	dimnames <- list(strsplit(a, "")[[1]], strsplit(b, "")[[1]])
	d <- matrix(0, nrow=n, ncol=m, dimnames=dimnames)
	act.values <- c("u", "l", "d")
	actions <- matrix(0, nrow=n, ncol=m, dimnames=dimnames)
	for(i in 1:n) {
		d[i, 1] <- gap*(i-1)
	}
	for(i in 1:m) {
		d[1, i] <- gap*(i-1)
	}

	for( i in 2:n ) {
		for( j in 2:m) {	
			scores = c(d[i-1, j]+gap, d[i, j-1]+gap, d[i-1, j-1]+sum(substring(a, i, i)!=substring(b, j, j))*mismatch)
			ind <- which.max(scores)
			d[i, j] <- scores[ind]
			actions[i,j] <- act.values[ind]
		}
	}
	a.res = ""
	aln.res = ""
	b.res = ""
	curr_i = n
	curr_j = m
	for(i in 1:max(m,n)) {
		curr_a <- substr(a, curr_i, curr_i)
		curr_b <- substr(b, curr_j, curr_j)
		cat(i, " : ", actions[curr_i, curr_j], "\n")
		if(actions[curr_i, curr_j]=="d") {
			a.res <- paste(curr_a, a.res, sep="")
			b.res <- paste(curr_b, b.res, sep="")
			if(curr_a==curr_b) {
				aln.res <- paste("*", aln.res, sep="")
			} else {
				aln.res <- paste("!", aln.res, sep="")
			}
			curr_i <- curr_i -1
			curr_j <- curr_j -1
		} else if(actions[curr_i, curr_j]=="u") {
			a.res <- paste("-", a.res, sep="")
			b.res <- paste(curr_b, b.res, sep="")
			aln.res <- paste(" ", aln.res, sep="")
			curr_i <- curr_i -1
		} else if(actions[curr_i, curr_j]=="l"){
			b.res <- paste("-", b.res, sep="")
			a.res <- paste(curr_a, a.res, sep="")
			aln.res <- paste(" ", aln.res, sep="")
			curr_j <- curr_j -1
		} else {
			while(curr_i > 1) {
				a.res <- paste(substr(a,curr_i, curr_i), a.res, sep="")
				b.res <- paste("-", b.res, sep="")
				aln.res <- paste(" ", aln.res, sep="")
				curr_i <- curr_i -1
			}
			while(curr_j > 1) {
				b.res <- paste(substr(b,curr_j, curr_j), b.res, sep="")
				a.res <- paste("-", a.res, sep="")
				aln.res <- paste(" ", aln.res, sep="")
				curr_j <- curr_j -1
			}
			break
		}
	}
	list(d, actions, a.res, aln.res, b.res)
}

ret <- nw("RRBBBRR", "RRRBBBR")
d <- ret[[1]]
a <- ret[[2]]
cat("\n", ret[[3]], "\n", ret[[4]], "\n", ret[[5]], "\n")

#BBRRBBBR- 
#  ******  
#--RRBBBRR
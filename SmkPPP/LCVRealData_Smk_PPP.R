

# Get standardised data (LDSC output)
P1 = na.omit(read.table("/Users/alicesmail/Desktop/KCL/LCV/GWASFiles/SmkMHC.sumstats.gz", header=TRUE, sep="\t", stringsAsFactors = FALSE))
P2 = na.omit(read.table("/Users/alicesmail/Desktop/KCL/LCV/GWASFiles/PPPMHC.sumstats.gz", header=TRUE, sep="\t", stringsAsFactors = FALSE))

# Get LD scores
LDScores = read.table("/Users/alicesmail/Desktop/KCL/LCV/eur_w_ld_chr/1.l2.ldscore.gz", header=TRUE, sep='\t', stringsAsFactors=FALSE)
for (i in 2:22){
  x <- read.table(paste0("/Users/alicesmail/Desktop/KCL/LCV/eur_w_ld_chr/",i,".l2.ldscore.gz"), header=TRUE, sep='\t', stringsAsFactors=FALSE)
  LDScores <- rbind(LDScores, x)
}

# Merge LD scores with munged GWAS data
P = merge(P1, P2, by="SNP")
data = merge(LDScores, P, by="SNP")

# 816,475 SNPs included in analysis
dim(data) 

# Sort by Chr & BP 
data = data[order(data[,"CHR"], data[,"BP"]),]

# Flip sign of one z-score if opposite alleles
mismatch = which(data$A1.x!=data$A1.y,arr.ind=TRUE)
data[mismatch,]$Z.y = data[mismatch,]$Z.y*-1
data[mismatch,]$A1.y = data[mismatch,]$A1.x
data[mismatch,]$A2.y = data[mismatch,]$A2.x

# Load LCV software
setwd("/Users/alicesmail/Desktop/KCL/LCV/LCVRScripts")
source("./RunLCV.R")

# Run LCV
LCV = RunLCV(data$L2,data$Z.x,data$Z.y)

# Print results
sprintf("Estimated posterior gcp=%.2f(%.2f), p=%.20f; estimated rho=%.2f(%.2f)",LCV$gcp.pm, LCV$gcp.pse, LCV$pval.gcpzero.2tailed, LCV$rho.est, LCV$rho.err)

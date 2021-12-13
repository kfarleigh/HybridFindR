
#' Peroform differential introgression analysis
#'
#' @param Data Object produced by the PrepareData function
#' @param H.id Character, the label for the hybrid population.
#' @param S0.id Character, the label for the S0 parental population.
#' @param S1.id Character, the label for the S1 parental population.
#' @param n.ind Numeric, the number of individuals in your data file.
#' @param permutations Numeric, number of permutations to use in significance testing.
#' @param ploidy Numeric, ploidy of markers in the Data object.
#'
#' @return A p-value for each SNP representing the proportion of permutations that possessed a greater proportion of S1 alleles in permuted hybrids than the empirical data.
#' @export
#'
#' @examples
#' \dontrun{ DI_test <- Differential_introgression(Data, H.id = 'H', S0.id = 'P',
#' S1.id = 'K', n.ind = 73, permutations = 1000, ploidy = 2)}
Differential_introgression <- function(Data, H.id, S0.id, S1.id, n.ind, permutations, ploidy) {
# Pull genotypes from the prepdata object
Genotypes <- Data

# Remove source column from Genotypes
Genotypes <- Genotypes[,-3]
Genotypes <- list2DF(Genotypes)

# Change the population IDs to numbers, 1 = hybrid, 0 = non-hybrid
Genotypes$POPID[Genotypes$POPID == H.id] <- 1
Genotypes$POPID[Genotypes$POPID == S1.id] <- 0
Genotypes$POPID[Genotypes$POPID == S0.id] <- 0

# Add hybrid ID column to end and remove extra columns in front
Genotypes$Hybrid <- Genotypes$POPID
Genotypes <- Genotypes[,3:length(Genotypes)]

# Number of permutations for each SNP
perms <- permutations

# Set the permutations
tags_permutations <- list()
for(i in 1:perms) {
  tags_permutations[[i]] <- gtools::permute(as.numeric(Genotypes$Hybrid))
}

# Retain Unique permutations
tags_permutations <- unique(tags_permutations)

# Get SNP names
SNPs <- colnames(Genotypes)
SNPs <- SNPs[1:(length(SNPs)-1)]

# Calculate the proportion of parental alleles in hybrids
Observed_prop <- list()
for(i in 1:(ncol(Genotypes)-1)) {

# Pull out individual SNPs and pop assignments
# Remove any NAs
# Determine what the parental state is
Dati <- Genotypes[, c(i, (ncol(Genotypes)))]
Dati <- Dati[stats::complete.cases(Dati),]

# Pull hybrids and determine the proportion of them that have the parental state
H <- Dati[which(Dati$Hybrid == 1),]

PropH <- sum(H[,1])/(length(H[,1])*ploidy)

# Put it into our list object
Observed_prop[[i]] <- PropH

}

# Pull the names of SNPs
# Remove anything that had an observed difference of 0
names(Observed_prop) <- SNPs

# Remove SNPs with an Observed Proportion of 0
Obs_prop_final <- Observed_prop[which(Observed_prop != 0)]

# Remove those SNPs from the Genotypes object
Gtypes <- Genotypes[,which(Observed_prop != 0)]

# Calculate the differences from our permutations
Perm_prop <- NULL
Pval <- NULL
PropP <- NULL

Perm_prop <- list()
Pval <- list()

cat(paste("Running Permutations"),
    fill=1); utils::flush.console()
# Set progress bar
Nsnp <- (ncol(Gtypes)-1)
pb <- utils::txtProgressBar(min = 0, max = Nsnp, initial = 0, style = 3)

for(j in 1:(ncol(Gtypes)-1)) {
for(i in 1:perms) {
  PermSNPi <- Gtypes[, c(j, ncol(Gtypes))]
  PermSNPi$Hybrid <- tags_permutations[[i]]

  PermSNPi <- PermSNPi[stats::complete.cases(PermSNPi), ]


  # Calculate the proportion of parental states in pseudohybrids
  PermH <- PermSNPi[which(PermSNPi$Hybrid == 1),]
  PermH <- PermH[stats::complete.cases(PermH),]
  PropP <- c(PropP,sum(PermH[,1])/(length(PermH[,1])*ploidy))
 # Calculate P-value per SNP
  P <- mean(PropP > Obs_prop_final[[j]])
  }
Perm_prop[[j]] <- PropP
Pval[[j]] <- P
PermH <- NULL
PropP <- NULL
P <- NULL
utils::setTxtProgressBar(pb,j)
}

### Determine significance ###
# Compares our observed data to the permutations
SNPs_final <- colnames(Gtypes)
SNPs_final <- SNPs_final[1:(length(SNPs_final)-1)]
names(Perm_prop) <- SNPs_final
names(Pval) <- SNPs_final
Pvalue <- data.frame(t(list2DF(Pval)))
Pvalue$SNP <- SNPs_final
colnames(Pvalue) <- c('Raw.P', 'SNP')
Pvalue$Raw.P[Pvalue$Raw.P == 0] <- (1/permutations)
return(Pvalue)
}


#' Plot the proportion of parental alleles in hybrid individuals
#'
#' @param SNP_names Character or character vector, containing the names of SNPs that you want to plot.
#' @param ploidy Numeric, ploidy of markers in the Data object.
#' @param S1_color Character, desired color for the S1 parental alleles.
#' @param S0_color Character, desired color for the S0 parental alleles.
#' @param Data Object produced by the PrepareData function
#'
#' @return A plot displaying the proportion of parental alleles in hybrids at each SNP provided to the SNP_names parameter.
#' @export
#'
#' @examples
#' \dontrun{ Plotprops(SNP_names = candidate_snps, ploidy = 2,
#' S1_color = 'red', S0_color = 'blue')}
Plotprops <- function(Data, SNP_names, ploidy, S1_color, S0_color){
Cand_SNP <- SNP_names
Cands_geno <- dplyr::select(Data, c(1:2,all_of(Cand_SNP)))

Hybrid_geno <- as.data.frame(Cands_geno[which(Cands_geno$POPID == 'H'),])

S1_prop <- list()
S0_prop <- list()
Loc <- colnames(Cands_geno[,3:length(Cands_geno)])
for (i in Loc) {
  H_geno <- data.frame(Hybrid_geno[,i])
  H_geno <- data.frame(H_geno[complete.cases(H_geno),])
  propS1 <- round(sum(H_geno[,1])/(nrow(H_geno)*ploidy),3)
  propS0 <- 1-propS1
  S1_prop[[i]] <- propS1
  S0_prop[[i]] <- propS0
}

S1_df <- data.frame(do.call('rbind', S1_prop))
S1_df$SNP <- Cand_SNP
colnames(S1_df) <- c('S1_prop', 'SNP')

S0_df <- data.frame(do.call('rbind', S0_prop))
S0_df$SNP <- Cand_SNP
colnames(S0_df) <- c('S0_prop', 'SNP')
S0_df$S0_prop = (S0_df$S0_prop * -1)


Propplot <- ggplot2::ggplot() +
  ggplot2::geom_point(data = S1_df, aes( x = 1:nrow(S1_df), y = S1_prop), size = 0.5, color= S1_color) +
  ggplot2::geom_point(data = S0_df, aes( x = 1:nrow(S0_df), y = S0_prop), size = 0.5, color= S0_color) +
  ggplot2::geom_linerange(data = S1_df, aes(x = 1:nrow(S1_df), ymax = S1_prop, ymin = 0), color= S1_color) +
  ggplot2::geom_linerange(data = S0_df, aes(x = 1:nrow(S0_df), ymax = 0, ymin = S0_prop), color= S0_color) +
  ggplot2::theme_classic() + xlab('Candidate SNPs') + ylab('Proportion of parental alleles in hybrids')

return(Propplot)
}

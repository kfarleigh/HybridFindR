
#' Analyze each locus to determine which individuals are homozygous and heterozygous.
#'
#' @param Data object produced by the PrepareData function.
#'
#' @return A list indicating which individuals are homozygous for the S1 and S0 alleles at each locus as well as the individuals that are heterozygous at each locus.
#' @export
#'
#' @examples
#' \dontrun{ Loc_stats <- Loci_stats(Data)}
Loci_stats <- function(Data) {
  Data <- as.data.frame(Data[,-c(2:3)])
  Loc <- 2:length(Data)
  Homozygous_S1 <- list()

  for (i in (2:ncol(Data))) {
    Homozygous_S1[[i]] <- data.frame(t(Data[which(Data[,i] == 2),1]))
  }
  names(Homozygous_S1) <- colnames(Data)
  Homozygous_S1 <- plyr::rbind.fill(Homozygous_S1)
  rownames(Homozygous_S1) <- colnames(Data)[2:length(Data)]
  Homozygous_S1 <- Homozygous_S1[rowSums(is.na(Homozygous_S1)) != length(Homozygous_S1),]
  cat(paste("Done determining homozygotes for the S1 population"), fill = 1)

  Heterozygous <- list()
  for (i in (2:ncol(Data))) {
    Heterozygous[[i]] <- data.frame(t(Data[which(Data[,i] == 1),1]))
  }
  names(Heterozygous) <- colnames(Data)
  Heterozygous <- plyr::rbind.fill(Heterozygous)
  rownames(Heterozygous) <- colnames(Data)[2:length(Data)]
  Heterozygous <- Heterozygous[rowSums(is.na(Heterozygous)) != length(Heterozygous),]
  cat(paste("Done determining heterozygous individuals"), fill = 1)

  Homozygous_S0 <- list()
  for (i in (2:ncol(Data))) {
    Homozygous_S0[[i]] <- data.frame(t(Data[which(Data[,i] == 0),1]))
  }
  names(Homozygous_S0) <- colnames(Data)
  Homozygous_S0 <- plyr::rbind.fill(Homozygous_S0)
  rownames(Homozygous_S0) <- colnames(Data)[2:length(Data)]
  Homozygous_S0 <- Homozygous_S0[rowSums(is.na(Homozygous_S0)) != length(Homozygous_S0),]
  cat(paste("Done determining homozygotes for the S0 population"),fill = 1)

  Locus_stats <- list(Homozygous_S1, Heterozygous,Homozygous_S0)

  return(Locus_stats)


}

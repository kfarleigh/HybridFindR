
#' Analyze the amount of missing data in your dataset
#'
#' @param Data Object produced by the PrepareData function
#'
#' @return A list containing the average missingness per individual and per locus as well as a barplot for each.
#' @export
#'
#' @examples
#' \dontrun{ Missing <- Missingness(Data)}
Missingness <- function(Data) {
  Inds <- Data[,1]
  Loci <- colnames(Data[,4:ncol(Data)])

  Missing_dat_ind <- round(rowSums(is.na(Data)/(ncol(Data[,4:length(Data)]))), 3)
  Missing_Ind <- cbind(Inds, Missing_dat_ind)
  colnames(Missing_Ind) <- c('Individual', 'Missingness')

  Missing_dat_loc <- round(colSums(is.na(Data[,4:length(Data)]))/nrow(Data),3)
  Missing_loc <- data.frame(cbind(Loci, Missing_dat_loc))
  colnames(Missing_loc) <- c('Loci', 'Missingness')

  graphics::barplot(Missing_Ind$Missingness, main = 'Individual Missingness', xlab = 'Individual', ylab = 'Missingness',
          names.arg = Missing_Ind$Individual, las = 2)
  Ind_plot <- grDevices::recordPlot()

  graphics::barplot(as.numeric(Missing_loc$Missingness), main = 'Locus Missingness', xlab = 'Locus', ylab = 'Missingness')
  Loc_plot <- grDevices::recordPlot()

  Missing <- list(Missing_Ind, Missing_loc, Ind_plot, Loc_plot )
  names(Missing) <- c('Individual Missingness', 'Locus Missingness', 'Individual Plot', 'Locus Plot')
  return(Missing)
}

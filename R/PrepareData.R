
#' Prepare a structure file (or similar data table) for differential introgression analysis using gghybrid.
#'
#' @param Data Character string defining the structure or data table to read in.
#' @param numprecol Numeric, the number of columns preceding the genetic data.
#' @param missingval Numeric or character, The value for indicating missing data.
#' @param onerow Numeric, (0 or 1). Whether or not there is a single row per individual. Currently, HybridFindR only supports 0.
#' @param numinds Numeric, the number of individuals in your data file.
#' @param S0.id Character, the label for the S0 parental population.
#' @param S1.id Character, the label for the S1 parental population.
#'
#' @return Returns a genotype table based on the number of copies of the S1 allele in each individual at each marker.
#' @export
#'
#' @examples
#' \dontrun{
#' Data <- PrepareData('mystructurefile.csv', numprecol = 2, missingval = 'NA',
#' onerow = 0, numinds = 73, S0.id = 'P', S1.id = 'K')}
PrepareData <- function(Data, numprecol, missingval, onerow, numinds, S0.id, S1.id){
  Data <- gghybrid::read.data(Data, nprecol = numprecol, MISSINGVAL = missingval, ONEROW = onerow, NUMINDS = numinds)
  Data <- gghybrid::data.prep(data = Data$data, loci = Data$loci, alleles = Data$alleles,
                              S0 = S0.id,
                              S1 = S1.id,
                              precols = Data$precols,
                              max.S.MAF = 0.1, return.genotype.table = T, return.locus.table = T)
  Geno_dat <- Data$geno.data
  return(Geno_dat)
}

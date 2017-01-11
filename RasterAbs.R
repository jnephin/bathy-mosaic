## Convert rasters to positive values only

# required packages
require(parallel)

# working directory
setwd('..')
#setwd("F:/Bathymetry_Multibeam/")

#--------------------------------------------------#


####----------------------------------------------------------------------####
## Functions

## Change raster values to absolute, assign NA value and export tif
rasterAbs <- function(rasterfile){
  # packages
  require(raster)
  require(rgdal)
  # load input raster
  inf <- paste0("Rasters/Original/",rasterfile)
  ras <- raster(inf)
  # output filename
  outf <- paste0("Rasters/Abs/",rasterfile)
  # Check for majority negative values
  sam <- sampleRandom(ras, 1000)
  qsam <- quantile(sam)
  # if the majority of sample values are negative, take the absolute values
  if(qsam[3] < 0){
    # Set values to absolute values
    aras <- raster::calc(ras, fun=abs, filename=outf, overwrite=TRUE, format = "GTiff", datatype = "FLT4S")
  } else {
    file.copy(inf, outf, overwrite = TRUE)
  }
}
####----------------------------------------------------------------------####


# list rasters
rlist <-list.files(path="Rasters/Original",pattern="*.tif$")


## create cluster object 
num_cores <- detectCores() - 1
cl <- makeCluster(num_cores)

# apply function across list
parSapply(cl, rlist, FUN=rasterAbs)

## stop cluster
stopCluster(cl)



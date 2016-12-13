## Created by Jessica Nephin
## Last edited 2016-11-25

# Masks input raster using clipped to coastline BoP layer
# Exports raster with appropriate data type to limit storage space

# required packages
require(parallel)
require(rgdal)

# working directory
setwd('..')



####----------------------------------------------------------------------####
## Function

## Masks env.layers and exports tiff with chosen datatype
maskfun <- function(rasterfile){
  # packages
  require(raster)
  require(rgdal)
  # load mosaiced raster
  ras <- raster(rasterfile)
  # output filename
  outf <- sub(".tif","_clip.tif", rasterfile)
  # name of region
  regname <- sub("[_].*","",rasterfile)
  regname <- sub(".*/","",regname)
  # set ful proj string
  proj4string(ras) <- proj
  # Mask - converts cells in raster stack to NA where cells are == NA in nccbop
  mras <- raster::mask(ras, reg[reg$Name == regname,], filename=outf, overwrite=TRUE, format = "GTiff", datatype = "FLT4S")
}
####----------------------------------------------------------------------####



####----------------------------------------------------------------------####
# Variables

#full bc albers proj
proj <- "+proj=aea +lat_1=50 +lat_2=58.5 +lat_0=45 +lon_0=-126 +x_0=1000000 +y_0=0 +datum=NAD83 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs"

# load 
reg <- readOGR(dsn = "C:/Users/NephinJ/Documents/Projects/Spatial/EEZ", layer = "Regions_alb")

# list mosaiced rasters
ras.list <- list.files(path="Mosaics",pattern=".tif$", full.names = TRUE)

####----------------------------------------------------------------------####




####----------------------------------------------------------------------####
# Run in parallel

## create cluster object 
num_cores <- detectCores() - 1
cl <- makeCluster(num_cores)

## make variables and packages available to cluster
clusterExport(cl, varlist=c("reg", "proj"))

# apply function over clusters for thiessen interp layers
parSapply(cl, ras.list, FUN=maskfun)

## stop cluster
stopCluster(cl)


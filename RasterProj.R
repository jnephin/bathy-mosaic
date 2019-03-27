## Add correct proj string to rasters 5m rasters

# required packages
require(parallel)

# working directory
setwd('..')

#--------------------------------------------------#



####----------------------------------------------------------------------####
## Function

## Assign raster CRS
rasterProj <- function(rasterfile){
  # packages
  require(raster)
  require(rgdal)
  # load input raster
  ras <- raster(paste0("Rasters/Resampled/",rasterfile))
  # output filename
  outf <- paste0("Rasters/Projected/",rasterfile)
  # Set the coordinate reference system
  matched <- grepl("proj=aea", proj4string( ras ) )
  if( !matched ){
    # project to albers if projection does match geoCRS
    ras <- projectRaster(ras, res=5, crs=CRS(proj), method="bilinear",
                         filename=outf, overwrite=TRUE, format = "GTiff", datatype = "FLT4S")
  } else {
    # Set the coordinate reference system if matches
    proj4string(ras) <- proj
    # write raster to file
    raster::writeRaster(ras,filename=outf, overwrite=TRUE, format = "GTiff", datatype = "FLT4S")
  }
}
####----------------------------------------------------------------------####


# list rasters
slist <-list.files(path="Rasters/Resampled/",pattern="*.tif$")
plist <-list.files(path="Rasters/Projected",pattern="*.tif$")
rlist <- slist[!slist %in% plist]

#full bc albers proj
proj <- "+proj=aea +lat_1=50 +lat_2=58.5 +lat_0=45 +lon_0=-126 +x_0=1000000 +y_0=0 +datum=NAD83 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs"


## create cluster object 
num_cores <- detectCores() - 1
cl <- makeCluster(num_cores)

## make variables and packages available to cluster
clusterExport(cl, varlist="proj")

# apply function across list
parSapply(cl, rlist, FUN=rasterProj)

## stop cluster
stopCluster(cl)




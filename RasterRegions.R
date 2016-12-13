## Reclass rasters to include only positive values

# required packages
require(sp)
require(rgdal)
require(parallel)

# working directory
setwd('..')

#--------------------------------------------------#

# load 
reg <- readOGR(dsn = "C:/Users/NephinJ/Documents/Projects/Spatial/EEZ", layer = "Regions_alb")

# names of each region layer
name <- names(table(reg$Name))

# list of all rasters to loop through
ras.list <- list.files(path="Rasters",pattern="proj.tif$", full.names = TRUE)

# Empty vector to place raster names within spatial extent of regions
rasterNames <- NULL


####----------------------------------------------------------------------####
## Functions

## Function that determines if rasters fall within a region 'Inner loop'
rasterFunc <- function(rasterfile, region){
  # packages
  require(raster)
  require(rgdal)
  require(sp)
  # load input raster
  ras <- raster(rasterfile)
  # get raster extents
  Rxmin <- extent(ras)[1]
  Rxmax <- extent(ras)[2]
  Rymin <- extent(ras)[3]
  Rymax <- extent(ras)[4]
  # get polygon extents
  Pxmin <- extent(reg[reg$Name == region,])[1]
  Pxmax <- extent(reg[reg$Name == region,])[2]
  Pymin <- extent(reg[reg$Name == region,])[3]
  Pymax <- extent(reg[reg$Name == region,])[4]
  # Does the raster overlap the polygon?
  if(Rxmin < Pxmax & Rxmax > Pxmin & Rymax > Pymin & Rymin < Pymax){
    rasterName <- sub("Rasters/","",rasterfile)
    return(rasterName)
  }
}

# Function that takes rasterFunc as an argument to loop through regions 'Outer loop'
RegionFun <- function(x, rasterfile, innerfun){
  rasterName <- NULL
  rasterNames <- NULL
  require(parallel)
  mclapply(rasterfile, innerfun, x)
}


####----------------------------------------------------------------------####
# Run functions in parallel

## create cluster object 
num_cores <- detectCores()
cl <- makeCluster(num_cores)

## make variables and packages available to cluster
clusterExport(cl, varlist=c("ras.list", "reg", "name"))

# apply outer and inner functions
dat <- parLapply(cl, name, RegionFun, ras.list, rasterFunc)

## stop cluster
stopCluster(cl)



####----------------------------------------------------------------------####
# Convert output and export
for(i in 1:length(name)){
  n <- name[i]
  tmp <- unlist(dat[[i]])
  tmp <- paste0("Rasters/",tmp)
  if(!is.null(tmp)){
    fileConn<-file(paste0("Regions/",n))
    writeLines(tmp, fileConn, sep = " ")
    close(fileConn)
  }
}







# Load packages
library(rgdal)
library(raster)
library(rgeos)

# set back
#setwd("E:/AbioticData/Bathymetry/Multibeam/Scripts")
setwd("..")

# Name of polygon shapefile 
shapefile_name <- "EEZ_alb"

# Load bounding polygon 
poly <- readOGR(dsn="Boundary", layer=shapefile_name) 

# Plot the shape
plot(poly)

# Create an empty raster
xmn	= extent(poly)[1] - 50000
xmx	= extent(poly)[2] + 50000
ymn	= extent(poly)[3] - 50000
ymx = extent(poly)[4] + 50000
grid <- raster(xmn=xmn,xmx=xmx,ymn=ymn,ymx=ymx)

# Make the grid have the same coordinate reference system (CRS) as the bouding polygon
proj4string(grid) <- proj4string(poly)

# Choose its resolution (in meters)
gridsize <- 200000

# Make the grid resolution
gridsize_km <- gridsize / 1000
res(grid) <- gridsize

# Transform the raster into a polygon
gridpolygon <- rasterToPolygons(grid)

# Export
writeOGR(gridpolygon, dsn="Boundary", layer="MultibeamGridRec", 
         driver="ESRI Shapefile", overwrite=TRUE)


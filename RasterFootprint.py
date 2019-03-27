'''*********************************************************************
Name: RasterDomain Example
Description: This script demonstrates how to use the
             Raster Domain tool to generate polygon footprints for all
             *.img rasters in a given workspace.
**********************************************************************'''

# Import system modules
import arcpy

# Set environment settings
arcpy.env.workspace = "E:/AbioticData/Bathymetry/Multibeam/Mosaics/Masked"

# Create the list of IMG rasters
rasterList = arcpy.ListRasters("*", "TIF")
# Verify there are rasters in the list
if rasterList:
    # Loop the process for each raster
    for raster in rasterList:
        # Set Local Variables
        outGeom = "POLYGON" # output geometry type
        # The [:-4] strips the .img from the raster name
        outPoly = "domain_" + raster[:-4] + ".shp"
        print("Creating footprint polygon for " + raster + ".")
        #Execute RasterDomain
        arcpy.RasterDomain_3d(raster, outPoly, outGeom)
    print("Finished.")
else:
    print("There are no TIF files in the " + env.workspace + " directory.")

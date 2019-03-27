# Export multibeam bathymetry from regional geodatabases to individual Geotiffs

# Import arcpy module
import os
import arcpy			# import the ESRI arcpy module
from arcpy import env	# import env from arcpy

# allow overwriting
arcpy.env.overwriteOutput = True

# move up one directory
os.chdir('..')

#--------------------------------------------------------------------------------#

# loop through region directories
areas = ["Rasters/MULTIBEAM.gdb",] #"HG","NCC","QCS","SoG","WCVI"
for a in areas:

	# geodatabases
	#geo = a+"_Albers_prj.gdb"

	# working env
	env.workspace = os.getcwd()+"/"+a
	#env.workspace = os.getcwd()+"/"+a+"/"+geo

	# get all rasters in geodatabase
	rasters = arcpy.ListRasters("*")

	# loop through rasters
	for  r in rasters:

		# variables
		inRaster=r
		outRaster=os.getcwd()+"/Rasters/Original/"+r+".tif"
		pt="32_BIT_FLOAT"
		f="TIFF"
		na=-3.4e+38

		# export rasters
		arcpy.CopyRaster_management (inRaster,outRaster, background_value=na, nodata_value=na, pixel_type=pt)

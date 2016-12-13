# Export multibeam bathymetry from regional geodatabases to individual Geotiffs

# Import arcpy module
import arcpy			# import the ESRI arcpy module
from arcpy import env	# import env from arcpy

arcpy.env.overwriteOutput = True # allow overwriting

#--------------------------------------------------------------------------------#

# loop through region directories
areas = ["HG","NCC","QCS","SoG","WCVI"] #
for a in areas:

	# geodatabases
	geo = a+"_Albers_prj.gdb"

	# working env	
	env.workspace = "F:/Bathymetry_Multibeam"+"/"+a+"/"+geo

	# get all rasters in geodatabase
	rasters = arcpy.ListRasters("*")
	
	# loop through rasters
	for  r in rasters:
		
		# variables
		inRaster=r
		outRaster="F:/Bathymetry_Multibeam"+"/Rasters/"+r+".tif"
		pt="32_BIT_FLOAT" 
		f="TIFF"

		# export rasters
		arcpy.CopyRaster_management (inRaster,outRaster,pixel_type=pt)



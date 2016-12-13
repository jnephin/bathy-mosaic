Methods for Mosaicing Bathymetry Multibeam Data
------------------------------------------------

1) Export multibeam bathymetry from regional geodatabases to individual Geotiff files to faciliate use in R
   * All rasters output into one directory 'Rasters'
   * Run GDB_RasterExport.py in ArcMap python window

2) Reclass rasters to convert negative to positive values (in some rasters depth was negative)
   * Rasters were assigned correct NA values and exported to the 'Rasters' directory (*abs.tif)
   * Run RasterAbs.R in RStudio

3) Resample all (*abs.tif) rasters to 5 x 5m grid
   * Run ResampleGdal.sh in cygwin
	
5) Add correct and full proj string to all 5m rasters
   * Save updated rasters as *proj.tif
   * Run RasterProj.R in RStudio
	
4) Determine which rasters fall within the spatial extents of bc region polygons (Regions_alb.shp)
   * Exports a list of raster names for each region to the 'Regions' directory
   * Run RasterRegions.R in RStudio

5) Mosaic rasters by region
   * Combines rasters into one mosaic for each region
   * Exports to 'Mosaics' directory
   * Run MosaicGdal.sh in cygwin
	
6) Mask rasters by bc region polygons (Regions_alb.shp)
   * Overwrites mosaic rasters
   * Run RasterMask.R in RStudio
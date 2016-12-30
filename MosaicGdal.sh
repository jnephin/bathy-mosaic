## Mosaic Multibeam bathymetry rasters by region
# Rasters to mosaic for each region listed in Regions directory (output of RasterRegions.R script)
# For all regions expect for offshore
# cd to parent directory


   
#  empty mosaic then add rasters with gdalwarp
for r in "CSoG" "QCStr" "NWCVI" "SWCVI" "CWCVI" "NHS" "DE" "EQCS" "JDF" "NSoG" "SHS" "SSoG" "WHG" "WQCS"; do 
   filename="Regions/$r"
   inf=$(<$filename)
   out="Mosaics/Original/${r}_5m.tif"
   na="-3.4e+38"
   C:/Anaconda/Scripts/gdal_merge.py -createonly -of "GTiff" -co "TILED=YES" -co "COMPRESS=LZW" -co "BIGTIFF=YES" -a_nodata $na -init $na $inf -o $out
    # add each file into mosaic with gdalwarp
    for f in $inf; do
        gdalwarp --config GDAL_CACHEMAX 500 -wm 2000 $f $out
    done
done



 #-------------------------------------------------------------------------------------------#
 # fast mosaic method --> don't have enough memory for this method for all areas
for r in  ; do 
    filename="Regions/$r"
    inf=$(<$filename)
    out="Mosaics/Original/${r}_5m.tif"
	na="-3.4e+38"
    C:/Anaconda/Scripts/gdal_merge.py -of "GTiff" -co "TILED=YES" -co "COMPRESS=LZW" -co "BIGTIFF=YES" -a_nodata $na -init $na $inf -o $out
done





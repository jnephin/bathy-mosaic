## build pyramids
# cd to parent directory

#  empty mosaic then add rasters with gdalwarp
for r in "CSoG" "QCStr" "NWCVI" "SWCVI" "CWCVI" "NHS" "DE" "EQCS" "JDF" "NSoG" "SHS" "SSoG" "WHG" "WQCS"; do 
   inf="Mosaics/${r}_5m_crop.tif"
   gdalinfo -stats $inf
   gdaladdo -r nearest $inf 2 4 8 16
done



inf="Mosaics/DE_5m_crop.tif"

# whip stats and set nodata
na="-3.3999999521444e+038"
C:/Anaconda/Scripts/gdal_edit.py -unsetstats $inf

# calculate stats
C:/Anaconda/Scripts/gdal_edit.py -stats -a_nodata $na $inf

# show
gdalinfo $inf

gdaladdo -r nearest $inf 2 4 8 16
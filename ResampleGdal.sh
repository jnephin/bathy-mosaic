## Resample bathymetry to 5 x 5m grid
# Only resample rasters that are not 5m resolution
# cd to Rasters directory

# ras=$(ls Abs/)
# for r in $ras; do
#    basext=${r##*/}
#    t="Abs/${basext}"
#    if grep -q "5m" <<< $r; then
#       f="Resampled/${basext}"
# 	  cp $t $f
#    else
#       out="Resampled/${basext%.tif}_r5m.tif"
#       gdalwarp --config GDAL_CACHEMAX 500 -wm 2000 -co TILED=YES -r bilinear -ot Float32 -tr 5 5 -overwrite $t $out
#    fi
# done



# resample new rasters
ras=$(ls Abs/MULTIBEAM*)
for r in $ras; do
   basext=${r##*/}
   t="Abs/${basext}"
   if grep -q "5m" <<< $r; then
      f="Resampled/${basext}"
	  cp $t $f
   else
      out="Resampled/${basext%.tif}_r5m.tif"
      gdalwarp --config GDAL_CACHEMAX 500 -wm 2000 -co TILED=YES -r bilinear -ot Float32 -tr 5 5 -overwrite $t $out
   fi
done

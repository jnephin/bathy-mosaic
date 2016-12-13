## Resample bathymetry to 5 x 5m grid
# Only resample rasters that are not 5m resolution
# cd to Rasters directory

ras=$(ls *_abs.tif)
   for r in $ras; do
   if grep -q "5m" <<< $r; then
      rename abs.tif abs_5m.tif $r
   else
      out="${r%.tif}_5m.tif"
      gdalwarp --config GDAL_CACHEMAX 3000 -wm 2000 -co TILED=YES -r cubicspline -ot Float32 -tr 5 5 -overwrite $r $out
   fi
done

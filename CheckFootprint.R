## Check coverage agaist chs and nrcan footprint

# required packages
require(rgdal)

# working directory
setwd('..')

#--------------------------------------------------#

# read files
nrcansp <- readOGR(dsn="Footprints/NRCanFootprint_22Nov17",layer="MultibeamFootprints")
nrcan <- nrcansp@data["CHS_NAME"]
nrcan$sor_id <- sub(".*_","",nrcan$CHS_NAME)

chssp <- readOGR(dsn="Footprints/CHSFootprint_11Oct2017",layer="CHSMultibeamFootprint")
chs <- chssp@data[c("OBJNAM","sor_id")]
chs$sor_id <- sub(".*_","",chs$sor_id)

# read list of our multibeam files
mb <- data.frame(list.files(path="Rasters/Original",pattern="*.tif$"))
colnames(mb)<- "filename"
mb$sor_id <- substr(mb$filename, 2, 8)


# dims
dim(nrcan)
dim(chs)
dim(mb)

# which nrcan surveys do we need?
ndat <- merge(nrcan, mb, by="sor_id", all.x=T)
ndat <- ndat[is.na(ndat$filename),]
write.csv(ndat$CHS_NAME, 
          file="Footprints/MissingSurveys_fromNRCan.csv",
          row.names = F)

# update footprint
head(nrcansp@data)
nrcansp@data$need <- "n"
nrcansp@data$need[(nrcansp@data$CHS_NAME %in% ndat$CHS_NAME)] <- "y"
nrcansp <- nrcansp[nrcansp@data$need == "y",]
writeOGR(nrcansp, dsn="Footprints/NRCanFootprint_22Nov17",
        layer="NRCanFootprints_need", driver="ESRI Shapefile", overwrite_layer = T)

# which surveys can we give to nrcan?
mdat <- merge(mb, nrcan, by="sor_id", all.x=T)
mdat <- mdat[is.na(mdat$CHS_NAME),]
sfiles <- file.path(getwd(),"Rasters/Original",unique(mdat$filename))
dfiles <- file.path(getwd(),"ForNRCan",unique(mdat$filename))
file.copy(from=sfiles, to=dfiles)

# rename files back to original
rfiles <- list.files("ForNRCan")
year <- substr(rfiles, 10,13)
code <- substr(rfiles, 2,8)
name <- substr(rfiles, 15,100)
name <- sub("_*_ra_alb.tif","",name)
rem <- paste(paste0("_",sub(".*_","",name)), collapse="|")
name <- sub(rem,"",name)
fname <- paste0(year,name,"_",code,".tif")
file.rename(from=dfiles, to=file.path(getwd(),"ForNRCan",fname))
file.rename(from=file.path(getwd(),"ForNRCan",oldfname), 
            to=file.path(getwd(),"ForNRCan",fname))


# which surveys do we need from CHS?
# merge lists of surveys
sl <- merge(chs,nrcan, by="sor_id", all.x=T)

# get surveys where there is no nrcan match
sl <- sl[is.na(sl$CHS_NAME),]

# get surveys where there is no match with our holdings
sm <- merge(sl,mb, by="sor_id", all.x=T)
sm <- sm[is.na(sm$filename),]
sur <- as.character(unique(sm$OBJNAM))
write.csv(sur, 
          file="Footprints/MissingSurveys_fromCHS.csv",
          row.names = F)

# update footprint
head(chssp@data)
chssp@data$need <- "n"
chssp@data$need[(chssp@data$OBJNAM %in% sur)] <- "y"
chssp <- chssp[chssp@data$need == "y",]
writeOGR(chssp, dsn="Footprints/CHSFootprint_11Oct2017",
         layer="CHSFootprints_need", driver="ESRI Shapefile", overwrite_layer = T)


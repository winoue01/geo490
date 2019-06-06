library(ncdf4)
ncpath <- "/Users/wauno/Documents/GEO 490/nc_files/"
ncname <- "us_fires"
ncfname <- paste(ncpath, ncname, ".nc", sep="")

# open a netCDF file
ncin <- nc_open(ncfname)
print(ncin)


# get longitude and latitude
lon <- ncvar_get(ncin,"lon")
nlon <- dim(lon)
head(lon)
lat <- ncvar_get(ncin,"lat")
nlat <- dim(lat)
head(lat)

print(c(nlon,nlat))

#get fire data
dname <- "fpafod_counts"
dname2 <- "fpafod_mean_area"
fire_array <- ncvar_get(ncin, dname)
fire_area_array <- ncvar_get(ncin, dname2)
dlname <- ncatt_get(ncin, dname, "long_name")
dunits <- ncatt_get(ncin, dname, "units")
fillvalue <- ncatt_get(ncin,dname,"_FillValue")
dim(fire_array)

# get global attributes
title <- ncatt_get(ncin,0,"title")
institution <- ncatt_get(ncin,0,"institution")
datasource <- ncatt_get(ncin,0,"datasource")
references <- ncatt_get(ncin,0,"references")
history <- ncatt_get(ncin,0,"history")
Conventions <- ncatt_get(ncin,0,"Conventions")

ls()

# load some packages
library(chron)
library(lattice)
library(RColorBrewer)

# replace netCDF fill values with NA's
fire_array[fire_array==fillvalue$value] <- NA
length(na.omit(as.vector(fire_array[,1])))


options(max.print=1000000)
print(fire_area_array)


grid <- expand.grid(lon=lon, lat=lat)
levelplot(fire_area_array ~ lon * lat, data=grid, cuts=5, pretty=T, 
          col.regions=(rev(brewer.pal(10,"RdBu"))))
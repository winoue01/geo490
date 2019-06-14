#Introduction#

The wildfire is one of the major concerns in the States. It not only threatens people's lives but also impacts the ecosystem of the area. To raise the awareness of the dangers of wildfires, for this project, data analysis was conducted with R.


#1. Download the Data
The data is retrieved from the class file using NetCDF.NetCDF is a widely used format for exchanging or distributing climate data, and has also been adopted in other fields. Wildfire is not climate data; however, the data contains the spatial data such as location and other information regarding damages caused. The file downloaded is called nc_files from GEO490 server contains following:

* TraCE_tas_llsy_monlenadj_seas_anm_PI_hw30.nc
* TraCE_tas_llsy_monlenadj_seas_locanm_hw30.nc
* treecov.nc
* tsi_v02r01_monthly_s188201_e188212_c20170717.nc
* us_fires.nc

#2.1 Open File#
To open the ncfiles on RStudio, the package **ncdf4** needs to be installed. The following code does not contain the installation part because the installation is required only once.  

    library(ncdf4)
	ncpath <- "/Users/wauno/Documents/GEO 490/nc_files/"
	ncname <- "us_fires"
	ncfname <- paste(ncpath, ncname, ".nc", sep="")

	# open a netCDF file
	ncin <- nc_open(ncfname)
	print(ncin)

#2.2 Get the longitude and latitude
    # get longitude and latitude
	lon <- ncvar_get(ncin,"lon")
	nlon <- dim(lon)
	head(lon)
	lat <- ncvar_get(ncin,"lat")
	nlat <- dim(lat)
	head(lat)
	print(c(nlon,nlat))
#2.3 Get Fire Data
	#get fire data
	dname <- "fpafod_counts"
	dname2 <- "fpafod_mean_area"
	fire_array <- ncvar_get(ncin, dname)
	fire_area_array <- ncvar_get(ncin, dname2)
	dlname <- ncatt_get(ncin, dname, "long_name")
	dunits <- ncatt_get(ncin, dname, "units")
	fillvalue <- ncatt_get(ncin,dname,"_FillValue")
	dim(fire_array)
#2.4 Get global attributes
	# get global attributes
	title <- ncatt_get(ncin,0,"title")
	institution <- ncatt_get(ncin,0,"institution")
	datasource <- ncatt_get(ncin,0,"datasource")
	references <- ncatt_get(ncin,0,"references")
	history <- ncatt_get(ncin,0,"history")
	Conventions <- ncatt_get(ncin,0,"Conventions")
#2.5 Visualization
To visualize the data, some packages need to be installed beforehand. For this project, packages **RColorBrewer** was installed, for instance.

	fire_array[fire_array==fillvalue$value] <- NA
	length(na.omit(as.vector(fire_array[,1])))


	grid <- expand.grid(lon=lon, lat=lat)
	cutpts <- c(0,50,100,150,200,250,300,350,400,500)
	levelplot(fire_area_array ~ lon * lat, data=grid, at=cutpts, cuts=11, pretty=T, 
          col.regions=(rev(brewer.pal(10,"RdBu"))))

![](https://i.imgur.com/GUdgdum.png)

It is a rough image since base map (U.S. shapefile is not used, but we can still observe that which area has higher occurrence of wildfires.)

![](https://i.imgur.com/QYjNChp.png)
This is for the the average area.



    
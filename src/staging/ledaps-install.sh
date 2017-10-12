#!/bin/bash

# Script for downloading the necessary Landsat data
# The needed data is surface reflectance and vegetation indices. There are two ways of obtaining it:
# 1) Download Level 1 data from Google Cloud. This is a really fast download, but you get TOA reflectances.
#    This then needs to be processed by LEDAPS to get surface reflectance and vegetation indices.
#    It is more work (LEDAPS is of medium difficulty to install), although it is completely reproducible.
# 2) Order data processing from USGS using the ESPA API. This is easier in that the processing is done
#    by USGS so we don't need to bother with it, but it is less reproducible and it requires waiting for
#    USGS to actually process the data.

# The second approach has a web API, but at the moment the transition from Pre-Collection to Collection 1 makes it
# impossible to download anything. The main way to "order" processing and download is through the web UI by dropping
# the "products-*.txt" file into the upload box.

# The first approach would require LEDAPS. On CentOS 7:

# Download LEDAPS
# Install dependencies
sudo yum install hdf hdf-devel libtiff-devel libgeotiff-devel jbigkit-devel libidn-devel
wget https://support.hdfgroup.org/ftp/HDF/releases/HDF4.2.12/src/hdf-4.2.12.tar.gz
tar xvf hdf-4.2.12.tar.gz
pushd hdf-4.2.12
./configure --prefix=`readlink -f ~/.local/` --disable-fortran --enable-shared
make -j31
make check
make install
make clean
popd
sudo ldconfig
rm hdf-4.2.12.tar.gz
wget ftp://edhs1.gsfc.nasa.gov/edhs/hdfeos/latest_release/HDF-EOS2.19v1.00.tar.Z
tar xvf HDF-EOS2.19v1.00.tar.Z
pushd hdfeos
./configure --prefix=`readlink -f ~/.local/` LDFLAGS="-L`readlink -f ~/.local/lib` -Wl,--rpath,`readlink -f ~/.local/`" CPPFLAGS="-I/usr/include/hdf" --enable-install-include
make -j30
make check
make install
make clean
popd
sudo ldconfig
rm HDF-EOS2.19v1.00.tar.Z
wget http://edclpdsftp.cr.usgs.gov/downloads/auxiliaries/land_water_poly/land_no_buf.ply.gz
gunzip land_no_buf.ply.gz
mkdir ~/.local/static-data
mv land_no_buf.ply ~/.local/static-data
# Set environment variables
export HDFEOS_GCTPINC=`readlink -f ~/.local/include`
export HDFEOS_GCTPLIB=`readlink -f ~/.local/lib`
export TIFFINC="/usr/include"
export TIFFLIB="/usr/lib64"
export GEOTIFF_INC="/usr/include/libgeotiff"
export GEOTIFF_LIB="/usr/lib64"
export HDFINC="/usr/include/hdf"
export HDFLIB=`readlink -f ~/.local/lib`
export HDF5INC="/usr/include"
export HDF5LIB="/usr/lib64"
export HDFEOS_INC=`readlink -f ~/.local/include`
export HDFEOS_LIB=`readlink -f ~/.local/lib`
export NCDF4INC="/usr/include"
export NCDF4LIB="/usr/lib64"
export JPEGINC="/usr/include"
export JPEGLIB="/usr/lib64"
export XML2INC="/usr/include/libxml2"
export XML2LIB="/usr/lib64"
export JBIGINC="/usr/include"
export JBIGLIB="/usr/lib64"
export ZLIBINC="/usr/include"
export ZLIBLIB="/usr/lib64"  
export SZIPINC="/usr/include"
export SZIPLIB="/usr/lib64"
export CURLINC="/usr/include"
export CURLLIB="/usr/lib64"
export LZMAINC="/usr/include"
export LZMALIB="/usr/lib64"
export IDNINC="/usr/include"
export IDNLIB="/usr/lib64"
export ESPAINC=`readlink -f ~/.local/include`
export ESPALIB=`readlink -f ~/.local/lib`
export PREFIX=`readlink -f ~/.local/`
export ESPA_LAND_MASS_POLYGON=$PREFIX/static_data/land_no_buf.ply

# First download the LEDAPS internal format tools
git clone --branch product_formatter_v1.13.0 --depth 1 https://github.com/USGS-EROS/espa-product-formatter.git
pushd espa-product-formatter/raw_binary/
make -j30
make install
make clean
popd
sudo ldconfig

# Now LEDAPS itself
git clone --branch ledaps_v3.2.0 --depth 1 https://github.com/USGS-EROS/espa-surface-reflectance.git
pushd espa-surface-reflectance/ledaps/
make -j30
make install
make -j30 all-ledaps-aux
make install-ledaps-aux
make clean clean-ledaps-aux
popd
sudo ldconfig

# Get auxiliary data on atmosphere conditions
wget http://edclpdsftp.cr.usgs.gov/downloads/auxiliaries/ledaps_auxiliary/ledaps_aux.1978-2017.tar.gz
tar xvf ledaps_aux.1978-2017.tar.gz
export LEDAPS_AUX_DIR=`readlink -f .`"/ledaps_aux.1978-2017"

This directory should contain input data. It is large and binary and thus not included. Instead, a list of files that should be put here is included. You should download the files and put them here yourself (for example, by placing an order on the ESPA system).

The lists of tiles are in the schema "type-campaign-satellite.txt", and generated from the full archive of imagery in the tiles listed in "tiles.txt" using the USGS metadata service.
    Type: "products" type lists the actual products that can be ordered on ESPA; "rejects" type lists tiles that existed at some point but cannot be ordered from ESPA. The reason why is listed.
    Campaign: One of the three study areas.
    Satellite: The satellite whose sensors captured the imagery.
The products files can be uploaded to ESPA directly.

For Sentinel-2 imagery, use the package `sentinelsat` with the `guyana2017.geojson` reference AOI file to get a list of files and download them.

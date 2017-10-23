This directory contains reference data on the location of selectively logged trees. This data is provided by Wageningen University & Research, Laboratory of Geo-information Science and Remote Sensing, as part of the WUR Terrestrial Laser Scanning Reserch project. Most of this data is derived from data available on the WUR website:
http://www.wur.nl/en/Expertise-Services/Chair-groups/Environmental-Sciences/Laboratory-of-Geo-information-Science-and-Remote-Sensing/Research/Sensing-measuring/WUR-terrestrial-Laser-Scanning-Research.htm

As such, the data in LoggedTrees.csv is not currently covered by the CC-BY-SA license and is used under permission from WUR.

Columns correspond to:
Campaign: Name of the dataset the point originates from.
ID: Point or plot ID in the original dataset.
Longitude, Latitude: Coordinates in WGS84.
PreLoggingDate, PostLoggingDate: The day on which the selectively logged tree is known to have been standing and is known to have been cut down, respectively. The selective logging event happened in between the two dates. In the datasets where this is not specified explicitly, PreLoggingDate is set to the day of the first GPS measurement, PostLoggingDate is set to the day of the last GPS measurement.

Note: Guyana2014 T06 has an issue where the PreLoggingDate is after the PostLoggingDate. The dates have been reversed here to keep consistency.

Note: Peru dataset included a database and GPS measurements. Database entries have a latitude offset of on average +0.005 degrees, which is a significant amount. As such, both entries have been kept, with the same dates; but only the GPS points are reliable. The database points can be used for validation and such.

Note: Peru dataset consists of individual points for each plot, as well as logging gaps that already existed by the time of the lidar scanning campaign. The gaps therefore do not have a pre-logging date.

Note: Peru dataset GPS coordinates were calculated by getting the centroid of all points in the same scanning session, and then getting the centroid of all scanning sessions' centroid plus the location of the associated gap (if any).


Projections.csv contains information about the projection of Landsat imagery in each campaign.


The .geojson file is a polygon convex hulls of the Guyana 2017 points as mentioned above, generated with QGIS. It is for use with the Sentinel-2 image download Python scripts.

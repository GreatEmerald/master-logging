This directory contains reference data on the location of selectively logged trees. This data is provided by Wageningen University & Research, Laboratory of Geo-information Science and Remote Sensing, as part of the WUR Terrestrial Laser Scanning Reserch project. Most of this data is derived from data available on the WUR website:
http://www.wur.nl/en/Expertise-Services/Chair-groups/Environmental-Sciences/Laboratory-of-Geo-information-Science-and-Remote-Sensing/Research/Sensing-measuring/WUR-terrestrial-Laser-Scanning-Research.htm

As such, this data is not currently covered by the CC-BY-SA license and is used under permission from WUR.

Columns correspond to:
Campaign: Name of the dataset the point originates from.
ID: Point or plot ID in the original dataset.
Longitude, Latitude: Coordinates in WGS84.
PreLoggingDate, PostLoggingDate: The day on which the selectively logged tree is known to have been standing and is known to have been cut down, respectively. The selective logging event happened in between the two dates. In the datasets where this is not specified explicitly, PreLoggingDate is set to the day of the first GPS measurement, PostLoggingDate is set to the day of the last GPS measurement.

Note: Guyana2014 T06 has an issue where the PreLoggingDate is after the PostLoggingDate. The dates have been reversed in this dataset.

Note: Peru dataset included a database and GPS measurements. Database entries have a latitude offset of on average +0.005 degrees, which is a significant amount. As such, both entries have been kept, with the same dates; only one of the entries will actually contain gaps.

Note: Peru dataset consists of individual points for each plot, as well as canopy gaps, but they do not always match. Gaps outside plots are listed separately. If both crown and base gaps are listed, crown position gets twice the weight.

Note: Peru dataset GPS coordinates were calculated by getting the centroid of all points in the same scanning session, and then getting the centroid of all scanning sessions' centroid plus the location of the associated gap (if any).

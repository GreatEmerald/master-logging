# master-logging

Master Geo-Information Science minor thesis "Evaluating the potential of Sentinel-2 and Landsat image time series for detecting selective logging in the Amazon".

The work is organised into three main directories: `data` for input and output datasets (placeholders), `src` for source code and `thesis` for LaTeX documents. The `master` branch should only contain text and reasonably-sized images, there may be other branches for binary data.

The working directory is always `src` (not a subdirectory) and an example of the processing chain is in `src/staging/process-data.sh`. Due to the large volume of data, you will most likely want to change the locations of your input/output files, how many are processed at once, etc., which is why there is not just one canonical way of processing the data.

For more in-depth descriptions of particular directories, see `readme.txt` files in them.

#!/bin/bash
# Small utility to extract download Landsat product URLs from ESPA download page, and then download.
# There is an API for this, but it gives JSON, so parsing it is hard.
# There is a downloader for this, but it is extremely slow. wget downloads a tile in 10 seconds.
# Input: HTML source code of the download webpage, perhaps from cURL
# Output: a urls.txt file and the files themselves.

# Could be combined through pipes, but useful to check the output first
grep -oP 'https://.*.tar.gz(?=">Download)' $@ > urls.txt
wget --no-clobber -i urls.txt

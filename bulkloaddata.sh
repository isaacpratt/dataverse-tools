#!/bin/bash

# This script uploads multiple datasets into dataverse using the Native API. The following directory structure is used:
# datasets/
# ├── dataset1
# │   ├── files.zip
# │   └── metadata.json
# ├── dataset2
# |   ├── files.zip
# |   └── metadata.json
# └── ...
# ----------------------------------------------------------------------

# Your API key
API_TOKEN=""

# The dataverse instance you are uploading to
HOSTNAME="" # e.g. https://demodv.scholarsportal.info

# The dataverse you are uploading the datasets to. Represented as the last part of your dataverse url, e.g. for a url of https://demodv.scholarsportal.info/dataverse/algoma, the alias is algoma
DATAVERSE_ALIAS=""

# the local directory which contains all of your datasets, one dataset per folder. Each directory must contain the metadata.json file and a files.zip file which contains all of the files for the dataset.
DIRECTORY=""

# time to wait between uploads in seconds - helpful if you're loading a large amount of data and/or are having server load issues
WAIT=0

# Loop through your directory, creating a new dataset for each folder and upload a zip of the files.

for i in $DIRECTORY/* ; do
    # wait between uploads to reduce to load on the server
    sleep $WAIT

    # Create the dataset and capture the output
    echo Creating the dataset...
    OUTPUT=$(curl -X POST -H "Content-type:application/json" -d @$i/metadata.json "$HOSTNAME/api/dataverses/$DATAVERSE_ALIAS/datasets/?key=$API_TOKEN")

    DOI=$(echo $OUTPUT | grep -o 'doi:[0-9*.[0-9]*\/[0-9A-Z]*\/[0-9A-Z]*')
    echo $DOI

    # TODO make sure the file isn't too large to be loaded into the DV instance
    # Check the size of files.zip
    filesize=$(du -k $i/files.zip)
    echo The filesize is $filesize KB

    # Add files to a dataset with a zip file
    echo Uploading files...
    curl -u $API_TOKEN: --data-binary @$i/files.zip -H "Content-Disposition: filename=files.zip" -H "Content-Type: application/zip" -H "Packaging: http://purl.org/net/sword/package/SimpleZip" $HOSTNAME/dvn/api/data-deposit/v1.1/swordv2/edit-media/study/$DOI
done

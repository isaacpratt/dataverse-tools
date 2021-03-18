#!/bin/bash

# A small script for bulk creating dataverses
# using the API. For API documentation see:
# https://guides.dataverse.org/en/latest/api/native-api.html#create-a-dataverse

# Your API key
API_TOKEN=""

# The dataverse instance you are uploading to, e.g. https://demodv.scholarsportal.info
SERVER=""

# The parent dataverse to create the sub-dataverses in, e.g. "root"
DV_ALIAS=""

# Location of the JSON files that represent each dataverse
JSON_DIR=""

for jsonFile in $JSON_DIR/* ;
do
    printf "Importing file: $jsonFile\n"
    curl -H "X-Dataverse-key: $API_TOKEN" -X POST "$SERVER/api/dataverses/$DV_ALIAS" --upload-file $jsonFile
    printf "\n"
done

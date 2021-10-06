#!/bin/sh
# -----------------------------------------------------------
# Generate a list of sizes of Dataverse collections as a text file. A list of collections is imported from "dv-list.sh".
#
# Dataverse API documentation: https://guides.dataverse.org/en/latest/api/native-api.html#report-the-data-file-size-of-a-dataverse
#
# usage:
# ./dv-sizes.sh
#
# requires:
# dv-list.sh
# -----------------------------------------------------------

# Read list of dataverses to check
. ./dv-list.sh || exit 1

API_TOKEN=''
DV_URL='' # Your dataverse installation URL, e.g. https://dataverse.scholarsportal.info
FILENAME='dataverse-sizes-'$(date +'%Y%m%d')'.txt'

echo $FILENAME
number_of_dv=${#dvName[@]}

echo "Sizes for published and unpublished data in institutional dataverses" >> $FILENAME
echo "Date run: $(date +'%Y%m%d')" >> $FILENAME
echo "URL: $DV_URL" >> $FILENAME
echo "\n" >> $FILENAME

for ((i=0; i<$number_of_dv; i++)); do
	current_name=${dvName[$i]}
	current_alias=${dvAlias[$i]}

    echo "$current_name: " >> $FILENAME

    curl -H "X-Dataverse-key: $API_TOKEN" "$DV_URL/api/dataverses/$current_alias/storagesize" | jq -r '.data.message | ltrimstr("Total size of the files stored in this dataverse: ") | rtrimstr(" bytes") | gsub(",";"")' | numfmt --to=iec --format='%.3f' >> $FILENAME

    echo "\n" >> $FILENAME
done

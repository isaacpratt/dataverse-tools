#!/bin/bash
# A small script for bulk uploading users to Dataverse
# using the API. For API documentation see:
# http://guides.dataverse.org/en/latest/api/native-api.html#builtin-users

host="" # Dataverse host URL
temppass="" # Temporary password to set for users - could update this script in the future to randomly generate a password per user
builtinkey="" # Built in users key - see the API guide to generate
jsondir="" # Directory where the json files are stored

for i in $jsondir/*;
do
    curl -d @"$i" -H "Content-type:application/json" "$host/api/builtin-users?password=$temppass&key=$builtinkey"
done

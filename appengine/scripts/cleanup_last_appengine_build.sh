VERSIONS_COUNT=0
SERVICE_NAME=default
VERSION_MAX=2

# check for the total number of build in the app engine if it is over a thredshold, for example : 200

for ID in $(gcloud app versions list --sort-by=createTime --format="value(VERSION.ID)")
do
   ((VERSIONS_COUNT=VERSIONS_COUNT+1))
done


# iterate what service is required  to be built.
# grap the most out-dated version id of that specific service and delete it
if [[ $VERSIONS_COUNT -ge $VERSION_MAX ]] 
then 
	echo "Deleting the last verion which its count is 200....!!" 
    OUTDATED_VERSION_ID=$(gcloud app versions list --sort-by=createTime --limit 1 --format='value(VERSION.ID)' --service=$SERVICE_NAME)
	gcloud app versions delete  $OUTDATED_VERSION_ID --quiet
fi



# versions=$(gcloud app versions list \
#   --service $SERVICE_NAME \
#   --sort-by '~VERSION.ID' \
#   --format 'value(VERSION.ID)' | sed 1,${VERSION_MAX}d)
# for version in $versions; do
#   gcloud app versions delete "$version" \
#     --service $SERVICE_NAME \
#     --quiet
# done
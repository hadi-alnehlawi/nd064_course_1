# set env variables
VERSIONS_COUNT=0 #counter
SERVICE_NAME=chr-service # service_to_be_built
VERSION_MAX=2 #threshold

# check for the total number of build in the app engine if it is over a threshold, for example : 200
for ID in $(gcloud app versions list --sort-by=createTime --format="value(VERSION.ID)")
do
   ((VERSIONS_COUNT=VERSIONS_COUNT+1))
done


# iterate what service is required  to be built.
# get the most out-dated version id of that specific service and delete it
if [[ $VERSIONS_COUNT -ge $VERSION_MAX ]] 
then 
	echo "Deleting the last verion of the service VERSIONS_COUNT!!" 
    OUTDATED_VERSION_ID=$(gcloud app versions list --sort-by=createTime --limit 1 --format='value(VERSION.ID)' --service=xx)
	gcloud app versions delete  $OUTDATED_VERSION_ID --quiet
fi


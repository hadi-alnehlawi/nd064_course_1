# set env variables
VERSIONS_COUNT=0 #counter
SERVICE_NAME=xx # service_to_be_built
VERSION_MAX=2 #threshold
SERVICE_IS_EXISTED=false # boolean_value


# check if the serivce is existexd
for service in gcloud app services list --format="value(SERVICE)"
do 
    if [[ service ==  $SERVICE_NAME ]]
    then
        SERVICE_IS_EXISTED=true
    fi 
done 

if [[ $SERVICE_IS_EXISTED == true ]]
then
    # check for the total number of build in the app engine if it is over a threshold, for example : 200
    for ID in $(gcloud app versions list --sort-by=createTime --format="value(VERSION.ID)")
    do
    ((VERSIONS_COUNT=VERSIONS_COUNT+1))
    done

    # get the most out-dated version id of that specific service and delete it
    if [[ $VERSIONS_COUNT -ge $VERSION_MAX ]] 
    then 
        # iterate what service is required  to be built.
        echo "Deleting the last verion of the service VERSIONS_COUNT!!" 
        OUTDATED_VERSION_ID=$(gcloud app versions list --sort-by=createTime --limit 1 --format='value(VERSION.ID)' --service=SERVICE_NAME)
        # gcloud app versions delete  $OUTDATED_VERSION_ID --quiet
    fi
else
    echo "the service SERVICE_NAME is not existed and nothing to be cleaned-up"
fi


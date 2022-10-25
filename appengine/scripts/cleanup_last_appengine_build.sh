VERSIONS_COUNT=0
SERVICE_NAME=APPENGINE_SERVICE_NAME
for ID in $(gcloud app versions list --sort-by=createTime --format="value(VERSION.ID) --service=$SERVICE_NAME")
do
   ((VERSIONS_COUNT=VERSIONS_COUNT+1))
done

echo $VERSIONS_COUNT


if [[ $VERSIONS_COUNT == 6 ]] 
then 
	echo "Deleting the last verion which its count is 200....!!" 
	gcloud app versions delete $(gcloud app versions list --sort-by=createTime --limit 1 --format='value(VERSION.ID)' --service=$SERVICE_NAME) --quiet
fi

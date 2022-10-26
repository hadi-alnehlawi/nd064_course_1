VERSIONS_COUNT=0
SERVICE_NAME=default
VERSION_MAX=2

for ID in $(gcloud app versions list --sort-by=createTime --format="value(VERSION.ID)")
do
   ((VERSIONS_COUNT=VERSIONS_COUNT+1))
done

echo $VERSIONS_COUNT


if [[ $VERSIONS_COUNT == $VERSION_MAX ]] 
then 
	echo "Deleting the last verion which its count is 200....!!" 
	gcloud app versions delete $(gcloud app versions list --sort-by=createTime --limit 1 --format='value(VERSION.ID)' --service=$SERVICE_NAME) --quiet
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
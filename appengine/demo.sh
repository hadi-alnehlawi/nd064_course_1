
VERSIONS_COUNT=0
for ID in $(gcloud app versions list --sort-by=createTime --format="value(VERSION.ID)")
do
   ((VERSIONS_COUNT=VERSIONS_COUNT+1))
done

echo $VERSIONS_COUNT


if [[ $VERSIONS_COUNT == 4 ]] 
then 
	echo "Deleting the last verion which its count is 4....!!" 
	gcloud app versions delete $(gcloud app versions list --sort-by=createTime --limit 1 --format='value(VERSION.ID)') --quiet
fi

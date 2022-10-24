
COUNT=0
for ID in $(gcloud app versions list --sort-by=createTime --format="value(VERSION.ID)")
do
   ((COUNT=COUNT+1))
done

echo $COUNT
# export VERSIONS_COUNT=$(gcloud app versions list --sort-by=createTime --format=json | jq ' . | length');
# echo $VERSIONS_COUNT;
# if [[ $VERSIONS_COUNT == 210 ]] 
# then 
# 	echo "deleting the last verion which its count is 210...." 
# 	gcloud app versions delete $(gcloud app versions list --sort-by=createTime --limit 1 --format='value(VERSION.ID)') --quiet
# fi

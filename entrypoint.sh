#!/bin/bash
echo "$S3_BUCKET_SOURCE"
echo "$S3_BUCKET_TARGET"
echo "$S3_OBJ"
SUFFIX=".gz"
FILE_NAME_REMOVE_SUFFIX=${S3_OBJ/%$SUFFIX}
DATE=$(date +"%F-%H")
echo "===Start mask db==="
aws s3 cp s3://"$S3_BUCKET_SOURCE"/"$S3_OBJ" .
echo "===Start Gunzip and MaskDb==="
echo $FILE_NAME_REMOVE_SUFFIX
gunzip $S3_OBJ
cat $FILE_NAME_REMOVE_SUFFIX | anonymize-mysqldump --config config.json 2> /var/log/errors.log | gzip > $FILE_NAME_REMOVE_SUFFIX-masked-$DATE.sql.gz
echo "===Finish MaskDB==="
echo "===Upload File To s3==="
aws s3 cp $FILE_NAME_REMOVE_SUFFIX-masked-$DATE.sql.gz s3://"$S3_BUCKET_TARGET"/
echo "===End==="

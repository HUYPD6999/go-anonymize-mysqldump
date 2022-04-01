#!/bin/bash
SUFFIX=".gz"
FILE_NAME_REMOVE_SUFFIX=${FILE_NAME/%$SUFFIX}
DATE=$(date +"%F-%H")
echo "===Start mask db==="
aws s3 cp s3://"$s3"/"$FILE_NAME" .
echo "===Start Gunzip and MaskDb==="
echo $FILE_NAME_REMOVE_SUFFIX
gunzip $FILE_NAME
cat $FILE_NAME_REMOVE_SUFFIX | anonymize-mysqldump --config config.json 2> /var/log/errors.log | gzip > $FILE_NAME_REMOVE_SUFFIX-masked-$DATE.sql.gz
echo "===End==="
aws s3 cp $FILE_NAME_REMOVE_SUFFIX-masked-$DATE.sql.gz s3://"$s3"/

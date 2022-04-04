#!/bin/bash
echo "$S3_BUCKET_SOURCE"
echo "$S3_BUCKET_TARGET"
echo "$S3_OBJ"
GZIP_SUFFIX=".gz"
SQL_SUFFIX=".sql"
FILE_NAME_REMOVE_GZIP_SUFFIX=${S3_OBJ/%$GZIP_SUFFIX}
FILE_NAME_REMOVE_SUFFIX=${S3_OBJ/%$SQL_SUFFIX$GZIP_SUFFIX}
DATE=$(date +"%F-%H")
echo "===Start mask db==="
aws s3 cp s3://"$S3_BUCKET_SOURCE"/"$S3_OBJ" .
echo "===Start Gunzip and MaskDb==="
echo $FILE_NAME_REMOVE_GZIP_SUFFIX
gunzip $S3_OBJ
cat $FILE_NAME_REMOVE_GZIP_SUFFIX | anonymize-mysqldump --config config.json 2> /var/log/errors.log | gzip > $FILE_NAME_REMOVE_SUFFIX-masked.sql.gz
echo "===Finish MaskDB==="
echo "===Upload File To s3==="
aws s3 cp $FILE_NAME_REMOVE_SUFFIX-masked.sql.gz s3://"$S3_BUCKET_TARGET"/
echo "===End==="

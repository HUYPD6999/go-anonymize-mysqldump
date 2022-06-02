#!/bin/bash
echo "$S3_BUCKET_TARGET"
DATE=$(date +"%F")
echo "===Start mysqldumps==="
mysqldump -u $username -h $hostname -p$password --databases $database | gzip > $database-$DATE.sql.gz
echo "===Finish mysqldumps==="
echo "===Upload File To s3==="
aws s3 cp $database-$DATE.sql.gz s3://"$S3_BUCKET_TARGET"/
echo "===End==="

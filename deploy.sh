#!/bin/bash

S3_ENDPOINT="https://..."
S3_BUCKET="mybucket"
FOLDER="result"

if [ ! -d $FOLDER ]; then
    echo "Error: directory not found"
    exit 1
fi

find $FOLDER -type f | while read -r file; do
    relative_path=${file#result/}
    
    aws s3 cp "$file" "s3://${S3_BUCKET}/${relative_path}" \
        --endpoint-url "${S3_ENDPOINT}" \
        --acl "public-read" \
        --content-encoding br

    if [ $? -eq 0 ]; then
        echo "Successfully uploaded: ${file} to s3://${S3_BUCKET}/${relative_path}"
    else
        echo "Failed to upload: ${file}"
    fi
done

echo "Upload process completed"
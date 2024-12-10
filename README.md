## compress.sh

Compress all files from source folder using max brotli compression

`SOURCE_FOLDER` = folder with source files

`RESULT_FOLDER` = folder with new compressed files

Run
```
sh ./compress.sh
```

## deploy.sh

Push all files to S3 without losing brotli compression

`S3_ENDPOINT` = S3 endpoint

`S3_BUCKET` = bucket name

`FOLDER` = folder with files

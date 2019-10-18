# Utility functions
get_log_date () {
    date +[%Y-%m-%d\ %H:%M:%S]
}
get_file_date () {
    date +%Y%m%d%H%M%S
}

# Validate needed ENV vars
if [ -z "$MONGO_URI" ]; then
    echo "$(get_log_date) MONGO_URI is unset or set to the empty string"
    exit 1
fi
if [ -z "$BUCKET_NAME" ]; then
    echo "$(get_log_date) BUCKET_NAME is unset or set to the empty string"
    exit 1
fi

# START
echo "$(get_log_date) Mongo restore started"

# Activate google cloud service account
echo "$(get_log_date) Activating service account"
gcloud auth activate-service-account --key-file=$GOOGLE_APPLICATION_CREDENTIALS

# Backup filename
BACKUP_FILE_FULL_NAME=$(gsutil ls -l gs://$BUCKET_NAME/ | sort -k 2 | tail -n 2 | head -1 | cut -d ' ' -f 7)
BACKUP_FILENAME=$(echo ${BACKUP_FILE_FULL_NAME/gs:\/\/$BUCKET_NAME\/})

# Copy file from google storage
echo "[Step 1/3] Copy file $BACKUP_FILENAME from google storage"
gsutil cp $BACKUP_FILE_FULL_NAME .

# Decompress backup
echo "$(get_log_date) [Step 2/3] Running file decompression ${BACKUP_FILENAME}"
tar -xf ${BACKUP_FILENAME}

# Restore mongo
echo "$(get_log_date) [Step 3/3] Running mongorestore"
mongorestore --uri $MONGO_URI var/mongobackup/dump
echo "$(get_log_date) Restore has been finished"
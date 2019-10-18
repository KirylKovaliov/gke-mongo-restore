#!/bin/sh

sudo docker build . --tag lgt-mongo-restore-service:latest
sudo docker tag lgt-mongo-restore-service gcr.io/lead-tool-generator/lgt-mongo-restore-service:latest
gcloud docker -- push gcr.io/lead-tool-generator/lgt-mongo-restore-service:latest

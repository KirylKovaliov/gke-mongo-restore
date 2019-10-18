FROM ubuntu:16.04

RUN apt-get update && apt-get install -y curl python
COPY cred.json /var/secrets/google/key.json

RUN curl https://dl.google.com/dl/cloudsdk/release/google-cloud-sdk.tar.gz > /tmp/google-cloud-sdk.tar.gz
# Installing the package
RUN mkdir -p /var/gcloud \
  && tar -C /var/gcloud -xvf /tmp/google-cloud-sdk.tar.gz \
  && /var/gcloud/google-cloud-sdk/install.sh  

# Adding the package path to local
ENV PATH $PATH:/var/gcloud/google-cloud-sdk/bin

# Installin mongo client tools
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 0C49F3730359A14518585931BC711F9BA15703C6
RUN echo "deb [ arch=amd64,arm64 ] http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/4.2 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-3.4.list
RUN apt-get update && apt-get install -y --allow-unauthenticated mongodb-org-tools

RUN mkdir -p /var/mongorestore
COPY mongorestore.sh /var/mongorestore/mongorestore.sh
COPY cred.json /var/cred.json


RUN chmod +x /var/mongorestore/mongobackup.sh

#ENTRYPOINT ["tail", "-f", "/dev/null"]
CMD /var/mongorestore/mongorestore.sh
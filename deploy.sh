# deploy.sh
#! /bin/bash

SHA1=$1

#echo "Compose building local files: "
#docker-compose build

echo "Pushing to docker hub"
docker-compose push

#docker tag db <dockerhubRepo>:$SHA1
#docker tag api <dockerhubRepo>:$SHA1

echo "Updating AWS ECR"
ecs-cli compose --file aws-compose.yml up


#S3 Cli
npm run build
#aws s3 cp --recursive ./web/dist s3://<bucket-name>

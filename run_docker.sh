#!/usr/bin/env bash

## Complete the following steps to get Docker running locally
docker stop udacity-project4
docker image  rm udacity-project4
docker image rmi udacity-project4
# Step 1:
# Build image and add a descriptive tag
 docker build --tag=udacity-project4 .
# Step 2: 
# List docker images
docker images --all
# Step 3: 
# Run flask app
docker run -p 8080:80 udacity-project4

docker logs udacity-project4 -f >> docker_out.txt
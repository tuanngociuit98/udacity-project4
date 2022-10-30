#!/usr/bin/env bash
# This file tags and uploads an image to Docker Hub

# Assumes that an image is built via `run_docker.sh`

# Step 1:
# Create dockerpath
# dockerpath=<your docker ID/path>
dockerpath=00375877633/udacity
# Step 2:  
# Authenticate & tag
echo "Docker ID and Image: ${dockerpath}"
docker login registry-1.docker.io -u 00375877633 -p dckr_pat_kdkaGhZmbNGk2NnoHbf5vqxRDc0

docker tag udacity-project4 $dockerpath

# Step 3:
# Push image to a docker repository
docker push $dockerpath
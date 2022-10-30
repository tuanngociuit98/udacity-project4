#!/usr/bin/env bash

# This tags and uploads an image to Docker Hub

# Step 1:
# This is your Docker ID/path
# dockerpath=<>
dockerpath=00375877633/udacity
# Step 2
# Run the Docker Hub container with kubernetes
kubectl run website --image=$dockerpath --port=8080

# Step 3:
# List kubernetes pods
sudo kubectl get pods 
sleep 20
# Step 4:
# Forward the container port to a host
kubectl port-forward pod/website 8080:80 >> ./kubernetes_out.txt &
kubectl logs -f website >> ./kubernetes_out.txt &

[![CircleCI](https://dl.circleci.com/status-badge/img/gh/tuanngociuit98/udacity-project4/tree/master.svg?style=svg)](https://dl.circleci.com/status-badge/redirect/gh/tuanngociuit98/udacity-project4/tree/master)


## Project Overview

In this project, you will apply the skills you have acquired in this course to operationalize a Machine Learning Microservice API. 

You are given a pre-trained, `sklearn` model that has been trained to predict housing prices in Boston according to several features, such as average rooms in a home and data about highway access, teacher-to-pupil ratios, and so on. You can read more about the data, which was initially taken from Kaggle, on [the data source site](https://www.kaggle.com/c/boston-housing). This project tests your ability to operationalize a Python flask app—in a provided file, `app.py`—that serves out predictions (inference) about housing prices through API calls. This project could be extended to any pre-trained machine learning model, such as those for image recognition and data labeling.

### Project Tasks

Your project goal is to operationalize this working, machine learning microservice using [kubernetes](https://kubernetes.io/), which is an open-source system for automating the management of containerized applications. In this project you will:
* Test your project code using linting
* Complete a Dockerfile to containerize this application
* Deploy your containerized application using Docker and make a prediction
* Improve the log statements in the source code for this application
* Configure Kubernetes and create a Kubernetes cluster
* Deploy a container using Kubernetes and make a prediction
* Upload a complete Github repo with CircleCI to indicate that your code has been tested

You can find a detailed [project rubric, here](https://review.udacity.com/#!/rubrics/2576/view).

**The final implementation of the project will showcase your abilities to operationalize production microservices.**

---

## Setup the Environment


* Create EC2 instance or using Centos 7 on Virtual Box
* Create a virtualenv with Python 3.7 and activate it. Refer to this link for help on specifying the Python version in the virtualenv. 

```bash
python3 -m pip install --user virtualenv
# You should have Python 3.7 available in your host. 
# Check the Python path using `which python3`
# Use a command similar to this one:
python3 -m virtualenv --python=<path-to-Python3.7> .devops
source .devops/bin/activate
```

* INSTALL NECESSARY TOOLS  
```bash

sudo yum update -y

#INSTALL GIT

sudo yum install git -y

#Check git 

git version

#INSTALL DOCKER

sudo yum install docker

#Enable docker service at boot time

sudo systemctl enable docker.service

#Start Docker service

sudo systemctl start docker.service

#INSTALL MINIKUBE

curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 
sudo chmod +x minikube 
sudo mv minikube /usr/local/bin/

#Check minikube version

minikube version

#Install Hadolint

sudo wget -O ./hadolint https://github.com/hadolint/hadolint/releases/download/v2.10.0/hadolint-Linux-x86_64
sudo chmod +x ./hadolint
sudo mv ./hadolint /usr/local/bin/hadolint
```

* Run `make install` to install the necessary dependencies

### Running `app.py`

1. Standalone:  `python app.py`
2. Run in Docker:  `./run_docker.sh`
3. Run in Kubernetes:  `./run_kubernetes.sh`

### Docker Steps

* Complete Dockerfile

```bash
FROM python:3.7.3-stretch

## Step 1:
# Create a working directory
WORKDIR /work

## Step 2:
# Copy source code to working directory
COPY . /work/


## Step 3:
# Install packages from requirements.txt
# hadolint ignore=DL3013
RUN pip install --trusted-host pypi.python.org -r requirements.txt

## Step 4:
# Expose port 80
EXPOSE 80

## Step 5:
# Run app.py at container launch
CMD ["python", "app.py"]
```

* Complete run_docker.sh
```bash
#!/usr/bin/env bash

## Complete the following steps to get Docker running locally

# Step 1:
# Build image and add a descriptive tag

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
docker run -d 8080:80 udacity-project4

docker logs udacity-project4 -f >> docker_out.txt 
```

* Build image , run docker and make a prediction
```bash
#Build image and run docker 
./run_docker.sh
#Make prediction
./make_prediction.sh
```

* Complete upload_docker.sh to upload docker image to dockerhub
```bash
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
```
* Run upload_docker.sh to upload docker image to dockerhub
```bash
./upload_docker.sh
```

### Kubernetes Steps
* Complete run_kubernetes.sh file
```bash
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
```

* Deploy application on kubernetes and make a prediction
```bash
#Start minikube
minikube start --driver=docker --insecure-registry="127.0.0.1:5000"
#Deploy application on kubernetes
./run_kubernetes.sh
#Make a prediction
./make_prediction.sh
```

## Directory Explain
* `.circleci/config.yml`: config file for CircleCI pipepline
* `Dockerfile`: config file to build docker image
* `make_prediction.sh`: script to make prediction from app's api
* `requirements.txt`:  dependencies require list to install 
* `run_docker.sh`: script to build docker image and run container
* `run_kubernetes.sh`: script to deploy application with kubenetes
* `upload_docker.sh`: script to upload docker image to docker hub
* `output_txt_files`: output file of docker and kubernetes script

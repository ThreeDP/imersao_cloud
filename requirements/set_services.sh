#!/bin/sh

export GOOGLE_CLOUD_PROJECT_ID=$(gcloud config get-value project)
gcloud config set project $GOOGLE_CLOUD_PROJECT_ID
./$1 
gcloud services enable containerregistry.googleapis.com
gcloud services enable container.googleapis.com
gcloud services enable sqladmin.googleapis.com
gcloud services enable cloudresourcemanager.googleapis.com
gcloud services enable serviceusage.googleapis.com
gcloud services enable compute.googleapis.com
gcloud services enable servicenetworking.googleapis.com --project=$GOOGLE_CLOUD_PROJECT_ID
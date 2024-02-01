#!/bin/sh

export GOOGLE_CLOUD_PROJECT_ID=$(gcloud config get-value project)
gcloud config set project $GOOGLE_CLOUD_PROJECT_ID
gcloud services disable servicenetworking.googleapis.com --project=$GOOGLE_CLOUD_PROJECT_ID
gcloud services disable serviceusage.googleapis.com --force
gcloud services disable compute.googleapis.com
gcloud services disable cloudresourcemanager.googleapis.com
gcloud services disable sqladmin.googleapis.com
gcloud services disable container.googleapis.com
gcloud services disable containerregistry.googleapis.com

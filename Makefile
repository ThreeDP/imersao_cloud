FILES_PATH				=	./requirements/
AWS_PATH				=	~/.aws/
TERRAFORM_PATH			=	$(addprefix $(FILES_PATH), terraform/)
KUBERNETES_PATH			=	$(addprefix $(FILES_PATH), kubernetes/)
APP_PATH				=	$(addprefix $(FILES_PATH), app/)

GCP_SCRIPT				=	gcp_set_project.sh
AWS_SCRIPT				=	aws_set_credentials.sh
SET_SERVICES_SCRIPT		=	set_services.sh
SCRIPTS					=	$(addprefix $(FILES_PATH), $(AWS_SCRIPT) $(GCP_SCRIPT) $(SET_SERVICES_SCRIPT))

TERRAFORM_OUT_FILES		=	$(addprefix $(TERRAFORM_PATH), .terraform .terraform.lock.hcl terraform.tfstate terraform.tfvars terraform.tfstate.backup)
KUBERNETES_FILE			=	luxxy-covid-testing-system.yaml

all: build

build:
	chmod +x $(SCRIPTS)
	mkdir -p $(AWS_PATH)
	touch $(addprefix $(AWS_PATH), $(CREDENTIALS_NAME))
	$(FILES_PATH)$(AWS_SCRIPT) $(SECRET)
	$(FILES_PATH)$(SET_SERVICES_SCRIPT) $(addprefix $(FILES_PATH), $(GCP_SCRIPT))
	terraform -chdir=$(TERRAFORM_PATH) init
	terraform -chdir=$(TERRAFORM_PATH) plan
	terraform -chdir=$(TERRAFORM_PATH) apply -auto-approve

deploy:
	gcloud services enable cloudbuild.googleapis.com
	cd $(APP_PATH) && gcloud builds submit --tag $(CONTAINER_LUXXY_COVID_NAME)
	gcloud container clusters get-credentials $(KUBERNETES_INSTANCE) --region us-east4 --project $(GOOGLE_CLOUD_PROJECT_ID)
	kubectl create configmap $(KUBERNETES_ENV_FILE) --from-env-file=.env
	cd $(KUBERNETES_PATH) && kubectl apply -f $(KUBERNETES_FILE)

clean:
	rm -rf $(TERRAFORM_OUT_FILES)
	rm -rf ~/.aws

fclean:
	gcloud container clusters get-credentials $(KUBERNETES_INSTANCE) --region us-east4 --project $(GOOGLE_CLOUD_PROJECT_ID)
	kubectl delete deployment luxxy-covid-testing-system
	kubectl delete service luxxy-covid-testing-system
	gcloud compute networks peerings delete servicenetworking-googleapis-com --network=$(VPC_NETWORK) --project=$(GOOGLE_CLOUD_PROJECT_ID)
	terraform -chdir=$(TERRAFORM_PATH) destroy
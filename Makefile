FILES_PATH				=	./requirements/
GCP_SCRIPT				=	gcp_set_project.sh
AWS_SCRIPT				=	aws_set_credentials.sh
SET_SERVICES_SCRIPT		=	set_services.sh
UNSET_SERVICES_SCRIPT	=	unset_services.sh
SCRIPTS					=	$(addprefix $(FILES_PATH), $(AWS_SCRIPT) $(GCP_SCRIPT) $(SET_SERVICES_SCRIPT))
CREDENTIALS_NAME		=	credentials
AWS_PATH				=	~/.aws/
TERRAFORM_PATH			=	$(addprefix $(FILES_PATH), terraform)
TERRAFROM_OUT_FILES		=	$(addprefix $(TERRAFORM_PATH), .terraform .terraform.lock.hcl terraform.tfstate terraform.tfvars)
SQL_INSTANCE			=	luxxy-covid-testing-system-database-instance-pt	

all: build

build:
	chmod +x $(SCRIPTS)
	mkdir -p $(AWS_PATH)
	touch $(addprefix $(AWS_PATH), $(CREDENTIALS_NAME))
	$(FILES_PATH)$(AWS_SCRIPT) $(KEY_SECRET)
	$(FILES_PATH)$(SET_SERVICES_SCRIPT) $(addprefix $(FILES_PATH), $(GCP_SCRIPT))
	terraform -chdir=$(TERRAFORM_PATH) init
	terraform -chdir=$(TERRAFORM_PATH) plan
	terraform -chdir=$(TERRAFORM_PATH) apply -auto-approve

deploy:
	gcloud sql connect $(SQL_INSTANCE) --user=root

fclean:
	kubectl delete deployment luxxy-covid-testing-system
	kubectl delete service luxxy-covid-testing-system
	terraform -chdir=$(TERRAFORM_PATH) destroy
	rm -rf $(TERRAFORM_OUT_FILES)
	gcloud sql instances delete $(SQL_INSTANCE)
#	$(FILES_PATH)$(UNSET_SERVICES_SCRIPT)
#	rm -rf ~/.aws
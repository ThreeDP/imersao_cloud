FILES_PATH				=	./requirements/
GCP_SCRIPT				=	gcp_set_project.sh
AWS_SCRIPT				=	aws_set_credentials.sh
SET_SERVICES_SCRIPT		=	set_services.sh
SCRIPTS					=	$(addprefix $(FILES_PATH), $(AWS_SCRIPT) $(GCP_SCRIPT) $(SET_SERVICES_SCRIPT))
CREDENTIALS_NAME		=	credentials
AWS_PATH				=	~/.aws/
TERRAFORM_PATH			=	$(addprefix $(FILES_PATH), terraform)

all: build

build:
	chmod +x $(SCRIPTS)
	mkdir -p $(AWS_PATH)
	touch $(addprefix $(AWS_PATH), $(CREDENTIALS_NAME))
	$(FILES_PATH)$(AWS_SCRIPT) $1
	$(FILES_PATH)$(SET_SERVICES_SCRIPT) $(GCP_SCRIPT)
	terraform init -chdir=$(TERRAFORM_PATH)
	terraform plan -chdir=$(TERRAFORM_PATH)
	terraform apply -chdir=$(TERRAFORM_PATH) -auto-approve


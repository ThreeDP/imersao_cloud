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
	$(FILES_PATH)$(AWS_SCRIPT) $(KEY_SECRET)
	$(FILES_PATH)$(SET_SERVICES_SCRIPT) $(addprefix $(FILES_PATH), $(GCP_SCRIPT))
	terraform -chdir=$(TERRAFORM_PATH) init
	terraform -chdir=$(TERRAFORM_PATH) plan
	terraform -chdir=$(TERRAFORM_PATH) apply -auto-approve


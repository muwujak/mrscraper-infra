
init:
	terraform init

plan:
	terraform plan -var-file=terraform.tfvars -out=plan.out

apply:
	terraform apply -var-file=terraform.tfvars plan.out


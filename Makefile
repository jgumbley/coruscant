define green
	@tput setaf 2; echo $1; tput sgr0;
endef

MACHINE_IP=$(shell cd terraform; terraform output ip)

.PHONY: setup
setup: terraform
	cd ansible; ansible-playbook -u ec2-user -i $(MACHINE_IP), setup.yml --private-key ../deploy_key

.PHONY: terraform
terraform: deploy_key
	cd terraform; terraform apply
	$(call green,"[All steps successful]")

deploy_key:
	ssh-keygen -t rsa -b 4096 -C "$(shell whoami)@jimssolution" -f ./deploy_key

.PHONY: clean
clean:
	cd terraform; terraform destroy -force
	$(call green,"[All steps successful]")

.PHONY: mrsparkle
mrsparkle: clean
	rm deploy_key deploy_key.pub
	$(call green,"[All steps successful]")

.PHONY: ssh
ssh:
	ssh ec2-user@$(SMASHER_IP)


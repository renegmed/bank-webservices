init-project:
	go mod init duomly.com/go-bank-backend
.PHONY: init-project 

eval:
	eval $(minikube docker-env)

build:
	docker build -t bank-api .

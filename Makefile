minikube:
	eval $(minikube docker-env)

minikube-ssh:
	minikube ssh


up:
	docker-compose up --build -d 
.PHONY: up 

tail-api:
	docker logs api -f 
.PHONY: api


register1:
	curl -XPOST 172.17.0.3:30088/register -d '{"username": "Radek1", "email": "radek1@radek.com", "password": "Radek1"}'
.PHONY: register1 

login1:
	@curl -XPOST localhost:8888/login -d '{"username": "Michael", "password": "Michael"}'
.PHONY: login1
 	
login-radek:
	@curl -XPOST localhost:8888/login -d '{"username": "Radek1", "password": "Radek1"}'
.PHONY: login-radek

get1:
	@curl 172.17.0.3:30088/user/2 -H "Authorization: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHBpcnkiOjE1OTU2ODQxMTUsInVzZXJfaWQiOjJ9.MHFE8earZcnMSv9m3_rOweiB51V56Do4eUxqylN4SIA"

get2:
	@curl 172.17.0.3:30088/user/3 -H "Authorization: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHBpcnkiOjE1OTU4NTczODksInVzZXJfaWQiOjN9._SgPeZ_qfOCEUJeEPvDe-3p97fmjMtyAxAQzq_Us7X0"

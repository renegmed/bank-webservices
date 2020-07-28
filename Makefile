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


local-merge:
	@curl -XPOST localhost:8888/merge

local-reg1:
	curl -XPOST localhost:8888/register -d '{"username": "Radek", "email": "radek1@radek.com", "password": "Radek"}'


local-get1:
	curl localhost:8888/user/2 -H "Authorization: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHBpcnkiOjE1OTU4ODkxMDMsInVzZXJfaWQiOjJ9.BSeuJB0E7YI43ZIKd1XigCtPjgsk-Wdj-SIa5uzCGmE"

local-get2:
	curl localhost:8888/user/3 -H "Authorization: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHBpcnkiOjE1OTU5NTEyNTksInVzZXJfaWQiOjN9.YHvLKYhxVv4Gyiqt4qVj5OjVFcut1DRinb7lMiPuJbE"

local-login1:
	@curl -XPOST localhost:8888/login -d '{"username": "Michael", "password": "Michael"}'
 
local-login2:
	@curl -XPOST localhost:8888/login -d '{"username": "Radek", "password": "Radek"}'
 
local-transact1:
	@curl -XPOST localhost:8888/transaction -d '{"userid": 2, "from": 2, "to": 3, "amount": 350}' -H "Authorization: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHBpcnkiOjE1OTU4ODkxMDMsInVzZXJfaWQiOjJ9.BSeuJB0E7YI43ZIKd1XigCtPjgsk-Wdj-SIa5uzCGmE"


# local-transact1:
# 	curl -XPOST localhost:8888/register -d '{"username": "Radek", "email": "radek1@radek.com", "password": "Radek"}'


reg1:
	curl -XPOST 172.17.0.3:30088/register -d '{"username": "Radek", "email": "radek@radek.com", "password": "Radek"}'
.PHONY: register1 

login1:
	@curl -XPOST 172.17.0.3:30088/login -d '{"username": "Michael", "password": "Michael"}'
.PHONY: login1
 	
login2:
	@curl -XPOST 172.17.0.3:30088/login -d '{"username": "Radek1", "password": "Radek1"}'
.PHONY: login-radek

get1:
	@curl 172.17.0.3:30088/user/2 -H "Authorization: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHBpcnkiOjE1OTU5MDI1ODMsInVzZXJfaWQiOjJ9.Nu9KD3l7b8SoHZuybZw0A_WIAEFVK3alMI2JIE8P8hE"

get2:
	@curl 172.17.0.3:30088/user/9 -H "Authorization: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHBpcnkiOjE1OTU5MDI2MjgsInVzZXJfaWQiOjl9.eqRBAQyT1pgUq08nVWBqPdhHBVmgN5E4-LcxSRTaKas"

transact1:
	@curl -XPOST 172.17.0.3:30088/transaction -d '{"userid": 2, "from": 2, "to": 9, "amount": 500}' -H "Authorization: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHBpcnkiOjE1OTU5MDI1ODMsInVzZXJfaWQiOjJ9.Nu9KD3l7b8SoHZuybZw0A_WIAEFVK3alMI2JIE8P8hE"


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


 
#LOCAL_MICHAEL_JWT= 
LOCAL_MICHAEL_LOGIN_JWT=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHBpcnkiOjE1OTYwMjY2NTAsInVzZXJfaWQiOjF9.oudEoQjnn9dkI07e4z4z9NJ27TDF_S025dRxApyf0X0
LOCAL_MICHAEL_USER_ID=1
LOCAL_MICHAEL_ACCNT_ID=1
#LOCAL_RADEK_JWT=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHBpcnkiOjE1OTYwMTg5NzgsInVzZXJfaWQiOjJ9.u51ohMfIpPiVL0uKSgO8Rf_sMONdfPvdaY0F7msf03c
LOCAL_RADEK_LOGIN_JWT=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHBpcnkiOjE1OTYwMjYzMjcsInVzZXJfaWQiOjJ9.AE007fOEuJfjwiMnSHjWJf6Bs5fk0LVqOw0I4PuJ7X8
LOCAL_RADEK_ACCNT_ID=2 
LOCAL_RADEK_USER_ID=2
#LOCAL_JEREMY_JWT=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHBpcnkiOjE1OTYwMTkwMTcsInVzZXJfaWQiOjN9.mRGlrG9fs3BsAbwh5p491DbhFAp45XYz-sGeoGl1EBQ
LOCAL_JEREMY_LOGIN_JWT=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHBpcnkiOjE1OTYwMjcwOTIsInVzZXJfaWQiOjN9.DEpzQZoGKL005oBQLBvhI7xqJ-HlvNt3uoZQLTFeY7I
LOCAL_JEREMY_USER_ID=3
LOCAL_JEREMY_ACCNT_ID=3 

local-migrate:
	@curl -XPOST localhost:8888/migrate


local-reg1:
	curl -XPOST $(MINIKUBE_IP):$(PORT)/register -d '{"username": "Michael", "email": "michael@test.com", "password": "Michael"}'

local-reg1:
	curl -XPOST localhost:8888/register -d '{"username": "Radek", "email": "radek@radek.com", "password": "Radek"}'

local-reg2:
	curl -XPOST localhost:8888/register -d '{"username": "Jeremy", "email": "jeremy@test.com", "password": "Jeremy"}' 


local-login1:
	@curl -XPOST localhost:8888/login -d '{"username": "Michael", "password": "Michael"}'
.PHONY: login1
 	
local-login2:
	@curl -XPOST localhost:8888/login -d '{"username": "Radek", "password": "Radek"}'
.PHONY: login-radek

local-login3:
	@curl -XPOST localhost:8888/login -d '{"username": "Jeremy", "password": "Jeremy"}'


# You have to logged-in to get details of the account

local-get1:
	@curl localhost:8888/user/$(LOCAL_MICHAEL_USER_ID) -H "Authorization: ${LOCAL_MICHAEL_LOGIN_JWT}"

local-get2:
	@curl localhost:8888/user/$(LOCAL_RADEK_USER_ID) -H "Authorization: ${LOCAL_RADEK_LOGIN_JWT}"

local-get3:
	@curl localhost:8888/user/$(LOCAL_JEREMY_USER_ID) -H "Authorization: ${LOCAL_JEREMY_LOGIN_JWT}"

# You have to logged-in to transact

local-transact1:
	@curl -XPOST localhost:8888/transaction -d '{"userid": ${LOCAL_MICHAEL_USER_ID}, "from": ${LOCAL_MICHAEL_ACCNT_ID}, "to": ${LOCAL_RADEK_ACCNT_ID}, "amount": 50}' -H "Authorization: ${LOCAL_MICHAEL_LOGIN_JWT}"

local-transact2:
	@curl -XPOST localhost:8888/transaction -d '{"userid": ${LOCAL_MICHAEL_USER_ID}, "from": ${LOCAL_MICHAEL_ACCNT_ID}, "to": ${LOCAL_RADEK_ACCNT_ID}, "amount": 75}' -H "Authorization: ${LOCAL_MICHAEL_LOGIN_JWT}"

local-transact3:
	@curl -XPOST localhost:8888/transaction -d '{"userid": ${LOCAL_RADEK_USER_ID}, "from": ${LOCAL_RADEK_ACCNT_ID}, "to": ${LOCAL_JEREMY_ACCNT_ID}, "amount": 1}' -H "Authorization: ${LOCAL_RADEK_LOGIN_JWT}"

local-transact4:
	@curl -XPOST localhost:8888/transaction -d '{"userid": ${LOCAL_RADEK_USER_ID}, "from": ${LOCAL_RADEK_ACCNT_ID}, "to": ${LOCAL_JEREMY_ACCNT_ID}, "amount": 150}' -H "Authorization: ${LOCAL_MICHAEL_LOGIN_JWT}"

local-transact5:
	@curl -XPOST localhost:8888/transaction -d '{"userid": ${LOCAL_JEREMY_USER_ID}, "from": ${LOCAL_JEREMY_ACCNT_ID}, "to": ${LOCAL_MICHAEL_ACCNT_ID}, "amount": 25}' -H "Authorization: ${LOCAL_JEREMY_LOGIN_JWT}"


# You have to logged-in to get transaction histories

local-transactions1:
	@curl localhost:8888/transactions/$(LOCAL_MICHAEL_USER_ID) -H "Authorization: ${LOCAL_MICHAEL_LOGIN_JWT}"

local-transactions2:
	@curl localhost:8888/transactions/$(LOCAL_RADEK_USER_ID) -H "Authorization: ${LOCAL_RADEK_LOGIN_JWT}"

local-transactions3:
	@curl localhost:8888/transactions/$(LOCAL_JEREMY_USER_ID) -H "Authorization: ${LOCAL_JEREMY_LOGIN_JWT}"
  

MINIKUBE_IP=172.17.0.3
PORT=30088
MICHAEL_JWT= 
MICHAEL_LOGIN_JWT= 
MICHAEL_USER_ID= 
MICHAEL_ACCNT_ID= 
RADEK_JWT= 
RADEK_LOGIN_JWT= 
RADEK_ACCNT_ID= 
RADEK_USER_ID=14
JEREMY_JWT= 
JEREMY_LOGIN_JWT=
JEREMY_USER_ID= 
JEREMY_ACCNT_ID= 

migrate:
	curl -XPOST $(MINIKUBE_IP):$(PORT)/migrate

reg1:
	curl -XPOST $(MINIKUBE_IP):$(PORT)/register -d '{"username": "Michael", "email": "michael@test.com", "password": "Michael"}'

reg2:
	curl -XPOST $(MINIKUBE_IP):$(PORT)/register -d '{"username": "Radek", "email": "radek@radek.com", "password": "Radek"}'

reg3:
	curl -XPOST $(MINIKUBE_IP):$(PORT)/register -d '{"username": "Jeremy", "email": "jeremy@test.com", "password": "Jeremy"}' 

login1:
	@curl -XPOST 172.17.0.3:30088/login -d '{"username": "Michael", "password": "Michael"}'
.PHONY: login1
 	
login2:
	@curl -XPOST 172.17.0.3:30088/login -d '{"username": "Radek", "password": "Radek"}'
.PHONY: login-radek

login3:
	@curl -XPOST 172.17.0.3:30088/login -d '{"username": "Jeremy", "password": "Jeremy"}'


# You have to logged-in to get details of the account

get1:
	@curl $(MINIKUBE_IP):$(PORT)/user/$(MICHAEL_USER_ID) -H "Authorization: ${MICHAEL_LOGIN_JWT}"

get2:
	@curl $(MINIKUBE_IP):$(PORT)/user/$(RADEK_USER_ID) -H "Authorization: ${RADEK_LOGIN_JWT}"

get3:
	@curl $(MINIKUBE_IP):$(PORT)/user/8 -H "Authorization: ${JEREMY_LOGIN_JWT}"


# You have to loggedin to transact 

transact1:
	@curl -XPOST $(MINIKUBE_IP):$(PORT)/transaction -d '{"userid": ${MICHAEL_USER_ID}, "from": ${MICHAEL_ACCNT_ID}, "to": ${RADEK_ACCNT_ID}, "amount": 50}' -H "Authorization: ${MICHAEL_LOGIN_JWT}"

transact2:
	@curl -XPOST $(MINIKUBE_IP):$(PORT)/transaction -d '{"userid": ${MICHAEL_USER_ID}, "from": ${MICHAEL_ACCNT_ID}, "to": ${RADEK_ACCNT_ID}, "amount": 75}' -H "Authorization: ${MICHAEL_LOGIN_JWT}"

transact3:
	@curl -XPOST $(MINIKUBE_IP):$(PORT)/transaction -d '{"userid": ${RADEK_USER_ID}, "from": ${RADEK_ACCNT_ID}, "to": ${JEREMY_ACCNT_ID}, "amount": 1}' -H "Authorization: ${RADEK_LOGIN_JWT}"

transact4:
	@curl -XPOST $(MINIKUBE_IP):$(PORT)/transaction -d '{"userid": ${RADEK_USER_ID}, "from": ${RADEK_ACCNT_ID}, "to": ${JEREMY_ACCNT_ID}, "amount": 150}' -H "Authorization: ${MICHAEL_LOGIN_JWT}"

transact5:
	@curl -XPOST $(MINIKUBE_IP):$(PORT)/transaction -d '{"userid": ${JEREMY_USER_ID}, "from": ${JEREMY_ACCNT_ID}, "to": ${MICHAEL_ACCNT_ID}, "amount": 25}' -H "Authorization: ${JEREMY_LOGIN_JWT}"


# You have to loggedin to get transaction histories
transactions1:
	@curl $(MINIKUBE_IP):$(PORT)/transactions/$(MICHAEL_USER_ID) -H "Authorization: ${MICHAEL_LOGIN_JWT}"

transactions2:
	@curl $(MINIKUBE_IP):$(PORT)/transactions/$(RADEK_USER_ID) -H "Authorization: ${RADEK_LOGIN_JWT}"

transactions3:
	@curl $(MINIKUBE_IP):$(PORT)/transactions/$(JEREMY_USER_ID)-H "Authorization: ${JEREMY_LOGIN_JWT}"
 
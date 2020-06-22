up:
	docker-compose up --build -d 
.PHONY: up 

tail-api:
	docker logs api -f 
.PHONY: api


login1:
	@curl -XPOST localhost:8888/login -d '{"username": "Michael", "password": "Michael"}'
.PHONY: login1

register1:
	@curl -XPOST localhost:8888/register -d '{"username": "Radek", "email": "radek@radek.com", "password": "Radek"}'
.PHONY: register1

login-radek:
	@curl -XPOST localhost:8888/login -d '{"email": "Michael", "password": "Radek"}'
.PHONY: login-radek
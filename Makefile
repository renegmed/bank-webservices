up:
	docker-compose up --build -d 
.PHONY: up 

tail-api:
	docker logs api -f 
.PHONY: api


login1:
	@curl -XPOST localhost:8888/login -d '{"username": "Michael", "password": "Michael"}'
.PHONY: login1
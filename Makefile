all: test

compose_environment:
	docker-compose up -d --build

test: compose_environment
	./test.sh

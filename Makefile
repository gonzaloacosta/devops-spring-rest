VERSION 	:= 0.0.1-SNAPSHOT
NAME 		:= devops-sprint-rest

# docker

docker/install:
	@brew install docker

docker/build:
	@docker build --build-arg JAR_FILE=build/libs/*.jar -t build38/$(NAME):$(TAG) .


docker/run:
	@docker run --rm -d build38/$(NAME):$(TAG) -p 8080:8080

docker/run:
	@docker run --name $(NAME) --rm -p 8080:8080 -d -it build38/$(NAME):$(TAG)

docker/login:
	@docker login

docker/push:
	@docker push $(REGISTRY)/$(NAME):$(TAG)


# Minikube
minikube/install:
	@brew install minikube@1.24

minikube/start:
	@minikube start --driver=docker
	@minikube status
	@minikube update-context
	@minikube addons enable ingress

minikube/stop:
	@minikube stop

minikube/tunnel:
	@minikube tunnel

# Kubernetes
kube/install/cli:
	@brew install kubectl@1.24
	@brew install kubectx
	@brew install kubens


kube/info:
	@kubectl versions
	@kubectl cluster-info

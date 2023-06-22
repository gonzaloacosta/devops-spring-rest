VERSION 	:= 0.0.2-SNAPSHOT
NAME 		:= devops-sprint-rest


# gradle
gradle/run:
	@./gradlew
	@./gradlew bootRun

# docker
docker/ps:
	@sudo docker ps -a

docker/images:
	@sudo docker images

docker/install:
	@brew install docker

docker/build:
	@sudo docker build --build-arg JAR_FILE=build/libs/*.jar -t build38/$(NAME):$(TAG) .


docker/run:
	@sudo docker run --name $(NAME) --rm -p 8080:8080 -d -it build38/$(NAME):$(TAG)

docker/login:
	@sudo docker login

docker/push:
	@sudo docker push $(REGISTRY)/$(NAME):$(TAG)


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


# Test
#actuator/health:
#    @curl "http://localhost:8081/actuator/health"

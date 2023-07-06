export
VERSION 		:= $(shell egrep '^version'  build.gradle | cut -d = -f 2 | sed "s/['|' ']//g")
NAME 			:= $(shell basename `pwd`)
ORGANIZATION	:= build38
NEXUS_REGISTRY 	:= $(NEXUS_REGISTRY)
IMAGE_TAG		:= $(NEXUS_REGISTRY)/$(ORGANIZATION)/$(NAME):$(VERSION)
JAR_FILE		:= $(NAME)-$(VERSION).jar
NEXUS_USER		:= $(NEXUS_USER)
NEXUS_PASSWORD 	:= $(NEXUS_PASSWORD)
export 
# env
env:
	@echo "Organization: $(ORGANIZATION)"
	@echo "Artifact: $(NAME)"
	@echo "Version: $(VERSION)"
	@echo "Registry: $(NEXUS_REGISTRY)"
	@echo "Image Registry Tag: $(IMAGE_TAG)"
	@echo "JAR file: $(JAR_FILE)"

# gradle
gradle/run:
	@`pwd`/gradlew
	@`pwd`/gradlew bootRun

gradle/build:
	@./gradlew build

# docker
docker/ps:
	@sudo docker ps -a

docker/images:
	@sudo docker images

docker/install:
	@brew install docker

docker/build:
	@docker build --build-arg JAR_FILE=build/libs/$(JAR_FILE) -t $(IMAGE_TAG) .

docker/run:
	@docker run --name $(NAME)-$(VERSION) --rm -p 8080:8080 -d -it $(IMAGE_TAG)

docker/login:
	@$(shell docker login -u $(NEXUS_USER) -p $(NEXUS_PASSWORD) $(NEXUS_REGISTRY))

docker/push:
	@docker push $(IMAGE_TAG)


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
health:
	@curl -s http://localhost:8080/actuator/health

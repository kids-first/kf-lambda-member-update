#!/bin/bash

GREEN='\e[32m'
RED='\e[0;31m'
CLEAR='\e[0m'

color_green(){
	echo -ne "$GREEN$1$CLEAR"
}

IMAGE_TAG="dev-kf-lambda-member-update"

build_image() {
  echo "==> building image: ${IMAGE_TAG}..."
  docker build -t "$IMAGE_TAG" . -f Dockerfile-dev
}

remove_image() {
  docker rmi "$IMAGE_TAG"
}

menu(){
echo -ne "
$(color_green '1)') Run unit tests
$(color_green '2)') Run integration tests (make sure your local elasticsearch cluster is up)
$(color_green '3)') Run terminal (with es-net network; sharing project files)
$(color_green '4)') Run terminal (no network; sharing project files)
$(color_green '5)') Remove image
$(color_green '0)') Exit
Choose an option: "
        read -r a
        case $a in
	        1) build_image && docker run --rm -it --workdir /code "$IMAGE_TAG" /bin/bash -c "pytest tests/unit ; exit" ;;
	        2) build_image && docker run --rm -it --network=es-net --workdir /code "$IMAGE_TAG" /bin/bash -c "pytest tests/integration ; exit" ;;
	        3) build_image && docker run --rm -it -v "$PWD":/code --network=es-net --workdir /code "$IMAGE_TAG" /bin/bash ;;
	        4) build_image && docker run --rm -it -v "$PWD":/code --workdir /code "$IMAGE_TAG" /bin/bash ;;
		      5) remove_image ;;
		      0) exit 0 ;;
		      *) echo -e "$RED""Wrong option." "$CLEAR";;
        esac
}

menu

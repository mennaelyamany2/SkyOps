#!/bin/bash

DOCKERHUB_USER="mennaelyamany"
SERVICES_DIR="$HOME/TeaStore/services"
VERSION_FILE="$HOME/TeaStore/.build_version"

if [ -f "$VERSION_FILE" ]; then
    CURRENT_VERSION=$(cat "$VERSION_FILE")
    NEW_VERSION=$((CURRENT_VERSION + 1))
else
    NEW_VERSION=1
fi

TAG="v$NEW_VERSION"
echo "Building with tag: $TAG"
echo ""

SERVICES=(
    "tools.descartes.teastore.auth:teastore-auth"
    "tools.descartes.teastore.image:teastore-image"
    "tools.descartes.teastore.persistence:teastore-persistence"
    "tools.descartes.teastore.recommender:teastore-recommender"
    "tools.descartes.teastore.registry:teastore-registry"
    "tools.descartes.teastore.webui:teastore-webui"
)

for SERVICE in "${SERVICES[@]}"; do
    SERVICE_DIR=$(echo $SERVICE | cut -d: -f1)
    IMAGE_NAME=$(echo $SERVICE | cut -d: -f2)
    FULL_PATH="$SERVICES_DIR/$SERVICE_DIR"

    echo "================================================"
    echo "Building: $IMAGE_NAME:$TAG"
    echo "================================================"

    if [ ! -f "$FULL_PATH/Dockerfile" ]; then
        echo "ERROR: Dockerfile not found in $FULL_PATH"
        continue
    fi

    docker build -t "$DOCKERHUB_USER/$IMAGE_NAME:$TAG" "$FULL_PATH"

    if [ $? -eq 0 ]; then
        docker tag "$DOCKERHUB_USER/$IMAGE_NAME:$TAG" "$DOCKERHUB_USER/$IMAGE_NAME:latest"
        docker push "$DOCKERHUB_USER/$IMAGE_NAME:$TAG"
        docker push "$DOCKERHUB_USER/$IMAGE_NAME:latest"
        echo "Done: $IMAGE_NAME"
    else
        echo "ERROR: Build failed for $IMAGE_NAME"
    fi
    echo ""
done

# Build DB separately from descartesresearch
echo "================================================"
echo "Tagging DB image: teastore-db:$TAG"
echo "================================================"
docker pull descartesresearch/teastore-db:latest
docker tag descartesresearch/teastore-db:latest "$DOCKERHUB_USER/teastore-db:$TAG"
docker tag descartesresearch/teastore-db:latest "$DOCKERHUB_USER/teastore-db:latest"
docker push "$DOCKERHUB_USER/teastore-db:$TAG"
docker push "$DOCKERHUB_USER/teastore-db:latest"
echo "Done: teastore-db"

echo "$NEW_VERSION" > "$VERSION_FILE"

echo "================================================"
echo "All services built with tag: $TAG"
echo "================================================"

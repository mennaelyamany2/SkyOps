#!/bin/bash

DOCKERHUB_USER="mennaelyamany"
SERVICES_DIR="$HOME/TeaStore/services"
VERSION_FILE="$HOME/TeaStore/.build_version"

# Get current version and increment it
if [ -f "$VERSION_FILE" ]; then
    CURRENT_VERSION=$(cat "$VERSION_FILE")
    NEW_VERSION=$((CURRENT_VERSION + 1))
else
    NEW_VERSION=1
fi

TAG="v$NEW_VERSION"
echo "Building with tag: $TAG"
echo ""

# Services list
SERVICES=(
    "tools.descartes.teastore.auth:teastore-auth"
    "tools.descartes.teastore.image:teastore-image"
    "tools.descartes.teastore.persistence:teastore-persistence"
    "tools.descartes.teastore.recommender:teastore-recommender"
    "tools.descartes.teastore.registry:teastore-registry"
    "tools.descartes.teastore.webui:teastore-webui"
)

# Build and push each service
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

    # Build
    docker build -t "$DOCKERHUB_USER/$IMAGE_NAME:$TAG" "$FULL_PATH"

    if [ $? -eq 0 ]; then
        echo "Build successful: $DOCKERHUB_USER/$IMAGE_NAME:$TAG"

        # Tag as latest too
        docker tag "$DOCKERHUB_USER/$IMAGE_NAME:$TAG" "$DOCKERHUB_USER/$IMAGE_NAME:latest"

        # Push
        echo "Pushing: $DOCKERHUB_USER/$IMAGE_NAME:$TAG"
        docker push "$DOCKERHUB_USER/$IMAGE_NAME:$TAG"
        docker push "$DOCKERHUB_USER/$IMAGE_NAME:latest"

        echo "Done: $IMAGE_NAME"
    else
        echo "ERROR: Build failed for $IMAGE_NAME"
    fi

    echo ""
done

# Save new version
echo "$NEW_VERSION" > "$VERSION_FILE"

echo "================================================"
echo "All services built with tag: $TAG"
echo "Version saved: $NEW_VERSION"
echo "================================================"

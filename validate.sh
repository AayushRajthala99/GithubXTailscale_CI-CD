#!/bin/bash

echo "🚀 Starting validation of GithubXTailscale_CI-CD project..."

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo "❌ Docker is not running. Please start Docker first."
    exit 1
fi

echo "✅ Docker is running"

# Check if docker-compose is available
if ! command -v docker compose &> /dev/null; then
    echo "❌ Docker Compose is not available"
    exit 1
fi

echo "✅ Docker Compose is available"

# Build the images
echo "📦 Building Docker images..."
if ! docker compose build; then
    echo "❌ Failed to build Docker images"
    exit 1
fi

echo "✅ Docker images built successfully"

# Start the services
echo "🏃 Starting services..."
if ! docker compose up -d; then
    echo "❌ Failed to start services"
    exit 1
fi

echo "✅ Services started"

# Wait for backend health check
echo "⏳ Waiting for backend to be healthy..."
sleep 10

# Check backend health
for i in {1..30}; do
    if curl -f http://localhost:5000/health > /dev/null 2>&1; then
        echo "✅ Backend is healthy"
        break
    fi
    if [ $i -eq 30 ]; then
        echo "❌ Backend failed to become healthy"
        docker compose logs backend
        docker compose down
        exit 1
    fi
    sleep 2
done

# Check frontend
echo "🌐 Checking frontend..."
if curl -f http://localhost:3000 > /dev/null 2>&1; then
    echo "✅ Frontend is accessible"
else
    echo "⚠️  Frontend may still be starting..."
fi

# Show running containers
echo ""
echo "📊 Running containers:"
docker compose ps

echo ""
echo "✨ Validation complete! Services are running:"
echo "   Frontend: http://localhost:3000"
echo "   Backend:  http://localhost:5000"
echo "   Health:   http://localhost:5000/health"
echo ""
echo "To stop services: docker compose down"
echo "To view logs: docker compose logs -f"

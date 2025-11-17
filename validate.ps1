# PowerShell validation script for Windows

Write-Host "🚀 Starting validation of GithubXTailscale_CI-CD project..." -ForegroundColor Cyan

# Check if Docker is running
try {
    docker info | Out-Null
    Write-Host "✅ Docker is running" -ForegroundColor Green
}
catch {
    Write-Host "❌ Docker is not running. Please start Docker first." -ForegroundColor Red
    exit 1
}

# Check if docker compose is available
try {
    docker compose version | Out-Null
    Write-Host "✅ Docker Compose is available" -ForegroundColor Green
}
catch {
    Write-Host "❌ Docker Compose is not available" -ForegroundColor Red
    exit 1
}

# Build the images
Write-Host "📦 Building Docker images..." -ForegroundColor Cyan
docker compose build
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Failed to build Docker images" -ForegroundColor Red
    exit 1
}
Write-Host "✅ Docker images built successfully" -ForegroundColor Green

# Start the services
Write-Host "🏃 Starting services..." -ForegroundColor Cyan
docker compose up -d
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Failed to start services" -ForegroundColor Red
    exit 1
}
Write-Host "✅ Services started" -ForegroundColor Green

# Wait for backend health check
Write-Host "⏳ Waiting for backend to be healthy..." -ForegroundColor Cyan
Start-Sleep -Seconds 10

# Check backend health
$healthy = $false
for ($i = 1; $i -le 30; $i++) {
    try {
        $response = Invoke-WebRequest -Uri "http://localhost:5000/health" -UseBasicParsing -ErrorAction Stop
        if ($response.StatusCode -eq 200) {
            Write-Host "✅ Backend is healthy" -ForegroundColor Green
            $healthy = $true
            break
        }
    }
    catch {
        Start-Sleep -Seconds 2
    }
}

if (-not $healthy) {
    Write-Host "❌ Backend failed to become healthy" -ForegroundColor Red
    docker compose logs backend
    docker compose down
    exit 1
}

# Check frontend
Write-Host "🌐 Checking frontend..." -ForegroundColor Cyan
try {
    $response = Invoke-WebRequest -Uri "http://localhost:3000" -UseBasicParsing -ErrorAction Stop
    Write-Host "✅ Frontend is accessible" -ForegroundColor Green
}
catch {
    Write-Host "⚠️  Frontend may still be starting..." -ForegroundColor Yellow
}

# Show running containers
Write-Host "`n📊 Running containers:" -ForegroundColor Cyan
docker compose ps

Write-Host "`n✨ Validation complete! Services are running:" -ForegroundColor Green
Write-Host "   Frontend: http://localhost:3000" -ForegroundColor White
Write-Host "   Backend:  http://localhost:5000" -ForegroundColor White
Write-Host "   Health:   http://localhost:5000/health" -ForegroundColor White
Write-Host "`nTo stop services: docker compose down" -ForegroundColor Yellow
Write-Host "To view logs: docker compose logs -f" -ForegroundColor Yellow

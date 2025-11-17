# GithubXTailscale_CI-CD

A full-stack application with automated CI/CD pipeline using GitHub Actions and Tailscale for secure deployments.

## Project Structure

```
├── backend/              # Python Flask API
│   ├── app.py
│   ├── Dockerfile
│   └── requirements.txt
├── frontend/             # React application
│   ├── src/
│   ├── public/
│   ├── Dockerfile
│   └── package.json
├── .github/
│   └── workflows/
│       └── master.yml    # CI/CD pipeline
└── docker-compose.yml    # Multi-container orchestration
```

## Features

- **Backend**: Python Flask API with CORS support, health checks, and production-ready Gunicorn server
- **Frontend**: React application with Nginx reverse proxy for API calls
- **Containerization**: Multi-stage Docker builds for optimized images
- **Orchestration**: Docker Compose with health checks and proper networking
- **CI/CD**: Automated builds and deployments via GitHub Actions
- **Security**: Tailscale integration for secure VM access

## Prerequisites

- Docker and Docker Compose
- Node.js 22+ (for local development)
- Python 3.12+ (for local development)
- Git

## Quick Start

### Using Docker Compose (Recommended)

1. Clone the repository:
```bash
git clone <repository-url>
cd GithubXTailscale_CI-CD
```

2. Build and run all services:
```bash
docker compose up -d --build
```

3. Access the application:
- Frontend: http://localhost:3000
- Backend API: http://localhost:5000
- Backend Health Check: http://localhost:5000/health

4. Stop the services:
```bash
docker compose down
```

### Local Development

#### Backend
```bash
cd backend
pip install -r requirements.txt
python app.py
```

#### Frontend
```bash
cd frontend
npm install
npm start
```

## CI/CD Pipeline

The GitHub Actions workflow (`.github/workflows/master.yml`) automatically:
1. Triggers on pushes to master branch affecting backend, frontend, or docker-compose files
2. Checks out the code
3. Builds and deploys all services using Docker Compose on a self-hosted runner with Tailscale

### Setting up CI/CD

1. Set up a self-hosted runner with the label `tailscaleCI-CD`
2. Ensure Docker and Docker Compose are installed on the runner
3. Configure Tailscale on the runner for secure access
4. Push changes to the master branch to trigger deployment

## Architecture

- **Frontend**: React app served by Nginx, proxies API requests to `/api/` → backend
- **Backend**: Flask app with Gunicorn, 4 workers, health check endpoint
- **Network**: Bridge network for container communication
- **Health Checks**: Backend has health checks ensuring frontend waits for backend to be ready

## Environment Variables

### Backend
- `FLASK_DEBUG`: Set to "true" for debug mode (default: false)

## API Endpoints

- `GET /`: Returns welcome message
- `GET /health`: Health check endpoint

## Docker Images

- **Backend**: Python 3.12-slim with Flask and Gunicorn
- **Frontend**: Multi-stage build (Node 22-alpine → Nginx 1.27-alpine)

## Production Considerations

✅ Multi-stage builds for smaller images  
✅ Health checks configured  
✅ Production WSGI server (Gunicorn)  
✅ Nginx reverse proxy  
✅ Proper networking and service dependencies  
✅ .dockerignore files to reduce build context  
✅ Restart policies configured  

## Troubleshooting

### Containers won't start
```bash
docker compose logs
```

### Frontend can't reach backend
- Check if both containers are on the same network
- Verify nginx.conf proxy settings
- Check backend health: `docker compose exec backend curl http://localhost:5000/health`

### Rebuild from scratch
```bash
docker compose down -v
docker compose build --no-cache
docker compose up -d
```

## License

MIT
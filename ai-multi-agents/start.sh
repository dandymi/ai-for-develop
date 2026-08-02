#!/bin/bash
# AI Multi-Agent Platform Startup Script
# Supports both V1 (Basic) and V2 (Full Production) stacks

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to validate .env file
validate_env() {
    print_info "Validating .env file..."
    
    if [ ! -f .env ]; then
        print_error ".env file not found! Please create one from .env.example"
        exit 1
    fi
    
    # Source the .env file
    set -a
    source .env
    set +a
    
    # Check API keys based on version
    if [ "$VERSION" == "v2" ]; then
        if [ "$OPENROUTER_API_KEY" == "sk-or-v1-your_openrouter_key_here" ] || [ -z "$OPENROUTER_API_KEY" ]; then
            print_error "OpenRouter API key not configured!"
            print_info "Please edit .env and set OPENROUTER_API_KEY"
            print_info "Get your key at: https://openrouter.ai/keys"
            exit 1
        fi
        print_success "OpenRouter API key configured"
    else
        if [ "$OPENAI_API_KEY" == "sk-your_openai_key_here" ] || [ -z "$OPENAI_API_KEY" ]; then
            print_error "OpenAI API key not configured!"
            print_info "Please edit .env and set OPENAI_API_KEY"
            print_info "Get your key at: https://platform.openai.com/api-keys"
            exit 1
        fi
        print_success "OpenAI API key configured"
    fi
}

# Function to create required directories
create_directories() {
    print_info "Creating required directories..."
    mkdir -p workspace
    mkdir -p monitoring/grafana/dashboards
    mkdir -p monitoring/grafana/datasources
    print_success "Directories created"
}

# Function to check system requirements
check_requirements() {
    print_info "Checking system requirements..."
    
    # Check Docker
    if ! command_exists docker; then
        print_error "Docker is not installed!"
        print_info "Install from: https://docs.docker.com/get-docker/"
        exit 1
    fi
    print_success "Docker found: $(docker --version)"
    
    # Check Docker Compose
    if ! command_exists docker-compose; then
        print_error "Docker Compose is not installed!"
        exit 1
    fi
    print_success "Docker Compose found: $(docker-compose --version)"
    
    # Check available memory
    if command_exists free; then
        AVAILABLE_MEM=$(free -g | awk '/^Mem:/{print $7}')
        print_info "Available memory: ${AVAILABLE_MEM}GB"
        if [ "$AVAILABLE_MEM" -lt 4 ]; then
            print_warning "Low memory detected. Minimum 4GB recommended."
        fi
    fi
    
    # Check disk space
    DISK_SPACE=$(df -BG . | awk 'NR==2 {print $4}' | sed 's/G//')
    print_info "Available disk space: ${DISK_SPACE}GB"
    if [ "$DISK_SPACE" -lt 20 ]; then
        print_warning "Low disk space. Minimum 20GB recommended."
    fi
}

# Function to start V1 stack
start_v1() {
    print_info "Starting V1 (Basic) Stack..."
    print_info "Components: Multica, Hermes, 3 OpenClaw agents"
    
    docker-compose down 2>/dev/null || true
    docker-compose up -d
    
    print_success "V1 Stack started!"
    echo ""
    print_info "Access URLs:"
    echo "  - Multica:     http://localhost:3000"
    echo "  - Hermes:      http://localhost:8080"
    echo ""
}

# Function to start V2 stack
start_v2() {
    print_info "Starting V2 (Full Production) Stack..."
    print_info "Components: Traefik, Multica, Hermes, Honcho, Ollama, 7 Agents, Monitoring"
    
    docker-compose -f docker-compose-v2.yml down 2>/dev/null || true
    docker-compose -f docker-compose-v2.yml up -d
    
    print_success "V2 Stack started!"
    echo ""
    print_info "Access URLs:"
    echo "  - Multica:     http://multica.localhost (add to /etc/hosts if needed)"
    echo "  - Grafana:     http://grafana.localhost (admin/admin123)"
    echo "  - Traefik:     http://localhost:8080"
    echo ""
    print_warning "Remember to pull Ollama models: ./start.sh pull-models"
}

# Function to pull Ollama models
pull_models() {
    print_info "Pulling Ollama models (this may take several minutes)..."
    
    # Check if ollama containers are running
    if ! docker ps | grep -q "ollama-main"; then
        print_error "Ollama containers not running! Start V2 stack first."
        exit 1
    fi
    
    print_info "Pulling deepseek-coder:33b on ollama-main..."
    docker exec -it ai-company-v2-ollama-main-1 ollama pull deepseek-coder:33b
    
    print_info "Pulling mistral:7b on ollama-main..."
    docker exec -it ai-company-v2-ollama-main-1 ollama pull mistral:7b
    
    print_info "Pulling qwen2.5-coder:14b on ollama-worker2..."
    docker exec -it ai-company-v2-ollama-worker2-1 ollama pull qwen2.5-coder:14b
    
    print_info "Pulling llama3.1:8b on ollama-worker2..."
    docker exec -it ai-company-v2-ollama-worker2-1 ollama pull llama3.1:8b
    
    print_success "All models pulled successfully!"
}

# Function to show status
show_status() {
    print_info "Container Status:"
    if docker ps | grep -q "ai-company"; then
        docker-compose -f docker-compose-v2.yml ps 2>/dev/null || docker-compose ps
    else
        print_warning "No containers running"
    fi
}

# Function to show logs
show_logs() {
    SERVICE=${1:-hermes}
    print_info "Showing logs for $SERVICE..."
    if [ -f docker-compose-v2.yml ] && docker ps | grep -q "ai-company-v2"; then
        docker-compose -f docker-compose-v2.yml logs -f "$SERVICE"
    else
        docker-compose logs -f "$SERVICE"
    fi
}

# Function to stop all containers
stop_all() {
    print_info "Stopping all containers..."
    docker-compose down 2>/dev/null || true
    docker-compose -f docker-compose-v2.yml down 2>/dev/null || true
    print_success "All containers stopped"
}

# Function to clean up everything
cleanup() {
    print_warning "This will remove all containers, volumes, and data!"
    read -p "Are you sure? (yes/no): " confirm
    if [ "$confirm" == "yes" ]; then
        docker-compose down -v 2>/dev/null || true
        docker-compose -f docker-compose-v2.yml down -v 2>/dev/null || true
        docker system prune -f
        print_success "Cleanup complete"
    else
        print_info "Cleanup cancelled"
    fi
}

# Main menu
show_menu() {
    echo ""
    echo "========================================"
    echo "  AI Multi-Agent Platform Manager"
    echo "========================================"
    echo ""
    echo "Usage: ./start.sh [command] [options]"
    echo ""
    echo "Commands:"
    echo "  v1                  Start V1 (Basic) stack"
    echo "  v2                  Start V2 (Full Production) stack"
    echo "  pull-models         Pull Ollama models (V2 only)"
    echo "  status              Show container status"
    echo "  logs [service]      Show logs for a service (default: hermes)"
    echo "  stop                Stop all containers"
    echo "  cleanup             Remove all containers and volumes"
    echo "  check               Check system requirements"
    echo "  help                Show this help message"
    echo ""
    echo "Examples:"
    echo "  ./start.sh v1                    # Start basic stack"
    echo "  ./start.sh v2                    # Start production stack"
    echo "  ./start.sh pull-models           # Download Ollama models"
    echo "  ./start.sh logs hermes           # View Hermes logs"
    echo ""
}

# Main script logic
main() {
    case "${1:-help}" in
        v1)
            VERSION=v1
            check_requirements
            create_directories
            validate_env
            start_v1
            show_status
            ;;
        v2)
            VERSION=v2
            check_requirements
            create_directories
            validate_env
            start_v2
            show_status
            ;;
        pull-models)
            pull_models
            ;;
        status)
            show_status
            ;;
        logs)
            show_logs "${2:-hermes}"
            ;;
        stop)
            stop_all
            ;;
        cleanup)
            cleanup
            ;;
        check)
            check_requirements
            create_directories
            print_success "System check complete!"
            ;;
        help|--help|-h)
            show_menu
            ;;
        *)
            print_error "Unknown command: $1"
            show_menu
            exit 1
            ;;
    esac
}

main "$@"

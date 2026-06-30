#!/bin/bash

# Multi-Agent System Guided Setup
# Helps configure customers and projects for a multi-agent Hermes system

set -euo pipefail

# Configuration
BASE_DIR="$HOME/.hermes/multi-agent"
CUSTOMERS_DIR="$BASE_DIR/customers"
PROJECTS_DIR="$BASE_DIR/projects"

# Initialize directories
init_directories() {
    mkdir -p "$CUSTOMERS_DIR"
    mkdir -p "$PROJECTS_DIR"
    echo "Initialized multi-agent system directories at $BASE_DIR"
}

# Customer management
add_customer() {
    read -p "Enter customer ID: " customer_id
    read -p "Enter customer name: " customer_name
    read -p "Enter customer description: " customer_desc
    
    customer_file="$CUSTOMERS_DIR/$customer_id.json"
    if [[ -f "$customer_file" ]]; then
        echo "Customer $customer_id already exists!"
        return 1
    fi
    
    cat > "$customer_file" <<EOF
{
    "id": "$customer_id",
    "name": "$customer_name",
    "description": "$customer_desc",
    "created_at": "$(date -Iseconds)",
    "projects": []
}
EOF
    echo "Customer $customer_id added successfully."
}

list_customers() {
    echo "=== Customers ==="
    ls "$CUSTOMERS_DIR"/*.json 2>/dev/null | while read -r file; do
        if [[ -f "$file" ]]; then
            id=$(basename "$file" .json)
            name=$(jq -r '.name // "N/A"' "$file" 2>/dev/null || echo "N/A")
            echo "ID: $id | Name: $name"
        fi
    done
    if [[ ! "$(ls -A "$CUSTOMERS_DIR"/*.json 2>/dev/null)" ]]; then
        echo "No customers found."
    fi
}

modify_customer() {
    list_customers
    read -p "Enter customer ID to modify: " customer_id
    customer_file="$CUSTOMERS_DIR/$customer_id.json"
    if [[ ! -f "$customer_file" ]]; then
        echo "Customer $customer_id not found!"
        return 1
    fi
    
    echo "Current customer details:"
    jq '.' "$customer_file"
    
    read -p "Enter new name (leave blank to keep current): " new_name
    read -p "Enter new description (leave blank to keep current): " new_desc
    
    # Update fields if provided
    if [[ -n "$new_name" ]]; then
        jq --arg name "$new_name" '.name = $name' "$customer_file" > "${customer_file}.tmp" && mv "${customer_file}.tmp" "$customer_file"
    fi
    if [[ -n "$new_desc" ]]; then
        jq --arg desc "$new_desc" '.description = $desc' "$customer_file" > "${customer_file}.tmp" && mv "${customer_file}.tmp" "$customer_file"
    fi
    
    echo "Customer $customer_id updated successfully."
}

delete_customer() {
    list_customers
    read -p "Enter customer ID to delete: " customer_id
    customer_file="$CUSTOMERS_DIR/$customer_id.json"
    if [[ ! -f "$customer_file" ]]; then
        echo "Customer $customer_id not found!"
        return 1
    fi
    
    # Check if customer has projects
    project_count=$(jq '.projects | length' "$customer_file" 2>/dev/null || echo "0")
    if [[ "$project_count" -gt 0 ]]; then
        echo "Customer $customer_id has $project_count projects. Delete them first or reassign."
        return 1
    fi
    
    read -p "Are you sure you want to delete customer $customer_id? (y/N): " confirm
    if [[ "$confirm" =~ ^[Yy]$ ]]; then
        rm "$customer_file"
        echo "Customer $customer_id deleted."
    else
        echo "Deletion cancelled."
    fi
}

# Project management
add_project() {
    list_customers
    read -p "Enter customer ID for this project: " customer_id
    customer_file="$CUSTOMERS_DIR/$customer_id.json"
    if [[ ! -f "$customer_file" ]]; then
        echo "Customer $customer_id not found!"
        return 1
    fi
    
    read -p "Enter project ID: " project_id
    read -p "Enter project name: " project_name
    read -p "Enter project description: " project_desc
    read -p "Enter Hermes profile to use (optional): " hermes_profile
    
    project_file="$PROJECTS_DIR/$project_id.json"
    if [[ -f "$project_file" ]]; then
        echo "Project $project_id already exists!"
        return 1
    fi
    
    cat > "$project_file" <<EOF
{
    "id": "$project_id",
    "customer_id": "$customer_id",
    "name": "$project_name",
    "description": "$project_desc",
    "hermes_profile": "${hermes_profile:-}",
    "created_at": "$(date -Iseconds)",
    "status": "active"
}
EOF
    
    # Add project reference to customer
    jq --arg pid "$project_id" '.projects += [$pid]' "$customer_file" > "${customer_file}.tmp" && mv "${customer_file}.tmp" "$customer_file"
    
    echo "Project $project_id added to customer $customer_id."
}

list_projects() {
    echo "=== Projects ==="
    ls "$PROJECTS_DIR"/*.json 2>/dev/null | while read -r file; do
        if [[ -f "$file" ]]; then
            id=$(basename "$file" .json)
            customer_id=$(jq -r '.customer_id // "N/A"' "$file" 2>/dev/null || echo "N/A")
            name=$(jq -r '.name // "N/A"' "$file" 2>/dev/null || echo "N/A")
            status=$(jq -r '.status // "N/A"' "$file" 2>/dev/null || echo "N/A")
            echo "ID: $id | Customer: $customer_id | Name: $name | Status: $status"
        fi
    done
    if [[ ! "$(ls -A "$PROJECTS_DIR"/*.json 2>/dev/null)" ]]; then
        echo "No projects found."
    fi
}

modify_project() {
    list_projects
    read -p "Enter project ID to modify: " project_id
    project_file="$PROJECTS_DIR/$project_id.json"
    if [[ ! -f "$project_file" ]]; then
        echo "Project $project_id not found!"
        return 1
    fi
    
    echo "Current project details:"
    jq '.' "$project_file"
    
    read -p "Enter new name (leave blank to keep current): " new_name
    read -p "Enter new description (leave blank to keep current): " new_desc
    read -p "Enter new Hermes profile (leave blank to keep current): " new_profile
    read -p "Enter new status (active/inactive/completed) (leave blank to keep current): " new_status
    
    # Update fields if provided
    if [[ -n "$new_name" ]]; then
        jq --arg name "$new_name" '.name = $name' "$project_file" > "${project_file}.tmp" && mv "${project_file}.tmp" "$project_file"
    fi
    if [[ -n "$new_desc" ]]; then
        jq --arg desc "$new_desc" '.description = $desc' "$project_file" > "${project_file}.tmp" && mv "${project_file}.tmp" "$project_file"
    fi
    if [[ -n "$new_profile" ]]; then
        jq --arg profile "$new_profile" '.hermes_profile = $profile' "$project_file" > "${project_file}.tmp" && mv "${project_file}.tmp" "$project_file"
    fi
    if [[ -n "$new_status" ]]; then
        jq --arg status "$new_status" '.status = $status' "$project_file" > "${project_file}.tmp" && mv "${project_file}.tmp" "$project_file"
    fi
    
    echo "Project $project_id updated successfully."
}

delete_project() {
    list_projects
    read -p "Enter project ID to delete: " project_id
    project_file="$PROJECTS_DIR/$project_id.json"
    if [[ ! -f "$project_file" ]]; then
        echo "Project $project_id not found!"
        return 1
    fi
    
    # Get customer ID to remove reference
    customer_id=$(jq -r '.customer_id' "$project_file" 2>/dev/null)
    
    read -p "Are you sure you want to delete project $project_id? (y/N): " confirm
    if [[ "$confirm" =~ ^[Yy]$ ]]; then
        # Remove project reference from customer
        if [[ -n "$customer_id" && -f "$CUSTOMERS_DIR/$customer_id.json" ]]; then
            jq --arg pid "$project_id" 'del(.projects[] | select(. == $pid))' "$CUSTOMERS_DIR/$customer_id.json" > "${CUSTOMERS_DIR/$customer_id.json}.tmp" && mv "${CUSTOMERS_DIR/$customer_id.json}.tmp" "$CUSTOMERS_DIR/$customer_id.json"
        fi
        
        rm "$project_file"
        echo "Project $project_id deleted."
    else
        echo "Deletion cancelled."
    fi
}

# Hermes integration helpers
hermes_profile_setup() {
    echo "=== Hermes Profile Setup ==="
    echo "This helper guides you through creating a Hermes profile for a project."
    echo
    read -p "Enter profile name: " profile_name
    read -p "Enter model (default: anthropic/claude-sonnet-4): " model
    model=${model:-anthropic/claude-sonnet-4}
    read -p "Enter provider (default: anthropic): " provider
    provider=${provider:-anthropic}
    
    # Create profile directory
    profile_dir="$HOME/.hermes/profiles/$profile_name"
    mkdir -p "$profile_dir"
    
    # Create basic config.yaml
    cat > "$profile_dir/config.yaml" <<EOF
model:
  default: $model
  provider: $provider
agent:
  max_turns: 90
terminal:
  backend: local
  timeout: 180
display:
  skin: default
  tool_progress: true
memory:
  memory_enabled: true
  user_profile_enabled: true
delegation:
  model: $model
  provider: $provider
  max_iterations: 50
EOF
    
    # Create .env if needed (commented for security)
    cat > "$profile_dir/env.example" <<EOF
# Copy to .env and fill in your API keys
# $provider API key:
# ${provider^^}_API_KEY=your_key_here
EOF
    
    echo "Hermes profile '$profile_name' created at $profile_dir"
    echo "Remember to:"
    echo "1. Copy env.example to .env and add your API keys"
    echo "2. Test the profile with: hermes -p $profile_name"
}

# Main menu
main_menu() {
    while true; do
        echo
        echo "=== Multi-Agent System Guided Setup ==="
        echo "1) Initialize directories"
        echo "2) Customer Management"
        echo "3) Project Management"
        echo "4) Hermes Profile Helper"
        echo "5) View System Status"
        echo "6) Exit"
        echo
        read -p "Select an option: " choice
        
        case $choice in
            1) init_directories ;;
            2) customer_menu ;;
            3) project_menu ;;
            4) hermes_profile_setup ;;
            5) show_status ;;
            6) echo "Goodbye!"; break ;;
            *) echo "Invalid option. Please try again." ;;
        esac
    done
}

customer_menu() {
    while true; do
        echo
        echo "=== Customer Management ==="
        echo "1) Add customer"
        echo "2) List customers"
        echo "3) Modify customer"
        echo "4) Delete customer"
        echo "5) Back to main menu"
        echo
        read -p "Select an option: " choice
        
        case $choice in
            1) add_customer ;;
            2) list_customers ;;
            3) modify_customer ;;
            4) delete_customer ;;
            5) break ;;
            *) echo "Invalid option. Please try again." ;;
        esac
    done
}

project_menu() {
    while true; do
        echo
        echo "=== Project Management ==="
        echo "1) Add project"
        echo "2) List projects"
        echo "3) Modify project"
        echo "4) Delete project"
        echo "5) Back to main menu"
        echo
        read -p "Select an option: " choice
        
        case $choice in
            1) add_project ;;
            2) list_projects ;;
            3) modify_project ;;
            4) delete_project ;;
            5) break ;;
            *) echo "Invalid option. Please try again." ;;
        esac
    done
}

show_status() {
    echo
    echo "=== Multi-Agent System Status ==="
    echo "Base directory: $BASE_DIR"
    echo
    echo "Customers: $(ls -1 "$CUSTOMERS_DIR"/*.json 2>/dev/null | wc -l)"
    echo "Projects: $(ls -1 "$PROJECTS_DIR"/*.json 2>/dev/null | wc -l)"
    echo
    echo "Recent customers:"
    list_customers | head -5
    echo
    echo "Recent projects:"
    list_projects | head -5
}

# Check dependencies
check_dependencies() {
    if ! command -v jq &> /dev/null; then
        echo "Error: jq is required but not installed."
        echo "Please install jq (e.g., sudo apt install jq)"
        exit 1
# Check dependencies
check_dependencies() {
    if ! command -v jq &> /dev/null; then
        echo "Error: jq is required but not installed."
        echo "Please install jq (e.g., sudo apt install jq)"
        exit 1
    fi
}

# Handle help flag
if [[ "${1:-}" == "--help" || "${1:-}" == "-h" ]]; then
    echo "Usage: $0 [options]"
    echo
    echo "Options:"
    echo "  --help, -h    Show this help message and exit"
    echo
    echo "Without options, runs the interactive menu."
    exit 0
fi

# Main execution
check_dependencies
main_menu


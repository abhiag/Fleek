#!/bin/bash

# Fleek CLI Menu-Driven Setup
# ---------------------------

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Variables
PROJECT_NAME=""
SITE_DIR="$HOME/fleek-quick-start"

# Check if command exists
command_exists() {
  command -v "$1" >/dev/null 2>&1
}

# Install Pre-Requirements
install_requirements() {
  echo -e "\n${YELLOW}📦 Installing Node.js and npm...${NC}"
  if ! command_exists node; then
    curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
    sudo apt-get install -y nodejs
  fi
  echo -e "${GREEN}✓ Node.js and npm ready${NC}"
}

# Install Fleek CLI and login
install_fleek() {
  echo -e "\n${YELLOW}⚡ Installing Fleek CLI...${NC}"
  sudo npm install -g @fleek-platform/cli
  echo -e "\n${BLUE}🔑 Please complete browser authentication...${NC}"
  fleek login
}

# Create Project
create_project() {
  echo -e "\n${YELLOW}🏗️ Creating Fleek Project${NC}"
  read -p "Enter project name: " PROJECT_NAME
  fleek projects create --name "$PROJECT_NAME"
}

# Setup Demo Page
setup_page() {
  echo -e "\n${YELLOW}🌐 Setting up demo page at $SITE_DIR${NC}"
  mkdir -p "$SITE_DIR"
  cd "$SITE_DIR" || exit
  echo "<!DOCTYPE html>
<html>
<head>
    <title>My Fleek Site</title>
    <style>body{font-family:sans-serif;text-align:center;margin-top:50px}</style>
</head>
<body>
    <h1>Hello from Fleek!</h1>
    <p>Deployed via Fleek CLI</p>
</body>
</html>" > index.html
  echo -e "${GREEN}✓ Demo page created${NC}"
}

# Deploy Site
deploy_site() {
  echo -e "\n${YELLOW}🚀 Initializing and deploying site${NC}"
  cd "$SITE_DIR" || exit
  fleek sites init <<< $'.\nno\n1\n'
  fleek sites deploy
  echo -e "\n${GREEN}✓ Deployment initiated!${NC}"
  echo -e "Check status with: ${BLUE}fleek sites list${NC}"
}

# Main Menu
show_menu() {
  clear
  echo -e "${BLUE}
  ███████╗██╗     ███████╗███████╗██╗  ██╗
  ██╔════╝██║     ██╔════╝██╔════╝██║ ██╔╝
  █████╗  ██║     █████╗  █████╗  █████╔╝ 
  ██╔══╝  ██║     ██╔══╝  ██╔══╝  ██╔═██╗ 
  ██║     ███████╗███████╗███████╗██║  ██╗
  ╚═╝     ╚══════╝╚══════╝╚══════╝╚═╝  ╚═╝
  ${NC}"
  echo -e "${YELLOW}1. Install Pre-Requirements${NC}"
  echo -e "${YELLOW}2. Install Fleek CLI & Login${NC}"
  echo -e "${YELLOW}3. Create a Fleek Project${NC}"
  echo -e "${YELLOW}4. Set Up a Simple Page${NC}"
  echo -e "${YELLOW}5. Initialize & Deploy Site${NC}"
  echo -e "${RED}0. Exit${NC}"
  echo -en "\n${BLUE}Select an option (0-5): ${NC}"
}

# Execute menu
while true; do
  show_menu
  read -r choice
  case $choice in
    1) install_requirements ;;
    2) install_fleek ;;
    3) create_project ;;
    4) setup_page ;;
    5) deploy_site ;;
    0) echo -e "\n${GREEN}Exiting...${NC}"; exit 0 ;;
    *) echo -e "\n${RED}Invalid option!${NC}" ;;
  esac
  echo -en "\n${BLUE}Press Enter to continue...${NC}"
  read -r
done

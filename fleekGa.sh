#!/bin/bash

# Fleek CLI Automated Setup Script
# -----------------------------------------------
# Installs prerequisites, Fleek CLI, and deploys a demo site

# Colors and formatting
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color
BOLD='\033[1m'

# Function to check command success
check_success() {
  if [ $? -ne 0 ]; then
    echo -e "${RED}✖ Failed: $1${NC}"
    exit 1
  else
    echo -e "${GREEN}✓ Success: $1${NC}"
  fi
}

echo -e "\n${YELLOW}🚀 Starting Fleek CLI Setup...${NC}"
echo "-----------------------------------------------"

# Section 1: Check for Node.js
echo -e "\n${YELLOW}📦 Checking Node.js installation...${NC}"
if ! command -v node &> /dev/null; then
  echo -e "${YELLOW}Node.js not found. Installing...${NC}"
  curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
  sudo apt-get install -y nodejs
  check_success "Node.js installed"
else
  echo -e "${GREEN}Node.js already installed.$(tput sgr0)"
fi

# Section 2: Install Fleek CLI
echo -e "\n${YELLOW}⚡ Installing Fleek CLI...${NC}"
sudo npm install -g @fleek-platform/cli
check_success "Fleek CLI installed"

# Section 3: Fleek Login
echo -e "\n${YELLOW}🔑 Initiating Fleek Login...${NC}"
echo -e "${BOLD}⚠️  MANUAL STEP REQUIRED: Complete browser authentication${NC}"
fleek login
check_success "Login successful"

# Section 4: Create Project
echo -e "\n${YELLOW}🏗️  Creating Fleek Project...${NC}"
read -p "Enter project name: " project_name
fleek projects create --name "$project_name"
check_success "Project created"

# Section 5: Setup Demo Site
echo -e "\n${YELLOW}🌐 Setting up demo site...${NC}"
mkdir -p ~/fleek-quick-start
cd ~/fleek-quick-start
echo "Hello World from Fleek!" > index.html
check_success "Demo files created"

# Section 6: Deploy Site
echo -e "\n${YELLOW}🚀 Deploying to Fleek...${NC}"
fleek sites init <<< $'.\nno\n'
fleek sites deploy
check_success "Deployment initiated"

# Completion
echo -e "\n${GREEN}🎉 Fleek setup completed successfully!${NC}"
echo -e "Your site is now deploying - check status with:"
echo -e "${BOLD}fleek sites list${NC}"
echo -e "\n${YELLOW}Note: Deployment may take 2-5 minutes to go live.${NC}"

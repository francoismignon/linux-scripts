#!/bin/bash

# 🚀 Script interactif pour gérer un projet Node.js dans Docker

PROJECT_DIR=$(pwd)
NODE_MODULES_DIR="$PROJECT_DIR/node_modules"
DEFAULT_COMMAND="npm run dev"

# 📦 Vérifie si node_modules existe
function check_node_modules {
  if [ ! -d "$NODE_MODULES_DIR" ]; then
    echo "📦 node_modules non trouvé. Installation des dépendances..."
    docker run --rm -it \
      -v "$PROJECT_DIR":/app \
      -v "$PROJECT_DIR/node_modules":/app/node_modules \
      -w /app \
      -p 3000:3000\
      node:latest \
      npm install
  fi
}

# 🚀 Lancer le projet
function run_project {
  CMD=$1
  echo "🚀 Lancement avec : $CMD"
  docker run --rm -it \
    -v "$PROJECT_DIR":/app \
    -v "$PROJECT_DIR/node_modules":/app/node_modules \
    -w /app \
    -p 3000:3000\
    node:latest \
    $CMD
}

# 📋 Vérifier les mises à jour
function check_updates {
  echo "📋 Modules obsolètes :"
  docker run --rm -it \
    -v "$PROJECT_DIR":/app \
    -w /app \
    -p 3000:3000\
    node:latest \
    npm outdated
}

# 🔄 Mettre à jour les modules
function update_dependencies {
  echo "🔄 Mise à jour de package.json + installation"
  docker run --rm -it \
    -v "$PROJECT_DIR":/app \
    -w /app \
    -p 3000:3000\
    node:latest \
    bash -c "npx npm-check-updates -u && npm install"
}

# 🎛️ Menu interactif
while true; do
  echo ""
  echo "=== Menu Node.js (Docker) ==="
  echo "1) Lancer avec npm run dev"
  echo "2) Lancer avec npm start"
  echo "3) Vérifier les mises à jour"
  echo "4) Mettre à jour les dépendances"
  echo "5) Quitter"
  echo "Choisis une option : "
  read -r choice

  case $choice in
    1)
      check_node_modules
      run_project "npm run dev"
      ;;
    2)
      check_node_modules
      run_project "npm start"
      ;;
    3)
      check_updates
      ;;
    4)
      update_dependencies
      ;;
    5)
      echo "👋 À bientôt !"
      break
      ;;
    *)
      echo "❌ Option invalide, réessaye..."
      ;;
  esac
done

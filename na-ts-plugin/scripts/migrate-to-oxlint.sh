#!/bin/bash
# Migrate from ESLint/Prettier to oxlint/oxfmt
# Handles package installation and basic script updates
# Platform: Linux/macOS/Windows (Git Bash/WSL)

set -euo pipefail

echo "=== Migrating to oxlint + oxfmt ==="

# Check if jq is available (required for package.json manipulation)
if ! command -v jq &> /dev/null; then
  echo "ERROR: jq not found. Falling back to manual migration."
  echo ""
  echo "Claude: Please handle this migration manually:"
  echo "1. Install oxlint: npm install -D oxlint (or pnpm/yarn/bun)"
  echo "2. Update scripts in package.json:"
  echo '   "lint": "oxlint src"'
  echo '   "format": "oxfmt src"'
  echo "3. Test: npm run lint"
  exit 1
fi

# Detect package manager
if [ -f "pnpm-lock.yaml" ]; then
  PKG_MGR="pnpm"
elif [ -f "yarn.lock" ]; then
  PKG_MGR="yarn"
elif [ -f "bun.lockb" ]; then
  PKG_MGR="bun"
else
  PKG_MGR="npm"
fi

echo "Detected package manager: $PKG_MGR"

# Install oxlint
echo "Installing oxlint..."
case $PKG_MGR in
  pnpm)
    pnpm add -D oxlint
    ;;
  yarn)
    yarn add -D oxlint
    ;;
  bun)
    bun add -D oxlint
    ;;
  *)
    npm install -D oxlint
    ;;
esac

# Update package.json scripts
echo "Updating scripts..."

# Backup package.json
cp package.json package.json.backup

# Update lint script
if grep -q '"lint"' package.json; then
  # Replace common ESLint patterns with oxlint
  sed -i.tmp 's/"lint": "eslint[^"]*"/"lint": "oxlint src"/' package.json
  sed -i.tmp 's/"lint": "eslint [^"]*"/"lint": "oxlint src"/' package.json
  rm -f package.json.tmp
else
  # Add lint script if not present
  jq '.scripts.lint = "oxlint src"' package.json > package.json.tmp
  mv package.json.tmp package.json
fi

# Update format script
if grep -q '"format"' package.json; then
  sed -i.tmp 's/"format": "prettier[^"]*"/"format": "oxfmt src"/' package.json
  rm -f package.json.tmp
else
  jq '.scripts.format = "oxfmt src"' package.json > package.json.tmp
  mv package.json.tmp package.json
fi

# Add format:check if not present
if ! grep -q '"format:check"' package.json; then
  jq '.scripts["format:check"] = "oxfmt --check src"' package.json > package.json.tmp
  mv package.json.tmp package.json
fi

echo "✓ oxlint installed and scripts updated"
echo ""
echo "Next steps for Claude:"
echo "1. Review and migrate .eslintrc configuration to oxlint"
echo "2. Test linting on the codebase"
echo "3. Update CI/CD configuration"
echo "4. After verification, remove ESLint/Prettier:"
echo "   $PKG_MGR remove eslint prettier @typescript-eslint/*"
echo ""
echo "Backup saved to: package.json.backup"

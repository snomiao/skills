#!/bin/bash
# Migrate from Vite/Rollup/webpack to tsdown
# Handles package installation and basic script updates
# Platform: Linux/macOS/Windows (Git Bash/WSL)

set -euo pipefail

echo "=== Migrating to tsdown ==="

# Check if jq is available
if ! command -v jq &> /dev/null; then
  echo "ERROR: jq not found. Falling back to manual migration."
  echo ""
  echo "Claude: Please handle this migration manually:"
  echo "1. Install tsdown: npm install -D tsdown"
  echo "2. Update scripts in package.json:"
  echo '   "build": "tsdown src/index.ts"'
  echo '   "dev": "tsdown src/index.ts --watch"'
  echo "3. Test: npm run build"
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

# Detect entry point from package.json
ENTRY_POINT="src/index.ts"
if [ -f "package.json" ]; then
  # Try to find main/module field
  MAIN=$(jq -r '.main // empty' package.json)
  if [ -n "$MAIN" ]; then
    # Convert dist path to src path
    ENTRY_POINT=$(echo "$MAIN" | sed 's/dist/src/;s/\.js$/.ts/')
  fi
fi

echo "Using entry point: $ENTRY_POINT"

# Install tsdown
echo "Installing tsdown..."
case $PKG_MGR in
  pnpm)
    pnpm add -D tsdown
    ;;
  yarn)
    yarn add -D tsdown
    ;;
  bun)
    bun add -D tsdown
    ;;
  *)
    npm install -D tsdown
    ;;
esac

# Backup package.json
cp package.json package.json.backup

# Update build script
if grep -q '"build"' package.json; then
  # Replace common bundler patterns with tsdown
  jq --arg entry "$ENTRY_POINT" '.scripts.build = "tsdown \($entry)"' package.json > package.json.tmp
  mv package.json.tmp package.json
else
  jq --arg entry "$ENTRY_POINT" '.scripts.build = "tsdown \($entry)"' package.json > package.json.tmp
  mv package.json.tmp package.json
fi

# Add dev script if not present
if ! grep -q '"dev"' package.json; then
  jq --arg entry "$ENTRY_POINT" '.scripts.dev = "tsdown \($entry) --watch"' package.json > package.json.tmp
  mv package.json.tmp package.json
fi

echo "✓ tsdown installed and scripts updated"
echo ""
echo "Next steps for Claude:"
echo "1. Review build configuration (may need tsdown.config.ts for complex setups)"
echo "2. Test build output and compare with previous bundler"
echo "3. Update any build-related configs (e.g., paths, externals)"
echo "4. Update CI/CD configuration"
echo "5. After verification, remove old bundler:"
echo "   $PKG_MGR remove vite rollup webpack"
echo ""
echo "Backup saved to: package.json.backup"

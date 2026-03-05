#!/bin/bash
# Migrate to @typescript/native-preview
# Handles package installation

set -euo pipefail

echo "=== Migrating to @typescript/native-preview ==="

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

# Install @typescript/native-preview
echo "Installing @typescript/native-preview..."
case $PKG_MGR in
  pnpm)
    pnpm add -D @typescript/native-preview
    ;;
  yarn)
    yarn add -D @typescript/native-preview
    ;;
  bun)
    bun add -D @typescript/native-preview
    ;;
  *)
    npm install -D @typescript/native-preview
    ;;
esac

# Note: tsc command works the same, no script changes needed
echo "✓ @typescript/native-preview installed"
echo ""
echo "Next steps for Claude:"
echo "1. Test type checking: npm run typecheck (or tsc --noEmit)"
echo "2. Verify IDE integration still works"
echo "3. Update CI/CD if needed"
echo "4. Keep 'typescript' package (still needed for language support)"
echo ""
echo "Note: @typescript/native-preview works as a drop-in replacement for tsc"
echo "No script changes needed - it uses the same command interface"

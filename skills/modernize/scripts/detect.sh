#!/bin/bash
# Environment Detection Script
# Outputs JSON with current toolchain info
# Cross-platform: Works on Linux/macOS/Windows (Git Bash/WSL)

set -euo pipefail

# Detect Windows and warn if not in bash environment
if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "win32" ]]; then
  # Running in Git Bash on Windows - OK
  :
elif [[ "$(uname -s)" == MINGW* || "$(uname -s)" == CYGWIN* ]]; then
  # Running in MinGW/Cygwin - OK
  :
fi

# Check if we're in a Node.js project
if [ ! -f "package.json" ]; then
  echo '{"error": "No package.json found", "isNodeProject": false}'
  exit 0
fi

# Function to check if a package is installed
has_package() {
  grep -q "\"$1\"" package.json 2>/dev/null
}

# Function to get package version
get_version() {
  grep "\"$1\"" package.json | head -1 | sed 's/.*"'"$1"'": "//;s/".*//' 2>/dev/null || echo "unknown"
}

# Function to check script existence
has_script() {
  grep -q "\"$1\":" package.json 2>/dev/null
}

# Function to get script command
get_script() {
  grep "\"$1\":" package.json | head -1 | sed 's/.*"'"$1"'": "//;s/".*//' 2>/dev/null || echo ""
}

# Detect linters
LINTERS='[]'
if has_package "eslint"; then
  LINTERS=$(echo "$LINTERS" | jq '. + [{"name": "eslint", "version": "'"$(get_version eslint)"'"}]')
fi
if has_package "prettier"; then
  LINTERS=$(echo "$LINTERS" | jq '. + [{"name": "prettier", "version": "'"$(get_version prettier)"'"}]')
fi
if has_package "biome"; then
  LINTERS=$(echo "$LINTERS" | jq '. + [{"name": "biome", "version": "'"$(get_version biome)"'"}]')
fi
if has_package "oxlint"; then
  LINTERS=$(echo "$LINTERS" | jq '. + [{"name": "oxlint", "version": "'"$(get_version oxlint)"'"}]')
fi

# Detect bundlers
BUNDLERS='[]'
if has_package "vite"; then
  BUNDLERS=$(echo "$BUNDLERS" | jq '. + [{"name": "vite", "version": "'"$(get_version vite)"'"}]')
fi
if has_package "rollup"; then
  BUNDLERS=$(echo "$BUNDLERS" | jq '. + [{"name": "rollup", "version": "'"$(get_version rollup)"'"}]')
fi
if has_package "webpack"; then
  BUNDLERS=$(echo "$BUNDLERS" | jq '. + [{"name": "webpack", "version": "'"$(get_version webpack)"'"}]')
fi
if has_package "esbuild"; then
  BUNDLERS=$(echo "$BUNDLERS" | jq '. + [{"name": "esbuild", "version": "'"$(get_version esbuild)"'"}]')
fi
if has_package "tsdown"; then
  BUNDLERS=$(echo "$BUNDLERS" | jq '. + [{"name": "tsdown", "version": "'"$(get_version tsdown)"'"}]')
fi

# Detect TypeScript
TS_INSTALLED=false
TS_VERSION="none"
if has_package "typescript"; then
  TS_INSTALLED=true
  TS_VERSION=$(get_version typescript)
fi

TS_NATIVE=false
if has_package "@typescript/native-preview"; then
  TS_NATIVE=true
fi

# Detect scripts
LINT_SCRIPT=$(get_script "lint")
FORMAT_SCRIPT=$(get_script "format")
BUILD_SCRIPT=$(get_script "build")
TYPECHECK_SCRIPT=$(get_script "typecheck")

# Build recommendations
RECOMMENDATIONS='[]'

# Check for upgradeable linters
if has_package "eslint" && ! has_package "oxlint"; then
  RECOMMENDATIONS=$(echo "$RECOMMENDATIONS" | jq '. + [{"type": "linter", "from": "eslint", "to": "oxlint", "reason": "50-100x faster", "priority": "high"}]')
fi

if has_package "prettier" && ! has_package "oxlint"; then
  RECOMMENDATIONS=$(echo "$RECOMMENDATIONS" | jq '. + [{"type": "formatter", "from": "prettier", "to": "oxfmt", "reason": "50-100x faster", "priority": "high"}]')
fi

# Check for upgradeable bundlers
if (has_package "vite" || has_package "rollup" || has_package "webpack") && ! has_package "tsdown"; then
  CURRENT_BUNDLER=""
  if has_package "vite"; then CURRENT_BUNDLER="vite"
  elif has_package "rollup"; then CURRENT_BUNDLER="rollup"
  elif has_package "webpack"; then CURRENT_BUNDLER="webpack"
  fi

  RECOMMENDATIONS=$(echo "$RECOMMENDATIONS" | jq '. + [{"type": "bundler", "from": "'"$CURRENT_BUNDLER"'", "to": "tsdown", "reason": "10-100x faster", "priority": "medium"}]')
fi

# Check for TypeScript native
if [ "$TS_INSTALLED" = true ] && [ "$TS_NATIVE" = false ]; then
  RECOMMENDATIONS=$(echo "$RECOMMENDATIONS" | jq '. + [{"type": "compiler", "from": "typescript", "to": "@typescript/native-preview", "reason": "2-10x faster", "priority": "low"}]')
fi

# Output JSON
jq -n \
  --argjson linters "$LINTERS" \
  --argjson bundlers "$BUNDLERS" \
  --arg tsInstalled "$TS_INSTALLED" \
  --arg tsVersion "$TS_VERSION" \
  --arg tsNative "$TS_NATIVE" \
  --arg lintScript "$LINT_SCRIPT" \
  --arg formatScript "$FORMAT_SCRIPT" \
  --arg buildScript "$BUILD_SCRIPT" \
  --arg typecheckScript "$TYPECHECK_SCRIPT" \
  --argjson recommendations "$RECOMMENDATIONS" \
  '{
    isNodeProject: true,
    linters: $linters,
    bundlers: $bundlers,
    typescript: {
      installed: $tsInstalled,
      version: $tsVersion,
      nativePreview: $tsNative
    },
    scripts: {
      lint: $lintScript,
      format: $formatScript,
      build: $buildScript,
      typecheck: $typecheckScript
    },
    recommendations: $recommendations
  }'

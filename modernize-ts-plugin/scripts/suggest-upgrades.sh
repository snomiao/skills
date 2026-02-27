#!/bin/bash
# Auto-suggest toolchain upgrades on session start
# Only suggests if package.json exists and old tools detected

# Exit silently if not in a Node.js project
[ ! -f "package.json" ] && exit 0

# Run detection script
PLUGIN_ROOT="${CLAUDE_PLUGIN_ROOT:-$(dirname "$0")/..}"
DETECTION=$("$PLUGIN_ROOT/scripts/detect.sh" 2>/dev/null)

# Exit if detection failed
[ $? -ne 0 ] && exit 0

# Parse recommendations
RECOMMENDATIONS=$(echo "$DETECTION" | jq -r '.recommendations // []')
COUNT=$(echo "$RECOMMENDATIONS" | jq 'length')

# Exit if no recommendations
[ "$COUNT" -eq 0 ] && exit 0

# Build suggestion message
echo ""
echo "⚡ modernize-ts detected upgradeable tools in this project:"
echo ""

echo "$RECOMMENDATIONS" | jq -r '.[] | "  • \(.from) → \(.to) (\(.reason))"'

echo ""
echo "Run /modernize-ts:modernize to modernize to faster tools."
echo ""

exit 0

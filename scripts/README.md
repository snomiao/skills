# Development Scripts

## Plugin Manifest Validation

### Overview

The `validate-plugin-manifests.js` script validates all `.claude-plugin/plugin.json` files to ensure they conform to the required schema before commits are made.

### What it validates

- **Required fields:**
  - `name` (string)
  - `description` (string)
  - `version` (string)

- **Optional but validated fields:**
  - `repository` - **must be a string URL**, not an object (common mistake from npm package.json format)
  - `homepage` - must be a string
  - `license` - must be a string
  - `author` - can be a string or object with `name` property

### Common Errors

#### Invalid repository field
❌ **Wrong** (npm package.json format):
```json
{
  "repository": {
    "type": "git",
    "url": "https://github.com/user/repo.git"
  }
}
```

✓ **Correct** (Claude plugin format):
```json
{
  "repository": "https://github.com/user/repo.git"
}
```

### Pre-commit Hook

The validation runs automatically via [Husky](https://typicode.github.io/husky/) git hooks. The hook is defined in `.husky/pre-commit` and validates all staged plugin.json files before allowing the commit.

### Manual validation

To manually run validation on all staged plugin.json files:

```bash
npm run validate:plugins
```

Or directly:

```bash
node scripts/validate-plugin-manifests.js
```

### Setup

Husky hooks are automatically installed when you run `npm install` (via the `prepare` script in package.json). For a fresh clone of the repository:

```bash
npm install
```

This ensures all developers have the same validation hooks without needing to manually copy files.

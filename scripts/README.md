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

The validation runs automatically via a git pre-commit hook at `.git/hooks/pre-commit`. It only validates plugin.json files that are staged for commit.

### Manual validation

To manually run validation on all staged plugin.json files:

```bash
node scripts/validate-plugin-manifests.js
```

### Setup

The pre-commit hook is already installed at `.git/hooks/pre-commit`. If you need to reinstall it:

```bash
chmod +x scripts/validate-plugin-manifests.js .git/hooks/pre-commit
```

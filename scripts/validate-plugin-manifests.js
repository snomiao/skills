#!/usr/bin/env node

const fs = require('fs');
const path = require('path');
const { execSync } = require('child_process');

// Get staged plugin.json files
const getStagedPluginFiles = () => {
  try {
    const output = execSync('git diff --cached --name-only --diff-filter=ACM', { encoding: 'utf-8' });
    return output
      .split('\n')
      .filter(file => file.endsWith('.claude-plugin/plugin.json'));
  } catch (error) {
    return [];
  }
};

// Validate plugin.json schema
const validatePlugin = (filePath) => {
  const errors = [];

  try {
    const content = fs.readFileSync(filePath, 'utf-8');
    const plugin = JSON.parse(content);

    // Required fields
    if (!plugin.name || typeof plugin.name !== 'string') {
      errors.push('Missing or invalid "name" field (must be a string)');
    }

    if (!plugin.description || typeof plugin.description !== 'string') {
      errors.push('Missing or invalid "description" field (must be a string)');
    }

    if (!plugin.version || typeof plugin.version !== 'string') {
      errors.push('Missing or invalid "version" field (must be a string)');
    }

    // Optional but validated fields
    if (plugin.repository !== undefined && typeof plugin.repository !== 'string') {
      errors.push('Invalid "repository" field (must be a string URL, not an object)');
    }

    if (plugin.homepage !== undefined && typeof plugin.homepage !== 'string') {
      errors.push('Invalid "homepage" field (must be a string)');
    }

    if (plugin.license !== undefined && typeof plugin.license !== 'string') {
      errors.push('Invalid "license" field (must be a string)');
    }

    if (plugin.author !== undefined) {
      if (typeof plugin.author === 'object') {
        if (plugin.author.name && typeof plugin.author.name !== 'string') {
          errors.push('Invalid "author.name" field (must be a string)');
        }
      } else if (typeof plugin.author !== 'string') {
        errors.push('Invalid "author" field (must be a string or object with name)');
      }
    }

  } catch (error) {
    if (error instanceof SyntaxError) {
      errors.push(`Invalid JSON: ${error.message}`);
    } else {
      errors.push(`Error reading file: ${error.message}`);
    }
  }

  return errors;
};

// Main execution
const main = () => {
  const stagedFiles = getStagedPluginFiles();

  if (stagedFiles.length === 0) {
    process.exit(0);
  }

  let hasErrors = false;

  for (const file of stagedFiles) {
    const errors = validatePlugin(file);

    if (errors.length > 0) {
      hasErrors = true;
      console.error(`\n❌ Validation failed for ${file}:`);
      errors.forEach(error => console.error(`   - ${error}`));
    } else {
      console.log(`✓ ${file} is valid`);
    }
  }

  if (hasErrors) {
    console.error('\n❌ Plugin manifest validation failed. Please fix the errors above.');
    process.exit(1);
  }

  console.log('\n✓ All plugin manifests are valid');
  process.exit(0);
};

main();

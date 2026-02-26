# Claude Code Skills & Plugins

A collection of Claude Code plugins and skills to enhance your development workflow.

## Plugins

### ⚡ na-ts (Native TypeScript)

Upgrade your JavaScript/TypeScript toolchain to blazing-fast native alternatives.

**Philosophy:** Modern native tools are 10-100x faster. Combine automation scripts for mechanical work with Claude's intelligence for decisions and edge cases.

**Migrations:**
- ESLint + Prettier → oxlint + oxfmt (50-100x faster)
- Rollup/Vite/webpack → tsdown (10-100x faster)
- tsc → @typescript/native-preview (2-10x faster)

**Features:**
- Auto-detects upgradeable tools on session start
- Automation scripts handle package installation
- Claude handles complex migrations and edge cases
- Cross-platform (Linux/macOS/Windows)

**Usage:**
```bash
claude --plugin-dir ./na-ts-plugin

# Automatic suggestions on session start
# Or run manually:
/na-ts:modernize
```

[Read more →](na-ts-plugin/README.md)

---

## Design Philosophy

This plugin follows a hybrid approach:

1. **Automation Scripts** - Handle deterministic work (package install, detection)
2. **AI Intelligence** - Handle decisions, complex configs, edge cases
3. **Best of Both** - 10x faster than pure AI, more flexible than pure scripting

### Example: Hybrid Approach

**Scripts handle:**
- Detect current toolchain (instant JSON output)
- Install packages with correct package manager
- Update basic package.json scripts
- Create backups

**Claude handles:**
- Complex ESLint → oxlint config migration
- Build configuration edge cases
- Testing and verification
- CI/CD updates
- Documentation

This is much faster than letting Claude manually install packages or having brittle scripts for every edge case.

## Installation

```bash
# Local testing
claude --plugin-dir ./na-ts-plugin

# In a TypeScript project, you'll see:
⚡ na-ts detected upgradeable tools in this project:
  • eslint → oxlint (50-100x faster)
  • vite → tsdown (10-100x faster)

Run /na-ts:modernize to modernize to faster tools.
```

## Quick Start

```bash
# 1. Load plugin
claude --plugin-dir ./na-ts-plugin

# 2. Run modernization
/na-ts:modernize

# 3. Scripts handle mechanical work (2s)
# 4. Claude handles complex parts (30s)
# 5. Your toolchain is now 10-100x faster!
```

## Plugin Structure

```
na-ts-plugin/
├── .claude-plugin/
│   └── plugin.json       # Plugin metadata
├── scripts/
│   ├── detect.sh         # Environment detection
│   ├── migrate-to-*.sh   # Migration automation
│   └── suggest-*.sh      # Auto-suggestions
├── hooks/
│   └── hooks.json        # SessionStart hook for suggestions
├── skills/
│   └── modernize/
│       └── SKILL.md      # Migration expertise
├── README.md
├── QUICKSTART.md
└── LICENSE
```

## Creating Your Own Plugin

Key principles:

1. **Script the deterministic parts** - Package installation, detection, simple updates
2. **Let Claude handle the smart parts** - Decisions, complex configs, testing
3. **Add hooks for automation** - Auto-suggestions, reminders
4. **Trust the hybrid approach** - Best of both worlds

Example minimal plugin (skill only):

```
my-plugin/
├── .claude-plugin/plugin.json
└── skills/
    └── my-skill/
        └── SKILL.md
```

Example with automation:

```
my-plugin/
├── .claude-plugin/plugin.json
├── scripts/
│   └── automate.sh        # Handle mechanical work
└── skills/
    └── my-skill/
        └── SKILL.md       # Reference ${CLAUDE_PLUGIN_ROOT}/scripts/automate.sh
```

## Documentation

- [Claude Code Docs](https://code.claude.com/docs)
- [Plugin System](https://code.claude.com/docs/en/plugins)
- [Hooks Reference](https://code.claude.com/docs/en/hooks)
- [Skills Guide](https://code.claude.com/docs/en/skills)

## Contributing

Contributions welcome! Guidelines:

1. Follow the hybrid approach (scripts + AI)
2. Script the deterministic, let Claude handle the smart
3. Keep code minimal and focused
4. Test with real projects
5. Share performance improvements

## License

MIT - see LICENSE file

## Credits

Built with [Claude Code](https://code.claude.com/)

Tools:
- [tsdown](https://github.com/egoist/tsdown) by @egoist
- [Oxc](https://oxc.rs/) by @Boshen
- [@typescript/native-preview](https://github.com/microsoft/TypeScript/tree/main/packages/native-preview) by Microsoft

## Support

- Issues: https://github.com/snomiao/claude-skills/issues
- Discussions: Share your experience and ideas

---

**Remember:** The best plugin combines smart automation with AI intelligence.

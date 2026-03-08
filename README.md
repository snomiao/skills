# snomiao/skills

Claude Code skills collection using the [vercel-labs/skills](https://github.com/vercel-labs/skills) format.

## Available Skills

### modernize

Upgrade your JavaScript/TypeScript toolchain to blazing-fast native alternatives:

- **ESLint + Prettier** → oxlint + oxfmt (50-100x faster)
- **Rollup/Vite/webpack** → tsdown (10-100x faster)
- **tsc** → @typescript/native-preview (2-10x faster)

Includes automation scripts for detection and migration, so Claude handles mechanical work instantly and focuses on complex decisions and edge cases.

### heal-pr

Fix and heal GitHub Pull Requests automatically:

- **CI/CD failures** → diagnose logs and fix code issues
- **Review comments** → address feedback or explain disagreements
- **Merge conflicts** → rebase and resolve intelligently
- **Bot reviews** → iterate with @copilot until approved

Systematically works through all PR issues in priority order, committing each fix separately for clean history.

## Install

```bash
# recommend: bunx, which is way faster than npx
bunx skills add snomiao/skills --skill modernize -g -y
bunx skills add snomiao/skills --skill heal-pr -g -y

# or npx if you are familiar with
npx skills add snomiao/skills --skill modernize -g -y
npx skills add snomiao/skills --skill heal-pr -g -y
```

## What's Included

```
skills/modernize/
├── SKILL.md                     # Skill instructions for Claude
└── scripts/
    ├── detect.sh                # Detect current toolchain & recommend upgrades
    ├── migrate-to-oxlint.sh     # Migrate linting to oxlint/oxfmt
    ├── migrate-to-tsdown.sh     # Migrate bundler to tsdown
    ├── migrate-to-ts-native.sh  # Install @typescript/native-preview
    └── suggest-upgrades.sh      # Auto-suggest available upgrades

skills/heal-pr/
└── SKILL.md                     # PR healing workflow for Claude
```

## License

MIT

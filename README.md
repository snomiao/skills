# snomiao/skills

Claude Code skills collection using the [vercel-labs/skills](https://github.com/vercel-labs/skills) format.

## Available Skills

### modernize

Upgrade your JavaScript/TypeScript toolchain to blazing-fast native alternatives:

- **ESLint + Prettier** → oxlint + oxfmt (50-100x faster)
- **Rollup/Vite/webpack** → tsdown (10-100x faster)
- **tsc** → @typescript/native-preview (2-10x faster)

Includes automation scripts for detection and migration, so Claude handles mechanical work instantly and focuses on complex decisions and edge cases.

## Install

```bash
# recommend: bunx, which is way faster than npx
bunx skills add snomiao/skills --skill modernize -g -y

# or npx if you are familiar with
npx skills add snomiao/skills --skill modernize -g -y
```

This copies `skills/modernize/` (including `SKILL.md` and all migration scripts) into `~/.claude/skills/modernize/`.

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
```

## License

MIT

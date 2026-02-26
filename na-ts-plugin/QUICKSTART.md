# na-ts Quick Start

Upgrade your toolchain to modern native tools in minutes.

## Install

```bash
claude --plugin-dir /path/to/na-ts-plugin
```

## Use

```bash
# In Claude Code
/na-ts:upgrade
```

That's it! Claude will:
1. Analyze your toolchain
2. Identify slow tools
3. Upgrade to fast alternatives
4. Test everything
5. Update documentation

## Example Session

```
You: /na-ts:upgrade

Claude: I'll analyze your toolchain...

Found:
- ESLint (25s per run) → Can upgrade to oxlint (0.3s)
- Vite build (3min) → Can upgrade to tsdown (10s)
- tsc (15s) → Can upgrade to @typescript/native-preview (4s)

Shall I proceed with all upgrades?

You: Yes

Claude: [Performs upgrades...]

✓ All done! Your toolchain is now 10-100x faster.
```

## Manual Usage

Be specific about what you want:

```
You: Replace ESLint with something faster
You: Speed up my Vite builds
You: Upgrade to faster TypeScript compiler
```

Claude figures out the rest.

## What Gets Upgraded

| From | To | Benefit |
|------|----|----|
| ESLint/Prettier | oxlint/oxfmt | 50-100x faster |
| Vite/Rollup/webpack | tsdown | 10-100x faster |
| tsc | @typescript/native-preview | 2-10x faster |

## Philosophy

Trust Claude to:
- Pick the right tools
- Test thoroughly
- Preserve compatibility
- Update configs
- Document changes

You focus on coding, Claude handles the migration.

## Next Steps

- See [README.md](README.md) for details
- Check tool documentation as needed
- Enjoy faster development!

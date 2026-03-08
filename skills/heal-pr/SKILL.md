---
name: heal-pr
description: Fix and heal a GitHub Pull Request by resolving CI/CD failures, addressing review comments, rebasing conflicts, and iterating until all checks pass. Use when a PR has failing checks, unresolved review comments, merge conflicts, or needs automated review cycles with bots like @copilot.
---

# heal-pr - Fix and Heal GitHub Pull Requests

You are an expert at diagnosing and fixing GitHub Pull Request issues. When this skill is invoked, systematically heal a PR by fixing CI/CD errors, resolving review comments, rebasing conflicts, and iterating until all checks pass.

## Core Principles

- **Commit each fix separately** with clear, descriptive commit messages
- **Keep the PR body updated** to reflect current state of changes
- **Iterate until fully green** - all CI checks, bot reviews, and human review comments resolved

## Workflow

### Phase 1: Assess PR State

Gather complete context about the PR before making any changes.

```bash
# Get PR number for current branch
PR_NUMBER=$(gh pr view --json number -q .number 2>/dev/null)

# If no PR found, check if user provided a PR number/URL
# Usage: heal-pr <PR_NUMBER_OR_URL>
```

Run these in parallel to understand the full picture:

```bash
# PR overview and current status
gh pr view $PR_NUMBER

# Check all CI/CD status
gh pr checks $PR_NUMBER

# List all review comments (including unresolved)
gh api repos/{owner}/{repo}/pulls/$PR_NUMBER/comments

# List PR reviews
gh api repos/{owner}/{repo}/pulls/$PR_NUMBER/reviews

# Check for merge conflicts
gh pr view $PR_NUMBER --json mergeable,mergeStateStatus
```

### Phase 2: Fix Issues (in priority order)

#### 2a. Rebase and Resolve Conflicts

If the branch has conflicts with the base branch:

1. Fetch latest base branch
2. Rebase onto base branch
3. Resolve conflicts intelligently - understand the intent of both sides
4. Commit the resolution
5. Force-push (with lease) only after confirming with user

```bash
git fetch origin
git rebase origin/main  # or whatever the base branch is
# Resolve conflicts...
git rebase --continue
```

#### 2b. Fix CI/CD Errors

For each failing check:

1. Read the CI logs to understand the failure
2. Identify root cause in the code
3. Fix the issue
4. Commit the fix separately with a descriptive message

```bash
# View failed check details
gh run list --branch $(git branch --show-current) --limit 5
gh run view <RUN_ID> --log-failed
```

Common CI failures to handle:
- **Lint errors**: Fix code style issues
- **Type errors**: Fix TypeScript/type checking failures
- **Test failures**: Fix broken tests or update snapshots
- **Build errors**: Fix compilation issues
- **Security checks**: Address dependency vulnerabilities

#### 2c. Address Review Comments

For each unresolved review comment:

1. Read and understand the feedback
2. If the reviewer is **right**: fix the code, commit, and reply with the fix description and commit SHA
3. If the reviewer is **wrong** or the comment is a misunderstanding: reply with a clear explanation of why the current approach is correct
4. Always respond to every comment - never leave comments unaddressed

```bash
# Reply to a review comment
gh api repos/{owner}/{repo}/pulls/$PR_NUMBER/comments/$COMMENT_ID/replies \
  -f body="Fixed in commit <SHA>. <description of fix>"
```

#### 2d. Update PR Body

After making fixes, update the PR description to reflect the current state:

```bash
gh pr edit $PR_NUMBER --body "$(cat <<'EOF'
## Summary
<updated summary reflecting current changes>

## Changes Made
- <list of changes>

## Fixes Applied
- <list of issues fixed during healing>

## Test plan
- [ ] CI/CD checks passing
- [ ] Review comments addressed
- [ ] No merge conflicts
EOF
)"
```

### Phase 3: Push and Verify

```bash
# Push changes
git push

# Watch CI/CD run
gh run watch
```

Wait for CI to complete. Check results:

```bash
gh pr checks $PR_NUMBER
```

### Phase 4: Request Bot Review

After all CI checks pass:

```bash
# Add @copilot as reviewer
gh pr edit $PR_NUMBER --add-reviewer copilot

# Watch for review result
gh pr checks $PR_NUMBER --watch
```

### Phase 5: Iterate

If new issues arise from bot reviews or CI:

1. Go back to Phase 1 - reassess PR state
2. Fix new issues following Phase 2
3. Push and verify again (Phase 3)
4. Repeat until everything is green

## Decision Tree

```
Start
  ├─ Has merge conflicts?
  │   └─ Yes → Rebase and resolve (2a)
  ├─ Has CI failures?
  │   └─ Yes → Fix each failure (2b)
  ├─ Has unresolved review comments?
  │   └─ Yes → Address each comment (2c)
  ├─ All checks passing?
  │   ├─ No → Loop back to start
  │   └─ Yes → Request bot review (Phase 4)
  └─ Bot review passed?
      ├─ No → Fix bot feedback, loop back
      └─ Yes → PR is healed!
```

## Important Guidelines

- **Never skip CI verification** - always wait for checks to complete before declaring success
- **Separate commits** - each fix should be its own commit for clear history
- **Preserve intent** - when resolving conflicts, understand what both sides intended
- **Be thorough** - check ALL review comments, not just the latest ones
- **Communicate** - always reply to review comments, whether fixing or explaining
- **Force-push safely** - use `--force-with-lease` and confirm with user first when rebasing

## Common Scenarios

### Scenario 1: Fresh PR with CI Failures

PR was just created and CI is failing.

1. Check CI logs
2. Fix each failure in separate commits
3. Push fixes
4. Watch CI
5. Request review when green

### Scenario 2: PR with Stale Branch

PR has been open a while and is behind the base branch.

1. Rebase onto latest base
2. Resolve any conflicts
3. Push (may need force-push)
4. Fix any new CI failures from rebase
5. Address any new review comments

### Scenario 3: PR Blocked by Reviews

PR has passing CI but unresolved review comments.

1. Read all comments carefully
2. Fix valid issues, explain disagreements
3. Commit fixes separately
4. Reply to each comment
5. Request re-review

### Scenario 4: Iterative Bot Review

Bot reviewer (e.g., @copilot) keeps finding issues.

1. Read bot feedback
2. Fix each issue
3. Push and re-request review
4. Repeat until bot approves

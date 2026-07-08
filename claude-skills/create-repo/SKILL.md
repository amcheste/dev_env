---
name: create-repo
description: Create a new GitHub repository from the amcheste/repo-template, clone it locally, and apply standard branch protection and settings. Use /setup-repo to configure an existing repo instead.
---

Create a new repository based on the user's request: $ARGUMENTS

## Parse the request

Extract from the user's message:
- **name**: the repository name (e.g. `my-new-service`). No owner prefix — always created under `amcheste`.
- **description**: optional one-line description of the repo.
- **visibility**: `public` (default) or `private`.

If the name is missing or ambiguous, ask before proceeding.

## Pre-flight

Confirm with the user:
- Repo name: `amcheste/<name>`
- Description: `<description or "none">`
- Visibility: `public` or `private`

Do not proceed until confirmed.

## Step 1 — Create from template

```bash
gh repo create amcheste/<name> \
  --template amcheste/repo-template \
  --<public|private> \
  --description "<description>"
```

## Step 2 — Clone locally

```bash
gh repo clone amcheste/<name> ~/Repos/amcheste/<name>
cd ~/Repos/amcheste/<name>
```

## Step 3 — Apply standard repo setup

Run the same configuration as `/setup-repo`:

**Create develop branch:**
```bash
git checkout -b develop
git push -u origin develop
```

**Set develop as default, merge policy, and branch auto-delete** (squash
disabled to protect bot authorship + co-author trailers; head branches
auto-delete on merge — they stay restorable from the PR page):
```bash
gh api repos/amcheste/<name> \
  --method PATCH \
  --field default_branch=develop \
  --field allow_squash_merge=false \
  --field allow_rebase_merge=true \
  --field allow_merge_commit=true \
  --field delete_branch_on_merge=true \
  --jq '{default_branch, allow_squash_merge, allow_rebase_merge, allow_merge_commit, delete_branch_on_merge}'
```

**Protect develop** (require PR, enforce on admins, all users must go through PR):
```bash
gh api repos/amcheste/<name>/branches/develop/protection \
  --method PUT \
  --input - <<'EOF'
{
  "required_status_checks": {
    "strict": true,
    "checks": [{"context": "Lint"}, {"context": "Commit Lint"}]
  },
  "enforce_admins": true,
  "required_pull_request_reviews": {
    "required_approving_review_count": 0,
    "dismiss_stale_reviews": false
  },
  "restrictions": null,
  "allow_force_pushes": false,
  "allow_deletions": false
}
EOF
```

Note: the default checks (`Lint`, `Commit Lint`) match the template's validate.yml. Once you customise the validate workflow, update the required checks accordingly using `/setup-repo`.

**Protect main:**
```bash
gh api repos/amcheste/<name>/branches/main/protection \
  --method PUT \
  --input - <<'EOF'
{
  "required_status_checks": {
    "strict": true,
    "checks": [{"context": "Lint"}]
  },
  "enforce_admins": true,
  "required_pull_request_reviews": {
    "required_approving_review_count": 0,
    "dismiss_stale_reviews": false
  },
  "restrictions": null,
  "allow_force_pushes": false,
  "allow_deletions": false
}
EOF
```

**Add tag protection:**
```bash
gh api repos/amcheste/<name>/rulesets \
  --method POST \
  --input - <<'EOF'
{
  "name": "Protect release tags",
  "target": "tag",
  "enforcement": "active",
  "conditions": {
    "ref_name": {
      "include": ["refs/tags/v*"],
      "exclude": []
    }
  },
  "rules": [
    {"type": "deletion"},
    {"type": "non_fast_forward"},
    {"type": "creation"}
  ],
  "bypass_actors": [
    {"actor_id": 3490270, "actor_type": "Integration", "bypass_mode": "always"},
    {"actor_id": 5, "actor_type": "RepositoryRole", "bypass_mode": "always"}
  ]
}
EOF
```

The bypass actors matter: rulesets bind everyone, including admins, so
without them no release tag can ever be pushed. Actor 3490270 is the
`amcheste-ai-agent` GitHub App; RepositoryRole 5 is repo admin.

**Enable Actions PR creation** (the monthly dependency release cannot open
its release PR without it):

```bash
gh api -X PUT repos/amcheste/<name>/actions/permissions/workflow \
  -f default_workflow_permissions=read \
  -F can_approve_pull_request_reviews=true
```

## Step 4 — Personalise the repo

Open the following files in the editor and prompt the user to fill them in:

1. **`README.md`** — replace `repo-name` with the actual name, fill in the description
2. **`SECURITY.md`** — replace `repo-name` in the private-vulnerability-reporting URL
3. **`CLAUDE.md`** — fill in the "About This Repo" section
4. **`.github/labeler.yml`** — add project-specific path→label mappings
5. **`.github/workflows/validate.yml`** — the template ships a real default Lint (markdownlint + offline link check). For docs/tooling repos, consider switching to the centralized `reusable-validate.yml` from amcheste/gh-workflows (required checks then become `validate / Lint` and `validate / Commit Lint`). For code repos, ADD the language lint (shellcheck, ruff, golangci-lint, …) to the existing Lint job.

Note: `monthly-dependency-release.yml` and `gitleaks.yml` are thin stubs calling amcheste/gh-workflows reusables pinned to a release tag — leave them alone; Dependabot bumps the pins. The monthly release also needs the repo setting **Settings → Actions → General → "Allow GitHub Actions to create and approve pull requests"** enabled — do that as part of setup.

## Summary

Tell the user:
- Repo URL: `https://github.com/amcheste/<name>`
- Cloned to: `~/Repos/amcheste/<name>`
- `develop` is the default branch, protected with required PR + CI
- `main` is protected — only reachable via develop→main release PR
- `v*` tags are protected
- Next: add language lint to `validate.yml` (or adopt the centralized reusable-validate), enable "Allow GitHub Actions to create and approve pull requests", then sync required status check names with `/setup-repo amcheste/<name>`

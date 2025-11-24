# Running Small Bets on NixOS

This document describes how to run the Small Bets project using Nix. It also covers how to manage Nix-specific changes to keep them separate from your feature branches.

## 1. Entering the Environment

We use `direnv` to automatically load the Nix environment.

```bash
cd smallbets
direnv allow
```

If you don't use `direnv`, you can manually enter the shell:

```bash
nix develop
```

## 2. Initial Setup

Run the setup script to install dependencies and prepare the database:

```bash
bin/setup
```

## 3. Running the Application

To start the application (backend + frontend), use:

```bash
bundle exec bin/dev
```

> [!IMPORTANT]
> Always use `bundle exec` before `bin/dev` to ensure the `foreman` gem is correctly loaded from the bundle.

## 4. Running Tests

To run the test suite:

```bash
bin/rails test
```

## 5. Managing Nix Changes

To support Nix, we made the following changes:

1.  **`flake.nix`**: Defines the system dependencies (Ruby, Node, Redis, etc.).
2.  **`.envrc`**: Loads the flake automatically.
3.  **`Gemfile`**: Added `gem "foreman"` to the `:development` group because the system `foreman` is not used in Nix.

### Keeping Nix Changes Separate

If you want to submit a PR without these Nix-specific changes, you have a few options:

#### Option A: Ignore Changes Locally (Recommended)

You can tell Git to ignore changes to specific files locally:

```bash
git update-index --skip-worktree Gemfile flake.nix .envrc
```

To undo this (if you need to update them):

```bash
git update-index --no-skip-worktree Gemfile flake.nix .envrc
```

#### Option B: Separate Branch

Keep a `nix-config` branch that contains these changes. When you start a new feature:

1.  Checkout `master`.
2.  Create your feature branch: `git checkout -b my-feature`.
3.  Merge `nix-config` into your feature branch: `git merge nix-config`.
4.  Do your work.
5.  Before pushing, interactively rebase to remove the Nix commits, or simply revert the changes to `Gemfile` if that's the only file you don't want to touch.

#### Option C: Global Git Ignore (for new files)

For `flake.nix` and `.envrc`, you can add them to your global `.gitignore` or `.git/info/exclude` so they are never tracked. However, since we modified `Gemfile`, Option A is usually best.

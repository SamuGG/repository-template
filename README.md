# About

Clone this repository to start new projects in a [Dev Container](https://learn.microsoft.com/en-us/shows/beginners-series-to-dev-containers/) populated with automation tools.

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
## Table of Contents

- [Automations Included](#automations-included)
- [Getting Started](#getting-started)
  - [1. Start New Project Repository](#1-start-new-project-repository)
  - [2. Configure Git In Container](#2-configure-git-in-container)
  - [3. Install Dependencies](#3-install-dependencies)
- [Usage](#usage)
  - [Creating a Release](#creating-a-release)
- [Getting Help](#getting-help)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## Automations Included

- Git hooks for:
  - Commit message linting, to enforce [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/)
  - Pre-Commit linting staged files, to prevent mistakes going in your commits
- Check spelling
- Lint markdown files
- Auto-generate table of contents in documentation
- Automate releases for:
  - Checking your git commits contain releasable changes
  - Auto-generating changelog
  - Enforcing semantic versioning
  - Creating version tags

[![semantic-release: conventionalcommits](https://img.shields.io/badge/semantic--release-conventionalcommits-e10079?logo=semantic-release)](https://github.com/semantic-release/semantic-release)

## Getting Started

### 1. Start New Project Repository

Create a new local git repository then, fetch and squash this template into one single _'initial commit'_

```sh
mkdir new-project && cd "$_"

git init

git fetch --depth=1 --no-tags https://github.com/SamuGG/code-project-template.git main

git reset --hard $(git commit-tree FETCH_HEAD^{tree} -m "chore: Initial commit" -m "Source repo https://github.com/SamuGG/code-project-template.git")
```

- `new-project` is the name of the new directory
- `main` is the branch to be fetched from the remote repository
- `chore: Initial commit` is your initial (conventional) commit message

> If using `ssh` instead of `https`, change previous fetch command to:
>
> `git fetch --depth=1 --no-tags git@github.com:SamuGG/code-project-template.git main`

Open the project folder with VS Code, and accept the prompt to re-open the folder inside a Dev Container.

**Requirement :** Install [Dev Containers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) extension in VS Code.

### 2. Configure Git In Container

Once the Dev Container starts with your new repository, open **VS Code terminal** and run the following scripts to configure Git in the container:

```sh
template-repo-scripts/configure-global-gitconfig.sh
template-repo-scripts/generate-global-gitignore.sh
```

Set-up your Git user:

```sh
git config --global user.name YOUR_GIT_USERNAME
git config --global user.email YOUR_GIT_EMAIL
```

> If using `ssh`, you must **copy** `id_rsa` or any other identification keys **from the host** computer into the container's `~/.ssh`.
>
> And the same for the `~/.ssh/config` if yours contains custom configuration.

### 3. Install Dependencies

From the Dev Container, open **VS Code terminal** and run `make install` to install automation tools.

## Usage

Automation tools will kick-off every time you run `git commit`

### Creating a Release

Open **VS Code terminal** and run `make create-release`

**Requirements :**

- Your remote repository must be set in `package.json` with `npm pkg set repository.url='github:user/repo'`
- The release branch must exist in the remote repository
- By default, `main` and `master` are the only branches allowing releases
- There must be some _releasable_ commit (i.e.: `style:` or `revert:` are NOT, while `feat:` or `fix:` are)

## Getting Help

You may replace the contents of this README safely for your new project.

All the documentation is kept in [template-repo-docs/](template-repo-docs/README.md)

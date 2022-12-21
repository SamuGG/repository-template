# 📚 Developer Guide

## Command Line

This repository uses `Bash` shell, instead of **Zsh**

## Package Management

This repository uses [Yarn](https://yarnpkg.com) package manager, instead of [NPM](https://www.npmjs.com/), for NodeJs scripts

## Dev Container Features

Dev Container **features** (NodeJs, Docker, etc.) are defined in [.devcontainer/devcontainer.json](/.devcontainer/devcontainer.json) in the `features` section.

## IDE Extensions

Recommended VS Code extensions can be placed in [.vscode/extensions.json](/.vscode/extensions.json)

Any extensions to be installed automatically in your Dev Container can be added to [.devcontainer/devcontainer.json](/.devcontainer/devcontainer.json) in the section `customizations.vscode.extensions`

## Git Hooks

When you're looking to enforce policies and ensure consistency among team members, git hooks can be a helpful solution. By running custom scripts before or after git operations occur, you can prevent commits from being added to a repository and notify team members that there are changes needed to be made.

**Husky** is a popular JavaScript package that allows us to add **git hooks** to our JS projects with ease.

To create a hook run:

```sh
yarn husky add pre-commit "yarn lint-staged"
```

Where `pre-commit` is the name of the hook to add; and `yarn lint-staged` is what we want the hook to do.

A list of available git hooks can be found [here](https://git-scm.com/docs/githooks).

To remove a hook, delete its file:

```sh
rm -f .husky/pre-commit
```

## Linting Staged Changes

Let's make sure that any code submitted to the repository is properly linted.

We'll use [lint-staged](https://github.com/okonet/lint-staged) to run checks on staged files.

It allows us, for example, for `.md` files only, to run [markdownlint-cli2](https://github.com/DavidAnson/markdownlint-cli2) and [cspell](https://cspell.org) tools from their Docker images, using our make commands `make lint-markdown` and `make spell-check`.

As another example, it also runs [doctoc](https://github.com/thlorenz/doctoc) on the `readme.md` file to generate the table of contents automatically, using our make command `make toc-markdown`.

### Linters Configuration

To configure linting steps, update [.lintstagedrc](.lintstagedrc)

To configure markdown linting, update [.markdownlint-cli2.jsonc](.markdownlint-cli2.jsonc)

To configure spell checking, update [.cspell.json](cspell.json)

By default, `doctoc` places the table of contents at the top of the file. You can indicate to have it placed elsewhere with the following format:

```xml
<!-- START doctoc -->
<!-- END doctoc -->
```

## Linting Commit Messages

In our repository, commit messages must follow the [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/) specification.

We'll use [@commitlint/cli](https://github.com/conventional-changelog/commitlint) Node package to validate all messages.

The configuration is saved in [commitlint.config.js](commitlint.config.js)

## Cloud Providers

No cloud providers CLI or SDK are included in this repository. You may install them on your own and add any [Makefile targets](makefile-targets.md) for your needs.

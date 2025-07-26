# 🏃 Getting Started

## Requirements

- [Docker](https://www.docker.com/products/docker-desktop/)
- [Makefile](https://makefiletutorial.com) support
- [Bun](https://bun.sh)

## 1. Create a new repository

Create a new local directory and initialize git with this template squashed in one single _'initial commit'_

<!-- cSpell:disable -->
```sh
mkdir my-repository-name && cd "$_"

git init

# For HTTP protocol run:
git fetch --depth=1 --no-tags https://github.com/SamuGG/repository-template.git main
# For SSH run below command instead:
# git fetch --depth=1 --no-tags git@github.com:SamuGG/repository-template.git main

git reset --hard $(git commit-tree FETCH_HEAD^{tree} -m "chore: Initial commit" -m "Source repo github:SamuGG/repository-template")

# Replace with your values
bun pm pkg set \
  name='{YOUR_PROJECT_NAME}' \
  description='{YOUR_PROJECT_DESCRIPTION}' \
  repository.url='github:{YOUR_GITHUB_USER}/{YOUR_GITHUB_REPO}'

git commit --all --amend --no-edit
```
<!-- cSpell:enable -->

## 2. Install local tools

Local tools are installed as packages with:

```sh
make install
```

# 🚶 Getting Started

## Requirements

- [Docker](https://www.docker.com/products/docker-desktop/)
- [Nodejs](https://nodejs.org/)
- [Makefile](https://makefiletutorial.com) support

## 1. Start A New Repository

Create a new local directory, initialize a new git repository and squash this template into one single _'initial commit'_

<!-- cSpell:disable -->
```sh
mkdir {repository-name} && cd "$_"

git init

# For HTTP protocol use command:
git fetch --depth=1 --no-tags https://github.com/SamuGG/repository-template.git {branch}
# For SSH use below command instead:
# git fetch --depth=1 --no-tags git@github.com:SamuGG/repository-template.git {branch}

git reset --hard $(git commit-tree FETCH_HEAD^{tree} -m "chore: Initial commit" -m "Source repo https://github.com/SamuGG/repository-template.git")
```
<!-- cSpell:enable -->

- `repository-name` is the name of the new directory
- `branch` is the branch to be fetched from the remote repository

## 2. Install Local Tools

Local tools are installed as Nodejs packages with:

```sh
make install
```

It's safe to run the command multiple times.

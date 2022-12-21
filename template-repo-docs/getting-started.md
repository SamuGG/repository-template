# Getting Started

## 1. Start New Project Repository

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

Open the project folder with VS Code, and accept prompt to re-open the folder inside a Dev Container.

**Requirement :** Install [Dev Containers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) extension in VS Code.

## 2. Configure Git In Container

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

## 3. Install Dependencies

From the Dev Container, open **VS Code terminal** and run `make install` to install automation tools.

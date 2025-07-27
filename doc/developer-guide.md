# 📚 Developer Guide

## Tech stack

- [![Visual Studio Code](https://img.shields.io/badge/Visual%20Studio%20Code-0078d7.svg?style=for-the-badge&logo=visual-studio-code&logoColor=white)](https://code.visualstudio.com/)

  - `C# Dev Kit` [extension](https://marketplace.visualstudio.com/items?itemName=ms-dotnettools.csdevkit)
  - `Terraform` [extension](https://marketplace.visualstudio.com/items?itemName=HashiCorp.terraform)

- [![Git](https://img.shields.io/badge/git-%23F05033.svg?style=for-the-badge&logo=git&logoColor=white)](https://git-scm.com/)

  - [Husky](https://typicode.github.io/husky/)

- [![Bash Script](https://img.shields.io/badge/bash_script-%23121011.svg?style=for-the-badge&logo=gnu-bash&logoColor=white)](https://www.gnu.org/software/bash/)
- [![Bun](https://img.shields.io/badge/Bun-%23000000.svg?style=for-the-badge&logo=bun&logoColor=white)](https://bun.com/)
- [![.Net](https://img.shields.io/badge/.NET-5C2D91?style=for-the-badge&logo=.net&logoColor=white)](https://dotnet.microsoft.com/)
- [![Terraform](https://img.shields.io/badge/terraform-%235835CC.svg?style=for-the-badge&logo=terraform&logoColor=white)](https://developer.hashicorp.com/terraform)
- [![Docker](https://img.shields.io/badge/docker-%230db7ed.svg?style=for-the-badge&logo=docker&logoColor=white)](https://www.docker.com/products/docker-desktop/)

  - [cspell](https://www.npmjs.com/package/cspell)
  - [doctoc](https://www.npmjs.com/package/doctoc)
  - [markdownlint-cli2](https://www.npmjs.com/package/markdownlint-cli2)
  - [tflint](https://github.com/terraform-linters/tflint)
  - [checkov](https://www.checkov.io/)
  - [LocalStack](https://docs.localstack.cloud/)
  - [samcli](https://github.com/aws/aws-sam-cli)

## Repository structure

- [.config/](../.config) - contains configuration files
- [.husky/](../.husky) - contains git hooks
- [dep/](../dep) - contains dependencies for the repository
- [doc/](./) - contains documentation
- [res/](../res) - contains resources such as scripts and templates
- [src/](../src) - contains source code
- [test/](../test) - contains testing code

## Git hooks

[Husky](https://typicode.github.io/husky/) is a popular JavaScript package that allows us to add git hooks to our repository and run custom scripts before or after git operations.

For example, we may want to check the spelling, make sure the staged code compiles and tests pass before git commits our changes.

i.e. create a `pre-commit` hook with:

```sh
echo "dotnet build && dotnet test" > .husky/pre-commit
```

Where `dotnet build && dotnet test` is the script to run.

## Linters

- [@commitlint/cli](https://github.com/conventional-changelog/commitlint) validates commit messages

    Configuration file is [commitlint.config.js](../.config/commitlint.config.js)

- [cspell](https://www.npmjs.com/package/cspell) checks spelling in text files and commit messages

    Configuration file is [.cspell.json](../.config/cspell.json)

- [markdownlint-cli2](https://www.npmjs.com/package/markdownlint-cli2) validates markdown files

    Configuration file is [.markdownlint-cli2.jsonc](../.config/.markdownlint-cli2.jsonc)

- [standard](https://www.npmjs.com/package/standard) validates JavaScript
- [tflint](https://github.com/terraform-linters/tflint) and [checkov](https://www.checkov.io/) validate Terraform code

    Configuration file is [checkov.yaml](../.config/checkov.yaml)

> Some linters are running inside Docker containers while others, are installed as dependencies in `package.json`. You may remove dependencies, commands and configuration files when not planning to use them.

## Tools

- [Husky](https://typicode.github.io/husky/) runs scripts before and after git commands
- [lint-staged](https://www.npmjs.com/package/lint-staged) runs tasks against staged files

    Configuration file is [.lintstagedrc](../.config/.lintstagedrc)

- [MSBuild Traversal](https://github.com/microsoft/MSBuildSdks/blob/main/src/Traversal/README.md)

    Configuration file is [dirs.proj](../dirs.proj)

- [doctoc](https://www.npmjs.com/package/doctoc) generates table of contents for markdown files

    It places the table at the top of the file by default. This behaviour can be changed by placing the following markup elsewhere:

    ```xml
    <!-- START doctoc -->
    <!-- END doctoc -->
    ```

- [semantic-release](https://www.npmjs.com/package/semantic-release) automates releases

    Configuration file is [.releaserc](../.config/.releaserc)

- [auto-changelog](https://www.npmjs.com/package/auto-changelog) generates changelogs based on commit messages

    Configuration file is [.auto-changelog](../.config/.auto-changelog)

- [LocalStack](https://docs.localstack.cloud/) emulates AWS cloud services running inside Docker

    Configuration is in [docker-compose.yml](../.config/docker-compose.yml)

> Some tools are running inside Docker containers while others, are installed as dependencies in `package.json`. You may remove dependencies, commands and configuration files when not planning to use them.

## Linting staged changes

We'll use [lint-staged](https://github.com/okonet/lint-staged) to run tasks against staged files. It's invoked by the `pre-commit` git hook.

When the tasks involve long or complex commands, it's much better defining a Makefile target; so it becomes easier to invoke them by simply calling commands like `make lint-markdown` or `make spell-check`.

Other good cases would be:

- running `dotnet build` to make sure staged files are building before committing them
- running [doctoc](https://github.com/thlorenz/doctoc) on markdown files to automatically generate / update table of contents

## Linting commit messages

We'll use [@commitlint/cli](https://github.com/conventional-changelog/commitlint) to enforce all commit messages follow the [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/) convention. It's invoked by the `commit-msg` git hook.

## Upgrading tools

To upgrade all outdated tools installed as dependencies:

```sh
bun update --interactive
```

To upgrade one package in particular:

```sh
bun update package-name
bun update package-name@1.2.3
```

**Docker** images used in this repository use the `latest` label by default. You can set the version by setting the constant variable in the [Makefile](../Makefile).

Don't forget to pull your Docker images regularly as they receive updates.

## Makefile

The following command will provide you with a comprehensive menu of all the targets available:

```sh
make
```

Run a target:

```sh
make lint-markdown
```

Multiple targets can be combined together in the same command, and even override variables when running the command; i.e.:

```sh
make check-spelling lint-markdown toc VERSION_CSPELL=6.14.2 VERSION_MARKDOWNLINT=v0.5.1
```

> Reference: [A brief introduction to makefiles](https://dev.to/sensorario/a-brief-introduction-to-what-makefiles-are-3fb1)

⚠️ **IMPORTANT**: Remember to set the variables required at the top of the file

## Creating a release

We'll use [semantic-release](https://www.npmjs.com/package/semantic-release) to automate all steps. Simply run:

```sh
make release
```

**Requirements**:

- A remote Git repository must exist and set in `package.json`
- The release branch must exist in the remote repository
- By default, `main` and `master` are the only branches allowing releases
- There must be some _releasable_ commit in the history (i.e.: `style:` or `revert:` are NOT, while `feat:` or `fix:` are good)

## Creating a changelog

Although `semantic-release` has a plugin for generating changelogs, we'll use [auto-changelog](https://github.com/CookPete/auto-changelog) separately. The reason being the `semantic-release` plugin is too simple and not much configurable.

To generate the changelog run:

```sh
make changelog
```

## Release notes vs changelog

The release notes and the changelog are different documents.

📝 The changelog usually lives in a `CHANGELOG.md` document in your repository, and grows over time adding new versions with the release date and a break-down of changes.

✉️ The release notes is not a file living in your repository. It's usually some markdown text summarizing one version where GitHub adds the version tag and links for build assets to download.

## Cloud providers

This repository mentions linters and tools for [AWS](https://aws.amazon.com/console/) cloud services however; you can replace them with tools for other cloud providers.

### Emulators

We'll use [LocalStack](https://www.localstack.cloud/)  as our local AWS cloud emulator.

Start it with:

```sh
make start-emulators
```

Stop it with:

```sh
make stop-emulators
```

⚠️ Design your code with environment variables or app settings in mind, so you can decide whether it points to AWS or LocalStack.

e.g. Nodejs Lambda function using environment variable `S3_ENDPOINT`:

```js
import { S3Client, GetObjectCommand } from '@aws-sdk/client-s3'

export const handler = async (event) => {
  try {
    const client = new S3Client({ endpoint: process.env.S3_ENDPOINT, forcePathStyle: true })
    const command = new GetObjectCommand({ Bucket: 'sample-bucket', Key: 'sample-file.json' })
    const { Body } = await client.send(command)
    const json = JSON.parse(await Body.transformToString())

    return {
      statusCode: 200,
      headers: { 'content-type': 'application/json' },
      body: JSON.stringify(json, null, 0)
    }
  } catch (error) {
    return {
      statusCode: 400,
      headers: { 'content-type': 'application/json' },
      body: JSON.stringify({ error: { message: 'Failed to load file' }}, null, 0)
    }
  }
}
```

Then, you can invoke the function with either:

- development LocalStack container: `http://s3.localhost.localstack.cloud:4566`
- or the real AWS service: `https://s3.eu-west-2.amazonaws.com`

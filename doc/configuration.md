# 🔧 Configuration

## Tools Configuration

### Husky

When installed, it updates git settings with `hooksPath = .husky`

- To create a `pre-commit` hook:

    ```sh
    echo "bun lint-staged" > .husky/pre-commit
    ```

    Where `bun lint-staged` is the command to run before git commit

- To remove a hook, delete the file

    ```sh
    rm -f .husky/pre-commit
    ```

- To change a hook, edit the file

See the list of available git [hooks](https://git-scm.com/docs/githooks).

### lint-staged

Edit [.lintstagedrc](../.config/.lintstagedrc) to configure your tasks.

```js
{
  "*.{md,markdown}": [
    "make check-spelling",
    "make lint-markdown"
  ]
}
```

Based on this sample configuration, it will:

- target markdown files only
- run 2 Makefile commands in sequence

⚠️ **IMPORTANT**: Commands run in sequence however; all tasks run in parallel by default, and may cause race conditions. See [Task concurrency](https://github.com/lint-staged/lint-staged?tab=readme-ov-file#task-concurrency)

```js
// 🚫 Don't do this. Both globs target the same file
{
  "README.md": "make toc",
  "*.md": "make lint-markdown"
}
```

### commitlint-cli

Edit [commitlint.config.js](../.config/commitlint.config.js) to configure your own conventional commits rules.

```js
module.exports = {
  parserPreset: "conventional-changelog-conventionalcommits",
  rules: {
    "type-enum": [
      2,
      "always",
      [
        "feat",
        "fix",
        "test"
      ]
    ]
  }
};
```

Based on this sample configuration, it will:

- parse git commit messages with the `conventional commits` preset
- only these three types of commit message will be valid:
  - 👌 `git commit -m "feat: something"` will be a valid commit message
  - 👌 `git commit -m "fix: something"` will be a valid commit message
  - 👌 `git commit -m "test: something"` will be a valid commit message
- any other type of commit message won't be valid:
  - ⛔ `git commit -m "docs: something"` won't be a valid commit message
  - ⛔ `git commit -m "chore: something"` won't be a valid commit message

### semantic-release

This tool runs the following [steps](https://github.com/semantic-release/semantic-release/blob/master/docs/usage/plugins.md#plugins), implemented by configurable [plugins](https://github.com/semantic-release/semantic-release/blob/master/docs/extending/plugins-list.md):

- `verifyConditions`
- `analyzeCommits`
- `verifyRelease`
- `generateNotes`
- `prepare`
- `publish`
- `success` / `fail`

To know more about plugins, read the [Plugin developer guide](https://github.com/semantic-release/semantic-release/blob/master/docs/developer-guide/plugin.md)

Edit [.releaserc](../.config/.releaserc) to configure the release automation; i.e.

```json
{
  "branches": [ "main", "master" ],
  "plugins": [
    [
      "@semantic-release/commit-analyzer",
      { "preset": "conventionalcommits" }
    ],
    [
      "@semantic-release/release-notes-generator",
      { "preset": "conventionalcommits" }
    ],
    "@semantic-release/npm",
    "@semantic-release/git"
  ]
}
```

Based on this sample configuration, it will:

- create new releases only from **main** and **master** branches
- run the following plugins in order:
  1. [commit-analyzer](https://github.com/semantic-release/commit-analyzer) to analyze commit messages and determine the type of release (fix, feature, breaking change), and used to generate the next version number (major, minor, patch)
  2. [release-notes-generator](https://github.com/semantic-release/release-notes-generator) to generate a markdown document
  3. [npm](https://github.com/semantic-release/npm) to update `package.json` version
  4. [git](https://github.com/semantic-release/git) to create a GitHub release
- use the conventional commits preset to analyze commits in the branch since last release
- use the conventional commits preset to generate the release notes (not to be confused with the changelog!)
- bump the version of the `package.json` file, following [semantic versioning](https://semver.org/) specification
- push a release commit and create a version tag

⚠️ **IMPORTANT**: You need to have at least one release branch specified; and this branch needs to exist in the remote repository.

The remote repository must be configured in `package.json`. This can be done running `bun pm pkg set repository.url='github:user/repo'`

---

You can customize even further the release notes generator:

```json
[
  "@semantic-release/release-notes-generator",
  {
    "preset": "conventionalcommits",
    "presetConfig": {
      "types": [
        { "type": "feat", "section": "Features" },
        { "type": "fix", "section": "Bug Fixes" }
      ]
    },
    "writerOpts": {
      "headerPartial": "", //👈 insert your handlebars template
      "commitPartial": "", //👈 insert your handlebars template
      "footerPartial": "" //👈 insert your handlebars template
    }
  }
]
```

With this configuration, it will:

- include only features and fixes in the release notes
- use your custom templates for generating the release notes

⚠️ **IMPORTANT**: You cannot use file names for the templates, as they won't be loaded so, you must use the template strings in the writer options. Read their [documentation](https://github.com/conventional-changelog/conventional-changelog/tree/master/packages/conventional-changelog-writer#partials).

### auto-changelog

Edit [.auto-changelog](../.config/.auto-changelog) to configure how the changelog is generated.

Edit [conventional.hbs](../res/templates/changelog/conventional.hbs) to customize the content.

### LocalStack

Edit [docker-compose.yml](../.config/docker-compose.yml) to configure environment variables, volumes and port numbers.

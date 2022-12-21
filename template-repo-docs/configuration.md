# 🔧 Configuration

## IDE Configuration

You can change settings for the IDE in these files:

- [.vscode/settings.json](/.vscode/settings.json)
- [.editorconfig](/.editorconfig)

### IDE Extensions Configuration

#### markdownlint

[Source website](https://marketplace.visualstudio.com/items?itemName=DavidAnson.vscode-markdownlint)

Edit [.markdownlintignore](/.markdownlintignore) to exclude files or paths from linting them from VS Code.

## Tools Configuration

### lint-staged

[Source website](https://github.com/okonet/lint-staged)

To configure which actions must be ran on your staged git files, edit [.lintstagedrc](/.lintstagedrc) file.

For example, you may check the spelling in text files:

```json
{
  "*.txt": "make spell-check DOCKER_INTERACTIVE=false"
}
```

With this configuration, it will:

- run the `spell-check` target from the [Makefile](/Makefile)
- set `DOCKER_INTERACTIVE` variable to `false` to indicate we're not running docker interactively from the shell

### cspell-cli

[Source website](https://github.com/streetsidesoftware/cspell-cli)

Edit [cspell.json](/cspell.json) to configure which paths to ignore, allow or forbid words.

### markdownlint-cli2

[Source website](https://github.com/DavidAnson/markdownlint-cli2)

Edit [.markdownlint-cli2.jsonc](/.markdownlint-cli2.jsonc) to configure markdown linting rules.

```json
{
  "config": {
    "MD013": false
  },
  "globs": [
    "**/*.md"
  ],
  "ignores": [
    "**/bin",
    "**/obj"
  ]
}
```

With this configuration, it will:

- switch off line length [rule](https://github.com/DavidAnson/markdownlint/blob/main/doc/Rules.md#md013)
- lint only `.md` files
- exclude any `bin` and `obj` paths

**NOTE:** The cli tool is meant to perform markdown linting from shell commands (ideally before git commits happen); while the VS Code extension will lint markdown files while editing them.

### commitlint-cli

[Source website](https://commitlint.js.org/)

Edit [commitlint.config.js](/commitlint.config.js) to configure your own conventional commits rules.

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

With this configuration, it will:

- parse git commit messages with the `conventional commits` preset
- only these three types of commit message will be valid:
  - 👌 `git commit -m "feat: something"` will be a valid commit message
  - 👌 `git commit -m "fix: something"` will be a valid commit message
  - 👌 `git commit -m "test: something"` will be a valid commit message
- any other type of commit message won't be valid:
  - ⛔ `git commit -m "docs: something"` won't be a valid commit message
  - ⛔ `git commit -m "chore: something"` won't be a valid commit message

### semantic-release

[Source website](https://github.com/semantic-release/semantic-release)

Edit [.releaserc](/.releaserc) to configure how the changelog is generated.

```json
{
  "branches": [ "main", "master" ],
  "plugins": [
    [ "@semantic-release/commit-analyzer",
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

With this configuration, it will:

- create new releases only on branches: **main** and **master**
- run the following plugins in order:
  1. [commit-analyzer](https://github.com/semantic-release/semantic-release/blob/master/docs/extending/plugins-list.md)
  2. [release-notes-generator](https://github.com/semantic-release/semantic-release/blob/master/docs/extending/plugins-list.md)
  3. [npm](https://github.com/semantic-release/semantic-release/blob/master/docs/extending/plugins-list.md)
  4. [git](https://github.com/semantic-release/semantic-release/blob/master/docs/extending/plugins-list.md)
- use the conventional commits preset to analyze commits in the branch since last release
- use the conventional commits preset to generate the release notes (this is not the changelog!)
- bump the version of the `package.json` file, following [semantic versioning](https://semver.org/) specification
- push a release commit and create a version tag, to the remote repository

🚫 **IMPORTANT:** You need to have at least one release branch specified. This branch needs to exist in the remote repository.

The remote repository must be configured in your `package.json`

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

🚫 **IMPORTANT:** You cannot use file names for the templates, as they won't be loaded so, you must use the template strings in the writer options. Read their [documentation](https://github.com/conventional-changelog/conventional-changelog/tree/master/packages/conventional-changelog-writer#partials).

The release notes generator plug-in uses [conventional-changelog](https://github.com/conventional-changelog/conventional-changelog) and their default templates can be found [here](https://github.com/conventional-changelog/conventional-changelog/tree/master/packages/conventional-changelog-writer/templates).

#### .versionrc

As seen above, semantic-release uses the commit analyser plug-in
[@semantic-release/commit-analyzer](https://github.com/semantic-release/commit-analyzer) as the very first plug-in to run, which then passes commits meta-data down the line to the next plug-in.

This plug-in uses [standard-version](https://github.com/conventional-changelog/standard-version) (as per the [conventional-changelog](https://github.com/conventional-changelog/conventional-changelog) repository)

And `standard-version` [configuration](https://github.com/conventional-changelog/standard-version#configuration) documentation allows using [.versionrc](/.versionrc) file, where we can define which git commits do we want to be considered / analysed for the release, instead of adding [releaseRules](https://github.com/semantic-release/commit-analyzer#releaserules) config block to the plug-in.

Note that by default, `@semantic-release/commit-analyzer` plug-in uses the `angular` preset; and we have configured it to use the `conventionalcommits` preset.

Therefore, we must configure `.versionrc` with _conventional commits_ rules; not _angular_ rules! (you can see their default rules [here](https://github.com/semantic-release/commit-analyzer/blob/master/lib/default-release-rules.js))

---

The second plug-in configured in semantic release would be [@semantic-release/release-notes-generator](https://github.com/semantic-release/release-notes-generator) which uses `standard-version` and the `.versionrc` file as well to filter which commits we want to be part of the release notes.

### auto-changelog

[Source website](https://github.com/CookPete/auto-changelog)

Edit [.auto-changelog](/.auto-changelog) to configure how the changelog is generated.

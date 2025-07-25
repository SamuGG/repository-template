#!/usr/bin/env bash
bun add @commitlint/cli
bun add @commitlint/config-conventional
bun add conventional-changelog-conventionalcommits

echo "make lint-commit-msg GIT_COMMIT_EDITMSG_FILE=\$1" > .husky/commit-msg
git add .husky/commit-msg

# https://commitlint.js.org/

cat <<EOF > .config/commitlint.config.js
module.exports = {
  parserPreset: "conventional-changelog-conventionalcommits",
  rules: {
    "body-leading-blank": [1, "always"],
    "body-max-line-length": [2, "always", 100],
    "footer-leading-blank": [1, "always"],
    "footer-max-line-length": [2, "always", 100],
    "header-max-length": [2, "always", 100],
    "scope-case": [2, "always", "lower-case"],
    "subject-case": [2, "always", ["sentence-case"]],
    "subject-empty": [2, "never"],
    "subject-full-stop": [2, "never", "."],
    "type-case": [2, "always", "lower-case"],
    "type-empty": [2, "never"],
    "type-enum": [2, "always",
      [
        "build",
        "chore",
        "ci",
        "docs",
        "feat",
        "fix",
        "perf",
        "refactor",
        "revert",
        "style",
        "test"
      ]
    ]
  }
};
EOF

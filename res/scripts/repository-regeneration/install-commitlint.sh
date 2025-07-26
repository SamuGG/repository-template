#!/usr/bin/env bash
# https://commitlint.js.org/

bun add --dev @commitlint/cli
bun add --dev @commitlint/config-conventional
bun add --dev conventional-changelog-conventionalcommits

echo "make lint-commit-msg GIT_COMMIT_EDITMSG_FILE=\$1" > .husky/commit-msg
git add .husky/commit-msg

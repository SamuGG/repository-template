#!/usr/bin/env bash
# https://github.com/okonet/lint-staged

bun add --dev lint-staged

echo "bun lint-staged --config .config/.lintstagedrc" > .husky/pre-commit
git add .husky/pre-commit

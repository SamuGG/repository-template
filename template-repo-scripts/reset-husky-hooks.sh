#!/usr/bin/env bash
yarn husky add .husky/commit-msg "yarn commitlint --edit \$1"
yarn husky add .husky/pre-commit "yarn lint-staged --concurrent false"

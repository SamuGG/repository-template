#!/usr/bin/env bash
yarn add lint-staged --dev

yarn husky add .husky/pre-commit "yarn lint-staged --config .config/.lintstagedrc"
git add .husky/pre-commit

# https://github.com/okonet/lint-staged

cat <<EOF > .config/.lintstagedrc
{
  "*.{md,markdown}": [
    "make check-spelling DOCKER_INTERACTIVE=false",
    "make lint-markdown DOCKER_INTERACTIVE=false"
  ],
  "README.md": "make toc DOCKER_INTERACTIVE=false",
  "*.tf": "make lint-terraform DOCKER_INTERACTIVE=false"
}
EOF

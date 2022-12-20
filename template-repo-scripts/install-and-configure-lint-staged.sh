# !/bin/sh
yarn add lint-staged --dev

yarn husky add .husky/pre-commit "yarn lint-staged --concurrent false"
git add .husky/pre-commit

# https://github.com/okonet/lint-staged

cat <<EOF > .lintstagedrc
{
  "*.md": [
    "make lint-markdown DOCKER_INTERACTIVE=false",
    "make spell-check DOCKER_INTERACTIVE=false"
  ],
  "README.md": "make toc-markdown DOCKER_INTERACTIVE=false"
}
EOF

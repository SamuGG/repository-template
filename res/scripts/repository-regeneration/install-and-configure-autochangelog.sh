#!/usr/bin/env bash
yarn add auto-changelog --dev

npm pkg set scripts.version="auto-changelog --package && git add CHANGELOG.md"

# https://github.com/CookPete/auto-changelog

cat <<EOF > .config/.auto-changelog
{
  "template": "templates/changelog/conventional.hbs",
  "unreleased": true,
  "commitLimit": false
}
EOF

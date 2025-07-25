#!/usr/bin/env bash
bun add auto-changelog

bun pm pkg set scripts.version="auto-changelog --package && git add CHANGELOG.md"

# https://github.com/CookPete/auto-changelog

cat <<EOF > .config/.auto-changelog
{
  "template": "templates/changelog/conventional.hbs",
  "unreleased": true,
  "commitLimit": false
}
EOF

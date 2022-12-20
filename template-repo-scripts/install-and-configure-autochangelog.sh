# !/bin/sh
yarn add auto-changelog --dev

npm pkg set scripts.version="auto-changelog --package && git add CHANGELOG.md"

# https://github.com/CookPete/auto-changelog

cat <<EOF > .auto-changelog
{
  "template": "templates/changelog/conventional.hbs",
  "unreleased": true,
  "commitLimit": false
}
EOF

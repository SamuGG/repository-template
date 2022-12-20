# !/bin/sh
echo "LICENSE" > .markdownlintignore

cat <<EOF > .markdownlint-cli2.jsonc
{
  "config": {
    "MD013": false
  },
  "globs": [
    "**/*.md"
  ],
  "ignores": [
    ".yarn/**",
    "node_modules/**",
    "**/bin",
    "**/obj",
    "/LICENSE"
  ]
}
EOF

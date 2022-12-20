# !/bin/sh
cat <<EOF > cspell.json
{
  "version": "0.2",
  "language": "en-GB",
  "words": [
    "commitlint",
    "devcontainer",
    "doctoc",
    "conventionalcommits"
  ],
  "flagWords": [
    "hte"
  ],
  "ignorePaths": [
    "node_modules",
    "bin",
    "obj",
    "*.lock",
    "/.*rc",
    "/cspell.json",
    "/package*.json",
    "Makefile",
    "LICENSE"
  ]
}
EOF

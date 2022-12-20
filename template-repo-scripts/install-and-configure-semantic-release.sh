# !/bin/sh
yarn add semantic-release --dev
yarn add @semantic-release/changelog --dev
yarn add @semantic-release/git --dev

# https://semantic-release.gitbook.io/semantic-release/

cat <<EOF > .releaserc
{
  "branches": [ "main", "master" ],
  "ci": false,
  "plugins": [
    [ "@semantic-release/commit-analyzer", { "preset": "conventionalcommits" } ],
    [ 
      "@semantic-release/release-notes-generator",
      {
        "preset": "conventionalcommits",
        "presetConfig": {
          "types": [
            { "type": "feat", "section": "Features" },
            { "type": "fix", "section": "Bug Fixes" },
            { "type": "perf", "section": "Performance Improvements" },
            { "type": "revert", "section": "Reverts" },
            { "type": "docs", "section": "Documentation", "hidden": false },
            { "type": "style", "section": "Styles", "hidden": false },
            { "type": "chore", "section": "Miscellaneous Chores", "hidden": false },
            { "type": "refactor", "section": "Code Refactoring", "hidden": false },
            { "type": "test", "section": "Tests", "hidden": false },
            { "type": "build", "section": "Build System", "hidden": false },
            { "type": "ci", "section": "Continuous Integration", "hidden": false }
          ]
        },
        "linkCompare": false,
        "linkReferences": false,
        "writerOpts": {
          "headerPartial": "# Release Notes\n\n## {{#if @root.linkCompare~}}[{{version}}]({{compareUrlFormat}}){{~else}}{{~version}}{{~/if}}{{~#if title}} {{title}}{{~/if}}{{~#if date}} ({{date}}){{/if}}",
          "commitPartial": "- {{#if scope~}}**{{scope}}:** {{/if}}{{~#if subject}}{{~subject}}{{~else}}{{~header}}{{~/if}}{{~#if hash}} {{#if @root.linkReferences~}}([{{shortHash}}]({{commitUrlFormat}})){{~else}}{{~shortHash}}{{~/if}}{{~/if}}\n",
          "footerPartial": "\n"
        }
      }
    ],
    "@semantic-release/npm",
    "@semantic-release/git"
  ]
}
EOF

cat <<EOF > .versionrc
{
  "types": [
    { "type": "feat", "section": "Features" },
    { "type": "fix", "section": "Bug Fixes" },
    { "type": "chore", "section": "Chores" },
    { "type": "docs", "section": "Documentation" },
    { "type": "style", "hidden": true },
    { "type": "refactor", "hidden": true },
    { "type": "perf", "section": "Performance" },
    { "type": "test", "hidden": true },
    { "type": "build", "hidden": true },
    { "type": "ci", "hidden": true },
    { "type": "revert", "hidden": true }
  ]
}
EOF

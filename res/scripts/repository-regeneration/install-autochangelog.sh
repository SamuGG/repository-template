#!/usr/bin/env bash
# https://github.com/CookPete/auto-changelog

bun add --dev auto-changelog
bun pm pkg set scripts.version="auto-changelog --package && git add CHANGELOG.md"

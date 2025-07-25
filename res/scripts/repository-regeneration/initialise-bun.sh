#!/usr/bin/env bash
bun init --private

bun pm pkg set \
  description='Custom repository template' \
  version='0.0.0' \
  license='ISC' \
  repository.type='git' \
  repository.url='github:user/repo'

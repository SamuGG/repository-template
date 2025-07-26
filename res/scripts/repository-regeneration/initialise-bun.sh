#!/usr/bin/env bash
# https://bun.com/docs

bun init

bun pm pkg set \
  description='Custom repository template' \
  version='0.0.0' \
  private=true \
  license='ISC' \
  repository.type='git' \
  repository.url='github:user/repo'

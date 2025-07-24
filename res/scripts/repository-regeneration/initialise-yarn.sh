#!/usr/bin/env bash
yarn init --private

npm pkg set \
  description='Custom repository template' \
  version='0.0.0' \
  license='ISC' \
  repository.type='git' \
  repository.url='github:user/repo'

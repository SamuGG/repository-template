# !/bin/sh
yarn init --private

npm pkg set \
  description='Custom development automation toolset' \
  version='0.0.0' \
  license='ISC' \
  repository.type='git' \
  repository.url='github:user/repo'

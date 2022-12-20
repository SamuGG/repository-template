# !/bin/sh
yarn add husky --dev
npm pkg set scripts.postinstall="husky install"

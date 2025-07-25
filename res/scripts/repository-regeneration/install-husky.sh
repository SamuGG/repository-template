#!/usr/bin/env bash
yarn add husky --dev
npm pkg set scripts.postinstall="husky"

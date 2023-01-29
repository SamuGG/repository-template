#!/usr/bin/env bash
sudo chown vscode .yarn && \
bash template-repo-scripts/generate-global-gitignore.sh && \
bash template-repo-scripts/configure-global-gitconfig.sh && \
make clean install

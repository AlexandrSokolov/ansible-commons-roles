#!/usr/bin/env bash

# copy all shared roles
rm -rf ~/.ansible/common_roles && \
mkdir -p ~/.ansible/common_roles && \
cp -r roles/* ~/.ansible/common_roles && \
echo "SUCCESS: All common roles have been copied from \`roles\` into \`~/.ansible/common_roles\` folder."

cp -r files ~/.ansible/ && \
echo "SUCCESS: The \`files\` folder has been copied into \`~/.ansible\` folder."

./scripts/extendScriptsPath.sh

#!/usr/bin/env bash

# copy all shared roles
rm -rf ~/.ansible/common_roles
mkdir -p ~/.ansible/common_roles
cp -r roles/* ~/.ansible/common_roles

cp -r files ~/.ansible/

./scripts/extendScriptsPath.sh

#!/usr/bin/env bash

# copy all shared roles
mkdir -p ~/.ansible/common_roles
cp -r roles/* ~/.ansible/common_roles

./scripts/extendScriptsPath.sh

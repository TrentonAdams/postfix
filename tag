#!/bin/bash

source ./xpath

echo "Current version: $(cat .version)"
echo -n "Enter new version: "
read -r version
echo -n $version > .version
git commit -m "- update version to $version" ./ && \
git tag $version && \
git push --all && \
git push --tags

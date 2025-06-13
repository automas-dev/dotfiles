#!/bin/bash

if [ $# -ne 1 ]; then
    echo "Usage: $0 <version>"
    exit 1
fi

VERSION=$1

git tag -a $VERSION -m $VERSION
git push
git checkout master
git merge development
git push
git push --tags
git checkout development

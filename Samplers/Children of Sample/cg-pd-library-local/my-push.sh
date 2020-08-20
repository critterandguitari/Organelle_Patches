#!/bin/sh

Poopy=$1

set -e

git add .
git commit -am "$Poopy"
git push -u origin master

exit 0


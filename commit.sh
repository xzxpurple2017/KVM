#!/bin/bash

git add *
git commit -m "$*"
git push git@github.com:r57shell/$(pwd | sed 's/\// /g' | awk '{print $NF}').git

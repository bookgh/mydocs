#!/bin/bash

source /opt/py3/bin/activate

make clean

git add .
git commit -m 'first commit'
git push

#!/bin/bash

GIT="/usr/bin/git"

echo "=============================="
echo "using git: $GIT"
echo "=============================="

#browserpairs
$GIT --git-dir=/home/moztw/repo/browser-pairs/.git pull origin master

#Error 451: blackout
$GIT --git-dir=/home/moztw/repo/TW-Error451-Blackout/.git pull origin gh-pages


#!/bin/bash

GIT="/usr/bin/git"

echo "=============================="
echo "using git: $GIT"
echo "=============================="

#browserpairs
$GIT --git-dir=/home/moztw/htdocs/www/foxmosa/game/pairs/.git pull origin master

#Error 451: blackout
$GIT --git-dir=/home/moztw/git-tw-blackout/.git pull origin gh-pages


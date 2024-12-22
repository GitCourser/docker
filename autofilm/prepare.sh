#!/bin/bash

wget https://github.com/$REPO/archive/refs/tags/$VER1.tar.gz
tar -zxf $VER1.tar.gz
mv AutoFilm-$VER2/app .
mv AutoFilm-$VER2/requirements.txt .
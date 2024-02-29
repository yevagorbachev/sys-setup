#!/usr/bin/bash

rename "s/__NAME/$1/" * -v
find . -type f -exec sed -i "s/__NAME/$1/g" {} +

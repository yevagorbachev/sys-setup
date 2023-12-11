#!/usr/bin/bash

rename "s/__NAME/$1/" *
find . -type f -exec sed -i "s/__NAME/$1/g" {} +

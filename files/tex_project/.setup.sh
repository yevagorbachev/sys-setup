#!/usr/bin/bash

rename "s/__NAME/$1/" *
sed -i "s/__NAME/$1/g" * 

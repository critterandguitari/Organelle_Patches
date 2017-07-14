#!/bin/sh
if xprop -root &> /dev/null; then
    echo "X server found..."
    exit 1
else
    echo "X server not found..."
    exit 0
fi

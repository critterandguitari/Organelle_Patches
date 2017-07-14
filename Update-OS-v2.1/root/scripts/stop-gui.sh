#!/bin/sh
jwm -exit
/root/scripts/start-mother.sh > /dev/null 2>&1
/root/scripts/welcome.sh

#!/bin/sh

awk -v version="$1" '
/^# / { if (p) { exit }; if ($2 == version) { p=1; next } } p && NF
' CHANGELOG.md

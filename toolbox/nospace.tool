#!/bin/bash
for file in "$@"; do
    mv -vn "$file" "$(echo "$file" | sed -r "s/['&,()!]//g;s/ - /-/g;s/ _ /_/g;s/ /_/g;s/__/_/g")"
done;

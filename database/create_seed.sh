#!/usr/bin/env bash

scripts_dir="../scripts"
seed_file="seed.sql"

# Scripts to ignore
denylist=(
  "5_requests.sql"
)

rm -f $seed_file
scripts=$(ls $scripts_dir)
for script in $scripts; do
  [[ " ${denylist[@]} " =~ " ${script} " ]] && continue
  echo "Adding $script to $seed_file"
  cat "$scripts_dir/$script" >> $seed_file
done
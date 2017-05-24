#!/bin/bash

path=$1

if [[ -n "$path" ]]; then
  git fetch origin refs/svn/map:refs/notes/commits
  cat $path | git notes copy --stdin
  cat $path | cut -d' ' -f 1 | git notes remove --stdin
  git notes prune
  git update-ref refs/notes/commits $(git commit-tree refs/notes/commits^{tree} -m "notes squashed")
  git fetch
  git push origin +refs/notes/*:refs/notes/*
  git log --pretty=format:"%H %N" --show-notes * >> notes.log
  echo "commits with notes logged to notes.log"
else
  echo "missing path to object-id-map.old-new.txt"
fi

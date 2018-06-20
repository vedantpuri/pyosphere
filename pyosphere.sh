#!/bin/sh
# pyosphere.sh
# Author(s): Vedant Puri
# Contributer(s): Mayank Kumar
# Version: 1.0.0
# Atom -> Tab Indent Level: 2

get_last_internal_nodes()
{
  for file in "$1"/*
  do
    if [[ -d "$file" ]]
    then
      echo "$file"
      get_last_internal_nodes "$file"
    fi
  done
}

get_last_internal_nodes "."

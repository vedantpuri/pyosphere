#!/bin/sh
get_last_internal_nodes(){
    for file in "$1"/*
    do
    if [ -d "$file" ]
    then
            echo "$file"
            get_last_internal_nodes "$file"
    fi
    done
}

get_last_internal_nodes "."

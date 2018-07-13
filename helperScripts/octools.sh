#!/bin/bash
#
# These functions are ment for easier use of oc rsh:
# You can can give the pod name without the random letters an the end, the script greps the full name by itself
# ocrshn also accepts a namespace
# Bash completion is also working, but is slow
#
# Installation: Source it in your bash ;) (or whatever shell you use)
#
function ocrsh() {
    PROJECT=$(oc project | cut -d'"' -f2)
    PODS=$(oc get pods -n $PROJECT | grep "Running" | head -n 1 | cut -d' ' -f1 )
    [[  -z $PODS ]] && echo "No PODS found" && return
    echo "Matching Pods $PROJECT/$PODS"
    oc rsh -n $PROJECT $PODS
}

function ocrshn() {
    PROJECT=$2
    PODS=$(oc get pods -n $PROJECT | grep "Running" | head -n 1 | cut -d' ' -f1 )
    [[  -z $PODS ]] && echo "No PODS found" && return
    echo "Matching Pods $PROJECT/$PODS"
    oc rsh -n $PROJECT $PODS
}

_ocrsh()
{
    local cur
    PROJECT=$(oc project | cut -d'"' -f2)

    COMPREPLY=()
    cur=${COMP_WORDS[COMP_CWORD]}
    if [ $COMP_CWORD -eq 1 ]; then
        # pods
        PODS=$(oc get pods -n $PROJECT | grep "Running" | cut -d' ' -f1 | tr "\n" " ")
        COMPREPLY=( $( compgen -W '$PODS' -- $cur ) )
    fi
}
complete -F _ocrsh ocrsh

_ocrshn()
{
    local cur prev

    COMPREPLY=()
    cur=${COMP_WORDS[COMP_CWORD]}
    prev=${COMP_WORDS[COMP_CWORD-1]}
    if [ $COMP_CWORD -eq 1 ]; then
        # namespaces
        NAMESPACES=$(oc get projects --no-headers | cut -d' ' -f1 | tr "\n" " ")
        COMPREPLY=( $( compgen -W '$NAMESPACES' -- $cur ) )
    elif [ $COMP_CWORD -eq 2 ]; then
        # pods
        PODS=$(oc get pods -n $prev | grep "Running" | cut -d' ' -f1 | tr "\n" " ")
        COMPREPLY=( $( compgen -W '$PODS' -- $cur ) )
    fi
}
complete -F _ocrshn ocrshn

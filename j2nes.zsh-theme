#!/bin/env zsh

PROMPT_SYMBOL="\u2771"

prompt-symbol() { print -n "%{$fg[cyan]%}$PROMPT_SYMBOL%{$reset_color%} " }

PROMPT="$(prompt-symbol)"
RPROMPT="%20<...<%~%<<"

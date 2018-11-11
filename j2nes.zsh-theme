#!/bin/env zsh

PROMPT_SYMBOL="\uf101"

prompt-symbol() { print -n "%{$fg[cyan]%}$PROMPT_SYMBOL%{$reset_color%} " }

PROMPT="
$(prompt-symbol)"

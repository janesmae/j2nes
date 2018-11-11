#!/bin/env zsh

PROMPT_SYMBOL="❱"

prompt-symbol() { print -n "%{$fg[cyan]%}$PROMPT_SYMBOL%{$reset_color%} " }

PROMPT="
$(prompt-symbol)"

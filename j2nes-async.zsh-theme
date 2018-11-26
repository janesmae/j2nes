#!/bin/env zsh

## J2nes - A theme for ZSH
#  Copyright 2018 Jaan Jänesmäe <git@janesmae.com>
#  Licence: MIT

### Configuration options

ZSH_THEME_PROMPT_SYMBOL="\u2771"				# Symbol for left prompt
ZSH_THEME_PROMPT_COLOR="cyan"					# Default color for prompt symbol
ZSH_THEME_PROMPT_COLOR_PRIVILEGED="red"				# Default color if user is privileged

ZSH_THEME_GIT_COLOR="green"					# Color of branch name if  no staged commits
ZSH_THEME_GIT_COLOR_ICONS=240					# Color of icons (dark grey)
ZSH_THEME_GIT_COLOR_CHANGESTOCOMMIT="yellow"			# Color of branch is there are staged changes to commit
ZSH_THEME_GIT_SYMBOL="\ue0a0"					# Git branch icon
ZSH_THEME_GIT_SYMBOL_UNTRACKEDFILES="\uf713"			# Icon to track untracked files
ZSH_THEME_GIT_SYMBOL_CHANGESNOTSTAGED="\u00b1"			# Icon to track not staged changes
ZSH_THEME_GIT_SYMBOL_STASHES="\ufb12"				# Icon to track stashes
ZSH_THEME_GIT_SYMBOL_AHEAD="\uf176"				# Icon to track if local repo is ahead
ZSH_THEME_GIT_SYMBOL_BEHIND="\uf175"				# Icon to track if local repo is behind

prompt-symbol() { print -n "%{$fg[cyan]%}$ZSH_THEME_PROMPT_SYMBOL%{$reset_color%} " }

git-status() {
	cd -q $1 && git status
}
setopt prompt_subst

async_init
async_start_worker lprompt -n
lprompt_complete() {
	local branch gitstatus col newprompt output=$@
	branch=$(=git symbolic-ref HEAD 2> /dev/null)


	if [[ -n $branch ]]; then
		
		state="$(=git status 2> /dev/null)"
		color=$ZSH_THEME_GIT_COLOR

		if [[ ${state} =~ "Changes to be committed" ]]; then¬
			color=$ZSH_THEME_GIT_COLOR_CHANGESTOCOMMIT¬
		fi

		if [[ -n `git stash list 2> /dev/null` ]]; then
			giticons="$giticons$ZSH_THEME_GIT_SYMBOL_STASHES"
		fi

		if [[ ${state} =~ "Changes not staged for commit" ]]; then
			giticons="$giticons$ZSH_THEME_GIT_SYMBOL_CHANGESNOTSTAGED"
		fi

		if [[ ${state} =~ "Untracked files" ]]; then
			giticons="$giticons$ZSH_THEME_GIT_SYMBOL_UNTRACKEDFILES"
		fi

		if [[ ${state} =~ "ahead" ]]; then
			giticons="$giticons$ZSH_THEME_GIT_SYMBOL_AHEAD"
		fi

		if [[ ${state} =~ "behind" ]]; then
			giticons="$giticons$ZSH_THEME_GIT_SYMBOL_BEHIND"
		fi

		newprompt="$ZSH_THEME_GIT_SYMBOL%F{$color}${branch#refs/heads/}%f"

		if [[ -n $giticons ]]; then
			newprompt="$newprompt%F{$ZSH_THEME_GIT_COLOR_ICONS}$giticons%f"
		fi

	fi

	G_PROMPT="$(print -n $newprompt)"
	async_job lprompt git-status $(pwd) 
}

async_register_callback lprompt lprompt_complete

#function precmd() { 
	async_job lprompt git-status $(pwd)
	
#}

TMOUT=1
TRAPALRM() { zle reset-prompt }
username="%n"
path_string="%3c"
precmd() {
	date_string=$(date +'%Y-%m-%d %H:%M:%S')
}

PROMPT="$(prompt-symbol)"
RPROMPT='$G_PROMPT %~'

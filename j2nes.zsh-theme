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

### Set prompt options
#   cr: Print a carriage return just before printing a prompt in the line editor.
#   percent: ‘%’ is treated specially in prompt expansion
#   subst: Parameter expansion, command substitution and arithmetic expansion are performed in prompts.

prompt_opts=(cr percent subst)

### User
#   Check if user is privileged, change prompt symbol color if conditions are met

prompt_user() {
	local color
	[[ $(print -P "%#") == '#' ]] && color=$ZSH_THEME_PROMPT_COLOR_PRIVILEGED || color=$ZSH_THEME_PROMPT_COLOR
	# [[ $UID == 0 || $EUID == 0 ]] && color=$ZSH_THEME_PROMPT_COLOR_PRIVILEGED || color=$ZSH_THEME_PROMPT_COLOR
	print -n "%F{$color}$ZSH_THEME_PROMPT_SYMBOL%f "
}

### Current Working Directory
#   Display the current working directory, limit line size to 20 characters.

prompt_cwd()
{
	print -n " %20<...<%~%<<"
}

### Git
#   Display info if CWD is a git repository
#   Tracking:
#     - current branch
#     - changes staged for commit
#     - changes not staged for commit
#     - untracked files
#     - if branch is ahead or behind (if local repo has this information)
#     - stashes

prompt_git()
{
	local branch state head giticons color
	branch=$(=git symbolic-ref HEAD 2> /dev/null)

	if [[ -n $branch ]]; then

		state="$(=git status 2> /dev/null)"
		color=$ZSH_THEME_GIT_COLOR

		if [[ ${state} =~ "Changes to be committed" ]]; then
			color=$ZSH_THEME_GIT_COLOR_CHANGESTOCOMMIT
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

		print -n "$ZSH_THEME_GIT_SYMBOL%F{$color}${branch#refs/heads/}%f"

		if [[ -n $giticons ]]; then
			 print -n "%F{$ZSH_THEME_GIT_COLOR_ICONS}$giticons%f"
		fi

	fi

}

### Create prompts

generate_left_prompt()
{
	prompt_user
}

generate_right_prompt()
{
	prompt_git
	prompt_cwd
}

prompt_precmd()
{
	PROMPT="$(generate_left_prompt)"
	RPROMPT="$(generate_right_prompt)"
}
add-zsh-hook precmd prompt_precmd

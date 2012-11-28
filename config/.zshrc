# run client in terminal
alias -g en="my_emacs -c -nw"
# run client in new frame
alias -g ec="my_emacs -c -n"
# run client in existing frame
alias -g e="my_emacs -n"

alias -g gx="git annex"

alias -g vi="vim"
alias -g x="xdg-open"

export GPG_TTY=`tty`


# Path to your oh-my-zsh configuration.
ZSH=/usr/share/oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
#ZSH_THEME="random"
#ZSH_THEME="robbyrussell"
ZSH_THEME="alanpeabody"
#ZSH_THEME="darkblood"
#dpoggi
#ZSH_THEME=jreese
#ZSH_THEME=juanhurtade#(kein return code)
#bira
#clean
# blinks (krc)a


# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Comment this out to disable weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
# COMPLETION_WAITING_DOTS="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git)

source $ZSH/oh-my-zsh.sh


if (( EUID != 0 )); then
		local ucol='$fg[blue]'
else
		local ucol='$fg[red]'
fi

local user='%{'$ucol'%}%n%{$reset_color%}'
local pwd='%{$fg[blue]%}%~%{$reset_color%}'

my_git_prompt (){
#		if ; then
		if git rev-parse git-annex > /dev/null 2>&1; then
#				echo 1>&2
				echo "%{$fg[green]%}git-%{$fg[blue]%}annex%{$reset_color%}"
	  else
				echo "$(git_prompt_status)%{$reset_color%}$(git_prompt_info)%{$reset_color%}"
	  fi
}
local git_branch=

ZSH_THEME_GIT_PROMPT_ADDED="%{$fg[green]%}[A]"
ZSH_THEME_GIT_PROMPT_MODIFIED="%{$fg[blue]%}[M]"
ZSH_THEME_GIT_PROMPT_DELETED="%{$fg[red]%}[D]"
ZSH_THEME_GIT_PROMPT_RENAMED="%{$fg[magenta]%}[R]"
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg[yellow]%}[MERGE]"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[cyan]%}[U]"


ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[green]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY=""
ZSH_THEME_GIT_PROMPT_CLEAN=""

# HOSTCOLORS:

declare -A hostcolor
hostcolor[debussy]=$fg[yellow]
hostcolor[scriabin]=$fg[green]

PROMPT="%(?..%{$fg[red]%}%?%1v )${user}${NO_COLOUR}@%{${hostcolor[`hostname`]}%}%m${NO_COLOUR} %40<...<%B%~%b%<<$ "
RPROMPT='$(my_git_prompt)'
#git_branch}"

DONTSETRPROMPT=1

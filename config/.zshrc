# this is needed for example on the current strauss ubuntu configuration for TRAMP in emacs (with scpc)
if [ "$TERM" = "dumb" ]
then
		return #exit will kill the whole shell on ssh login
fi

#use the "ends with a space trick" (see man zshall) for alias expansion after a sudo:
# env PATH=$PATH is insecure and breaks options passed to sudo!
alias sudo='command sudo'

# run client in terminal
alias  en="my_emacs -c -nw"
# run client in new frame
alias  ec="my_emacs -c -n"
# run client in existing frame
alias  e="my_emacs -n"

alias -g gx="git annex"
alias gvp="git verify-pull"
alias gvl="git verify-log"
alias gil="git log --graph --decorate --abbrev-commit"
alias gsp="git commit-sign-push"

alias scl="sudo systemctl"
alias uumount="udevil umount"

alias latexdiff2="latexdiff-vc --git  --packages=amsmath,hyperref -c \"$CBI/config/latexdiff.cfg\""

alias feh2="feh --scale-down --keep-zoom-vp --action2 'xrename \"%f\" ' "

alias -g vi="vim"
# global collides with unrar x so use \x
#alias -g x="xdg-open"
# I created a small script instead
alias -g xa="xargs -d '\n' "

alias r="ranger"
alias mut="TMUX= tmux -2 new-session -ds mutt mutt; tmux switch-client -t mutt"

alias hd=/home/data

alias f="find"
alias pidgin="pidgin -c /home/data/personal/misc/pidgin"

alias egrep="egrep --color=auto"
alias egrepc="egrep --color=always"

alias curlf="curl -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:27.0) Gecko/20100101 Firefox/27.0'"
# alias mpv="mpv --save-position-on-quit" # alternativ, beenden mit `U` 
alias mpvl="mpv -playlist /dev/fd/0"

alias cmatrix="cmatrix -b -a -u 3"

alias udm="udevil mount"
alias udu="udevil umount"


export MAIL=$HOME/Mail/local
export GPG_TTY=`tty`
export BROWSER=firefox

unsetopt correct_all
unsetopt correct

# does not work anymore since grml-zsh 0.8: DONTSETRPROMPT=1
#instead:
prompt off


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
DISABLE_AUTO_UPDATE="true"

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
COMPLETION_WAITING_DOTS="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git vi-mode)

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

function my_vi_mode() {
  echo "${${KEYMAP/vicmd/$}/(main|viins)/}"
}

PROMPT="%(?..%{$fg[red]%}%?%1v )${user}${NO_COLOUR}@%{${hostcolor[`hostname`]}%}%m${NO_COLOUR} %40<...<%B%~%b%<<\$ "
RPROMPT='$(my_git_prompt) $(vi_mode_prompt_info)'
#git_branch}"



if [ "$CBI_MACHINE" = 'scriabin' -o "$CBI_MACHINE" = 'debussy' ]; then
HISTFILE=/home/data/personal/zsh_history
fi
HISTSIZE=5000000
SAVEHIST=5000000
setopt HIST_FIND_NO_DUPS
# setopt HIST_IGNORE_DUPS #is default
unsetopt HIST_IGNORE_ALL_DUPS

#make the esc key faster (to exit vi insert mode!
KEYTIMEOUT=1


# archey # takes sometimes too lon gto spawn a terminal!
# cd /home
unsetopt correct_all

setopt BRACE_CCL #allow {a-z} expansion


alias history="fc -nlE 0"
alias history_sorted="fc -nlE 0 | sort -k3n -k2n -k1n -t ."

alias -g en="emacsclient -nw"
alias -g ec="emacsclient -c -n"
alias -g e="emacsclient -n"
alias -g vi="vim"

export GPG_TTY=`tty`



#Deactivate Oh-my-zsh
return 

# Path to your oh-my-zsh configuration.
ZSH=/usr/share/oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="alanpeabody" #robbyrussell"
#alanpeabody
#darkblood
#dpoggi
# juanghurtade (kein return code)
#jreese
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

# Customize to your needs...


if [ "$TERM" = "dumb" ]
then
unsetopt zle
unsetopt prompt_cr
unsetopt prompt_subst
# unfunction precmd # these two are not
# unfunction preexec # working for me
PS1='$ '
fi


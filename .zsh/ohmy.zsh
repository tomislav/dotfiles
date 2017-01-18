export ZSH=/Users/tomislav/.oh-my-zsh

ZSH_THEME="powerlevel9k/powerlevel9k"

DEFAULT_USER=tomislav

POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(context dir vcs)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status time)
POWERLEVEL9K_STATUS_VERBOSE=false
POWERLEVEL9K_SHORTEN_DIR_LENGTH=3
POWERLEVEL9K_SHORTEN_STRATEGY="truncate_middle"

plugins=(git brew docker fasd pod warhol zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

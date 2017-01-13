export ZSH=/Users/tomislav/.oh-my-zsh

ZSH_THEME="powerlevel9k/powerlevel9k"

ENABLE_CORRECTION="true"
DEFAULT_USER=tomislav

POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(context dir vcs)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status time)
POWERLEVEL9K_STATUS_VERBOSE=false

plugins=(git docker fasd pod warhol)

source $ZSH/oh-my-zsh.sh

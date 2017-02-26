source /usr/local/share/antigen/antigen.zsh

antigen use oh-my-zsh

antigen bundle git
antigen bundle command-not-found
antigen bundle brew
antigen bundle docker
antigen bundle fasd
antigen bundle pod
antigen bundle ssh-agent

antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle zsh-users/zsh-completions
antigen bundle zsh-users/zsh-autosuggestions

antigen bundle unixorn/warhol.plugin.zsh
antigen bundle peterhurford/git-aliases.zsh

# Theme
DEFAULT_USER=tomislav
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(context dir vcs)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status time)
POWERLEVEL9K_STATUS_VERBOSE=false
POWERLEVEL9K_SHORTEN_DIR_LENGTH=3
POWERLEVEL9K_SHORTEN_STRATEGY="truncate_middle"

antigen theme bhilburn/powerlevel9k powerlevel9k

# Tell antigen that we're done
antigen apply

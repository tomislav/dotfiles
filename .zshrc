TERM=xterm-256color
DEFAULT_USER=tomislav

SPACESHIP_EXEC_TIME_ELAPSED=10

export ZPLUG_HOME=/usr/local/opt/zplug
source $ZPLUG_HOME/init.zsh

zplug "plugins/git", from:oh-my-zsh
zplug "plugins/command-not-found", from:oh-my-zsh
zplug "plugins/brew", from:oh-my-zsh
zplug "plugins/docker", from:oh-my-zsh
zplug "plugins/pod", from:oh-my-zsh
zplug "plugins/osx", from:oh-my-zsh
zplug "plugins/bundler", from:oh-my-zsh
zplug "plugins/xcode", from:oh-my-zsh

zplug "zsh-users/zsh-completions", defer:0
zplug "zsh-users/zsh-autosuggestions", defer:2
zplug "zsh-users/zsh-syntax-highlighting", defer:2
zplug "zsh-users/zsh-history-substring-search", defer:3

# zplug "unixorn/warhol.plugin.zsh", from:github
# zplug "mahori/zsh-grc", from:github
zplug "peterhurford/git-aliases.zsh", from:github
zplug "djui/alias-tips", from:github
zplug "b4b4r07/enhancd", use:init.sh
zplug "denysdovhan/spaceship-prompt", use:spaceship.zsh, from:github, as:theme
zplug "pawel-slowik/zsh-term-title", from:github

zplug "~/.zsh", from:local
zplug "~/.fastlane/completions/", from:local, use:"*.zsh"

# Install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

# Then, source plugins and add commands to $PATH
zplug load

[[ -s "/usr/local/etc/grc.zsh" ]] && source /usr/local/etc/grc.zsh

__enhancd::filter::fuzzy() # redefine
{
    if [[ -z $1 ]]; then
        cat <&0
    else
        fuzzydirfilter "$1"
    fi
}

# tabtab source for serverless package
# uninstall by removing these lines or running `tabtab uninstall serverless`
[[ -f /usr/local/lib/node_modules/serverless/node_modules/tabtab/.completions/serverless.zsh ]] && . /usr/local/lib/node_modules/serverless/node_modules/tabtab/.completions/serverless.zsh
# tabtab source for sls package
# uninstall by removing these lines or running `tabtab uninstall sls`
[[ -f /usr/local/lib/node_modules/serverless/node_modules/tabtab/.completions/sls.zsh ]] && . /usr/local/lib/node_modules/serverless/node_modules/tabtab/.completions/sls.zsh

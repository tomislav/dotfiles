TERM=xterm-256color
DEFAULT_USER=tomislav
SPACESHIP_EXEC_TIME_ELAPSED=10
PATH="/usr/local/opt/ruby/bin:/usr/local/opt/mysql-client/bin:$HOME/Scripts:$PATH"

### Added by Zplugin's installer
source '/Users/tomislav/.zplugin/bin/zplugin.zsh'
autoload -Uz _zplugin
(( ${+_comps} )) && _comps[zplugin]=_zplugin
### End of Zplugin installer's chunk

zplugin light "denysdovhan/spaceship-prompt"

zplugin ice wait blockf lucid
zplugin light zsh-users/zsh-completions

zplugin ice wait atload"_zsh_autosuggest_start" lucid
zplugin light zsh-users/zsh-autosuggestions

zplugin ice wait atinit"zpcompinit; zpcdreplay" lucid
zplugin light zdharma/fast-syntax-highlighting

zplugin ice wait lucid atload' \
    zmodload zsh/terminfo; \
    bindkey "$terminfo[kcuu1]" history-substring-search-up; \
    bindkey "$terminfo[kcud1]" history-substring-search-down; \
    bindkey "^[[A" history-substring-search-up; \
    bindkey "^[[B" history-substring-search-down; \
'
zplugin light zsh-users/zsh-history-substring-search

zplugin ice wait pick"init.sh" lucid
zplugin light b4b4r07/enhancd

zplugin ice wait lucid
zplugin light peterhurford/git-aliases.zsh

zplugin ice wait lucid
zplugin light djui/alias-tips

zplugin ice wait lucid
zplugin light pawel-slowik/zsh-term-title

zplugin ice wait lucid
zplugin light buonomo/yarn-completion

zplugin ice wait silent
zplugin light marzocchi/zsh-notify

zplugin ice wait depth="1" as"program" atclone'./install.sh $ZPFX $ZPFX' atpull"%atclone" compile"grc.zsh" src"grc.zsh" pick'$ZPFX/bin/grc*' lucid
zplugin light garabik/grc

# snippets
zplugin ice wait lucid
zplugin snippet OMZ::plugins/git/git.plugin.zsh

zplugin ice wait lucid
zplugin snippet OMZ::plugins/command-not-found/command-not-found.plugin.zsh

zplugin ice wait lucid
zplugin snippet OMZ::plugins/brew/brew.plugin.zsh

zplugin ice wait silent
zplugin snippet OMZ::plugins/osx/osx.plugin.zsh

zplugin ice wait lucid
zplugin snippet OMZ::plugins/bundler/bundler.plugin.zsh

zplugin ice wait lucid
zplugin snippet OMZ::plugins/xcode/xcode.plugin.zsh

# local plugins
zplugin ice wait lucid
zplugin load ~/.zsh/

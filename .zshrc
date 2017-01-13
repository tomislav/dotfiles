# oh my zsh
source ~/.zsh/ohmy.zsh

# load files
files=(
  options
  path
  # completion
  locale
  exports
  aliases
  functions
  history
  locale
  rbenv
  extra
)

for file in $files; do
  source ~/.zsh/$file.zsh
done

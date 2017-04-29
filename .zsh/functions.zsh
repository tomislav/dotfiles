# change iTerm2 Profile
it2profile() { echo -e "\033]50;SetProfile=$1\a" }

# sudo previous command
sudothat() {
  echo -e "$(tput setaf 1)sudo:$(tput sgr0) $(fc -ln -1)"
  eval "sudo $(fc -ln -1)"
}

# history
h() {
  if [ "$#" -eq 0 ]; then
    history
  else
    history 0 | egrep -i --color=auto $@
  fi
}

# quickly add and remove '.bak' to files
bak() {
  for file in "$@"; do
    if [[ $file =~ "\.bak$" ]]; then
      mv -iv "$file" "$(basename ${file} .bak)"
    else
      mv -iv "$file" "${file}.bak"
    fi
  done
}

# simple find functions
fn() { find . -iname "*$@*" 2>/dev/null         }
fd() { find . -iname "*$@*" -type d 2>/dev/null }
ff() { find . -iname "*$@*" -type f 2>/dev/null }

# extract archives
extract() {
  if [[ -z "$1" ]]; then
    echo "extracts files based on extensions"
  elif [[ -f $1 ]]; then
    case ${(L)1} in
      *.tar.bz2) tar -jxvf $1  ;;
      *.tar.gz)  tar -zxvf $1  ;;
      *.tar.xz)  tar -xvf $1   ;;
      *.bz2)     bunzip2 $1    ;;
      *.gz)      gunzip $1     ;;
      *.jar)     unzip $1      ;;
      *.rar)     unrar x $1    ;;
      *.tar)     tar -xvf $1   ;;
      *.tbz2)    tar -jxvf $1  ;;
      *.tgz)     tar -zxvf $1  ;;
      *.zip)     unzip $1      ;;
      *.Z)       uncompress $1 ;;
      *)         echo "unable to extract '$1'"
    esac
  else
    echo "file '$1' does not exist!"
  fi
}
compctl -g '*.tar.bz2 *.tar.gz *.bz2 *.gz *.jar *.rar *.tar *.tbz2 *.tgz *.zip *.Z' + -g '*(-/)' extract

#
cdf() {
    target=`osascript -e 'tell application "Finder" to if (count of Finder windows) > 0 then get POSIX path of (target of front Finder window as text)'`
    if [ "$target" != "" ]; then
        cd "$target"; pwd
    else
        echo 'No Finder window found' >&2
    fi
}

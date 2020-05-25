#zplug
if [ ! -d ~/.zplug ]; then
  curl -sL zplug.sh/installer | zsh
fi

if [ ! -d ~/.zsh.d ]; then
  git clone https://github.com/rupa/z.git ~/.zsh.d
fi

source ~/.zplug/init.zsh

zplug "zsh-users/zsh-syntax-highlighting"
zplug "zsh-users/zsh-completions"
zplug "zsh-users/zsh-autosuggestions"

if ! zplug check --verbose; then
  printf "Install? [y/N]: "
  if read -q; then
    echo; zplug install
  fi
fi

zplug load

#options
setopt auto_cd
setopt auto_pushd
setopt prompt_subst
setopt menu_complete

#prompt
autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git svn
zstyle ':vcs_info:*' max-exports 6
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' formats '%b@%r' '%c' '%u'
zstyle ':vcs_info:git:*' actionformats '%b@%r|%a' '%c' '%u'

function vcs_echo {
  local st branch color
  STY= LANG=en_US.UTF-8 vcs_info
  st=`git status 2> /dev/null`
  if [[ -z "$st" ]]; then return; fi
  branch="$vcs_info_msg_0_"
  if   [[ -n "$vcs_info_msg_1_" ]]; then color=${fg[green]} #staged
  elif [[ -n "$vcs_info_msg_2_" ]]; then color=${fg[red]} #unstaged
  elif [[ -n `echo "$st" | grep "^Untracked"` ]]; then color=${fg[blue]} # untracked
  else color=${fg[cyan]}
  fi
  echo "%{$color%}(%{$branch%})%{$reset_color%}" | sed -e s/@/"%F{yellow}@%f%{$color%}"/
}

PROMPT='
%F{yellow}[%~]%f `vcs_echo`
%(?.$.%F{red}$%f) '

#completion
zstyle ':completion:*' recent-dirs-insert both
zstyle ':chpwd:*' recent-dirs-max 500
zstyle ':chpwd:*' recent-dirs-default true
zstyle ':chpwd:*' recent-dirs-file "$HOME/.cache/shell/chpwd-recent-dirs"
zstyle ':chpwd:*' recent-dirs-pushd true
zstyle ':completion:*' recent-dirs-insert both
zstyle ':completion:*' verbose yes
zstyle ':completion:*' completer _expand _complete _match _prefix _approximate _list _history
zstyle ':completion:*:messages' format '%F{YELLOW}%d'$DEFAULT
zstyle ':completion:*:warnings' format '%F{RED}No matches for:''%F{YELLOW} %d'$DEFAULT
zstyle ':completion:*:descriptions' format '%F{YELLOW}completing %B%d%b'$DEFAULT
zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*:descriptions' format '%F{yellow}Completing %B%d%b%f'$DEFAULT
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select interactive

#aliases
if type nvim >/dev/null 2>&1; then
  alias vi='nvim'
else
  alias vi='vim'
fi
alias la='ls -a'
alias ll='ls -la'
alias gst='git status'
alias gnbr='(){git checkout -b $1}'
alias gco='(){git checkout $1}'
alias gadi="git add -i"
alias gadu="git add . && gst"
alias gcm='(){git commit -m $1}'
alias gps='git push'
alias gpso='(){git push --set-upstream origin $1}'
alias gpl='git pull'
alias gcp='(){git cherry-pick $1}'
alias gsts='git stash -u'
alias gsta='git stash apply stash@{0}'
alias gbr='git branch}'
alias gbrr='git branch -r'
alias gbra='git branch -a'
alias glg='git log --oneline'
alias gdf='git diff'
alias gdft='git difftool'
alias gmgt='git mergetool'
alias grh='git reset --hard HEAD^'
alias grh='git reset --hard HEAD^ && git clean -f && git clean -df'
alias gcl='git checkout . && git clean -f && git clean -df'
alias gdl='(){git branch | grep $1 | xargs git branch -D}'
alias gbd='git branch -D $1'
alias gbm='git branch -m $1'
alias cb="git symbolic-ref --short HEAD | tr -d '\n' | pbcopy"
alias gstl="git stash list"
alias finder="open -a Finder"
alias rmds='find ./ -name ".DS_Store" -print -exec rm {} ";"'
alias grepword='(){find ./ -type f -print | xargs grep $1}'
alias grepreplace="grep -l $1 ./ | xargs perl -i -pe 's/$1/$2/g'"
alias rimraf='(){rm -r $1}'
alias dcu='docker-compose build && docker-compose up -d'
alias drc='docker rm -f `docker ps -a -q`'
alias dri='docker rmi `docker images -q`'
alias ydl='youtube-dl $1 -i --extract-audio --audio-format mp3 --audio-quality 0 -U --verbose'
alias hl='heroku logs --tail -a $1'
alias blog='cd && cd zatsutabi/content/blog && open .'

#functions
source ~/.zsh.d/z.sh

function peco-z-search {
  which peco z > /dev/null
  if [ $? -ne 0 ]; then
    echo "Please install peco and z"
    return 1
  fi
  local res=$(z | sort -rn | cut -c 12- | peco)
  if [ -n "$res" ]; then
    BUFFER+="cd $res"
    zle accept-line
  else
    return 1
  fi
}

zle -N peco-z-search
bindkey '^f' peco-z-search

function mkd() {
	mkdir -p "$@" && cd "$_";
}

function compare() {
  echo "original size (bytes): $(cat "$1" | wc -c)"
  echo "    gzip size (bytes): $(gzip -c "$1" | wc -c)"
  echo "  zopfli size (bytes): $(zopfli -c "$1" | wc -c)"
  echo "  brotli size (bytes): $(brotli -c  "$1" | wc -c)"
}

function http_get_title_of_page {
  curl -s ${1} | ggrep -oP "(?<=<title>)(.+)(?=</title>)"
}

#env
if type nvim >/dev/null 2>&1; then
  export GIT_EDITOR=nvim
else
  export GIT_EDITOR=vim
fi
export PATH=$PATH:$M2_HOME/bin
export PATH=$PATH:/usr/bin
export PATH=$PATH:/usr/local/bin
export PATH=$PATH:./node_modules/.bin
export PATH=$HOME/.nodebrew/current/bin:$PATH

export PKG_CONFIG_PATH="/usr/local/opt/libffi/lib/pkgconfig"


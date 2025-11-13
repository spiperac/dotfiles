###############
# ZSH Config
###############

# Locale
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# Wayland Display set
#export WAYLAND_DISPLAY=wayland-0

# Path
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/scripts:$PATH"

# ZSH Configuration
autoload -U colors && colors

# Faster compinit - only run once per day
autoload -Uz compinit
if [[ -n ${ZDOTDIR}/.zcompdump(#qN.mh+24) ]]; then
  compinit
else
  compinit -C
fi

export LS_COLORS='rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:mi=00:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arc=01;31:*.arj=01;31:*.taz=01;31:*.lha=01;31:*.lz4=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.tzo=01;31:*.t7z=01;31:*.zip=01;31:*.z=01;31:*.dz=01;31:*.gz=01;31:*.lrz=01;31:*.lz=01;31:*.lzo=01;31:*.xz=01;31:*.zst=01;31:*.tzst=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.alz=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.cab=01;31:*.wim=01;31:*.swm=01;31:*.dwm=01;31:*.esd=01;31:*.jpg=01;35:*.jpeg=01;35:*.mjpg=01;35:*.mjpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.m4a=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.oga=00;36:*.opus=00;36:*.spx=00;36:*.xspf=00;36:'

# Enhanced Git info in prompt
git_info() {
  local branch
  branch=$(git symbolic-ref --short HEAD 2>/dev/null) || return
  [[ -n $branch ]] || return
  
  local status_color="%F{magenta}"
  local git_status=$(git status --porcelain 2>/dev/null)
  
  if [[ -n $git_status ]]; then
    status_color="%F{red}"  # Dirty repo
  elif git log --oneline @{u}..HEAD 2>/dev/null | grep -q .; then
    status_color="%F{yellow}"  # Ahead of remote
  fi
  
  echo "$status_color( $branch)%f"
}

precmd() {
  local exit_status="%(?:%F{green}✓:%F{red}✗%?)%f"
  PROMPT="%F{214}%n%f@%F{green}%m%f %F{blue}%~%f $(git_info) ${exit_status} %F{white}$%f "
}

# History settings
HISTFILE=~/.zsh_history
HISTSIZE=50000
SAVEHIST=50000
setopt SHARE_HISTORY
setopt INC_APPEND_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_REDUCE_BLANKS
setopt HIST_SAVE_NO_DUPS
setopt HIST_FCNTL_LOCK



zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' # Case-insensitive
zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format '%B%F{blue}-- %d --%f%b'
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache
zstyle ':completion:*:ssh:*' config on

# Zsh line editor and other options
setopt AUTO_LIST               # show completions automatically
setopt LIST_AMBIGUOUS          # list options when ambiguous
setopt AUTO_CD                 # cd by typing directory name
setopt CORRECT                 # suggest corrections for commands
setopt EXTENDED_GLOB           # extended globbing patterns

# Key bindings
bindkey -e
bindkey '^[[1;5C' forward-word    # Ctrl-Right
bindkey '^[[1;5D' backward-word   # Ctrl-Left
autoload -U history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^[OA" history-beginning-search-backward-end
bindkey "^[OB" history-beginning-search-forward-end
bindkey "^[[A" history-beginning-search-backward-end
bindkey "^[[B" history-beginning-search-forward-end

# User configuration
export EDITOR='nvim'
export VISUAL='nvim'
export PAGER='less'
export LESS='-R'
export FZF_DEFAULT_OPTS='--height 50% --layout=reverse --border'
# Keep foot locally, but override TERM for SSH
function ssh() {
    TERM=xterm-256color command ssh "$@"
}


# SSH Keyring
export SSH_KEY_PATH="~/.ssh/rsa_id"
#export SSH_AUTH_SOCK=$(find /tmp/ssh-* -name "agent.*" 2>/dev/null | head -n 1)
if [[ -z "$SSH_AUTH_SOCK" ]]; then
  eval "$(ssh-agent -s)"
fi
if ! ssh-add -l &>/dev/null; then
  ssh-add ~/.ssh/id_rsa
fi

#### Aliases
alias ls='ls --color=auto'
alias ll='ls -l --color=auto'
alias lg='lazygit'
alias vf='vim $(fzf --preview "head -100 {}")'
alias fz='cd $(dirname $(find . -type f | fzf))'

# Navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# Safety nets
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# git
alias gl='git log --oneline --graph --decorate'

# Quality of life
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias tree='tree -C'
alias df='df -h'
alias du='du -h'
alias fsdir='du -sh . 2>/dev/null | awk '\''{print $1}'\'''
alias ncmpcpp='ncmpcpp -b ~/.config/ncmpcpp/bindings'

# Tmux
alias t='tmux attach || tmux new'
alias ta='tmux attach -t'
alias tn='tmux new -s'

source ~/scripts/app-aliases

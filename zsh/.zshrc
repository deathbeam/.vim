# vim:foldmethod=marker:set ft=zsh:

# General {{{

# Source .profile
if [ -f ~/.profile ]; then
  source ~/.profile
fi

# Enable colors
export CLICOLOR=1

# }}}

# Aliases & functions {{{

# Alias xclip copy/paste
if command -v xclip >/dev/null 2>&1; then
  alias xcopy='xclip -i -selection clipboard'
  alias xpaste='xclip -o -selection clipboard'
elif command -v xsel >/dev/null 2>&1; then
  alias xcopy='xsel --clipboard --input'
  alias xpaste='xsel --clipboard --output'
fi

# Open Vim and start saving it's session
alias vims='vim -c "Session"'

# Set proxy
function setproxy {
  export no_proxy="localhost,127.0.0.1,localaddress,.localdomain.com"
  export http_proxy=$1
  export https_proxy=$http_proxy
  export ftp_proxy=$http_proxy
  export rsync_proxy=$http_proxy
  export HTTP_PROXY=$http_proxy
  export HTTPS_PROXY=$http_proxy
  export FTP_PROXY=$http_proxy
  export RSYNC_PROXY=$http_proxy
}

# Unset proxy
function unsetproxy {
  unset http_proxy https_proxy ftp_proxy rsync_proxy \
    HTTP_PROXY HTTPS_PROXY FTP_PROXY RSYNC_PROXY
}

# }}}

# Plugins {{{

# Load zim
if [ -f $ZIM_HOME/init.zsh ]; then
  # Select what modules you would like enabled.
  zmodules=( \
    archive \
    autosuggestions \
    directory \
    environment \
    fasd \
    git \
    git-info \
    history \
    input \
    utility \
    pacman \
    prompt \
    ssh \
    syntax-highlighting \
    history-substring-search \
    completion)

  # Use VI input mode
  zinput_mode='vi'

  # Pacman
  zpacman_frontend='yay'
  zpacman_helper=()

  # This appends '../' to your input for each '.' you type after an initial '..'
  zdouble_dot_expand='true'

  # Set the string below to the desired terminal title format string.
  # Below uses the following format: 'username@host:/current/directory'
  ztermtitle='%n@%m:%~'

  # This determines what highlighters will be used with the syntax-highlighting module.
  zhighlighters=(main brackets pattern cursor)

  # Set prompt theme
  zprompt_theme='pure'
  PURE_PROMPT_SYMBOL='$'

  # Load these ssh identities with the ssh module
  zssh_ids=(id_rsa)

  # Source zim
  source $ZIM_HOME/init.zsh
fi

# Load pyenv
command -v pyenv >/dev/null 2>&1 && eval "$(pyenv init -)"

# Load hub alias
command -v hub >/dev/null 2>&1 && eval "$(hub alias -s)"

# Load travis
[ -f "$HOME/.travis/travis.sh" ] && source "$HOME/.travis/travis.sh"

# Pathogen-like loader for plugins
find -L ~/.zsh/bundle -type f -name "*.plugin.zsh" | sort |
while read filename; do source "$filename"; done

# Load fzf after plugins to be able to override them
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Use faster FZF grep command if possible
if command -v rg >/dev/null 2>&1; then
  export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --glob "!.git/*"'
  export FZF_CTRL_T_COMMAND=$FZF_DEFAULT_COMMAND
  export FZF_ALT_C_COMMAND='rg --files --hidden --follow --glob "!.git/*" --null | xargs -0 dirname | uniq'
elif command -v ag >/dev/null 2>&1; then
  export FZF_DEFAULT_COMMAND='ag -g ""'
  export FZF_CTRL_T_COMMAND=$FZF_DEFAULT_COMMAND
fi

export FZF_DEFAULT_OPTS='--preview "[[ $(file --mime {}) =~ binary ]] &&
  echo {} is a binary file ||
  (highlight -O ansi -l {} ||
  coderay {} ||
  rougify {} ||
  cat {}) 2> /dev/null | head -500"'

# Load base16 theme
[ -z $BASE16_THEME ] && base16_solarized-dark

# }}}

# User configuration {{{

# Load user config
[ -f "$HOME/.zshrc.local" ] && source "$HOME/.zshrc.local"

# }}}

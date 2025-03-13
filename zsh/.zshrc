# ~/.zshrc

export EDITOR="nvim"

export ZPLUG_DIR=$HOME/.zplug

[[ ! -d $ZPLUG_DIR ]] && { git clone https://github.com/zplug/zplug.git $ZPLUG_DIR; }
source $ZPLUG_DIR/init.zsh

# Plugins
zplug "zsh-users/zsh-completions"
zplug "zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-syntax-highlighting", defer:2
zplug "zsh-users/zsh-history-substring-search", defer:3
zplug "plugins/direnv", from:oh-my-zsh
zplug "plugins/docker", from:oh-my-zsh
zplug "plugins/docker-compose", from:oh-my-zsh
zplug "plugins/git", from:oh-my-zsh
zplug "plugins/github", from:oh-my-zsh
zplug "plugins/node", from:oh-my-zsh
zplug "plugins/nodenv", from:oh-my-zsh
zplug "plugins/npm", from:oh-my-zsh
zplug "plugins/nvm", from:oh-my-zsh
zplug "plugins/pyenv", from:oh-my-zsh
zplug "plugins/python", from:oh-my-zsh
zplug "plugins/kitty", from:oh-my-zsh
zplug "plugins/tmux", from:oh-my-zsh
zplug "themes/gentoo", from:oh-my-zsh, as:theme

if $( ! zplug check --verbose; ); then
    echo -e "Install plugin updates? [y/N]: "
    read -q && { echo; zplug install; } || { echo -e "Skipped."; }
fi

zplug load

# XDG 
if test -z "${XDG_RUNTIME_DIR}"; then
  export XDG_RUNTIME_DIR=/tmp/"${UID}"-runtime-dir
    if ! test -d "${XDG_RUNTIME_DIR}"; then
        mkdir "${XDG_RUNTIME_DIR}"
        chmod 0700 "${XDG_RUNTIME_DIR}"
    fi
fi

# NVM 
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# pyenv
  echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.zshrc
  echo '[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.zshrc
  echo 'eval "$(pyenv init - zsh)"' >> ~/.zshrc
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - zsh)"

# direnv
eval "$(direnv hook zsh)"
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - zsh)"


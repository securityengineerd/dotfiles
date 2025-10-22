#!/usr/bin/env zsh

load_order=( load_includes load_zplug )

function notice() {                                           
  GET_INPUT=$1                                         
                                                              
  printf "-${fg_bold[cyan]}!${fg[default]}- ${GET_INPUT}\n\n" 
                                                              
}                                                             

function subnotice() {
  GET_INPUT=$1                                                 
                                                               
  printf " ${fg_bold[white]}҉҉҉҉҈҉·${fg[default]}  ${GET_INPUT}\n\n"  
                                                               
}

function load_zplug {
  notice "Loading Plugin Manager (${fg_bold[green]}zplug${fg[default]})"
    export ZPLUG_DIR="$HOME/.zplug"
    export ZPLUG_INIT="$ZPLUG_DIR/init.zsh"
    export ZPLUG_REPO="https://github.com/zplug/zplug.git"

    function zplug_check {
        subnotice "checking for existing installations."
        if [ ! -d "$ZPLUG_DIR" ]; then
          printf '[!] %s\n' "Unable to locate zplug install folder. Installing..."
          git clone $ZPLUG_REPO $ZPLUG_DIR
        fi
    }

    function zplug_init { 
        subnotice "preparing zplug environment"
        source $ZPLUG_INIT
    }

    function zplug_plugins {
        subnotice "loading user selected plugins"
        
        # user selected plugins
        zplug "zsh-users/zsh-completions"
        zplug "zsh-users/zsh-autosuggestions"
        zplug "zsh-users/zsh-syntax-highlighting", defer:2
        zplug "zsh-users/zsh-history-substring-search", defer:3
        zplug 'plugins/autoenv', from:oh-my-zsh
        zplug 'plugins/brew', from:oh-my-zsh
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
        zplug 'themes/bureau', as:theme, from:oh-my-zsh
    }

    function zplug_update {
        subnotice "checking for updates"
        if ! zplug check --verbose; then
            printf '%s\n' "Install latest plugins? [y/N]: "
            read -q && { echo; zplug install; } || \
                { echo -e "  - skipped by user"; }
        fi
    }

    function zplug_load {
      zplug load && { notice "Plugin Manager (${fg_bold[cyan]}zplug${fg[default]}): Loaded Successfully"; } || \
          { notice "failed to load zplug"; }
    }

    zplug_check;
    zplug_init;
    zplug_plugins;
    zplug_update;
    zplug_load;
}

function load_includes() {
  printf "-${fg_bold[cyan]}!${fg[default]}- Loading include objects from $HOME/.zsh_include\n\n"
  for include in $HOME/.zsh_include/*
  do 
    source $include &&
      { printf "  [${fg_bold[green]}$(basename $include)${fg[default]}] imported successfully\n\n"; } || \
        { printf "  [${fg_bold[red]}$(basename $include){fg[default]}] import failure\n\n"; }
  done
  printf " ${fg_bold[cyan]}>${fg[default]} Complete\n\n"
}

function compose-getenv() {
  local CTNR_ID=$1
  local INPUT=$2

  function usage() { 
    printf "Container name required to output environment!\n\n"
    printf "Usage: compose-getenv CONTAINER_NAME VARIABLE\n\n
        CONTAINER_NAME		Name of the container to show variables\n
	VARIABLE		Optional. Check specific variable.\n"
  }

  if [ -z "${CTNR_ID}" ]; then
    usage; exit 1; 
  fi

  if [ -z $INPUT ]; then
    printf "Environment for ${CTNR_ID}\n\n"
    docker compose exec $CTNR_ID env
  
  fi

  docker compose exec ${CTNR_ID} env | grep ${INPUT}
  
}

for function in ${load_order[@]};
do 
  eval $function 
done

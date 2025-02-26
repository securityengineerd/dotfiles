# .zshrc

function prompt_init {
  unset rand PROMPT_RAND
  PROMPT_LIST=( `cat ~/.zsh_favlist` )
  rand=$[$RANDOM % ${#PROMPT_LIST[@]}]; 
  PROMPT_RAND="themes/${PROMPT_LIST[$rand]}"
}

function uenv_banner {
  export PROGRAM_NAME="userENVy Profile Manager"
  if [[ ! -z $1 ]]; then
     export UENV_BANNER="${fg_bold[grey]}==========[${fg_bold[cyan]}    $PROGRAM_NAME${fg_bold[grey]}:${fg[white]} $1    ${fg_bold[grey]}]==========${fg[default]}"
  else
    export UENV_BANNER="${fg_bold[gray]}==========[${fg_bold[cyan]}    $PROGRAM_NAME    ${fg_bold[gray]}]==========${fg[default]}"
  fi

  #printf '\n\n%s\n' "$UENV_BANNER"
  print -r - ${(l[COLUMNS/2][=]r[COLUMNS-COLUMNS/2][=])UENV_BANNER}
  unset UENV_BANNER
}

function uenv_msg {

  local INPUT_TEXT="$1"
  local INPUT_CLR="$2"
  local OUTPUT_CLR="${fg_bold[$INPUT_CLR]}"
  local OUTPUT_MSG=">${OUTPUT_CLR} ${INPUT_TEXT} ${fg[default]}"
  
  printf '%s\n' "$OUTPUT_MSG"

}

uenv_msg "Initializing Zshell plugin manager." "cyan";
export ZPLUG=$HOME/.zplug; 
export ZPLUG_INIT=$ZPLUG/init.zsh

[[ ! -d $ZPLUG ]] && { git clone https://github.com/zplug/zplug.git $ZPLUG; }

source $ZPLUG_INIT && { printf '  [%s]\n' "${fg_bold[green]}success${fg[default]}"}

prompt_init;                                                                
[[ -z $( basename $PROMPT_RAND | egrep -v 'themes' ) ]] && { prompt_init; } 
echo -e ": Random Prompt [$PROMPT_RAND]"                                    

uenv_msg "Reading user-specified plugins."
zplug "zsh-users/zsh-completions"
zplug "zsh-users/zsh-syntax-highlighting", defer:2
zplug "zsh-users/zsh-autosuggestions", use:"zsh-autosuggestions.zsh"
zplug "zsh-users/zsh-history-substring-search", defer:3
#zplug "themes/bureau", from:oh-my-zsh, as:theme
#zplug "themes/eastwoof", from:oh-my-zsh, as:theme
zplug $PROMPT_RAND, from:oh-my-zsh, as:theme

uenv_msg "Checking for updates." 
if $( ! zplug check --verbose; ); then
  printf '%s\n' "Install updated plugins? [y/N]: "
  read -q && { echo; zplug install; echo; } || { echo -e "  - user skipped"; }
fi

zplug load 


# printf '\n\n%s\n' "${fg_bold[gray]}!==========[${fg_bold[green]}    userENV.y Successfully Loaded    ${fg_bold[gray]}]==========!${fg[default]}"
uenv_banner "Initialized";

# node version manager
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

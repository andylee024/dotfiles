# Run this file only in Bash.
if [ -z "${BASH_VERSION:-}" ]; then
  return 0 2>/dev/null || exit 0
fi

# ~/.bash_profile
# Bash login-shell configuration.

# -----------------------------------------------------------------------------
# Conda initialization (managed by `conda init`)
# Keep this block intact.
# -----------------------------------------------------------------------------
# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/andylee/anaconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/andylee/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/Users/andylee/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/Users/andylee/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

# -----------------------------------------------------------------------------
# PATH and tool environment
# -----------------------------------------------------------------------------
path_prepend() {
  case ":$PATH:" in
    *":$1:"*) ;;
    *) PATH="$1:$PATH" ;;
  esac
}

[ -d "$HOME/.local/bin" ] && path_prepend "$HOME/.local/bin"
[ -d "$HOME/bin" ] && path_prepend "$HOME/bin"

[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"

if command -v nvim >/dev/null 2>&1; then
  export EDITOR="nvim"
else
  export EDITOR="vim"
fi
export VISUAL="$EDITOR"
export PAGER="less"
export LESS="-FRX"
export LSCOLORS='ExGxBxDxCxEgEdxbxgxcxd'

# -----------------------------------------------------------------------------
# Interactive shell only
# -----------------------------------------------------------------------------
if [[ $- == *i* ]]; then
  # Avoid inherited zsh-style PROMPT vars from parent env.
  unset PROMPT NEWLINE
  export -n PROMPT 2>/dev/null || true

  # Prompt: current directory + git branch (single-line).
  parse_git_branch() {
    local branch
    branch=$(git symbolic-ref --short HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null) || return
    printf ' (%s)' "$branch"
  }

  COLOR_DEF='\[\e[0m\]'
  COLOR_DIR='\[\e[38;5;197m\]'
  COLOR_GIT='\[\e[38;5;39m\]'
  PS1="${COLOR_DIR}\w${COLOR_GIT}\$(parse_git_branch)${COLOR_DEF} \\$ "
  export -n PS1 2>/dev/null || true

  # History behavior.
  export HISTSIZE=50000
  export HISTFILESIZE=100000
  export HISTCONTROL="ignoredups:erasedups"
  export HISTIGNORE="ls:cd:pwd:exit:clear"
  shopt -s histappend cmdhist checkwinsize promptvars

  # Persist history across concurrent shells.
  case "$PROMPT_COMMAND" in
    *"history -a; history -n"*) ;;
    *) PROMPT_COMMAND="history -a; history -n${PROMPT_COMMAND:+; $PROMPT_COMMAND}" ;;
  esac

  # Bash completion (Homebrew common paths on macOS).
  if [ -f /opt/homebrew/etc/profile.d/bash_completion.sh ]; then
    . /opt/homebrew/etc/profile.d/bash_completion.sh
  elif [ -f /usr/local/etc/profile.d/bash_completion.sh ]; then
    . /usr/local/etc/profile.d/bash_completion.sh
  fi

  # Aliases: navigation and shell quality-of-life.
  alias ls='ls -G'
  alias ll='ls -lah'
  alias la='ls -A'
  alias ..='cd ..'
  alias ...='cd ../..'
  alias reload='source ~/.bash_profile'

  # Aliases: environments and tooling.
  alias dtb='conda activate dtb'
  alias dtb_csql='cd; ./cloud-sql-proxy --port 3310 basis-leads:us-central1:basis-leads-db'
  alias lint='pre-commit run --all-files'
  alias ep='conda activate eigen-portfolio'
  alias sp='conda activate second-path'
  alias llm='conda activate llm'

  # Aliases: projects.
  alias at='cd "$HOME/Projects/andy-thinks"'
  alias mib='cd "$HOME/Projects/nano-claw"'
  alias ad='agent-deck'

  # Functions.
  mkcd() {
    mkdir -p "$1" && cd "$1"
  }
fi

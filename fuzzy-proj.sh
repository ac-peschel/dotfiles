#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

CONFIG_NAME=".tmux"
SEARCH_ROOT="$HOME/repos"

# init a new project
if [[ "${1:-}" == "init" ]]; then
   if [[ -e "$CONFIG_NAME" ]]; then
      echo "'$CONFIG_NAME' already exists."
      exit 0
   fi
   cat > "$CONFIG_NAME" <<'JSON'
{
   "tabs": [
      { "name": "nvim", "dir": ".", "cmd": "nvim" },
      { "name": "cmd", "dir": "." }
   ]
}
JSON
   echo "Created default '$CONFIG_NAME' in $(pwd)"
   exit 0
fi

# fuzzy find projects
PROJECTS=$(find "$SEARCH_ROOT" -type f -name "$CONFIG_NAME" -printf '%h\n' | sort -u)
if [[ -z "$PROJECTS" ]]; then
   echo "No projects found containing a '$CONFIG_NAME'"
   exit 1
fi

SELECTED=$(echo "$PROJECTS" | fzf --prompt="Select project: ")
if [[ -z "$SELECTED" ]]; then
   echo "No project selected"
   exit 1
fi

CONFIG_FILE="$SELECTED/$CONFIG_NAME"

# Kill all current tmux sessions
if tmux ls &>/dev/null; then
   tmux kill-server
fi

if ! command -v jq &>/dev/null; then
   echo "jq is required. Installt it first."
   exit 1
fi

SESSION_NAME=$(basename "$SELECTED")
tmux new-session -d -s "$SESSION_NAME"

NUM_TABS=$(jq '.tabs | length' "$CONFIG_FILE")
for ((i=0; i<NUM_TABS; i++)); do
   NAME=$(jq -r ".tabs[$i].name" "$CONFIG_FILE")
   DIR=$(jq -r ".tabs[$i].dir // \".\"" "$CONFIG_FILE")
   CMD=$(jq -r ".tabs[$i].cmd // \"\"" "$CONFIG_FILE")
   FULL_DIR="$SELECTED/$DIR"
   TMUX_WIN=$((i+1))
   if [[ $i -eq 0 ]]; then
      tmux rename-window -t "$SESSION_NAME:$TMUX_WIN" "$NAME"
   else
      tmux new-window -t "$SESSION_NAME" -n "$NAME"
   fi

   tmux send-keys -t "$SESSION_NAME:$TMUX_WIN" "cd \"$FULL_DIR\"" C-m
   if [[ -n "$CMD" ]]; then
      tmux send-keys -t "$SESSION_NAME:$TMUX_WIN" "$CMD" C-m
   fi
done

tmux select-window -t "$SESSION_NAME:1"
tmux attach -t "$SESSION_NAME"


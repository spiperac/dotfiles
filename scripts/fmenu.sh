#!/usr/bin/env bash

# CONFIGURATION
LAUNCHER="fuzzel"
LAUNCHER_MENU=" --dmenu"
LAUNCHER_PROMPT=" --dmenu --prompt"
LAUNCHER_ARGS=""
NIXOS_HOME="/home/spiperac/nix"
# LAUNCHERS
LAUNCHER_MENU="${LAUNCHER}${LAUNCHER_ARGS}${LAUNCHER_MENU}"
LAUNCHER_PROMPT="${LAUNCHER}${LAUNCHER_ARGS}${LAUNCHER_PROMPT}"

fuzz_ssh() {
  SSH_HOSTS=$(grep "^Host " ~/.ssh/config | awk '{print $2}' | tr ' ' '\n')
  choice=$(echo "$SSH_HOSTS" | $LAUNCHER_MENU)

  # Open new ssh connection in a shell
  if [[ -n "$choice" ]]; then
    foot -e ssh "$choice"
  fi
}

fuzz_kill() {
  # Get list of running processes with PID and command, show only program name
  PROCESSES=$(ps -axo pid,comm | tail -n +2)
  
  # Show in fuzzel
  choice=$(echo "$PROCESSES" | $LAUNCHER_MENU)
  
  if [[ -n "$choice" ]]; then
    # Extract PID from the selection
    PID=$(echo "$choice" | awk '{print $1}')
    
    # Confirm kill action
    confirm=$(echo -e "Yes\nNo" | ${LAUNCHER_PROMPT}="Kill process $PID?")
    
    if [[ "$confirm" == "Yes" ]]; then
      kill -9 "$PID"
    fi
  fi
}

fuzz_tmux() {
  TMUX_SESSIONS=$(printf "New Session\n%s" "$(tmux list-sessions | cut -d ':' -f 1)")
  choice=$(echo "$TMUX_SESSIONS" | $LAUNCHER_MENU)

  # List tmux sessions and attach if chosen
  if [[ -n "$choice" ]]; then
    if [[ "$choice" == "New Session" ]]; then
      new_session=$(echo "" | $LAUNCHER_PROMPT "Session name: ")
      if [[ -n "$new_session" ]]; then
        foot -e tmux new -s "$new_session" 
      fi
    else
      foot -e tmux attach -t "${choice}"
    fi
  fi
}

fuzz_projects() {
  PROJECTS=$(ls ~/projects | sed 's/^/ /')
  choice=$(echo "$PROJECTS" | $LAUNCHER_MENU)

  # List projects or create new 
  if [[ -n "$choice" ]]; then

    choice="${choice# }"
    if [[ "$choice" == "New Project" ]]; then
      new_project=$(echo "" | $LAUNCHER_PROMPT "Project name: ")
      if [[ -n "$new_project" ]]; then
        foot sh -c "mkdir ~/projects/\"$new_project\" && cd ~/projects/\"$new_project\""
      fi
    else
      foot --working-directory="$HOME/projects/$choice"
    fi
  fi
}

fuzz_notes() {
  # Add create option
  NOTES=$(printf "📝 Create New Note\n📝 New Blog\n$(ls ~/Vault/notes)")
  choice=$(echo "$NOTES" | $LAUNCHER_MENU)
  
  if [[ -n "$choice" ]]; then
    if [[ "$choice" == "📝 Create New Note" ]]; then
      new_note=$(echo "" | $LAUNCHER_PROMPT "New note name: ")
      if [[ -n "$new_note" ]]; then
        emacsclient -r -n -a "" -e "(create-note \"$new_note\")" &
      fi
    elif [[ "$choice" == "📝 New Blog" ]]; then
      new_post=$(echo "" | $LAUNCHER_PROMPT "New post: ")
      if [[ -n "$new_post" ]]; then
        emacsclient -r -n -a "" -e "(spiperac/zola-new-post \"$new_post\")" &
      fi
    else
      emacsclient -r -n -a "emacs" ~/Vault/notes/"$choice" &
    fi
  fi
}

fuzz_audio_mixer() {
  CONTROLS=$(mixer | awk '{print $1}')
  choice=$(echo "$CONTROLS" | $LAUNCHER_MENU)
  if [[ -n "$choice" ]]; then
    level=$(echo "" | ${LAUNCHER_PROMPT}="Level for $choice (0-1): ")
    mixer "$choice" "$level"
  fi
}

fuzz_audio() {
  # Get list of audio sinks
  sinks=$(wpctl status | awk '/Sinks:/,/Sources:/ {if (/[0-9]+\./) print}' | sed 's/.*│\s*\*\?\s*//')

  choice=$(echo "$sinks" | $LAUNCHER_MENU)
  
  if [[ -n "$choice" ]]; then
    # Extract sink ID (first number)
    sink_id=$(echo "$choice" | awk '{print $1}' | tr -d '.*')
    wpctl set-default "$sink_id"
  fi
}

declare -A CHOICES=(
  [" SSH"]="fuzz_ssh"
  ["󰓾 Kill"]="fuzz_kill"
  [" Tmux"]="fuzz_tmux"
  ["󰎚 Notes"]="fuzz_notes"
  [" Audio"]="fuzz_audio_mixer"
  [" Projects"]="fuzz_projects"
)

selection=$(printf '%s\n' "${!CHOICES[@]}" | $LAUNCHER_MENU)

# Check if selection is not empty
if [[ -n "$selection" ]]; then
  # Call the script associated with the selection
  "${CHOICES[$selection]}"
fi


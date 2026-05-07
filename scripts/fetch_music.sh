#!/usr/bin/env bash
# fetch_music.sh — Browse your NAS music library and sync selected items to ~/Music
# Dependencies: fzf, rsync

set -euo pipefail

# ── Config ────────────────────────────────────────────────────────────────────
NAS_MUSIC="/mnt/NAS/multimedia/music"
LOCAL_MUSIC="$HOME/Music"
# ──────────────────────────────────────────────────────────────────────────────

case "$(uname)" in
    FreeBSD|OpenBSD|NetBSD|Darwin)
        du_bytes() { du -sk "$1" 2>/dev/null | awk '{print $1 * 1024}'; }
        fmt_bytes() { gnumfmt --to=iec "$1" 2>/dev/null || echo "${1} bytes"; }
        ;;
    *)
        du_bytes() { du -sb "$1" 2>/dev/null | cut -f1; }
        fmt_bytes() { numfmt --to=iec "$1" 2>/dev/null || echo "${1} bytes"; }
        ;;
esac

# Colours
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
CYAN='\033[0;36m'; BOLD='\033[1m'; RESET='\033[0m'

die()  { echo -e "${RED}Error: $*${RESET}" >&2; exit 1; }
info() { echo -e "${CYAN}$*${RESET}"; }
ok()   { echo -e "${GREEN}✔ $*${RESET}"; }

# ── Dependency check ──────────────────────────────────────────────────────────
for cmd in fzf rsync; do
    command -v "$cmd" &>/dev/null || die "'$cmd' is not installed. Please install it first."
done
[[ -d "$NAS_MUSIC" ]] || die "NAS music directory not found: $NAS_MUSIC"

mkdir -p "$LOCAL_MUSIC"

# ── Mode selector ─────────────────────────────────────────────────────────────
usage() {
    echo -e "${BOLD}fetch_music.sh${RESET} — NAS music syncer"
    echo ""
    echo -e "  ${BOLD}Modes:${RESET}"
    echo "    albums    Browse top-level folders (albums / artists)"
    echo "    songs     Browse individual audio files"
    echo "    synced    Show what's already synced locally"
    echo "    clean     Remove local items no longer wanted"
    echo ""
    echo -e "  ${BOLD}Usage:${RESET}"
    echo "    ./fetch_music.sh [albums|songs|synced|clean]"
    echo "    (no argument → interactive mode picker)"
}

# ── fzf preview helper ────────────────────────────────────────────────────────
preview_dir() {
    local path="$NAS_MUSIC/$1"
    if [[ -d "$path" ]]; then
        echo "📁 $(du -sh "$path" 2>/dev/null | cut -f1)  —  $(find "$path" -maxdepth 3 -type f \( -iname "*.flac" -o -iname "*.mp3" -o -iname "*.m4a" -o -iname "*.ogg" -o -iname "*.opus" \) | wc -l) tracks"
        echo "─────────────────────────────────────"
        find "$path" -maxdepth 2 -type f \( -iname "*.flac" -o -iname "*.mp3" -o -iname "*.m4a" -o -iname "*.ogg" -o -iname "*.opus" \) \
            | sed "s|$path/||" | sort | head -40
    else
        echo "(not a directory)"
    fi
}
export -f preview_dir
export NAS_MUSIC

# ── rsync wrapper ─────────────────────────────────────────────────────────────
do_sync() {
    local src="$1"
    local dst="$2"
    local dry="${3:-}"

    local flags=(-avh --progress --no-group --no-owner)
    [[ -n "$dry" ]] && flags+=(--dry-run)

    rsync "${flags[@]}" "$src" "$dst"
}

# ── Mode: Albums (top-level folders) ─────────────────────────────────────────
mode_albums() {
    info "Select albums/artists to sync  (TAB=multi-select, ENTER=confirm, ESC=quit)"
    echo ""

    local selected
    selected=$(
        ls -1 "$NAS_MUSIC" | sort \
        | fzf \
            --multi \
            --prompt="🎵 Albums > " \
            --header="TAB to select multiple | ENTER to sync | ESC to quit" \
            --preview='bash -c "preview_dir {}"' \
            --preview-window=right:45%:wrap \
            --marker="✓" \
            --color="header:italic,prompt:bright-cyan"
    ) || { info "No selection made."; return; }

    [[ -z "$selected" ]] && { info "Nothing selected."; return; }

    echo ""
    echo -e "${BOLD}Selected:${RESET}"
    echo "$selected" | while read -r item; do
        local size
        size=$(du -sh "$NAS_MUSIC/$item" 2>/dev/null | cut -f1)
        echo -e "  ${YELLOW}▸${RESET} $item  ${CYAN}($size)${RESET}"
    done

    echo ""
    local total_bytes
    total_bytes=$(echo "$selected" | while read -r item; do
        du_bytes "$NAS_MUSIC/$item"
    done | awk '{s+=$1} END {print s}')
    info "Total to sync: $(fmt_bytes "$total_bytes")"

    echo ""
    echo -e "  ${BOLD}[d]${RESET} Dry run (preview)   ${BOLD}[s]${RESET} Sync now   ${BOLD}[q]${RESET} Quit"
    read -rp "Choice: " choice

    case "$choice" in
        d|D)
            info "── Dry run ──────────────────────────────────"
            echo "$selected" | while read -r item; do
                info "Would sync: $item"
                do_sync "$NAS_MUSIC/$item" "$LOCAL_MUSIC/" --dry-run
                echo ""
            done
            ;;
        s|S)
            info "── Syncing ──────────────────────────────────"
            echo "$selected" | while read -r item; do
                info "Syncing: $item"
                do_sync "$NAS_MUSIC/$item" "$LOCAL_MUSIC/"
                ok "Done: $item"
                echo ""
            done
            ok "All done! Check $LOCAL_MUSIC"
            ;;
        *)
            info "Aborted."
            ;;
    esac
}

# ── Mode: Individual songs ────────────────────────────────────────────────────
mode_songs() {
    info "Select individual tracks to sync  (TAB=multi-select, ENTER=confirm)"
    echo ""

    local selected
    selected=$(
        find "$NAS_MUSIC" -type f \( -iname "*.flac" -o -iname "*.mp3" -o -iname "*.m4a" -o -iname "*.ogg" -o -iname "*.opus" \) \
            | sed "s|$NAS_MUSIC/||" | sort \
        | fzf \
            --multi \
            --prompt="🎵 Tracks > " \
            --header="TAB to select multiple | ENTER to sync" \
            --color="header:italic,prompt:bright-cyan" \
            --marker="✓"
    ) || { info "No selection made."; return; }

    [[ -z "$selected" ]] && { info "Nothing selected."; return; }

    local count
    count=$(echo "$selected" | wc -l)
    info "$count track(s) selected."

    echo -e "  ${BOLD}[d]${RESET} Dry run   ${BOLD}[s]${RESET} Sync now   ${BOLD}[q]${RESET} Quit"
    read -rp "Choice: " choice

    case "$choice" in
        d|D)
            echo "$selected" | while read -r track; do
                local src="$NAS_MUSIC/$track"
                local rel_dir
                rel_dir=$(dirname "$track")
                local dst="$LOCAL_MUSIC/$rel_dir/"
                info "[dry-run] $track → $dst"
                mkdir -p "$dst"
                rsync -avh --dry-run --progress "$src" "$dst"
            done
            ;;
        s|S)
            echo "$selected" | while read -r track; do
                local src="$NAS_MUSIC/$track"
                local rel_dir
                rel_dir=$(dirname "$track")
                local dst="$LOCAL_MUSIC/$rel_dir/"
                mkdir -p "$dst"
                rsync -avh --progress "$src" "$dst"
            done
            ok "All tracks synced."
            ;;
        *)
            info "Aborted."
            ;;
    esac
}

# ── Mode: Show synced ─────────────────────────────────────────────────────────
mode_synced() {
    info "Currently synced in $LOCAL_MUSIC:"
    echo ""
    if [[ -z "$(ls -A "$LOCAL_MUSIC" 2>/dev/null)" ]]; then
        echo "  (nothing synced yet)"
    else
        ls -1 "$LOCAL_MUSIC" | while read -r item; do
            local size
            size=$(du -sh "$LOCAL_MUSIC/$item" 2>/dev/null | cut -f1)
            echo -e "  ${GREEN}✔${RESET}  $item  ${CYAN}($size)${RESET}"
        done
        echo ""
        info "Total: $(du -sh "$LOCAL_MUSIC" 2>/dev/null | cut -f1)"
    fi
}

# ── Mode: Clean (remove local items) ─────────────────────────────────────────
mode_clean() {
    info "Select items to REMOVE from local ~/Music  (TAB=multi-select)"
    echo ""

    if [[ -z "$(ls -A "$LOCAL_MUSIC" 2>/dev/null)" ]]; then
        info "Nothing synced locally, nothing to clean."
        return
    fi

    local selected
    selected=$(
        ls -1 "$LOCAL_MUSIC" \
        | fzf \
            --multi \
            --prompt="🗑  Remove > " \
            --header="TAB to select | ENTER to delete from local | ESC to quit" \
            --color="header:italic,prompt:bright-red" \
            --marker="✓"
    ) || { info "No selection."; return; }

    [[ -z "$selected" ]] && { info "Nothing selected."; return; }

    echo ""
    echo -e "${RED}${BOLD}Will DELETE from local $LOCAL_MUSIC:${RESET}"
    echo "$selected" | while read -r item; do
        echo -e "  ${RED}✗${RESET}  $item"
    done
    echo ""
    read -rp "Are you sure? This only removes local copies. [y/N] " confirm
    [[ "$confirm" =~ ^[Yy]$ ]] || { info "Aborted."; return; }

    echo "$selected" | while read -r item; do
        rm -rf "${LOCAL_MUSIC:?}/$item"
        ok "Removed: $item"
    done
}

# ── Main ──────────────────────────────────────────────────────────────────────
main() {
    local mode="${1:-}"

    if [[ -z "$mode" ]]; then
        echo -e "${BOLD}fetch_music.sh${RESET} — what would you like to do?"
        echo ""
        mode=$(printf "albums\nsongs\nsynced\nclean\nquit" \
            | fzf --prompt="Mode > " --height=10 --no-multi \
                  --color="prompt:bright-cyan") || { info "Bye!"; exit 0; }
    fi

    case "$mode" in
        albums)  mode_albums  ;;
        songs)   mode_songs   ;;
        synced)  mode_synced  ;;
        clean)   mode_clean   ;;
        quit)    info "Bye!"; exit 0 ;;
        help|-h|--help) usage ;;
        *)       die "Unknown mode: $mode"; usage ;;
    esac
}

main "$@"

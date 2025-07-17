#################################################################

COLOR_RESET="\[\e[0m\]"
COLOR_CYAN="\[\e[0;36m\]"
COLOR_CYAN_BOLD="\[\e[1;36m\]"
COLOR_GREEN="\[\e[0;32m\]"
COLOR_GREEN_BOLD="\[\e[1;32m\]"
COLOR_PURPLE="\[\e[0;35m\]"
COLOR_PURPLE_BOLD="\[\e[1;35m\]"
COLOR_RED="\[\e[0;31m\]"
COLOR_RED_BOLD="\[\e[1;31m\]"
COLOR_YELLOW="\[\e[0;33m\]"
COLOR_YELLOW_BOLD="\[\e[1;33m\]"

ICON_GIT_DIRECTORY="💙"
ICON_STANDARD_DIRECTORY="😎"
ICON_TIME="⏳"

#################################################################

GIT_SH_PROMPT=/usr/lib/git-core/git-sh-prompt

if [ -f "$GIT_SH_PROMPT" ]; then
  . "$GIT_SH_PROMPT"
else
  echo "ERROR: git-sh-prompt is missing"
fi

#################################################################

get_git_info() {
    if git rev-parse --is-inside-work-tree &>/dev/null; then
        local branch
        branch=$(git symbolic-ref --short HEAD 2>/dev/null || git describe --tags --exact-match 2>/dev/null)

        local git_status
        git_status=$(git status --porcelain 2>/dev/null)

        local has_untracked=""
        local has_modified=""
        local has_staged=""
        local is_clean=true

        # Detect status flags
        while IFS= read -r line; do
            case "$line" in
                \?\?*) has_untracked=true ;;
                [MARCDU]?) has_staged=true ;;
                ?[MARCDU]) has_modified=true ;;
            esac
        done <<< "$git_status"

        local info=""
        local operations=""
        local stash_marker=""
        local conflict_marker=""

        # Detect ongoing Git operations
        [ -d .git/rebase-apply ] && operations+=" (rebase)"
        [ -f .git/MERGE_HEAD ] && operations+=" (merge)"
        [ -f .git/CHERRY_PICK_HEAD ] && operations+=" (cherry-pick)"
        [ -f .git/REVERT_HEAD ] && operations+=" (revert)"
        [ -f .git/BISECT_LOG ] && operations+=" (bisect)"

        # Detect stash
        local has_stash=""
        if git rev-parse --verify --quiet refs/stash &>/dev/null; then
            has_stash=true
        fi

        # Detect merge conflicts
        if [[ -n $(git diff --name-only --diff-filter=U) ]]; then
            conflict_marker=" [Conflict]"
        fi

        # Build status summary
        if [[ $has_staged ]]; then
            info+=" [Staged]"
            is_clean=false
        fi
        if [[ $has_modified ]]; then
            info+=" [Modified]"
            is_clean=false
        fi
        if [[ $has_untracked ]]; then
            info+=" [Untracked]"
            is_clean=false
        fi
        if [[ $has_stash && $is_clean == true ]]; then
            info+=" [Clean+Stash]"
        elif [[ $is_clean == true ]]; then
            info+=" [Clean]"
        fi
        if [[ $has_stash && $is_clean != true ]]; then
            stash_marker=" [Stash]"
        fi

        # Compose output
        echo -n "${ICON_GIT_DIRECTORY} ${ICON_TIME}$(date +%H:%M:%S) " \
            "${COLOR_YELLOW_BOLD}${branch}${COLOR_RESET}" \
            "${COLOR_PURPLE_BOLD}${operations}${info}${stash_marker}${conflict_marker}${COLOR_RESET}"
    else
        echo -n "${ICON_STANDARD_DIRECTORY} ${ICON_TIME}$(date +%H:%M:%S)"
    fi
}

trap 'LAST_COMMAND_STATUS=$?' DEBUG

get_user_host() {
    if [ $LAST_COMMAND_STATUS -eq 0 ]; then
        echo -n "${COLOR_GREEN_BOLD}\u@\h${COLOR_RESET}"
    else
        echo -n "${COLOR_RED_BOLD}\u@\h${COLOR_RESET}"
    fi
}

get_path() {
    echo -n "${COLOR_CYAN_BOLD}\w${COLOR_RESET}"
}

#################################################################

set_bash_prompt() {
    local git_info="$(get_git_info)"
    local user_host="$(get_user_host)"
    local path_info="$(get_path)"
    PS1="\n${git_info}\n${user_host}:${path_info} \$ "
}

#################################################################

PROMPT_COMMAND=set_bash_prompt

#################################################################


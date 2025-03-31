# git-update-function.sh
# Copyright 2025 James D. Fischer
# Source this file into the script that requires it.
#

###########################################################################
# git_update()
#
# @param[in] git_repo_directory
# @param[in] restore_starting_directory (boolean, optional). Default value
#       is 'false'.
# 
# DESCRIPTION
#   For branches 'main' and 'develop' within the Git repository located
#   in the specified git_repo_directory, git_update performes these tasks:
#   - git switch <branch>
#   - <stash any changed and/or untracked files>
#   - git pull
#   - <unstash any changed and/or untracked files>
#
###########################################################################

function git_update()
{
    local git_repo_directory="${1%/}"
    local restore_starting_branch="${2:-false}"
    local branch_name
    local git_repo_directory_realpath
    local git_stash_starting_branch
    local git_stash_current_branch
    local starting_branch
    local -r GIT=/usr/bin/git
    local -r REALPATH=/usr/bin/realpath

    # If the path string beings with a tilde character '~', replace the
    # tilde with the canonical path to the user's HOME directory.
    # See also:  https://stackoverflow.com/a/27485157/5051940
    git_repo_directory="${git_repo_directory/#\~/$HOME}"
    git_repo_directory_realpath="$("${REALPATH}" "$git_repo_directory")"

    echo
    echo "==============================================================="
    echo "  Processing: $git_repo_directory"
    if [[ "${git_repo_directory}" != "${git_repo_directory_realpath}" ]]; then
        echo "  Realpath  : $git_repo_directory_realpath"
    fi
    echo "==============================================================="

    if [[ ! -d "${git_repo_directory}" ]]; then
        >&2 echo ":: NOTICE :: Folder '${git_repo_directory}' does not exist."
        return
    elif [[ ! -d "${git_repo_directory}"/.git/ ]]; then
        >&2 echo ":: NOTICE :: Folder '${git_repo_directory}' does not contain a Git repository."
        return
    fi

    pushd "$git_repo_directory" >/dev/null

    starting_branch=$("$GIT" branch --show-current)

    # If the starting branch has changed or untracked files, stash them
    # before continuing.
    git_stash_starting_branch=false
    if [[ $("$GIT" status --porcelain) ]]; then
        "$GIT" stash --include-untracked
        git_stash_starting_branch=true
    fi

    "$GIT" fetch --all

    for branch_name in main develop; do
        if "$GIT" show-ref --quiet refs/heads/${branch_name}; then
            if "$GIT" switch "${branch_name}"; then

                # If this branch has changed or untracked files, stash them.
                git_stash_current_branch=false
                if [[ $("$GIT" status --porcelain) ]]; then
                    "$GIT" stash --include-untracked
                    git_stash_current_branch=true
                fi

                "$GIT" pull

                if $git_stash_current_branch; then
                    "$GIT" stash pop
                fi
            fi
        else
            >&2 echo ":: NOTICE :: Branch '${branch_name}' doesn't exist; skipping..."
        fi
    done

    # Checkout the starting branch and pop any stashed files
    "$GIT" checkout "$starting_branch"
    if $git_stash_starting_branch; then
        "$GIT" stash pop
    fi

    # If restore_starting_branch != true, switch to the 'develop' branch
    # and exit. Otherwise, remain on this branch (the starting branch) and
    # exit.
    if [ "$restore_starting_branch" != "true" ]; then
        "$GIT" switch develop
    fi

    popd >/dev/null
}


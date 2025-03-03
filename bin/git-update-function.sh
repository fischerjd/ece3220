# git-update-function.sh
# Copyright 2025 James D. Fischer
# Source this file into the script that requires it.
#

###########################################################################
##  git_update()
###########################################################################

function git_update()
{
    local git_repo_directory="${1%/}"
    local -r GIT=/usr/bin/git

    # If the path string beings with a tilde character '~', replace the
    # tilde with the canonical path to the user's HOME directory.
    # See also:  https://stackoverflow.com/a/27485157/5051940
    git_repo_directory="${git_repo_directory/#\~/$HOME}"
    git_repo_directory_realpath="$(/usr/bin/realpath "$git_repo_directory")"

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

    "$GIT" fetch --all

    for branch_name in main develop; do
        if "$GIT" show-ref --quiet refs/heads/${branch_name}; then
            if "$GIT" checkout "${branch_name}"; then
                "$GIT" pull
            fi
        else
            >&2 echo ":: NOTICE :: Branch '${branch_name}' doesn't exist; skipping..."
        fi
    done

    # Checkout the starting branch
    #"$GIT" checkout "$starting_branch"
    
    popd >/dev/null
}


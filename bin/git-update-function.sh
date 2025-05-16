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
#   For branches 'main'/'master' and 'develop' within the Git repository
#   located in the specified git_repo_directory, git_update performes these
#   tasks:
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
    local current_branch_files_were_stashed
    local git_repo_directory_realpath
    local starting_branch
    local starting_branch_files_were_stashed
    local -r GIT=/usr/bin/git
    local -r REALPATH=/usr/bin/realpath

    # If the path string begins with a tilde character '~', replace the
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

    pushd "$git_repo_directory" >/dev/null || exit 1

    starting_branch="$("$GIT" branch --show-current)"

    # If the starting branch has changed or untracked files, stash them
    # before continuing.
    starting_branch_files_were_stashed=false
    if [[ $("$GIT" status --porcelain) ]]; then
        "$GIT" stash --include-untracked
        starting_branch_files_were_stashed=true
    fi

    "$GIT" fetch --all

    for branch_name in main master develop; do
        if "$GIT" show-ref --quiet refs/heads/${branch_name}; then
            if "$GIT" switch "${branch_name}"; then

                # CHECK: Does this branch have a remote branch?
                if ! "$GIT" branch -r | /usr/bin/grep "origin/${branch_name}" &>/dev/null; then
                    # This branch does not have a remote branch.
                    # Ignore this branch.
                    cat << MESSAGE_EOF
:: NOTE ::
Branch '${branch_name}' does not have a remote-tracking branch.  If you want to
update the files in your '${branch_name}' branch, use git-merge(1) or git-rebase(1)
to merge the contents of your main/master branch, for example, into your
'${branch_name}' branch.
MESSAGE_EOF
                    continue
                fi

                # If this branch has changed or untracked files, stash them.
                current_branch_files_were_stashed=false
                if [[ $("$GIT" status --porcelain) ]]; then
                    "$GIT" stash --include-untracked
                    current_branch_files_were_stashed=true
                fi

                "$GIT" pull

                if $current_branch_files_were_stashed; then
                    "$GIT" stash pop
                fi
            fi
        else
            case ${branch_name} in
            main | master ) : ;;
            *) >&2 echo ":: NOTICE :: Branch '${branch_name}' doesn't exist; skipping..." ;;
            esac
        fi
    done

    current_branch="$(/usr/bin/git rev-parse --abbrev-ref HEAD)"

    if $starting_branch_files_were_stashed; then
        if [ "$current_branch" != "$starting_branch" ]; then
            "$GIT" switch "$starting_branch"
            current_branch="$starting_branch"
        fi
        "$GIT" stash pop
    fi

    if [ "$restore_starting_branch" == "true" ]; then
        if [ "$current_branch" != "$starting_branch" ]; then
            "$GIT" switch "$starting_branch"
        fi
    else
        # If this repository has a branch named 'develop', select the
        # develop branch before returning from this function.
        if [ "$current_branch" != "develop" ]; then
            if "$GIT" show-ref --quiet refs/heads/develop; then
                "$GIT" switch develop
            fi
        fi
    fi

    popd >/dev/null || exit 1
}


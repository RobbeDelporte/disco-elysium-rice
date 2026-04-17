#!/usr/bin/env bash
# Sync all three caelestia forks with upstream, following the workflow from
# the caelestia editing guide: fetch upstream, merge into local main, push to
# origin (my fork). Run with no arguments to sync everything, or pass one of
# `shell`, `cli`, `dots` to sync a single repo.
#
# Safe by default: aborts a repo if its working tree is dirty or HEAD isn't on
# `main`, rather than clobbering in-progress work. Use `--force-stash` to auto-
# stash and reapply (risky if you have conflicts pending).

set -euo pipefail

declare -A REPOS=(
    [shell]="$HOME/.config/quickshell/caelestia"
    [cli]="$HOME/.local/share/caelestia-cli"
    [dots]="$HOME/.local/share/caelestia-dots"
)

FORCE_STASH=0
TARGETS=()
for arg in "$@"; do
    case "$arg" in
        --force-stash) FORCE_STASH=1 ;;
        shell|cli|dots) TARGETS+=("$arg") ;;
        -h|--help)
            grep '^#' "$0" | sed 's/^# \{0,1\}//'
            exit 0 ;;
        *) echo "unknown arg: $arg" >&2; exit 2 ;;
    esac
done
[[ ${#TARGETS[@]} -eq 0 ]] && TARGETS=(shell cli dots)

sync_one() {
    local name="$1" dir="${REPOS[$1]}"
    echo
    echo "=== $name  ($dir) ==="

    if [[ ! -d "$dir/.git" ]]; then
        echo "  skip: not a git repo"; return
    fi
    cd "$dir"

    local branch; branch=$(git symbolic-ref --short HEAD 2>/dev/null || echo "DETACHED")
    if [[ "$branch" == "DETACHED" ]]; then
        echo "  skip: HEAD is detached. Check out a branch and re-run."
        return
    fi

    local dirty=0
    if ! git diff --quiet || ! git diff --cached --quiet; then dirty=1; fi

    local stashed=0
    if [[ $dirty -eq 1 ]]; then
        if [[ $FORCE_STASH -eq 1 ]]; then
            echo "  stashing local changes..."
            git stash push -u -m "caelestia-update auto-stash"
            stashed=1
        else
            echo "  skip: working tree dirty (pass --force-stash to auto-stash)"
            return
        fi
    fi

    local switched=0
    if [[ "$branch" != "main" ]]; then
        echo "  on '$branch' — switching to main to sync"
        git checkout main
        switched=1
    fi

    git fetch upstream --prune

    local new_commits
    new_commits=$(git log --oneline main..upstream/main || true)
    if [[ -n "$new_commits" ]]; then
        echo "  new upstream commits:"
        echo "$new_commits" | sed 's/^/    /'
    else
        echo "  already up to date with upstream/main"
    fi

    git merge --ff-only upstream/main || {
        echo "  fast-forward failed; falling back to merge commit"
        git merge --no-edit upstream/main
    }
    git push origin main

    if [[ $switched -eq 1 ]]; then
        echo "  returning to '$branch' and rebasing onto main"
        git checkout "$branch"
        if ! git rebase main; then
            echo "  !! rebase had conflicts — aborting; resolve manually with 'git rebase main'"
            git rebase --abort || true
        fi
    fi

    if [[ $stashed -eq 1 ]]; then
        echo "  re-applying stash..."
        git stash pop || echo "  !! stash pop had conflicts — resolve manually"
    fi

    if [[ "$name" == "shell" ]]; then
        echo "  rebuilding native plugin..."
        cmake --build "$dir/build" -j"$(nproc)"
        cmake --install "$dir/build"
    fi

    echo "  ok"
}

for t in "${TARGETS[@]}"; do
    sync_one "$t"
done

echo
echo "done."

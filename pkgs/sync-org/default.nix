{ writeShellApplication, git, coreutils, openssh }:

writeShellApplication {
  name = "sync-org";
  runtimeInputs = [ git coreutils openssh ];
  text = ''
  WORKING_DIR=$HOME/org

  function sync_org::diff() {
      cd "''${WORKING_DIR}"

      # 1. Check whether there are untracked files
      has_untracked=$(git ls-files --others | wc -l)

      if [[ ''${has_untracked} -ne 0 ]]; then
          echo "yes"
          return 0
      fi

      # 2. Check outstanding changes
      git diff-index --quiet "$1"
      has_changes=$?

      if [[ ''${has_changes} -ne 0 ]]; then
          echo "yes"
          return 0
      fi

      echo "no"
  }

  function sync_org::try_commit() {
      cd "''${WORKING_DIR}"

      # Check whether there are outstanding changes
      if [[ "$(sync_org::diff HEAD)" == "no" ]]; then
          # If there is no change, task completed.
          echo "[ ok ] No outstanding changes."
          return 0
      fi

      # When there are changes, list the diffs and create a commit.
      git diff-index --name-status HEAD
      echo "[info] Creating commit ..."
      git add .
      if [ -z "$(git status --porcelain)" ]; then
          echo "[ ok ] nothing to commit."  
      else
          git commit -m "@$(hostname) Automatic Sync,  $(date)"
      fi
  }

  function sync_org::pull_rebase() {
      cd "''${WORKING_DIR}"

      git pull --rebase
      pull_success=$?

      if  [[ ''${pull_success} -eq 0 ]]; then
          return 0
      fi

      echo "[FAIL] Cannot pull --rebase."

      return 15
  }

  function sync_org::main() {
      if [[ ! -d ''${WORKING_DIR} ]]; then
          echo "[FAIL] working directory ''${WORKING_DIR} does not exist."
          return 1
      fi
      cd "''${WORKING_DIR}"

      # Compare with remote origin/master, return if no need to sync.
      git fetch
      if [[ "$(sync_org::diff origin/master)" == "no" ]]; then
          echo "[done] No need to sync."
          return 0
      fi

      sync_org::try_commit
      sync_org::pull_rebase
      git push

      echo "[done] Sync'ed with remote."
  }

  sync_org::main
  '';
}

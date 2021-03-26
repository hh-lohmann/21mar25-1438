#
# qgit.sh
#

exitShowSyntax() {
  showSyntax
  exit
}

showSyntax() {
  printf "Syntax:\n"
  printf "$(basename $0) ( '?' | ( ["] QGIT-SHORTCUT { SHORTCUT-ARGUMENTS } ["] | GIT-COMMAND ) { GIT-OPTION } )\n"
  printf "  - '?' lists all defined shortcuts \n"
  printf "  - QGIT-SHORTCUT is a defined shortcut\n"
  printf "    - If SHORTCUT has no arguments, than \"\"s are optional\n"
  printf "    - ! Shortcuts can do actions on their own *or* just pass over options to Git\n"
  printf "      - In the second case additional options are possible\n"
  printf "        - ! qgit passes options arguments without any examination\n"
  printf "  - GIT-COMMAND is a Git command\n"
  printf "    - ! Only one Git command possible\n"
  printf "  - GIT-OPTIONs are those as defined for the respective Git command\n"
}


show_qs() {
  [ ! "$1" ] && list_qs || check_q $1
}

list_qs() {
  printf "Defined Shortcuts:   (\"? SHORTCTUT\" for details)\n"
  declare -F | grep "q_" | sed -e 's/declare -f q_/  - /'
}

check_q() {
  [ ! "$1" ] &&  echo "Kein Shortcut angegben" && return
  strTst=$(declare -f "q_$1" | tail -n +2)
  [ "$strTst" ] && echo "$strTst" || echo "'$1' nicht vorhanden"
}

exit_qError() {
  printf "\n"
  printf "################################################################################\n"
  printf "FEHLER:\n"
  printf "$1\n"
  printf "################################################################################\n"
  printf "\n\n"
    # NB: "exit" effectless if function is called via "$()"
  exit
}

q_log1() {
  echo "log --oneline"
}

q_logn() {
  echo "log --name-status"
}

  # EXAMPLE + for testing
  #   - NO Action here + Action passing to Git
  #   - compare q_add-branch, q_del-branch 
q_show-branch() {
  [ ! "$1" ] && exit_qError "show-branch: kein BRANCHNAME angegeben"
    # NO action here
  # ...nothing...
    # Action to pass over
  echo "branch --list $1"
}

  # EXAMPLE + for testing
  #   - Action here + Action passing to Git
  #   - compare q_show-branch, q_del-branch 
q_add-branch() {
  [ ! "$1" ] && exit_qError "add-branch: kein BRANCHNAME angegeben"
    # Action here
  git branch $1
    # Action to pass over (here: check result)
  echo "branch"
}

  # EXAMPLE + for testing
  #   - Action here + NO Action passing to Git
  #   - compare q_show-branch, q_add-branch 
q_del-branch() {
  [ ! "$1" ] && exit_qError "del-branch: kein BRANCHNAME angegeben"
    # Action here
  git branch -d $1
    # NO action to pass over
    #   - => ! Special echo to still allow shortcut existence check
  echo "()"
}

q_open-task() {
  [ ! "$1" ] && exit_qError "add-orphan: kein TITLE angegeben"
  echo "hallo checkout --orphan ID $1"

}

[ ! "$1" ] && exitShowSyntax
[ "$1" = "?" ] && show_qs $2 && exit
declare qargs=()
declare strCmdArgs
declare strTst
for arg in "$@"
  do
    strTst=${arg%% *}
    [ "$strTst" != "$arg" ] && strCmdArgs="${arg#* }" || strTst=$arg
    strTst="$("q_$strTst" "$strCmdArgs" 2>/dev/null)"
    strCmdArgs=''
    if [ "$strTst" ]
      then
        qargs=( "${qargs[@]}" "$strTst" )
      else
        qargs=( "${qargs[@]}" "$arg" )
    fi
  done

echo "--------------------------------------------------------------------------------"
# echo "reading...: qgit $@"
echo "qgit performing: git ${qargs[@]}"
echo "--------------------------------------------------------------------------------"

  # "###" signals exit_qError => exit if function is called via "$()"
[ "${qargs[0]:4:3}" = "###" ] && exit
  # Shortcut without action to pass to Git (signalled by "()" as echo)
echo "schno: ${qargs[0]::2}" && exit
[ "${qargs[0]}" = "()" ] && echo "guo" && exit
# git ${qargs[@]}

#()
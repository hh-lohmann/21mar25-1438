#
# qgit.sh
#

exitShowSyntax() {
  showSyntax
  exit
}

showSyntax() {
  printf "Syntax:\n"
  printf "$(basename $0) ( '?' | ( QGIT-SHORTCUT | GIT-COMMAND ) { GIT-OPTION } )\n"
  printf "  - '?' lists all defined shortcuts \n"
  printf "  - QGIT-SHORTCUT is a defined shortcut\n"
  printf "  - GIT-COMMAND is a Git command\n"
  printf "  - GIT-OPTIONs are those as defined for Git commands\n"
}


show_qs() {
  declare -F | grep "q_" | sed -e 's/declare -f q_//'
}

q_log1() {
  echo "log --oneline"
}

q_logn() {
  echo "log --name-status"
}

[ ! "$1" ] && exitShowSyntax
[ "$1" = "?" ] && show_qs && exit
declare qargs=()
declare strTst
for arg in "$@"
  do
    strTst="$("q_$arg" 2>/dev/null)"
    # if [ "$("q_$arg" 2>/dev/null)" ]
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

git ${qargs[@]}

#()
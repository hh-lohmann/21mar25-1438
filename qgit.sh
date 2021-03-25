#
# qgit.sh
#

exitShowSyntax() {
  showSyntax
  exit
}

q_log1() {
  echo "log --oneline"
}

q_logn() {
  echo "log --name-status"
}

[ ! "$1" ] 
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
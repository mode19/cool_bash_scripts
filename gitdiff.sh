#!/bin/bash
#
# 1. Show a user a git log and let them select a commit as A
# 2. Show a user a git log and let them select a commit as B
# 3. Show a git diff -- stat summary and let them select a filename
# 4. call git difftool to compare A v.s B for that f for file
#


GIT_LOG_CMD='git log --date=short --pretty=format:"%h,%ad:[%aN]:%s" | nl | head -20'

#
# getCommitFromLog <ReturnValue>
# Return value is the COMMIT number that the user selected on the command line
#
function getCommitFromLog() {
  local  __resultvar=$1
  eval $GIT_LOG_CMD 
  echo "Chose commit:"
  read n
  BEFORE_LINE=`eval $GIT_LOG_CMD | egrep "^\s+$n\s+"`
  COMMIT=`echo "$BEFORE_LINE" | sed -e "s/\s\+$n\s\+//" | cut -f1 -d","`
  echo "$COMMIT"
  eval $__resultvar="'$COMMIT'"
}

getCommitFromLog FIRSTCOMMIT
getCommitFromLog SECONDCOMMIT

while true;
do
  echo "Diffing from commit [$FIRSTCOMMIT] to [$SECONDCOMMIT]:"
  git diff --stat=200 --stat-graph-width=10 $FIRSTCOMMIT $SECONDCOMMIT | grep -v "file[s]* changed" |  nl
  read FILENUM
  if [[ "$FILENUM" = "q" ]]
  then
      exit
  fi
  FILENAMELINE=`git diff --stat=200 --stat-graph-width=10 $FIRSTCOMMIT $SECONDCOMMIT | grep -v "file([s])* changes" | nl | egrep "^\s+$FILENUM\s+"`
  FILENAME=`echo "$FILENAMELINE" | sed -e "s/\s\+$FILENUM\s\+//" | cut -f1 -d" "`
  echo "Diffing $FILENUM - $FILENAME"
  echo "COMMAND=git difftool -y -t kdiff3 $FIRSTCOMMIT $SECONDCOMMIT -- $FILENAME"
  git difftool -y -t kdiff3 $FIRSTCOMMIT $SECONDCOMMIT -- $FILENAME
done


#!/bin/sh
ResFile="$0.res"
echo $'\n\n----' >> "${ResFile}"
set -o pipefail
set -uC

(
  set -ex 
  (
    date
  	pwd
    
    ./Fetch.sh
    ./Deploy.sh
  )
)
  ExitCode=$?
  exit ${ExitCode}
 2>&1 | tee -a "${ResFile}"

exit ${ExitCode}

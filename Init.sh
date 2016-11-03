#!/bin/sh
ResFile="$0.res"
echo $'\n\n----' >> "${ResFile}"
set -o pipefail
set -uC

set -ex 
(
	pwd
	source './zConfig.sh'

	echo '0' > "${RepoVersionFile}" || true
	echo '0' > "${ServerVersionFile}" || true
)

ExitCode=$?
exit ${ExitCode} && echo 'Success' || echo "Error / ExitCode = $?"
  
exit ${ExitCode}
 2>&1 | tee -a "${ResFile}"

read -rs -n1 -p 'Press any key to continue...'

exit ${ExitCode}

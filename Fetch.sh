#!/bin/sh
ResFile="$0.res"
CurrentDir=$(pwd)
echo $'\n\n----' >> "${ResFile}"
set -o pipefail
set -uC
( (
	set -ex
	source "${CurrentDir}/zConfig.sh"
	WorkDir="${CurrentDir}/${WorkDir}";
	cd "${WorkDir}"
		pwd
		FetchCmd="git fetch --prune --all"
		eval "${FetchCmd}" 

		eval "git rev-parse ${TargetBranch}" >| "${CurrentDir}/${RepoVersionFile}"
	cd "${CurrentDir}"
  )
	ExitCode=$?
	(exit ${ExitCode}) && echo 'Success' || echo "Error / ExitCode = $?"
	exit ${ExitCode}
) 2>&1 | tee -a "${ResFile}"
ExitCode=$?
exit ${ExitCode}
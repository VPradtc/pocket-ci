#!/bin/sh
ResFile="$0.res"
CurrentDir="$1" || ""
echo $'\n\n----' >> "${ResFile}"
set -o pipefail
set -uC
( (
	set -ex
	source "${CurrentDir}./zConfig.sh"
	WorkDir="${CurrentDir}${WorkDir}";
	cd "${WorkDir}"
	pwd
	FetchCmd="git fetch --prune --all"
	time ${FetchCmd} ||
	(
		ExitCode=0
		${FetchCmd} ||
		ExitCode=$?

		git rev-parse "${TargetBranch}" | echo > "${RepoVersionFile}"
		
		exit ${ExitCode}
	) ; (exit $?) || false

  )
	ExitCode=$?
	(exit ${ExitCode}) && echo 'Success' || echo "Error / ExitCode = $?"
	exit ${ExitCode}
) 2>&1 | tee -a "${ResFile}"
ExitCode=$?
exit ${ExitCode}
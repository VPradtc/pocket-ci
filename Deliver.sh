#!/bin/sh
ResFile="$0.res"
echo $'\n\n----' >> "${ResFile}"
set -o pipefail
set -uC

(
  set -ex 
  (
	source "./zConfig.sh"

	while read -r Line
	do
	    RepoVersion="${Line}"
	done < "${RepoVersionFile}"

	while read -r Line
	do
	    ServerVersion="${Line}"
	done < "${ServerVersionFile}"

	(
		"${RepoVersionFile}"
		-eq
		"${ServerVersionFile}"
	) && echo 'Up to date.' && exit 0
	||
	(
		SolutionFileFilter=".*\.\(sln\)"

    	FindSolutionCmd="find ./ -type f -maxdepth 1 -regex '${SolutionFileFilter}'"
    	BuildCmd="${MSBuildPath} /p:DeployOnBuild=true /t:Clean,Build /p:PublishProfile=${PublishProfileName}"

		cd "${WorkDir}"

		git branch -f "${CiBranch}" "${TargetBranch}"
		git checkout -q "${CiBranch}"

		eval "${FindSolutionCmd} -exec ${BuildCmd}"

		git rev-parse "${CiBranch}" | echo > "${ServerVersionFile}"
	)
  )
)
  exit ${ExitCode}
 2>&1 | tee -a "${ResFile}"

exit ${ExitCode}

#!/bin/sh
ResFile="$0.res"
CurrentDir=$(pwd)
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

	
	if [ "${RepoVersion}" == "${ServerVersion}" ]; then 
		echo 'Up to date.' && exit 0 
	else (

			cd "${WorkDir}"
			(

				ProjectFileFilter=".*\.\(csproj\)"

				BuildParams="/property:DeployOnBuild=true /target:Clean,Build /property:PublishProfile=${PublishProfile}"

				(git rev-parse "${CiBranch}") || (git branch "${CiBranch}")

				git checkout -q "${CiBranch}"
				git reset --hard "${TargetBranch}"

				ProjectPath=$(find ./ -type f -name ${ProjectName} | xargs realpath | xargs cygpath -m)

				eval "\"${MSBuildPath}\" \"${ProjectPath}\" ${BuildParams}"
			) && (

				WebsitePath=$(find ./ -type d -name ${WebsiteDir} | xargs realpath)
				TmpDir="./tmp"
				PublishDir=$(cygpath -u ${PublishDirectory})

				cp -R "${WebsitePath}/." "${TmpDir}"

				find "${TmpDir}" -type f -regex ".*Web.*config" | xargs rm -f

				cp -R "${TmpDir}/." "${PublishDir}"

			)

			git rev-parse "${CiBranch}" >| "${CurrentDir}/${ServerVersionFile}"
		)
	fi
	ExitCode=$?
  )
  ExitCode=$?
)
ExitCode=$?
  exit ${ExitCode}
 2>&1 | tee -a "${ResFile}"

exit ${ExitCode}

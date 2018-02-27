#!/bin/bash

REPOS="naisible nais-platform-apps nais-tpa nais-inventory"
TWO_MINUTES_AGO=$((`date +'%s'` - 120))

for REPO in `echo ${REPOS}`; do
	cd ${REPO}
	LAST_COMMIT=`git show -s --format=%ct`
	if [[ ${LAST_COMMIT} > ${TWO_MINUTES_AGO} ]]; then
		echo "Repo: ${REPO}"
		git log -1 && exit 0
	fi
	cd ${WORKSPACE}
done

exit 0

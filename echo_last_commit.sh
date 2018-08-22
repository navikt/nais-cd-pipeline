#!/bin/bash

REPOS="naisible nais-platform-apps nais-tpa nais-inventory nais-yaml"
REPO_WITH_TIMESTAMP=()

# creates a list of tuples on the format <last changed timestamp since epoch>;<repo name>
for REPO in `echo ${REPOS}`; do
    cd ${REPO}
    LAST_COMMIT_TIMESTAMP=`git show -s --format=%ct`
    REPO_WITH_TIMESTAMP+=("${LAST_COMMIT_TIMESTAMP};${REPO}")
    cd ${WORKSPACE}
done

LAST_CHANGED_REPO=$(echo ${REPO_WITH_TIMESTAMP[@]} | tr " " "\n" | sort | tail -n 1 | cut -d";" -f2)

cd ${LAST_CHANGED_REPO}

echo "Repo: ${LAST_CHANGED_REPO}"
git log -1 && exit 0

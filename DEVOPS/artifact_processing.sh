#!/bin/bash
#set -x
export WORKSPACE_IN=$1
export BRANCH_NAME=$2
export WORKSPACE=$(echo $WORKSPACE_IN | tr '\' '/' | sed 's|:||' | sed 's|^|/|')
function createGitTag
{
echo "Started Creating Git Tag ..."
 cd $WORKSPACE 
 git config --global user.name "[git user name]"
 git config --global user.email "[user email address]"
 git remote set-url origin "https://[[git user name]]:[git token]@github.com/[git user name]/[git repository name].git"
 git fetch --tag
 git tag -l
 branch_version=$(echo ${BRANCH_NAME} | cut -d '_' -f4 )
 if [ `echo ${BRANCH_NAME} | grep -c '^dwh_bi_Rel_[0-9]\{2,\}$'` -eq 1 ]
 then
    export PATTERN="dwh_release_${branch_version}.0"
 else
    export PATTERN="dwh_snapshot_${branch_version}.0"
 fi
 prev_tag_number=`git tag -l | grep "^${PATTERN}." | cut -d '.' -f3 | sort -n | tail -1` 
 new_tag_number=`expr $prev_tag_number + 1`
export new_tag=${PATTERN}.${new_tag_number}
 git tag ${new_tag}  
 git push origin --tags 

echo "Completed Creating Git Tag ${new_tag}..."
}

function artifactoryCheckIn
{
echo "Completed pushing artifact ${new_tag} to artifactory..."
cd $WORKSPACE
tar -cvf ${new_tag}.tar .
gzip ${new_tag}.tar
curl -v --user [artifactory user name]:[artifactory user password] -T ${new_tag}.tar.gz -X PUT https://[artifactory domain]/artifactory/[artifactory repo name]/${new_tag}/${new_tag}.tar.gz

echo "Completed pushing artifact ${new_tag} to artifactory..."
}

createGitTag > ${WORKSPACE}/artifact.log 2>&1
artifactoryCheckIn >> ${WORKSPACE}/artifact.log 2>&1


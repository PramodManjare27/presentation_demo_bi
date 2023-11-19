#!/bin/bash
set -x
export WORKSPACE_IN=$1
export BRANCH=$2
export BUILD_NUM=$3
export WORKSPACE=$(echo $WORKSPACE_IN | tr '\' '/' | sed 's|:||' | sed 's|^|/|')

function skip_first_build
{
set -x
if [ ${BUILD_NUM} -eq 1 ]
then
  echo "skipping build as this is fresh branch"
  echo 'Y' > ${WORKSPACE}/failure_checkout.log
  exit 5
else
  echo "Valid commit, proceeding with build"
  echo 'N' > ${WORKSPACE}/failure_checkout.log
fi
}

function committer_release_file_mapping
{
  echo "Started mapping release file..."
export release_file_name=`echo release_$(git log -1 | grep Author | cut -d '<' -f2 | cut -d '>' -f1 | tr '.' '_' | cut -d '@' -f1)`
  echo "release file name is ${release_file_name}"
  if [ -f "${WORKSPACE}/RELEASES/${release_file_name}" -a ! -z "${release_file_name}" -a `echo ${BRANCH_NAME} | grep -c '^dwh_bi_Rel_[0-9]\{2,\}$'` -eq 0 ]
  then 
     if [ `echo ${BRANCH_NAME} | grep -c '^dwh_bi_Rel_[0-9]\{2,\}$'` -eq 1 ]
	  then 
	       echo "Skipping release file copy... For release branches, we will not have single reelase file "
	  else	   
		   cp RELEASES/${release_file_name} ${WORKSPACE}/release
	 fi 
  elif [ ! -z "${release_file_name}" -a `echo ${BRANCH_NAME} | grep -c '^dwh_bi_Rel_[0-9]\{2,\}$'` -eq 1 ]
  then 
     echo "Skipping release file copy... For release branches, we will not have single reelase file"
	   echo 'N' > ${WORKSPACE}/failure_checkout.log
  else 
     echo "unable to locate release file... exiting"
	   echo 'Y' > ${WORKSPACE}/failure_checkout.log
	 exit 2
  fi
  echo "Completed mapping release file..."
  echo 'N' > ${WORKSPACE}/failure_checkout.log
}

function validate_release_version
{
set -x
if [ `echo ${BRANCH_NAME} | grep -c '^dwh_bi_Rel_[0-9]\{2,\}$'` -eq 1 ]
then
	   echo "Skpping the validations of rlease file version on release branch..."
else
 cd $WORKSPACE 
 release_file_version=$(cat ${WORKSPACE}/RELEASES/${release_file_name} | grep 'RELEASE_VERSION=' |cut -d '=' -f2)
 branch_name_version=$(echo ${BRANCH} | cut -d '_' -f4 )
 if [ $release_file_version == ${branch_name_version} ]
 then
    echo "Validation suceeded, branch version and release file version matches"
	echo 'N' > ${WORKSPACE}/failure_checkout.log
 else
    echo "Branch version and release file version is not matching.. exiting"
	echo 'Y' > ${WORKSPACE}/failure_checkout.log
    exit 1
 fi
fi
}


skip_first_build > ${WORKSPACE}/build.log 2>&1
committer_release_file_mapping >> ${WORKSPACE}/build.log 2>&1
validate_release_version >> ${WORKSPACE}/build.log 2>&1
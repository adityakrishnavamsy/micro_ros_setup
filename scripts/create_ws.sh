#! /bin/bash

set -e
set -o nounset
set -o pipefail

if [ $# -lt 3 ]  #$# is number of arguments is lessthan 3 then
then
    echo "Syntax: $0 <targetdir> <pkglist> <repolist>"
    exit 255
fi

if [ ! -d  $1 ] #if the first argument i.e target dictinory is not found then
then
    echo "Error: Target ('$1') must be a directory but isn't".
    exit 255
fi


PACKAGES=$2
REPOS=$3

if [ ! -f ${PACKAGES} ]  #if the file having packages is not found then 
then
    echo "Error: Package list file $PACKAGES (expanded from $2) does not exist"
    exit 255
fi

if [ ! -f ${REPOS} ] #if file having the repo is not found then 
then
    echo "Error: Repo file $REPOS (expanded from $3) does not exist"
    exit 255
fi


pushd $1 >/dev/null   #https://linuxhint.com/what_is_dev_null/    when there are a lot of op then we push it to null to keep terminal clean
if [ -f ros2.repos ]  #if file is present then ros2.repo
then
    echo "Repo-file ros2.repos already present, overwriting!"
fi

# ROS_DISTRO SPECIFIC
#curl is a command-line tool to transfer data to or from a server, using any of the supported protocols
#-s is for silent transfer with out msges displayed
curl -s https://raw.githubusercontent.com/ros2/ros2/foxy/ros2.repos |\
    ros2 run micro_ros_setup yaml_filter.py ${PACKAGES} > ros2.repos   #push the packages to ros2.repo
vcs import --input ros2.repos --skip-existing  #to clone all repos
vcs import --input $REPOS --skip-existing    $to clone all repos

popd >/dev/null


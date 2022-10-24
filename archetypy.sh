#!/bin/bash


if [ $# -eq 0 ]
    then
        echo "No arguments supplied."
        exit 1
fi

handle_interrupt() {
    echo Exiting...
    exit
}

trap handle_interrupt SIGINT

SCRIPT=`realpath $0`
SCRIPTPATH=`dirname $SCRIPT`

# won't do this probably
# if [ ! -d $1 ]
#     then
#         echo directory $1 does not exist in $SCRIPTPATH. creating one...
#         mkdir ./$1
# fi


PACKAGEPATH=`realpath $1`
PACKAGENAME="${PACKAGEPATH%"${PACKAGEPATH##*[!/]}"}" # extglob-free multi-trailing-/ trim
PACKAGENAME="${PACKAGENAME##*/}"                  # remove everything before the last /
PACKAGENAME=${PACKAGENAME//-/_}


echo Starting the project in $PACKAGEPATH.
mkdir $PACKAGEPATH/$PACKAGENAME

# initialize dir structure with the static files
ARCHETYPEPATH=$SCRIPTPATH/resources/project-archetype/
find $ARCHETYPEPATH -maxdepth 1 -type d,f ! -name package_name ! -path $ARCHETYPEPATH -exec cp -rt $PACKAGEPATH {} +

# initialize Python environment with archetype packages
echo Initializing Python evironment in $PACKAGEPATH/venv/.
python3 -m venv $PACKAGEPATH/venv
echo Installing Python packages to the environment
$PACKAGEPATH/venv/bin/pip install -r $PACKAGEPATH/requirements.txt


echo Initializing a git repository in $PACKAGEPATH.
git init $PACKAGEPATH/



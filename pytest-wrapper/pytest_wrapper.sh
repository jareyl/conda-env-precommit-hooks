#!/bin/bash

source
# -----------------------------------------------------------------------
# Functions definition
# -----------------------------------------------------------------------
function check_pytest_status() {
  status=$1
  if [ $status -eq 0 ]; then
    echo "All tests were collected and passed successfully"
  elif [ $status -eq 1 ]; then
    echo "Tests were collected and run but some of the tests failed"
  elif [ $status -eq 2 ]; then
    echo "Test execution was interrupted by the user"
  elif [ $status -eq 3 ]; then
    echo "Internal error happened while executing tests"
  elif [ $status -eq 4 ]; then
    echo "pytest command line usage error"
  elif [ $status -eq 5 ]; then
    echo "No tests were collected"
  else
    echo "Unknown error occurred"
  fi
}
# -----------------------------------------------------------------------
# End functions definition
# -----------------------------------------------------------------------

MY_PATH=$(dirname "$0")            # relative
MY_PATH=$(dirname $(dirname $(cd "$MY_PATH" && pwd)))    # going up 2 dir levels
if [[ -z "$MY_PATH" ]] ; then
  # error; for some reason, the path is not accessible
  # to the script (e.g. permissions re-evaled after suid)
  exit 1  # fail
fi

#Paths management
ROOT_PATH=$MY_PATH
SETUP_PATH=$ROOT_PATH/setup
SETUP_CONF_PATH=$SETUP_PATH/style_conf
SRC_PATH=$ROOT_PATH/src
TESTS_PATH=$ROOT_PATH/tests
INI_PATH=$TESTS_PATH/pytest.ini

####### Installing dev dependencies in order to be able to run tests properly
pip install -r "$SETUP_PATH/requirements_develop.txt"
pip install -r "$SETUP_PATH/requirements.txt"

####### Pytest execution.
cd $TESTS_PATH && PYTHONPATH=$SRC_PATH pytest -c $INI_PATH -rfs $TESTS_PATH
status=$?
echo "Finished pytest execution with status $status"
check_pytest_status $status
exit $status


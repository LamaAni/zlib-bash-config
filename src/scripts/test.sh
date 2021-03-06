#!/bin/bash

function assert() {
  local code="$1"
  shift
  if [ "$code" -ne 0 ]; then
    echo "[ERROR]" "$@"
  fi
  return $code
}

function zbash_config_test_counts() {
  local counts="$ZBASH_CONFIG_TEST_CYCLE_COUNT"
  : "${counts:="100"}"
  echo "$counts"
}

function zbash_config_test_method_call() {
  for i in $(seq 1 "$(zbash_config_test_counts)"); do
    "$@" >>/dev/null
    assert $? " When invoking: " "$@" || return $?
  done
}

function zbash_config_test_git_speed() {
  local counts="$(zbash_config_test_counts)"
  echo "Checking $counts times get git branch"
  time zbash_config_test_method_call prompt_git || return $?
  echo "Checking $counts times get git status"
  time zbash_config_test_method_call prompt_git_status || return $?
}

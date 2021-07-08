#!/bin/sh

workspace_path=$1
project_path=$2
wait_sec=$3
wait_host=$4
wait_port=$5

run_cmd=${RUN_CMD}
init_file=${INIT_FILE}

exit_with_usage() {
    echo "usage:"
    echo "sh wait_to_run.sh <workspace_abs_path>  <project_path_rel_to_workspace> [wait_sec] [wait_host <wait_port>]"
    echo "accept environment:"
    echo "RUN_CMD: the command to run, if not assigned, 'tail -f /dev/null' by default"
    echo "INIT_FILE: a .sh file in project_path, will execute it before run the RUN_CMD"
    exit
}

if [ -z "$project_path" ]; then
    exit_with_usage
fi

if [ -n "$wait_host" ]; then
    if [ -z "$wait_port" ]; then
        exit_with_usage
    fi
    nc_check=1
    until [ $nc_check -eq 0 ]; do
        nc -z $wait_host $wait_port
        nc_check=$?
        sleep 1
    done
fi

if [ -n "$wait_sec" ]; then
    sleep $wait_sec
fi

base_path="$workspace_path/$project_path"

if [ -n "$init_file" ]; then
    if [ -f "$base_path/$init_file" ]; then
        cd $base_path && sh "./$init_file"
    else
        echo "$base_path/$init_file does not exist"
    fi
fi

if [ -n "$run_cmd" ]; then
    cd $base_path && sh -c "$run_cmd"
else
    tail -f /dev/null
fi
#!/usr/bin/env bash

set -e

if [[ -z "$ROS_PACKAGE_NAME" ]]; then
    echo "Error: ROS_PACKAGE_NAME is not set." >&2
    exit 1
fi

if [[ -z "$ROS_NODE_NAME" ]]; then
    echo "Error: ROS_NODE_NAME is not set." >&2
    exit 1
fi

if [[ -z "$ROS_DISTRO" ]]; then
    echo "Error: ROS_DISTRO is not set." >&2
    exit 1
fi


cd /ros2_ws/

ROS2_WORKSPACE_DIRECTORY="/ros2_ws/"

source /opt/ros/$ROS_DISTRO/setup.bash
source /opt/ros/$ROS_DISTRO/local_setup.bash
source /ros2_ws/install/local_setup.bash


exec ros2 run "$ROS_PACKAGE_NAME" "$ROS_NODE_NAME"


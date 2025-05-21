#!/bin/bash

set -e

# soure ros2
source /opt/ros/${ROS_DISTRO}/setup.bash

# execute a command in the container that keeps it open
tail -f /dev/null

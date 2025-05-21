FROM ros:humble-ros-base-jammy

SHELL ["/bin/bash", "-c"]

# set the ros version
ENV ROS_DISTRO=humble

# install some useful packages and upgrade existing ones
#   -y so skips interactive terminal to reduce error
RUN apt update && apt upgrade -y \
    && apt install -y \
    apt-utils \
    git \
    curl \
    nano \
    vim \
    tmux \
    x11-apps \
    python3-pip \
    python-is-python3 \
    # install dependencies for robofleet
    libqt5websockets5-dev \
    # remove qt5-default not found error
    qtbase5-dev \
    qtchooser \
    qt5-qmake \
    qtbase5-dev-tools

# install full ros package
RUN apt update && apt upgrade -y \
    && apt install -y \
    ros-${ROS_DISTRO}-desktop-full

# install ros packages
# see ../docs/installing_ros_packages.md for alternatives
RUN DEBIAN_FRONTEND=noninteractive apt install -y \
    # Packages essential for Robot Control
    ros-${ROS_DISTRO}-ros2-control \
    ros-${ROS_DISTRO}-gazebo-ros2-control \
    ros-${ROS_DISTRO}-joint-state-broadcaster \
    ros-${ROS_DISTRO}-joint-trajectory-controller\
    ros-${ROS_DISTRO}-ros2-controllers \
    ros-${ROS_DISTRO}-moveit-msgs \
    ros-${ROS_DISTRO}-nav2-msgs \
    # All URDF related packages
    ros-${ROS_DISTRO}-urdf* \
    # Package essential for realsense ROS integration
    ros-${ROS_DISTRO}-realsense2-* \
    && rm -rf /var/lib/apt/lists/

RUN rosdep update

# switch to home dir
WORKDIR /root/ros2_ws

# setup .bashrc
SHELL ["/bin/bash", "-l", "-c"]
#   # set the bash prompt colors
RUN sed -i 's/#force_color_prompt=yes/force_color_prompt=yes/' "/root/.bashrc" \
    && sed -i 's/01;32m/01;36m/g; s/01;34m/01;35m/g' "/root/.bashrc" \
    # source ros setup.bash
    && echo "source /opt/ros/${ROS_DISTRO}/setup.bash" >> ~/.bashrc \
    && echo "source /opt/ros/${ROS_DISTRO}/setup.bash" >> ~/.profile \
    # add a package to the ROS_PACKAGE_PATH
    echo "export ROS_PACKAGE_PATH=\$ROS_PACKAGE_PATH:/root/amrl_msgs" >> ~/.bashrc \
    && echo "export ROS_PACKAGE_PATH=\$ROS_PACKAGE_PATH:/root/amrl_msgs" >> ~/.profile

# copy the entrypoint into the image
COPY ./entrypoint.sh /entrypoint.sh
# run this script on startup
ENTRYPOINT /entrypoint.sh
# ROS2 Humble Docker Image
This repo contains the Docker files to set up a an environment with ROS2 Humble in Ubuntu Jammy thorugh a Docker container for ROS2 projects. There are helpful packages included for ROS2 software development and testing. This environment currently only works on devices with Nvidia GPU's.

This template based on this [Docker Workshop](https://github.com/ut-texas-robotics/docker_workshop).

## Installation and Setup
Clone the repo in your desired directory:
```
git clone git@github.com:luisluna01/docker_ros2.git
cd docker_ros2/
```
**Optional:** You can grant the user `root` acess to the X server (the graphical display system) for local connections to display GUI windows (e.g.,running `rviz`)
```
xhost +local:root
```

## Build and Run
Build the Docker image:
```
docker compose build
```

Start a container:
```
docker compose up -d
```

Open a bash terminal in the container:
```
docker exec -ti ros2_c bash
```

## Test
This section explains how to test the ROS2 Humble environment is set up correcly.


Check which distribution of ROS2 is currently installed:
```
printenv | grep ROS_DISTRO # Correct Output: ROS_DISTRO=humble
```

### Test ROS2 Network
Open two bash terminals. In shell #1 run:
```
ros2 run demo_nodes_cpp talker
```

In shell #2 run:
```
ros2 run demo_nodes_cpp listener
```

Congratulations! You now have a complete ROS2 Environment to develop projects with.

## Exit and Remove Container
To stop and remove the Docker container run:
> **Note**: Ensure you are not in a container shell. To exit one press `CTL+D` or type `exit`.
```
docker compose down
```

**Optional**: If you want to remove all data related to this Docker project run:
```
docker compose down --rmi all --volumes --remove-orphans
```
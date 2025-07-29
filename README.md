# ROS 2 Node Docker Compose Service 

This repository contains a docker compose project to define a singular
ROS2 node running as a docker compose service.

## Getting Started

### Prerequisites
This requires the following tools reinstalled and configured before proceeding:
- Docker
- GNU Make

### Building the Docker service/image

1. Clone the repository and submodules:
```bash
git clone <repo uri>
cd ros2_service
git submodule update --init
```

2. **Build the Docker image** using the provided `Dockerfile`:
```bash
make build
```

### Running the service
1. To run the docker compose service use the provided make target:
```bash
make start 
```
and to stop it:
```bash
make stop
```


### Configuring the service
The entrypoint or service can be defined in the docker compose. To change the
service/node entrypoint modify the `docker-compose.yaml` and change the
following lines:
```yaml
  - ROS_PACKAGE_NAME=<desired package>
  - ROS_NODE_NAME=<desired node name>
```

### Adding custom ROS2 packages
To add a custom package add it as a submodule to the `ros2_ws/src` directory:
```bash
cd ros2_ws/src && git submodule add <repository uri>
```

You may need to modify the `Dockerfile` to add specific system dependencies to
build your node.

### Adding system dependencies via APT and Python3 PIP
System dependencies defined in files with the name: 
[requirements.system](ros2_ws/src/hello_world/requirements.system)
for APT.

To add dependencies create a file called `requirements.system` in your package
and add the dependencies to the file, one per line.
For an example see: [ros2_ws/src/hello_world/requirements.system](ros2_ws/src/hello_world/requirements.system)

System dependencies defined in files with the name: 
[requirements.pip3](ros2_ws/src/hello_world/requirements.pip3)
for Python3 PIP.

To add dependencies create a file called `requirements.pip3` in your package
and add the dependencies to the file, one per line.
For an example see: [ros2_ws/src/hello_world/requirements.pip3](ros2_ws/src/hello_world/requirements.pip3)

All APT and Python3 PIP dependencies will be automatically installed with `make build`




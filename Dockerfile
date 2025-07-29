ARG ROS_DISTRO=jazzy
ARG USER=rosuser
ARG UID
ARG GID

FROM ros:${ROS_DISTRO} AS ros_service_runner

ARG ROS_DISTRO
ARG USER
ARG UID
ARG GID

RUN apt-get update && apt-get install -y bash gettext python3 python3-pip python3-colcon-common-extensions

COPY ros2_ws /ros2_ws


ENV DEBIAN_FRONTEND=noninteractive
RUN --mount=target=/var/lib/apt/lists,type=cache,sharing=locked \
    --mount=target=/var/cache/apt,type=cache,sharing=locked \
    rm -f /etc/apt/apt.conf.d/docker-clean && \
    apt-get update && \
    requirements=$(find . -type f -name 'requirements.system*' -exec cat {} + | sed '/^#/d' | sed '/^$/d' | envsubst) && \
    if [ -n "$requirements" ]; then apt-get install --no-install-recommends -y $requirements; fi

RUN --mount=target=/root/.cache/pip,type=cache,sharing=locked \
    requirements=$(find . -type f -name 'requirements.pip3' -exec cat {} + | sed '/^#/d' | sed '/^$/d' | envsubst) && \
    if [ -n "$requirements" ]; then python3 -m pip install --break-system-packages --no-cache-dir $requirements; fi



RUN userdel --remove ubuntu || true
RUN rm -rf /home/ubuntu || true
RUN useradd --create-home ${USER}
RUN cat /etc/passwd && usermod -u ${UID} ${USER} && groupmod -g ${GID} ${USER}
RUN chown -R ${UID}:${GID} $$HOME | true

RUN mkdir -p /ros2_ws/log
RUN chown -R ${UID}:${GID} /ros2_ws | true

WORKDIR /ros2_ws
SHELL ["/bin/bash", "-c"]

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

USER ${USER}
RUN echo 'export ROS_LOG_DIR=/ros2_ws/log' >> /home/${USER}/.bashrc

WORKDIR /ros2_ws
RUN bash -c 'source /opt/ros/${ROS_DISTRO}/setup.bash && colcon build --parallel-workers $(nproc)'

USER ${USER}
ENTRYPOINT ["bash", "-c", "/usr/bin/bash /entrypoint.sh"]



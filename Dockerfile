ARG ubuntuImage="nytimes/blender:3.1-cpu-ubuntu18.04"
FROM $ubuntuImage

# Fixes a Gradle crash while building for Android on Unity 2019 when there are accented characters in environment variables
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

# Set frontend to Noninteractive in Debian configuration.
# https://github.com/phusion/baseimage-docker/issues/58#issuecomment-47995343
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

# Global dependencies
RUN apt-get -q update \
 && apt-get -q install -y --no-install-recommends apt-utils \
 && apt-get -q install -y --no-install-recommends --allow-downgrades \
 ca-certificates \
 libasound2 \
 libc6-dev \
 libcap2 \
 libgconf-2-4 \
 libglu1 \
 libgtk-3-0 \
 libncurses5 \
 libnotify4 \
 libnss3 \
 libxtst6 \
 libxss1 \
 cpio \
 lsb-release \
 python \
 python-setuptools \
 xvfb \
 xz-utils \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# Toolbox
RUN apt-get -q update \
 && apt-get -q install -y --no-install-recommends --allow-downgrades \
 atop \
 curl \
 git \
 git-lfs \
 jq \
 openssh-client \
 wget \
 && git lfs install --system --skip-repo \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# libstdc++6 upgrade
RUN apt-get -q update \
 && apt-get -q install -y --no-install-recommends software-properties-common \
 && add-apt-repository -y ppa:ubuntu-toolchain-r/test \
 && apt-get -q install -y --only-upgrade libstdc++6 \
 && add-apt-repository -y --remove ppa:ubuntu-toolchain-r/test \
 && apt-get -q remove -y --auto-remove software-properties-common \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# Disable default sound card, which removes ALSA warnings
RUN /bin/echo -e 'pcm.!default {\n\
    type plug\n\
    slave.pcm "null"\n\
}' > /etc/asound.conf

# Support forward compatibility for unity activation
RUN echo "576562626572264761624c65526f7578" > /etc/machine-id && mkdir -p /var/lib/dbus/ && ln -sf /etc/machine-id /var/lib/dbus/machine-id

# Used by Unity editor in "modules.json" and must not end with a slash.
ENV UNITY_PATH="/opt/unity"
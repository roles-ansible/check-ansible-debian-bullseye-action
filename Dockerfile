FROM debian:stable

LABEL "maintainer"="L3D <l3d@c3woc.de>"
LABEL "repository"="https://github.com/roles-ansible/check-ansible-debian-stable-action.git"
LABEL "homepage"="https://github.com/roles-ansible/check-ansible-debian-stable-action"

LABEL "com.github.actions.name"="check-ansible-debian-stable"
LABEL "com.github.actions.description"="Check ansible with Debian stable"
LABEL "com.github.actions.icon"="activity"
LABEL "com.github.actions.color"="gray-dark"

RUN apt-get update -y && apt-get install -y --no-install-recommends \
    software-properties-common \
    build-essential \
    libffi-dev \
    libssl-dev \
    python3-dev \
    python3-pip \
    git \
    systemd \
 && rm -rf /var/lib/apt/lists/*

RUN pip3 install --upgrade setuptools && pip3 install ansible

RUN mkdir -p /etc/ansible && echo "[local]\nlocalhost ansible_connection=local" > /etc/ansible/hosts

ADD ansible-docker.sh /ansible-docker.sh
ENTRYPOINT ["/ansible-docker.sh"]

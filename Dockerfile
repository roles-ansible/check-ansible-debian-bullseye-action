FROM debian:stable

LABEL "maintainer"="L3D <l3d@c3woc.de>"
LABEL "repository"="https://github.com/roles-ansible/check-ansible-debian-stable-action.git"
LABEL "homepage"="https://github.com/roles-ansible/check-ansible-debian-stable-action"

LABEL "com.github.actions.name"="check-ansible-debian-stable"
LABEL "com.github.actions.description"="Check ansible role with Debian stable"
LABEL "com.github.actions.icon"="aperture"
LABEL "com.github.actions.color"="green"

RUN apt-get update -y && apt-get install -y \
    software-properties-common \
    build-essential \
    libffi-dev \
    libssl-dev \
    python3-dev \
    python3-pip \
    git \
    tee \
    systemd

RUN pip3 install --upgrade setuptools && pip3 install ansible

RUN ansible --version

RUN mkdir -p /etc/ansible && echo -e "[local]\nlocalhost ansible_connection=local ansible_python_interpreter='/usr/bin/python3'" | tee -a /etc/ansible/hosts

ADD ansible-docker.sh /ansible-docker.sh
ENTRYPOINT ["/ansible-docker.sh"]

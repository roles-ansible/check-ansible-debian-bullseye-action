#! /usr/bin/env bash

set -Eeuo pipefail
set -x

# Generates client.
# env:
#   [required] TARGETS : Path to your ansible role or to a playbook .yml file you want to be tested.
#                       (e.g, './' or 'roles/my_role/' for roles or 'site.yml' for playbooks)

ansible::prepare() {
  : "${TARGETS?No targets to check. Nothing to do.}"
  : "${GITHUB_WORKSPACE?GITHUB_WORKSPACE has to be set. Did you use the actions/checkout action?}"
  pushd ${GITHUB_WORKSPACE}

  # generate ansible.cfg
  echo -e """
[defaults]
inventory = host.ini
nocows = True
host_key_checking = False
forks = 20
fact_caching = jsonfile
fact_caching_connection = $HOME/facts
fact_caching_timeout = 7200
stdout_callback = yaml
ansible_python_interpreter=/usr/bin/python3
ansible_connection=local
""" | tee ansible.cfg

  # create host list
  echo -e "[local]\nlocalhost ansible_python_interpreter=/usr/bin/python3 ansible_connection=local" | tee host.ini
}
ansible::test::role() {
  : "${TARGETS?No targets to check. Nothing to do.}"
  : "${GITHUB_WORKSPACE?GITHUB_WORKSPACE has to be set. Did you use the actions/checkout action?}"
  pushd ${GITHUB_WORKSPACE}

  # generate playbook to be executed
  echo -e """---
  - name: test a ansible role
    hosts: localhost
    tags: default
    roles:
      - \""${TARGETS}"\"
    """ | tee -a deploy.yml

  # execute playbook
  ansible-playbook  --connection=local --inventory host.ini  --limit localhost deploy.yml
}
ansible::test::playbook() {
  : "${TARGETS?No targets to check. Nothing to do.}"
  : "${GITHUB_WORKSPACE?GITHUB_WORKSPACE has to be set. Did you use the actions/checkout action?}"
  pushd ${GITHUB_WORKSPACE}

  # execute playbook
  ansible-playbook  --connection=local  --inventory host.ini --limit localhost ${TARGETS} 
}


if [ "$0" = "$BASH_SOURCE" ] ; then
  >&2 echo -E "\nRunning Ansible debian check...\n"
  ansible::prepare
  if [[ "${TARGETS}" == *.yml ]]
  then
      echo -E "\nansible playbook detected\ninitialize playbook testing...\n"
      ansible::test::playbook
  else
      echo -E "\nno playbook detected\ninitialize role testing...\n"
      ansible::test::role
  fi
fi

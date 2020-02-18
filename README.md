[![Github Marketplace](https://raw.githubusercontent.com/roles-ansible/check-ansible-debian-stable-action/master/.github/marketplace.svg?sanitize=true)](https://github.com/marketplace/actions/check-ansible-debian-stable)
[![MIT License](https://raw.githubusercontent.com/roles-ansible/check-ansible-debian-stable-action/master/.github/license.svg?sanitize=true)](https://github.com/roles-ansible/check-ansible-debian-stable-action/blob/master/LICENSE)

 Check Ansible Debian stable
=======================
This action allows you to test your ansible role in a Docker Container with ``debian:stable``.

## Usage
To use the action simply create an `ansible-debian-stable.yml` (or choose custom `*.yml` name) in the `.github/workflows/` directory.

For example:

```yaml
name: Ansible check debian:stable  # feel free to pick your own name

on: [push, pull_request]

jobs:
  build:

    runs-on: ubuntu-latest

    steps:
    # Important: This sets up your GITHUB_WORKSPACE environment variable
    - uses: actions/checkout@v2

    - name: ansible check with debian:stable
      # replace "master" with any valid ref
      uses: roles-ansible/check-ansible-debian-stable-action@master
      with:
        # [required]
        # Paths to your ansible role you want to test
        # For Example:
        # targets: "role/my_role/"
        targets: "./"

```

Alternatively, you can run the ansible check only on certain branches:

```yaml

on:
  push:
    branches:
    - stable
    - release/v*
```

or on various [events](https://help.github.com/en/articles/events-that-trigger-workflows)

<br>

 Contributing
-------------
If you are missing a feature or see a bug. Please report it. Or - if you like - open a pull-request.

 License
----------
The Dockerfile and associated scripts and documentation in this project are released under the [MIT License](LICENSE).

 Credits
--------------
The initial GitHub action has been created by [Stefan Stölzle](/stoe) at
[stoe/actions](https://github.com/stoe/actions).<br/>
It was used by ansible for lint checks. at [ansible/ansible-lint-action](https://github.com/ansible/ansible-lint-action.git)<br/>
It was modified from L3D to check ansible roles.

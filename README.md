### Requirements

To be able to use bash scripts and Ansible common roles in other projects, run:

`./scripts/extendScripsAndAnsibleRolesPaths.sh`

from the `ansible-commons-roles` folder

Make sure your Ansible projects have `ansible.cfg` file `~/.ansible/common_roles` included:
```yaml
[defaults]
roles_path=roles:~/.ansible/common_roles
```

### Features:

- [Change the current folder to the Ansible directory](#change-the-current-folder-to-the-ansible-directory)


#### Change the current folder to the Ansible directory

Add into the bash script:

1. When project does not exist yet:

```bash
#!/usr/bin/env bash

source ansible.commons.sh

# get artifact id as $artifact_id variable

changePwd2AnsibleScriptsFolder $artifact_id

# pass app_basedir to Ansible:
ansible-playbook \
  -v \
  -i inventories/local \
  --extra-vars "${extra_vars} app_basedir=$app_basedir" \
  playbooks/somePlaybook.yaml
```

2. When the project already exists, and you extend its functionality:
```bash
#!/usr/bin/env bash

source ansible.commons.sh

changePwd2AnsibleScriptsFolder

# pass app_basedir to Ansible:
ansible-playbook \
  -v \
  -i inventories/local \
  --extra-vars "${extra_vars} app_basedir=$app_basedir" \
  playbooks/somePlaybook.yaml
```


#### fds
### Requirements

To be able to use bash scripts and Ansible common roles in other projects, run:

`./scripts/extendScripsAndAnsibleRolesPaths.sh`

from the `ansible-commons-roles` folder

Make sure your Ansible projects have `ansible.cfg` file `~/.ansible/common_roles` included:
```yaml
[defaults]
roles_path=roles:~/.ansible/common_roles
```

For each change in commons role, to make them visible run:

`./scripts/extendScripsAndAnsibleRolesPaths.sh`

### Features:

- [Change the current folder to the Ansible directory](#change-the-current-folder-to-the-ansible-directory)
- [Insert one template after another](#to-insert-one-template-after-another)
- [Insert text after another](#to-insert-text-after-another)
- [Load all maven properties into the project](#load-all-maven-properties-into-the-project)
- [Generate the whole Maven module with java and non-java templates](roles/gen_java_class_from_path/README.md)
- [Generate Java class from a template](#to-generate-java-class-from-a-template-and-put-it-into-the-correct-package-path)
- [Possible issues](#issues)


#### Change the current folder to the Ansible directory

Add into the bash script:

1. When project does not exist yet extract and pass `$artifact_id` to the `changePwd2AnsibleScriptsFolder`:

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

Note: you could run an Ansible role without a playbook file:
```bash
#running role directly without playbook
ansible localhost -v \
  --module-name include_role \
  --args name=some_role_name \
  --extra-vars "${extra_vars} app_basedir=$app_basedir"
```

#### To insert one template after another

```yaml
- name: "Update the root `pom.xml` file with git url"
  include_role:
    name: insert_template_after_another
  with_items:
    - path: "{{ app_basedir }}/pom.xml"
      insert_after_template: "{{ role_path }}/templates/insert_after_template.j2"
      insert_template: "{{ role_path }}/templates/insert_template.j2"
  loop_control:
    loop_var: cs_itaa_tmpl_item
```

#### To insert text after another

The following examples inserts after `</apache-commons-logging.version>` the line
with a line break, and
the 2nd line, which starts with 4 spaces and ends with
`<jackson.version>{{ jackson_version }}</jackson.version>`

```yaml
- name: "Update the deps `pom.xml` with jackson version"
  include_role:
     name: insert_text_after_another
  with_items:
     - path: "{{ app_basedir }}/deps/pom.xml"
       insert_after: |
          </apache-commons-logging.version>
       insert_text: |4
               <jackson.version>{{ jackson_version }}</jackson.version>
  loop_control:
    loop_var: cs_itaa_txt_item
```

#### Load all maven properties into the project

```yaml
- name: "Loading projects properties"
  include_role:
    name: load_maven_properties
```

#### To generate Java class from a template and put it into the correct package path

In the Java template specify package path via `{{ group_id }}` variable:
```j2
package {{ group_id }}.app;
```

In the Ansible script use `{{ group_id_path }}` when specify the destination for java:
```yaml
- name: "Generate java classes of `domain` module"
  include_role:
    name: gen_java_class_from_template
  with_items:
    - src: domain/src/main/java/ApplicationService.java.j2
      dst: "{{ app_basedir }}/domain/src/main/java/{{ group_id_path }}/app/ApplicationService.java"
    - src: domain/src/main/resources/META-INF/beans.xml
      dst: "{{ app_basedir }}/domain/src/main/resources/META-INF/beans.xml"
  loop_control:
    loop_var: cs_gjcft_item
```
Note how the `app` is used in the java class as part of the package name and in the Ansible script as part of the path.
For `{{ group_id }}.x.y.z` package, the path should look like: `{{ group_id_path }}/x/y/z`.

**Note** this role suites not only for Java classes. 
It is very usefull with all file types, when the destination might not exist when you run it.
The role automatically creates all required folders according to the `dst` path.

### Issues:

- You get an error: `ERROR! the role 'someRoleName' was not found in ...`

   Make sure that:
   
   1. `~/.ansible/common_roles` is included in the error message in the list of paths for search. 
   To make the folder searchable it must be included in the `roles_path`:
   ```yaml
   roles_path=roles:~/.ansible/common_roles
   ```
   
   2. Commons roles are up-to-date. If you added a new common role or renamed existing, 
      run: `./scripts/extendScripsAndAnsibleRolesPaths.sh`

- You get an error: `"msg": "The target XML source '.../pom.xml' does not exist."`
  
   You run the script not within the project base directory. That is the folder with the parent `pom.xml` in it.

- You get an error: `"msg": "Xpath /ns:project/ns:organization/ns:url does not reference a node!"`
  
  You run the script not within the project base directory. That is the folder with the parent `pom.xml` in it. 
  But you run the script from the folder with `pom.xml`, which is not parent `pom.xml`
  
- You get ant error, related to `ansible.commons.sh` script. 
  
  Make sure you installed commons ansible roles and scripts. See requirements above.

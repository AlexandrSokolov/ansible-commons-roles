Usage:

```
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
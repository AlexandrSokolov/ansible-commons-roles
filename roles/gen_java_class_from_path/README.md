### This role handles both java and non-java templates

This role handles each java templates, by generating the destination path.
The java template must end with: `.java.j2`
Its first line contains: `package {{ group_id }}.some.package;`

A real path for java class is constructed from the package definition.
So the location of java templates play no role to construct a path. 
Only the package definition is responsible for it.

Java test templates, must end wither with `Test.java.j2` or with `IT.java.j2`.

For other types of template, which do not end with '.java.j2', 
the destination path is constructed according to its relative path 
in the `cs_gjcfp_templates.src` folder.

#### Dependency:
To handle templates correctly, some data must be extracted from parent pom.xml with:
```yaml
- name: "Loading projects properties"
  include_role:
    name: load_maven_properties
```

#### Usage:
```yaml
- name: "Generate sources of `rest_api` and `rest_web` modules"
  include_role:
    name: gen_java_class_from_path
  with_items:
    - src: "{{ role_path }}/templates/rest_api"
      dst_src_path: "{{ app_basedir }}/rest_api"
    - src: "{{ role_path }}/templates/rest_web"
      dst_src_path: "{{ app_basedir }}/rest_web"
  loop_control:
    loop_var: cs_gjcfp_templates
```
Note: to make generation correct, follow the next folder structure. Assume the module has `some_module` name:
```
├── some_module
│    └── templates
│          └── some_module
│               └── src
│                    ├── main
│                    ├── test
│                    ├── pom.xml.j2
│                    └── README.md.j2
```
Then for that structure, you have to define an ansible task as:
```yaml
- name: "Generate sources of `some_module` modules"
  include_role:
    name: gen_java_class_from_path
  with_items:
    - src: "{{ role_path }}/templates/some_module"
      dst_src_path: "{{ app_basedir }}/some_module"
  loop_control:
    loop_var: cs_gjcfp_templates
```
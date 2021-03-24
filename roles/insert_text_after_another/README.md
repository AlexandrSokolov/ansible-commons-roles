Usage:

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
```
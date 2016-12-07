{%- from "shibboleth/map.jinja" import server with context %}

{%- if server.enabled %}

include:
- apache

/etc/shibboleth/shibboleth2.xml:
  file.managed:
  - source: salt://shibboleth/files/shibboleth2.xml
  - template: jinja
  - require:
    - pkg: apache_packages
  - watch_in:
    - service: apache_service
    - service: shibboleth_service

/etc/shibboleth/attribute-map.xml:
  file.managed:
  - source: salt://shibboleth/files/attribute-map.xml
  - template: jinja
  - require:
    - pkg: apache_packages
  - watch_in:
    - service: apache_service
    - service: shibboleth_service

shibboleth_service:
  service.running:
    - enable: true
    - name: shibd

{%- endif %}

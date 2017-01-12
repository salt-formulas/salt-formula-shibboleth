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

{%- if server.idp_certificate is defined %}
/etc/shibboleth/fedsigner.pem:
  file.managed:
  - contents: {{ server.idp_certificate | yaml_encode }}
  - require:
    - pkg: apache_packages
  - watch_in:
    - service: apache_service
    - service: shibboleth_service
{%- endif %}

{%- if server.certificate is defined and server.key is defined %}
/etc/shibboleth/sp-key.pem:
  file.managed:
  - contents: {{ server.key | yaml_encode }}
  - mode: 600
  - require:
    - pkg: apache_packages
  - watch_in:
    - service: apache_service
    - service: shibboleth_service

/etc/shibboleth/sp-cert.pem:
  file.managed:
  - contents: {{ server.certificate | yaml_encode }}
  - require:
    - pkg: apache_packages
  - watch_in:
    - service: apache_service
    - service: shibboleth_service
{%- endif %}

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

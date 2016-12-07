{%- if pillar.shibboleth is defined %}
include:
{%- if pillar.shibboleth.server is defined %}
- shibboleth.server
{%- endif %}
{%- endif %}

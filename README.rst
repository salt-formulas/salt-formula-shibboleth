=======================
salt-formula-shibboleth
=======================

Shibboleth is among the world's most widely deployed federated identity solutions, connecting users to applications both within and between organizations.

Sample pillars
==============

.. code-block:: yaml

  shibboleth:
    server:
      enabled: true
      keystone_protocol: http
      keystone_public_address: ${_param:proxy_vip_address_public}
      keystone_port: 5000
      idp_url: "https://saml.example.com/oam/fed"
      idp_metadata_url: "https://saml.example.com/oamfed/idp/metadata"
      attributes:
      - name: test
        id: test
        name_format: urn:oasis:names:tc:SAML:2.0:attrname-format:basic
      key: |
        -----BEGIN PRIVATE KEY-----
        MIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQDmM1NIxgQ3Y70Q
        GXoFQQnJ7nliaRtJR2xHAW47InyALQ+M3/VCtdFnNI0d2CHoytQ6mVg6BzOtdvT2
        ocEl0+LNkskSZsc6Nh59XooTQncL5PA7hXmo/nxCEgURH4oika5CC14K4hagwZca
        CQZvW1m9KwfVaNc0Va0KepH2lGI+VdxyZgRMifTMl9qDLYr++ftyFTNn5uit0Yh8
        9QFU4HLVvT0rHSQUTcFbvYE=
        -----END PRIVATE KEY-----
      certificate: |
        -----BEGIN CERTIFICATE-----
        MIIDDzCCAfegAwIBAgIJAOvxYAMLVkHZMA0GCSqGSIb3DQEBBQUAMCMxITAfBgNV
        BAMTGGN0bC0wMS5qcGUyLmppb2Nsb3VkLmNvbTAeFw0xNzAxMTIxMDIwMTRaFw0y
        k3u0PIEqysz9sOpmuSmlY4FKRobYQ3viviTIMTTuqjoCAFKIApI3tZWOqj+zShje
        Xr4ue39/lvQLj2jXV+Q2TOovQA==
        -----END CERTIFICATE-----
      idp_certificate: |
        -----BEGIN CERTIFICATE-----
        BAMTGGN0bC0wMS5qcGUyLmppb2Nsb3VkLmNvbTAeFw0xNzAxMTIxMDIwMTRaFw0y
        CcnueWJpG0lHbEcBbjsifIAtD4zf9UK10Wc0jR3YIejK1DqZWDoHM6129PZ8kx5k
        aN5DvAdir7oYCpHwD5/WvHahUgsrtcz9s+pzRfiStvICVwqCsGquThZHe8YAgGpZ
        04UU/56ncPbsHf5asS3DvfVGw==
        -----END CERTIFICATE-----


Shibboleth through HTTP proxy
==============
Sometimes there is needed to connect to IdP through HTTP proxy. This has to be done via adding TransportOption to MetadataProvider in Shibboleth2.xml configuration file.

.. code-block:: yaml

  shibboleth:
    server:
      enabled: true
      proxy: http://10.10.10.12:8888
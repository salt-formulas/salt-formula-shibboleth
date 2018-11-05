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
      app:
        entity_id: http://${_param:proxy_vip_address_public}:5000
        signing: "false"
        encryption: "false"
      idp_url: "https://saml.example.com/oam/fed"
      idp_metadata_url: "https://saml.example.com/oamfed/idp/metadata"
      attributes:
      - name: test
        id: test
        name_format: urn:oasis:names:tc:SAML:2.0:attrname-format:basic
      - name: test1
        id: test1
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


Shibboleth with Transaction logging
==============

.. code-block:: yaml

  shibboleth:
    server:
      enabled: true
      logging:
        message_decoder: DEBUG
      outofprocess:
        tranlogformat: "%u|%a|%s|%SP|%IDP|%t|%b|%ac|%attr|%E|%e|%S|%SS|%SM|%URI|%URL|%UA|%app|%p|%n|%D|%d|%I|%II"


Override IdP metadata from file
==============
Sometimes the metadata is not publicly aviailable from IPD. You can define the metadata in pillar. In this case the idp_metadata_url parameter will be ignored.

.. code-block:: yaml

  shibboleth:
    server:
      idp_metadata_file: |
        <?xml version="1.0" encoding="UTF-8" standalone="yes"?>
        <EntityDescriptor xmlns:xsi="https://www.w3.org/2001/XMLSchema-instance" xmlns="urn:oasis:names:tc:SAML:2.0:metadata"
        entityID="idp_url">
        <IDPSSODescriptor
        WantAuthnRequestsSigned="false"
        protocolSupportEnumeration="urn:oasis:names:tc:SAML:2.0:protocol">
        <KeyDescriptor use="signing">
        <ds:KeyInfo xmlns:ds="http://www.w3.org/2000/09/xmldsig#">
        <ds:X509Data>
        <ds:X509Certificate>MIIEADi........==</ds:X509Certificate>
        </ds:X509Data>
        </ds:KeyInfo>
        </KeyDescriptor>
        <KeyDescriptor use="signing">
        <ds:KeyInfo xmlns:ds="http://www.w3.org/2000/09/xmldsig#">
        <ds:X509Data>
        <ds:X509Certificate>MIIEADi........==</ds:X509Certificate>
        </ds:X509Data>
        </ds:KeyInfo>
        </KeyDescriptor>
        <!-- Supported Name Identifier Formats -->
        <NameIDFormat>urn:oasis:names:tc:SAML:2.0:nameid-format:transient</NameIDFormat>
        <!-- AuthenticationRequest Consumer endpoint -->
        <SingleSignOnService
        Binding="urn:oasis:names:tc:SAML:2.0:bindings:HTTP-POST"
        Location="https://IDP_URL/SAMLLogin"
        />
        </IDPSSODescriptor>
        </EntityDescriptor>


Shibboleth session control
==============
Sometimes there is needed to tune session settings for the application. This has to be done via setting sessions variables Shibboleth2.xml configuration file.

.. code-block:: yaml

  shibboleth:
    server:
      sessions:
        lifetime: 28800
        timeout: 3600
        relaystate: "ss:mem"
        checkaddress: "false"
        handlerssl: "false"
        cookieprops: "http"


Shibboleth attributeresolver/regex plugins support
==============
Sometimes there is needed to set add new attribute by extracting some information from other attributes.  This has to be done loading the plugin and a adding attributeresolver with transform type in Shibboleth2.xml configuration file.
See more detail here: https://wiki.shibboleth.net/confluence/display/SHIB2/NativeSPAttributeResolver#NativeSPAttributeResolver-TransformAttributeResolver(Version2.5andAbove)

.. code-block:: yaml

  shibboleth:
    server:
      outofprocess:
        extensions:
          library:
            plugin1:
               path: plugins.so
               fatal: "true"
      attributeresolver:
        transform:
          Email:
            mantch1:
              match: "@.*$"
              destination_name: "User-identifier"
              destination: "$1"
            mantch2:
              match: "@.*$"
              destination: "$2"
Shibboleth shared session
==============
Sometimes there is needed to set shibd on each controller where keystone is running. To make sure sessions are accessible and shared between all of them you need to setup shared storage for sessions
The example below shows you how to setup shared storage using memcached available on controllers:
Please note that sessioncache requires memcached with bitmap set to true. Omitting sessioncache element will result in an in-memory plugin identified as id="mem".
https://wiki.shibboleth.net/confluence/display/SHIB2/NativeSPStorageService

.. code-block:: yaml

  shibboleth:
    server:
      outofprocess:
        extensions:
          library:
            plugin1:
              path:  "memcache-store.so"
              fatal: "true"
      storageservice:
        mc:
          type: MEMCACHE
          buildmap: "0"
          sendtimeout: "999999" #optional
          recvtimeout: "999999" #optional
          polltimeout: "1000" #optional
          failtimeout: "5" #optional
          retrytimeout: "30" #optional
          prefix: "SHIBD" #optional
          hosts: "${_param:cluster_node01_address}:11211,${_param:cluster_node02_address}:11211,${_param:cluster_node03_address}:11211
        mc-ctx:
          type: MEMCACHE
          buildmap: "1"
          sendtimeout: "999999" #optional
          recvtimeout: "999999" #optional
          polltimeout: "1000" #optional
          failtimeout: "5" #optional
          retrytimeout: "30" #optional
          prefix: "SHIBD" #optional
          hosts: "${_param:cluster_node01_address}:11211,${_param:cluster_node02_address}:11211,${_param:cluster_node03_address}:11211
      sessioncache:
        type: "StorageService"
        cachetimeout: "900" #optional
        storageservice: "mc-ctx"
        storageservicelite: "mc"
      replaycache:
        storageservice: "mc"
      replaycache:
        storageservice: "mc"
        artifactTTL: "180"  #optional

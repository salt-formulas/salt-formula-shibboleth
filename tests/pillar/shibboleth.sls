shibboleth:
  server:
    enabled: true
    app:
      entity_id: http://${_param:proxy_vip_address_public}:5000
      signing: false
      encryption: false
    idp_url: "https://saml.example.com/oam/fed"
    idp_metadata_url: "https://saml.example.com/oamfed/idp/metadata"
    attributes:
    - name: test
      id: test
      name_format: urn:oasis:names:tc:SAML:2.0:attrname-format:basic
    - name: test1
      id: test1
    logging:
      message_decoder: DEBUG
    idp_metadata_file: |
      <?xml version="1.0" encoding="UTF-8" standalone="yes"?>
      <EntityDescriptor xmlns:xsi="https://www.w3.org/2001/XMLSchema-instance" xmlns="urn:oasis:names:tc:SAML:2.0:metadata"
      entityID="idp_url">
      <IDPSSODescriptor
      </IDPSSODescriptor>
      </EntityDescriptor>
    sessions:
      lifetime: 28800
      timeout: 3600
      relaystate: "ss:mem"
      checkaddress: "false"
      handlerssl: "false"
      cookieprops: "http"
    outofprocess:
      tran_log_format: "%u|%a|%s|%SP|%IDP|%t|%b|%ac|%attr|%E|%e|%S|%SS|%SM|%URI|%URL|%UA|%app|%p|%n|%D|%d|%I|%II"
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
        hosts: "127.0.0.1:11211"
      mc-ctx:
        type: MEMCACHE
        buildmap: "1"
        sendtimeout: "999999" #optional
        recvtimeout: "999999" #optional
        polltimeout: "1000" #optional
        failtimeout: "5" #optional
        retrytimeout: "30" #optional
        prefix: "SHIBD" #optional
        hosts: "127.0.0.1:11211"
    sessioncache:
      type: "StorageService"
      cachetimeout: "900" #optional
      storageservice: "mc-ctx"
      storageservicelite: "mc"
    replaycache:
      storageservice: "mc"
      artifactTTL: "180"  #optional
    artifactmap:
      storageservice: "mc"
      artifactTTL: "180"  #optional
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
apache:
  server:
    enabled: true
    default_mpm: event
    site:
      keystone:
        enabled: true
        type: keystone
        name: wsgi
        host:
          name: test
    pkgs:
      - apache2
      - libapache2-mod-shib2
    modules:
      - wsgi
      - shib2

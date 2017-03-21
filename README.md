# docker-mongo-es
Docker based wrapper for [mongo connector](https://github.com/10gen-labs/mongo-connector) to send data to elasticsearch.

## Issues
[https://github.com/yisoft/docker-mongo-es/issues](https://github.com/yisoft/docker-mongo-es/issues)

## Requirements
- Docker 1.6.2+
- MongoDB Replica Set (1 or more nodes)
- Admin access to replicaset
- ElasticSearch Instance

## Running
```
docker run --rm -it -e MONGO_URL=172.17.42.1:27017 \
                    -e ES_URL=172.17.42.1:9200 \ 
                    totem/docker-mongo-es
```
 
## Environment Variables

### MONGO_URL
Specifies the mongo replicaset url. (e.g.: 172.17.42.1:27017)

### ES_URL
Specified the elastic search url (e.g.: 172.17.42.1:9200)

### MONGO_USERNAME
Admin username for mongodb. If blank, no credentials are used. (Defaults to blank)

### MONGO_PASSWORD
Admin password for mongodb.(Default to blank)

### MONGO_INCLUDES
List of database.collection separated by comma that needs to be included for indexing. e.g.: ```totem.events,yisoft.*``` to 
include database collection events from totem database, and all database collections from yisoft database.

more about wildcard ```*``` see [mongo-connector wiki](https://github.com/10gen-labs/mongo-connector/wiki/Configuration-Options)

### CONFIG_LOCATION
Optional config file location. (Defaults to blank). e.g.:  file:///tmp/config.yml  or https://my-config-server/config.yml.
Example config file:  
```
defaults:
  index-defaults: &index-defaults
    mappings:
      _default_:
        _all:
          enabled: true
        dynamic_templates:
          - string_fields:
              mapping:
                index: not_analyzed
                type: string
              match: '*'
              match_mapping_type: string
es:
  indexes:
    totem:
      <<: *index-defaults
mongo-connector:
  logging:
    type: stream
```

Note:  List of complete mongo-connector settings can be found in [mongo-connector wiki](https://github.com/10gen-labs/mongo-connector/wiki/Configuration-Options)

### LOG_VERBOSITY
Verbosity for logging (between 0 - 3,  where 0 is ERROR,  3 is DEBUG)
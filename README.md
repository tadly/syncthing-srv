# syncthing-srv
A alpine linux based syncthing relay and discovery server.

## Usage
```sh
docker create \
  --name=syncthing-srv \
  -v *host path to relay data*:/strelaysrv \
  -v *host path to discovery data*:/stdiscosrv \
  -e RELAY_ARGS="" \
  -e DISCOVER_ARGS="" \
  -p 22067:22067 8443:8443 \
  tadly/syncthing-srv
```

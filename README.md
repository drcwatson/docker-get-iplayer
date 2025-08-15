Docker container for running the get_iplayer script: https://github.com/get-iplayer/get_iplayer

## Configuration and output

It is recommended to mount a volume into the container as /data. This will be used by the script to cache the index and store any output as follows:
```
/data/config - used for caching
/data/output - used for storing output
```

## Usage

For full instructions please refer to the get_iplayer documentation: https://github.com/get-iplayer/get_iplayer/wiki

```
# View help
docker run -v $(pwd)/data:/data barwell/get-iplayer -h

# Search for 'news'
docker run -v $(pwd)/data:/data barwell/get-iplayer news

# Download programme at index 1234
docker run -v $(pwd)/data:/data barwell/get-iplayer --get 1234

# Download programme with PID b06z12ab
docker run -v $(pwd)/data:/data barwell/get-iplayer --pid b06z12ab

# Download radio programme with PID b06z34cd
docker run -v $(pwd)/data:/data barwell/get-iplayer --type radio --pid b06z34cd

# Download programme from iPlayer website URL
docker run -v $(pwd)/data:/data barwell/get-iplayer --url https://www.bbc.co.uk/iplayer/episode/<id>/<name>
```

## Changes from base

1. Changed to use latest alpine not hardcoded value
2. Changed to get latest get-iplayer at build time
3. Changed to use an iplayer user
4. Hardcoded uid/gid of iplayer user to match personal storage
5. Changed to use data paths from personal storage system
6. Added github action to build docker image and store to repo container registry
7. Scheduled rebuild weekly to get latest iplayer (and other fixes)

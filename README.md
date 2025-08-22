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

# Kubernetes

Creates a CronJob that runs @daily (aka midnight).  The /data mountpoint is mounted from an NFS server (see values.yaml).

If enabled in the values then the PVR management UI is deployed.

## Management UI

The management UI is exposed through a service, by default a LoadBalancer, this should get an IP address exposed by your LoadBalancer system.
The deployment is enabled if webui.enabled is true.

The Web Management PVR is available through the default ingress controller on the host and path specified in the values.

## Ad-Hoc Recording

Ad-Hoc recording is available via the deployment supporting the PVR Management UI.  Run:

```
kubectl exec -t -n iplayer services/get-iplayer -- /app/get_iplayer.sh --get <Search>
```

`--pid` or `--pid-recursive` may also be specified on the command line:

```
kubectl exec -t -n iplayer services/get-iplayer -- /app/get_iplayer.sh --get --pid-recursive <PID>
```


## Deploying

### Pulling Images from GitHub Container Registry (ghcr.io)

To deploy this chart using images from GitHub Container Registry, you need to create a Personal Access Token (PAT) and a Kubernetes image pull secret:

#### 1. Create a GitHub Personal Access Token (PAT)

1. Go to [GitHub Settings > Developer settings > Personal access tokens](https://github.com/settings/tokens).
2. Click "Generate new token" (classic).
3. Give it a name and select the `read:packages` scope and `repo`
4. Copy the token and save it securely.

#### 2. Create the Kubernetes Secret

```sh
read -s PAT # PASTE the copied token in response to this
kubectl create secret docker-registry ghcr \
  --docker-server=ghcr.io \
  --docker-username="$(git config get user.name)" \
  --docker-password=$PAT \
  --docker-email=$(git config get user.email)
```
### Deploy

Deploy with:

```
helm upgrade  --install -n iplayer --create-namespace get-iplayer .
```
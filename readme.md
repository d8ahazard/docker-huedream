# [d8ahazard/docker-huedream](https://github.com/d8ahazard/docker-huedream)

[HueDream](https://github.com/HueDream/HueDream) - A fork of Sonarr to work with movies à la Couchpotato.


[![huedream](https://raw.githubusercontent.com/d8ahazard/docker-templates/master/d8ahazard.io/img/huedream.png)](https://github.com/HueDream/HueDream)

## Supported Architectures

Our images support multiple architectures such as `x86-64`, `arm64` and `armhf`. We utilise the docker manifest for multi-platform awareness. More information is available from docker [here](https://github.com/docker/distribution/blob/master/docs/spec/manifest-v2-2.md#manifest-list) and our announcement [here](https://blog.d8ahazard.io/2019/02/21/the-lsio-pipeline-project/).

Simply pulling `d8ahazard/huedream` should retrieve the correct image for your arch, but you can also pull specific arch images via tags.

The architectures supported by this image are:

| Architecture | Tag |
| :----: | --- |
| x86-64 | amd64-latest |
| arm64 | arm64v8-latest |
| armhf | arm32v7-latest |

## Version Tags

This image provides various versions that are available via tags. `latest` tag usually provides the latest stable version. Others are considered under development and caution must be exercised when using them.

| Tag | Description |
| :----: | --- |
| latest | Stable HueDream releases |
| 5.14 | Stable HueDream releases, but run on Mono 5.14 |
| nightly | Nightly HueDream releases |
| preview | Alpha HueDream releases, unsupported and for development only |

## Usage

Here are some example snippets to help you get started creating a container.

### docker

```
docker create \
  --name=huedream \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=America/Chicago \
  -p 5000:5000 \
  --restart unless-stopped \
  --network=host \
  digitalhigh/huedream
```


### docker-compose

Compatible with docker-compose v2 schemas.

```
---
version: "2"
services:
  huedream:
    image: d8ahazard/huedream
    container_name: huedream
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=America/Chicago
    network_mode: "host"
    restart: unless-stopped
```

## Parameters

Container images are configured using parameters passed at runtime (such as those above). These parameters are separated by a colon and indicate `<external>:<internal>` respectively. For example, `-p 8080:80` would expose port `80` from inside the container to be accessible from the host's IP on port `8080` outside the container.

| Parameter | Function |
| :----: | --- |
| `-e PUID=1000` | for UserID - see below for explanation |
| `-e PGID=1000` | for GroupID - see below for explanation |
| `-e TZ=America/Chicago` | Specify a timezone to use EG America/Chicago, this is required for HueDream |



&nbsp;
## Application Setup

Access the webui at `<your-ip>:5000`, for more information check out [HueDream](https://github.com/HueDream/HueDream).



## Support Info

* Shell access whilst the container is running: `docker exec -it huedream /bin/bash`
* To monitor the logs of the container in realtime: `docker logs -f huedream`
* container version number
  * `docker inspect -f '{{ index .Config.Labels "build_version" }}' huedream`
* image version number
  * `docker inspect -f '{{ index .Config.Labels "build_version" }}' d8ahazard/huedream`

## Updating Info

Most of our images are static, versioned, and require an image update and container recreation to update the app inside. With some exceptions (ie. nextcloud, plex), we do not recommend or support updating apps inside the container. Please consult the [Application Setup](#application-setup) section above to see if it is recommended for the image.

Below are the instructions for updating containers:

### Via Docker Run/Create
* Update the image: `docker pull d8ahazard/huedream`
* Stop the running container: `docker stop huedream`
* Delete the container: `docker rm huedream`
* Recreate a new container with the same docker create parameters as instructed above (if mapped correctly to a host folder, your `/config` folder and settings will be preserved)
* Start the new container: `docker start huedream`
* You can also remove the old dangling images: `docker image prune`

### Via Docker Compose
* Update all images: `docker-compose pull`
  * or update a single image: `docker-compose pull huedream`
* Let compose update all containers as necessary: `docker-compose up -d`
  * or update a single container: `docker-compose up -d huedream`
* You can also remove the old dangling images: `docker image prune`

### Via Watchtower auto-updater (especially useful if you don't remember the original parameters)
* Pull the latest image at its tag and replace it with the same env variables in one run:
  ```
  docker run --rm \
  -v /var/run/docker.sock:/var/run/docker.sock \
  containrrr/watchtower \
  --run-once huedream
  ```

**Note:** We do not endorse the use of Watchtower as a solution to automated updates of existing Docker containers. In fact we generally discourage automated updates. However, this is a useful tool for one-time manual updates of containers where you have forgotten the original parameters. In the long term, we highly recommend using Docker Compose.

* You can also remove the old dangling images: `docker image prune`

## Building locally

If you want to make local modifications to these images for development purposes or just to customize the logic:
```
git clone https://github.com/d8ahazard/docker-huedream.git
cd docker-huedream
docker build \
  --no-cache \
  --pull \
  -t d8ahazard/huedream:latest .
```

The ARM variants can be built on x86_64 hardware using `multiarch/qemu-user-static`
```
docker run --rm --privileged multiarch/qemu-user-static:register --reset
```

Once registered you can define the dockerfile to use with `-f Dockerfile.aarch64`.

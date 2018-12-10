# Sonarr, Radarr, Jackett etc on Synology in Docker

By default the `admin` user is not a member of the `docker` group, in fact, the `docker` group doesn't even exist. And the docker socket is owned by `root:root`.

To correct this do the following:

1. Create a group (it is fine to use the DSM web UI) called `docker`
1. Add your user(s) to the docker group (again the web UI is fine)
1. Run the following command in a terminal:
    ```sh
    sudo chown root:docker /var/run/docker.sock
    ```
1. Update the `docker-compose.yml` file to reference your `PGID` and `PUID`, [find out how to do that here](https://www.linuxserver.io/docs/puid-pgid/)

Now you can use `docker-compose` to start up your containers.

```sh
docker-compose up -d
```

## Useful docker commands

```sh
# connect to shell within docker container
docker exec -i -t ${container_identifier} /bin/bash

# delete ALL docker images
docker rmi $(docker images -a -q) -f

# delete all volumes
docker volume rm $(docker volume ls -q) -f

# delete all cached images
docker system prune -a
```

## Reference

- docker-compose file based on: https://github.com/sebgl/htpc-download-box/blob/master/docker-compose.yml
- Add Jacket as just one indexer in Sonarr and Radarr: https://www.reddit.com/r/PleX/comments/737foz/tip_if_you_use_jackett_for_indexers_you_can_set_a/
- How-to: Deploy OpenVPN on Synology using Docker: https://www.reddit.com/r/synology/comments/74te0y/howto_deploy_openvpn_on_synology_using_docker/

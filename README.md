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

## Setting up your NAS to work with OpenVPN in Docker

Follow the instructions under "Instructions to deploy OpenVPN docker container on Synology" in (this Reddit article)[https://www.reddit.com/r/synology/comments/74te0y/howto_deploy_openvpn_on_synology_using_docker/]. Step 9 is the important one.

Point the scheduled task at `setup-tun.sh` from this repo.

## Notes

### Refreah docker images

```sh
docker-compose down

docker-compose pull

docker-compose up -d --build
```

### Useful docker commands

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

### Add all public trackers to Jackett

1. Open the "Add Indexer" modal
1. Open your browser's dev tools
1. Run the following JavaScript in the dev tools' console:

```js
document.querySelectorAll('#unconfigured-indexer-datatable tbody tr').forEach((row, index) => {
    if (row.cells[2].textContent === 'public') {
        const button = row.cells[4].querySelector('button[title="Add"]');
        button.click();
    }
});
```

### Notify JellyFin of new downloads from Sonarr and Radarr

#### JellyFin API key

1. Open the JellyFin Dashboard
1. Go to API Keys
1. Click on the plus symbol next to the page title
1. Name your new key something like: "Sonarr and Radarr"

#### Update `jellyfin-connect.sh` script

1. Paste the JellyFin API key into `scripts/jellyfin-connect.sh` to replace `JELLYFIN_TOKEN`
1. Replace `JELLYFIN_ADDRESS` with the IP address or domain name of your JellyFin server

#### Set up Sonarr and Radarr

1. In Sonarr and Radarr, go to Settings > Connect and add an new Custom Script.
1. Name your script something like "Refresh JellyFin"
1. Choose what should trigger notifying JellyFin, I chose:
    ```
    On Grab - No
    On Download - Yes
    On Upgrade - Yes
    On Rename - No
    ```
1. In the Path field enter `/scripts/jellyfin-connect.sh`

## Reference

- docker-compose file based on: https://github.com/sebgl/htpc-download-box/blob/master/docker-compose.yml
- Add Jacket as just one indexer in Sonarr and Radarr: https://www.reddit.com/r/PleX/comments/737foz/tip_if_you_use_jackett_for_indexers_you_can_set_a/
- How-to: Deploy OpenVPN on Synology using Docker: https://www.reddit.com/r/synology/comments/74te0y/howto_deploy_openvpn_on_synology_using_docker/
- JellyFin connect script for Sonarr and Radarr v3: https://www.reddit.com/r/jellyfin/comments/g1p8p4/radarrsonnarr_connect_date_added_behavior_for_new/fnjue49/?utm_source=reddit&utm_medium=web2x&context=3

# jellyfin-rffmpeg-server

Official jellyfin docker image with [rffmpeg](https://github.com/joshuaboniface/rffmpeg) included.

The public ssh key is located inside the container at `/config/rffmpeg/.ssh/id_rsa.pub`
The known_hosts file is located inside the container at `/config/rffmpeg/.ssh/known_hosts`

## Setup

Workers must have access to Jellyfin's `/config`, `/cache` and `/transcodes` directories. It's recommended to setup NFS share for this.

### Adding new workers

Copy the public ssh key to the worker:
```bash
docker compose exec -it jellyfin ssh-copy-id -i /config/rffmpeg/.ssh/id_rsa.pub <user>@<host>
```

Add the worker to rffmpeg:
```bash
docker compose exec -it jellyfin rffmpeg add [--weight 1] [--name myfirsthost] <ip address of the host>
```

Check the status of rffmpeg:

```bash
docker compose exec -it jellyfin rffmpeg status
```

### Hardware Acceleration

Enable it normally in the Jellyfin admin panel.

If you want to use Hardware Acceleration all of the workers **must** support the same tech (VAAPI, NVENC, etc.).

**Note**: If the Jellyfin host doesn't support that same Hardware Accel tech then it **can't** be used as a failover, but if you have available workers it will still transcode without problems.
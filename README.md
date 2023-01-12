# jellyfin-rffmpeg

## Unofficial docker image made by including [rffmpeg](https://github.com/joshuaboniface/rffmpeg) in the official Jellyfin docker image.

**Note: this [image](https://github.com/aleksasiriski/jellyfin-rffmpeg/blob/master/Dockerfile#L38) uses `/config/cache` for cache dir by default, instead of the official `/cache`. This allows to use a single volume for stateful data, which can save costs when using Kubernetes in the cloud.**

The public ssh key is located inside the container at `/config/rffmpeg/.ssh/id_rsa.pub`
The known_hosts file is located inside the container at `/config/rffmpeg/.ssh/known_hosts`

## Setup

[Workers](https://github.com/aleksasiriski/rffmpeg-worker) must have access to Jellyfin's `/config/transcodes` and `/config/data/subtitles` directories. It's recommended to setup [NFS share](https://github.com/aleksasiriski/jellyfin-rffmpeg/blob/master/docker-compose.example.yml) for this.

### Adding new workers

Copy the public ssh key to the worker:
```bash
docker compose exec -it jellyfin ssh-copy-id -i /config/rffmpeg/.ssh/id_rsa.pub <probably_root>@<worker_ip_address>
```

Add the worker to rffmpeg:
```bash
docker compose exec -it jellyfin rffmpeg add [--weight 1] [--name first_worker] <worker_ip_address>
```

Check the status of rffmpeg:

```bash
docker compose exec -it jellyfin rffmpeg status
```

### Hardware Acceleration

Enable it normally in the Jellyfin admin panel.

If you want to use Hardware Acceleration all of the workers **must** support the same tech (VAAPI, NVENC, etc.).

**Note**: If the Jellyfin host doesn't support that same Hardware Accel tech then it **can't** be used as a failover, but if you have available workers it will still transcode without problems.

## Kubernetes

Check [this](https://github.com/aleksasiriski/rffmpeg-worker) out!

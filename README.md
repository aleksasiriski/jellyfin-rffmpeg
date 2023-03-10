# jellyfin-rffmpeg

## Unofficial docker image made by including [rffmpeg-go](https://github.com/aleksasiriski/rffmpeg-go) in the official Jellyfin docker image.

### Note: 
* This [image](https://github.com/aleksasiriski/jellyfin-rffmpeg/blob/main/Dockerfile#L27) uses `/config/cache` for cache dir by default, instead of the official `/cache`. This allows to use a single volume for stateful data, which can save costs when using Kubernetes in the cloud.
* The public ssh key is located inside the container at `/config/rffmpeg/.ssh/id_ed25519.pub`
* The known_hosts file is located inside the container at `/config/rffmpeg/.ssh/known_hosts`

## Setup

### Database

#### SQLite

SQLite is already provided and configured, you can start by adding workers.

#### Postgresql

If you want to use this container as a stateless app (currently not possible because Jellyfin itself isn't stateless) set the required fields in `/config/rffmpeg/rffmpeg.yaml` or equivalent env vars that take precedence for Postgresql:

| Name | Default value | Description |
| :---- | :----: | ----: | 
| DATABASE_TYPE | sqlite | Must be 'sqlite' or 'postgres` |
| DATABASE_HOST | localhost | Postgres database host |
| DATABASE_PORT | 5432 | Postgres database port |
| DATABASE_NAME | rffmpeg | Postgres database name |
| DATABASE_USERNAME | postgres | Postgres database username |
| DATABASE_PASSWORD | "" | Postgres database password |

### Workers

Workers must have access to Jellyfin's `/config/transcodes` and `/config/data/subtitles` directories. It's recommended to setup [NFS share](https://github.com/aleksasiriski/jellyfin-rffmpeg/blob/main/docker-compose.example.yml) for this.

For a worker docker image you can use [this](https://github.com/aleksasiriski/rffmpeg-worker).

#### Adding new workers

Copy the public ssh key to the worker:
```bash
docker compose exec -it jellyfin ssh-copy-id -i /config/rffmpeg/.ssh/id_ed25519.pub root@<worker_ip_address>
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

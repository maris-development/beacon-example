# Cloud storage (S3/MinIO) example

This example runs Beacon with an S3-compatible backend using **MinIO**.

## What you get

- **Beacon API** on `http://localhost:8080`
- **MinIO S3 API** on `http://localhost:9000`
- **MinIO Console (UI)** on `http://localhost:9001`
- An S3 bucket named `beacon-bucket` created automatically on startup

## Prerequisites

- Docker (includes Docker Compose)

## Run it

From the repository root:

```bash
cd cloud-storage-minio

# Newer Docker versions
docker compose up -d

# If your setup still uses the legacy binary
# docker-compose up -d
```

## Credentials

MinIO is started with the default credentials from the compose file:

- Username: `minioadmin`
- Password: `minioadmin`

## Data and table metadata

Beacon reads table metadata from the folder mounted into the container:

- Host folder: `cloud-storage-minio/data/tables`
- Container folder: `/beacon/data/tables`

This example includes a minimal table definition at:

- `cloud-storage-minio/data/tables/default/table.json`

The bucket setup container (`createbuckets`) creates `beacon-bucket` and configures **anonymous download** so Beacon can access it with:

- `AWS_ENDPOINT=http://minio:9000`
- `AWS_SKIP_SIGNATURE=true`

This is convenient for local development, but is **not** a production setup.

### Uploading objects to MinIO

You can upload objects to the bucket using either:

- The MinIO Console at `http://localhost:9001` (browse to bucket `beacon-bucket`)
- The MinIO client (`mc`) if you have it installed locally

## Stop / reset

```bash
cd cloud-storage-minio

# Stop containers
docker compose down

# Stop and remove volumes (fully reset)
docker compose down -v
```

## Troubleshooting

- If `createbuckets` fails, wait a few seconds and re-run `docker compose up -d`.
- If ports are already in use, change the host-side mappings in `docker-compose.yml` (e.g. `8080:8080`).

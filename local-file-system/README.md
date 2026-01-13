# Local file system example

This example runs Beacon using the **local file system** for datasets and table metadata.

## What you get

- **Beacon API** on `http://localhost:8080`

## Prerequisites

- Docker (includes Docker Compose)

## Folder layout

These folders on your machine are mounted into the Beacon container:

- `local-file-system/datasets` → `/beacon/data/datasets`
- `local-file-system/tables` → `/beacon/data/tables`

A sample NetCDF file is included in `local-file-system/datasets/`.

## Table metadata (important)

The compose file sets:

- `BEACON_DEFAULT_TABLE=default`

That means Beacon expects a table definition named `default` under `/beacon/data/tables`.

If `local-file-system/tables/` is empty, create a minimal table definition like this:

```text
local-file-system/
  tables/
    default/
      table.json
```

Example `table.json`:

```json
{
  "table_name": "default",
  "table_type": { "empty": null },
  "description": "Default Table."
}
```

## Run it

From the repository root:

```bash
cd local-file-system

# Newer Docker versions
docker compose up -d

# If your setup still uses the legacy binary
# docker-compose up -d
```

## Stop / reset

```bash
cd local-file-system

# Stop containers
docker compose down
```

## Troubleshooting

- If Beacon starts but doesn’t show expected tables/data, double-check the contents of `tables/` and that `BEACON_DEFAULT_TABLE` matches your folder name.
- If port `8080` is already in use, change the host-side mapping in `docker-compose.yml`.

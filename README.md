# Surf Research Cloud (SRC) example

This example is to deploy Beacon on the Surf Research Cloud (SRC).

## Plugin parameters

Set the parameters in the Surf Research Cloud workspace form. The script writes them to `.env`.

| Parameter | Default | Function |
| --- | --- | --- |
| `BEACON_SRC_ADMIN_AUTH` | `true` | `true` protects `/admin/` with the SRC login. `false` uses the basic auth of Beacon. |
| `BEACON_ADMIN_USERNAME` | `admin` | Admin user of Beacon. |
| `BEACON_ADMIN_PASSWORD` | `admin` | Admin password of Beacon. |

The SRC login sends these admin credentials to Beacon in the `Authorization` header.

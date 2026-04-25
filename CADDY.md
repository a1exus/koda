# Caddy HTTPS for Native `make serve`

Caddy provides local and LAN HTTPS termination for the native `make serve` path. Use it when:

- You need HTTPS for Cursor but don't have Tailscale
- You're on the same machine or same local network as the server

If you have Tailscale, use `tailscale serve` instead — it provisions a trusted certificate automatically with no extra setup. See [TAILSCALE.md](./TAILSCALE.md).

| Scenario | Recommended |
| :--- | :--- |
| Private remote access | Tailscale — HTTPS built in |
| Local machine or LAN, no Tailscale | Caddy |
| Docker | Traefik via `compose.traefik.yml` |

---

## Install

**macOS / Linux**
```bash
brew install caddy
```

**Windows (WSL)**
```bash
sudo apt install -y debian-keyring debian-archive-keyring apt-transport-https curl
curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' | sudo gpg --dearmor -o /usr/share/keyrings/caddy-stable-archive-keyring.gpg
curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/debian.deb.txt' | sudo tee /etc/apt/sources.list.d/caddy-stable.list
sudo apt update && sudo apt install caddy
```

---

## Start

First, start your model server:
```bash
make serve ENV=models/ggml-org/gemma-4-31B-it-GGUF.Q4_K_M.env
```

Then start Caddy in front of it. Choose the `--from` address based on where your client is:

**Same machine (e.g. Cursor on localhost)**
```bash
caddy reverse-proxy --from https://localhost:8443 --to localhost:8080
```

**LAN access (e.g. Cursor on another machine on the same network)**
```bash
caddy reverse-proxy --from https://192.168.1.100:8443 --to localhost:8080
```

**Private remote access (Tailscale)**
```bash
caddy reverse-proxy --from https://my-machine.tail1234.ts.net --to localhost:8080
```
> Caddy will obtain a TLS certificate automatically when using a real hostname. For `localhost`, it issues a locally-trusted certificate via its built-in CA (requires trusting Caddy's root cert).

---

## Trust the Local Certificate (localhost only)

When using `localhost`, Caddy issues a self-signed cert from its own CA. Trust it once:

```bash
caddy trust
```

This installs Caddy's root certificate into your system trust store so browsers and tools like Cursor accept it without warnings.

---

## Use the HTTPS URL in Cursor

Once Caddy is running, use the HTTPS URL as the base URL in Cursor:

- **localhost:** `https://localhost:8443/v1`
- **LAN:** `https://192.168.1.100:8443/v1`
- **Tailscale:** `https://my-machine.tail1234.ts.net/v1`

See [CURSOR.md](./CURSOR.md) for the full Cursor configuration steps.

# docker

## Wann laden?
Bei Container-Änderungen: Dockerfile editieren, Services hinzufügen,
Volume/Netzwerk-Konfiguration, Rebuild oder Restart.

## Kontext

mycoforge läuft als Docker Container auf einem Ubuntu VPS.

| Host | Container | Inhalt |
|------|-----------|--------|
| `/docker/mycoforge/workspace` | `/workspace` | Projekte |
| `/docker/mycoforge/claude` | `/root/.claude` | Claude Config |
| `/docker/mycoforge` | `/mycoforge` | mycoforge selbst |

Alle Services laufen im selben Netzwerk: `mycoforge_network`.

## Vorgehen

### Container bauen
```bash
cd /docker/mycoforge
docker compose build
```

### Container starten (interaktiv)
```bash
docker compose run --rm -it mycoforge claude
```

### Einmaligen Befehl ausführen
```bash
docker compose run --rm mycoforge claude -p "dein prompt"
```

### Update (Git + Rebuild + Restart)
```bash
./update.sh
```

### Nach Dockerfile-Änderung
```
1. Änderung committen
2. docker compose build
3. Testen
4. ./update.sh
```

### Neuen Service hinzufügen

In `docker-compose.yml` unter `services:`:
```yaml
  neuer-service:
    image: service-image:latest
    restart: unless-stopped
    networks:
      - mycoforge_network
```

## Secrets & Umgebungsvariablen

- Immer über `.env` — nie ins Dockerfile hardcoden
- `.env.example` aktuell halten wenn neue Variablen hinzukommen
- `.env` ist in `.gitignore` — niemals committen

## Beispiele

```bash
# Rebuild nach Dockerfile-Änderung
cd /docker/mycoforge && docker compose build && docker compose run --rm -it mycoforge claude

# Shell im laufenden Container
./shell.sh
```

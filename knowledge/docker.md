# Docker & Container

## Wann diese Datei laden?
Lade diese Datei wenn Container-Änderungen vorgenommen werden sollen.

## mycoforge Container

### Bauen
```bash
cd /docker/mycoforge
docker compose build
```

### Starten (interaktiv)
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

## Dockerfile ändern

Nach jeder Dockerfile-Änderung:
1. Änderung committen
2. docker compose build
3. Testen
4. ./update.sh

## Neuen Service hinzufügen

In docker-compose.yml unter services:
```yaml
  neuer-service:
    image: service-image:latest
    restart: unless-stopped
    networks:
      - mycoforge_network
```

## Volumes

| Host                        | Container        | Inhalt |
|-----------------------------|------------------|--------|
| ./workspace                 | /workspace       | Projekte |
| ./claude                    | /root/.claude    | Claude Config |
| .                           | /mycoforge       | mycoforge selbst |

## Netzwerk

Alle Services im selben Netzwerk: mycoforge_network
Neue Services müssen diesem Netzwerk hinzugefügt werden.

## Secrets & Umgebungsvariablen

- Immer über .env
- Nie ins Dockerfile hardcoden
- .env.example aktuell halten wenn neue Variablen hinzukommen

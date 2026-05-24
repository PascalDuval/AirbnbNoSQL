# Installation MongoDB sur Windows (detaillee)

Ce projet a ete prepare avec une installation MongoDB sur Windows en version Desktop.
Concretement, cela signifie:

1. MongoDB Community Server (moteur `mongod`)
2. MongoDB Compass (interface graphique Desktop)
3. MongoDB Shell `mongosh`

## 1) Installer MongoDB Community Server (Desktop)

1. Telecharger MongoDB Community Server 8.0 depuis le site officiel MongoDB.
2. Lancer l'installateur en mode complet.
3. Cocher l'installation de MongoDB Compass si proposee.
4. Laisser le service Windows MongoDB active si vous voulez un demarrage automatique (optionnel pour ce projet, car les scripts lancent des instances dediees).
3. Conserver le chemin standard:
   - `C:\Program Files\MongoDB\Server\8.0\bin`
4. Verifier que `mongod.exe` existe dans ce dossier.

## 2) Installer / verifier MongoDB Compass (Desktop GUI)

1. Ouvrir MongoDB Compass.
2. Verifier que vous pouvez creer une connexion locale.
3. Pour ce projet, les connexions utiles sont:
   - `mongodb://localhost:27017` (replica set simple)
   - `mongodb://localhost:27000` (routeur `mongos` en mode sharde)

## 3) Installer mongosh

1. Telecharger `mongosh` (MongoDB Shell) pour Windows.
2. Extraire l'archive, par exemple:
   - `C:\Users\karap\Downloads\mongosh-2.5.10-win32-x64\mongosh-2.5.10-win32-x64\bin\mongosh.exe`
3. Verifier que `mongosh.exe` est accessible.

## 4) Dossiers de donnees utilises par les scripts

Les scripts utilisent la base locale:

- `C:\Users\karap\mongodb`

Sous-dossiers crees selon le scenario:

- Replica set: `rs-paris`, `rs-lyon`, `rs-strasbourg`
- Sharding: `cfg1`, `cfg2`, `cfg3` (ou `cfg33` selon script), `shard1`, `shard2`, `shard3`

## 5) Ports MongoDB utilises

- `27017`, `27018`, `27019`: noeuds data / shards
- `26001`, `26002`, `26003`: config servers
- `27000`: routeur `mongos`

## 6) Verification rapide

Verifier les binaires:

```powershell
& "C:\Program Files\MongoDB\Server\8.0\bin\mongod.exe" --version
& "C:\Program Files\MongoDB\Server\8.0\bin\mongos.exe" --version
& "C:\Users\karap\Downloads\mongosh-2.5.10-win32-x64\mongosh-2.5.10-win32-x64\bin\mongosh.exe" --version
```

Verifier les processus:

```powershell
Get-Process mongod,mongos -ErrorAction SilentlyContinue
```

Verifier les ports:

```powershell
Get-NetTCPConnection -LocalPort 27000,27017,27018,27019,26001,26002,26003 -ErrorAction SilentlyContinue
```

## 7) Demarrage type pour ce projet

1. Ouvrir PowerShell a la racine du repo.
2. Lancer `scripts/powershell/03_start-sharded-cluster.ps1`.
3. Ouvrir Compass et se connecter a `mongodb://localhost:27000`.
4. Verifier l'etat via `mongosh` avec `sh.status()`.

## 8) Points d'attention

1. Les scripts actuels utilisent des chemins absolus. Adaptez-les si votre installation differe.
2. Si ExecutionPolicy bloque, executer PowerShell en administrateur et utiliser `-ExecutionPolicy Bypass`.
3. Si un port est deja occupe, arreter l'instance existante avant de relancer les scripts.

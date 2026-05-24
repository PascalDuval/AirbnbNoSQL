# Installation MongoDB sur Windows (detaillee)

## 1) Installer MongoDB Server

1. Telecharger MongoDB Community Server 8.0 depuis le site officiel MongoDB.
2. Lancer l'installateur en mode complet.
3. Conserver le chemin standard:
   - `C:\Program Files\MongoDB\Server\8.0\bin`
4. Verifier que `mongod.exe` existe dans ce dossier.

## 2) Installer mongosh

1. Telecharger `mongosh` (MongoDB Shell) pour Windows.
2. Extraire l'archive, par exemple:
   - `C:\Users\karap\Downloads\mongosh-2.5.10-win32-x64\mongosh-2.5.10-win32-x64\bin\mongosh.exe`
3. Verifier que `mongosh.exe` est accessible.

## 3) Dossiers de donnees utilises par les scripts

Les scripts utilisent la base locale:

- `C:\Users\karap\mongodb`

Sous-dossiers crees selon le scenario:

- Replica set: `rs-paris`, `rs-lyon`, `rs-strasbourg`
- Sharding: `cfg1`, `cfg2`, `cfg3` (ou `cfg33` selon script), `shard1`, `shard2`, `shard3`

## 4) Ports MongoDB utilises

- `27017`, `27018`, `27019`: noeuds data / shards
- `26001`, `26002`, `26003`: config servers
- `27000`: routeur `mongos`

## 5) Verification rapide

Verifier les binaires:

```powershell
& "C:\Program Files\MongoDB\Server\8.0\bin\mongod.exe" --version
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

## 6) Points d'attention

1. Les scripts actuels utilisent des chemins absolus. Adaptez-les si votre installation differe.
2. Si ExecutionPolicy bloque, executer PowerShell en administrateur et utiliser `-ExecutionPolicy Bypass`.
3. Si un port est deja occupe, arreter l'instance existante avant de relancer les scripts.

# Guide des scripts PS1 et JS

## Vue d'ensemble

Les scripts sont separes dans `scripts/powershell` et numerotes pour execution sequentielle.

## Scripts PowerShell

### 01_start-mongo-replica.ps1

- But: demarrer 3 instances `mongod` en replica set `rsGeo`.
- Ports: `27017`, `27018`, `27019`.
- Donnees: `C:\Users\karap\mongodb\rs-paris`, `rs-lyon`, `rs-strasbourg`.
- Utilisation:

```powershell
PowerShell -ExecutionPolicy Bypass -File .\scripts\powershell\01_start-mongo-replica.ps1
```

### 02_test-replication-manuel.ps1

- But: relancer les noeuds replica set (utile pour test manuel de demarrage).
- Ports: `27017`, `27018`, `27019`.
- Utilisation:

```powershell
PowerShell -ExecutionPolicy Bypass -File .\scripts\powershell\02_test-replication-manuel.ps1
```

### 03_start-sharded-cluster.ps1

- But: demarrer un cluster sharde complet:
  - 3 config servers (replica set `cfgRepl`)
  - 3 shards (`shard1Repl`, `shard2Repl`, `shard3Repl`)
  - 1 routeur `mongos` sur port `27000`
  - ajout automatique des shards
- Utilisation:

```powershell
PowerShell -ExecutionPolicy Bypass -File .\scripts\powershell\03_start-sharded-cluster.ps1
```

### 04_init-sharded-cluster.ps1

- But: variante d'initialisation cluster sharde (nettoyage + demarrage + initiation + ajout shards).
- Utilisation:

```powershell
PowerShell -ExecutionPolicy Bypass -File .\scripts\powershell\04_init-sharded-cluster.ps1
```

## Script Mongo Shell

### 05_shard-move-chunks.js

- But: split manuel des chunks puis deplacement de chunks selon `host_location`.
- A executer depuis `mongosh` connecte au `mongos` (port `27000`).
- Utilisation:

```javascript
load("./scripts/mongo/05_shard-move-chunks.js")
```

## Sequence recommandee (tests sequentiels)

### Option Replica Set

1. Executer `01_start-mongo-replica.ps1`
2. Verifier dans `mongosh`:

```javascript
rs.status()
```

### Option Sharding

1. Executer `03_start-sharded-cluster.ps1`
2. Verifier:

```javascript
sh.status()
```

3. Executer `05_shard-move-chunks.js`
4. Re-verifier `sh.status()`

## Arret des processus MongoDB

```powershell
Stop-Process -Name mongod -Force -ErrorAction SilentlyContinue
Stop-Process -Name mongos -Force -ErrorAction SilentlyContinue
```

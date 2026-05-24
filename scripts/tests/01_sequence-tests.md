# Sequence de tests manuels

## Test 01 - Replica Set

1. Lancer `scripts/powershell/01_start-mongo-replica.ps1`
2. Ouvrir `mongosh` sur `--port 27017`
3. Executer `rs.status()`
4. Verifier qu'un PRIMARY et des SECONDARY sont presents

## Test 02 - Cluster Sharde

1. Lancer `scripts/powershell/03_start-sharded-cluster.ps1`
2. Ouvrir `mongosh` sur `--port 27000`
3. Executer `sh.status()`
4. Verifier la presence de `shard1Repl`, `shard2Repl`, `shard3Repl`

## Test 03 - Deplacement de chunks

1. Depuis `mongosh` (port 27000), executer:
   `load("./scripts/mongo/05_shard-move-chunks.js")`
2. Reexecuter `sh.status()`
3. Verifier les chunks deplaces

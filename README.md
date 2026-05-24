# AirbnbNoSQL

Ce dépôt contient la mise en place d'une base NoSQL MongoDB pour des données Airbnb (Paris/Lyon), avec des scripts PowerShell pour replica set, cluster shardé et vérification.

Dépôt GitHub : https://github.com/PascalDuval/AirbnbNoSQL

## 1) Structure du dépôt

```
data/
  raw/            # données sources CSV/JSON
  exports/        # exports depuis MongoDB
  schemas/        # schéma JSON et pipeline diagnostic
notebooks/        # notebooks d'analyse
scripts/
  powershell/     # scripts PS1 d'infra MongoDB (numérotés)
  mongo/          # scripts JS exécutés dans mongosh
  tests/          # documentation de tests séquentiels
documentation/    # documentation officielle (dont périmètre PDF)
docus/            # archives / fichiers non essentiels
```

Le document de périmètre est dans :

- `documentation/Duval_Pascal_presentation2_projet7-NoSQL_26122025.pdf`

## 2) Cloner le dépôt

```powershell
git clone https://github.com/PascalDuval/AirbnbNoSQL.git
Set-Location .\AirbnbNoSQL
```

Vérifier l'état :

```powershell
git status -sb
```

## 3) Prérequis techniques

1. Windows 10/11
2. MongoDB Community Server (Desktop Windows) installé
3. MongoDB Compass (Desktop) installé
4. mongosh installé
5. PowerShell autorisé à exécuter les scripts

Voir le guide détaillé :

- `documentation/MONGODB_WINDOWS_INSTALLATION.md`

## 4) Configurer Jupyter / noyau Python

Interpréteur recommandé :

- `C:/chemin/vers/envs/projet-python/python.exe`

Dans VS Code:

1. Ouvrir un notebook dans `notebooks/`.
2. Sélectionner le kernel `projet-python` (ou l'interpréteur ci-dessus).
3. Installer les paquets avec `%pip` dans le notebook (éviter `!pip`).

Exemple dans une cellule notebook :

```python
%pip install pandas pymongo polars matplotlib
```

Guide pas à pas :

- `documentation/JUPYTER_KERNEL_SETUP.md`

## 5) Scripts PowerShell (ordre conseillé)

Les scripts sont numérotés pour un enchaînement séquentiel clair.

### Scénario A - Replica Set géographique

1. `scripts/powershell/01_start-mongo-replica.ps1`
2. `scripts/powershell/02_test-replication-manuel.ps1`

### Scénario B - Cluster shardé

1. `scripts/powershell/03_start-sharded-cluster.ps1`
2. `scripts/powershell/04_init-sharded-cluster.ps1`
3. `scripts/mongo/05_shard-move-chunks.js`

Guide complet d'exécution et rôle de chaque script :

- `documentation/SCRIPTS_PS1_GUIDE.md`

## 6) Commandes d'exécution

Depuis la racine du dépôt :

```powershell
Set-Location .\scripts\powershell
PowerShell -ExecutionPolicy Bypass -File .\01_start-mongo-replica.ps1
PowerShell -ExecutionPolicy Bypass -File .\02_test-replication-manuel.ps1
```

Pour cluster shardé :

```powershell
Set-Location .\scripts\powershell
PowerShell -ExecutionPolicy Bypass -File .\03_start-sharded-cluster.ps1
PowerShell -ExecutionPolicy Bypass -File .\04_init-sharded-cluster.ps1
```

Puis dans `mongosh` (connecté sur port 27000) :

```javascript
load("./scripts/mongo/05_shard-move-chunks.js")
```

## 7) Données

- Sources: `data/raw`
- Exports MongoDB: `data/exports`
- Schéma/pipeline : `data/schemas`
- Archives/inutiles non versionnées : `docus/`

## 8) Notes importantes

1. Les scripts utilisent des chemins absolus locaux (ex : `C:\Program Files\MongoDB\Server\8.0\bin`). Adapter ces chemins si nécessaire.
2. Les ports utilisés sont principalement 27000, 27017, 27018, 27019, 26001, 26002, 26003.

## 9) GitHub

Push standard (déjà configuré localement) :

```powershell
git add .
git commit -m "Message explicite"
git push -u origin main
```

Important : les gros fichiers de `data/` passent par Git LFS.

# AirbnbNoSQL - Projet 7

Ce depot contient la mise en place d'une base NoSQL MongoDB pour des donnees Airbnb (Paris/Lyon), avec scripts PowerShell pour replica set, cluster sharde et verification.

Depot GitHub: https://github.com/PascalDuval/AirbnbNoSQL

## 1) Structure du projet

```
data/
  raw/            # donnees sources CSV/JSON
  exports/        # exports depuis MongoDB
  schemas/        # schema JSON et pipeline diagnostic
notebooks/        # notebooks d'analyse
scripts/
  powershell/     # scripts PS1 d'infra MongoDB (numerotes)
  mongo/          # scripts JS executes dans mongosh
  tests/          # documentation de tests sequentiels
documentation/    # documentation officielle du projet (dont perimetre PDF)
docus/            # archives / fichiers non essentiels
```

Le document de perimetre est dans:

- `documentation/Duval_Pascal_presentation2_projet7-NoSQL_26122025.pdf`

## 2) Cloner le projet

```powershell
git clone https://github.com/PascalDuval/AirbnbNoSQL.git
Set-Location .\AirbnbNoSQL
```

Verifier l'etat:

```powershell
git status -sb
```

## 3) Prerequis techniques

1. Windows 10/11
2. MongoDB Community Server (Desktop Windows) installe
3. MongoDB Compass (Desktop) installe
4. mongosh installe
4. PowerShell autorise a executer les scripts

Voir le guide detaille:

- `documentation/MONGODB_WINDOWS_INSTALLATION.md`

## 4) Configurer Jupyter / noyau Python

Interpreteur recommande pour ce projet:

- `C:/Users/karap/anaconda3/envs/LLMRag/python.exe`

Dans VS Code:

1. Ouvrir un notebook dans `notebooks/`.
2. Selectionner le kernel `LLMRag` (ou l'interpreteur ci-dessus).
3. Installer les paquets avec `%pip` dans le notebook (eviter `!pip`).

Exemple dans une cellule notebook:

```python
%pip install pandas pymongo polars matplotlib
```

Guide pas a pas:

- `documentation/JUPYTER_KERNEL_SETUP.md`

## 5) Scripts PowerShell (ordre conseille)

Les scripts sont numerotes pour un enchainement sequentiel clair.

### Scenario A - Replica Set geographique

1. `scripts/powershell/01_start-mongo-replica.ps1`
2. `scripts/powershell/02_test-replication-manuel.ps1`

### Scenario B - Cluster sharde

1. `scripts/powershell/03_start-sharded-cluster.ps1`
2. `scripts/powershell/04_init-sharded-cluster.ps1`
3. `scripts/mongo/05_shard-move-chunks.js`

Guide complet d'execution et role de chaque script:

- `documentation/SCRIPTS_PS1_GUIDE.md`

## 6) Commandes d'execution

Depuis la racine du projet:

```powershell
Set-Location .\scripts\powershell
PowerShell -ExecutionPolicy Bypass -File .\01_start-mongo-replica.ps1
PowerShell -ExecutionPolicy Bypass -File .\02_test-replication-manuel.ps1
```

Pour cluster sharde:

```powershell
Set-Location .\scripts\powershell
PowerShell -ExecutionPolicy Bypass -File .\03_start-sharded-cluster.ps1
PowerShell -ExecutionPolicy Bypass -File .\04_init-sharded-cluster.ps1
```

Puis dans `mongosh` (connecte sur port 27000):

```javascript
load("./scripts/mongo/05_shard-move-chunks.js")
```

## 7) Donnees

- Sources: `data/raw`
- Exports MongoDB: `data/exports`
- Schema/pipeline: `data/schemas`
- Archives/inutiles non versionnees: `docus/`

## 8) Notes importantes

1. Un doublon du PDF de perimetre peut rester a la racine si le fichier est ouvert/verrouille par Windows. Fermer le PDF puis supprimer la copie racine.
2. Les scripts utilisent des chemins absolus locaux (ex: `C:\Program Files\MongoDB\Server\8.0\bin`). Adapter ces chemins si necessaire.
3. Les ports utilises sont principalement 27000, 27017, 27018, 27019, 26001, 26002, 26003.

## 9) GitHub

Push standard (deja configure localement):

```powershell
git add .
git commit -m "Message explicite"
git push -u origin main
```

Important: les gros fichiers de `data/` passent par Git LFS.

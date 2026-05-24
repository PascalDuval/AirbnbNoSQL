# Configuration Jupyter Kernel (VS Code)

## Objectif

Executer les notebooks du projet avec le bon environnement Python.

Interpreteur cible:

- `C:/chemin/vers/envs/projet-python/python.exe`

## 1) Ouvrir un notebook

1. Ouvrir `notebooks/metrique.ipynb` ou `notebooks/requeteavanceespolar.ipynb`.
2. Cliquer sur le selecteur de kernel en haut a droite dans VS Code.

## 2) Selectionner le bon kernel

1. Choisir l'environnement `projet-python`.
2. Si absent, choisir "Select Another Kernel" puis pointer vers:
   - `C:/chemin/vers/envs/projet-python/python.exe`

## 3) Installer les dependances dans le notebook

Toujours utiliser `%pip` dans les cellules notebook.

```python
%pip install pandas pymongo polars matplotlib jupyter
```

## 4) Verification rapide

Executer cette cellule:

```python
import sys
import pandas as pd
import pymongo
import polars as pl

print(sys.executable)
print(pd.__version__)
print(pymongo.__version__)
print(pl.__version__)
```

Le chemin de `sys.executable` doit pointer vers l'environnement `projet-python`.

## 5) Conseils de depannage

1. Si un package est introuvable, reexecuter `%pip install ...` puis redemarrer le kernel.
2. Si VS Code propose plusieurs interpreteurs, re-selectionner explicitement `projet-python`.
3. Eviter `!pip` dans notebook pour garder un environnement coherent.

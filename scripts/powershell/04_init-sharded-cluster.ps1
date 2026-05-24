# ============================================
# Script PowerShell - Init MongoDB Sharded Cluster
# ============================================

# ✅ Config
$mongod = "C:\Program Files\MongoDB\Server\8.0\bin\mongod.exe"
$mongosh = "C:\Users\karap\Downloads\mongosh-2.5.10-win32-x64\mongosh-2.5.10-win32-x64\bin\mongosh.exe"
$baseDir = "C:\Users\karap\mongodb"

# ✅ Nettoyage
Write-Host "🧹 Nettoyage en cours..." -ForegroundColor Yellow
Stop-Process -Name mongod -Force -ErrorAction SilentlyContinue
Stop-Process -Name mongos -Force -ErrorAction SilentlyContinue
Start-Sleep -Seconds 2

# ✅ Dossiers attendus
$dirs = @("shard1", "shard2", "shard3", "cfg1", "cfg2", "cfg3")
foreach ($dir in $dirs) {
    $full = Join-Path $baseDir $dir
    if (-not (Test-Path $full)) {
        New-Item -ItemType Directory -Path $full | Out-Null
    }
}

# ✅ Lancement des Shards
$shards = @(27017, 27018, 27019)
for ($i = 0; $i -lt $shards.Length; $i++) {
    $port = $shards[$i]
    $folder = Join-Path $baseDir "shard$($i+1)"
    Start-Process -FilePath $mongod -ArgumentList @(
        "--shardsvr",
        "--replSet", "shard$($i+1)Repl",
        "--port", "$port",
        "--dbpath", "`"$folder`"",
        "--bind_ip", "localhost",
        "--logpath", "`"$folder\mongod.log`"",
        "--logappend"
    ) -WindowStyle Hidden
    Write-Host "✅ Shard lancé : shard$($i+1)Repl sur port $port"
}

# ✅ Lancement des Config Servers
$cfgPorts = @(26001, 26002, 26003)
for ($i = 0; $i -lt $cfgPorts.Length; $i++) {
    $port = $cfgPorts[$i]
    $folder = Join-Path $baseDir "cfg$($i+1)"
    Start-Process -FilePath $mongod -ArgumentList @(
        "--configsvr",
        "--replSet", "cfgRepl",
        "--port", "$port",
        "--dbpath", "`"$folder`"",
        "--bind_ip", "localhost",
        "--logpath", "`"$folder\mongod.log`"",
        "--logappend"
    ) -WindowStyle Hidden
    Write-Host "✅ Config Server $i lancé sur port $port"
}

Start-Sleep -Seconds 10

# ✅ Lancer mongos
$mongosLog = "$baseDir\mongos.log"
Start-Process -FilePath "$mongod\..\mongos.exe" -ArgumentList @(
    "--configdb", "cfgRepl/localhost:26001,localhost:26002,localhost:26003",
    "--port", "27000",
    "--bind_ip", "localhost",
    "--logpath", "`"$mongosLog`"",
    "--logappend"
) -WindowStyle Hidden
Write-Host "✅ Routeur mongos lancé sur port 27000"

Start-Sleep -Seconds 10

# ✅ Initialisation des Replica Sets
Write-Host "⚙️ Initialisation des Replica Sets..." -ForegroundColor Cyan

& $mongosh --port 27017 --eval "rs.initiate({ _id: 'shard1Repl', members: [{ _id: 0, host: 'localhost:27017' }] })"
& $mongosh --port 27018 --eval "rs.initiate({ _id: 'shard2Repl', members: [{ _id: 0, host: 'localhost:27018' }] })"
& $mongosh --port 27019 --eval "rs.initiate({ _id: 'shard3Repl', members: [{ _id: 0, host: 'localhost:27019' }] })"

& $mongosh --port 26001 --eval "rs.initiate({
  _id: 'cfgRepl',
  configsvr: true,
  members: [
    { _id: 0, host: 'localhost:26001' },
    { _id: 1, host: 'localhost:26002' },
    { _id: 2, host: 'localhost:26003' }
  ]
})"

Start-Sleep -Seconds 10

# ✅ Ajout des Shards
Write-Host "➕ Ajout des shards au cluster..." -ForegroundColor Cyan
& $mongosh --port 27000 --eval "sh.addShard('shard1Repl/localhost:27017')"
& $mongosh --port 27000 --eval "sh.addShard('shard2Repl/localhost:27018')"
& $mongosh --port 27000 --eval "sh.addShard('shard3Repl/localhost:27019')"

# ✅ État du cluster
Write-Host "`n📊 État du cluster :" -ForegroundColor Cyan
& $mongosh --port 27000 --eval "sh.status()"

Write-Host "`n✅ Cluster sharded prêt à l'emploi 🎉" -ForegroundColor Green

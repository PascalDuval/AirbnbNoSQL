# Script PowerShell - Start MongoDB Sharded Cluster

Write-Host "Cleaning up previous mongod/mongos instances..."
Stop-Process -Name mongod -Force -ErrorAction SilentlyContinue
Stop-Process -Name mongos -Force -ErrorAction SilentlyContinue
Start-Sleep -Seconds 2

# Base paths
$baseDir = "C:\Users\karap\mongodb"
$mongod = "C:\Program Files\MongoDB\Server\8.0\bin\mongod.exe"
$mongos = "C:\Program Files\MongoDB\Server\8.0\bin\mongos.exe"
$mongosh = "C:\Users\karap\Downloads\mongosh-2.5.10-win32-x64\mongosh-2.5.10-win32-x64\bin\mongosh.exe"

# Create folders
$dirs = @("cfg1", "cfg2", "cfg33", "shard1", "shard2", "shard3")
foreach ($dir in $dirs) {
    $full = Join-Path $baseDir $dir
    if (-not (Test-Path $full)) {
        Write-Host "Creating folder $full"
        New-Item -ItemType Directory -Path $full | Out-Null
    }
}

# Config servers
$cfgPorts = @(26001, 26002, 26003)
$cfgFolders = @("cfg1", "cfg2", "cfg33")
for ($i = 0; $i -lt $cfgPorts.Length; $i++) {
    $port = $cfgPorts[$i]
    $folder = Join-Path $baseDir $cfgFolders[$i]
    Start-Process -FilePath $mongod -ArgumentList @(
        "--configsvr",
        "--replSet", "cfgRepl",
        "--port", "$port",
        "--dbpath", "$folder",
        "--bind_ip", "localhost",
        "--logpath", "$folder\mongod.log",
        "--logappend"
    ) -WindowStyle Normal
    Write-Host "Started config server on port $port"
}

Start-Sleep -Seconds 5

# Initiate config replica set
& $mongosh --port 26001 --eval @"
rs.initiate({
  _id: "cfgRepl",
  configsvr: true,
  members: [
    { _id: 0, host: "localhost:26001" },
    { _id: 1, host: "localhost:26002" },
    { _id: 2, host: "localhost:26003" }
  ]
})
"@

Start-Sleep -Seconds 5

# Shard servers
$shardRepls = @("shard1Repl", "shard2Repl", "shard3Repl")
$shardPorts = @(27017, 27018, 27019)
$shardFolders = @("shard1", "shard2", "shard3")
for ($i = 0; $i -lt $shardPorts.Length; $i++) {
    $port = $shardPorts[$i]
    $folder = Join-Path $baseDir $shardFolders[$i]
    $repl = $shardRepls[$i]
    Start-Process -FilePath $mongod -ArgumentList @(
        "--shardsvr",
        "--replSet", "$repl",
        "--port", "$port",
        "--dbpath", "$folder",
        "--bind_ip", "localhost",
        "--logpath", "$folder\mongod.log",
        "--logappend"
    ) -WindowStyle Normal
    Write-Host "Started shard $repl on port $port"
}

Start-Sleep -Seconds 5

# Initiate shard replica sets
for ($i = 0; $i -lt $shardPorts.Length; $i++) {
    $port = $shardPorts[$i]
    $repl = $shardRepls[$i]
    & $mongosh --port $port --eval "rs.initiate({_id: '$repl', members: [{_id: 0, host: 'localhost:$port'}]})"
    Start-Sleep -Seconds 3
}

# Start mongos
Start-Process -FilePath $mongos -ArgumentList @(
    "--configdb", "cfgRepl/localhost:26001,localhost:26002,localhost:26003",
    "--port", "27000",
    "--bind_ip", "localhost",
    "--logpath", "$baseDir\mongos.log",
    "--logappend"
) -WindowStyle Normal
Write-Host "Started mongos on port 27000"

Start-Sleep -Seconds 5

# Add shards to mongos
& $mongosh --port 27000 --eval @"
sh.addShard('shard1Repl/localhost:27017');
sh.addShard('shard2Repl/localhost:27018');
sh.addShard('shard3Repl/localhost:27019');
sh.status();
"@

Write-Host ""
Write-Host "Initialization finished. Shards are ready."
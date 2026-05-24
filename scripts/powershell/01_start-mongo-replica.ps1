# === Configuration ===
$mongoBin = "C:\Program Files\MongoDB\Server\8.0\bin"
$dataRoot = "C:\Users\karap\mongodb"

$nodes = @(
    @{ name = "paris"; port = 27017 },
    @{ name = "lyon"; port = 27018 },
    @{ name = "strasbourg"; port = 27019 }
)

# === Création des dossiers ===
foreach ($node in $nodes) {
    $path = Join-Path $dataRoot "rs-$($node.name)"
    if (-Not (Test-Path $path)) {
        New-Item -ItemType Directory -Path $path | Out-Null
    }
}

# === Démarrage de chaque mongod ===
foreach ($node in $nodes) {
    $dbpath = Join-Path $dataRoot "rs-$($node.name)"
    $logpath = Join-Path $dbpath "mongod.log"
    $port = $node.port

    Start-Process -FilePath "$mongoBin\mongod.exe" `
        -ArgumentList "--replSet", "rsGeo", "--port", "$port", "--dbpath", "$dbpath", "--bind_ip", "localhost", "--logpath", "$logpath", "--logappend" `
        -WindowStyle Normal
}

Write-Output "✅ Replica Set lancé."
Write-Output "Connecte-toi avec :"
Write-Output "`n`"C:\Users\karap\Downloads\mongosh-2.5.10-win32-x64\mongosh-2.5.10-win32-x64\bin\mongosh.exe`" --port 27017"

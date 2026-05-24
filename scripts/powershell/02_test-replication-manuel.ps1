# ===========================================
# Start MongoDB Replica Set (rsGeo)
# ===========================================

Write-Host "Starting MongoDB Replica Set rsGeo..." -ForegroundColor Cyan

# Path to mongod.exe (SERVER)
$mongod = "C:\Program Files\MongoDB\Server\8.0\bin\mongod.exe"

# Base data directory
$basePath = "C:\Users\karap\mongodb"

# Nodes definition
$nodes = @(
    @{ name = "PARIS";      port = 27017; folder = "rs-paris" },
    @{ name = "LYON";       port = 27018; folder = "rs-lyon" },
    @{ name = "STRASBOURG"; port = 27019; folder = "rs-strasbourg" }
)

# Create data folders if needed
foreach ($node in $nodes) {
    $path = Join-Path $basePath $node.folder
    if (-not (Test-Path $path)) {
        Write-Host "Creating folder $path"
        New-Item -ItemType Directory -Path $path | Out-Null
    }
}

# Start each mongod
foreach ($node in $nodes) {
    $dataPath = Join-Path $basePath $node.folder
    $logPath  = Join-Path $dataPath "mongod.log"

    Write-Host "Starting $($node.name) on port $($node.port)"

    Start-Process -FilePath $mongod `
        -ArgumentList @(
            "--port", $node.port,
            "--dbpath", $dataPath,
            "--replSet", "rsGeo",
            "--bind_ip", "localhost",
            "--logpath", $logPath,
            "--logappend"
        ) `
        -WindowStyle Normal
}

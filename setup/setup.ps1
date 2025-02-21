Write-Output "Instsalling Toolchain..."

function Command-Exists {
    param($command)
    return !(Get-Command $command -ErrorAction SilentlyContinue -eq $null)
}

if (-Not (Command-Exists "choco")) {
    Write-Output "Installing Chocolatey..."
    Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
}

if (-Not (Command-Exists "arkade")) {
    Write-Output "Installing Arkade..."
    choco install arkade -y
}

$tools = @("tilt", "helm", "kubectl", "kustomize")

foreach ($tool in $tools) {
    if (-Not (Command-Exists $tool)) {
        Write-Output "Installing $tool..."
        arkade get $tool
        Move-Item -Path "$env:USERPROFILE\.arkade\bin\$tool.exe" -Destination "$env:ProgramFiles\$tool.exe" -Force
    } else {
        Write-Output "$tool is already installed. Skipping..."
    }
}

if (-Not (Command-Exists "docker")) {
    Write-Output "Installing Docker..."
    choco install docker-desktop -y
}

if (-Not (Command-Exists "k3d")) {
    Write-Output "Installing k3d..."
    choco install k3d -y
}

Write-Output "Creating Local Cluster..."
k3d cluster create dead-letter --port "1337:80@loadbalancer"

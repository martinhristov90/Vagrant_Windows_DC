# install Active Directory Explorer from https://technet.microsoft.com/en-us/sysinternals/adexplorer.aspx
# NB even though you can use the Windows ADSI Edit application, I find ADExplorer nicer.
$adExplorerUrl = 'https://download.sysinternals.com/files/AdExplorer.zip'
$adExplorerHash = '3F4137464DF5156C629C8E1827151CBFC7FA99CC10C43E187D7899E6500791EC'
$adExplorer = 'c:/tmp/AdExplorer.zip' 
(New-Object System.Net.WebClient).DownloadFile($adExplorerUrl, $adExplorer)
$adExplorerActualHash = (Get-FileHash $adExplorer -Algorithm SHA256).Hash
if ($adExplorerHash -ne $adExplorerActualHash) {
    throw "AdExplorer.zip downloaded from $adExplorerUrl to $adExplorer has $adExplorerActualHash hash witch does not match the expected $adExplorerHash"
}
Add-Type -AssemblyName System.IO.Compression.FileSystem
$Shell = New-Object -ComObject 'WScript.Shell'
$ShellSpecialFolders = $Shell.SpecialFolders
$adExplorerProgramFiles = Join-Path $env:ProgramFiles 'ADExplorer'
[IO.Compression.ZipFile]::ExtractToDirectory($adExplorer, $adExplorerProgramFiles)
$shortcut = $Shell.CreateShortcut((Join-Path $ShellSpecialFolders.Item('AllUsersStartMenu') 'Active Directory Explorer (ADExplorer).lnk'))
$shortcut.TargetPath = Join-Path $adExplorerProgramFiles 'ADExplorer.exe'
$shortcut.Save()

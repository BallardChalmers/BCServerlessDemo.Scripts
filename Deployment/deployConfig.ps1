param ( 
    [Parameter(Mandatory=$true)]
    $rootPath,
    [Parameter(Mandatory=$true)]
    $functionsUrl,
    [Parameter(Mandatory=$true)]
    $tenant,
    [Parameter(Mandatory=$true)]
    $clientID,
    [Parameter(Mandatory=$true)]
    $signUpSignInPolicy
)

#$webConfig= "$rootPath/web.config"
#$msalConfig="$rootPath/assets/config/msalConfig.json"
$ngswConfig="$rootPath/ngsw.json"
$ngswWorkerJS="$rootPath/ngsw-worker.js"


$allFiles = Get-ChildItem -Path $rootPath | Sort-Object LastWriteTime -descending
$allFileCount = $allFiles.Count
Write-Output "$allFileCount files found from all of them"
$mainFiles = Get-ChildItem -Filter *main* -Path $rootPath | Sort-Object LastWriteTime -descending
#Select the most recent mainfile
Write-Output "Finding main files at path: $rootPath"
$mainFileCount = $mainFiles.Count
Write-Output "$mainFileCount files found"
Write-Output "Updating ${$mainFiles[0].FullName}"
Write-Output "Setting to $clientID, $functionsUrl, $tenant, $signUpSignInPolicy"

$mainFileText = Get-Content -Raw -Path $mainFiles[0].FullName
$mainFileText = $mainFileText.Replace("clientID:""clientIDToReplace""","clientID:""$clientID""")
$mainFileText = $mainFileText.Replace("apiEndpoint:""http://localhost:7072/api""","apiEndpointFunctions:""$functionsUrl/api""")
$mainFileText = $mainFileText.Replace("tenant:""tenantToReplace""","tenant:""$tenant""")
$mainFileText = $mainFileText.Replace("signUpSignInPolicy:""policyToReplace""","signUpSignInPolicy:""$signUpSignInPolicy""")
$mainFileText = $mainFileText.Replace("b2cScopes:[""clientIDToReplace""]","b2cScopes:[""$clientID""]")
$mainFileText | Out-File $mainFiles[0].FullName 

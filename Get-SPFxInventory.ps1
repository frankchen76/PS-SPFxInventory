[CmdletBinding()]
param (
    [Parameter()]
    [string]
    $csvFile = 'SPFxInventory.csv',
    [Parameter(Mandatory = $true)] 
    [string] $spoAdminUrl,
    [Parameter(Mandatory = $false)] 
    [string] $credStoreName
)

$scriptFullPath = $MyInvocation.MyCommand.Path
$scriptPath = Split-Path $scriptFullPath

if ($csvFile -eq 'SPFxInventory.csv') {
    $csvFile = "{0}\{1}" -f $scriptPath, $csvFile
}

$psCred = Get-PnPStoredCredential -Name $credStoreName -Type PSCredential

#get all site collections
Connect-SPOService -Url $spoAdminUrl -Credential $psCred
$allSites = Get-SPOSite -Limit All -IncludePersonalSite $false
$apps = @()
$progress = 0

foreach ($site in $allSites) {
    Connect-PnPOnline -Url $site.Url -Credentials $psCred
    $applist = Get-PnPApp
    foreach ($app in $applist) {
        #Id                                   Title                Deployed AppCatalogVersion InstalledVersion
        $appObj = @{
            Url                 = $site.Url
            AppId               = $app.Id
            AppTitle            = $app.Title
            AppDeployed         = $app.Deployed
            AppCatalogVersion   = $app.AppCatalogVersion
            AppInstalledVersion = $app.InstalledVersion
        }
        $apps += New-Object PSObject -Property $appObj
    }
    $progress++
    $percentage = [int]($progress * 100 / $allSites.count)
    Write-Progress -Activity "Analyze site collections..." -Status "$($percentage)% complete:" -PercentComplete $percentage
}
if ($null -ne $apps) {
    $apps | Export-Csv -Path $csvFile
    Write-Host $("Report was generated at {0}" -f $csvFile)
}
else {
    Write-Host $("No information was generated. ")
}


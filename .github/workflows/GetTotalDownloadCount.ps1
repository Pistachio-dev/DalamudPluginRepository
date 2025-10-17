param ( [Parameter(Mandatory=$true)] [string]$RepoUrl)

$lifetimeReleases = 0;
$splitRepoUrl = $RepoURL -split "/"
$releasesFetchUri = "https://api.github.com/repos/$($splitRepoUrl[3])/$($splitRepoUrl[4])/releases"
Write-Output "Releases URI: $($releasesFetchUri)"
Invoke-WebRequest -Uri $releasesFetchUri -RetryIntervalSec 20 -MaximumRetryCount 10 -Outfile releaseListFile
$jsonReleaseList = Get-Content -Path releaseListFile -Raw | ConvertFrom-Json
for (($k = 0); $k -lt $jsonReleaseList.Count; $k++)
{
    $release = $jsonReleaseList[$k]
    for (($j = 0); $j -lt $release.assets.Count; $j++){
        $asset = $release.assets[$j]
        if ($asset.name.EndsWith(".zip")){
            Write-Output "$($release.name): $($asset.name), $($asset.download_count) downloads"
            $lifetimeReleases++;
        }    
    }
}

return $lifetimeReleases


param([string]$categoryFilter = "", [string]$reportFilter="+[*]*-[*.Tests]*", [string]$buildConfiguration=$env:CONFIGURATION)

Write-Host "Report filter $($reportFilter)" -ForegroundColor Green
Write-Host "Category filter $($categoryFilter)" -ForegroundColor Green

$coveralls = (Resolve-Path "packages/coveralls.net.*/tools/csmacnz.coveralls.exe").ToString()
$testProj = (Resolve-Path "*/*.Tests/*.Tests.csproj").ToString()
$openCover = (Resolve-Path "packages/OpenCover.*/tools/OpenCover.Console.exe").ToString()

$targetArgs = "$testProj /config:$buildConfiguration"

If ($categoryFilter)
{
	$targetArgs = "$targetArgs  --where=$categoryFilter"
}

Write-Host "OpenCover path $($openCover)" -ForegroundColor Green
Write-Host "Test project path $($testProj)" -ForegroundColor Green
Write-Host "Coveralls path $($coveralls)" -ForegroundColor Green
Write-Host "nUnit args $($targetArgs)" -ForegroundColor Green

Write-Host "$($openCover) -register:user -target:nunit3-console.exe -targetargs:$($targetArgs) -filter:$($reportFilter) -output:OpenCover.xml" -ForegroundColor Green

& $openCover -register:user -target:nunit3-console.exe -targetargs:$targetArgs -filter:$reportFilter -output:OpenCover.xml
$testCode = $lastexitcode
$env:APPVEYOR_BUILD_NUMBER
& $coveralls --opencover -i OpenCover.xml --repoToken $env:COVERALLS_REPO_TOKEN --useRelativePaths --commitId $env:APPVEYOR_REPO_COMMIT --commitBranch $env:APPVEYOR_REPO_BRANCH --commitAuthor $env:APPVEYOR_REPO_COMMIT_AUTHOR --commitEmail $env:APPVEYOR_REPO_COMMIT_AUTHOR_EMAIL --commitMessage $env:APPVEYOR_REPO_COMMIT_MESSAGE --jobId $env:APPVEYOR_BUILD_NUMBER --serviceName appveyor
exit $testCode
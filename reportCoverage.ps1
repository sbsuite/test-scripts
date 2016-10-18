$coveralls = (Resolve-Path "packages/coveralls.net.*/tools/csmacnz.coveralls.exe").ToString()
$testProj = (Resolve-Path "dev/*.Tests/*.Tests.csproj").ToString()
$openCover = (Resolve-Path "packages/OpenCover.*/tools/OpenCover.Console.exe").ToString()
$testFilter = "cat!=IntegrationTest"
$targetArgs = "$testProj --where=$testFilter /config:Release"
$testFilter = "+[*]*-[*.Tests]*"

$openCover
$testProj
$coveralls
$targetArgs
$testFilter

& $openCover -register:user -target:nunit3-console.exe -targetargs:$targetArgs -filter:$testFilter -output:OpenCover.xml
$env:APPVEYOR_BUILD_NUMBER
& $coveralls --opencover -i OpenCover.xml --repoToken $env:COVERALLS_REPO_TOKEN --useRelativePaths --commitId $env:APPVEYOR_REPO_COMMIT --commitBranch $env:APPVEYOR_REPO_BRANCH --commitAuthor $env:APPVEYOR_REPO_COMMIT_AUTHOR --commitEmail $env:APPVEYOR_REPO_COMMIT_AUTHOR_EMAIL --commitMessage $env:APPVEYOR_REPO_COMMIT_MESSAGE --jobId $env:APPVEYOR_BUILD_NUMBER --serviceName appveyor
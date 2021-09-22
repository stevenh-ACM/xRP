<#
.SYNOPSIS
    Setsup new customization project
#>



$ESC=[char]27
$RED="$ESC[0;91m"
$YELLOW="$ESC[1;33m"
$NC="$ESC[0m"

$OSBit = "64bit"

if ($args.count -eq 0 ) {
    echo $RED "ERROR: Missing project name$NC"
    echo "`tUsage: $YELLOW$($MyInvocation.MyCommand.Name) <Project Name>$NC"
    exit
}

$project = $args[0]
#$PROJECT_PATH = (Resolve-Path -Path ".\").tostring()
$PROJECT_DIRECTORY = Split-Path $MyInvocation.MyCommand.Path
$PROJECT_PATH += $PROJECT_DIRECTORY + "\" + $project

if (Test-Path $PROJECT_PATH) {
    echo $RED "ERROR: Cannot generate in existing folder: " $YELLOW $PROJECT_PATH $NC
    exit
}

function Invoke-Command([scriptblock]$Command, [switch]$Fatal, [switch]$Quiet) {
    $output = ""
    if ($Quiet) {
        $output = & $Command 2>&1
    } else {
        & $Command
    }

    if (!$Fatal) {
        return
    }

    $exitCode = 0
    if ($LastExitCode -ne 0) {
        $exitCode = $LastExitCode
    } elseif (!$?) {
        $exitCode = 1
    } else {
        return
    }

    $error = "``$Command`` failed"
    if ($output) {
        Write-Host -ForegroundColor yellow $output
        $error += ". See output above."
    }
    Throw $error
}


function Ensure-Solution {
       
    mkdir $PROJECT_PATH | Out-Null   

    $templatePath = Join-Path $PROJECT_DIRECTORY "template"

    # Folders
    @("tools", "assets", "database") | % { Copy-Item "$templatePath/$_" -Filter * -Destination "$PROJECT_PATH/$_" -Recurse }
    

    # Files        
    @("OpenVS.bat", "Directory.Build.props",
            "build.ps1", "build.cake", ".gitignore", ".editorconfig") | % {
        $tmp = (Get-Content "$templatePath/$_" | %{$_ -replace "#PROJECT#", $project}) 
        $tmp | Out-File -Encoding utf8 "$PROJECT_PATH/$_"
    }
    
    Copy-Item "$PROJECT_DIRECTORY/README.md" -Destination "$PROJECT_PATH"
       

    # Solution File
    $slnFileContent = (Get-Content "$templatePath/WebsiteSolution.sln" | %{$_ -replace "#PROJECT#", $project}) 
    $slnFileContent | Out-File -Encoding utf8 "$PROJECT_PATH/$project.sln"
}


function Ensure-Project {
    $templatePath = Join-Path $PROJECT_DIRECTORY "template"
    $targetDir = Join-Path $PROJECT_PATH "src/$project"
    mkdir $targetDir | Out-Null
    $csprojFileContent = (Get-Content "$templatePath/src/ProjectTemplate.csproj" | %{$_ -replace "#PROJECT#", $project}) 
    $csprojFileContent | Out-File -Encoding utf8 "$targetDir/$project.csproj"
    
    Get-ChildItem -Path "$templatePath/src" -Exclude "*.csproj" | 
        Copy-Item -Destination "$targetDir" -Recurse -Container     
}


function Ensure-Tests {
    $templatePath = Join-Path $PROJECT_DIRECTORY "template"
    $targetDir = Join-Path $PROJECT_PATH "tests/$project.Tests"
    mkdir $targetDir | Out-Null
    $csprojFileContent = (Get-Content "$templatePath/tests/ProjectTemplate.Tests.csproj" | %{$_ -replace "#PROJECT#", $project}) 
    $csprojFileContent | Out-File -Encoding utf8 "$targetDir/$project.Tests.csproj"
}


& {
    Ensure-Solution
    Ensure-Project
    Ensure-Tests
}

echo "Completed successfully..."
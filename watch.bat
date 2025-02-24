@echo off
setlocal

REM Check if the correct number of arguments are provided
if "%~2"=="" (
  echo Usage: %~nx0 ^<slug^> ^<format^>
  exit /b 1
)

set "slug=%~1"
set "format=%~2"

set "srcPath=src/%slug%.typ"
set "outputPath=page/%slug%.%format%"

REM Determine the format-specific path
if /i "%format%"=="html" (
  typst watch "%srcPath%" --root . --format html --features html --font-path="./assets/fonts" --input fmt=html "%outputPath%"
) else if /i "%format%"=="pdf" (
  typst watch "%srcPath%" --root . --format pdf --features html --font-path="./assets/fonts" --input fmt=pdf "%outputPath%"
) else (
  echo Unsupported format: %format%
  exit /b 1
)
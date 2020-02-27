REM Work around to run Powershell as administrator in Jenkins build

powershell -ExecutionPolicy Unrestricted -File build.ps1 -version %1

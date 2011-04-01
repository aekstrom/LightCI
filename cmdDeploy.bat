@echo off

pushd "%~dp0"

powershell -NoProfile -ExecutionPolicy unrestricted -Command "& { Import-Module .\Tools\PSake\psake.psm1; Invoke-psake .\Environment.ps1 -t Upload }"

popd

pause
# https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_profiles?view=powershell-7.3
#
# VSCODE     : C:\program files\powershell\7\profile.ps1 
# Powershell : C:\Users\<user>\<onedrive>\Documents\WindowsPowerShell\Microsoft.Powershell_profile.ps1
#

Write-Host "--"
$osname = (Get-WmiObject -class Win32_OperatingSystem).Caption
Write-Host "OS         : $($osname)"
Write-Host "OS version : $([System.Environment]::OSVersion.Version)"
Write-Host "PS profile : $($profile)"
Write-Host "PS path    : $((Get-Process powershell | Select-Object -First 1).path)"
Write-Host "PSHome     : $($PSHOME)"
Write-Host "PS version : $($host.version)"
Write-Host "Home       : $($HOME)"
Write-Host "User       : $(whoami)"
Write-Host "Host       : $(hostname)"
Write-Host ""
Write-Host "Script Location: $($PSScriptRoot)\$($MyInvocation.MyCommand)"
Write-Host "--"
$host.ui.RawUI.WindowTitle = "PS-$(whoami)"


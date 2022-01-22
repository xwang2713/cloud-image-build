<#

.SYNOPSIS
Top Script of Building HPCCSystems Hyper-V image

.DESCRIPTION

Usage:

.EXAMPLE

.NOTES
.LINK

#>

param(
    $version = $(Throw "Missing HPCCSystems version.")
)

$script_directory  = split-path $myInvocation.MyCommand.path
../cloud-image-build/packer/hyper-v/create-hpccvm.ps1 -version $version -url_prefix http://10.224.20.10/builds/
if ( ! ($?) ) { exit 1}

packer build hyperv.json
if ( ! ($?) ) { exit 1}

# Create zip file
#-----------------
$source = "${script_directory}/hpcc-vm"
$destination = "${script_directory}/HPCCSystemsVM-HyperV-${version}.zip"
If(Test-path $destination) {Remove-item $destination}
Add-Type -assembly "system.io.compression.filesystem"
[io.compression.zipfile]::CreateFromDirectory($Source, $destination) 


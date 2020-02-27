<#

.SYNOPSIS
Build HPCCSystems Hyper-V image

.DESCRIPTION

Usage:

.EXAMPLE

.NOTES
.LINK

#>

param(
    $version = $(Throw "Missing HPCCSystems version."),
    $arch="amd64",
    $codename="bionic",
    $ubuntu_user="hpccdemo",
    $ubuntu_passwd="hpccdemo",
    $output_dir="hpcc-vm",
    $base_dir="hpcc-base-vm",
    $url_prefix = "http://10.240.32.242/builds/",
    $download_dir="hpcc-systems/bionic",
    $configuration_version="8.0",
    $switch="External"
)
$vm_name="hpccvm64-${version}"
$script_directory  = split-path $myInvocation.MyCommand.path

@"
      Build HPCCSystems Hyper-V Image 
      -------------------------------
      Ubuntu         : $codename
      Arch           : $arch
      HPCC Version   : $version
"@

#-----------------------------------------------------------
# Download HPCCSystems packages
#-----------------------------------------------------------
Copy-Item $script_directory/hpcc-packages-downloader.ps1

$cmd = "./hpcc-packages-downloader.ps1 -version ${version} -codename ${codename}" + 
       " -arch ${arch} -download_dir $download_dir -url_prefix ${url_prefix}"
iex "$cmd ; `$err=`$?"
if ( ! ($?) ) { exit 1 }

#-----------------------------------------------------------
# Configure Packer build file from the template
#-----------------------------------------------------------
$directories_to_delete = "packer-cache", $output_dir
Foreach ($dir in $directories_to_delete)
{
  If (Test-Path -Path $dir)
  {
      Remove-Item -Path $dir -Force -Recurse
  }
}	
(Get-Content $script_directory/hyperv.json.in) | Foreach-Object {
    $_ -replace '@SSH_USER@', $ubuntu_user `
       -replace '@SSH_PASSWD@', $ubuntu_passwd `
       -replace '@VM_NAME@', $vm_name `
       -replace '@VM_BASE_DIR@', $base_dir `
       -replace '@OUTPUT_DIR@', $output_dir `
       -replace '@DOWNLOAD_DIR@', "${download_dir}/" `
       -replace '@ARCH@', $arch `
       -replace '@CODENAME@', $codename `
       -replace '@CONFIGURATION_VERSION@', $configuration_version `
       -replace '@SWITCH@', $switch
} | Set-Content hyperv.json

Copy-Item $script_directory/$codename/hpcc-${codename}-${arch}.sh

<#

.SYNOPSIS
Build HPCCSystems Hyper-V base image

.DESCRIPTION

Usage:

.EXAMPLE

.NOTES
.LINK

#>

param(
    $codename="bionic",
    $arch="amd64",
    $ubuntu_user="hpccdemo",
    $ubuntu_passwd="hpccdemo",
    $root_passwd="r00t@HPCCVM",
    $hostname="HPCCSystemVM-amd64",
    $vm_name="hpcc-bionic-base",
    $output_dir="hpcc-base-vm",
    $cpu=1,
    $memory=2048,
    $disk_size=40000,
    $iso_url="http://us.cdimage.ubuntu.com/releases/18.04/release/ubuntu-18.04.3-server-amd64.iso",
    $iso_checksum="cb7cd5a0c94899a04a536441c8b6d2bf",
    $switch="External",
	$configuration_version="8.0",
    $preseeds_dir="preseeds"


)

$script_directory  = split-path $myInvocation.MyCommand.path

@"
      Build HPCCSystems Hyper-V Image 
      -------------------------------
      Ubuntu         : $codename
      Arch           : $arch
      VM Name        : $vm_name
      CPU            : $cpu
      Memory         : $memory
      DISK Size (MB) : $disk_size
      ISO            : $iso_url

"@

#-----------------------------------------------------------
# Configure Packer build file from the template
#-----------------------------------------------------------
$directories_to_delete = "packer-cache","output",$preseeds_dir
Foreach ($dir in $directories_to_delete)
{
  If (Test-Path -Path $dir)
  {
      Remove-Item -Path $dir -Force -Recurse
  }
}	
(Get-Content $script_directory/hyperv-base.json.in) | Foreach-Object {
    $_ -replace '@SSH_USER@', $ubuntu_user `
       -replace '@SSH_PASSWD@', $ubuntu_passwd `
       -replace '@HOSTNAME@', $hostname `
       -replace '@VM_NAME@', $vm_name `
       -replace '@OUTPUT_DIR@', $output_dir `
       -replace '@CPU@', $cpu `
       -replace '@MEMORY@', $memory `
       -replace '@DISK_SIZE@', $disk_size `
       -replace '@ISO_URL@', $iso_url `
       -replace '@ISO_CHECKSUM@', $iso_checksum `
       -replace '@ARCH@', $arch `
       -replace '@CODENAME@', $codename `
	   -replace '@CONFIGURATION_VERSION@', $configuration_version `
       -replace '@PRESEEDS_DIR@', "./${preseeds_dir}" `
       -replace '@SWITCH@', $switch
} | Set-Content hyperv-base.json

If (!(Test-Path -Path $preseeds_dir)) 
{
    New-Item -ItemType directory -Path $preseeds_dir
}
(Get-Content ${script_directory}/${codename}/${preseeds_dir}/preseed_${codename}.cfg.in) | Foreach-Object {
    $_ -replace '@SSH_USER@', $ubuntu_user `
       -replace '@SSH_PASSWD@', $ubuntu_passwd `
       -replace '@ROOT_PASSWD@', $root_passwd
} | Set-Content ${preseeds_dir}/preseed_${codename}.cfg

Copy-Item $script_directory/$codename/hpcc-base-${codename}-${arch}.sh

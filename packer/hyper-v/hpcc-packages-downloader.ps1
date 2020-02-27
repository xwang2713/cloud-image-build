<#
.SYNOPSIS

.DESCRIPTION

.EXAMPLE

.NOTES

.LINK


#>
param(
   $codename = "bionic",
   $arch = "amd64",
   $download_dir='hpcc-systems/bionic',
   $url_prefix = "https://d2wulyp08c6njk.cloudfront.net/releases",
   $version = $(Throw "Missing HPCCSystems version.")
)
$ErrorActionPreference = "Stop"

$version_mmp = ${version}.split('-')[0]

$script_directory = split-path $MyInvocation.MyCommand.path

If (Test-Path -Path ${download_dir})
{
      Remove-Item -Path ${download_dir} -Force -Recurse
}

New-Item -ItemType Directory -Force -Path ${download_dir}
""
"Download Platform"
$platform = "hpccsystems-platform-community_${version}${codename}_${arch}.deb"
$url = "${url_prefix}/CE-Candidate-${version_mmp}/bin/platform/${platform}"

"Invoke-WebRequest -OutFile ${download_dir}/${platform} ${url}"
Invoke-WebRequest -OutFile ${download_dir}/${platform} ${url}

""
"Download Plugins"
$plugins = "couchbaseembed",
           "javaembed",
           "kafka",
           "memcached",
           "mysqlembed",
           "redis",
           "sqlite3embed",
           "sqs",
           "v8embed"
foreach ($plugin in $plugins)
{
    $plugin_filename =  "hpccsystems-plugin-${plugin}_${version}${codename}_${arch}.deb" 
    $url = "${url_prefix}/CE-Candidate-${version_mmp}/bin/plugins/${plugin_filename}"
    "Invoke-WebRequest -OutFile ${download_dir}/${plugin_filename} ${url}"
    Invoke-WebRequest -OutFile ${download_dir}/${plugin_filename} ${url}
}
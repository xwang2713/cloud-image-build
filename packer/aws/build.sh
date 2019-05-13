#!/bin/bash

SCRIPT_DIR=$(dirname $0)

# Functions
#----------------------------------
usage()
{
   echo ""
   echo "Usage build.sh -v <HPCC Version> [-r <regsion> | -i <region file>] [options] -c <codename>  "
   echo "   -a <value>: arch: amd64 or x86_64"
   echo "   -c <value>: Linux distro codename. For example, xential, trusty, el7"
   echo "   -i <value>: region file. One region per line."
   echo "   -n no run. Generate build script only."
   echo "   -p use subnet template for VPC setting."
   echo "   -r <value>: one region."
   echo "   -t <value>: amazone ec2 type: instance or ebs."
   echo "   -v <value>: HPCC Version. For example 6.4.24-1"
   echo ""
   exit
}

configure_file()
{

 sed "s|@HPCC_VERSION@|${hpcc_version}|g; \
      s|@CODENAME@|${codename}|g; \
      s|@ARCH@|${arch}|g; \
      s|@BUILD_TYPE@|${type}|g; \
      s|@SUBNET_ID@|${subnet_id}|g; \
      s|@BASE_AMI@|${base_ami}|g; \
      s|@AWS_REGION@|${region}|g"   < ${build_script_in} > ${build_script} 

}

run_packer_build()
{
  now=$(date -u +%Y%m%d-%H%M)
  log=ami-${region}-log-${now}.log
  num_of_build=$(expr $num_of_build \+ 1)
  build_script=ami-build-json-${region}
  base_ami=$(cat ${wk_dir}/${codename}/base-ami | grep ${region} | cut -d' ' -f2)
  subnet_id=$(cat ${wk_dir}/subnet-ids | grep ${region} | cut -d' ' -f2)
  
  configure_file

  [ "$dry_run_only" = "true" ] && return
  
  if [ "$quiet" = "true" ]
  then
     packer build ${build_script} > $log 2>&1
     rc=$?
  else
     echo ""
     echo "Build for $region with $build_script"
     packer build ${build_script} 2>&1 | tee -a $log ; rc=${PIPESTATUS[0]}

     # To debug usig following. When error happens the instance will be kept in AWS EC2 region instances
     # Use hpcc-build key file ssh to the instance to debug the problem
     #packer build -on-error=abort -debug ${build_script} 2>&1 | tee -a $log ; rc=${PIPESTATUS[0]}
  fi

  if [ ${rc} -eq 0 ] 
  then
     num_of_success=$(expr $num_of_success \+ 1)
     cat $log | tail -n 2 | head -n 1 >> ${ami_list}
  else
     num_of_failure=$(expr $num_of_failure \+ 1)
     echo "${region} $log" >> $err_file_list
  fi

}

# Variables
#----------------------------------
arch=amd64
hpcc_version=
codename=
type=instance
build_script=aws-build.json
region_file=
err_file_list=log_list
quiet=false

wk_dir=

num_of_failure=0
num_of_success=0
num_of_build=0
dry_run_only=false
use_subnet=false
log=

# Parse input parameters
#----------------------------------
while getopts "*a:c:d:i:npqr:t:v:" arg
do
    case "$arg" in
       a) arch="$OPTARG"
          ;;
       c) codename="$OPTARG"
          ;;
       i) region_file="$OPTARG"
          ;;
       n) dry_run_only=true
          ;;
       p) use_subnet=true
          ;;
       q) quiet=true
          ;;
       r) region="$OPTARG"
          ;;
       t) type="aws_$OPTARG"
          ;;
       v) hpcc_version="$OPTARG"
          ;;
       ?) usage
          ;;
    esac
done

# Check variables
#----------------------------------
[ -z "${wk_dir}" ] && wk_dir=${SCRIPT_DIR}


if [ -z ${hpcc_version} ]
then
   echo "Miss HPCC version." 
   exit 1
fi

ami_list="ami-${hpcc_version}"
[ -e ${ami_list} ] && rm -rf ${ami_list}

if [ -z ${codename} ]
then
   echo "Miss Linux codename. For example  xential, el7, etc." 
   exit 1
fi

if [ -z ${region} ] && [ -z ${region_file} ] 
then
   echo "Miss region. Provide either region with -r or region list file with -i." 
   exit 1
fi

if [ "$use_subnet" = "true" ]
then
   build_script_in=${wk_dir}/${type}/aws-build-vpc.json.in
else
   build_script_in=${wk_dir}/${type}/aws-build.json.in
fi

if [ ! -e ${build_script_in} ]
then
   echo "Cannot find build script template ${build_script_in}" 
   exit 1
fi

type="amazon-$type"
cp ${wk_dir}/${codename}/*.sh .

[ -e ${err_file_list} ] && rm -rf ${err_file_list}

# Build AMI 
#----------------------------------
if [ -n "$region" ] 
then
   run_packer_build
else
  if [ ! -e ${region_file} ]
  then
     echo "Region file $region_file doesn't exists"
     exit 1
  fi

  for line in $(cat ${region_file} )
  do 
    line=$(echo $line | sed 's/[[:space:]]//g')
    [[ $line == \#* ]] && continue
    region=$(echo $line | cut -d' ' -f1 )
    run_packer_build 
  done

fi

[ "$dry_run_only" = "true" ] && exit 0

# Summary
#----------------------------------
echo ""
echo "  Total number of region build: $num_of_build"
echo "  Total number of sucess      : $num_of_success"
echo "  Total number of failure     : $num_of_failure"
echo ""

if [ ${num_of_failure} -gt 0 ]
then
   echo "Error logs:"
   cat ${err_file_list}
   echo ""
fi

if [ ${num_of_success} -gt 0 ]
then
  echo "Generated AMI list:"
  cat ${ami_list}
  echo ""
fi

# End
#----------------------------------

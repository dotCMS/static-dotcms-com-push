#!/bin/bash

bucket='static.dotcms.com'
type="$1"
version="$2"
aws_access_key_id="$3"
aws_secret_access_key="$4"
aws_folder=/root/.aws
aws_region='us-west-1'
test_run=$5
target_base='./dist-output'
test_prefix='vico'
distro_base_key='versions'
javadoc_base_key="docs/${version}/javadocs"
if [[ ${test_run} == true ]]; then
  distro_base_key="${test_prefix}/${distro_base_key}"
  javadoc_base_key="${test_prefix}/${javadoc_base_key}"
fi

export AWS_EC2_METADATA_DISABLED=true

mkdir ${aws_folder} && chmod 755 ${aws_folder}
echo "[default]
aws_access_key_id=${aws_access_key_id}
aws_secret_access_key=${aws_secret_access_key}" > ${aws_folder}/credentials
echo "[default]
region=${aws_region}
output=json" > ${aws_folder}/config

chmod 644 ${aws_folder}/*
ls -las ${aws_folder}
cat ${aws_folder}/*

function s3Push {
  local key=$1
  local object=$2
  
  echo "
  
  
  
  
  
######################################################################"
  ls -las ${object}
  echo "Executing: /usr/local/bin/aws s3 ls ${bucket}/${key}"
  /usr/local/bin/aws --debug s3 ls ${bucket}/${key}  
  
  #echo "Executing: /usr/local/bin/aws s3api put-object --bucket ${bucket} --key ${key} --body ${object}"
  #/usr/local/bin/aws --debug s3api put-object --bucket ${bucket} --key ${key} --body ${object}
  #echo "Executing: /usr/local/bin/aws s3 ls ${bucket}/${key}"
  #/usr/local/bin/aws --debug s3 ls ${bucket}/${key}
}

function pushDistro {
  local ext=$1
  local distro_file="dotcms_${version}.${ext}"
  s3Push ${distro_base_key}/${distro_file} ${target_base}/${distro_file}
}

function pushJavadoc {
  s3Push ${javadoc_base_key} ./buils/docs/javadoc
}

/usr/local/bin/aws --version
#route add blackhole 169.254.169.254

case "${type}" in
  distro)
    pushDistro 'tar.gz'
    #pushDistro 'zip'
    ;;
  javadoc)
    pushJavadoc 
    ;;
  all)
    pushDistro 'tar.gz'
    pushDistro 'zip'
    pushJavadoc
    ;;
  *)
    echo "Invalid type, it should be 'distro', 'javadoc' or 'all'"
    exit 1
    ;;
esac

#route del blackhole 169.254.169.254

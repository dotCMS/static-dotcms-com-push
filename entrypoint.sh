#!/bin/bash

bucket='static.dotcms.com'
type=$1
test_run=$2
version="${DOTCMS_VERSION}"
aws_access_key_id="${AWS_ACCESS_KEY_ID}"
aws_secret_access_key="${AWS_SECRET_ACCESS_KEY}"

target_base='./dist-output'
test_prefix='vico'
distro_base_key='versions'
javadoc_base_key="docs/${version}/javadocs"
if [[ ${test_run} == true ]]; then
  distro_base_key="${test_prefix}/${distro_base_key}"
  javadoc_base_key="${test_prefix}/${javadoc_base_key}"
fi

function s3Push {
  local key=$1
  local object=$2
  
  echo "
  
  
  
  
  
######################################################################"
  ls -las ${object}
  echo "Executing: /usr/local/bin/aws s3 ls ${bucket}/${key}"
  aws s3 ls ${bucket}/${key}  
  echo "Executing: /usr/local/bin/aws s3api put-object --bucket ${bucket} --key ${key} --body ${object}"
  aws s3api put-object --bucket ${bucket} --key ${key} --body ${object}
  echo "Executing: /usr/local/bin/aws s3 ls ${bucket}/${key}"
  aws s3 ls ${bucket}/${key}
}

function pushDistro {
  local ext=$1
  local distro_file="dotcms_${version}.${ext}"
  s3Push ${distro_base_key}/${distro_file} ${target_base}/${distro_file}
}

function pushJavadoc {
  s3Push ${javadoc_base_key} ./buils/docs/javadoc
}

case "${type}" in
  distro)
    pushDistro 'tar.gz'
    pushDistro 'zip'
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

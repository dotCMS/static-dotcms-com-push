#!/bin/bash

bucket='static.dotcms.com'
type="$1"
version="$2"
aws_access_key_id="$3"
aws_secret_access_key="$4"

ls -las /root
echo "[default]
aws_access_key_id=${aws_access_key_id}
aws_secret_access_key=${aws_secret_access_key}" > /root/.aws/credentials

case "${type}" in
  distro)
    targz_distro_file="dotcms_${version}.tar.gz"
    zip_distro_file="dotcms_${version}.zip"
    base_key='/versions/'
    target_base='./dist-output/'
    
    key="${base_key}/${targz_distro_file}"
    object="${target_base}/${targz_distro_file}"
    /usr/local/bin/aws put-object --bucket ${bucket} --key ${key} --body ${object}

    key="${base_key}/${zip_distro_file}"
    object="${target_base}/${zip_distro_file}"
    /usr/local/bin/aws put-object --bucket ${bucket} --key ${key} --body ${object}
    ;;
  javadoc)
    key="docs/${version}/javadocs"
    object="./buils/docs/javadoc"
    /usr/local/bin/aws put-object --bucket ${bucket} --key ${key} --body ${object}
    ;;
  *)
    echo "Invalid type, should be 'distro' or 'javadoc'"
    exit 1
    ;;
esac

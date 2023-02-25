#!/bin/bash
target_dir=${1:-.}
volume_id=$(isoinfo -d -i /dev/sr0 | grep 'Volume id' | awk -F " " '{print $NF}')
mkv_outdir="${target_dir}/${volume_id}"

mkdir -p $mkv_outdir &&
makemkvcon --robot --minlength=600 --noscan mkv dev:/dev/sr0 all $mkv_outdir
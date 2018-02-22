#!/usr/bin/env bash

if [ $# -ne 4 ]; then
    echo "usage ${0} in_dir out_dir num_files";
    exit -1;
fi

function mp4_2_wav {
    in_dir=${1}
    out_dir=${2}
    num_files=${3}
    mkdir -p ${out_dir}
    #for mp4_file in ${in_dir}*.mp4
    for mp4_file in  $(ls ${in_dir}*.mp4 | head -n ${num_files})
    do
        printf "converting %s\n" ${mp4_file}
        file_name=$(basename ${mp4_file})
        fname=${file_name%.*}
        ffmpeg -i ${mp4_file} -vn -acodec pcm_s16le -ac 1 -ar 16000 ${out_dir}/${fname}.wav
    done
}

mp4_2_wav ${1} ${2} ${3}

echo "done!"

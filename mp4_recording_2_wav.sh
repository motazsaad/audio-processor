#!/usr/bin/env bash



function mp4_2_wav {
    in_dir=${1}
    out_dir=${2}
    mkdir -p ${out_dir}
    for mp4_file in ${in_dir}*.mp4
    do
        printf "converting %s\n" ${mp4_file}
        file_name=$(basename ${mp4_file})
        fname=${file_name%.*}
        ffmpeg -i ${mp4_file} -vn -acodec pcm_s16le -ac 1 -ar 16000 ${out_dir}/${fname}.wav
    done
}

echo "done!"

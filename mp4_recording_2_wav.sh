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

jsc=/storage/recordings/2713/
mbc1=/storage/recordings/2769/
alarabiya=/storage/recordings/18396/
emarat_fm=/storage/recordings/3289/

recording_date=2017/11/01/
out=wav_2017_11_01/

mp4_2_wav ${jsc}${recording_date} ${out}
mp4_2_wav ${mbc1}${recording_date} ${out}
mp4_2_wav ${alarabiya}${recording_date} ${out}
mp4_2_wav ${emarat_fm}${recording_date} ${out}

echo "done!"

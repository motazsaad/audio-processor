#!/usr/bin/env bash
#echo ${#}
if [ $# -ne 1 ]; then
    echo "usage ${0} in_dir";
    exit -1;
fi

function make_wav_list {
    in_dir=${1}
    mkdir -p ${out_dir}
    for wav_file in ${in_dir}*.wav
    do
        duration=$(sox --i -D "$file")
        printf "%s\t%s" ${wav_file} ${duration}
    done
}

make_wav_list ${1} ${2}

echo "done!"

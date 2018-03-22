#!/usr/bin/env bash
#echo ${#}
if [ $# -ne 1 ]; then
    echo "usage: ${0} in_dir";
    exit -1;
fi

function make_wav_list {
    in_dir=${1}
    for wav_file in ${in_dir}*.wav
    do
        duration=$(sox --i -D "$wav_file")
        file_name=$(basename ${wav_file})
        printf "%.1f\t%s\n" ${duration} ${file_name}
    done
}

# call the function with CLI args 
make_wav_list ${1}

echo "done!"

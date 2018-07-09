#!/usr/bin/env bash


# after many experiments (0.3, 0.4, 0.5), 0.4 is the best 
in_dir=mp4
out_dir=wav
mkdir -p ${out_dir}
rm ${out_dir}/*.wav
for mp4_file in  ${in_dir}/*.mp4 
do
printf "converting %s\n" ${mp4_file}
file_name=$(basename ${mp4_file})
fname=${file_name%.*}
ffmpeg -i ${mp4_file} -vn -acodec pcm_s16le -ac 1 -ar 16000 ${out_dir}/${fname}.wav
done
###############################################
rm *_20180*/*.wav 
###############################################
for wav_file in ${out_dir}/*.wav
do 
dir_name=$(basename ${wav_file})
mkdir -p ${dir_name}
done 

###############################################
sil="0.4"
echo "" > t_${sil}.txt
for wav_file in ${out_dir}/*.wav
do
dir_name=$(basename ${wav_file})
python split_wav.py ${wav_file} -o ${dir_name}/ -m ${sil}
python wave_info.py -i ${dir_name} >> t_${sil}.txt
done 


grep 'average' t_${sil}.txt
grep 'of files' t_${sil}.txt




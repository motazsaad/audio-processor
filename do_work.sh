#!/usr/bin/env bash


# after many experiments (0.3, 0.4, 0.5), 0.4 is the best 
# after more expreiments, we try 0.25 
# after many experiments, 0.5 is the best with the other parameters for split_wav.py
in_dir=mp4
out_dir=wav
if [ ! -d "$in_dir" ]; then
# Control will enter here if $in_dir doesn't exist.
echo "mp4 directory does not exist";
exit -1;
fi
###############################################

###############################################
# clean wav dir 
rm ${out_dir} -rf 
# start conversion 
mkdir ${out_dir}
for mp4_file in  ${in_dir}/*.mp4 
do
printf "converting %s\n" ${mp4_file}
file_name=$(basename ${mp4_file})
fname=${file_name%.*}
ffmpeg -i ${mp4_file} -vn -acodec pcm_s16le -ac 1 -ar 16000 ${out_dir}/${fname}.wav
done
###############################################
# clean previous split 
rm *_20180*/ -rf
# create a dir for each big wav file 
for wav_file in ${out_dir}/*.wav
do 
dir_name=$(basename ${wav_file})
mkdir -p ${dir_name}
done 

###############################################
# after many experiments, these are the best parameters to get segments between 20s and 60s 
sil="0.5" # 'The minimum length of silence at which a split may occur [seconds]. Defaults to 3 seconds.'
energy_level="0.0001" # 'The energy level (between 0.0 and 1.0) below which the signal is regarded as silent. Defaults to 1e-6 == 0.0001%.'
step_duration="0.03" # 'The amount of time to step forward in the input file after calculating energy. Smaller value = slower, but more accurate silence detection. Larger value = faster, but might miss some split opportunities. Defaults to (min-silence-length / 10.).'

logfile=${sil}_${energy_level}_${step_duration}.txt
echo "" > ${logfile}
for wav_file in ${out_dir}/*.wav
do
dir_name=$(basename ${wav_file})
source ~/py3env/bin/activate 
python split_wav.py ${wav_file} -o ${dir_name}/ -m ${sil} -t ${energy_level} -s ${step_duration}
#python split_wav.py ${wav_file} -o ${dir_name}/ -m ${sil} -t ${energy_level}
#python split_wav.py ${wav_file} -o ${dir_name}/ -m ${sil}
python wave_info.py -i ${dir_name} >> ${logfile}
done 


grep 'average' ${logfile}
grep 'of files' ${logfile}


grep 'average' ${logfile} > summary_${logfile}
grep 'of files' ${logfile} >> summary_${logfile}



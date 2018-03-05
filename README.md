# audio-processor
process audio files (convert to wav format, split wave, ....)

* Audio files are converted into wav format using ffmpeg command 
* Wave files are split using pydub python library 
* Wave files list and their durations are generated using bash script and sox command 

# wave_splitter.py 
```
usage: wave_splitter.py [-h] -i INDIR -o OUTDIR -s {fixed,silence}
```
The following arguments are required: -i/--indir, -o/--outdir, -s/--split

# mp4_recording_2_wav.sh
```
usage: mp4_recording_2_wav.sh in_dir out_dir num_files
```

# wav_list.sh
```
usage: wav_list.sh in_dir
```

## How to contribute
Your contributions to improve the code are welcomed. Please follow the steps below.
1. Fork the project.
2. Modify the code, test it, make sure that it works fine. 
3. Make a pull request.

Please consult [github help](https://help.github.com/) to get help.
import argparse
import datetime
import glob
import os

from pydub import AudioSegment
from pydub import silence
from pydub import utils as dubutils

# silence_thresh
# anything quieter than this will be considered silence.
# default: -16dBFS
# the value below is determined by trail and error on recordings 
# You can try different values on your recordings to get the best value 
threshold = -36 

# split the 10min into chunks (25sec each one)
# 25 sec * 24 parts = 10 min ; 24 parts / 8 cpus
my_chunk_length = 25000 # 25000 milli-seconds (25 seconds)

my_min_silence_len = 1000  # 450  # min_silence_len default: 1000ms
my_keep_silence = 100  # 350  # keep_silence default: 100ms


def split_wav_on_silence(audio_seg):
    thr = threshold
    print('silence thresh: {}\tkeep silence: {}\tmin_silence_len: {}'.format(thr, my_keep_silence,
                                                                             my_min_silence_len))
    nuggets = silence.split_on_silence(audio_seg, silence_thresh=thr,
                                       keep_silence=my_keep_silence,
                                       min_silence_len=my_min_silence_len)
    return nuggets


def export_chunks(nuggets, wave_file, out_dir):
    print('number of chucks:{}'.format(len(nuggets)))
    base_name = os.path.basename(wave_file).replace('.wav', '')
    if out_dir[-1] == '/':
        out_dir = out_dir[:-1]
    for i, chunk in enumerate(nuggets):
        out_file = "{}/{}_{}.wav".format(out_dir, base_name, str(i).zfill(2))
        print('out file:', out_file)
        chunk.export(out_file, format="wav")


parser = argparse.ArgumentParser(description='wave splitter (split wave sound into chuncks'
                                             'based on silence or fixed intervals')
parser.add_argument('-i', '--indir', type=str,
                    help='input wave dir', required=True)
parser.add_argument('-o', '--outdir', type=str,
                    help='output directory', required=True)
parser.add_argument('-s', '--split', type=str, choices=['fixed', 'silence'],
                    help='split mode', required=True)

if __name__ == '__main__':
    args = parser.parse_args()
    wav_list = sorted(glob.glob(os.path.join(args.indir, '*.wav')))
    for wav_file in wav_list:
        print('processing', wav_file)
        my_audio_segment = AudioSegment.from_wav(wav_file)
        print('wave duration: {}'.format(datetime.timedelta(seconds=my_audio_segment.duration_seconds)))
        if args.split == 'silence':
            chunks = split_wav_on_silence(my_audio_segment)
        elif args.split == 'fixed':
            chunks = dubutils.make_chunks(audio_segment=my_audio_segment, 
            chunk_length=my_chunk_length)
        out = args.outdir
        export_chunks(chunks, wav_file, out)
        print('done!')

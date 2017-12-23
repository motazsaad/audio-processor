import argparse
import datetime
import io
import os
import shutil
import glob

from pydub import AudioSegment
from pydub import silence
from pydub import utils as dubutils

# silence_thresh
# anything quieter than this will be considered silence.
# default: -16dBFS
threshold = -36

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
    base_name, ext = os.path.basename(wave_file).split('.')
    if not os.path.exists(os.path.join('out_dir', base_name)):
        print("making ", os.path.join('out_dir', base_name))
        os.mkdir(os.path.join('out_dir', base_name))
    else:
        print("removing ", os.path.join('out_dir', base_name))
        shutil.rmtree(os.path.join('out_dir', base_name))
        print("making ", os.path.join('out_dir', base_name))
        os.mkdir(os.path.join('out_dir', base_name))
    for i, chunk in enumerate(nuggets):
        out_file = "{}/{}/{}_{}.wav".format(out_dir, base_name, base_name, str(i).zfill(2))
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
        audio_segment = AudioSegment.from_wav(wav_file)
        print('wave duration: {}'.format(datetime.timedelta(seconds=audio_segment.duration_seconds)))
        if args.split == 'silence':
            chunks = split_wav_on_silence(audio_segment)
        elif args.split == 'fixed':
            # split the 10min into chunks (25sec each one)
            # 25 sec * 24 parts = 10 min ; 24 parts / 8 cpus
            chunks = dubutils.make_chunks(audio_segment, 25000)
        print('number of chucks:{}'.format(len(chunks)))
        out = args.outdir
        export_chunks(chunks, wav_file, out)

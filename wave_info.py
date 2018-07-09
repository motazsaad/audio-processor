import wave
import contextlib
import os 

import argparse

parser = argparse.ArgumentParser(description='collect info about wav files')
parser.add_argument('--input-dir', '-i', type=str, default='.', help='The input folder. Defaults to the current folder.')

args = parser.parse_args()

indir = args.input_dir
onlyWavfiles = [os.path.join(indir, f) for f in os.listdir(indir) if os.path.isfile(os.path.join(indir, f))]
#print(onlyWavfiles)
average = 0.0
greater_than_60 = 0
less_than_20 = 0
for fname in onlyWavfiles:
	#print("fname: {}".format(fname))
	with contextlib.closing(wave.open(fname,'r')) as f:
		frames = f.getnframes()
		rate = f.getframerate()
		duration = frames / float(rate)
		if duration > 60: greater_than_60 +=1
		if duration < 20: less_than_20 +=1 	 
		print("{0}\t{1:.1f} secs".format(fname.split('/')[1], duration))
		average = average + duration 
average = average / len(onlyWavfiles)	
print("average duration for {0}: {1:.1f} secs".format(indir, duration))
print("# of files for {}: {}".format(indir, len(onlyWavfiles)))
print("# of files for {} that are longer than 60s: {}".format(indir, greater_than_60))
print("# of files for {} that are shorter than 20s: {}".format(indir, less_than_20))
print("--------------------------------------------")


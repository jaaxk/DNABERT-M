from Bio import SeqIO
import math
import os

input_files = ['all_species_sequences_oral.fna', 'all_species_sequences_vag.fna', 'all_species_sequences_uhgg.fna']
subseq_length = 1000
out_file = './full_dataset.fasta'
if os.path.exists('out_file'):
    os.remove('out_file')
log_step = 10000

skipped = 0
count = 0
num_N = 0

with open(out_file, 'w') as outfile:
    for infile in input_files:
        with open(infile, 'r') as fastafile:
            for record in SeqIO.parse(fastafile, 'fasta'):
                seq = str(record.seq)

                #skip seqs <subseq_length
                if len(seq) < subseq_length:
                    skipped+=1
                    continue

                #remove Ns
                if 'N' in seq:
                    seq.replace('N', '')
                    num_N += 1

                #get subsequences of length subseq_length
                for subseq in range(math.floor(len(seq) / subseq_length)):
                    subsequence = seq[subseq_length*subseq : subseq_length*(subseq+1)] + '\n'
                    outfile.write(f'>sequence_{count}\n{subsequence}\n')
                    count+=1


                    if count % log_step == 0:
                        print(f'Wrote {count} subsequences', end='\r')

print(f'Complete! Wrote {count} lines, removed {num_N} Ns, and skipped {skipped} contigs for being too short')

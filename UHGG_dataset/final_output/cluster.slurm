#!/bin/bash
#SBATCH -p long-96core
#SBATCH --time 48:00:00
#SBATCH --output res.txt
#SBATCH --cpus-per-task 96
#SBATCH --mem 250G

mmseqs easy-cluster full_dataset.fasta clusteredDB tmp --min-seq-id 0.8 --cov-mode 1 -c 0.8 --threads 96 -v 3

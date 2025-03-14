#!/bin/bash
#SBATCH --job-name=my_job                # Name of the job
#SBATCH --output=res.txt                 # Output file for the job
#SBATCH --time=48:00:00                  # Time limit for the job (48 hours)
#SBATCH --partition=a100-long            # Partition to use (a100-long node)
#SBATCH --gres=gpu:4                     # Request 4 GPUs
#SBATCH --nodes=1                        # Request 1 node

cd /gpfs/scratch/jvaska/DNABERT-M
source dnabertm_venv/bin/activate

python run_mlm.py \
--model_type bert \
--tokenizer_name zhihan1996/DNABERT-2-117M \
--train_file ./full_dataset_filtered.txt \
--config_overrides ./config.json \
--output_dir ./output \
--do_train True \
--line_by_line True \
--max_seq_length 512 \
--per_device_train_batch_size 16 \
--learning_rate 5e-5 \
--num_train_epochs 3 \
--save_steps 1000 \
--logging_dir ./logs \
--overwrite_output_dir True \
--cache_dir ./cache \
--fp16

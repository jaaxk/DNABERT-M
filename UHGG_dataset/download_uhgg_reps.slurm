#!/bin/bash
#SBATCH --job-name=download_uhgg
#SBATCH --partition=long-96core
#SBATCH --time=48:00:00
#SBATCH --nodes=1
#SBATCH --cpus-per-task=40
#SBATCH --output=res_uhgg.txt
#SBATCH --error=uhgg_download_%j.err

module load wget

# Set FTP base URL for species_catalogue
FTP_URL="ftp://ftp.ebi.ac.uk/pub/databases/metagenomics/mgnify_genomes/human-gut/v2.0.2/species_catalogue/"

# Create necessary directories
rm -rf downloaded_fna_uhgg
mkdir -p downloaded_fna_uhgg final_output

echo "Starting download of .fna files from $FTP_URL..."
wget -r -np -nH --cut-dirs=6 -A "*.fna" --reject "pan-genome.fna" --no-directories -P downloaded_fna_uhgg -q "$FTP_URL" 2>&1 | tee download.log &

# Simple progress tracker
while pgrep -x wget > /dev/null; do
    sleep 600  # Update progress every 10 minutes
    count=$(find downloaded_fna_uhgg/ -type f -name "*.fna" ! -name "*.fna.fai" | wc -l)
    echo "$(date): Downloaded so far: $count files..."
done

# Final count of downloaded files
downloaded_files=$(find downloaded_fna_uhgg/ -type f -name "*.fna" ! -name "*.fna.fai" | wc -l)
echo "Downloaded $downloaded_files .fna files (Expected: 4,744)."

if [ "$downloaded_files" -ne 4744 ]; then
    echo "WARNING: Expected 4,744 files, but found $downloaded_files!"
fi

echo "Concatenating extracted sequences into a single file..."
FINAL_FASTA="final_output/all_species_sequences_uhgg.fna"
> "$FINAL_FASTA"

count=0
find downloaded_fna_uhgg/ -type f -name "*.fna" ! -name "*.fna.fai" | while read -r fna_file; do
    file_base=$(basename "$fna_file" .fna)
    echo ">$file_base" >> "$FINAL_FASTA"
    cat "$fna_file" >> "$FINAL_FASTA"

    # Progress update every 500 files
    ((count++))
    if (( count % 500 == 0 )); then
        echo "$(date): Processed $count files..."
    fi
done

echo "Counting the total number of 'N' nucleotides..."
N_count=$(grep -o "N" "$FINAL_FASTA" | wc -l)
echo "Total number of 'N' nucleotides: $N_count"

echo "Script completed successfully!"


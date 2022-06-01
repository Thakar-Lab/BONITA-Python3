#!/bin/sh
#SBATCH --partition=standard
#SBATCH -a 1-5
#SBATCH -J GArun
#SBATCH -o GA_out_%A_%a.txt
#SBATCH -t 96:00:00
#SBATCH -n 1
#SBATCH -c 1

module load anaconda3/2020.11
activate BONITA
python pathway_analysis_score_nodes.py $1 $SLURM_ARRAY_TASK_ID
echo "BONITA complete"

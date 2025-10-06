#!/bin/bash
#SBATCH --job-name=T30w50    
#SBATCH --account=gito_earth
#SBATCH --partition=gito_earth 
#SBATCH --time=2-00:00:00 ## time format is DD-HH:MM:SS

#SBATCH --cpus-per-task=1
#SBATCH --ntasks=64 # nodes have 40 to 48 physical cores, so ask for 2 nodes with this number of tasks.
#SBATCH --nodes=2
#SBATCH --mem=78G
#SBATCH --tasks-per-node=32

#SBATCH --distribution="*:*:*"  # Set the distribution to defaults if doing sbatch from interactive session

#SBATCH --error=hello-%A.err ## %A - filled with jobid
#SBATCH --output=hello-%A.out ## %A - filled with jobid

## Useful for remote notification
#SBATCH --mail-type=END,FAIL,REQUEUE
#SBATCH --mail-user=gito@hawaii.edu

# unset these variables so submission via interactive sessions do not cause problems
unset SLURM_CPU_BIND_VERBOSE SLURM_CPU_BIND_LIST SLURM_CPU_BIND_TYPE SLURM_CPU_BIND

module purge
# build the application
module load toolchain/intel/2022b
module load numlib/PETSc/3.18.5-intel-2022b-mumps

# Configure the Intel MPI parameters
# https://www.intel.com/content/www/us/en/docs/mpi-library/developer-reference-linux/2021-9/overview.html
#export I_MPI_PIN_RESPECT_CPUSET=0
#export I_MPI_FABRICS=shm:ofi
export I_MPI_PMI_LIBRARY=/lib64/libpmi.so

# Prepare and execute the MPI application
date > log
#srun -n ${SLURM_NTASKS} ~/LaMEM_github/bin/opt/LaMEM -Paramfile input.dat >> log
srun -n ${SLURM_NTASKS} ~/LaMEM_github/bin/opt/LaMEM_save -Paramfile input.dat -mode restart >> log
date >> log


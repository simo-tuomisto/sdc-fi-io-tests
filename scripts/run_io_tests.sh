#!/bin/bash

# Set the script to fail, if something fails
set -euo pipefail

# If the number of arguments is less than three, quit

if [ "$#" -lt 3 ]; then
	echo -n '
    usage: bash '$0' JOB_NAME STARTJOBS MAXJOBS EXTRA_SLURM_PARAMETERS

    example: bash '$0' fio-seq-RW 1 8 --exclusive -c 4

'
  exit 1
fi

# Set JOBNAME to be the test name we want to run (e.g. fio-rand-read)
JOBNAME=$1
# Set the starting index
STARTJOBS=$2
# Set the maximum index
MAXJOBS=$3
# Get extra parameters
EXTRA_PARAMETERS=${@:4}

# Verify that JOBID is unset
unset JOBID
# For each job, submit a new slurm script
for NJOBS in $(seq $STARTJOBS $MAXJOBS); do
	if [[ ! -v JOBID ]]; then
    # If job is the first to be submitted, submit it and capture JOBID
		JOBID=$(sbatch --array=1-${NJOBS} --output=../outputs/${JOBNAME}-${NJOBS}_%a.out ${EXTRA_PARAMETERS} run_io_test.slrm ${JOBNAME} ${NJOBS} | awk '{ print $NF }')
	else
    # Submit a job with dependency on the previous job (job with id JOBID). Capture JOBID for next job in the series.
		JOBID=$(sbatch --array=1-${NJOBS} --output=../outputs/${JOBNAME}-${NJOBS}_%a.out --dependency=afterok:$JOBID ${EXTRA_PARAMETERS} run_io_test.slrm ${JOBNAME} ${NJOBS} | awk '{ print $NF }')
	fi
done

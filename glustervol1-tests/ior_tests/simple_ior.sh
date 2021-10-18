#!/bin/bash -l
#SBATCH --time=02:00:00
#SBATCH --nodes=4
#SBATCH --ntasks-per-node=6
#SBATCH --mem=96G
#SBATCH --output=simple-ior-user.out
#SBATCH --wait-all-nodes=1

source ~/spack/share/spack/setup-env.sh

spack load -r ior

which ior

TEST_DIR=${PWD}/simple-ior-user

echo 'Running ior to '$TEST_DIR

ITERATIONS=5

echo 'Iterations: '$ITERATIONS

mkdir -p $TEST_DIR

srun --cpu-freq=high --hint=compute_bound ior -w -k -r -m -v -a POSIX -i $ITERATIONS -b 22906142720 -t 1048576 -e -g -C -F -o ${TEST_DIR}/IOR_File.bin

#rm -r ${TEST_DIR}

#!/bin/bash -l
#SBATCH --time=02:00:00
#SBATCH --nodes=4
#SBATCH --ntasks-per-node=6
#SBATCH --mem=96G
#SBATCH --output=simple-mdtest-user-%j.out
#SBATCH --wait-all-nodes=1

source ~/spack/share/spack/setup-env.sh

spack load -r ior

which mdtest

TEST_DIR=${PWD}/simple-mdtest-user

echo 'Running mdtest to '$TEST_DIR

ITERATIONS=5

echo 'Iterations: '$ITERATIONS

mkdir -p $TEST_DIR

srun --cpu-freq=high --hint=compute_bound mdtest -F -v -v -p 10 -d $TEST_DIR -i $ITERATIONS -n 10000 -u -e 16384 -w 16384 -N 1

#rm -r ${TEST_DIR}

# SDC-FI IO tests

## Requirements

The tests are done with fio io tester. It can be obtained
[here](https://github.com/axboe/fio)

The output is by default saved in json+ output. Some older versions of fio do
not have this format. See
[fio documentation](https://fio.readthedocs.io/en/latest/fio_doc.html#id1)
for information on the format.

The default way of running the script is done using Slurm scheduler, so that
the load is bit more representative of actual cluster load. To run them without
Slurm modify the `scripts/run_io_test.slrm`-script to your liking.

## Usage

To run these io tests clone this repository to file system you want to measure.

After this go to the scripts-folder and run

```sh
bash run_io_tests.sh <test> <start index> <end index>
```

This will submit `<end index>` - `<start index>` slurm array jobs that will
run in a series.

E.g:
```sh

bash run_io_tests.sh fio-seq-read 4 6
```
would run `fio-seq-read` test with 4,5 and 6 workers.

To increase the load you can also add slurm flags to the end

```sh
bash run_io_tests.sh <test> 1 8 --exclusive -c 4
```

This would run the test with 1 to 8 tasks, where each task is allocated their
own node. The `-c 4` flag that specifies the number of cpus/task is captured
by the runtime script and each task would run the io test with 4 cpus. Thus
the overall load would be from 4 to 32 cpus with an increment of 4 cpus.

## Tests

Available tests include:
- fio-seq-read - Sequential read test
- fio-seq-write - Sequential read test
- fio-rand-read - Random read test
- fio-rand-write - Random read test

In tests each array task will create a 20GB file that will be accessed in the
fashion described in the 

More tests are available
[here](https://github.com/axboe/fio/tree/master/examples).

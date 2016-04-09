
export LD_LIBRARY_PATH=$PWD:$LD_LIBRARY_PATH

LD_PRELOAD=$PWD/libmalloc.so ./test
#gdb ./test


unset LD_LIBRARY_PATH

CC ?= gcc
CRYSTAL ?= crystal
CRYSTALFLAGS ?= --release
CFLAGS ?= -O2

.PHONY: all
all: all_spec bench example bench_cpp bench_native

all_spec: *.cr spec/*.cr libhttp_parser.so
	LIBRARY_PATH=`pwd` LD_LIBRARY_PATH=`pwd` $(CRYSTAL) spec/all_spec.cr $(CRYSTALFLAGS) -o $@

bench: *.cr benchmark/bench.cr libhttp_parser.so
	LIBRARY_PATH=`pwd` LD_LIBRARY_PATH=`pwd` $(CRYSTAL) benchmark/bench.cr $(CRYSTALFLAGS) -o $@
	
bench_cpp: benchmark/cpp/bench.cpp http_parser.o
	$(CC) $(CFLAGS) $< http_parser.o -o $@ -lstdc++

bench_native: benchmark/native_bench.cr
	$(CRYSTAL) $< $(CRYSTALFLAGS) -o $@

example: *.cr examples/example.cr libhttp_parser.so
	LIBRARY_PATH=`pwd` LD_LIBRARY_PATH=`pwd` $(CRYSTAL) examples/example.cr $(CRYSTALFLAGS) -o $@

libhttp_parser.so: http_parser.o
	$(CC) $< -shared -o $@

http_parser.o: http-parser/http_parser.c http-parser/http_parser.h
	$(CC) $(CFLAGS) $< -o $@ -c -fPIC

.PHONY: clean
clean:
	rm -f example bench all_spec bench_cpp bench_native *.o *.so

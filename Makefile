CC ?= gcc
CRYSTAL ?= crystal
CRYSTALFLAGS ?= --release
CFLAGS ?= -O2

.PHONY: all
all: all_spec bench example bench_cpp bench_native

./http-parser:
	        git clone --depth 1 git://github.com/joyent/http-parser.git ./http-parser

all_spec: *.cr src/*.cr spec/*.cr libhttp_parser.so
	LIBRARY_PATH=. $(CRYSTAL) spec/all_spec.cr $(CRYSTALFLAGS) -o $@

bench: *.cr src/*.cr benchmark/bench.cr libhttp_parser.so
	LIBRARY_PATH=. $(CRYSTAL) benchmark/bench.cr $(CRYSTALFLAGS) -o $@
	
bench_cpp: benchmark/cpp/bench.cpp http_parser.o
	$(CC) $(CFLAGS) $< http_parser.o -o $@ -lstdc++

bench_native: benchmark/native_bench.cr
	$(CRYSTAL) $< $(CRYSTALFLAGS) -o $@

example: *.cr src/*.cr examples/example.cr libhttp_parser.so
	LIBRARY_PATH=. $(CRYSTAL) examples/example.cr $(CRYSTALFLAGS) -o $@

libhttp_parser.so: http_parser.o
	$(CC) $< -shared -o $@

http_parser.o: ./http-parser http-parser/http_parser.c http-parser/http_parser.h
	$(CC) $(CFLAGS) http-parser/http_parser.c -o $@ -c -fPIC

.PHONY: clean
clean:
	rm -f example bench all_spec bench_cpp bench_native *.o *.so

CRYSTAL ?= crystal
CRYSTALFLAGS ?= --release
CFLAGS ?= -O2

.PHONY: all package
all: bench example bench_cpp bench_native
package: src/http_parser.o

./http-parser:
	        git clone --depth 1 git://github.com/joyent/http-parser.git ./http-parser

bench: src/*.cr src/**/*.cr benchmark/bench.cr src/http_parser.o
	$(CRYSTAL) build benchmark/bench.cr $(CRYSTALFLAGS) -o $@

bench_cpp: benchmark/cpp/bench.cpp src/http_parser.o
	$(CC) $(CFLAGS) $< src/http_parser.o -o $@ -lstdc++

bench_native: benchmark/native_bench.cr
	$(CRYSTAL) build $< $(CRYSTALFLAGS) -o $@

example: src/*.cr src/**/*.cr examples/example.cr src/http_parser.o
	$(CRYSTAL) build examples/example.cr $(CRYSTALFLAGS) -o $@

src/http_parser.o: ./http-parser http-parser/http_parser.c http-parser/http_parser.h
	$(CC) $(CFLAGS) http-parser/http_parser.c -o $@ -c

.PHONY: clean
clean:
	rm -f example bench bench_cpp bench_native *.o *.so src/*.o

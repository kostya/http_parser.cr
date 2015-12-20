CRYSTAL ?= crystal
CRYSTALFLAGS ?= --release
CFLAGS ?= -O2

.PHONY: all package spec
all: bench example bench_cpp bench_native
package: src/ext/http_parser.o

bench: src/*.cr src/**/*.cr benchmark/bench.cr src/ext/http_parser.o
	$(CRYSTAL) build benchmark/bench.cr $(CRYSTALFLAGS) -o $@

bench_cpp: benchmark/cpp/bench.cpp src/ext/http_parser.o
	$(CC) $(CFLAGS) $< src/ext/http_parser.o -o $@ -lstdc++

bench_native: benchmark/native_bench.cr
	$(CRYSTAL) build $< $(CRYSTALFLAGS) -o $@

example: src/*.cr src/**/*.cr examples/example.cr src/ext/http_parser.o
	$(CRYSTAL) build examples/example.cr $(CRYSTALFLAGS) -o $@

src/ext/http_parser.o:
	cd src/ext && make package

spec:
	crystal spec

.PHONY: clean
clean:
	rm -f example bench bench_cpp bench_native *.o *.so src/ext/*.o

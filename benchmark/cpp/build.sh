g++ -c -O2 bench.cpp -o bench.o
g++ bench.o ../../http_parser.o -o bench_cpp

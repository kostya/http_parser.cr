g++ -c -O3 bench.cpp -o bench.o
g++ bench.o ../../http_parser.o -o bench_cpp

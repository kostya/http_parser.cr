CFLAGS ?= -O2

.PHONY: package
package: http_parser.o

./http-parser:
	        git clone --depth 1 git://github.com/joyent/http-parser.git ./http-parser

http_parser.o: ./http-parser http-parser/http_parser.c http-parser/http_parser.h
	$(CC) $(CFLAGS) http-parser/http_parser.c -o $@ -c

.PHONY: clean
clean:
	rm -f *.o

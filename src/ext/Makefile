CFLAGS ?= -O2

.PHONY: package
package: http_parser.o multipart_parser.o

# ./http-parser:
# 	        git clone --depth 1 git://github.com/joyent/http-parser.git ./http-parser

# ./multipart-parser-c:
# 	        git clone --depth 1 https://github.com/iafonov/multipart-parser-c.git ./multipart-parser-c

http_parser.o: ./http-parser http-parser/http_parser.c http-parser/http_parser.h
	$(CC) $(CFLAGS) http-parser/http_parser.c -o $@ -c

multipart_parser.o: ./multipart-parser-c ./multipart-parser-c/multipart_parser.c ./multipart-parser-c/multipart_parser.h
	$(CC) $(CFLAGS) multipart-parser-c/multipart_parser.c -o $@ -c

.PHONY: clean
clean:
	rm -f *.o

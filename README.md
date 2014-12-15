HttpParser.cr
-------------

Crystal(>= 0.5.5) wrapper for Http Parser lib: https://github.com/joyent/http-parser

Make:

```
git clone https://github.com/kostya/http_parser.cr.git
cd http_parser.cr

make
```

Run:
```
./example
```


Example:
```ruby
require "../http_parser"

puts HttpParser.version_string

str = "
GET / HTTP/1.1
Host: www.example.com
Connection: keep-alive
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_3) AppleWebKit/535.11 (KHTML, like Gecko) Chrome/17.0.963.78 S
Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8
Accept-Encoding: gzip,deflate,sdch
Accept-Language: en-US,en;q=0.8
Accept-Charset: ISO-8859-1,utf-8;q=0.7,*;q=0.3

"

parser = HttpParser::Request.new
parser << str

p parser.headers
p parser.method
p parser.http_version
p parser.request_url
```


### Install as crystal package:
```
cd CRYSTAL_PATH
git clone https://github.com/kostya/http_parser.cr.git libs/http_parser.cr
cd libs/http_parser.cr/
make package
```

this is should work from any folder:
`crystal eval 'require "http_parser.cr/http_parser"; puts HttpParser.version_string'`

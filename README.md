HttpParser.cr
-------------

Crystal wrapper for Http Parser lib: https://github.com/joyent/http-parser

Install:

```
git clone https://github.com/kostya/http_parser.cr.git
cd http_parser.cr

git submodule init
git submodule update

make

LIBRARY_PATH=`pwd` LD_LIBRARY_PATH=`pwd` ./example
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

parser = HttpParser::Request.create
parser << str

p parser.headers
p parser.method
p parser.http_version
p parser.request_url
```
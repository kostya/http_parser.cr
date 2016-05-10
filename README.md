# HttpParser

Crystal wrapper for Http Parser lib: https://github.com/joyent/http-parser. And for Http multipart parser https://github.com/iafonov/multipart-parser-c

## Installation


Add this to your application's `shard.yml`:

```yaml
dependencies:
  http_parser:
    github: kostya/http_parser.cr
```


## Usage


```crystal
require "http_parser"

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

Multipart Example:
```crystal
str = "--AaB03x\r\n"+
      "content-disposition: form-data; name=\"field1\"\r\n"+
      "\r\n"+
      "Joe Blow\r\nalmost tricked you!\r\n"+
      "--AaB03x\r\n"+
      "content-disposition: form-data; name=\"pics\"; filename=\"file1.txt\"\r\n"+
      "Content-Type: text/plain\r\n"+
      "\r\n"+
      "... contents of file1.txt ...\r\r\n"+
      "--AaB03x--\r\n"

m = HttpParser::Multipart.new("AaB03x")
m << str
p m.parts
```

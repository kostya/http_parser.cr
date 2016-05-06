require "../src/http_parser"
require "benchmark"
require "uri"

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

url = "http://mail.ru/bla"
url = "http://foo:bar@www.example.com:8080/some/path?foo=bar#frag"
Benchmark.ips do |x|
  x.report("old") { URI.old_parse(url) }
  x.report("new") { URI.parse(url) }
  x.report("lib") { HttpParser::Url.new(url) }
end
    
url = "http://foo:bar@www.#{"example"*100}.com"
Benchmark.ips do |x|
  x.report("old") { URI.old_parse(url) }
  x.report("new") { URI.parse(url) }
  x.report("lib") { HttpParser::Url.new(url) }
end

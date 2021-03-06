require "../src/http_parser"

str = "--AaB03x\r\n" +
  "content-disposition: form-data; name=\"field1\"\r\n" +
  "\r\n" +
  "Joe Blow\r\nalmost tricked you!\r\n" +
  "--AaB03x\r\n" +
  "content-disposition: form-data; name=\"pics\"; filename=\"file1.txt\"\r\n" +
  "Content-Type: text/plain\r\n" +
  "\r\n" +
  "... contents of file1.txt ...\r\r\n" +
  "--AaB03x--\r\n"

t = Time.now
s = 0

100000.times do
  m = HttpParser::Multipart.new("AaB03x")
  m << str
  m.parts.each { |part| s += part.headers.size }
end

p s
puts Time.now - t

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

m = HttpParser::Multipart.new("AaB03x")
m << str
p m.parts

require "spec_helper"

describe "HttpParser::Request" do
  it "default parser work" do
    parser = HttpParser::Request.new

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
    parser << str
    parser.http_version.should eq("1.1")
    parser.done.should be_true
    parser.headers.should eq({"Host" => "www.example.com", "Connection" => "keep-alive", "User-Agent" => "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_3) AppleWebKit/535.11 (KHTML, like Gecko) Chrome/17.0.963.78 S", "Accept" => "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8", "Accept-Encoding" => "gzip,deflate,sdch", "Accept-Language" => "en-US,en;q=0.8", "Accept-Charset" => "ISO-8859-1,utf-8;q=0.7,*;q=0.3"})
    parser.method.should eq("GET")
    parser.request_url.should eq("/")
    parser.http_errno_name.should eq("HPE_OK")
    parser.http_errno_description.should eq("success")
  end

  it "raise error on invalid data" do
    begin
      parser = HttpParser::Request.new
      parser << "WHAT?"
      fail "Could not parse data entirely (0 != 5)"
    rescue HttpParser::CommonParser::Error
    end
  end
end


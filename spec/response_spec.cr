require "spec_helper"

describe "HttpParser::Response" do
  it "default parser work" do
    parser = HttpParser::Response.create

    str = "HTTP/1.1 200 OK
Date: Sat, 28 Jun 2014 14:05:38 GMT
Server: imagine/lite (7377732e)
Connection: close
X-Frame-Options: SAMEORIGIN
Set-Cookie: mrcu=6E4853AECBB20BE7CFF671296C6D; expires=Tue, 25 Jun 2024 14:05:38 GMT; path=/; domain=.mail.ru
Cache-Control: no-cache,no-store,must-revalidate
Pragma: no-cache
Expires: Fri, 28 Jun 2013 14:05:38 GMT
Last-Modified: Sat, 28 Jun 2014 18:05:38 GMT
Content-Length: 199814
Content-Type: text/html; charset=utf-8

<html> </html>
"
    parser << str
    parser.http_version.should eq("1.1")
    parser.done.should be_true
    parser.headers["Content-Length"].should eq("199814")
    parser.method.should eq("")
    parser.request_url.should eq("/")
    
    parser.status.should eq("")
    parser.body.should eq("")

    parser.http_errno_name.should eq("HPE_OK")
    parser.http_errno_description.should eq("success")
  end
end

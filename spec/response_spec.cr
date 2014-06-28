require "spec_helper"

describe "HttpParser::Response" do
  it "default parser work" do
    parser = HttpParser::Response.new

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
    parser << "somebody\n"

    parser.http_version.should eq("1.1")
    parser.headers["Content-Length"].should eq("199814")
    parser.status.should eq(200)
    parser.body.should eq("<html> </html>\nsomebody\n")
    parser.body_final?.should eq(false)

    parser.http_errno_name.should eq("HPE_OK")
    parser.http_errno_description.should eq("success")
  end
end

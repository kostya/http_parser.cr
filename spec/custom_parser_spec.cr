require "./spec_helper"

class MyTestParser < HttpParser::CommonParser
  def initialize(type = HttpParser::Lib::HttpParserType::HTTP_REQUEST)
    super(type)

    @begin = false
    @body = ""
    @header_field = ""
    @header_value = ""
    @status = ""
    @headers_complete = false
    @message_complete = false
    @url = ""
  end

  def on_message_begin
    @begin = true
  end

  callback :on_message_begin

  def on_header_field(s : String)
    @header_field = s
  end

  callback_data :on_header_field

  def on_header_value(s : String)
    @header_value = s
  end

  callback_data :on_header_value

  def on_status(s)
    @status = s
  end

  callback_data :on_status

  def on_headers_complete
    @headers_complete = true
  end

  callback :on_headers_complete

  def on_message_complete
    @message_complete = true
  end

  callback :on_message_complete

  def on_url(url)
    @url = url
  end

  callback_data :on_url

  def on_body(chunk)
    @body = chunk
  end

  callback_data :on_body
end

describe "custom http parser" do
  it "should parse" do
    parser = MyTestParser.new

    str = "POST /path/script.cgi HTTP/1.0
From: frog@jmarshall.com
User-Agent: HTTPTool/1.0
Content-Type: application/x-www-form-urlencoded
Content-Length: 32

home=Cosby&favorite+flavor=flies"

    parser << str
    parser.@begin.should eq(true)
    parser.@header_field.should eq("Content-Length")
    parser.@header_value.should eq("32")
    parser.@status.should eq("")
    parser.@headers_complete.should eq(true)
    parser.@message_complete.should eq(true)
    parser.@url.should eq("/path/script.cgi")
    parser.@body.should eq("home=Cosby&favorite+flavor=flies")
    parser.http_version.should eq("1.0")
    parser.method.should eq("POST")
  end
end

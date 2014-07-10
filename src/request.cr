class HttpParser::Request < HttpParser::CommonParser
  getter :request_url
  getter :done
  getter :headers
  getter :body

  def initialize
    super(HttpParser::Lib::HttpParserType::HTTP_REQUEST, true)
    @headers = {} of String => String
    @current_header_field = ""
    @request_url = ""
    @body = ""
    @done = false
  end

  def on_header_field(s)
    @current_header_field = s
  end

  callback_data :on_header_field

  def on_header_value(s)
    @headers[@current_header_field] = s
  end

  callback_data :on_header_value

  def on_url(url)
    @request_url = url
  end

  callback_data :on_url

  def on_message_complete
    @done = true
  end

  callback :on_message_complete

  def on_body(body)
    @body = body
  end

  callback_data :on_body
end

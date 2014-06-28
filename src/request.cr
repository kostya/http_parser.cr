class HttpParser::Request < HttpParser::CommonParser
  getter :request_url
  getter :done
  getter :headers

  init_http_parser_settings

  def initialize(tp)
    super(HttpParser::Lib::HttpParserType::HTTP_REQUEST)
    @headers = {} of String => String
    @current_header_field = ""
    @request_url = ""
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
end
class HttpParser::Response < HttpParser::CommonParser
  getter :body
  getter :headers

  init_http_parser_settings

  def initialize(tp)
    super(HttpParser::Lib::HttpParserType::HTTP_RESPONSE)
    @headers = {} of String => String
    @current_header_field = ""
    @body = ""
  end

  def on_header_field(s)
    @current_header_field = s
  end

  callback_data :on_header_field

  def on_header_value(s)
    @headers[@current_header_field] = s
  end

  callback_data :on_header_value

  def on_body(chunk)
    @body += chunk
  end

  callback_data :on_body
end

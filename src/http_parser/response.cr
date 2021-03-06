class HttpParser::Response < HttpParser::CommonParser
  getter :body
  getter :headers
  getter :done

  def initialize
    super(HttpParser::Lib::HttpParserType::HTTP_RESPONSE, true)
    @headers = {} of String => String
    @current_header_field = ""
    @body = ""
    @done = false
  end

  def on_header_field(s)
    @current_header_field = String.new(s)
  end

  callback_data :on_header_field

  def on_header_value(s)
    @headers[@current_header_field] = String.new(s)
  end

  callback_data :on_header_value

  def on_body(chunk)
    @body += String.new(chunk)
  end

  callback_data :on_body

  def on_message_complete
    @done = true
  end

  callback :on_message_complete
end

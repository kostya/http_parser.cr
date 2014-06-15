require "pure_http_parser"

class HttpParser < PureHttpParser
  getter :request_url
  getter :done
  getter :headers

  init_http_parser_settings

  def initialize(tp)
    super(tp)
    @headers = {} of String => String
    @current_header_field = ""
    @request_url = ""
    @done = false
  end

  def on_header_field(s : String)
    @current_header_field = s
  end

  callback_data :on_header_field

  def on_header_value(s : String)
    @headers[@current_header_field] = s
  end

  callback_data :on_header_value

  def on_url(url : String)
    @request_url = url
  end

  callback_data :on_url

  def on_message_complete
    @done = true
  end

  callback :on_message_complete

  def reset!
    @headers = {} of String => String
    @current_header_field = ""
    @request_url = ""
    @done = false
  end
end

require "./multipart_parser"

class HttpParser::Multipart < HttpParser::MultipartParser
  getter :parts
  getter :done

  class Part
    property :headers, :body

    def initialize
      @headers = {} of String => String
      @body = ""
    end
  end

  def initialize(boundary : String? = nil)
    super(boundary, true)
    @part = Part.new
    @parts = [] of Part
    @current_header_field = ""
    @done = false
  end

  def on_part_data_end
    @parts << @part
    @part = Part.new
  end

  callback :on_part_data_end

  def on_header_field(s)
    @current_header_field = String.new(s)
  end

  callback_data :on_header_field

  def on_header_value(s)
    @part.headers[@current_header_field] = String.new(s)
  end

  callback_data :on_header_value

  def on_part_data(body)
    @part.body += String.new(body)
  end

  callback_data :on_part_data

  def on_body_end
    @done = true
  end

  callback :on_body_end
end

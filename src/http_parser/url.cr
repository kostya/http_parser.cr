class HttpParser::Url
  class Error < Exception; end

  def self.parse(url)
    self.new(url)
  end

  getter :schema, :host, :path

  def initialize(url)
    res = HttpParser::Lib.http_parser_parse_url(url.to_unsafe, url.length.to_sizet, 0, out parser_struct)

    if res != 0
      name = String.new(HttpParser::Lib.http_errno_name(res))
      desc = String.new(HttpParser::Lib.http_errno_description(res))
      raise Error.new("#{name} - #{desc}")
    end

    setup_variables
  end

  macro setup_variables
    %w{schema host path}.each do |name|
      %id = HttpParser::Lib::HttpParserUrlFields::UF_{% name.upcase %}
      %seg = parser_struct.data[%id]
      %slice = Slice.new(url.to_unsafe + %seq.off, %seg.len)
      @{% name %} = String.new(%slice)
    end
  end
end

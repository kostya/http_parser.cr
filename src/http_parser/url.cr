class HttpParser::Url
  class Error < Exception; end

  def self.parse(url)
    self.new(url)
  end

  FIELDS = %w(schema host port path query fragment userinfo)

  {% for name in FIELDS %}
    getter {{name}}
  {% end %}

  def initialize(url)
    res = HttpParser::Lib.http_parser_parse_url(url.to_unsafe, url.size, 0, out parser_struct)

    if res != 0
      name = String.new(HttpParser::Lib.http_errno_name(res))
      desc = String.new(HttpParser::Lib.http_errno_description(res))
      raise Error.new("#{name} - #{desc}")
    end

    {% for name in FIELDS %}
      setup_variable({{name}})
    {% end %}
  end

  macro setup_variable(name)
    %id = HttpParser::Lib::HttpParserUrlFields::UF_{{ name.upcase.id }}.to_i
    %seg = parser_struct.data[%id]
    @{{ name.id }} = if %seg.off < url.size && %seg.len > 0
      %slice = Slice.new(url.to_unsafe + %seg.off, %seg.len)
      String.new(%slice)
    else
      ""
    end
  end
end

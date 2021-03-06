class HttpParser::CommonParser
  class Error < Exception; end

  property :http_parser

  @http_parser : HttpParser::Lib::HttpParser*

  def initialize(type, @check_parsed = true)
    @http_parser = Pointer(HttpParser::Lib::HttpParser).malloc(1)
    HttpParser::Lib.http_parser_init(@http_parser, type)
    @http_parser.value.data = self.as Void*
  end

  def self.cast(s : HttpParser::Lib::HttpParser*)
    s.value.data.as self
  end

  def <<(data : String)
    push(data.to_unsafe, data.bytesize)
  end

  def push(data : String)
    push(data.to_unsafe, data.bytesize)
  end

  def push(slice : Slice(UInt8))
    push(slice.to_unsafe, slice.size)
  end

  def <<(slice : Slice(UInt8))
    push(slice)
  end

  def push(raw : UInt8*, size : Int32)
    res = HttpParser::Lib.http_parser_execute(@http_parser, self.class.http_parser_settings, raw, size.to_u64)

    if @check_parsed && res != size
      raise Error.new("Could not parse data entirely (#{res} != #{size})")
    end

    self
  end

  def end
    HttpParser::Lib.http_parser_execute(@http_parser, self.class.http_parser_settings, nil, 0_u64)
  end

  def body_final?
    HttpParser::Lib.http_body_is_final(@http_parser) > 0
  end

  def keep_alive!
    HttpParser::Lib.http_should_keep_alive(@http_parser)
  end

  def http_major
    @http_parser.value.http_major
  end

  def http_minor
    @http_parser.value.http_minor
  end

  def http_version
    "#{http_major}.#{http_minor}"
  end

  def status
    @http_parser.value.status_code
  end

  def method_code
    @http_parser.value.method
  end

  def method
    String.new(HttpParser::Lib.http_method_str(method_code))
  end

  def http_errno
    @http_parser.value.http_errno & 127
  end

  def http_errno_name
    String.new(HttpParser::Lib.http_errno_name(http_errno))
  end

  def http_errno_description
    String.new(HttpParser::Lib.http_errno_description(http_errno))
  end

  def upgrade?
    (@http_parser.value.http_errno & 128) > 0
  end

  macro inherited
    init_http_parser_settings
  end

  macro init_http_parser_settings
    @@http_parser_settings_{{@type.name.identify.id}} : HttpParser::Lib::HttpParserSettings*
    @@http_parser_settings_{{@type.name.identify.id}} = Pointer(HttpParser::Lib::HttpParserSettings).malloc(1)
    def self.http_parser_settings
      @@http_parser_settings_{{@type.name.identify.id}}
    end
  end

  macro callback(name)
    self.http_parser_settings.value.{{name.id}} = ->(s : HttpParser::Lib::HttpParser*) do
      parser = {{@type.name.id}}.cast(s)
      res = parser.{{name.id}}
      if res.is_a?(Symbol) && res == :stop
        -1
      else
        0
      end
    end
  end

  macro callback_data(name)
    self.http_parser_settings.value.{{name.id}} = ->(s : HttpParser::Lib::HttpParser*, b : UInt8*, l : UInt64) do
      parser = {{@type.name.id}}.cast(s)
      res = parser.{{name.id}}(Slice(UInt8).new(b, l.to_i))
      if res.is_a?(Symbol) && res == :stop
        -1
      else
        0
      end
    end
  end
end

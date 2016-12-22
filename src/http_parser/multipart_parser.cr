class HttpParser::MultipartParser
  class Error < Exception; end

  property :parser
  @parser : HttpParser::MultipartLib::MultipartParser*

  def initialize(boundary : String? = nil, @check_parsed = false)
    boundary = boundary ? "--#{boundary}" : "--"
    @parser = HttpParser::MultipartLib.multipart_parser_init(boundary.to_unsafe, self.class.settings)
    HttpParser::MultipartLib.multipart_parser_set_data(@parser, self.as Void*)
  end

  def self.cast(s : HttpParser::MultipartLib::MultipartParser*)
    HttpParser::MultipartLib.multipart_parser_get_data(s).as self
  end

  def finalize
    HttpParser::MultipartLib.multipart_parser_free(@parser)
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
    res = HttpParser::MultipartLib.multipart_parser_execute(@parser, raw, size.to_u64)

    if @check_parsed && res != size
      raise Error.new("Could not parse data entirely (#{res} != #{size})")
    end

    self
  end

  macro inherited
    init_settings
  end

  macro init_settings
    @@multipart_parser_settings_{{@type.name.identify.id}} : HttpParser::MultipartLib::MultipartParserSettings*
    @@multipart_parser_settings_{{@type.name.identify.id}} = Pointer(HttpParser::MultipartLib::MultipartParserSettings).malloc(1)
    def self.settings
      @@multipart_parser_settings_{{@type.name.identify.id}}
    end
  end

  macro callback(name)
    self.settings.value.{{name.id}} = ->(s : HttpParser::MultipartLib::MultipartParser*) do
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
    self.settings.value.{{name.id}} = ->(s : HttpParser::MultipartLib::MultipartParser*, b : UInt8*, l : UInt64) do
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

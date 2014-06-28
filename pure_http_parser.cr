require "lib_http_parser"

class PureHttpParser
  class Error < Exception; end

  property :http_parser

  def self.create(type = LibHttpParser::HttpParserType::HTTP_REQUEST)
    s = new(type)
    s.http_parser.value.data = pointerof(s) as Void*
    s
  end

  macro init_http_parser_settings
    $http_parser_settings_{{@name.identify.id}} = Pointer(LibHttpParser::HttpParserSettings).malloc(1)
    def self.http_parser_settings
      $http_parser_settings_{{@name.identify.id}}
    end
  end

  def initialize(type)
    @http_parser = Pointer(LibHttpParser::HttpParser).malloc(1)
    LibHttpParser.http_parser_init(@http_parser, type)
  end

  def self.as(s : LibHttpParser::HttpParser*)
    (s.value.data as self*).value
  end

  def <<(data : String)
    push(data.cstr, data.length)
  end

  def push(raw : UInt8*, size : Int32)
    res = LibHttpParser.http_parser_execute(@http_parser, class.http_parser_settings, raw, size.to_u64)
    raise Error.new("Could not parse data entirely (#{res} != #{size})") if res != size
    res
  end

  def body_final?
    LibHttpParser.http_body_is_final(@http_parser) == 0
  end

  def keep_alive!
    LibHttpParser.http_should_keep_alive(@http_parser)
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
    String.new(LibHttpParser.http_method_str(method_code))
  end

  def http_errno
    @http_parser.value.http_errno & 127
  end

  def http_errno_name
    String.new(LibHttpParser.http_errno_name(http_errno))
  end

  def http_errno_description
    String.new(LibHttpParser.http_errno_description(http_errno))
  end

  def upgrade?
    (@http_parser.value.http_errno & 128) > 0
  end

  macro callback(name)
    $http_parser_settings_{{@name.identify.id}}.value.{{name.id}} = ->(s: LibHttpParser::HttpParser*) {
      parser = {{@name.id}}.as(s)
      res = parser.{{name.id}}
      if res.is_a?(Symbol) && res == :stop
        -1
      else
        0
      end
    }
  end

  macro callback_data(name)
    $http_parser_settings_{{@name.identify.id}}.value.{{name.id}} = ->(s : LibHttpParser::HttpParser*, b : UInt8*, l : UInt64) {
      parser = {{@name.id}}.as(s)
      res = parser.{{name.id}}(String.new(b, l.to_i))
      if res.is_a?(Symbol) && res == :stop
        -1
      else
        0
      end
    }
  end
end

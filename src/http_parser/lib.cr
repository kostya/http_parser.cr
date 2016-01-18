module HttpParser
  @[Link(ldflags: "#{__DIR__}/../ext/http_parser.o")]
  lib Lib
    enum HttpParserType
      HTTP_REQUEST
      HTTP_RESPONSE
      HTTP_BOTH
    end

    struct HttpParser
      # ** PRIVATE **
      some : Int32[4]

      # ** READ-ONLY **
      http_major : UInt16
      http_minor : UInt16
      status_code : UInt16
      method : UInt8
      http_errno : UInt8

      # ** PUBLIC **
      data : Void*
    end

    type HttpDataCb = HttpParser*, UInt8*, LibC::SizeT -> Int32
    type HttpCb = HttpParser* -> Int32

    enum HttpParserUrlFields
      UF_SCHEMA   = 0
      UF_HOST
      UF_PORT
      UF_PATH
      UF_QUERY
      UF_FRAGMENT
      UF_USERINFO
      UF_MAX
    end

    struct HttpParserUrlOffset
      off : UInt16
      len : UInt16
    end

    struct HttpParserUrl
      field_set : UInt16
      port : UInt16
      data : HttpParserUrlOffset[7]
    end

    fun http_parser_version : Int64
    fun http_parser_init(HttpParser*, HttpParserType)
    fun http_parser_execute(HttpParser*, HttpParserSettings*, UInt8*, LibC::SizeT) : LibC::SizeT
    fun http_should_keep_alive(HttpParser*) : Int32
    fun http_method_str(UInt8) : UInt8*
    fun http_errno_name(UInt8) : UInt8*
    fun http_errno_description(UInt8) : UInt8*
    fun http_parser_parse_url(UInt8*, LibC::SizeT, Int32, HttpParserUrl*) : Int32
    fun http_parser_pause(HttpParser*, Int32) : Int32
    fun http_body_is_final(HttpParser*) : Int32
  end
end

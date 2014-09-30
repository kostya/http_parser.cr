module HttpParser
  @[Link(ldflags: "#{__DIR__}/../http_parser.o")]
  lib Lib
    enum HttpParserType
      HTTP_REQUEST
      HTTP_RESPONSE
      HTTP_BOTH
    end

    struct HttpParser
    # ** PRIVATE **
      some : Int32[4]

    #** READ-ONLY **
      http_major : UInt16
      http_minor : UInt16
      status_code : UInt16
      method : UInt8
      http_errno : UInt8

    #** PUBLIC **
      data : Void*
    end

    type HttpDataCb = HttpParser*, UInt8*, C::SizeT -> Int32
    type HttpCb = HttpParser* -> Int32

    struct HttpParserSettings
      on_message_begin    : HttpCb
      on_url              : HttpDataCb
      on_status           : HttpDataCb
      on_header_field     : HttpDataCb
      on_header_value     : HttpDataCb
      on_headers_complete : HttpCb
      on_body             : HttpDataCb
      on_message_complete : HttpCb
    end

    fun http_parser_version : Int64
    fun http_parser_init(HttpParser*, HttpParserType)
    fun http_parser_execute(HttpParser*, HttpParserSettings*, UInt8*, C::SizeT) : C::SizeT
    fun http_should_keep_alive(HttpParser*) : Int32
    fun http_method_str(UInt8) : UInt8*
    fun http_errno_name(UInt8) : UInt8*
    fun http_errno_description(UInt8) : UInt8*
    #fun http_parser_parse_url(UInt8*, C::SizeT, Int32, HttpParserUrl*) : Int32
    fun http_parser_pause(HttpParser*, Int32) : Int32
    fun http_body_is_final(HttpParser*) : Int32
  end
end

module HttpParser
  @[Link(ldflags: "#{__DIR__}/../ext/multipart_parser.o")]
  lib MultipartLib
    type MultipartParser = Void*
    type MultipartDataCb = MultipartParser*, UInt8*, LibC::SizeT -> Int32
    type MultipartNotifyCb = MultipartParser* -> Int32

    struct MultipartParserSettings
      on_header_field : MultipartDataCb
      on_header_value : MultipartDataCb
      on_part_data : MultipartDataCb

      on_part_data_begin : MultipartNotifyCb
      on_headers_complete : MultipartNotifyCb
      on_part_data_end : MultipartNotifyCb
      on_body_end : MultipartNotifyCb
    end

    fun multipart_parser_init(boundary : UInt8*, settings : MultipartParserSettings*) : MultipartParser*
    fun multipart_parser_free(p : MultipartParser*)
    fun multipart_parser_set_data(p : MultipartParser*, data : Void*)
    fun multipart_parser_get_data(p : MultipartParser*) : Void*
    fun multipart_parser_execute(p : MultipartParser*, buf : UInt8*, len : LibC::SizeT) : LibC::SizeT
  end
end

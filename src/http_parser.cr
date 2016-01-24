module HttpParser
end

require "./http_parser/*"

module HttpParser
  VERSION = "1.0"

  def self.lib_version
    v = HttpParser::Lib.http_parser_version
    {(v >> 16) & 255, (v >> 8) & 255, v & 255}
  end

  def self.lib_version_string
    lib_version.join "."
  end

  def self.version_string
    "HttpParser.cr v#{VERSION} (libhttp_parser v#{lib_version_string})"
  end
end

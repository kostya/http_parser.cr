module HttpParser  
end
require "src/*"

module HttpParser
  VERSION = "0.3"

  def self.lib_version
    version = LibHttpParser::http_parser_version
    major = (version >> 16) & 255
    minor = (version >> 8) & 255
    patch = (version) & 255
    { major, minor, patch }
  end

  def self.lib_version_string
    major, minor, patch = lib_version
    "#{major}.#{minor}.#{patch}"
  end

  def self.version_string
    "HttpParser.cr v#{VERSION} (libhttp_parser v#{lib_version_string})"
  end
end

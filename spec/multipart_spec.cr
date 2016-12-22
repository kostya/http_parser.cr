require "./spec_helper"

describe "HttpParser::Multipart" do
  it "rfc1867" do
    str = "--AaB03x\r\n" +
          "content-disposition: form-data; name=\"field1\"\r\n" +
          "\r\n" +
          "Joe Blow\r\nalmost tricked you!\r\n" +
          "--AaB03x\r\n" +
          "content-disposition: form-data; name=\"pics\"; filename=\"file1.txt\"\r\n" +
          "Content-Type: text/plain\r\n" +
          "\r\n" +
          "... contents of file1.txt ...\r\r\n" +
          "--AaB03x--\r\n"

    m = HttpParser::Multipart.new("AaB03x")
    m << str

    res = m.parts.map { |part| {part.headers, part.body} }
    res.should eq [{ {"content-disposition" => "form-data; name=\"field1\""},
      "Joe Blow\r\nalmost tricked you!" },
      { {"content-disposition" => "form-data; name=\"pics\"; filename=\"file1.txt\"",
        "Content-Type"        => "text/plain"}, "... contents of file1.txt ...\r" }]
    m.done.should eq true
  end

  it "rfc1867 by stream" do
    str = ["--AaB03x\r\n",
      "content-disposition: form-data; name=\"field1\"\r\n",
      "\r\n",
      "Joe Blow\r\nalmost tricked you!\r\n",
      "--AaB03x\r\n",
      "content-disposition: form-data; name=\"pics\"; filename=\"file1.txt\"\r\n",
      "Content-Type: text/plain\r\n",
      "\r\n",
      "... contents of file1.txt ...\r\r\n",
      "--AaB03x--\r\n"]

    m = HttpParser::Multipart.new("AaB03x")
    str[0..-2].each do |s|
      m << s
      m.done.should eq false
    end

    m << str[-1]

    res = m.parts.map { |part| {part.headers, part.body} }
    res.should eq [{ {"content-disposition" => "form-data; name=\"field1\""},
      "Joe Blow\r\nalmost tricked you!" },
      { {"content-disposition" => "form-data; name=\"pics\"; filename=\"file1.txt\"",
        "Content-Type"        => "text/plain"}, "... contents of file1.txt ...\r" }]
    m.done.should eq true
  end

  it "noTrailing\\r\\n" do
    str = "--AaB03x\r\n" +
          "content-disposition: form-data; name=\"field1\"\r\n" +
          "\r\n" +
          "Joe Blow\r\nalmost tricked you!\r\n" +
          "--AaB03x\r\n" +
          "content-disposition: form-data; name=\"pics\"; filename=\"file1.txt\"\r\n" +
          "Content-Type: text/plain\r\n" +
          "\r\n" +
          "... contents of file1.txt ...\r\r\n" +
          "--AaB03x--"

    m = HttpParser::Multipart.new("AaB03x")
    m << str

    res = m.parts.map { |part| {part.headers, part.body} }
    res.should eq [{ {"content-disposition" => "form-data; name=\"field1\""},
      "Joe Blow\r\nalmost tricked you!" },
      { {"content-disposition" => "form-data; name=\"pics\"; filename=\"file1.txt\"",
        "Content-Type"        => "text/plain"}, "... contents of file1.txt ...\r" }]
    m.done.should eq true
  end

  it "wrong boundary" do
    str = "--AaB0--------3x\r\n" +
          "content-disposition: form-data; name=\"field1\"\r\n" +
          ": foo\r\n" +
          "\r\n" +
          "Joe Blow\r\nalmost tricked you!\r\n" +
          "--AaB03x\r\n" +
          "content-disposition: form-data; name=\"pics\"; filename=\"file1.txt\"\r\n" +
          "Content-Type: text/plain\r\n" +
          "\r\n" +
          "... contents of file1.txt ...\r\r\n" +
          "--AaB03x--"

    m = HttpParser::Multipart.new("AaB03x")
    expect_raises do
      p m << str
    end
    m.done.should eq false
  end

  it "another boundary" do
    str =
      "--\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
Content-Disposition: form-data; name=\"sticker\"; filename=\"beta-sticker-1.png\"
Content-Type: image/png
Content-Transfer-Encoding: base64

iVBORw0KGgoAAAANSUhEUgAAACQAAAAkCAYAAADhAJiYAAAAGXRFWHRTb2Z0d2F==
--\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/--"

    m = HttpParser::Multipart.new("\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/")
    m << str.split("\n").join("\r\n")
    res = m.parts.map { |part| {part.headers, part.body} }
    res.should eq [{ {"Content-Disposition" => "form-data; name=\"sticker\"; filename=\"beta-sticker-1.png\"",
      "Content-Type" => "image/png", "Content-Transfer-Encoding" => "base64"},
      "iVBORw0KGgoAAAANSUhEUgAAACQAAAAkCAYAAADhAJiYAAAAGXRFWHRTb2Z0d2F==" }]
    m.done.should eq true
  end
end

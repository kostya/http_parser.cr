#include "../../http-parser/http_parser.h"
#include <map>
#include <string>
#include "stdio.h"

using namespace std;

string str = "GET / HTTP/1.1\r\nHost: www.example.com\r\nConnection: keep-alive\r\nUser-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_3) AppleWebKit/535.11 (KHTML, like Gecko) Chrome/17.0.963.78 S\r\nAccept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8\r\nAccept-Encoding: gzip,deflate,sdch\r\nAccept-Language: en-US,en;q=0.8\r\nAccept-Charset: ISO-8859-1,utf-8;q=0.7,*;q=0.3\r\n\r\n\r\n";

map<string, string> headers;

class Parser {
public:
  map<string, string> headers;
  int done;
  string current_header_field;
  string request_url;
  http_parser parser;

  Parser() {
    done = 0;
    http_parser_init(&parser, HTTP_REQUEST);
    parser.data = (void*)this;
  }

  void push(http_parser_settings *settings, string str) {
    int res = http_parser_execute(&parser, settings, str.c_str(), str.length());
  }

  void on_header_field(string s) {
    current_header_field = s;
  }

  void on_header_value(string s) {
    headers[current_header_field] = s;
  }

  void on_url(string url) {
    request_url = url;
  }

  void on_message_complete() {
    done = 1;
  }
};

Parser* get_parser(http_parser* p) {
  return (Parser*)p->data;
}

int on_message_begin(http_parser* s) {
  return 0;
}

int on_header_field(http_parser* s, const char* at, size_t length) {
  get_parser(s)->on_header_field(string(at, length));
  return 0;
}

int on_header_value(http_parser* s, const char* at, size_t length) {
  get_parser(s)->on_header_value(string(at, length));
  return 0;
}

int on_message_complete(http_parser* s) {
  get_parser(s)->on_message_complete();
  return 0;
}

int on_url(http_parser* s, const char* at, size_t length) {
  get_parser(s)->on_url(string(at, length));
  return 0;
}


int main(){
  printf("begin %s \n", str.c_str());
  http_parser_settings* settings = new http_parser_settings();
  settings->on_message_begin = on_message_begin;
  settings->on_url = on_url;
  settings->on_header_field = on_header_field;
  settings->on_header_value = on_header_value;
  settings->on_headers_complete = NULL;
  settings->on_body = NULL;
  settings->on_message_complete = on_message_complete;

  int s = 0;

  for (int i = 0; i < 100000; ++i) {
    Parser p = Parser();
    p.push(settings, str);
    s += p.headers.size();
  }

  printf("s = %d\n", s);
}

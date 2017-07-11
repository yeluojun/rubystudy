# http代理服务器
require 'socket'
require 'uri'
class Rproxy
  def initialize(host, port=8089)
    begin
      Socket.tcp_server_loop(host, port) do |connection|
        Thread.new { do_server(connection) }
      end
    rescue Interrupt
      puts "关闭程序"
    rescue => e
      puts e.message
    end
  end

  def do_server(connection)
    begin
      # 第一步： 超文本协议解析（按行读取）
      # 获取请求方式，版本号
      http_lines = []
      while line = connection.readline
        break if line ==  "\r\n"
        http_lines << line
      end

      # 第二部，构造一个http客户端
      uri = URI.parse http_lines[0].split(" ")[1]
      httpClient = TCPSocket.new uri.host, uri.port || 80

      # 头部信息的写入，找出Content-Length
      content_length_line = ""
      http_lines.each_with_index do |line, index|
        if index == 0
          s = line.split(" ", 3)
          line = "#{s[0]} #{uri.request_uri} #{s[2]}" # http请求方式 请求path+query http版本号
          httpClient.write(line)
          next
        end
        if line =~ /^proxy/i
          next
        end
        httpClient.write(line)
        content_length_line = line if line.include? "Content-Length"
      end
      httpClient.write("Connection: close\r\n\r\n") # 短连接

      # 请求主体的信息的写入
      if content_length_line.length > 0
        content_length = content_length_line.split(" ")[1].strip.to_i
        httpClient.write(connection.read(content_length)) if content_length >0
      end

      # 三. 返回信息给原客户端
      while line = httpClient.read(2048)
        if line.to_s == ""
          break
        end
        connection.write line
      end

      # 四. 关闭连接
      httpClient.close
      connection.close
      
    rescue => error
      puts "something error:", error.message
    ensure
      connection.close if connection
    end
  end
end

# 获取命令行输入
port = 8089
if ARGV.empty?
  puts "use default port: 8089"
elsif ARGV.size == 1
  port = ARGV[0].to_i
  if port <= 0
    port = 8089
    puts "use default port: 8089"
  end
  puts "use port: #{port}"
else
  puts 'Usage: ruby proxy.rb [port] , defaut port is 8089'
  exit 1
end

Rproxy.new("localhost", port)

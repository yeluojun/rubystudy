require "minitest/autorun"
require "rest-client"
# require_relative "proxy"

class ProxyTest < Minitest::Test
  def test_proxy
    # a = Thread.new do
    #   Rproxy.new("localhost", 8081)
    # end

    b = Thread.new do

      # 普通的get 数据
      RestClient.proxy = "http://localhost:8089"
      # data = RestClient.get("www.baidu.com")
      # p data
      # assert_equal 200, data.code

      # 带参数的 get
      data = RestClient.get "http://dc.simuwang.com/index.php", {
        params: { c: "chart", a: 'quotation' }
      }
      puts data
      # a.exit
    end
    b.join
    # a.join
  end


end

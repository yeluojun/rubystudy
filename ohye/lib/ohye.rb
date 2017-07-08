require "ohye/version"
require "ohye/toutiao"
require "ohye/qiniu"
# require "ohye/qiniu"

module Ohye
  # Your code goes here...
  def say_hi
    return "hi!"
  end
  def self.say_good
    return "good!"
  end
  module_function :say_hi
end

require "spec_helper"

RSpec.describe 'module is Ohye:' do
  it "test qiniu" do
    qiniu = Ohye::Qiniu.new
    str = qiniu.hello_qiniu
    expect(str). to eq("hello qiniu")
  end
end

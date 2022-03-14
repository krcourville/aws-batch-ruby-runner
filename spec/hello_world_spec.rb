# frozen_string_literal: true

class HelloWorld
  def say_hello
    'Hello World!'
  end
end

describe HelloWorld do
  context 'When testing the HelloWorld class' do
    it "should say 'Hello World' when we call the say_hello method" do
      hw = HelloWorld.new
      message = hw.say_hello
      expect(message).to eq 'Hello World!'
    end
  end
end

def get_value(*args)
  args_s = args.map(&:to_s)
  data = {
    'name' => {
      'f' => 'joe',
      'l' => 'schmoe'
    }
  }
  data.dig(*args_s)
end

describe 'HashTest' do
  context 'when working with hash' do
    it 'should do stuff' do
      expect(get_value(:name, :f)).to eq 'joe'
      expect(get_value('name', 'f')).to eq 'joe'
    end
  end
end

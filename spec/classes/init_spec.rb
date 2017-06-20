require 'spec_helper'
describe 'puppet_agent_cleanser' do
  let(:facts) { {
    :puppetversion => '4.3.1',
    :kernel        => 'Linux',
  } }
  context 'with default values for all parameters' do
    it { should contain_class('puppet_agent_cleanser') }
  end
end

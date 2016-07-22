require 'spec_helper'

describe 'XPack Tests v 2.x' do

  describe user('elasticsearch') do
    it { should exist }
  end

end


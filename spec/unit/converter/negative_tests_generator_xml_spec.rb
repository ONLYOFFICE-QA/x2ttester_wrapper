# frozen_string_literal: true

require 'rspec'
require 'pathname'

require_relative '../../../framework/manager_x2ttesting'

describe X2tTesting::X2ttesterXml, type: :aruba do
  config = JSON.load_file("#{__dir__}/assets/config_negative_test.json")
  options = { project_dir: Dir.pwd, x2t_dir: '', fonts_dir: '', report_dir: '', tmp_dir: "#{Dir.pwd}/tmp" }

  it 'Negative test input_dir_path' do
    expect(described_class.new(config, options).send(:input_dir_path)).to eq("#{Dir.pwd}/documents")
  end

  it 'Negative test output_dir_path' do
    expect(described_class.new(config, options).send(:output_dir_path)).to eq("#{Dir.pwd}/tmp")
  end

  it 'Negative test delete_ok' do
    expect(described_class.new(config, options).send(:delete_ok)).to eq(0)
    config['delete'] = ''
    expect { described_class.new(config, options).send(:delete_ok) }.to raise_error(X2tTesting::RedStandardError)
  end

  it 'Negative test errors_only' do
    expect(described_class.new(config, options).send(:errors_only)).to eq(0)
    config['errors_only'] = ''
    expect { described_class.new(config, options).send(:errors_only) }.to raise_error(X2tTesting::RedStandardError)
  end

  it 'Negative test timestamp' do
    expect(described_class.new(config, options).send(:timestamp)).to eq(0)
    config['timestamp'] = ''
    expect { described_class.new(config, options).send(:timestamp) }.to raise_error(X2tTesting::RedStandardError)
  end

  it 'Negative test number_of_cores' do
    expect { described_class.new(config, options).send(:number_of_cores) }.to raise_error(X2tTesting::RedStandardError)
  end

  it 'Negative test x2t_path' do
    expect { described_class.new(config, options).send(:x2t_path) }.to raise_error(X2tTesting::RedStandardError)
  end
end

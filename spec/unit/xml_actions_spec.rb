# frozen_string_literal: true

require 'rspec'
require 'pathname'
require_relative '../../manager'

describe XmlActions, type: :aruba do
  described_class.new.create_doc_renderer_config(path_to: ProjectConfig.tmp_dir)
  path_to = "#{ProjectConfig.tmp_dir}/DoctRenderer.config"
  array = File.read(path_to).split
  after(:all) do
    FileUtils.rm(path_to)
  end

  it 'Check exist DoctRenderer.config' do
    expect(Pathname.new(path_to)).to exist
    expect(Pathname.new(path_to)).to be_file
  end

  it 'Check the file line by line' do
    expect(array).to include(match(/native.js/))
    expect(array).to include(match(/jquery_native.js/))
    expect(array).to include(match(/AllFonts.js/))
    expect(array).to include(match(/xregexp-all-min.js/))
    expect(array).to include(match(/sdkjs/))
  end
end

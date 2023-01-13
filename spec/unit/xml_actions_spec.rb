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

describe XmlActions, type: :aruba do
  files_array_xml = described_class.new(config: "#{ProjectConfig::PROJECT_DIR}/spec/unit/config.json").generate_files_list
  after(:all) do
    files_array_xml.close!
  end

  it 'Check exist files_list_xml' do
    expect(Pathname.new(files_array_xml)).to exist
    expect(Pathname.new(files_array_xml)).to be_file
  end

  it 'comparison of xml files' do
    expect(File.read(files_array_xml)).to eq(File.read("#{ProjectConfig::PROJECT_DIR}/spec/unit/file_array.xml"))
  end
end

# frozen_string_literal: true

require 'rspec'
require 'pathname'
require_relative '../../manager'

describe XmlActions, type: :aruba do
  ProjectConfig::CONFIG['version'] = '7.3.0.142'
  ProjectConfig::CONFIG['cores'] = '4'
  ProjectConfig::CONFIG['errors_only'] = '1'
  ProjectConfig::CONFIG['delete'] = '1'
  ProjectConfig::CONFIG['timestamp'] = '1'
  ProjectConfig::CONFIG['input_dir'] = '/db/files/'
  ProjectConfig::CONFIG['output_dir'] = './tmp'
  ProjectConfig::CONFIG['files_array'] = %w[0.ppt 1.xls 2.docx 3.xlsx 4.html 5.pdf]
  xml_actions = described_class.new
  input_format = 'doc'
  output_format = 'docx'
  report_path = "#{ProjectConfig.reports_dir}/#{input_format}_#{output_format}_report.csv"
  x2t_path = "#{ProjectConfig.core_dir}/#{ProjectConfig.host_config[:x2t]}"
  doctrenderer_path = "#{ProjectConfig.core_dir}/DoctRenderer.config"

  before(:all) do
    FileUtils.rm_rf(ProjectConfig.core_dir) if Dir.exist?(ProjectConfig.core_dir)
    CoreActions.new.getting_core
    @files_array_xml = xml_actions.generate_files_list
    @parameters_xml = xml_actions.generate_parameters(input_format, output_format, @files_array_xml.path)
    @array = File.read(doctrenderer_path).split
    @parsed_result = File.open(@parameters_xml) { |f| Nokogiri::XML(f) }
  end

  after(:all) do
    FileUtils.rm_rf(ProjectConfig.core_dir)
    @files_array_xml.close!
    @parameters_xml.close!
  end

  it 'Check exist DoctRenderer.config' do
    expect(Pathname.new(doctrenderer_path)).to exist
    expect(Pathname.new(doctrenderer_path)).to be_file
  end

  it 'Check the DoctRenderer.config line by line' do
    expect(@array).to include(match(/native.js/))
    expect(@array).to include(match(/jquery_native.js/))
    expect(@array).to include(match(/AllFonts.js/))
    expect(@array).to include(match(/xregexp-all-min.js/))
    expect(@array).to include(match(/sdkjs/))
  end

  it 'Check exist files_list_xml' do
    expect(Pathname.new(@files_array_xml.path)).to exist
    expect(Pathname.new(@files_array_xml.path)).to be_file
  end

  it 'Comparison of xml files' do
    expect(File.read(@files_array_xml)).to eq(File.read("#{ProjectConfig::PROJECT_DIR}/spec/unit/file_array.xml"))
  end

  it 'Check exist x2ttester_parameters.xml' do
    expect(Pathname.new(@parameters_xml.path)).to exist
    expect(Pathname.new(@parameters_xml.path)).to be_file
  end

  it 'Check x2ttester_parameters.xml' do
    expect(@parsed_result.at('reportPath').content).to eq(report_path)
    expect(@parsed_result.at('inputDirectory').content).to eq(ProjectConfig::CONFIG['input_dir'])
    expect(@parsed_result.at('outputDirectory').content).to eq(ProjectConfig::CONFIG['output_dir'])
    expect(@parsed_result.at('x2tPath').content).to eq(x2t_path)
    expect(@parsed_result.at('cores').content).to eq(ProjectConfig::CONFIG['cores'])
    expect(@parsed_result.at('input').content).to eq(input_format)
    expect(@parsed_result.at('output').content).to eq(output_format)
    expect(@parsed_result.at('errorsOnly').content).to eq(ProjectConfig::CONFIG['errors_only'])
    expect(@parsed_result.at('deleteOk').content).to eq(ProjectConfig::CONFIG['delete'])
    expect(@parsed_result.at('timestamp').content).to eq(ProjectConfig::CONFIG['timestamp'])
    expect(@parsed_result.at('inputFilesList').content).to eq(@files_array_xml.path)
  end
end

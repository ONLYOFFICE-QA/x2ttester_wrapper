# frozen_string_literal: true

require 'rspec'
require 'pathname'
require_relative '../../manager'

describe XmlGenerator, type: :aruba do
  Configurator::X2TTESTER_CONFIG['version'] = '7.3.0.142'
  Configurator::X2TTESTER_CONFIG['cores'] = '4'
  Configurator::X2TTESTER_CONFIG['errors_only'] = '1'
  Configurator::X2TTESTER_CONFIG['delete'] = '1'
  Configurator::X2TTESTER_CONFIG['timestamp'] = '1'
  Configurator::X2TTESTER_CONFIG['input_dir'] = '/db/files'
  Configurator::X2TTESTER_CONFIG['output_dir'] = './tmp'
  Configurator::X2TTESTER_CONFIG['files_array'] = %w[0.ppt 1.xls 2.docx 3.xlsx 4.html 5.pdf]
  xml_actions = described_class.new
  input_format = 'doc'
  output_format = 'docx'
  report_path = "#{Configurator.reports_dir}/#{input_format}_#{output_format}_report.csv"
  x2t_path = "#{Configurator.core_dir}/#{Configurator.host_config[:x2t]}"
  doctrenderer_path = "#{Configurator.core_dir}/DoctRenderer.config"

  before(:all) do
    FileUtils.rm_rf(Configurator.core_dir) if Dir.exist?(Configurator.core_dir)
    CoreGenerator.new.getting_core
    @files_array_xml = xml_actions.x2ttester_files_list
    @parameters_xml = xml_actions.create_x2ttester_parameters(input_format, output_format, @files_array_xml.path)
    @array = File.read(doctrenderer_path).split
    @parsed_result = File.open(@parameters_xml) { |f| Nokogiri::XML(f) }
  end

  after(:all) do
    FileUtils.rm_rf(Configurator.core_dir)
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
    expect(File.read(@files_array_xml)).to eq(File.read("#{Configurator::PROJECT_DIR}/spec/unit/file_array.xml"))
  end

  it 'Check exist x2ttester_parameters.xml' do
    expect(Pathname.new(@parameters_xml.path)).to exist
    expect(Pathname.new(@parameters_xml.path)).to be_file
  end

  it 'Check x2ttester_parameters.xml' do
    expect(@parsed_result.at('reportPath').content).to eq(report_path)
    expect(@parsed_result.at('inputDirectory').content).to eq(Configurator::X2TTESTER_CONFIG['input_dir'])
    expect(@parsed_result.at('outputDirectory').content).to eq(Configurator::X2TTESTER_CONFIG['output_dir'])
    expect(@parsed_result.at('x2tPath').content).to eq(x2t_path)
    expect(@parsed_result.at('cores').content).to eq(Configurator::X2TTESTER_CONFIG['cores'])
    expect(@parsed_result.at('input').content).to eq(input_format)
    expect(@parsed_result.at('output').content).to eq(output_format)
    expect(@parsed_result.at('errorsOnly').content).to eq(Configurator::X2TTESTER_CONFIG['errors_only'])
    expect(@parsed_result.at('deleteOk').content).to eq(Configurator::X2TTESTER_CONFIG['delete'])
    expect(@parsed_result.at('timestamp').content).to eq(Configurator::X2TTESTER_CONFIG['timestamp'])
    expect(@parsed_result.at('inputFilesList').content).to eq(@files_array_xml.path)
  end
end

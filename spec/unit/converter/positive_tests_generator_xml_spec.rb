# frozen_string_literal: true

require 'rspec'
require 'pathname'

require_relative '../../../framework/manager_x2ttesting'

describe X2tTesting::X2ttesterXml, type: :aruba do
  config = JSON.load_file("#{__dir__}/assets/config_positive_test.json")
  tmp_dir = "#{Dir.pwd}/tmp"
  options = { project_dir: Dir.pwd, x2t_dir: tmp_dir, fonts_dir: tmp_dir, report_dir: tmp_dir, tmp_dir: tmp_dir }
  x2t = X2tTesting::HostConfig.new(tmp_dir).os_specific_configuration[:x2t]

  before(:all) do
    FileUtils.mkdir(tmp_dir) unless Dir.exist?(tmp_dir)
    FileUtils.touch(File.join(tmp_dir, x2t))
    @generator_xml = described_class.new(config, options)
  end

  after(:all) do
    FileUtils.rm_rf(tmp_dir)
  end

  it 'Check of x2ttester_files_list files' do
    xml_builder = Nokogiri::XML(@generator_xml.file_names(%w[0.ppt 1.xls 2.docx 3.xlsx 4.html 5.pdf]))
    expect(xml_builder.to_xml).to eq(File.read("#{__dir__}/assets/file_array.xml"))
  end

  it 'Positive test x2ttester_parameters.xml_actions' do
    xml_builder = Nokogiri::XML(@generator_xml.parameters('doc', 'docx', '/tmp/file_names_array.xml_actions'))
    expect(xml_builder.at('reportPath').text).to eq("#{tmp_dir}/doc_docx_report.csv")
    expect(xml_builder.at('inputDirectory').text).to eq(config['input_dir'])
    expect(xml_builder.at('outputDirectory').text).to eq(config['output_dir'])
    expect(xml_builder.at('x2tPath').text).to eq(File.join(tmp_dir, x2t))
    expect(xml_builder.at('cores').text).to eq(config['cores'])
    expect(xml_builder.at('input').text).to eq('doc')
    expect(xml_builder.at('output').text).to eq('docx')
    expect(xml_builder.at('errorsOnly').text).to eq('1')
    expect(xml_builder.at('deleteOk').text).to eq('1')
    expect(xml_builder.at('timestamp').text).to eq('1')
    expect(xml_builder.at('inputFilesList').text).to eq('/tmp/file_names_array.xml_actions')
    expect(xml_builder.at('fonts').text.strip).to eq(tmp_dir)
  end
end

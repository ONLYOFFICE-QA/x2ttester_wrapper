# frozen_string_literal: true

require 'rspec'
require 'pathname'
require_relative '../../../framework/manager_x2ttesting'

describe X2tTesting::X2tLibsXml do
  tmp_dir = File.join(Dir.pwd, 'tmp')

  before do
    FileUtils.mkdir(tmp_dir) unless Dir.exist?(tmp_dir)
    @xml = described_class.new.doc_renderer_config
    File.write(File.join(tmp_dir, 'DoctRenderer.config'), @xml)
  end

  it 'Check exist DoctRenderer.config' do
    expect(Pathname.new(File.join(tmp_dir, 'DoctRenderer.config'))).to exist
    expect(Pathname.new(File.join(tmp_dir, 'DoctRenderer.config'))).to be_file
  end

  it 'Check x2t_doc_renderer_config' do
    expect(Nokogiri::XML(@xml).to_xml).to eq(File.read("#{__dir__}/assets/doc_renderer_template.xml"))
  end
end

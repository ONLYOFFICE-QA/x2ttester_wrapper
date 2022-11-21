# frozen_string_literal: true

# class for working with xml
class XmlActions
  def initialize
    @x2t_config = JSON.load_file("#{Dir.pwd}/config.json")
    @x2t_connections = JSON.load_file("#{Dir.pwd}/config/x2t_connections.json")
    @x2tpath = "#{ProjectConfig.core_dir}/#{ProjectConfig.host_config[:x2t]}"
  end

  def generate_doc_renderer_xml
    Nokogiri::XML::Builder.new(encoding: 'UTF-8') do |xml|
      xml.Settings do
        xml.file(@x2t_connections.fetch('native'))
        xml.file(@x2t_connections.fetch('jquery_native'))
        xml.allfonts(@x2t_connections.fetch('AllFonts'))
        xml.file(@x2t_connections.fetch('xregexp_all_min'))
        xml.sdkjs(@x2t_connections.fetch('sdkjs'))
      end
    end.to_xml
  end

  def create_doc_renderer_config
    File.write("#{ProjectConfig.core_dir}/DoctRenderer.config", generate_doc_renderer_xml)
  end

  # Generate parameters for x2ttester
  # @param [String] cores Number of threads to convert
  # @param [String (frozen)] direction Conversion direction
  # @return [Tempfile]
  def generate_parameters(cores, direction = 'all')
    xml_parameters = Nokogiri::XML::Builder.new(encoding: 'UTF-8') do |xml|
      xml.Settings do
        xml.reportPath("#{ProjectConfig.reports_dir}/#{direction}_report.csv")
        xml.inputDirectory(@x2t_config.fetch('input_dir'))
        xml.outputDirectory(@x2t_config.fetch('output_dir'))
        xml.x2tPath(@x2tpath)
        xml.cores(cores)
        xml.input(direction) if direction != 'all'
        if Dir.exist?(ProjectConfig.fonts_dir) && !Dir.empty?(ProjectConfig.fonts_dir)
          xml.fonts('system' => '0') do
            xml.directory(ProjectConfig.fonts_dir)
          end
        else
          xml.fonts('system' => '1') do
            xml.directory('')
          end
        end
      end
    end
    write_xml_to_tmp_file(xml_parameters)
  end

  # Creates a unique temporary xml-file
  # @param [Object] xml_parameters
  # @return [null, Tempfile]
  def write_xml_to_tmp_file(xml_parameters)
    file = Tempfile.new(%w[params .xml], ProjectConfig.tmp_dir)
    file.write(xml_parameters.to_xml)
    file.rewind
    file
  end
end

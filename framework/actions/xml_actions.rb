# frozen_string_literal: true

# class for working with xml
class XmlActions
  # @param [Object] args
  # @return [Object]
  def self.generate_doc_renderer_xml(args)
    Nokogiri::XML::Builder.new(encoding: 'UTF-8') do |xml|
      xml.Settings do
        xml.file(args.fetch('native'))
        xml.file(args.fetch('jquery_native'))
        xml.allfonts(args.fetch('AllFonts'))
        xml.file(args.fetch('xregexp_all_min'))
        xml.sdkjs(args.fetch('sdkjs'))
      end
    end.to_xml
  end

  # @param [Object] path_to
  # @return [Integer]
  def self.create_doc_renderer_config(path_to)
    File.write("#{path_to}/DoctRenderer.config", generate_doc_renderer_xml(StaticData::X2T_CONNECTIONS))
  end

  # @param [String] input_dir Path to directory with source files for conversion
  # @param [String] output_dir Path to the directory where the converted file will be saved
  # @param [String] cores Number of threads to convert
  # @param [String (frozen)] direction Conversion direction
  # @return [Tempfile]
  def self.generate_param_for_x2ttester(cores, direction = 'all')
    xml_parameters = Nokogiri::XML::Builder.new(encoding: 'UTF-8') do |xml|
      xml.Settings do
        xml.reportPath("#{StaticData::REPORTS_DIR}/#{direction}_report.csv")
        xml.inputDirectory(StaticData::CONFIG.fetch('input_dir'))
        xml.outputDirectory(StaticData::CONFIG.fetch('output_dir'))
        xml.x2tPath(StaticData::X2T_PATH)
        xml.cores(cores)
        xml.input(direction) if direction != 'all'
        if Dir.exist?(StaticData::FONTS_DIR) && !Dir.empty?(StaticData::FONTS_DIR)
          xml.fonts('system' => '0') do
            xml.directory(StaticData::FONTS_DIR)
          end
        else
          xml.fonts('system' => '1') do
            xml.directory('')
          end
        end
      end
    end
    XmlActions.write_xml_to_tmp_file(xml_parameters)
  end

  # Creates a unique temporary xml-file
  # @param [Object] xml_parameters
  # @return [null, Tempfile]
  def self.write_xml_to_tmp_file(xml_parameters)
    file = Tempfile.new(%w[params .xml], StaticData::TMP_DIR)
    file.write(xml_parameters.to_xml)
    file.rewind
    file
  end
end

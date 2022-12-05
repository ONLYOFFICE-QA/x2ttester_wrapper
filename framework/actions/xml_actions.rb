# frozen_string_literal: true

# class for working with xml
class XmlActions
  def initialize
    @x2t_config = JSON.load_file("#{Dir.pwd}/config/x2ttester_config.json")
    @x2t_connections = JSON.load_file("#{Dir.pwd}/config/x2t_connections.json")
  end

  def generate_x2t_path
    raise('Check x2t File') unless File.exist?("#{ProjectConfig.core_dir}/#{ProjectConfig.host_config[:x2t]}")

    "#{ProjectConfig.core_dir}/#{ProjectConfig.host_config[:x2t]}"
  end

  def generate_number_of_cores
    raise('Please enter the number of cores in x2ttester_config.json ') if @x2t_config.fetch('cores') == ''

    @x2t_config.fetch('cores')
  end

  def generate_input_dir_path
    return "#{ProjectConfig::PROJECT_DIR}/documents/" if @x2t_config.fetch('input_dir') == ''

    @x2t_config.fetch('input_dir')
  end

  def generate_output_dir_dir_path
    return ProjectConfig.tmp_dir.to_s if @x2t_config.fetch('output_dir') == ''

    @x2t_config.fetch('output_dir')
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

  def generate_files_list
    xml_parameters = Nokogiri::XML::Builder.new(encoding: 'UTF-8') do |xml|
      xml.files do
        @x2t_config.fetch('files_array').each do |file_name|
          xml.file(file_name)
        end
      end
    end
    write_xml_to_tmp_file(xml_parameters)
  end

  def generate_report_path(input_format, output_format)
    "#{ProjectConfig.reports_dir}/#{input_format}_#{output_format}_report.csv"
  end

  # Generate parameters for x2ttester
  # @param [String (frozen)] direction Conversion direction
  # @return [Tempfile]
  def generate_parameters(input_format = nil, output_format = nil, path_to_files_list = nil)
    xml_parameters = Nokogiri::XML::Builder.new(encoding: 'UTF-8') do |xml|
      xml.Settings do
        xml.reportPath(generate_report_path(input_format, output_format))
        xml.inputDirectory(generate_input_dir_path)
        xml.outputDirectory(generate_output_dir_dir_path)
        xml.x2tPath(generate_x2t_path)
        xml.cores(generate_number_of_cores)
        xml.input(input_format) if input_format
        xml.output(output_format) if output_format
        xml.errorsOnly(@x2t_config.fetch('errors_only')) if %w[1 0].include? @x2t_config.fetch('errors_only')
        xml.deleteOk(@x2t_config.fetch('delete')) if %w[1 0].include? @x2t_config.fetch('delete')
        xml.timestamp(@x2t_config.fetch('timestamp')) if %w[1 0].include? @x2t_config.fetch('timestamp')
        xml.inputFilesList(path_to_files_list) if path_to_files_list
        if Dir.exist?(ProjectConfig.fonts_dir) && !Dir.empty?(ProjectConfig.fonts_dir)
          xml.fonts('system' => '0') do
            xml.directory(ProjectConfig.fonts_dir)
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


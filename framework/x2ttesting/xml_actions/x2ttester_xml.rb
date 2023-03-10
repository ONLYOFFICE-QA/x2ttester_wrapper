# frozen_string_literal: true

module X2tTesting
  # class generate xml_actions for converter
  class X2ttesterXml

    # @param [JSON] config_json - custom configuration file for converter required parameters:
    # cores - num cores to use
    # errors_only - reports only errors (value: `true\false`)
    # delete - is delete successful conversions files (value: `true\false`)
    # timestamp -  timestamp in report file name (value: `true\false`)
    # input_dir -  path to the folder with the documents to be converted.
    # output_dir - path to the folder with
    # @param [Hash] options is a hash with required keys:
    # :project_dir - is a path to project folder
    # :tmp_dir - is a path to tmp folder
    # :report_dir -  is a path to report folder
    # :x2t_dir - is a path to folder with x2t
    # :fonts_dir -  is a path to folder with fonts
    def initialize(config_json, options = {})
      @x2ttester_config = config_json
      @project_dir = options[:project_dir]
      @tmp_dir = options[:tmp_dir]
      @report_dir = options[:report_dir]
      @x2t_dir = options[:x2t_dir]
      @fonts_dir = options[:fonts_dir]
    end

    # Generate xml_actions file with an array of file names for conversion
    def file_names(file_names_array)
      Nokogiri::XML::Builder.new(encoding: 'UTF-8') do |xml|
        xml.files do
          file_names_array.each do |file_name|
            xml.file(file_name)
          end
        end
      end.to_xml
    end

    # Generate parameters for converter
    # @param [String] input_format Source file extension
    # @param [String] output_format Converted file extension
    # @param [String] files_list_path Path to xml_actions file with an array of file names for conversion
    # @return [Xml] Parameters xml_actions for conversion via converter
    def parameters(input_format, output_format, files_list_path)
      Nokogiri::XML::Builder.new(encoding: 'UTF-8') do |xml|
        xml.Settings do
          xml.reportPath(report_path(input_format, output_format))
          xml.inputDirectory(input_dir_path)
          xml.outputDirectory(output_dir_path)
          xml.x2tPath(x2t_path)
          xml.cores(number_of_cores)
          xml.input(input_format) if input_format
          xml.output(output_format) if output_format
          xml.errorsOnly(errors_only)
          xml.deleteOk(delete_ok)
          xml.timestamp(timestamp)
          xml.inputFilesList(files_list_path) unless files_list_path.nil?
          if Dir.exist?(@fonts_dir) && !Dir.empty?(@fonts_dir)
            xml.fonts('system' => '0') do
              xml.directory(@fonts_dir)
            end
          end
        end
      end.to_xml
    end

    # Creates a unique temporary xml_actions-file
    # @param [Xml] xml
    # @return [null, Tempfile] Temp xml_actions file
    def create_tmp_xml(xml)
      file = Tempfile.new(%w[params .xml], @tmp_dir)
      file.write(xml)
      file.rewind
      file
    end

    private

    def host
      @host ||= HostConfig.new(@x2t_dir).os_specific_configuration
    end

    def delete_last_slash(string)
      return string.strip.chop! if %w[/ \\].include? string.strip.chars[-1]

      string
    end

    # Generate deleteOk parameter for converter
    def delete_ok
      case @x2ttester_config.fetch('delete').downcase
      when 'true' then 1
      when 'false' then 0
      else
        raise RedStandardError, 'the value of delete must be true or false'
      end
    end

    # Generate errorsOnly parameter for converter
    def errors_only
      case @x2ttester_config.fetch('errors_only').downcase
      when 'true' then 1
      when 'false' then 0
      else
        raise RedStandardError, 'the value of errors_only must be true or false'
      end
    end

    # Generate timestamp parameter for converter
    def timestamp
      case @x2ttester_config.fetch('timestamp').downcase
      when 'true' then 1
      when 'false' then 0
      else
        raise RedStandardError, 'the value of timestamp must be true or false'
      end
    end

    # Generate path to report
    # @param [String] input_format Source file extension
    # @param [String] output_format Converted file extension
    def report_path(input_format, output_format)
      File.join(@report_dir, "#{input_format}_#{output_format}_report.csv")
    end

    # Checks if x2t  file exists and generates a path to it
    # @return [String] Path to x2t file
    def x2t_path
      raise RedStandardError, 'Check x2t File' unless File.exist?(File.join(@x2t_dir, host[:x2t]))

      File.join(@x2t_dir, host[:x2t])
    end

    # Checks the presence of the parameter "cores"
    # @return [String] Number of cores
    def number_of_cores
      raise RedStandardError, 'Please enter the number of cores in config.json ' if @x2ttester_config.fetch('cores') == ''

      @x2ttester_config.fetch('cores')
    end

    # Generates path to folder with source files for conversion
    # @return [String] Path to files for conversion
    def input_dir_path
      return File.join(@project_dir, 'documents') if @x2ttester_config.fetch('input_dir') == ''

      delete_last_slash(@x2ttester_config.fetch('input_dir'))
    end

    # Generates path to directory with converted files
    # @return [String] path to directory with converted files
    def output_dir_path
      return @tmp_dir if @x2ttester_config.fetch('output_dir') == ''

      delete_last_slash(@x2ttester_config.fetch('output_dir'))
    end
  end
end

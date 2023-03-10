# frozen_string_literal: true


module X2tTesting
  # a class with methods to control the conversion
  class X2tTester

    # @param [JSON] config_json - custom configuration file for converter required parameters:
    # cores - num cores to use
    # errors_only - reports only errors (value: `true\false`)
    # delete - is delete successful conversions files (value: `true\false`)
    # timestamp -  timestamp in report file name (value: `true\false`)
    # input_dir -  path to the folder with the documents to be converted.
    # output_dir - path to the folder with
    # files_array- file names for selective conversion
    # @param [Hash] options is a hash with required keys:
    # :project_dir - is a path to project folder
    # :tmp_dir - is a path to tmp folder
    # :report_dir -  is a path to report folder
    # :x2t_dir - is a path to folder with x2t
    # :fonts_dir -  is a path to folder with fonts
    def initialize(config_json, options = {})
      @x2ttester_config = config_json
      @files_array = config_json.fetch('files_array')
      @tmp_dir = options[:tmp_dir]
      @x2t_dir = options[:x2t_dir]
      @fonts_dir = options[:fonts_dir]
      @project_dir = options[:project_dir]
      @report_dir = options[:report_dir]
      FileUtils.mkdir(@tmp_dir) unless Dir.exist?(@tmp_dir)
    end

    # @param [String] input_format
    # @param [String] output_format
    def convert_from_files_array(input_format, output_format, file_names_array: @files_array)
      list_xml = x2ttester_xml.create_tmp_xml(x2ttester_xml.file_names(file_names_array))
      convert(input_format, output_format, list_xml.path.to_s)
      list_xml.close!
    end

    # @param [String] input_format
    # @param [String] output_format
    # @param [String] list_xml - path to list.xml_actions
    def convert(input_format, output_format, list_xml = '')
      tmp_xml = x2ttester_xml.create_tmp_xml(x2ttester_xml.parameters(input_format, output_format, list_xml))
      system("#{File.join(@x2t_dir, host[:x2ttester])} #{tmp_xml.path}")
      tmp_xml.close!
    end

    private

    def host
      @host ||= HostConfig.new(@x2t_dir).os_specific_configuration
    end

    def x2ttester_xml
      @x2ttester_xml ||= X2ttesterXml.new(
        @x2ttester_config,
        {
          tmp_dir: @tmp_dir,
          x2t_dir: @x2t_dir,
          fonts_dir: @fonts_dir,
          project_dir: @project_dir,
          report_dir: @report_dir
        }
      )
    end
  end
end

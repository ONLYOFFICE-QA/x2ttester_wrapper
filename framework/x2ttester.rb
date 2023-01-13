# frozen_string_literal: true

# a class with methods to control the conversion
class X2ttester
  def initialize
    @xml = XmlActions.new
  end

  def run_x2ttester(input_format, output_format, path_to_list = nil)
    tmp_xml = @xml.generate_parameters(input_format, output_format, path_to_list)
    system("#{ProjectConfig.core_dir}/#{ProjectConfig.host_config[:x2ttester]} #{tmp_xml.path}")
    tmp_xml.close!
  end

  def conversion_via_x2ttester(input_format, output_format, list)
    if list == 'ls'
      list_xml = @xml.generate_files_list
      run_x2ttester(input_format, output_format, list_xml.path)
      list_xml.close!
    else
      run_x2ttester(input_format, output_format)
    end
  end
end

# frozen_string_literal: true

# class for downloading and unpacking core
class CoreActions
  def initialize
    @branch = StaticData::CONFIG.fetch('branch')
    @version = "v#{StaticData::CONFIG.fetch('version')}".sub(/.*\K\..*/, '')
    @build = StaticData::CONFIG.fetch('version')
    @os = StaticData::HOST
    @arch = StaticData::ARCH
    @url = generate_url
    @core_archive = "#{StaticData::TMP_DIR}/#{File.basename(@url)}"
  end

  # generates the url for the core download
  def generate_url
    @build = @build.sub(/.*\K\./, '-') if @os.include?('linux')
    'https://s3.eu-west-1.amazonaws.com/repo-doc-onlyoffice-com/' \
    "#{@os}/core/#{@branch}/#{@version}/#{@build}/#{@arch}/core.7z"
  end

  # Checks if the file exists on the server and checks validity of url
  # @return [String] Response from the server
  def check_core_on_server
    core_status = `curl --head #{@url}`
    if core_status.split("\r")[0].include?('200 OK')
      '200'
    else
      p "Core not found, check version and branch settings are correct\nURL:#{@url}\nCurl response:#{core_status}"
    end
  end

  # @param [String] archive_path Path to the archive to unpack
  # @param [String] execute_path The path to the unpacking location
  def unpacking_with_7zip(archive_path, execute_path)
    File.open(archive_path, 'rb') do |file|
      SevenZipRuby::Reader.open(file) do |szr|
        szr.extract_all execute_path
      end
    end
  end

  # Changes the access parameters of the folder and core components, to run on mac and linux
  def change_core_access
    return unless StaticData::HOST.include?('linux') || StaticData::HOST.include?('mac')

    FileUtils.chmod('+x', Dir.glob("#{StaticData::PROJECT_DIR}/#{File.basename(@url, '.7z')}/*"))
  end

  # Generate AllFonts.js
  def generate_allfonts
    `#{StaticData::CORE_DIR}/#{StaticData::STANDARDTESTER}`
  end

  def download_core
    return unless check_core_on_server == '200'

    system("curl #{@url} --output #{@core_archive}")
    unpacking_with_7zip(@core_archive, "#{StaticData::PROJECT_DIR}/#{File.basename(@url, '.7z')}")
    FileUtils.rm_rf(@core_archive)
    change_core_access
    XmlActions.create_doc_renderer_config(StaticData::CORE_DIR)
    generate_allfonts
  end
end

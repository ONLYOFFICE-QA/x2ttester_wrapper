# frozen_string_literal: true

require_relative 'manager'
require_relative 'config/static_data'

desc 'Download core'
task :core do |_t|
  # @branch = 'develop'
  # @version = 'v99.99.99'
  # @build = '99.99.99.3166'
  @branch = 'release'
  @version = 'v7.3.0'
  @build = 'latest'
  # @build = '7.2.1-53' # The difference in builds for different os
  @arch = Gem::Platform.local.cpu

  case Gem::Platform.local.os
  when 'mingw'
    @os = 'windows'
  when 'linux'
    @os = 'linux'
    @arch = @arch.sub('86_', '')
  when 'darwin'
    @os = 'mac'
    @arch = @arch.sub('arm', 'x')
  else
    p 'Error: definition os'
  end

  @build = @build.sub(/.*\K\./, '-') if @build.include?('99.99.99') & @os.include?('linux')
  url = "https://repo-doc-onlyoffice-com.s3.eu-west-1.amazonaws.com/#{@os}/core/#{@branch}/#{@version}/#{@build}/#{@arch}/core.7z"
  url = "https://s3.eu-west-1.amazonaws.com/repo-doc-onlyoffice-com/#{@os}/core/#{@branch}/#{@build}/#{@arch}/core.7z" if @build.include?('99.99.99')

  result = system("curl #{url} --output #{StaticData::TMP_DIR}/#{File.basename(url)}")

  if result
    File.open("#{StaticData::TMP_DIR}/#{File.basename(url)}", 'rb') do |file|
      SevenZipRuby::Reader.open(file) do |szr|
        szr.extract_all Dir.pwd.to_s
      end
    end

    # Make the x2t utility executable
    FileUtils.chmod('+x', Dir.glob("#{Dir.pwd}/#{File.basename(url, '.7z')}/*")) if @os.include?('linux')
  end

  XmlActions.create_doc_renderer_config(StaticData::PROJECT_BIN_PATH)

  # Generate AllFonts.js
  `#{StaticData::PROJECT_BIN_PATH}/standardtester` if @os.include?('linux') || @os.include?('mac')
  `#{StaticData::PROJECT_BIN_PATH}/standardtester.exe` if @os.include?('windows')
end

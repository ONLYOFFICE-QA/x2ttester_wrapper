# frozen_string_literal: true

require 'rspec'
require_relative '../../../framework/manager_x2ttesting'

describe X2tTesting::CoreUrlGenerator do
  release_version = '0.0.0.000'
  develop_version = '99.99.99.9999'
  hotfix_version = '0.0.1.000'
  core_host_url = 'https://s3.eu-west-1.amazonaws.com'
  host = X2tTesting::HostConfig.new('./tmp').os_specific_configuration
  os = host[:os]
  arch = host[:arch]

  it 'Check generate build' do
    build = Gem::Platform.local.os == 'mingw' ? release_version : '0.0.0-000'
    expect(described_class.new(core_host_url, release_version, os, arch).build).to eq(build)
  end

  it 'Check generate release url' do
    url_generator = described_class.new(core_host_url, release_version, os, arch)
    url = "#{core_host_url}/repo-doc-onlyoffice-com/#{os}/core/release/v0.0.0/#{url_generator.build}/#{arch}/core.7z"
    expect(url_generator.url).to eq(url)
  end

  it 'Check generate hotfix url' do
    url_generator = described_class.new(core_host_url, hotfix_version, os, arch)
    url = "#{core_host_url}/repo-doc-onlyoffice-com/#{os}/core/hotfix/v0.0.1/#{url_generator.build}/#{arch}/core.7z"
    expect(url_generator.url).to eq(url)
  end

  it 'Check generate develop url' do
    url_generator = described_class.new(core_host_url, develop_version, os, arch)
    url = "#{core_host_url}/repo-doc-onlyoffice-com/#{os}/core/develop/#{url_generator.build}/#{arch}/core.7z"
    expect(url_generator.url).to eq(url)
  end
end

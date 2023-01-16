# frozen_string_literal: true

require 'rspec'
require_relative '../../manager'

describe CoreActions do

  before do
    FileUtils.rm_rf(ProjectConfig.core_dir) if Dir.exist?(ProjectConfig.core_dir)
  end

  after do
    FileUtils.rm_rf(ProjectConfig.core_dir) if Dir.exist?(ProjectConfig.core_dir)
  end

  it 'Check generate version on develop' do
    ProjectConfig::CONFIG['version'] = '99.99.99.3247'
    expect(described_class.new.generate_version).to eq('v99.99.99')
  end

  it 'Check generate build on develop' do
    ProjectConfig::CONFIG['version'] = '99.99.99.3247'
    expect(described_class.new.generate_build).to eq('99.99.99-3247')
  end

  it 'Check generate version on release' do
    ProjectConfig::CONFIG['version'] = '7.3.0.53'
    expect(described_class.new.generate_version).to eq('v7.3.0')
  end

  it 'Check generate build on release' do
    ProjectConfig::CONFIG['version'] = '7.3.0.53'
    expect(described_class.new.generate_build).to eq('7.3.0-53')
  end

  it 'Check getting core on release' do
    ProjectConfig::CONFIG['version'] = '7.3.0.142'
    described_class.new.getting_core
    expect(Pathname.new(ProjectConfig.core_dir)).to exist
    expect(Pathname.new(ProjectConfig.core_dir)).to be_directory
    expect(Pathname.new("#{ProjectConfig.core_dir}/core")).not_to exist
    expect(Pathname.new(ProjectConfig.core_dir)).not_to be_empty
  end

  it 'Check getting core on develop' do
    ProjectConfig::CONFIG['version'] = '99.99.99.3247'
    described_class.new.getting_core
    expect(Pathname.new(ProjectConfig.core_dir)).to exist
    expect(Pathname.new(ProjectConfig.core_dir)).to be_directory
    expect(Pathname.new("#{ProjectConfig.core_dir}/core")).not_to exist
    expect(Pathname.new(ProjectConfig.core_dir)).not_to be_empty
  end

  it 'Check getting core on hotfix' do
    ProjectConfig::CONFIG['version'] = '7.2.2.53'
    described_class.new.getting_core
    expect(Pathname.new(ProjectConfig.core_dir)).to exist
    expect(Pathname.new(ProjectConfig.core_dir)).to be_directory
    expect(Pathname.new("#{ProjectConfig.core_dir}/core")).not_to exist
    expect(Pathname.new(ProjectConfig.core_dir)).not_to be_empty
  end
end

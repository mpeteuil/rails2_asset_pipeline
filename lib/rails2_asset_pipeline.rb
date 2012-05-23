require 'rails2_asset_pipeline/version'
require 'sprockets'

module Rails2AssetPipeline
  STATIC_ENVIRONMENTS = ["production", "staging"]

  class << self
    attr_accessor :dynamic_assets_available
  end

  def self.env
    @env || setup
  end

  def self.setup
    @env ||= Sprockets::Environment.new
    @env.append_path 'app/assets/images'
    @env.append_path 'app/assets/javascripts'
    @env.append_path 'app/assets/stylesheets'
    # TODO vendor + lib
    yield @env if block_given?
    @env
  end

  def self.config_ru
    lambda do
      unless STATIC_ENVIRONMENTS.include?(Rails.env)
        Rails2AssetPipeline.dynamic_assets_available = true
        map '/assets' do
          run Rails2AssetPipeline.env
        end
      end
    end
  end
end

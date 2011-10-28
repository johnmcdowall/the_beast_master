require 'rubygems'
require 'yaml'
require 'sinatra'


module TheBeastMasterConfig

  def self.set_environment env
    @env = env.to_s
  end
  
  # Allows accessing config variables from ingest_config.yml like so:
  # IngestConfig[:mongo_dev_server] => 127.0.0.1
  def self.[](key)
    unless @config
      path = File.dirname(__FILE__) + "/../config/the_beast_master_config.yml"
      raw_config = File.read(path)
      @config = symbolize_keys(YAML.load(raw_config)[@env])
    end
    @config[key]
  end
  
  def self.[]=(key, value)
    @config[key.to_sym] = value
  end

  def self.method_missing(m, *args)
    return self[m.to_s.sub(/\?$/, '').to_sym] if m.to_s =~ /\?$/
    super
  end

  # change string keys into symbols
  def self.symbolize_keys(arg)
    case arg
    when Array
      arg.map { |elem| symbolize_keys elem }
    when Hash
      Hash[
        arg.map { |key, value|
          k = key.is_a?(String) ? key.to_sym : key
          v = symbolize_keys value
          [k,v]
        }]
    else
      arg
    end
  end
  
end
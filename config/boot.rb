ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../../Gemfile', __FILE__)

require 'bundler/setup' # Set up gems listed in the Gemfile.
#20160313 portを3003に
require 'rails/commands/server'
module Rails
  class Server
    def default_options
      super.merge({
        :Port => 3003
      })
    end
  end
end
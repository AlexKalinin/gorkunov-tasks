require 'rubygems'
require 'bundler/setup'
Bundler.require

require 'require_all'
require 'byebug'
require 'pry'
require 'logger'

require_all 'src'

# load configuration
$APP_CONFIG = YAML.load_file(File.join(File.dirname(__FILE__), 'config/application.yml'))


logger = Logger.new(STDOUT)
listen_address = $APP_CONFIG['listen_address']
listen_port = $APP_CONFIG['listen_port']
workers_amount = $APP_CONFIG['workers_amount']

logger.info 'Starting program, hello!'
logger.debug "The configuration is: #{$APP_CONFIG.to_s}"

s = Server.instance
s.init listen_address, listen_port, workers_amount
begin
  s.start
rescue Interrupt => e
  logger.info 'MAIN: Waiting for workers stop...'
  s.stop
  logger.info 'MAIN: Server finished. Good Bye!'
end

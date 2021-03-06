require 'rubygems'
require 'bundler/setup'
Bundler.require

require 'require_all'
require 'byebug'
require 'pry'
require 'logger'

require_all 'src'

# load configuration
$APP_ROOT = File.dirname(__FILE__)
$APP_CONFIG = YAML.load_file(File.join($APP_ROOT, 'config/application.yml'))


logger = Logger.new(STDOUT)
listen_address = $APP_CONFIG['listen_address']
listen_port = $APP_CONFIG['listen_port']
workers_amount = $APP_CONFIG['workers_amount']

logger.info '[MAIN]: Starting program, hello!'
logger.debug "[MAIN]: The configuration is: #{$APP_CONFIG}"

s = Server.instance
s.init listen_address, listen_port, workers_amount
begin
  s.start
rescue Interrupt
  logger.info '[MAIN]: Ctrl+C pressed, shutting down server...'
  s.stop
  logger.info '[MAIN]: Server shutdown successfully. Good Bye!'
end

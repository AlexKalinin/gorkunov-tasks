require 'rubygems'
require 'bundler'
Bundler.setup

require 'rake'

require 'require_all'
require 'byebug'
require 'pry'
require 'logger'
require 'pg'
require 'colorize'


require_all 'src'


# load configuration
$APP_ROOT = File.dirname(__FILE__)
$APP_CONFIG = YAML.load_file(File.join($APP_ROOT, 'config/application.yml'))


# $logger = Logger.new(STDOUT)
$logger = AppLogger.new
